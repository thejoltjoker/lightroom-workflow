----------------------------------------------------------------------------------------------------------------------
-- Globals

local function getPluginVersion()
    local infoFilePath = import 'LrPathUtils'.child(_PLUGIN.path, 'Info.lua')
    local infoFileContent = import 'LrFileUtils'.readFile(infoFilePath)
    _, _, major, minor, revision, build  = string.find(infoFileContent, "%s*major%s*=%s*(%d+)%s*,%s*minor%s*=%s*(%d+)%s*,%s*revision%s*=%s*(%d+)%s*,%s*build%s*=%s*(%d+)%s*")
    return { major = major, minor = minor, revision = revision, build = build }
end

plugin =
{
    name = 'Loupedeck2',
    version = getPluginVersion(),

    loggingMode = "",

    running = false,
    shutdown = false,

    prefs = import 'LrPrefs'.prefsForPlugin()
}

-----------------------------------------------------------------------------------------------------------------------
-- Generic

function showBezel(message)
    if plugin.prefs.showBezel then
        import 'LrDialogs'.showBezel(message)
    end
end

----------------------------------------------------------------------------------------------------------------------
-- String functions

function string.startsWith(text, startText)
    return string.sub(text, 1, text.len(startText)) == startText
end

function string.isNullOrEmpty(text)
    return (nul == text) or (''== text)
end

function string.split(text, separator)
    local separator1, separator2 = string.find(text, separator, 1, true)
    local part1 = nil == separator1 and text or string.sub(text, 1, separator1 - 1)
    local part2 = nil == separator1 and nil or string.sub(text, separator2 + 1)
    return part1, part2
end

----------------------------------------------------------------------------------------------------------------------
-- Debug functions

function initLogger(loggingMode) -- "none", "print", "logfile"
    if (loggingMode ~= 'none') and (loggingMode ~= 'print') and (loggingMode ~= 'logfile') then loggingMode = 'none' end
    if plugin.loggingMode == loggingMode then return end
    
    plugin.loggingMode = loggingMode
    plugin.prefs.loggingMode = loggingMode
    
    local logger = import 'LrLogger'(plugin.name)

    if "none" == plugin.loggingMode then
        logger:disable()
    else
        logger:enable(plugin.loggingMode)
        logger:trace("--------------------------------------------------")
        logger:tracef("Loupedeck plugin v%d.%d.%d", plugin.version.major, plugin.version.minor, plugin.version.revision)
    end

    trace = logger:quickf('trace')
end

initLogger(plugin.prefs.loggingMode)

function traceTable(table)
    for key, value in ipairs(table) do
        trace('"' .. tostring(key) .. '"="' .. tostring(value) .. '"')
    end
end

----------------------------------------------------------------------------------------------------------------------
-- Plugin shutdown

function shutdownPlugin()
    trace('Shutdown started')

    if plugin.running then
        -- tell the run loop to exit
        plugin.shutdown = false
        plugin.running = false
        
        trace('Shutdown initialized')
    end

    trace('Shutdown finished')
end
