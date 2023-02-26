return {
	LrSdkVersion = 6.0,
	LrSdkMinimumVersion = 6.0,

	LrToolkitIdentifier = 'com.loupedeck.loupedeck2',

	LrPluginName = "Loupedeck2",

  	LrInitPlugin = "InitPlugin.lua",
  	LrShutdownPlugin = "ShutdownPlugin.lua",
  	LrShutdownApp = "ShutdownApp.lua",
  	LrEnablePlugin = "EnablePlugin.lua",
  	LrDisablePlugin = "DisablePlugin.lua",

  	LrForceInitPlugin = true,
    LrPluginInfoUrl = "https://loupedeck.com",

	LrHelpMenuItems =
	{
		{
			title = "Loupedeck &Console Setup...",
			file = "MenuItemConfigure.lua",
		},
		{
			title = "Loupedeck &Plugin Settings...",
			file = "MenuItemSettings.lua",
		},
		{
			title = "&Update Develop Presets List",
			file = "MenuItemClearDevelopPresets.lua",
		},
		{
			title = "Loupedeck &Support",
			file = "MenuItemHelp.lua",
		},
		{
			title = "&About Loupedeck...",
			file = "MenuItemAbout.lua",
		},
	},

	VERSION = { major=5, minor=0, revision=2, build=0 }
}
