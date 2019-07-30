local function sendError(messageId, error)
    trace('(%s) %s', messageId, error)

    if '0' == messageId then
        sendEvent("ErrorOccurred", error)
    else
        sendMessage(-messageId, error)
    end
end

function handleMessage(messageId, functionName, functionParams)
    trace('(%s) "%s"="%s"', messageId, functionName, functionParams)
        
    if 'runscript' == functionName then
        -- replace '\\\\n' string with '\\n' string, and '\\n' string with '\n' char
        script = string.gsub(functionParams, '\\\\', '\\')
        count = 1
        while count > 0 do
            script, count = string.gsub(script, '([^\\])\\n', '%1\n')
        end
        trace('Script "%s"', script)

        trace('Loading script')
        local method, error = loadstring(script)
        if nil == method then
            sendError(messageId, 'Cannot load script: ' .. tostring(error))
            return
        end

        trace('Executing script')
        local success, result = import 'LrTasks'.pcall(method)

        if (nil == success) or (not success) then
            sendError(messageId, 'Cannot execute script: ' .. tostring(result))
            return
        end

        trace('Success')

        if messageId ~= '0' then
            if result ~= nil then
                sendMessage(messageId, result)
            else
                sendMessage(messageId, "")
            end
        end
    end
end
