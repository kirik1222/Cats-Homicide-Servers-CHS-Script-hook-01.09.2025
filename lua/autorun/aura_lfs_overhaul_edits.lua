local cvarVolume = GetConVar("lfs_volume")
local cvarCamFocus = GetConVar("lfs_camerafocus")
local cvarShowPlaneIdent = GetConVar("lfs_show_identifier")
local cvarShowNameIndc = CreateClientConVar( "lfs_show_nameindc", 1, true, false)
local cvarShowHPIndc = CreateClientConVar( "lfs_show_hpindc", 1, true, false)
local cvarShowHud = CreateClientConVar( "lfs_show_hud", 1, true, false)
local cvarVoiceIndecs = CreateClientConVar( "lfs_voice_indicators", 1, true, false)
local cvarAlertIndecs = CreateClientConVar( "lfs_alert_indicators", 1, true, false)
local cvarRollWithShip = CreateClientConVar( "lfs_roll_with_ship", 0, true, false)
local cvarEnableRadar = CreateClientConVar( "lfs_enable_radar", 1, true, false)
local cvarEnableHpShield = CreateClientConVar( "lfs_enable_hp_shield", 1, true, false)
local cvarShowHostileAlert = CreateClientConVar( "lfs_enable_hostile_alert", 1, true, false)

----------
local cvarDisabledDamageChanges = CreateConVar("lfs_disable_damage_changes",0,{16384, 32, 128})
local cvarDisabledAdminNotify = CreateConVar("lfs_disable_admin_notify",0,{16384, 32, 128})
local cvarDisabledAdminNotifyAI = CreateConVar("lfs_disable_admin_notify_ai",0,{16384, 32, 128})

----------

local ShowPlaneIdent = cvarShowPlaneIdent and cvarShowPlaneIdent:GetBool() or true
local ShowNameIndc = aura_lfs_overhaul_config_enable_friendly_name_crosshair and cvarShowNameIndc and cvarShowNameIndc:GetBool() or false
local ShowHPIndc = aura_lfs_overhaul_config_enable_friendly_hp_crosshair and cvarShowHPIndc and cvarShowHPIndc:GetBool() or false
local ShowHUD = aura_lfs_overhaul_config_enable_HUD and cvarShowHud and cvarShowHud:GetBool() or false
local VoiceActivate = aura_lfs_overhaul_config_enable_voice_interactions and cvarVoiceIndecs and cvarVoiceIndecs:GetBool() or false
local ShowAlerts = aura_lfs_overhaul_config_enable_alerts and cvarAlertIndecs and cvarAlertIndecs:GetBool() or false
local AllowRollWithShip = aura_lfs_overhaul_config_enable_rolling_with_ship and cvarRollWithShip and cvarRollWithShip:GetBool() or false
local EnableRadar = aura_lfs_overhaul_config_enable_radar and cvarEnableRadar and cvarEnableRadar:GetBool() or false
local ShowHPAndShield = aura_lfs_overhaul_config_enable_hp_and_shield and cvarEnableHpShield and cvarEnableHpShield:GetBool() or false
local EnableHostileAlert = aura_lfs_overhaul_config_enable_hostile_alerts and cvarShowHostileAlert and cvarShowHostileAlert:GetBool() or false

local radarMat
local randomSoundList = {}

if (SERVER) then
	util.AddNetworkString("Aura_LFS_Open_Config_From_Server_Admin")
	util.AddNetworkString("Aura_LFS_Toggle_Damage_Reduction")
	util.AddNetworkString("Aura_LFS_Toggle_Admin_Notify")
	util.AddNetworkString("Aura_LFS_Toggle_Admin_Notify_AI_Only")

	hook.Add("PlayerSay", "AuraLFSConfigOpenConfigMenu", function( ply, text )
		if (string.lower(text) == string.lower(aura_lfs_overhaul_config_open_menu_command)) then
			net.Start("Aura_LFS_Open_Config_From_Server_Admin")
			net.Send(ply)
		end
	end)

	hook.Add("Initialize","AuraInitLFSVoiceInteractions", function()
	    print("Aura LFS interface edits has been initalized!")
	end)

	hook.Add( "CanEditVariable", "aura_restrict_lfs_ai_edit", function( ent, ply, key, val, editor )
		if (GetConVar("lfs_disable_admin_notify"):GetBool()) then return end
		if (!ent.LFS) then return end
		if (ply:IsAdmin() or ply:IsSuperAdmin()) then return end

		local playerList = player.GetAll()

		local var = editor.title
		local t = editor.type
		ply.aura_lfs_var_currentVal = val
		if (GetConVar("lfs_disable_admin_notify_ai"):GetBool()) then
			if var != "AI" then return end
		end

		for i=1, #playerList do
			if (ply:IsAdmin() or ply:IsSuperAdmin()) then
				if (!ply.isOnAuraChatAlertCoolDown) then
					ply.isOnAuraChatAlertCoolDown = true
					ply.aura_lfs_last_val_changed = val
					local time = .25
					if (t != "Boolean") then
						time = 3
					end
					timer.Simple(time, function()
						if (IsValid(ply)) then
							if (IsValid(ent)) then
								if (ply.aura_lfs_last_val_changed != ply.aura_lfs_var_currentVal or (t == "Boolean")) then
									playerList[i]:ChatPrint(ply:Nick() .. " has just set var: " .. var .. " to value " .. ply.aura_lfs_var_currentVal .. " on an LFS vehicle")
								end
							end
							ply.isOnAuraChatAlertCoolDown = false
						end
					end)
				end
			end
		end
	end )
end

