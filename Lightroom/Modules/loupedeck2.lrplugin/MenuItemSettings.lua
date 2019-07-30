require 'Globals'
trace('Settings')

local LrBinding = import "LrBinding"
local LrDialogs = import "LrDialogs"
local LrFunctionContext = import "LrFunctionContext"
local LrHttp = import "LrHttp"
local LrView = import "LrView"

LrFunctionContext.callWithContext('LoupedeckPluginSettings', function(context)

    local properties = LrBinding.makePropertyTable(context)
    properties.showBezel = plugin.prefs.showBezel
    
    local f = LrView.osFactory()

    local contents = f:view {
        f:row {
            spacing = f:control_spacing(),
            f:checkbox {
                title = "Show plugin notifications",
                bind_to_object = properties,
                value = LrView.bind('showBezel'),
            },
        },
        f:row {
            spacing = f:control_spacing(),
            f:static_text {
                title = "Plugin notifications are shown in a window that quickly fades away",
            },
        }
    }

    -- invoke a dialog box
    local result = LrDialogs.presentModalDialog({
        title = "Loupedeck Plugin Settings",
        contents = contents,
        actionVerb = "OK",
    })

    if "ok" == result then
        plugin.prefs.showBezel = properties.showBezel
    end

end )
