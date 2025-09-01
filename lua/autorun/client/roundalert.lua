CreateClientConVar( "roundalert_sound", "sound/common/warning.wav", true, false, "This affects the sound played when spawned while minimized." )

net.Receive( "Annoying Beep", function( len, pl )
	if system.HasFocus() then return end
	
	sound.PlayFile( GetConVar( "roundalert_sound" ):GetString(), "", function( alert ) if ( IsValid( alert ) ) then alert:Play() end end )
end )