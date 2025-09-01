-- This is the important stuff for servers

-- Using these settings are recommended to get the best experience for your players that you want
hook.Add("Initialize","AuraDebugUpdateGlobals", function()
	aura_lfs_overhaul_config_cvarDisableAllClient = CreateClientConVar( "lfs_disable_all_overhaul_settings", 0, true, false) -- Can disable everything for a client, don't need to touch this, just for organization
end)

aura_lfs_overhaul_config_ui_color = Color(0,127,255,200)

aura_lfs_overhaul_config_open_menu_command 					= "!lfsConfig" -- Set this to whatever you want the command to be to open the config menu, if you dont want to use this file -- Default: !lfsMenu (Caps does not matter)

-- These next ones are for ALL clients, should these be false, the corrisponding feature will be disabled

aura_lfs_overhaul_config_enable_friendly_name_crosshair		= aura_lfs_overhaul_config_enable_friendly_name_crosshair 	or 		true -- Enables players to see friendly target ship pilot/driver name in crosshair -- Default: True
aura_lfs_overhaul_config_enable_friendly_hp_crosshair		= aura_lfs_overhaul_config_enable_friendly_hp_crosshair 	or 		false -- Enables players to see friendly target ship HP in crosshair -- Default: True
aura_lfs_overhaul_config_enable_HUD						 	= aura_lfs_overhaul_config_enable_HUD 						or 		true -- Enables HUD for all people in vehicles -- Default: True
aura_lfs_overhaul_config_enable_voice_interactions		 	= aura_lfs_overhaul_config_enable_voice_interactions 		or 		false -- Enables voice line interaction for all people in vehicles -- Default: True
aura_lfs_overhaul_config_enable_alerts					 	= aura_lfs_overhaul_config_enable_alerts 					or 		true -- Enables alerts/warnings for all people in vehicles -- Default: True
aura_lfs_overhaul_config_enable_rolling_with_ship			= aura_lfs_overhaul_config_enable_rolling_with_ship 		or 		true -- Enables players camera to roll with vehicle while in it -- Default: True
aura_lfs_overhaul_config_enable_radar					 	= aura_lfs_overhaul_config_enable_radar 					or 		true -- Enables radar for all people in vehicles -- Default: True
aura_lfs_overhaul_config_enable_hp_and_shield				= aura_lfs_overhaul_config_enable_hp_and_shield 			or		true -- Enables health and shield visuals for all people in vehicles -- Default: True
aura_lfs_overhaul_config_enable_hostile_alerts				= aura_lfs_overhaul_config_enable_hostile_alerts 			or 		true -- Enables alerts about number of hostiles targeting player for all people in vehicles -- Default: True

---------------------------------------------------------------------------------------------------------