-- Created By joe.aldred ( http://steamcommunity.com/id/joealdred/ ) --
local CATEGORY_NAME = "Cleanup"

function ulx.delsprays( calling_ply )

	for k, v in pairs(player.GetAll()) do
		v:SendLua([[ LocalPlayer():ConCommand("r_cleardecals") ]])
		v:SendLua([[ LocalPlayer():ConCommand("r_cleardecals") ]])
	end
	ulx.fancyLogAdmin( calling_ply, "#A removed all sprays from the map." )
	
end
local delsprays = ulx.command( CATEGORY_NAME, "ulx delsprays", ulx.delsprays, "!delsprays" )
delsprays:defaultAccess( ULib.ACCESS_ADMIN )
delsprays:help( "Remove all sprays from the map." )
