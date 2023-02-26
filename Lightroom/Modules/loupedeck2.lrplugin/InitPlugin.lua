local LrApplication = import 'LrApplication'
local LrApplicationView = import 'LrApplicationView'
local LrDevelopController = import 'LrDevelopController'
local LrDialogs = import 'LrDialogs'
local LrFileUtils = import 'LrFileUtils'
local LrFunctionContext = import "LrFunctionContext"
local LrPathUtils = import 'LrPathUtils'
local LrSocket = import "LrSocket"
local LrTasks = import "LrTasks"

--local LrLogger = import 'LrLogger'
--local logger = LrLogger('LoupedeckPlugin2')
--logger:enable("logfile")
--logger:trace('0')

----------------------------------------------------------------------------------------------------------------------

require 'Globals'

-- set preferences defaults at first run
if nil == plugin.prefs.showBezel then plugin.prefs.showBezel = true end

trace('InitPlugin')

----------------------------------------------------------------------------------------------------------------------

local function writePortToFile(port, index)
    local portFilePath = LrPathUtils.addExtension(_PLUGIN.id, 'port' .. index)
    trace(portFilePath)
    portFilePath = LrPathUtils.child(LrPathUtils.getStandardFilePath('temp'), portFilePath)
    trace(portFilePath)

    trace(portFilePath)
    local file = io.open(portFilePath, 'w+')
    if file ~= nil then
        file:write(tostring(port))
        file:close()
    end

    return portFilePath
end

----------------------------------------------------------------------------------------------------------------------

local sender
local senderPort = 0
local senderConnected = false
local senderPortFilePath
local senderShutdown = false

local function createSenderSocket(context)

    trace("Creating sender socket")

    sender = LrSocket.bind
    {
        functionContext = context,
        port = 0,
        mode = "send",
        plugin = _PLUGIN,

        onConnecting = function(socket, port)
            trace('Sender socket connecting: ' .. port)
            senderPort = port

            senderPortFilePath = writePortToFile(senderPort, '2')
        end,

        onConnected = function(socket, port)
            trace('Sender socket connected: ' .. port)
            senderConnected = true
        end,

        onClosed = function(socket)
            trace('Sender socket closed: ' .. senderPort)
            senderConnected = false

            if receiverShutdown then
                LrFileUtils.delete(senderPortFilePath)
            end
        end,

        onError = function(socket, err)
            trace('Sender socket %d error: %s', senderPort, err)
            senderConnected = false

            if senderShutdown then
                trace('Sender socket is shut down: ' .. senderPort)
                return
            end

            if string.sub(err, 1, string.len("failed to open")) == "failed to open" then
                LrDialogs.showError("Loupedeck needs access to tcp ports, but failed to make a connection.")
                return
            end

            socket:reconnect()
        end,
    }

    return sender
end

function sendMessage(messageId, message)
    LrTasks.startAsyncTaskWithoutErrorHandler(function ()
        trace('Sending message "%s": "%s"', messageId, message)
        sender:send(messageId .. '|' .. message .. '\n')
        trace('Sent')
    end, 'sendMessage')
end

function sendEvent(eventName, eventParameter)
    sendMessage("0", eventName .. '|' .. eventParameter)
end

----------------------------------------------------------------------------------------------------------------------

local receiverPort = 0
local receiverConnected = false
local receiverPortFilePath
local receiverShutdown = false

require 'Messages'
require 'Library'

