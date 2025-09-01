JukeBox = {}

if SERVER then
	AddCSLuaFile( "client_base.lua" )
	AddCSLuaFile( "client_player.lua" )
	AddCSLuaFile( "client_hud.lua" )
	AddCSLuaFile( "vgui_base.lua" )
	AddCSLuaFile( "vgui_allsongs.lua" )
	AddCSLuaFile( "vgui_queue.lua" )
	AddCSLuaFile( "vgui_options.lua" )
	AddCSLuaFile( "vgui_request.lua" )
	AddCSLuaFile( "vgui_request_quick.lua" )
	AddCSLuaFile( "vgui_admin_requests.lua" )
	AddCSLuaFile( "vgui_admin_bans.lua" )
	AddCSLuaFile( "vgui_admin_idleplay.lua" )
	AddCSLuaFile( "shared_settings.lua" )
	AddCSLuaFile( "shared_language.lua" )
	
	include( "shared_settings.lua" )
	include( "shared_language.lua" )
	include( "mysql_settings.lua" )
	include( "server_base.lua" )
	include( "server_saving.lua" )
else
	include( "shared_settings.lua" )
	include( "shared_language.lua" )
	include( "client_base.lua" )
	include( "client_player.lua" )
	include( "client_hud.lua" )
	include( "vgui_base.lua" )
	include( "vgui_allsongs.lua" )
	include( "vgui_queue.lua" )
	include( "vgui_options.lua" )
	include( "vgui_request.lua" )
	include( "vgui_request_quick.lua" )
	include( "vgui_admin_requests.lua" )
	include( "vgui_admin_bans.lua" )
	include( "vgui_admin_idleplay.lua" )
end