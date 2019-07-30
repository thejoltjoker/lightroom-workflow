require 'Globals'
trace('ShutdownApp')

local function shutdownFunction(doneFunction, progressFunction)
    progressFunction(0, 'Shutdown started')

    shutdownPlugin()

    progressFunction(1, 'Shutdown finished')
    doneFunction()
end

return { LrShutdownFunction = shutdownFunction }