if CLIENT then
	function AuraLFSChangeConfig_HostileAlert(new)
		aura_lfs_overhaul_config_enable_hostile_alerts = new
	end

	function AuraLFSChangeConfig_HPShield(new)
		aura_lfs_overhaul_config_enable_hp_and_shield = new
	end

	function AuraLFSChangeConfig_Radar(new)
		aura_lfs_overhaul_config_enable_radar = new
	end

	function AuraLFSChangeConfig_Names(new)
		aura_lfs_overhaul_config_enable_friendly_name_crosshair = new
	end

	function AuraLFSChangeConfig_HP(new)
		aura_lfs_overhaul_config_enable_friendly_hp_crosshair = new
	end

	function AuraLFSChangeConfig_HUD(new)
		aura_lfs_overhaul_config_enable_HUD = new
	end

	function AuraLFSChangeConfig_Alerts(new)
		aura_lfs_overhaul_config_enable_alerts = new
	end

	function AuraLFSChangeConfig_VoiceInteractions(new)
		aura_lfs_overhaul_config_enable_voice_interactions = new
	end

	function AuraLFSChangeConfig_Rolling(new)
		aura_lfs_overhaul_config_enable_rolling_with_ship = new
	end

	local propertiesMenuClient = 
	{
		[1] = {name = "Enable Hostile Alert", desc = "Show # of hostiles targeting you in alerts", convar = "lfs_enable_hostile_alert", func = AuraLFSChangeConfig_HostileAlert},
		[2] = {name = "Enable HP/Shield", desc = "See HP and shield bars / values", convar = "lfs_enable_hp_shield", func = AuraLFSChangeConfig_HPShield},
		[3] = {name = "Enable Radar", desc = "See small scale ships in HUD", convar = "lfs_enable_radar", func = AuraLFSChangeConfig_Radar},
		[4] = {name = "Show Names", desc = "See names of friendly vehicle pilots on your crosshair", convar = "lfs_show_nameindc", func = AuraLFSChangeConfig_Names},
		[5] = {name = "Show HP", desc = "See HP of friendly vehicle pilots on your crosshair", convar = "lfs_show_hpindc", func = AuraLFSChangeConfig_HP},
		[6] = {name = "Show HUD", desc = "Enables all HUD based elements,\nsuch as throttle meter, altitude meter, and pitch scroller", convar = "lfs_show_hud", size = 30, func = AuraLFSChangeConfig_HUD},
		[7] = {name = "Show Alerts", desc = "Display important alerts on HUD, not\nlinked with HUD (Most FPS impact)", convar = "lfs_alert_indicators", size = 30, func = AuraLFSChangeConfig_Alerts},
		[8] = {name = "Voice Alerts", desc = "Enable voice indicators for some events", convar = "lfs_voice_indicators", func = AuraLFSChangeConfig_VoiceInteractions},
		[9] = {name = "Roll with ship", desc = "Allow camera to roll with vehicle roll", convar = "lfs_roll_with_ship", func = AuraLFSChangeConfig_Rolling},
	}

	local greenCol = Color(75,255,59, 255)
	local whiteCol = Color(200,200,200,255)

	local adminMat = Material( "icon16/shield.png" )
	radarMat = Material( "sprites/radar_base.png" )
	local NextFind = 0
	local AllPlanes = {}
	randomSoundList = {
		"npc/attack_helicopter/aheli_damaged_alarm1.wav",
	}

	local alertString = ""
	local alertNum = 0
	local boxX = 100
	local currWidth = 0
	local boxY = 100
	--local radarRotator = 0
	surface.CreateFont( "AURA_LFS_FONT", {
		font = "DebugFixed",
		extended = false,
		size = 20,
		weight = 1000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = true,
		outline = false,
	} )

	surface.CreateFont( "AURA_LFS_FONT_PANEL", {
		font = "Arial",
		extended = false,
		size = 16,
		weight = 1000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = true,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont( "LFS_FONT_RADAR_HEIGHT", {
		font = "Arial",
		extended = false,
		size = 25,
		weight = 1000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

 	local function LFSAuraContactNotify( ent )
 		if GetConVar("lfs_disable_all_overhaul_settings"):GetBool() then return end
		if !IsValid(ent) or ent == nil then return end
		if not ShowPlaneIdent then return end

		if (ent.aura_lfs_initalActivation == nil) then
			ent:EmitSound( Sound("HL1/fvox/voice_on.wav"), 155, 100, 1, CHAN_AUTO )
			ent.aura_lfs_initalActivation = false
		end

		if (ent.aura_lfs_notify_contacts == nil or ent.aura_lfs_speak_cooldown == nil) then
			ent.aura_lfs_speak_cooldown = false
			ent.aura_lfs_notify_contacts = {}
		end
		if NextFind < CurTime() then
			NextFind = CurTime() + 3
			AllPlanes = simfphys.LFS:PlanesGetAll()
		end
		ShowNameIndc = aura_lfs_overhaul_config_enable_friendly_name_crosshair and cvarShowNameIndc and cvarShowNameIndc:GetBool() or false
		ShowHPIndc = aura_lfs_overhaul_config_enable_friendly_hp_crosshair and cvarShowHPIndc and cvarShowHPIndc:GetBool() or false
		ShowHUD = aura_lfs_overhaul_config_enable_HUD and cvarShowHud and cvarShowHud:GetBool() or false
		VoiceActivate = aura_lfs_overhaul_config_enable_voice_interactions and cvarVoiceIndecs and cvarVoiceIndecs:GetBool() or false
		ShowAlerts = aura_lfs_overhaul_config_enable_alerts and cvarAlertIndecs and cvarAlertIndecs:GetBool() or false
		AllowRollWithShip = aura_lfs_overhaul_config_enable_rolling_with_ship and cvarRollWithShip and cvarRollWithShip:GetBool() or false
		EnableRadar = aura_lfs_overhaul_config_enable_radar and cvarEnableRadar and cvarEnableRadar:GetBool() or false
		ShowHPAndShield = aura_lfs_overhaul_config_enable_hp_and_shield and cvarEnableHpShield and cvarEnableHpShield:GetBool() or false
		EnableHostileAlert = aura_lfs_overhaul_config_enable_hostile_alerts and cvarShowHostileAlert and cvarShowHostileAlert:GetBool() or false
		 
		local MyPos = ent:GetPos()
		local MyTeam = ent:GetAITEAM()

		-- Lets initalize some vars!

		if (ent.aura_lfs_shield_alert == nil or ent.aura_lfs_shield_charging == nil or ent.aura_lfs_ammoNotifyPrimary == nil or ent.aura_lfs_ammoNotifySecondary == nil or ent.aura_lfs_healthCritialNotify == nil or ent.aura_lfs_health_0_notify == nil) then
			ent.aura_lfs_shield_alert = true
			ent.aura_lfs_shield_charging = true
			ent.aura_lfs_ammoNotifyPrimary = true
			ent.aura_lfs_ammoNotifySecondary = true
			ent.aura_lfs_healthCritialNotify = true
			ent.aura_lfs_health_0_notify = true
		end

		----------------------------

		-- SHIELD NOTIFICATIONS
		if (ent:GetShield() == 0 and ent.aura_lfs_shield_charging and ent.MaxShield != 0) then
			ent.aura_lfs_shield_alert = false
			if (VoiceActivate) then
				ent:EmitSound( Sound("HL1/fvox/armor_gone.wav"), 155, 100, 1, CHAN_AUTO )
			end
			ent.aura_lfs_shield_charging = false
			ent.aura_lfs_shield_text = true
		end

		if (!ent.aura_lfs_shield_alert) then
			if (ent:GetShield() == ent.MaxShield) then
				if (VoiceActivate) then
					ent:EmitSound( Sound("HL1/fvox/power_restored.wav"), 150, 100, 1, CHAN_AUTO )
				end
				ent.aura_lfs_shield_alert = true
			end
			if (ent:GetShield() > 0 and !ent.aura_lfs_shield_charging) then
				ent.aura_lfs_shield_charging = true
				ent.aura_lfs_shield_text = false
			end
		end

		----------------------------

		-- AMMO NOTIFICATIONS

		if (ent:GetAmmoPrimary() == 0 and ent.aura_lfs_ammoNotifyPrimary) then
			ent.aura_lfs_ammoNotifyPrimary = false
			ent.aura_lfs_ammoPrimary_text = true
			if (VoiceActivate) then
				ent:EmitSound( Sound("HL1/fvox/ammo_depleted.wav"), 155, 100, 1, CHAN_AUTO )
			end
		end

		if (!ent.aura_lfs_ammoNotifyPrimary) then
			if (ent:GetAmmoPrimary() > 0) then
				if (VoiceActivate) then
					ent:EmitSound( Sound("items/ammo_pickup.wav"), 150, 100, 1, CHAN_AUTO )
				end
				ent.aura_lfs_ammoNotifyPrimary = true
				ent.aura_lfs_ammoPrimary_text = false
			end
		end

		if (ent:GetAmmoSecondary() == 0 and ent.aura_lfs_ammoNotifySecondary) then
			ent.aura_lfs_ammoNotifySecondary = false
			ent.aura_lfs_ammoSecondary_text = true
			if (VoiceActivate) then
				ent:EmitSound( Sound("HL1/fvox/ammo_depleted.wav"), 155, 100, 1, CHAN_AUTO )
			end
		end

		if (!ent.aura_lfs_ammoNotifySecondary) then
			if (ent:GetAmmoSecondary() > 0) then
				if (VoiceActivate) then
					ent:EmitSound( Sound("items/ammo_pickup.wav"), 150, 100, 1, CHAN_AUTO )
				end
				ent.aura_lfs_ammoNotifySecondary = true
				ent.aura_lfs_ammoSecondary_text = false
			end
		end

		----------------------------

		-- HEALTH NOTIFICATIONS

		if (ent:GetHP() <= ent:GetMaxHP() / 2 and ent.aura_lfs_healthCritialNotify) then
			if (VoiceActivate) then
				ent:EmitSound( Sound("HL1/fvox/health_dropping.wav"), 155, 100, 1, CHAN_AUTO )
			end
			ent.aura_lfs_health_text = true
			timer.Simple(3.5, function()
				if (IsValid(ent)) then
					local hpPercent = math.Round(math.Remap(ent:GetHP(),0,ent:GetMaxHP(),0,100) / 10) * 10
					local sound = "HL1/fvox/fifty.wav"
					local vol = 1
					if (VoiceActivate) then
						if (hpPercent <= 40) then
							sound = "HL1/fvox/fourty.wav"
							vol = .8
						end
						if (hpPercent <= 30) then
							sound = "HL1/fvox/thirty.wav"
						end
						if (hpPercent <= 20) then
							sound = "HL1/fvox/twenty.wav"
						end
						if (hpPercent <= 10) then
							sound = "HL1/fvox/ten.wav"
						end
						if (hpPercent > 40 and hpPercent < 50) then
							sound = "HL1/fvox/fifty.wav"
						end
						ent:EmitSound( Sound(sound), 155, 100, vol, CHAN_AUTO )
						timer.Simple(1, function()
							if (IsValid(ent)) then
								ent:EmitSound( Sound("HL1/fvox/percent.wav"), 155, 100, 1, CHAN_AUTO )
							end
						end)
					end
				end
			end)
			ent.aura_lfs_healthCritialNotify = false
		end

		if (!ent.aura_lfs_healthCritialNotify) then
			if (ent:GetHP() > ent:GetMaxHP() / 2) then
				if (VoiceActivate) then
					ent:EmitSound( Sound("HL1/fvox/medical_repaired.wav"), 150, 100, 1, CHAN_AUTO )
				end
				ent.aura_lfs_healthCritialNotify = true
				ent.aura_lfs_health_text = false
			end
		end

		if (ent:GetHP() == 0 and ent.aura_lfs_health_0_notify) then
			if (VoiceActivate) then
				ent:EmitSound( Sound("HL1/fvox/health_critical.wav"), 155, 100, 1, CHAN_AUTO )
				timer.Simple(3.5, function()
					if (IsValid(ent)) then
						ent:EmitSound( Sound("HL1/fvox/evacuate_area.wav"), 155, 100, 1, CHAN_AUTO )
					end
				end)
			end
			ent.aura_lfs_health_0_notify = false
		end

		if (!ent.aura_lfs_health_0_notify) then
			if (ent:GetHP() > 0) then
				ent.aura_lfs_health_0_notify = true
			end
		end

		-- Crosshair changes
		for _, v in pairs( AllPlanes ) do
			if IsValid( v ) then
				if v ~= ent then
					if isvector( v.SeatPos ) then
						local rPos = v:LocalToWorld( v.SeatPos )
						
						--if Me:IsLineOfSightClear( rPos ) then
						local Pos = rPos:ToScreen()
						local Size = 60
						local Dist = (MyPos - rPos):Length()
						if (v:GetAITEAM() != MyTeam) then
							if (v:GetEngineActive()) then
								if (!table.HasValue(ent.aura_lfs_notify_contacts,v)) then
									table.insert(ent.aura_lfs_notify_contacts,v)
									if (!ent.aura_lfs_speak_cooldown) then
										local s = Sound( randomSoundList[math.random(1,#randomSoundList)] )
										ent:EmitSound( s, 75, 150, 1, CHAN_AUTO )
										ent.aura_lfs_speak_cooldown = true
										timer.Simple(3, function()
											if (IsValid(ent)) then
												ent.aura_lfs_speak_cooldown = false
											end
										end)
									end
								end
							end
						end

						if Dist < 13000 then
							local Alpha = math.max(255 - Dist * 0.015,0) 
							local Team = v:GetAITEAM()
							surface.SetDrawColor(0, 127, 255, Alpha)
							if Team == 0 then
								surface.SetDrawColor( 255, 150, 0, Alpha )
								surface.SetMaterial(Material("sprites/team_0_square.png"))
							else
								if Team ~= MyTeam then
									surface.SetMaterial(Material("sprites/hostile_square.png"))
									surface.SetDrawColor( 255, 0, 0, Alpha )
								else
									surface.SetMaterial(Material("sprites/friendly_square.png"))
									local yPos = 1
									if (ShowNameIndc) then
										if (v:GetDriver()) then
											surface.SetFont( "LFS_FONT" )
											surface.SetTextColor( 0, 127, 255, Alpha )
											surface.SetTextPos( Pos.x + Size * 1.1, Pos.y - Size ) 
											if (v:GetDriver():IsPlayer()) then
							    				surface.DrawText(v:GetDriver():Nick())
							    			else
							    				if (v:GetAI()) then
							    					surface.DrawText("Automated Flight System")
							    				end
							    			end
							    			yPos = yPos - .5
							    		end
							    		if (v.lfsRepairDroid) then
					    					surface.DrawText("Repair Droid")
					    				end
							    	end
							    	if (ShowHPIndc) then
							    		if (v:GetDriver()) then
											surface.SetFont( "LFS_FONT" )
											surface.SetTextPos( Pos.x + Size * 1.1, Pos.y - Size * yPos ) 

											if (v:GetDriver():IsPlayer()) then
						    					local hp = math.Round(v:GetHP(),0)
						    					surface.DrawText("HP: " .. hp .. "/" .. v:GetMaxHP())
							    			else
							    				if (v:GetAI()) then
							    					local hp = math.Round(v:GetHP(),0)
							    					surface.DrawText("HP: " .. hp .. "/" .. v:GetMaxHP())
							    				end
							    			end
							    			yPos = yPos - .5
							    		end
							    	end
								end
							end

							local tr = util.TraceLine( {
								start = ent:GetPos(),
								endpos = ent:GetPos() + ent:GetForward() * 13000,
								filter =  {ent, Entity(0)}
							} )
							if (v == tr.Entity) then
								local dist = ent:GetPos():Distance(v:GetPos())
								local actualDist = math.Round(dist / 39.37,1)
								draw.DrawText(actualDist .. "m","LFS_FONT",Pos.x - Size - 5,Pos.y + Size - draw.GetFontHeight("LFS_FONT"),(Team == MyTeam and Color(0,127,255,Alpha)) or (Team == 0 and Color( 255, 150, 0, Alpha )) or Color( 255, 0, 0, Alpha ),TEXT_ALIGN_RIGHT)
								surface.DrawTexturedRectRotated( Pos.x, Pos.y, Size * 2 , Size * 2, CurTime() * 75)
							end
						end
					end
				end
			end
		end
		-----------------------------------
	end

	function Aura_LFS_ToMeters(num)
		return math.Round(num / 39.37,3)
	end

	local function DrawAltitudeMeter(ply, ent)
		if (true) then
			local altitudePos = Vector(225,-350,0)
            local altW = 30
			local altH = 200

			local trFromShip = util.TraceLine( {
				start = ent:GetPos(),
				endpos = ent:GetPos() + Vector(0,0,-1000000000),
				filter = function( e ) if ( e == Entity(0) ) then return false end end
			} )

			local trFromGround = util.TraceLine( {
				start = trFromShip.HitPos,
				endpos = trFromShip.HitPos + Vector(0,0,1000000000),
				filter = function( e ) if ( e != Entity(0) ) then return false end end
			} )

			local height = ent:GetPos().z - trFromShip.HitPos.z

			local max = trFromGround.HitPos.z - trFromShip.HitPos.z

			local scaledAlt = (height / (max / altH))

			surface.SetDrawColor(aura_lfs_overhaul_config_ui_color)
			surface.SetMaterial(Material("sprites/altitude_meter.png"))
			surface.DrawTexturedRect(altitudePos.x,altitudePos.y,altW,altH)

			local matSize = 20

			surface.SetMaterial(Material("sprites/altitude_triangle.png"))
			local realY = altitudePos.y - scaledAlt + altH - matSize / 2
			surface.SetTextPos(altitudePos.x + altW + 30,realY)

			surface.SetTextColor(aura_lfs_overhaul_config_ui_color)
			surface.SetFont("AURA_LFS_FONT")
			surface.DrawText("ALT: " .. Aura_LFS_ToMeters(height) .. "m")
			surface.DrawTexturedRect(altitudePos.x + altW, realY,matSize,matSize)
		end
	end

	local function DrawThrottleMeter(ply, ent)
		if (true) then
			local throttlePos = Vector(-250,-350,0)
			local throttleW = 30
			local throttleH = 200

			surface.SetDrawColor(aura_lfs_overhaul_config_ui_color)
			surface.SetMaterial(Material("sprites/pitch_meter.png"))
			surface.DrawTexturedRect(throttlePos.x,throttlePos.y,throttleW,throttleH)

			local matSize = 20
			local throttle = ent:GetThrottlePercent()
			local posThrot = throttle
			if (throttle > 100) then
				posThrot = 100
			end
			local realThrottle = throttlePos.y - (posThrot / (100 / throttleH)) + throttleH - matSize / 2

			surface.SetMaterial(Material("sprites/pitch_triangle.png"))
	
			draw.DrawText("THROTTLE: " .. throttle .. "%","AURA_LFS_FONT",throttlePos.x - throttleW,realThrottle,throttle <= 100 and aura_lfs_overhaul_config_ui_color or Color(255,0,0,255),TEXT_ALIGN_RIGHT)
			surface.DrawTexturedRect(throttlePos.x - matSize, realThrottle,matSize,matSize)
		end
	end

	local function DrawAmmoMeter(ply, ent)
		if (true) then
			local primaryAmmoPos = Vector(-250,-380,0)

			draw.DrawText("AMMO PRI: " .. ent:GetAmmoPrimary(),"AURA_LFS_FONT",primaryAmmoPos.x,primaryAmmoPos.y,aura_lfs_overhaul_config_ui_color,TEXT_ALIGN_LEFT)

			local secondaryAmmoPos = Vector(255,-380,0)
			draw.DrawText("AMMO SEC: " .. ent:GetAmmoSecondary(),"AURA_LFS_FONT",secondaryAmmoPos.x,secondaryAmmoPos.y,aura_lfs_overhaul_config_ui_color,TEXT_ALIGN_RIGHT)
		end
	end

	local function DrawPitchScroller(ply, ent)
		if (true) then

			local pitchBarPos = Vector(0,-350,0)
			local ang = ent:GetAngles()

			if (ang.x >= -20 and ang.x <= 20) then
				local p = (pitchBarPos.y - ang.x * 16) + 100
				surface.SetDrawColor(aura_lfs_overhaul_config_ui_color)
				draw.DrawText("0°","AURA_LFS_FONT",pitchBarPos.x - 100,p - 25,aura_lfs_overhaul_config_ui_color,TEXT_ALIGN_RIGHT)
				draw.DrawText("0°","AURA_LFS_FONT",pitchBarPos.x + 100,p - 25,aura_lfs_overhaul_config_ui_color,TEXT_ALIGN_RIGHT)
				surface.DrawRect(pitchBarPos.x - 150,p,100,3)
				surface.DrawRect(pitchBarPos.x + 50,p,100,3)

				surface.DrawRect(pitchBarPos.x - 75,p + 50,50,3)
				surface.DrawRect(pitchBarPos.x + 25,p + 50,50,3)

				surface.DrawRect(pitchBarPos.x - 75,p - 50,50,3)
				surface.DrawRect(pitchBarPos.x + 25,p - 50,50,3)
			end

			if !((ang.x >= -20 and ang.x <= 20)) then
				local p = (pitchBarPos.y - ang.x * 16) + 100
				local txt = "20"
				surface.SetDrawColor(aura_lfs_overhaul_config_ui_color)
				if (ang.x < -20 and ang.x > -60) then
					txt = "40"
					p = (pitchBarPos.y - (ang.x + 40) * 16) + 100
				elseif (ang.x <= -60) then
					txt = "80"
					p = (pitchBarPos.y - (ang.x + 80) * 16) + 100
				end
				if (ang.x > 20 and ang.x <= 60) then
					txt = "-40"
					p = (pitchBarPos.y - (ang.x - 40) * 16) + 100
				elseif (ang.x > 60) then
					txt = "-80"
					p = (pitchBarPos.y - (ang.x - 80) * 16) + 100
				end

				draw.DrawText(txt .. "°","AURA_LFS_FONT",pitchBarPos.x - 100,p - 25,aura_lfs_overhaul_config_ui_color,TEXT_ALIGN_RIGHT)
				draw.DrawText(txt .. "°","AURA_LFS_FONT",pitchBarPos.x + 100,p - 25,aura_lfs_overhaul_config_ui_color,TEXT_ALIGN_RIGHT)
				surface.DrawRect(pitchBarPos.x - 150,p,100,3)
				surface.DrawRect(pitchBarPos.x + 50,p,100,3)

				surface.DrawRect(pitchBarPos.x - 75,p + 50,50,3)
				surface.DrawRect(pitchBarPos.x + 25,p + 50,50,3)

				surface.DrawRect(pitchBarPos.x - 75,p - 50,50,3)
				surface.DrawRect(pitchBarPos.x + 25,p - 50,50,3)
			end
		end
	end

	local function AddAlert(alert, boxSize)
		alertString = alertString .. "     -" .. alert .. "\n"
		alertNum = alertNum + 1
		boxX = math.max(boxX, boxSize)
	end

	local function DrawAlertPopup(ply, ent)
		if (!ply:GetVehicle():GetThirdPersonMode()) then
			local rPos = LocalPlayer():GetPos() + LocalPlayer():GetForward() * 100 + LocalPlayer():GetRight() * - 75 + LocalPlayer():GetUp() * 60
			local Pos = Vector(-400,-650,0)
			alertString = ""
			alertNum = 0
			if (ent.aura_lfs_anyAlert == nil) then
				ent.aura_lfs_anyAlert = false
			end

			if (ent.aura_lfs_health_text == nil) then
				ent.aura_lfs_health_text = false
			end
			if (ent.aura_lfs_shield_text == nil) then
				ent.aura_lfs_shield_text = false
			end
			if (ent.aura_lfs_ammoPrimary_text == nil) then
				ent.aura_lfs_ammoPrimary_text = false
			end
			if (ent.aura_lfs_ammoSecondary_text == nil) then
				ent.aura_lfs_ammoSecondary_text = false
			end

			if (ent.aura_lfs_shield_text) then
				AddAlert("Warning, shields depleted", 320)
			end

			if (ent.aura_lfs_health_text) then
				local hpPercent = math.Round(math.Remap(ent:GetHP(),0,ent:GetMaxHP(),0,100))
				AddAlert("Warning, health low -- " .. hpPercent .. "%", 400)
			end

			if (ent.aura_lfs_ammoPrimary_text) then
				local ammo = math.Round(math.Remap(ent:GetAmmoPrimary(),0,ent:GetMaxAmmoPrimary(),0,100))
				AddAlert("Warning, primary ammo depleted", 400)
			end

			if (ent.aura_lfs_ammoSecondary_text) then
				local ammo = math.Round(math.Remap(ent:GetAmmoSecondary(),0,ent:GetMaxAmmoSecondary(),0,100))
				AddAlert("Warning, secondary ammo depleted", 400)
			end

			if (ent.aura_lfs_hostile_alert and EnableHostileAlert) then
				local num = #ent.aura_lfs_notify_ai_target
				local h = "hostiles"
				if (num == 1) then
					h = "hostile"
				end
				AddAlert("You currently have " .. num .. " " .. h .. " targeting you", 500)
			end

			if (alertNum > 0) then
				ent.aura_lfs_anyAlert = true
			else
				if (ent.aura_lfs_anyAlert) then
					ent.aura_lfs_anyAlert = false
					ent.aura_lfs_animation_finished = false
				end
				if (currWidth > 0) then
					local h = draw.GetFontHeight("LFS_FONT")
					surface.SetDrawColor(25,25,25,255)
					surface.DrawRect(Pos.x - 15, Pos.y - 10, 5, 50 + boxY)
					surface.DrawRect(Pos.x - 10 + boxX, Pos.y - 10, 5, 50 + boxY)
					local reps = 1
					surface.SetDrawColor(50,50,50,200)
					currWidth = math.Approach(currWidth,0, (FrameTime() * boxX / reps))
    				surface.DrawRect(Pos.x - 10, Pos.y - 10, currWidth, 50 + boxY)
    				surface.DrawRect(Pos.x + boxX - currWidth - 10, Pos.y - 10, currWidth, 50 + boxY)
				else
					boxX = 0
				end
			end

			if (ent.aura_lfs_animation_finished == nil) then
				ent.aura_lfs_animation_finished = false
			end

			if (ent.aura_lfs_anyAlert) then
				local h = draw.GetFontHeight("LFS_FONT")
				surface.SetDrawColor(25,25,25,255)
				boxY = (alertNum * h)
				surface.DrawRect(Pos.x - 15, Pos.y - 10, 5, 50 + boxY)
				surface.DrawRect(Pos.x - 10 + boxX, Pos.y - 10, 5, 50 + boxY)
				if (!ent.aura_lfs_animation_finished) then
					local reps = 1
					currWidth = math.Approach(currWidth,boxX / 2, (FrameTime() * boxX / reps))
    				surface.DrawRect(Pos.x - 10, Pos.y - 10, currWidth, 50 + boxY)
    				surface.DrawRect(Pos.x + boxX - currWidth - 10, Pos.y - 10, currWidth, 50 + boxY)
    				if (currWidth >= boxX / 2) then
						ent.aura_lfs_animation_finished = true
					end
				end
				if (ent.aura_lfs_animation_finished) then
					surface.SetDrawColor(50,50,50,200)
    				surface.DrawRect(Pos.x - 10, Pos.y - 10, boxX, 50 + boxY)

		    		surface.SetTextColor(238,210,2,200)
		    		surface.SetFont("LFS_FONT")
		    		surface.SetTextPos(Pos.x,Pos.y)
					surface.DrawText("! ALERT !")
					draw.DrawText(alertString,"LFS_FONT",Pos.x,Pos.y + 30,aura_lfs_overhaul_config_ui_color,TEXT_ALIGN_LEFT)
					ent.aura_lfs_animation_finished = true
				end
			end

		else
			ent.aura_lfs_anyAlert = false
			ent.aura_lfs_animation_finished = false
			currWidth = 0
		end
	end

	local function DrawHealthAndShield(ply, ent)
		if (true) then
			local shieldPos = Vector(0,-20,0)
			local barWidth = 250
			local barHeight = 6
			local shield = ent:GetShield()
			local maxShield = ent.MaxShield

			if (maxShield != 0) then
				local scaledShield = math.Remap(shield,0,ent.MaxShield,0,barWidth)
				local offSet = (barWidth - scaledShield)
				surface.SetDrawColor(aura_lfs_overhaul_config_ui_color)
				surface.DrawRect(shieldPos.x + (offSet / 2) - (barWidth / 2),shieldPos.y,scaledShield,barHeight)
			else
				barHeight = 6
				shieldPos = Vector(0,-20 - barHeight,0)
			end

			local hp = ent:GetHP()

			local scaledHP = math.Remap(hp,0,ent:GetMaxHP(),0,barWidth)
			local offSetHp = (barWidth - scaledHP)
			surface.SetDrawColor(255,0,0,255)
			surface.DrawRect(shieldPos.x + (offSetHp / 2) - (barWidth / 2),shieldPos.y + barHeight,scaledHP,barHeight)


			local hpPos = Vector(-250,-140,0)

			draw.DrawText("HP: " .. math.Round(hp,0) .. "/" .. ent:GetMaxHP(),"AURA_LFS_FONT",hpPos.x,hpPos.y,aura_lfs_overhaul_config_ui_color,TEXT_ALIGN_CENTER)

			local shieldPos2 = Vector(255,-140,0)
			draw.DrawText("SHIELD: " .. math.Round(shield,0) .. "/" .. ent.MaxShield,"AURA_LFS_FONT",shieldPos2.x,shieldPos2.y,aura_lfs_overhaul_config_ui_color,TEXT_ALIGN_CENTER)
		end
	end

	local function CleanUpShipModel(entity)
		if !entity.LFS then return end
		if (entity.aura_radar_models == nil) then return end
		for i=1,#entity.aura_radar_models do
			local e = entity.aura_radar_models[i]
			if (IsValid(e)) then
				if (!IsValid(e.ship)) then
					SafeRemoveEntityDelayed(e,0)
				end
			end
		end

		for i=1,#entity.aura_radar_models do
			local m = entity.aura_radar_models[i]
			if (!IsValid(m)) then
				table.remove(entity.aura_radar_models,i)
			end
		end
	end

	local function AITargetInfront( self, ent, range )
		if not IsValid( ent ) then return false end
		if not range then range = 45 end
		
		local DirToTarget = (ent:GetPos() - self:GetPos()):GetNormalized()
		
		local InFront = math.deg( math.acos( math.Clamp( self:GetForward():Dot( DirToTarget ) ,-1,1) ) ) < range
		return InFront
	end

	local function CanSee( self, otherEnt )
		if not IsValid( otherEnt ) then return false end

		return util.TraceLine( { start = self:GetPos(), filter = self, endpos = otherEnt:GetPos() } ).Entity == otherEnt
	end

	local function aura_override_lfsGetPlane(self)
		
		local Pod = self:GetVehicle()
		
		if not IsValid( Pod ) then return NULL end
		
		if Pod.LFSchecked == true then
			
			return Pod.LFSBaseEnt
			
		elseif Pod.LFSchecked == nil then
			
			local Parent = Pod:GetParent()
			
			if not IsValid( Parent ) then Pod.LFSchecked = false return NULL end
			
			if not Parent.LFS then Pod.LFSchecked = false return NULL end
			
			Pod.LFSchecked = true
			Pod.LFSBaseEnt = Parent
			
			return Parent
		else
			return NULL
		end
	end

	local function AIGetTarget(self)
		if (self:GetAI() == false) then return end
		self.NextAICheck = self.NextAICheck or 0

		if self.NextAICheck > CurTime() and self.LastTarget != nil then return self.LastTarget end

		self.NextAICheck = CurTime() + 2
		
		local players = player.GetAll()
		
		local ClosestTarget = NULL
		local TargetDistance = 60000
		
		local MyPos = self:GetPos()
		local MyTeam = self:GetAITEAM()
		
		if not simfphys.LFS.IgnorePlayers then
			for _, v in pairs( players ) do
				if IsValid( v ) then
					if v:Alive() then
						local Dist = (v:GetPos() - MyPos):Length()
						if Dist < TargetDistance then
							local Plane = aura_override_lfsGetPlane(v)
							
							if IsValid( Plane ) then
								if CanSee( self, Plane ) and Plane:GetHP() > 0 and Plane ~= self then
									local HisTeam = Plane:GetAITEAM()
									if HisTeam ~= MyTeam or HisTeam == 0 then
										ClosestTarget = v
										TargetDistance = Dist
									end
								end
							else
								local HisTeam = v:lfsGetAITeam()
								if v:IsLineOfSightClear( self ) then
									if HisTeam ~= MyTeam or HisTeam == 0 then
										ClosestTarget = v
										TargetDistance = Dist
									end
								end
							end
						end
					end
				end
			end
		end
		self.FoundPlanes = simfphys.LFS:PlanesGetAll()		
		for _, v in pairs( self.FoundPlanes ) do
			if IsValid( v ) and v ~= self and v.LFS then
				local Dist = (v:GetPos() - MyPos):Length()
				
				if Dist < TargetDistance and AITargetInfront( self, v, 100 ) then
					if v:GetHP() > 0 and v.GetAITEAM then
						local HisTeam = v:GetAITEAM()
						
						if HisTeam ~= self:GetAITEAM() or HisTeam == 0 then
							ClosestTarget = v
							TargetDistance = Dist
						end
					end
				end
			end
		end

		self.LastTarget = ClosestTarget
		
		return ClosestTarget
	end


	local function DrawRadar(ply, ent, pos)
		if (true) then
			local radarPos = Vector(0,-200,0)
			if (ent.aura_lfs_notify_ai_target == nil or ent.aura_lfs_hostile_alert == nil) then
				ent.aura_lfs_notify_ai_target = {}
				ent.aura_lfs_hostile_alert = false
			end
			if (ent.aura_radar_models == nil) then
				ent.aura_radar_models = {}
			end

			surface.SetMaterial(radarMat)
	
			local matSize = 300

			surface.DrawTexturedRect(radarPos.x - (matSize / 2), radarPos.y,matSize,matSize)

			surface.DrawTexturedRect(radarPos.x - (matSize / 3), radarPos.y + (matSize /  6),matSize / 1.5,matSize / 1.5)

			surface.DrawTexturedRect(radarPos.x - (matSize / 2.3), radarPos.y + (matSize /  15),matSize / 1.15,matSize / 1.15)


			surface.DrawTexturedRect(radarPos.x - (matSize / 8), radarPos.y + (matSize / 2.75),matSize / 4,matSize / 4)

			local pos2 = ent:GetPos()
			local dist = 10000
			local entList = ents.FindInSphere(pos2,dist)


			local div = (dist / matSize)^2 / 1.5
			local teamColor = Color(0,127,255,255)
			local radarList = {}

			if (ent.aura_updateTargetAlert == nil) then
				ent.aura_updateTargetAlert = true
			end

			if (ent.aura_updateTargetAlert and EnableHostileAlert) then

				if (#ent.aura_lfs_notify_ai_target == 0) then
					ent.aura_lfs_hostile_alert = false
				end
				for i=1,#ent.aura_lfs_notify_ai_target do
					if (!IsValid(ent.aura_lfs_notify_ai_target[i])) then
						table.remove(ent.aura_lfs_notify_ai_target,i)
					end
				end

				ent.aura_updateTargetAlert = false
				timer.Simple(1, function()
					if (IsValid(ent)) then
						ent.aura_updateTargetAlert = true
					end
				end)
			end
			for i=1,#entList do
				local v = entList[i]
				if v.LFS and IsValid(v) and v != ent then
					if (EnableHostileAlert) then
						if (v.aura_updateTargetFinder == nil) then
							v.aura_updateTargetFinder = true
						end
						if (v != ent and v.aura_updateTargetFinder and v:GetAITEAM() != ent:GetAITEAM()) then
							local target = AIGetTarget(v)
							if (target == ent:GetDriver() or target == ent) then
								if (!table.HasValue(ent.aura_lfs_notify_ai_target,v)) then
									table.insert(ent.aura_lfs_notify_ai_target,v)
									ent.aura_lfs_hostile_alert = true
								end
							else
								if (table.HasValue(ent.aura_lfs_notify_ai_target,v)) then
									table.RemoveByValue(ent.aura_lfs_notify_ai_target,v)
								end
							end
							v.aura_updateTargetFinder = false
							timer.Simple(1, function()
								if (IsValid(v)) then
									v.aura_updateTargetFinder = true
								end
							end)
						end
					end

					local dist = (ent:GetPos() - v:GetPos()):Length2D()
					if (dist < 10000) then

						teamColor = Color(0,127,255,255)
						local model = v.MDL or v:GetModel()
						if (v:GetClass() == "aura_acclamator_spawner_ai") then
							model = "models/acclamator/syphadias/acclamator.mdl"
						end
						if (v:GetClass() == "aura_munificent_spawner_ai") then
							model = "models/munificent/syphadias/munificent.mdl"
						end
						if (v.lfsRepairDroid) then
							if (IsValid(v:GetParent()) and v:GetParent() != nil) then
								model = v:GetParent():GetModelString()
							end
						end

						if (model == nil or model == "") then
							model = "models/Combine_Helicopter/helicopter_bomb01.mdl"
						end
						local shipProp = nil
						for i=1,#ent.aura_radar_models do
							local sp = ent.aura_radar_models[i]
							if (sp.ship == v and sp.ent == ent) then
								shipProp = sp
							end
						end
						if (!IsValid(shipProp) or shipProp == nil) then
							util.PrecacheModel(model)
							shipProp = ClientsideModel( model, RENDERGROUP_TRANSLUCENT )
							shipProp:SetCollisionGroup(10)
				    		shipProp.ship = v
				    		shipProp.ent = ent
				    		table.insert(ent.aura_radar_models,shipProp)
						end
						if (IsValid(shipProp) and shipProp != nil) then
							--local midPos = (pos + ent:GetForward() * .75)
							--local actualPos = midPos + entPos / div
							--local entPos = (v:GetPos() - ent:GetPos())
							local midPos = (pos + ent:GetForward() * .75)

							local entPos = (v:GetPos() - midPos)

							local actualPos = midPos + entPos

							
							if (v != ent) then

								local textPos = (actualPos)

								if (v.lfsRepairDroid) then
									textPos = ((pos + ent:GetForward() * 1.5) + entPos / div)
								end
								local startPos = textPos

								local endPos = textPos

								--render.DrawLine(startPos,endPos,Color(0,255,0,255), false)

								local ang = ent:GetAngles()

								actualPos.x = math.Clamp(actualPos.x - midPos.x,-1.75,1.75) + midPos.x
								actualPos.y = math.Clamp(actualPos.y - midPos.y,-1.75,1.75) + midPos.y

								local pos = Vector(0,0,0)


								local worldVec = (WorldToLocal(v:GetPos(), v:GetAngles(), ent:GetPos(), ent:GetAngles())) / div / 2
								actualPos = LocalToWorld(worldVec,ent:GetAngles(),midPos,ent:GetAngles())

								cam.Start3D2D(midPos, ang, 1)
									local endSecondPos = Vector(worldVec.x ,-worldVec.y,worldVec.z)
									local firstStart = Vector(0,0,0)
									local firstEnd = Vector(worldVec.x ,-worldVec.y,0)
									render.DrawLine(firstStart,firstEnd,whiteCol)
									render.DrawLine(firstEnd,endSecondPos,whiteCol)

					    		cam.End3D2D()
					    	end

					    	if (v:GetAITEAM() != ent:GetAITEAM()) then
								teamColor = Color(255,0,0,255)
							end
							teamColor.a = ((v:GetHP() / v:GetMaxHP() ) * 255 / 10)

							shipProp:SetLOD(3)

							shipProp:SetModelScale(1 / (v:GetModelScale()) / div)
							shipProp:SetMaterial("models/wireframe", true)
							shipProp:SetRenderMode( RENDERMODE_TRANSALPHA )
							shipProp:SetColor(teamColor)
							shipProp:SetPos(actualPos)

							if (v.lfsRepairDroid) then
								shipProp:SetModelScale(v:GetModelScale() / div * 5)
								shipProp:Spawn()
								shipProp:SetAngles(v:GetParent():GetAngles())
								CleanUpShipModel(ent)
							else
								shipProp:Spawn()
								shipProp:SetAngles(v:GetAngles())

								CleanUpShipModel(ent)
							end
						end
					end
				end
			end
		end
	end

	local function CleanUpModels(entity)
		if !entity.LFS then return end
		if (entity.aura_radar_models == nil) then return end
		for i=1,#entity.aura_radar_models do
			local e = entity.aura_radar_models[i]
			if (IsValid(e)) then
				if (e.ship == entity or e.ent == entity) then
					SafeRemoveEntityDelayed(e,0)
				end
			end
		end

		for i=1,#entity.aura_radar_models do
			local m = entity.aura_radar_models[i]
			if (!IsValid(m)) then
				table.remove(entity.aura_radar_models,i)
			end
		end
	end

	hook.Add("EntityRemoved","LFSOverHaulRadarCleanup", function(entity)
		CleanUpModels(entity)
	end)

	hook.Add( "HUDPaint", "!!!!!LFS_hud_aura_interface", function()
		if GetConVar("lfs_disable_all_overhaul_settings"):GetBool() then return end
		local ply = LocalPlayer()

		local ang = LocalPlayer():EyeAngles()
		local pos = Vector(0,0,0)
		
		if ply:GetViewEntity() ~= ply then return end
		
		local Parent = aura_override_lfsGetPlane(LocalPlayer())

		if !IsValid(Parent) or Parent == nil then return end

		LFSAuraContactNotify( Parent )

	end)

	local smTran = 0

	hook.Add("CalcView","Aura_LFS_Redo_View", function(aura_safe_override_ply, aura_safe_override_origin, aura_safe_override_angles, aura_safe_override_fov)
		if GetConVar("lfs_disable_all_overhaul_settings"):GetBool() then return end
		if (!AllowRollWithShip) then return end
		local aura_safe_override_ent = aura_override_lfsGetPlane(aura_safe_override_ply)

		if !IsValid(aura_safe_override_ent) or aura_safe_override_ent == nil then return end
		if not aura_safe_override_ply:GetVehicle():GetThirdPersonMode() then
			smTran = smTran + ((aura_safe_override_ply:lfsGetInput( "FREELOOK" ) and 0 or 1) - smTran) * FrameTime() * 10
			local viewRet = {}
			viewRet.origin = aura_safe_override_origin
			viewRet.fov = aura_safe_override_fov
			viewRet.angles = (aura_safe_override_ent:GetForward() * (1 + 1) * smTran * 0.8 + aura_safe_override_ply:EyeAngles():Forward() * math.max(1 - 1, 1 - smTran)):Angle()
			viewRet.angles.r = aura_safe_override_ent:GetAngles().z

			viewRet.drawviewer = false
			return viewRet
		end
	end)

	hook.Add("PostDrawTranslucentRenderables","AuraHUDDrawTestStuff", function(drawDepth, skybox)
		local ply = LocalPlayer()
		if (ply:Alive() and ply != nil) then

			local ent = aura_override_lfsGetPlane(LocalPlayer())
			if GetConVar("lfs_disable_all_overhaul_settings"):GetBool() then CleanUpModels(ent) return end
			if (!IsValid(ent)) then return end
			local ang = ent:GetAngles()

			local pos = ply:GetPos() + ent:GetForward() * 10 + ent:GetUp() * 22.5
			ang:RotateAroundAxis( ang:Forward(), 90 )
			ang:RotateAroundAxis( ang:Right(), 90 )

			cam.Start3D2D(pos, ang , .015)

				if (ShowHPAndShield) then
					DrawHealthAndShield(ply,ent)
				end

				if (ShowHUD) then
					DrawAltitudeMeter(ply, ent)
					DrawThrottleMeter(ply, ent)
					DrawPitchScroller(ply, ent)
					DrawAmmoMeter(ply,ent)
				end
				if (ShowAlerts) then
					DrawAlertPopup(ply, ent)
				end
             
            cam.End3D2D()

            if (EnableRadar) then
	            pos = pos + ent:GetForward() * 3

	            cam.Start3D2D(pos, ang + Angle(0,0,-90), .015)

					DrawRadar(ply, ent, pos)
	             
	            cam.End3D2D()
	        else
	        	CleanUpModels(ent)
	        end
	    end
	end)

	cvars.AddChangeCallback( "lfs_show_nameindc", function( convar, oldValue, newValue ) 
		ShowNameIndc = tonumber( newValue ) ~=0
	end)

	cvars.AddChangeCallback( "lfs_show_hpindc", function( convar, oldValue, newValue ) 
		ShowHPIndc = tonumber( newValue ) ~=0
	end)

	cvars.AddChangeCallback( "lfs_show_identifier", function( convar, oldValue, newValue ) 
		ShowPlaneIdent = tonumber( newValue ) ~=0
	end)

	cvars.AddChangeCallback( "lfs_show_hud", function( convar, oldValue, newValue ) 
		ShowHud = tonumber( newValue ) ~=0
	end)

	cvars.AddChangeCallback( "lfs_voice_indicators", function( convar, oldValue, newValue ) 
		VoiceActivate = tonumber( newValue ) ~=0
	end)

	cvars.AddChangeCallback( "lfs_alert_indicators", function( convar, oldValue, newValue ) 
		ShowAlerts = tonumber( newValue ) ~=0
	end)

	cvars.AddChangeCallback( "lfs_roll_with_ship", function( convar, oldValue, newValue ) 
		AllowRollWithShip = tonumber( newValue ) ~=0
	end)

	cvars.AddChangeCallback( "lfs_enable_radar", function( convar, oldValue, newValue ) 
		EnableRadar = tonumber( newValue ) ~=0
	end)

	cvars.AddChangeCallback( "lfs_enable_hp_shield", function( convar, oldValue, newValue ) 
		ShowHPAndShield = tonumber( newValue ) ~=0
	end)

	cvars.AddChangeCallback( "lfs_enable_hostile_alert", function( convar, oldValue, newValue ) 
		EnableHostileAlert = tonumber( newValue ) ~=0
	end)


	local Frame

	local function OpenAuraSettingsMenu(admin)
		if not IsValid( Frame ) then
			local width = 400
			Frame = vgui.Create( "DFrame" )
			Frame:SetSize( width, 250 )
			Frame:SetTitle( "" )
			Frame:SetDraggable( true )
			Frame:MakePopup()
			Frame:Center()

			local y = 40
			if (admin) then
				y = 70
			end

			for i=1,#propertiesMenuClient do
				local name = propertiesMenuClient[i].name
				local desc = propertiesMenuClient[i].desc
				local cvar = propertiesMenuClient[i].convar
				local size = propertiesMenuClient[i].size or 20

				local CheckBox = vgui.Create( "DCheckBoxLabel", Frame )
				CheckBox:SetText( name .. " -- " .. desc )
				CheckBox:SetConVar(cvar) 
				CheckBox:SizeToContents()
				CheckBox:SetPos( 20, y )
				if (admin) then
					local func = propertiesMenuClient[i].func
					function CheckBox:OnChange(bVal)
						func(bVal)
					end
				end

				y = y + size
			end

			if (admin) then
				y = y + 20
				local CheckBox = vgui.Create( "DCheckBoxLabel", Frame )
				CheckBox:SetText( "Disable Damage Changes -- If enabled, guns do less damage\nto LFS vehicles" )
				CheckBox:SetChecked(GetConVar("lfs_disable_damage_changes"):GetBool())
				CheckBox:SizeToContents()
				CheckBox:SetPos( 20, y )
				function CheckBox:OnChange(bVal)
					net.Start("Aura_LFS_Toggle_Damage_Reduction")
					net.WriteBool(bVal)
					net.SendToServer()
				end
				y = y + 30

				local CheckBoxTwo = vgui.Create( "DCheckBoxLabel", Frame )
				CheckBoxTwo:SetText( "Disable Staff notifications -- If enabled, staff will get notified\nwhenever someone changes a vehicles properties" )
				CheckBoxTwo:SetChecked(GetConVar("lfs_disable_admin_notify"):GetBool())
				CheckBoxTwo:SizeToContents()
				CheckBoxTwo:SetPos( 20, y )
				function CheckBoxTwo:OnChange(bVal)
					net.Start("Aura_LFS_Toggle_Admin_Notify")
					net.WriteBool(bVal)
					net.SendToServer()
				end
				y = y + 30

				local CheckBoxThree = vgui.Create( "DCheckBoxLabel", Frame )
				CheckBoxThree:SetText( "Disable Staff notifications (Except AI) -- If enabled, staff will get\nnotified whenever someone changes a vehicles AI property" )
				CheckBoxThree:SetChecked(GetConVar("lfs_disable_admin_notify_ai"):GetBool())
				CheckBoxThree:SizeToContents()
				CheckBoxThree:SetPos( 20, y )
				function CheckBoxThree:OnChange(bVal)
					net.Start("Aura_LFS_Toggle_Admin_Notify_AI_Only")
					net.WriteBool(bVal)
					net.SendToServer()
				end
				y = y + 30
			end

			Frame:SetSize( width, 40 + y - 30 )
			Frame:Center()
			Frame.Paint = function(self, w, h )
				draw.RoundedBox( 8, 0, 0, w, h, Color( 0, 0, 0, 255 ) )
				draw.RoundedBox( 8, 1, 26, w-2, h-26, Color( 120, 120, 120, 255 ) )
				draw.RoundedBox( 8, 0, 0, w, 25, Color( 127, 0, 0, 255 ) )
				local title = "Aura's LFS Settings -- Client"
				if (admin) then
					title = "Aura's LFS Settings -- Admin"
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial( adminMat )
					surface.DrawTexturedRect( 285, 5, 16, 16 )
					draw.SimpleText( "This is the server config menu, any settings", "AURA_LFS_FONT_PANEL", width / 2, 38, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					draw.SimpleText( "you change here affects ALL players", "AURA_LFS_FONT_PANEL", width / 2, 53, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				draw.SimpleText( title, "LFS_FONT", 5, 11, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
		end
	end

	list.Set( "DesktopWindows", "AuraLFSOverHaulMenu", {
		title = "LFS Overhaul Settings",
		icon = "icon64/aura_lfs_icon.png",
		init = function( icon, window )
			OpenAuraSettingsMenu(false)
		end
	} )

	net.Receive("Aura_LFS_Open_Config_From_Server_Admin", function()
		if (LocalPlayer():IsSuperAdmin()) then
			OpenAuraSettingsMenu(true)
		else
			LocalPlayer():ChatPrint(LocalPlayer():Nick() .. ", you do not have permission to open this menu!" )
		end
	end)
end

if (SERVER) then
	net.Receive("Aura_LFS_Toggle_Damage_Reduction", function()
		local b = net.ReadBool()
		GetConVar("lfs_disable_damage_changes"):SetBool(b)
	end)

	net.Receive("Aura_LFS_Toggle_Admin_Notify", function()
		local b = net.ReadBool()
		GetConVar("lfs_disable_admin_notify"):SetBool(b)
	end)

	net.Receive("Aura_LFS_Toggle_Admin_Notify_AI_Only", function()
		local b = net.ReadBool()
		GetConVar("lfs_disable_admin_notify_ai"):SetBool(b)
	end)

	hook.Add("EntityTakeDamage","AuraLFSDamageModifier", function(ent, dmginfo)
		if (GetConVar("lfs_disable_damage_changes"):GetBool()) then return end
		if (!ent.LFS) then return end
		if (dmginfo:GetInflictor().LFS or dmginfo:GetInflictor() == Entity(0) or dmginfo:GetDamageType() == 0) then return end
		dmginfo:SetDamage(dmginfo:GetDamage() * .15)
	end)
end