local function createReceiverSocket(context)

    trace('Creating receiver socket')

    local receiver = LrSocket.bind
    {
        functionContext = context,
        port = 0,
        mode = "receive",
        plugin = _PLUGIN,

        onConnecting = function(socket, port)
            trace('Receiver socket connecting: ' .. port)
            receiverPort = port

            receiverPortFilePath = writePortToFile(receiverPort, '1')
        end,

        onConnected = function(socket, port)
            trace('Receiver socket connected: ' .. port)
            receiverConnected = true

            createSenderSocket(context)
        end,

        onClosed = function(socket)
            trace('Receiver socket closed: ' .. receiverPort)
            receiverConnected = false

            sender:close()

            if receiverShutdown then
                LrFileUtils.delete(receiverPortFilePath)
            else
                socket:reconnect()
            end
        end,

        onError = function(socket, err)
            if receiverShutdown then
                trace('Receiver socket is shut down: ' .. receiverPort)
                return
            end

            receiverConnected = false

            trace('Receiver socket %d error: %s', receiverPort, err)

            if string.sub(err, 1, string.len("failed to open")) == "failed to open" then
                LrDialogs.showError("Loupedeck needs access to tcp ports, but failed to make a connection.")
                return
            end

            socket:reconnect()
        end,

        onMessage = function(socket, message)
            if type(message) ~= "string" then
                trace('Receiver socket message type ' .. type(message))
            end

            local messageId, message = string.split(message, '|')
            local functionName, functionParams = string.split(message, '|')

            trace('Function "%s(%s)"', functionName, functionParams)
            if 'ping' == functionName then
                return
            elseif 'handshake' == functionName then
                sendMessage(messageId, 'ok')
                return
            elseif 'getlogging' == functionName then
                sendMessage(messageId, plugin.loggingMode)
            elseif 'setlogging' == functionName then
                initLogger(functionParams)
            else
                LrTasks.startAsyncTaskWithoutErrorHandler(function ()
                    handleMessage(messageId, functionName, functionParams)
                end, 'handleMessage')
            end
        end,
    }

    return receiver
end

----------------------------------------------------------------------------------------------------------------------

LrTasks.startAsyncTask(function()
    
    LrFunctionContext.callWithContext('loupedeck2', function(context)

        local version = LrApplication.versionTable()
        if version['major'] < 7 then
            trace('Not initializing plugin for Lightroom version ' .. LrApplication.versionString())
            return
        end

        trace('Starting sockets')

        local receiver = createReceiverSocket(context)

        local currentModule = LrApplicationView.getCurrentModuleName()
        local currentTool = ''
        if 'develop' == currentModule then
            currentTool = LrDevelopController.getSelectedTool()
        end

        plugin.running = true
        while plugin.running do
            local newModule = LrApplicationView.getCurrentModuleName()
            if newModule ~= currentModule then
                currentModule = newModule
                if senderConnected then
                    sendEvent("ModuleChanged", currentModule)
                end
            end

            if 'develop' == currentModule then
                local newTool = LrDevelopController.getSelectedTool()
                if newTool ~= currentTool then
                    currentTool = newTool
                    if senderConnected then
                        sendEvent("DevelopToolChanged", currentTool)
                    end
                    if newTool == "masking" then
                        startMaskingUpdater()
                    end
                end
            else
                currentTool = ''
            end
            LrTasks.sleep(0.25) -- 250ms
        end

        trace('Stopping sockets')
    
        receiverShutdown = true
        senderShutdown = true

        if receiverConnected then
            receiver:close()
        end

        trace('Stopped sockets')

        plugin.shutdown = true

    end)

end)

local json2 = require("Json2")

local previousMasks = ""
local selectedMaskId = ""
local selectedMaskToolId = ""

function startMaskingUpdater()

    LrTasks.startAsyncTask(function()

        LrFunctionContext.callWithContext('loupedeck2', function(context)

            if senderConnected then
                sendEvent('MasksChanged', json2:encode(LrDevelopController.getAllMasks()))
            end

            while LrDevelopController.getSelectedTool() == 'masking' do
                checkMasksAndCallEvents()            
                LrTasks.sleep(1)
            end

            previousMasks = nil
            selectedMaskId = nil
            selectedMaskToolId = nil

        end)
        
    end)

end

function checkMasksAndCallEvents()

    local currentMasks = json2:encode(LrDevelopController.getAllMasks()) 
    if currentMasks == nil then currentMasks = "" end
    if currentMasks ~= previousMasks then
        previousMasks = currentMasks
        if senderConnected then
            sendEvent('MasksChanged', currentMasks)
        end
    end

    local newMaskId = LrDevelopController.getSelectedMask()
    if newMaskId == nil then newMaskId = "" end
    if selectedMaskId ~= newMaskId then
        selectedMaskId = newMaskId
        if senderConnected then
            sendEvent('SelectedMaskChanged', tostring(newMaskId)) 
        end
    end

    local newMaskToolId = LrDevelopController.getSelectedMaskTool() 
    if newMaskToolId == nil then newMaskToolId = "" end
    if selectedMaskToolId ~= newMaskToolId then
        selectedMaskToolId = newMaskToolId
        if senderConnected then
            sendEvent('SelectedMaskToolChanged', tostring(selectedMaskToolId)) 
        end
    end

end
