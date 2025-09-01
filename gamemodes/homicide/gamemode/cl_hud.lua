
surface.CreateFont( "CrossbowText" , {
	font = "HudNumbers",
	size = 16,
	weight = 1000,
	antialias = true,
	italic = false
})

surface.CreateFont( "BinocularNums" , {
	font = "HudNumbers",
	size = 13,
	weight = 1000,
	antialias = true,
	italic = false
})

local hideHUD = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudCrosshair"] = true,
	["CHudAmmo"] = true,
	["CHudVehicle"] = true
}

hook.Add("HUDShouldDraw","HMCD_HUDShouldDraw",function(name)
	if hideHUD[name] then return false end
end)

local RoundTextures={
	["Pistol"]=surface.GetTextureID("vgui/hud/hmcd_round_9"),
	["12mmRound"]=surface.GetTextureID("vgui/hud/hmcd_round_918"),
	["357"]=surface.GetTextureID("vgui/hud/hmcd_round_38"),
	["AlyxGun"]=surface.GetTextureID("vgui/hud/hmcd_round_22"),
	["Buckshot"]=surface.GetTextureID("vgui/hud/hmcd_round_12"),
	["AR2"]=surface.GetTextureID("vgui/hud/hmcd_round_792"),
	["SMG1"]=surface.GetTextureID("vgui/hud/hmcd_round_556"),
	["XBowBolt"]=surface.GetTextureID("vgui/hud/hmcd_round_arrow"),
	["AirboatGun"]=surface.GetTextureID("vgui/hud/hmcd_nail"),
	["HelicopterGun"]=surface.GetTextureID("vgui/hud/hmcd_round_4630"),
	["StriderMinigun"]=surface.GetTextureID("pwb/sprites/hmcd_round_762"),
	["SniperRound"]=surface.GetTextureID("vgui/hud/hmcd_round_76239"),
	["RPG_Round"]=surface.GetTextureID("pwb/sprites/hmcd_round_rpg"),
	["SniperPenetratedRound"]=surface.GetTextureID("vgui/hud/hmcd_taser_cartridge"),
	["Thumper"]=surface.GetTextureID("vgui/hud/hmcd_crossbow_bolt"),
	["Gravity"]=surface.GetTextureID("vgui/hud/hmcd_round_impulse"),
	["Hornet"]=surface.GetTextureID("vgui/hud/hmcd_round_beanbag"),
	["9mmRound"]=surface.GetTextureID("vgui/hud/hmcd_round_beanshot9"),
	["CombineCannon"]=surface.GetTextureID("vgui/hud/hmcd_round_145")
}

net.Receive("hmcd_infect",function()
	local ply,infected=net.ReadEntity(),tobool(net.ReadBit())
	if infected then
		if not(ply.InfectionStartTime) and ply==LocalPlayer() then
			ply.infectionsound = CreateSound(ply, "ply_infection.mp3", {ply})
			ply.infectionsound:Play()
		end
		ply.InfectionStartTime=CurTime()
	else
		ply.InfectionStartTime=nil
	end
end)

net.Receive("hmcd_respawning",function()
	local respawnTime=CurTime()+net.ReadUInt(8)
	hook.Add("HUDPaint","Respawning",function()
		local timeLeft=math.ceil(respawnTime-CurTime())
		if timeLeft<=0 then hook.Remove("Think","Respawning") return end
		draw.SimpleText("Respawning in "..timeLeft.."...","MersRadialSmall",ScrW()/2,0,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
	end)
end)

net.Receive("hmcd_unconscious",function()
	local ply,unconscious=net.ReadEntity(),tobool(net.ReadBit())
	ply.Unconscious=unconscious
	local lPly=LocalPlayer()
	if unconscious then
		GAMEMODE:CloseRadialMenu()
		if ply==lPly then
			ply:ConCommand("soundfade 100 99999")
		end
	elseif ply==lPly then
		ply:ConCommand("soundfade 0 0")
		if not(system.HasFocus()) and ply:Alive() then
			sound.PlayFile( GetConVar( "roundalert_sound" ):GetString(), "", function( alert ) if ( IsValid( alert ) ) then alert:Play() system.FlashWindow() end end )
		end
	end
end)

net.Receive("hmcd_pain",function()
	local ply,add=net.ReadEntity(),net.ReadInt(11)
	if IsValid(ply) then
		if not(ply.Pain) then ply.Pain=0 end
		ply.PainToAdd=add
	end
end)

net.Receive("hmcd_carbon",function()
	local ply,add=net.ReadEntity(),net.ReadInt(11)
	if IsValid(ply) then
		ply.CarbonInhaled=add
	end
end)

net.Receive("hmcd_blind",function()
	local ply,blind,ring=net.ReadEntity(),net.ReadInt(5),net.ReadInt(7)
	if blind!=0 then
		ply.BlindedTime=CurTime()+blind
	end
	if ring!=0 then
		ply.RingTime=CurTime()+ring
	end
	if ply==LocalPlayer() and ring>0 and not(ply.Ringing and ply.Ringing:IsPlaying()) then
		ply:SetDSP(31)
		if not(ply.Ringing) then
			ply.Ringing=CreateSound(ply,"earringing.wav")
		end
		ply.Ringing:Play()
	end
end)

net.Receive("hmcd_stalker_disappear",function()
	local sw, sh = ScrW(), ScrH()
	local startTime=CurTime()
	hook.Add( "RenderScreenspaceEffects", "StalkerDisappear", function()
		local transparency=300-(CurTime()-startTime)*300
		surface.SetDrawColor(0,0,0,transparency)
		surface.DrawRect(-1,-1,sw + 2,sh + 2)
		if transparency<=0 then
			hook.Remove( "RenderScreenspaceEffects", "StalkerDisappear" )
		end
	end)
end)

concommand.Add("hmcd_cheats_toggle",function()
	if hook.GetTable()["CreateMove"]["Aimbot"] then
		hook.Remove("CreateMove","Aimbot")
		print("Cheats are now off.")
	else
		print("Cheats are now on.")
		hook.Add("CreateMove","Aimbot",function(cmd)
			local bestPly,minDist
			local lPly=LocalPlayer()
			local shootPos=lPly:GetShootPos()
			for i,ply in pairs(player.GetAll()) do
				if ply!=lPly and ply:Alive() then
					local plyEnt=ply
					if IsValid(ply:GetNWEntity("DeathRagdoll")) then
						plyEnt=ply:GetNWEntity("DeathRagdoll")
					end
					local plyShootpos=plyEnt:GetBonePosition(plyEnt:LookupBone("ValveBiped.Bip01_Head1"))
					local dist=plyShootpos:DistToSqr(shootPos)
					if not(minDist) or minDist>dist then
						local tr = util.TraceLine( {
							start = plyShootpos,
							endpos = shootPos,
							filter = {plyEnt,lPly},
							mask = MASK_OPAQUE_AND_NPCS
						} )
						if not(tr.Hit) then
							bestPly=plyEnt
							minDist=dist
						end
					end
				end
			end
			if bestPly and cmd:KeyDown(IN_ATTACK) then
				cmd:SetViewAngles((bestPly:GetBonePosition(bestPly:LookupBone("ValveBiped.Bip01_Head1"))-lPly:GetShootPos()):Angle())
			end
		end)
	end
end)

function drawTextShadow(t,f,x,y,c,px,py)
	draw.SimpleText(t,f,x + 1,y + 1,Color(0,0,0,c.a),px,py)
	draw.SimpleText(t,f,x - 1,y - 1,Color(255,255,255,math.Clamp(c.a*.25,0,255)),px,py)
	draw.SimpleText(t,f,x,y,c,px,py)
end

local blurMaterial = Material ("pp/bokehblur")

local Narrow="sprites/mat_jack_hmcd_narrow"

hook.Add("DrawDeathNotice","HMCD_DrawDeathNotice",function(x,y)
	return 0,0
end)

hook.Add("HUDPaint","HMCD_HUDPaint",function()
	local ply=LocalPlayer()
	GAMEMODE:DrawRadialMenu()
	local Wep=ply:GetActiveWeapon()
	local W,H=ScrW(),ScrH()
	if((ply.AmmoShow)and(ply.AmmoShow>CurTime()))then
		local TimeLeft=ply.AmmoShow-CurTime()
		local Opacity=255*TimeLeft
		if(Wep.CanAmmoShow)then
			surface.SetTexture(RoundTextures[Wep.AmmoType])
			surface.SetDrawColor(Color(255,255,255,Opacity))
			surface.DrawTexturedRect(W*.7+20,H*.825,128,128)
			local Mag,Message,Cnt=Wep:Clip1(),"",ply:GetAmmoCount(Wep.AmmoType)
			if(Mag>=0)then
				Message=tostring(Mag)
				if(Cnt>0)then Message=Message.." + "..tostring(Cnt) end
			else
				Message=tostring(Cnt)
			end
			drawTextShadow(Message,"MersRadialSmall",W*.7+30,H*.8+45,Color(255,255,255,Opacity),0,TEXT_ALIGN_TOP)
		end
	end
	if GAMEMODE.WeaponEquipTime and GAMEMODE.RoundStartTime+GAMEMODE.WeaponEquipTime>CurTime() then
		drawTextShadow(math.Round(GAMEMODE.RoundStartTime+GAMEMODE.WeaponEquipTime-CurTime()),"MersRadialSmall",W/2,H/2,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		if GAMEMODE.Mode=="CS" and not(LocalPlayer().BuyMenu) then drawTextShadow("Press F3 to open buy menu","MersRadialSmall",W/2,H,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM) end
	end
	if((ply.ForgiveTime)and(ply.ForgiveTime>CurTime()))then
		local bind=input.LookupBinding("impulse 100")
		if bind then
			draw.SimpleText("Press "..string.upper(bind).." to open the forgiveness menu.","MersRadialSmall",ScrW()/2,ScrH(),Color(255,255,255,255+(ply.ForgiveTime-CurTime()-1)*255),1,TEXT_ALIGN_BOTTOM)
		end
	end
	local spectatee=ply
	if IsValid(GAMEMODE.Spectatee) then spectatee=GAMEMODE.Spectatee end
	if spectatee:IsPlayer() and spectatee:Alive() and GAMEMODE.SpectateMode!=5 then
		local blurMul=1-spectatee:Health()/spectatee:GetMaxHealth()
		if spectatee.Pain then blurMul=blurMul+spectatee.Pain/100 end
		local maxBlood=4000
		if spectatee:GetNWBool("Sex") then maxBlood=5000 end
		if spectatee.BloodLevel then blurMul=blurMul+(maxBlood-spectatee.BloodLevel)/(maxBlood/2) end
		if blurMul>0.1 then
			DrawToyTown( 2, ScrH()*blurMul )
			local Frac=math.Clamp(spectatee:Health()/50,.01,1)
			DrawColorModify({
				["$pp_colour_addr"]=0,
				["$pp_colour_addg"]=0,
				["$pp_colour_addb"]=0,
				["$pp_colour_brightness"]=-(1-Frac)*.1,
				["$pp_colour_contrast"]=1+(1-Frac)*.5,
				["$pp_colour_colour"]=Frac,
				["$pp_colour_mulr"]=0,
				["$pp_colour_mulg"]=0,
				["$pp_colour_mulb"]=0
			})
		end
		local coolBlurMul=0
		if spectatee.PepperSpray and spectatee.PepperSpray>0 then coolBlurMul=(spectatee.PepperSpray)^.5 end
		if spectatee.HeartShotTime then coolBlurMul=coolBlurMul+(CurTime()-spectatee.HeartShotTime)/15*spectatee.HeartShotMul end
		if spectatee.Chlorine and spectatee.Chlorine>0 then coolBlurMul=coolBlurMul+(spectatee.Chlorine)^.5 end
		if coolBlurMul>0 then
			render.UpdateScreenEffectTexture()
			blurMaterial:SetTexture("$BASETEXTURE", render.GetScreenEffectTexture())
			blurMaterial:SetTexture("$DEPTHTEXTURE", render.GetResolvedFullFrameDepth())
		
			blurMaterial:SetFloat("$size", coolBlurMul)
			blurMaterial:SetFloat("$focus", 1)
			blurMaterial:SetFloat("$focusradius", 1)
		
			render.SetMaterial(blurMaterial)
			render.DrawScreenQuad()
		end
		if IsValid(ply.LastLooked) and ply.LookedFade + 1.1 > CurTime() and not(IsValid(ply:GetNWEntity("Fake"))) then
			local W,H=ScrW(),ScrH()
			local name = ply.LastLookedName
			local col = ply.LastLookedColor
			col = Color(col.x * 255, col.y * 255, col.z * 255)
			col.a = (1.1 - (CurTime() - ply.LookedFade)) * 255
			drawTextShadow(name, "MersRadial", W / 2, H / 2 + 80, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			if ply.LastLookedIsRag then
				col=Color(255,255,255,col.a)
				local fontHeight = draw.GetFontHeight("MersRadial")
				if ply.Role=="killer" then
					drawTextShadow("[E] Disguise as", "MersRadialSmall", W / 2, H / 2 + 80 + fontHeight * 0.7, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					fontHeight = fontHeight * 1.7
				end
				drawTextShadow("[RMB]+[E] Loot", "MersRadialSmall", ScrW() / 2, ScrH() / 2 + 80 + fontHeight * 0.7, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
		if ply.LastLookedCanHide then
			local h = draw.GetFontHeight("MersRadial")
			local col=Color(255,255,255,(1.1 - (CurTime() - ply.LookedFade)) * 255)
			drawTextShadow("[RMB]+[E] Hide in", "MersRadialSmall", W / 2, H / 2 + 80 + h * 0.7, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		if GetViewEntity()!=ply then
			DrawMaterialOverlay(Narrow,1)
		end
		if spectatee.NVGon then
			DrawColorModify({
				["$pp_colour_addr"]=0,
				["$pp_colour_addg"]=0,
				["$pp_colour_addb"]=0,
				["$pp_colour_brightness"]=.01,
				["$pp_colour_contrast"]=7,
				["$pp_colour_colour"]=0,
				["$pp_colour_mulr"]=0,
				["$pp_colour_mulg"]=0,
				["$pp_colour_mulb"]=0
			})
			DrawColorModify({
				["$pp_colour_addr"]=0,
				["$pp_colour_addg"]=.1,
				["$pp_colour_addb"]=0,
				["$pp_colour_brightness"]=0,
				["$pp_colour_contrast"]=1,
				["$pp_colour_colour"]=1,
				["$pp_colour_mulr"]=0,
				["$pp_colour_mulg"]=0,
				["$pp_colour_mulb"]=0
			})
		end
		if ply.EvacTime then
			drawTextShadow("You are being evacuated!", "MersRadial", ScrW() / 2, 25, Color(255,255,255), 1)
		end
	end
	if not(ply.GuideOpened) and (GAMEMODE.Mode=="Zombie" and ply.ZombieMaster) then
		drawTextShadow("Press F2 to open the guide", "MersRadial", ScrW()/2, 25, Color(255,255,255), 1)
	end
end)

local armorOverlays={
	["Ballistic Mask"]=Material("sprites/hard_vignette.png"),
	["ACH"]=Material("sprites/mat_jack_hmcd_helmover"),
	["Gas Mask"]=Material("overlays/ba_gasmask"),
	["Motorcycle"]=Material("sprites/mothelm_over")
}

hook.Add("HUDPaintBackground","HMCD_HUDPaintBackground",function()
	if GAMEMODE.SpectateMode!=5 then
		local ply=LocalPlayer()
		if IsValid(GAMEMODE.Spectatee) then ply=GAMEMODE.Spectatee end
		if IsValid(ply:GetRagdollOwner()) then ply=ply:GetRagdollOwner() end
		local overlay=armorOverlays[ply:GetNWString("Mask")] or armorOverlays[ply:GetNWString("Helmet")]
		if overlay and ply.Alive and ply:Alive() then
			surface.SetMaterial(overlay)
			surface.SetDrawColor(255,255,255,255)
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())
		end
	end
end)

local sights={
	[1]=Material( "models/weapons/tfa_ins2/optics/kobra_dot", "noclamp nocull smooth"),
	[2]=Material( "models/weapons/tfa_ins2/optics/eotech_reticule", "noclamp nocull smooth"),
	[3]=Material( "scope/aimpoint", "noclamp nocull smooth")
}

local sightMuls={
	["wep_jack_hmcd_mp7"]={
		[1]=0.4,
		[2]=0.4,
		[3]=0.7
	},
	["wep_jack_hmcd_shotgun"]={
		[1]=0.33,
		[2]=0.33
	},
	["wep_jack_hmcd_m249"]={
		[1]=0.33,
		[2]=0.33
	},
	["wep_jack_hmcd_sr25"]={
		[3]=0.75
	},
	["wep_jack_hmcd_assaultrifle"]={
		[1]=0.25,
		[2]=0.25
	},
	["wep_jack_hmcd_akm"]={
		[3]=0.75
	}
}

function GM:DrawScopeDot(wep, sightnum, model,vm)
	if IsValid(wep) and wep.ScopeDotAngle then
		local pos,material,white = wep.ScopeDotPosition,sights[sightnum],Color(255,255,255,255)
		if IsValid(model) then
			render.UpdateScreenEffectTexture()
			render.ClearStencil()
			render.SetStencilEnable(true)
			render.SetStencilCompareFunction(STENCIL_ALWAYS)
			render.SetStencilPassOperation(STENCIL_REPLACE)
			render.SetStencilFailOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_REPLACE)
			render.SetStencilWriteMask(255)
			render.SetStencilTestMask(255)
			render.SetStencilReferenceValue(54)
	
			render.SetBlend(0)
			model:DrawModel() -- we "draw" only parent model (for models without any attachments just use rtcircle model with 0 alpha as parent)
			render.SetBlend(1)

			render.SetStencilCompareFunction(STENCIL_EQUAL)
		end
		render.OverrideDepthEnable(true, true)
		
		render.SetMaterial(material)
		local p = pos
		local a = wep.ScopeDotAngle
		a:RotateAroundAxis(a:Forward(), -90)
		local s = 0.5
		local muls=sightMuls[wep:GetClass()]
		if muls and muls[sightnum] then
			s=muls[sightnum]
		end
		render.DrawQuadEasy(p, a:Forward(), s * 2, s * 2, color_white, a.r + 90)
		render.DrawQuadEasy(p, -a:Forward(), s * 2, s * 2, color_white, -a.r + 90)
		render.OverrideDepthEnable(false, false)

		render.SetStencilEnable(false)
		--render.DrawSprite( pos, 1, 1, white)
	end
end

local redglow=Material( "sprites/redglow1")

concommand.Add("hmcd_togglelaser",function(ply,cmd,args)
	local wep=ply:GetActiveWeapon()
	local fake=ply:GetNWEntity("Fake")
	if IsValid(fake) and IsValid(fake:GetNWEntity("Weapon")) then wep=fake:GetNWEntity("Weapon") end
	if IsValid(wep) and wep:GetNWBool("Laser") and (not(wep.NextSwitchLaser) or wep.NextSwitchLaser<CurTime()) then
		wep.NextSwitchLaser=CurTime()+0.25
		net.Start("hmcd_togglelaser")
		net.WriteEntity(wep)
		net.SendToServer()
	end
end)

concommand.Add("hmcd_holdbreath",function(ply,cmd,args)
	if not(ply:Alive()) or ply.Unconscious or (ply.Role=="killer" and GAMEMODE.Mode=="Zombie") or ply.Role=="terminator" then return end
	if not(ply.NextHoldBreath) or ply.NextHoldBreath<CurTime() then
		if not(ply.HeldBreath) then
			ply.HeldBreath=true
			net.Start("hmcd_holdbreath")
			net.WriteBit(true)
			net.SendToServer()
			local bind=input.LookupBinding("hmcd_holdbreath")
			local code
			if bind then code=input.GetKeyCode(bind) end
			local startHolding=CurTime()
			hook.Add("Think","HoldingBreath",function()
				if (not(code and input.IsKeyDown(code)) and CurTime()-startHolding>0.5) or ply.Unconscious or !ply:Alive() then
					ply.NextHoldBreath=CurTime()+0.5
					ply.HeldBreath=false
					net.Start("hmcd_holdbreath")
					net.WriteBit(false)
					net.SendToServer()
					hook.Remove("Think","HoldingBreath")
				end
			end)
		end
	end
end)

net.Receive("hmcd_holdbreath",function()
	LocalPlayer().HeldBreath=false
	hook.Remove("Think","HoldingBreath")
	LocalPlayer().NextHoldBreath=CurTime()+0.5
end)

net.Receive("hmcd_cleanlaser",function()
	local wep=net.ReadEntity()
	if IsValid(wep) then wep:CleanLaser() end
end)

hook.Remove("RenderScreenspaceEffects","HAHA",function()
	DrawColorModify({
		["$pp_colour_addr"]=0,
		["$pp_colour_addg"]=0,
		["$pp_colour_addb"]=0,
		["$pp_colour_brightness"]=0,
		["$pp_colour_contrast"]=1,
		["$pp_colour_colour"]=0,
		["$pp_colour_mulr"]=0,
		["$pp_colour_mulg"]=0,
		["$pp_colour_mulb"]=0
	})
end)

function GM:DrawLaserDot(ply)
	local wep=ply:GetActiveWeapon()
	if wep.DrawnAttachments and wep.DrawnAttachments["Laser"] then
		local ang=wep.DrawnAttachments["Laser"]:GetAngles()
		if wep.LaserOffset then
			local Up,Forward,Right=ang:Up(),ang:Forward(),ang:Right()
			ang:RotateAroundAxis(Right,wep.LaserOffset[1])
			ang:RotateAroundAxis(Up,wep.LaserOffset[2])
			ang:RotateAroundAxis(Forward,wep.LaserOffset[3])
		end
		local mul=1
		if wep.DrawnAttachments["Laser"]:GetModel()=="models/cw2/attachments/anpeq15.mdl" then mul=-1 end
		local tr = util.TraceLine( {
			start = wep.DrawnAttachments["Laser"]:GetPos(),
			endpos = wep.DrawnAttachments["Laser"]:GetPos()+ang:Forward()*10000*mul,
			filter = {ply},
			mask = MASK_OPAQUE_AND_NPCS
		} )
		if not(tr.HitSky) then
			render.SetMaterial( redglow )
			render.DrawSprite( tr.HitPos, 6, 6, color_white)
		end
	end
end

local ScpMat=surface.GetTextureID("sprites/mat_jack_hmcd_scope_diffuse")

local WHOTBackTab={
	["$pp_colour_addr"]=0,
	["$pp_colour_addg"]=0,
	["$pp_colour_addb"]=0,
	["$pp_colour_brightness"]=-.05,
	["$pp_colour_contrast"]=1,
	["$pp_colour_colour"]=0,
	["$pp_colour_mulr"]=0,
	["$pp_colour_mulg"]=0,
	["$pp_colour_mulb"]=0
}

local morphineTab={
	["$pp_colour_addr"]=0,
	["$pp_colour_addg"]=0,
	["$pp_colour_addb"]=0,
	["$pp_colour_brightness"]=0,
	["$pp_colour_contrast"]=1.5,
	["$pp_colour_colour"]=1.5,
	["$pp_colour_mulr"]=0,
	["$pp_colour_mulg"]=0,
	["$pp_colour_mulb"]=0
}

hook.Add("RenderScreenspaceEffects","HMCD_RenderScreenspaceEffects",function()
	if GAMEMODE.SpectateMode!=5 then
		local Wep=LocalPlayer():GetActiveWeapon()
		if((Wep.AimPerc)and(Wep.AimPerc>99)) then
			if(Wep.Scoped and (not(Wep.DetachableScope) or Wep.DrawnAttachments["Scope"])) and not(IsValid(LocalPlayer():GetNWEntity("Fake"))) then
				local W,H=ScrW(),ScrH()
				surface.SetDrawColor(255,255,255,255)
				--[[if not(client.JackaHMCDNoScopeAberration)then
					surface.SetTexture(AbbMat)
					surface.DrawTexturedRect(-1,-1,W+1,H+1)
				end]]
				surface.SetTexture(ScpMat)
				if Wep:GetClass()=="wep_jack_hmcd_crossbow" then
					local Mul=H/1080
					surface.SetDrawColor(0,0,0,255)
					surface.DrawRect( W/2-60, H/2+50*Mul, 65, 2 )
					surface.SetTextPos(W/2-60,H/2+37*Mul+5*(Mul-2))
					surface.SetTextColor(0,0,0,255)
					surface.SetFont("CrossbowText")
					surface.DrawText("20", false)
					surface.DrawRect( W/2-80, H/2+130*Mul, 85, 2 )
					surface.SetTextPos(W/2-80,H/2+117*Mul+5*(Mul-2))
					surface.SetTextColor(0,0,0,255)
					surface.SetFont("CrossbowText")
					surface.DrawText("30", false)
					surface.DrawRect( W/2-100, H/2+210*Mul, 105, 2 )
					surface.SetTextPos(W/2-100,H/2+197*Mul+5*(Mul-2))
					surface.SetTextColor(0,0,0,255)
					surface.SetFont("CrossbowText")
					surface.DrawText("40", false)
				end
				surface.DrawTexturedRect(-1,-1,W+1,H+1)
				surface.SetDrawColor(0,0,0,255)
				if not(Wep.Binocular) then
					surface.DrawRect(0,(H/2),W,2)
					surface.DrawRect((W/2)+5,-1,2,H+1)
				else
					local widthmul=W/2560*1.2
					surface.DrawRect(W/2-5,H/2,10,1)
					surface.DrawRect(W/2,H/2-5,1,10)
					for i=1,2 do
						surface.DrawRect(W/2,H/2-20-16*(i-1),1,10)
						surface.DrawRect(W/2-6,H/2-23-16*(i-1),14,1)
					end
					for i=1,9 do
						local mul=1
						if i % 2 == 1 then mul=0.5 end
						surface.DrawRect(W/2-5-i*64*widthmul,H/2-5*mul,1,20*mul)
						surface.DrawRect(W/2+5+i*64*widthmul,H/2-5*mul,1,20*mul)
						if i % 4 == 0 then
							surface.SetTextColor(0,0,0,255)
							surface.SetFont("BinocularNums")
							surface.SetTextPos(W/2-10-i*64*widthmul,H/2-15)
							surface.DrawText(tostring(i*5), false)
							surface.SetTextPos(W/2-2+i*64*widthmul,H/2-15)
							surface.DrawText(tostring(i*5), false)
						end
					end
				end
			end
		end
		local spectatee=LocalPlayer()
		if IsValid(GAMEMODE.Spectatee) then spectatee=GAMEMODE.Spectatee end
		if spectatee.Unconscious or (spectatee.Headcrabbed and spectatee.Alive and spectatee:Alive()) then
			surface.SetDrawColor(0,0,0,255)
			surface.DrawRect( -5,-5,ScrW()+5,ScrH()+5 )
		end
		if spectatee.BlindedTime then
			surface.SetDrawColor(255,255,255,255+(spectatee.BlindedTime-CurTime())*50)
			surface.DrawRect( 0,0,ScrW(),ScrH() )
			if 255+(spectatee.BlindedTime-CurTime())*50<0 then spectatee.BlindedTime=nil end
		end
		if spectatee.Adrenaline and spectatee.Adrenaline>1 then
			DrawSharpen(spectatee.Adrenaline/100,spectatee.Adrenaline/100)
		end
		if spectatee.Morphine and spectatee.Morphine>1 then
			local morphine=spectatee.Morphine
			morphineTab[ "$pp_colour_contrast" ]=1+morphine/3600
			morphineTab[ "$pp_colour_colour" ]=1+morphine/3600
			DrawBloom( morphine/7200, morphine/900, morphine/210, morphine/210, 1, 1, 1, 1, 1 )
			DrawColorModify(morphineTab)
		end
		if spectatee.InfectionStartTime then
			local timepassed=CurTime()-spectatee.InfectionStartTime
			-- Draw Veins and shit			
			-- Colormods
			local tab = {}
			tab[ "$pp_colour_addr" ] = 0
			tab[ "$pp_colour_addg" ] = 0
			tab[ "$pp_colour_addb" ] = 0
			tab[ "$pp_colour_brightness" ] = 0
			tab[ "$pp_colour_contrast" ] = math.Clamp(1-((1/120)*(timepassed-10))*1.1,0,1)
			tab[ "$pp_colour_colour" ] = math.Clamp(1+((timepassed/217)*-8),0,1)
			tab[ "$pp_colour_mulr" ] = 0
			tab[ "$pp_colour_mulg" ] = 0
			tab[ "$pp_colousr_mulb" ] = 0 
			DrawColorModify( tab )			
			-- End
			
			local tex = surface.GetTextureID("vgui/hud/infection")
			surface.SetTexture(tex)
			surface.SetDrawColor( 255, 255, 255,(timepassed/255)*255 )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
					
			DrawMotionBlur( 0.09, (  (1/137)*timepassed), 0)

					
			if timepassed>=207 or not(spectatee:Alive()) or not(spectatee.InfectionStartTime) then
				spectatee.InfectionStartTime=nil
				if LocalPlayer()==spectatee then spectatee.infectionsound:FadeOut(1) end
			end	
		end
		if spectatee.ZombieVisionDir then
			local client=LocalPlayer()
			client.ZombieVision=math.Clamp(client.ZombieVisionOnChange+(CurTime()-client.ZombieVisionStart)*client.ZombieVisionDir,0,1)
			if client.ZombieVision==0 then client.ZombieVisionDir=nil end
			local Close,Playa,Red=nil,nil,0
			for key,ply in pairs(team.GetPlayers(2))do
				if(not(ply==client)and(ply:Alive()))then
					local Dist=ply:GetPos():Distance(spectatee:GetPos())
					if not(Close) or Dist<Close then Close=Dist;Playa=ply end
				end
			end
			local mul=client.ZombieVision
			if(Playa)then
				local DotProduct=client:GetAimVector():DotProduct((Playa:GetPos()-spectatee:GetPos()):GetNormalized())
				local ApproachAngle=(-math.deg(math.asin(DotProduct))+90)
				local AngFrac=1-(ApproachAngle/180)
				Red=Red+(AngFrac^5)
				local DistFrac=math.Clamp(1-(Close/1000),0,1)
				Red=Red+DistFrac*2
				WHOTBackTab["$pp_colour_mulr"]=Red/2*mul
				WHOTBackTab["$pp_colour_addr"]=Red/15*mul
				WHOTBackTab["$pp_colour_colour"]=1-mul
				WHOTBackTab["$pp_colour_brightness"]=-.05*mul
			end
			DrawColorModify(WHOTBackTab)
		end
		if spectatee.CarbonInhaled and spectatee.CarbonInhaled>0 then
			DrawMotionBlur( spectatee.CarbonInhaled/200, spectatee.CarbonInhaled/100, 0.01 )
			DrawSharpen( spectatee.CarbonInhaled/50, spectatee.CarbonInhaled/25)
		end
	end
end)

function GM:HUDDrawTargetID()
	-- overwriting the function so that it doesnt do anything
end

function GM:HUDDrawPickupHistory()

end

function GM:OpenAmmoDropMenu()
	local Ply,AmmoType,AmmoAmt,Ammos=LocalPlayer(),"Pistol",1,{}
	
	for key,name in pairs(HMCD_AmmoNames)do
		local Amt=Ply:GetAmmoCount(key)
		if(Amt>0)then Ammos[key]=Amt end
	end
	
	if(#table.GetKeys(Ammos)<=0)then
		Ply:ChatPrint("You have no ammo!")
		return
	end
	
	AmmoType=table.GetKeys(Ammos)[1]
	AmmoAmt=Ammos[AmmoType]

	local DermaPanel=vgui.Create("DFrame")
	DermaPanel:SetPos(40,80)
	DermaPanel:SetSize(300,300)
	DermaPanel:SetTitle("Drop Ammo")
	DermaPanel:SetVisible(true)
	DermaPanel:SetDraggable(true)
	DermaPanel:ShowCloseButton(true)
	DermaPanel:MakePopup()
	DermaPanel:Center()

	local MainPanel=vgui.Create("DPanel",DermaPanel)
	MainPanel:SetPos(5,25)
	MainPanel:SetSize(290,270)
	MainPanel.Paint=function()
		surface.SetDrawColor(0,20,40,255)
		surface.DrawRect(0,0,MainPanel:GetWide(),MainPanel:GetTall()+3)
	end
	
	local SecondPanel=vgui.Create("DPanel",MainPanel)
	SecondPanel:SetPos(100,177)
	SecondPanel:SetSize(180,20)
	SecondPanel.Paint=function()
		surface.SetDrawColor(100,100,100,255)
		surface.DrawRect(0,0,SecondPanel:GetWide(),SecondPanel:GetTall()+3)
	end
	
	local amtselect=vgui.Create("DNumSlider",MainPanel)
	amtselect:SetPos(10,170)
	amtselect:SetWide(290)
	amtselect:SetText("Amount")
	amtselect:SetMin(1)
	amtselect:SetMax(AmmoAmt)
	amtselect:SetDecimals(0)
	amtselect:SetValue(AmmoAmt)
	amtselect.OnValueChanged=function(panel,val)
		AmmoAmt=math.Round(val)
	end
	
	local AmmoList=vgui.Create("DListView",MainPanel)
	AmmoList:SetMultiSelect(false)
	AmmoList:AddColumn("Type")
	for key,amm in pairs(Ammos)do
		AmmoList:AddLine(HMCD_AmmoNames[key]).Type=key
	end
	AmmoList:SetPos(5,5)
	AmmoList:SetSize(280,150)
	AmmoList.OnRowSelected=function(panel,ind,row)
		AmmoType=row.Type
		AmmoAmt=Ammos[AmmoType]
		amtselect:SetMax(AmmoAmt)
		amtselect:SetValue(AmmoAmt)
	end
	AmmoList:SelectFirstItem()
	
	local gobutton=vgui.Create("Button",MainPanel)
	gobutton:SetSize(270,40)
	gobutton:SetPos(10,220)
	gobutton:SetText("Drop")
	gobutton:SetVisible(true)
	gobutton.DoClick=function()
		DermaPanel:Close()
		RunConsoleCommand("hmcd_droprequest_ammo",AmmoType,tostring(AmmoAmt))
	end
end

function GM:OpenEquipmentDropMenu()
	local ply,eqType=LocalPlayer(),""
	if(table.Count(ply.Equipment)<=0)then
		ply:ChatPrint("You have no equipment!")
		return
	end
	
	local size=ScrW()/8.5
	local DermaPanel=vgui.Create("DFrame")
	DermaPanel:SetPos(size/7.5,size/3.75)
	DermaPanel:SetSize(size,size)
	DermaPanel:SetTitle("Drop Equipment")
	DermaPanel:SetVisible(true)
	DermaPanel:SetDraggable(true)
	DermaPanel:ShowCloseButton(true)
	DermaPanel:MakePopup()
	DermaPanel:Center()

	local MainPanel=vgui.Create("DPanel",DermaPanel)
	MainPanel:SetPos(size/60,size/12)
	MainPanel:SetSize(size*0.96,size*0.9)
	MainPanel.Paint=function()
		surface.SetDrawColor(0,20,40,255)
		surface.DrawRect(0,0,MainPanel:GetWide(),MainPanel:GetTall())
	end

	local amtselect=vgui.Create("DNumSlider",MainPanel)

	local EquipmentList=vgui.Create("DListView",MainPanel)
	EquipmentList:SetMultiSelect(false)
	EquipmentList:AddColumn("Type")
	for key,amm in pairs(ply.Equipment)do
		EquipmentList:AddLine(key).Type=table.KeyFromValue(HMCD_EquipmentNames,key)
	end
	EquipmentList:SetPos(5,5)
	EquipmentList:SetSize(size*0.93,size*0.5)
	EquipmentList.OnRowSelected=function(panel,ind,row)
		eqType=row.Type
	end
	EquipmentList:SelectFirstItem()

	local gobutton=vgui.Create("Button",MainPanel)
	gobutton:SetSize(size*0.9,size*0.15)
	gobutton:SetPos(size/30,size*0.73)
	gobutton:SetText("Drop")
	gobutton:SetVisible(true)
	gobutton.DoClick=function()
		DermaPanel:Close()
		ply.Equipment[HMCD_EquipmentNames[eqType]]=nil
		RunConsoleCommand("hmcd_dropequipment",eqType)
	end
end

function GM:OpenAttachmentMenu()
	local ply,Wep,attType=LocalPlayer(),LocalPlayer():GetActiveWeapon(),0
	local List={}
	if IsValid(Wep) then
		local atts={}
		if Wep.Attachments and Wep.Attachments["Owner"] then
			for attachment,info in pairs(Wep.Attachments["Owner"]) do
				if info.num then
					if(Wep:GetNWBool(attachment)) and not(ply.Equipment[HMCD_EquipmentNames[info.num]]) then
						table.insert(List,info.num)
					end
					table.insert(atts,info.num)
				end
			end
		end
		if ply.Equipment then
			for i,attachment in pairs(atts) do
				if(ply.Equipment[HMCD_EquipmentNames[attachment]])then
					table.insert(List,attachment)
				end
			end
		end	
	end
	if(#List<=0)then
		ply:ChatPrint("You have no attachments!")
		return
	end
	local size=ScrW()/8.5
	local DermaPanel=vgui.Create("DFrame")
	DermaPanel:SetPos(size/7.5,size/3.75)
	DermaPanel:SetSize(size,size)
	DermaPanel:SetTitle("Customize your weapon")
	DermaPanel:SetVisible(true)
	DermaPanel:SetDraggable(true)
	DermaPanel:ShowCloseButton(true)
	DermaPanel:MakePopup()
	DermaPanel:Center()

	local MainPanel=vgui.Create("DPanel",DermaPanel)
	MainPanel:SetPos(size/60,size/12)
	MainPanel:SetSize(size*0.96,size*0.9)
	MainPanel.Paint=function()
		surface.SetDrawColor(0,20,40,255)
		surface.DrawRect(0,0,MainPanel:GetWide(),MainPanel:GetTall()+3)
	end

	local amtselect=vgui.Create("DNumSlider",MainPanel)

	local AttachmentList=vgui.Create("DListView",MainPanel)
	AttachmentList:SetMultiSelect(false)
	AttachmentList:AddColumn("Type")
	for i,att in pairs(List)do
		AttachmentList:AddLine(HMCD_EquipmentNames[List[i]]).Type=att
	end
	AttachmentList:SetPos(5,5)
	AttachmentList:SetSize(size*0.93,size*0.5)
	AttachmentList.OnRowSelected=function(panel,ind,row)
		attType=row.Type
	end
	AttachmentList:SelectFirstItem()
	local gobutton=vgui.Create("Button",MainPanel)
	gobutton:SetSize(size*0.9,size*0.15)
	gobutton:SetPos(size/30,size*0.73)
	gobutton:SetText("Attach")
	gobutton:SetVisible(true)
	gobutton.DoClick=function()
		DermaPanel:Close()
		RunConsoleCommand("hmcd_attachrequest",attType)
	end
end

net.Receive("hmcd_updateinventory",function()
	local body,info,index=net.ReadEntity(),net.ReadTable(),net.ReadInt(13)
	if IsValid(body) then
		if table.Count(info)==0 then info=nil end
		if info==nil and body.Inventory and body.Inventory[index] and body.WepsToRender and body.WepsToRender[body.Inventory[index]["Class"]] then
			for class,atts in pairs(body.WepsToRender) do
				for j,att in pairs(atts) do
					if IsValid(body.RenderedWeapons[body.Inventory[index]["Class"].."_"..j]) then
						body.RenderedWeapons[body.Inventory[index]["Class"].."_"..j]:Remove()
						body.RenderedWeapons[body.Inventory[index]["Class"].."_"..j]=nil
					end
				end
			end
			body.WepsToRender[body.Inventory[index]["Class"]]=nil
		end
		if body.Inventory then body.Inventory[index]=info end
	end
end)

net.Receive("hmcd_updateinventory_ammo",function()
	local body,info,index=net.ReadEntity(),net.ReadTable(),net.ReadInt(13)
	if IsValid(body) and body.InventoryAmmo then
		if table.Count(info)==0 then info=nil end
		body.InventoryAmmo[index]=info
	end
end)

net.Receive("hmcd_updateinventory_equipment",function()
	local body,info,index=net.ReadEntity(),net.ReadTable(),net.ReadInt(13)
	if IsValid(body) and body.InventoryEquipment then
		if table.Count(info)==0 then info=nil end
		body.InventoryEquipment[index]=info
	end
end)

local function findRowAndColumn(x,y)
	local Row = math.ceil(y / 52)
	if x<=62 then Column=1 return Row,Column end
	local Column = math.ceil((x-62) / 52 + 1)
	return Row,Column
end

local RoundTexturesInv={
	["Pistol"]=Material("vgui/hud/hmcd_round_9"),
	["12mmRound"]=Material("vgui/hud/hmcd_round_918"),
	["357"]=Material("vgui/hud/hmcd_round_38"),
	["AlyxGun"]=Material("vgui/hud/hmcd_round_22"),
	["Buckshot"]=Material("vgui/hud/hmcd_round_12"),
	["AR2"]=Material("vgui/hud/hmcd_round_792"),
	["SMG1"]=Material("vgui/hud/hmcd_round_556"),
	["XBowBolt"]=Material("vgui/hud/hmcd_round_arrow"),
	["AirboatGun"]=Material("vgui/hud/hmcd_nail"),
	["HelicopterGun"]=Material("vgui/hud/hmcd_round_4630"),
	["StriderMinigun"]=Material("pwb/sprites/hmcd_round_762"),
	["SniperRound"]=Material("vgui/hud/hmcd_round_76239"),
	["RPG_Round"]=Material("pwb/sprites/hmcd_round_rpg"),
	["SniperPenetratedRound"]=Material("vgui/hud/hmcd_taser_cartridge"),
	["Thumper"]=Material("vgui/hud/hmcd_crossbow_bolt"),
	["Gravity"]=Material("vgui/hud/hmcd_round_impulse"),
	["Hornet"]=Material("vgui/hud/hmcd_round_beanbag"),
	["9mmRound"]=Material("vgui/hud/hmcd_round_beanshot9"),
	["MP5_Grenade"]=Material("vgui/hud/hmcd_energy_charge"),
	["CombineCannon"]=Material("vgui/hud/hmcd_round_145")
}

local forbiddenItems={
	["combine"]={
		["Maglite ML300LX-S3CC6L Flashlight"]=true,
		["Advanced Combat Helmet"]=true
	},
	["freeman"]={
		["Advanced Combat Helmet"]=true,
		["Level IIIA Armor"]=true
	},
	["rebel"]={
		["Level IIIA Armor"]="wt"
	},
	["terminator"]={
		["Advanced Combat Helmet"]=true,
		["Level IIIA Armor"]=true,
		["Maglite ML300LX-S3CC6L Flashlight"]=true,
		["Level III Armor"]=true,
		["Ground Panoramic Night Vision Goggles"]=true
	}
}

function GM:LootBody(body)
	if IsValid(Frame) then return end
	Frame=vgui.Create("DFrame")
	Frame:SetPos(40,80)
	Frame:SetSize(600,450)
	Frame:SetTitle(tostring(body:GetNWString("bystanderName")).."'s body")
	Frame:SetVisible(true)
	Frame:SetDraggable(true)
	Frame:ShowCloseButton(true)
	Frame:MakePopup()
	Frame:Center()
	Frame.Paint=function()
		surface.SetDrawColor(20,20,20,120)
		surface.DrawRect(0,0,Frame:GetWide(),Frame:GetTall()+3)
	end
	local MainPanel=vgui.Create("DPanel",Frame)
	MainPanel:SetPos(5,25)
	MainPanel:SetSize(590,420)
	MainPanel.Paint=function()
		surface.SetDrawColor(20,20,20,120)
		surface.DrawRect(0,0,MainPanel:GetWide(),MainPanel:GetTall()+3)
	end
	local forbiddenspots={}
	local forbiders={}
	local length,gap = 50,10
	local itemframes={}
	local items={}
	local ammoframes={}
	local ammo={}
	local equipmentframes={}
	local equipment={}
	local ammocount={}
	local curlevel=0
	local mul=0
	if body.Inventory!=nil then
		for i, item in pairs(body.Inventory) do
			local iconlength = body.Inventory[i]["Length"] or 1
			local iconheight = body.Inventory[i]["Height"] or 1
			if (mul+iconlength)*length+gap*mul/5>570 then
				mul=0
				curlevel=curlevel+1
			end
			local row, column = findRowAndColumn(mul*length+gap*mul/5+5,curlevel*length+gap+5)
			while table.HasValue(forbiddenspots,tostring(row).."+"..tostring(column)) do
				local add=1
				if forbiders[table.KeyFromValue(forbiddenspots,tostring(row).."+"..tostring(column))]!=nil then add = forbiders[table.KeyFromValue(forbiddenspots,tostring(row).."+"..tostring(column))] end
				mul=mul+add
				if mul*length+gap*mul/5>570 then
					mul=0
					curlevel=curlevel+1
				end
				row, column = findRowAndColumn(mul*length+gap*mul/5+5,curlevel*length+gap+5)
			end
			itemframes[i]=vgui.Create("DPanel",MainPanel)
			itemframes[i]:SetPos(mul*length+gap*mul/5,curlevel*length+gap*curlevel/5)
			if iconheight>1 then
				for i=1,iconheight-1 do
					table.insert(forbiddenspots,tostring(row+i).."+"..tostring(column))
					table.insert(forbiders,iconlength)
				end
			end
			itemframes[i]:SetSize(length*iconlength+gap*(iconlength-1)/5,length*iconheight+gap*(iconheight-1)/5)
			itemframes[i].Color=Color(64,64,64,105)
			itemframes[i].Paint=function()
				surface.SetDrawColor(itemframes[i].Color)
				surface.DrawRect(0,0,length*iconlength+gap*(iconlength-1)/5,length*iconheight+gap*(iconheight-1)/5)
			end
			items[i] = vgui.Create("DButton", itemframes[i])
			items[i]:SetPos(2,2)
			items[i]:SetSize((length*iconlength)-4,(length*iconheight)-4)
			items[i]:SetText("")
			items[i].Color=Color(255, 255, 255, 255)
			local item_mat=Material(body.Inventory[i]["Texture"])
			items[i].Paint = function( sel, w, h )
				if IsValid(body) and body.Inventory[i] and item_mat then
					surface.SetDrawColor( items[i].Color )
					surface.SetMaterial( item_mat )
					surface.DrawTexturedRect( 0, 0, (length*iconlength)-5, (length*iconheight)-5 )
				end
			end
			items[i].DoRightClick = function()
				if body.Inventory[i] and not(LocalPlayer():HasWeapon(body.Inventory[i]["Class"]) and not(body.Inventory[i]["Stackable"])) then
					if body.Inventory[i]["Class"]=="wep_jack_hmcd_birbake" then
						LocalPlayer():PrintMessage(HUD_PRINTTALK,"This does not belong to you.")
						return
					end
					net.Start("hmcd_give")
					net.WriteEntity(body)
					net.WriteInt(i,13)
					net.SendToServer()
					if body.WepsToRender and body.WepsToRender[body.Inventory[i]["Class"]] then
						for class,atts in pairs(body.WepsToRender) do
							for j,att in pairs(atts) do
								if IsValid(body.RenderedWeapons[body.Inventory[i]["Class"].."_"..j]) then
									body.RenderedWeapons[body.Inventory[i]["Class"].."_"..j]:Remove()
									body.RenderedWeapons[body.Inventory[i]["Class"].."_"..j]=nil
								end
							end
						end
						body.WepsToRender[body.Inventory[i]["Class"]]=nil
					end
					body.Inventory[i]=nil
					items[i]:Remove()
					itemframes[i]:Remove()
					if MainPanel.PanelPartition then
						MainPanel.PanelPartition:Remove()
						MainPanel.PreviewIconFrame:Remove()
						if MainPanel.PickUp then
							MainPanel.PickUp:Remove()
						end
						if MainPanel.Unload then 
							MainPanel.Unload:Remove()
						end
						if MainPanel.Poison then
							MainPanel.Poison:Remove()
						end
						if PoisonFood then
							PoisonFood:Remove()
						end
						if PoisonTouch then
							PoisonTouch:Remove()
						end
						if PoisonBlade then
							PoisonBlade:Remove()
						end
						if MainPanel.TextBox then
							MainPanel.TextBox:Remove()
						end
						if MainPanel.Slider then
							MainPanel.Slider:Remove()
						end
						if MainPanel.AmmoTake then
							MainPanel.AmmoTake:Remove()
						end
						Frame:SetTall(450)
						MainPanel:SetTall(420)
					end
				else
					if body.Inventory[i] then
						LocalPlayer():PrintMessage(HUD_PRINTTALK,"You already have this item.")
					end
				end
			end
			items[i].DoClick = function()
				if body.Inventory and not(items[i].NextClick) or items[i].NextClick<CurTime() then
					--[[itemframes[i].Color=Color(128,128,128,105)
					itemframes[i].Holding=true
					timer.Simple(.05,function()
						if IsValid(body.Inventory) and IsValid(itemframes[i]) then 
							itemframes[i].Holding=false
						end
					end)]]
					if MainPanel.PanelPartition then 
						MainPanel.PanelPartition:Remove()
						MainPanel.PreviewIconFrame:Remove()
						if MainPanel.TextBox then
							MainPanel.TextBox:Remove()
						end
						if MainPanel.Slider then
							MainPanel.Slider:Remove()
						end
						if MainPanel.AmmoTake then
							MainPanel.AmmoTake:Remove()
						end
						if MainPanel.PickUp then
							MainPanel.PickUp:Remove()
						end
						if MainPanel.Unload then 
							MainPanel.Unload:Remove()
						end
						if MainPanel.Poison then
							MainPanel.Poison:Remove()
						end
						if PoisonFood then
							PoisonFood:Remove()
						end
						if PoisonTouch then
							PoisonTouch:Remove()
						end
						if PoisonBlade then
							PoisonBlade:Remove()
						end
						Frame:SetTall(450)
						MainPanel:SetTall(420)
					end
					local PanelPartition=vgui.Create("DPanel",MainPanel)
					PanelPartition:SetPos(0,Frame:GetTall())
					PanelPartition:SetSize(Frame:GetWide(),20)
					PanelPartition.Entitynum=i
					MainPanel.PanelPartition=PanelPartition
					local partx,party = PanelPartition:GetPos()
					Frame:SetTall(party+250)
					MainPanel:SetTall(party+245)
					PanelPartition.Paint=function()
						surface.SetDrawColor(64,64,64,105)
						surface.DrawRect(0,0,MainPanel:GetWide(),MainPanel:GetTall()+3)
					end
					PreviewIconFrame=vgui.Create("DPanel",MainPanel)
					PreviewIconFrame:SetPos(5, MainPanel:GetTall()-175)
					if iconlength==1 and iconheight==1 then
						PreviewIconFrame:SetSize(75*iconlength,75*iconheight)
					else
						PreviewIconFrame:SetSize(itemframes[i]:GetWide(),itemframes[i]:GetTall())
					end
					PreviewIconFrame.Paint=function()
						surface.SetDrawColor(64,64,64,105)
						surface.DrawRect(0,0,PreviewIconFrame:GetWide(),PreviewIconFrame:GetTall())
					end
					MainPanel.PreviewIconFrame=PreviewIconFrame
					PreviewIcon=vgui.Create("DButton",PreviewIconFrame)
					if iconlength==1 and iconheight==1 then
						PreviewIcon:SetPos(10,10)
						PreviewIcon:SetSize(60*iconlength,60*iconheight)
					else
						PreviewIcon:SetPos(2,2)
						PreviewIcon:SetSize(items[i]:GetWide(),items[i]:GetTall())
					end
					PreviewIcon:SetText("")
					PreviewIcon.Paint = function( sel, w, h )
						if body.Inventory[i] and item_mat then
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.SetMaterial( item_mat )
							surface.DrawTexturedRect( 0, 0, PreviewIcon:GetWide(), PreviewIcon:GetTall() )
						end
					end
					local instructions = body.Inventory[i]["Instructions"] or ""
					if string.find(instructions,"\n",1,true)!=nil then
						instructions=string.Left(instructions,string.find(instructions,"\n",1,true))
					end
					local postofind=35
					local lineamt=1
					if postofind<string.len(instructions) then
						while postofind<string.len(instructions) do
							local spacefound = string.find(instructions, " ", postofind,false)
							if spacefound!=nil then
								instructions = string.SetChar(instructions,spacefound,"\n")
							end
							postofind=postofind+35
							lineamt=lineamt+1
						end
					end
					local previewposx,previewposy=PreviewIconFrame:GetPos()
					TextBox = vgui.Create("DLabel",MainPanel)
					TextBox:SetPos(PreviewIcon:GetWide()+50,previewposy)
					TextBox:SetSize(250,45+lineamt*10)
					TextBox:SetText(instructions)
					MainPanel.TextBox=TextBox
					PickUp = vgui.Create("DButton", MainPanel)
					PickUp:SetPos(PanelPartition:GetWide()-100,MainPanel:GetTall()-150)
					PickUp:SetSize(80,50)
					PickUp:SetText("Take item")
					MainPanel.PickUp=PickUp
					PickUp.DoClick = function()
						if body.Inventory[i] and not(LocalPlayer():HasWeapon(body.Inventory[i]["Class"]) and not(body.Inventory[i]["Stackable"])) then
							if body.Inventory[i]["Class"]=="wep_jack_hmcd_birbake" then
								LocalPlayer():PrintMessage(HUD_PRINTTALK,"This does not belong to you.")
								return
							end
							net.Start("hmcd_give")
							net.WriteEntity(body)
							net.WriteInt(i,13)
							net.SendToServer()
							if body.WepsToRender and body.WepsToRender[body.Inventory[i]["Class"]] then
								for class,atts in pairs(body.WepsToRender) do
									for j,att in pairs(atts) do
										if IsValid(body.RenderedWeapons[body.Inventory[i]["Class"].."_"..j]) then
											body.RenderedWeapons[body.Inventory[i]["Class"].."_"..j]:Remove()
											body.RenderedWeapons[body.Inventory[i]["Class"].."_"..j]=nil
										end
									end
								end
								body.WepsToRender[body.Inventory[i]["Class"]]=nil
							end
							body.Inventory[i]=nil
							items[i]:Remove()
							itemframes[i]:Remove()
							if MainPanel.PanelPartition then 
								MainPanel.PanelPartition:Remove()
								MainPanel.PreviewIconFrame:Remove()
								MainPanel.TextBox:Remove()
								Frame:SetTall(Frame:GetTall()-250)
								MainPanel:SetTall(MainPanel:GetTall()-245)
							end
						else
							if body.Inventory[i] then
								LocalPlayer():PrintMessage(HUD_PRINTTALK,"You already have this item.")
							end
						end
					end
					if body.Inventory[i]["Ammo"] and body.Inventory[i]["Ammo"]>0 then
						Unload = vgui.Create("DButton", MainPanel)
						Unload:SetPos(PanelPartition:GetWide()-100,MainPanel:GetTall()-90)
						Unload:SetSize(80,50)
						Unload:SetText("Unload Weapon")
						Unload.DoClick=function()
							body.Inventory[i]["Ammo"]=0
							net.Start("hmcd_unload")
							net.WriteEntity(body)
							net.WriteInt(i,13)
							net.SendToServer()
							Unload:Remove()
						end
						MainPanel.Unload=Unload
					end
					local poisons,poisonnum,poisontouch,poisonblade,poisonfood=0,0,false,false,false
					if LocalPlayer():HasWeapon("wep_jack_hmcd_poisonliquid") then poisontouch=true poisons=poisons+1 end
					if LocalPlayer():HasWeapon("wep_jack_hmcd_poisongoo") and body.Inventory[i]["Poisonable"]==true then poisonblade=true poisons=poisons+1 end
					if LocalPlayer():HasWeapon("wep_jack_hmcd_poisonpowder") and (body.Inventory[i]["Class"]=="wep_jack_hmcd_fooddrink" or body.Inventory[i]["Class"]=="wep_jack_hmcd_painpills") then poisonfood=true poisons=poisons+1 end
					if poisontouch or poisonblade or poisonfood then
						Poison = vgui.Create("DButton", MainPanel)
						Poison:SetPos(PanelPartition:GetWide()-100,MainPanel:GetTall()-210)
						Poison:SetSize(80,50)
						Poison:SetText("Poison with...")
						MainPanel.Poison=Poison
						Poison.DoClick=function()
							if poisontouch then
								poisonnum=poisonnum+1
								PoisonTouch = vgui.Create("DButton", MainPanel)
								PoisonTouch:SetPos(PanelPartition:GetWide()-100,MainPanel:GetTall()-210+(poisonnum-1)*(50/poisons))
								PoisonTouch:SetSize(80,50/poisons)
								PoisonTouch:SetText("VX Vial")
								PoisonTouch.DoClick=function()
									net.Start("hmcd_remove")
									net.WriteEntity(LocalPlayer():GetWeapon("wep_jack_hmcd_poisonliquid"))
									net.SendToServer()
									sound.Play("snd_jack_hmcd_needleprick.wav",LocalPlayer():GetShootPos(),45,math.random(90,110))
									body.Inventory[i].ContactPoisoned=true
									body.Inventory[i].Poisoner=LocalPlayer()
									net.Start("hmcd_updateinventory_sv")
									net.WriteEntity(body)
									net.WriteInt(i,13)
									net.WriteTable(body.Inventory[i])
									net.SendToServer()
									PoisonTouch:Remove()
								end
							end
							if poisonfood then
								poisonnum=poisonnum+1
								PoisonFood = vgui.Create("DButton", MainPanel)
								PoisonFood:SetPos(PanelPartition:GetWide()-100,MainPanel:GetTall()-210+(poisonnum-1)*(50/poisons))
								PoisonFood:SetSize(80,50/poisons)
								PoisonFood:SetText("Cyanide Capsule")
								PoisonFood.DoClick=function()
									net.Start("hmcd_remove")
									net.WriteEntity(LocalPlayer():GetWeapon("wep_jack_hmcd_poisonpowder"))
									net.SendToServer()
									sound.Play("snd_jack_hmcd_needleprick.wav",LocalPlayer():GetShootPos(),45,math.random(90,110))
									body.Inventory[i].Poisoner=LocalPlayer()
									body.Inventory[i].Poisoned=true
									net.Start("hmcd_updateinventory_sv")
									net.WriteEntity(body)
									net.WriteInt(i,13)
									net.WriteTable(body.Inventory[i])
									net.SendToServer()
									PoisonFood:Remove()
								end
							end
							if poisonblade then
								poisonnum=poisonnum+1
								PoisonBlade = vgui.Create("DButton", MainPanel)
								PoisonBlade:SetPos(PanelPartition:GetWide()-100,MainPanel:GetTall()-210+(poisonnum-1)*(50/poisons))
								PoisonBlade:SetSize(80,50/poisons)
								PoisonBlade:SetText("Curare Vial")
								PoisonBlade.DoClick=function()
									net.Start("hmcd_remove")
									net.WriteEntity(LocalPlayer():GetWeapon("wep_jack_hmcd_poisongoo"))
									net.SendToServer()
									LocalPlayer():EmitSound("snd_jack_hmcd_drink1.wav",55,120)
									body.Inventory[i].Poisoned=true
									body.Inventory[i].Poisoner=LocalPlayer()
									net.Start("hmcd_updateinventory_sv")
									net.WriteEntity(body)
									net.WriteInt(i,13)
									net.WriteTable(body.Inventory[i])
									net.SendToServer()
									PoisonBlade:Remove()
								end
							end
							Poison:Remove()
						end
					end
				end
			end
			mul=mul+iconlength
		end
	end
	if body.InventoryAmmo then
		for i, ammos in pairs(body.InventoryAmmo) do
			if body.InventoryAmmo[i] and body.InventoryAmmo[i]["Amount"] and body.InventoryAmmo[i]["Amount"]>0 then
				if (mul+1)*length+gap*mul/5>570 then
					mul=0
					curlevel=curlevel+1
				end
				local row, column = findRowAndColumn(mul*length+gap*mul/5+5,curlevel*length+gap+5)
				while table.HasValue(forbiddenspots,tostring(row).."+"..tostring(column)) do
					local add=1
					if forbiders[table.KeyFromValue(forbiddenspots,tostring(row).."+"..tostring(column))]!=nil then add = forbiders[table.KeyFromValue(forbiddenspots,tostring(row).."+"..tostring(column))] end
					mul=mul+add
					if mul*length+gap*mul/5>570 then
						mul=0
						curlevel=curlevel+1
					end
					row, column = findRowAndColumn(mul*length+gap*mul/5+5,curlevel*length+gap+5)
				end
				ammoframes[i]=vgui.Create("DPanel",MainPanel)
				ammoframes[i]:SetPos(mul*length+gap*mul/5,curlevel*length+gap*curlevel/5)
				ammoframes[i]:SetSize(length,length)
				ammoframes[i].Color=Color(64,64,64,105)
				ammoframes[i].Paint=function()
					surface.SetDrawColor(ammoframes[i].Color)
					surface.DrawRect(0,0,ammoframes[i]:GetWide(),ammoframes[i]:GetTall())
				end
				ammo[i] = vgui.Create("DButton", ammoframes[i])
				ammo[i]:SetPos(2,2)
				ammo[i]:SetSize(ammoframes[i]:GetWide()-4,ammoframes[i]:GetTall()-4)
				ammo[i]:SetText("")
				ammo[i].Color=Color(255, 255, 255, 255)
				local ammo_mat=RoundTexturesInv[ammos["Name"]]
				ammo[i].Paint = function( sel, w, h )
					if IsValid(body) and body.InventoryAmmo and body.InventoryAmmo[i] then
						surface.SetDrawColor( ammo[i].Color )
						surface.SetMaterial( ammo_mat )
						surface.DrawTexturedRect( 0, 0, ammoframes[i]:GetWide()-5, ammoframes[i]:GetTall()-5 )
					end
				end
				ammo[i].DoRightClick=function()
					if IsValid(SliderBackGround) then
						SliderBackGround:Remove() 
						AmmoTake:Remove() 
					end
					ammoframes[i]:Remove()
					net.Start("hmcd_takeammo")
					net.WriteEntity(body)
					net.WriteInt(i,13)
					net.WriteInt(body.InventoryAmmo[i]["Amount"],13)
					net.SendToServer()
					body.InventoryAmmo[i]=nil
					if MainPanel.PanelPartition then 
						MainPanel.PanelPartition:Remove()
						MainPanel.PreviewIconFrame:Remove()
						if MainPanel.PickUp then
							MainPanel.PickUp:Remove()
						end
						if MainPanel.Unload then 
							MainPanel.Unload:Remove()
						end
						if MainPanel.Poison then
							MainPanel.Poison:Remove()
						end
						if PoisonFood then
							PoisonFood:Remove()
						end
						if PoisonTouch then
							PoisonTouch:Remove()
						end
						if PoisonBlade then
							PoisonBlade:Remove()
						end
						if MainPanel.TextBox then
							MainPanel.TextBox:Remove()
						end
						if MainPanel.Slider then
							MainPanel.Slider:Remove()
						end
						if MainPanel.AmmoTake then
							MainPanel.AmmoTake:Remove()
						end
						Frame:SetTall(450)
						MainPanel:SetTall(420)
					end
				end
				ammocount[i] = vgui.Create("DButton", ammoframes[i])
				ammocount[i]:SetPos(ammoframes[i]:GetWide()-25,ammoframes[i]:GetTall()-15)
				ammocount[i]:SetSize(25,15)
				ammocount[i]:SetColor(Color(255,255,255,255))
				ammocount[i]:SetText(tostring(body.InventoryAmmo[i]["Amount"]))
				ammocount[i].OldAmt=body.InventoryAmmo[i]["Amount"]
				ammocount[i].Paint=function()
					surface.SetDrawColor( Color(255,255,255,0) )
				end
				ammo[i].DoClick=function()
					if MainPanel.PanelPartition then 
						MainPanel.PanelPartition:Remove()
						MainPanel.PreviewIconFrame:Remove()
						if MainPanel.PickUp then
							MainPanel.PickUp:Remove()
						end
						if MainPanel.Unload then 
							MainPanel.Unload:Remove()
						end
						if MainPanel.Poison then
							MainPanel.Poison:Remove()
						end
						if PoisonFood then
							PoisonFood:Remove()
						end
						if PoisonTouch then
							PoisonTouch:Remove()
						end
						if PoisonBlade then
							PoisonBlade:Remove()
						end
						if MainPanel.TextBox then
							MainPanel.TextBox:Remove()
						end
						if MainPanel.Slider then
							MainPanel.Slider:Remove()
						end
						if MainPanel.AmmoTake then
							MainPanel.AmmoTake:Remove()
						end
						Frame:SetTall(450)
						MainPanel:SetTall(420)
					end
					local PanelPartition=vgui.Create("DPanel",MainPanel)
					PanelPartition:SetPos(0,Frame:GetTall())
					PanelPartition:SetSize(Frame:GetWide(),20)
					PanelPartition.Entitynum=i
					MainPanel.PanelPartition=PanelPartition
					local partx,party = PanelPartition:GetPos()
					Frame:SetTall(party+250)
					MainPanel:SetTall(party+245)
					PanelPartition.Paint=function()
						surface.SetDrawColor(64,64,64,105)
						surface.DrawRect(0,0,MainPanel:GetWide(),MainPanel:GetTall()+3)
					end
					PreviewIconFrame=vgui.Create("DPanel",MainPanel)
					PreviewIconFrame:SetPos(5, MainPanel:GetTall()-175)
					PreviewIconFrame:SetSize(80,80)
					PreviewIconFrame.Paint=function()
						surface.SetDrawColor(64,64,64,105)
						surface.DrawRect(0,0,PreviewIconFrame:GetWide(),PreviewIconFrame:GetTall())
					end
					MainPanel.PreviewIconFrame=PreviewIconFrame
					PreviewIcon=vgui.Create("DButton",PreviewIconFrame)
					PreviewIcon:SetPos(10,10)
					PreviewIcon:SetSize(60,60)
					PreviewIcon:SetText("")
					PreviewIcon.Paint = function( sel, w, h )
						if IsValid(body) and body.InventoryAmmo and body.InventoryAmmo[i] then
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.SetMaterial( ammo_mat )
							surface.DrawTexturedRect( 0, 0, PreviewIcon:GetWide(), PreviewIcon:GetTall() )
						end
					end
					SliderBackGround=vgui.Create("DPanel", MainPanel)
					SliderBackGround:SetPos(MainPanel:GetWide()-230,MainPanel:GetTall()-175)
					SliderBackGround:SetSize(170,50)
					SliderBackGround.Paint=function()
						surface.SetDrawColor(64,64,64,105)
						surface.DrawRect(0,0,SliderBackGround:GetWide(),SliderBackGround:GetTall())
					end
					MainPanel.Slider=SliderBackGround
					Slider=vgui.Create("DNumSlider",SliderBackGround)
					Slider:SetPos(-100,0)
					Slider:SetText("")
					Slider:SetMin(1)
					Slider:SetMax(body.InventoryAmmo[i]["Amount"])
					Slider:SetWide(290)
					Slider:SetDecimals(0)
					Slider:SetValue(body.InventoryAmmo[i]["Amount"])
					Slider.Value=Slider:GetValue()
					Slider.AmmoType=ammos["Name"]
					Slider.OnValueChanged=function(panel,val)
						Slider.Value=math.Round(val)
					end
					AmmoTake=vgui.Create("DButton",MainPanel)
					local sliderposx,sliderposy=SliderBackGround:GetPos()
					AmmoTake:SetPos(sliderposx+35,sliderposy+75)
					AmmoTake:SetSize(100,50)
					AmmoTake:SetText("Take Ammo")
					MainPanel.AmmoTake=AmmoTake
					AmmoTake.DoClick=function()
						local val = Slider.Value
						body.InventoryAmmo[i]["Amount"]=body.InventoryAmmo[i]["Amount"]-val
						net.Start("hmcd_takeammo")
						net.WriteEntity(body)
						net.WriteInt(i,13)
						net.WriteInt(val,13)
						net.SendToServer()
						Slider:SetMax(body.InventoryAmmo[i]["Amount"])
						if body.InventoryAmmo[i]["Amount"]>Slider:GetMax() then
							Slider:SetValue(body.InventoryAmmo[i]["Amount"])
						end
						if body.InventoryAmmo[i]["Amount"]<=0 then 
							SliderBackGround:Remove() 
							AmmoTake:Remove() 
							ammoframes[i]:Remove()
							if MainPanel.PanelPartition then 
								MainPanel.PanelPartition:Remove()
								MainPanel.PreviewIconFrame:Remove()
								if MainPanel.Slider then
									MainPanel.Slider:Remove()
								end
								if MainPanel.AmmoTake then
									MainPanel.AmmoTake:Remove()
								end
								Frame:SetTall(450)
								MainPanel:SetTall(420)
							end
						end
						if IsValid(ammocount[i]) then
							ammocount[i]:SetText(tostring(body.InventoryAmmo[i]["Amount"]))
						end
					end
				end
				mul=mul+1
			end
		end
	end
	if body.InventoryEquipment!=nil then
		for i,equipments in pairs(body.InventoryEquipment) do
			local iconlength = body.InventoryEquipment[i]["Length"] or 1
			local iconheight = body.InventoryEquipment[i]["Height"] or 1
			if (mul+iconlength)*length+gap*mul/5>570 then
				mul=0
				curlevel=curlevel+1
			end
			local row, column = findRowAndColumn(mul*length+gap*mul/5+5,curlevel*length+gap+5)
			while table.HasValue(forbiddenspots,tostring(row).."+"..tostring(column)) do
				local add=1
				if forbiders[table.KeyFromValue(forbiddenspots,tostring(row).."+"..tostring(column))]!=nil then add = forbiders[table.KeyFromValue(forbiddenspots,tostring(row).."+"..tostring(column))] end
				mul=mul+add
				if mul*length+gap*mul/5>570 then
					mul=0
					curlevel=curlevel+1
				end
				row, column = findRowAndColumn(mul*length+gap*mul/5+5,curlevel*length+gap+5)
			end
			equipmentframes[i]=vgui.Create("DPanel",MainPanel)
			equipmentframes[i]:SetPos(mul*length+gap*mul/5,curlevel*length+gap*curlevel/5)
			if iconheight>1 then
				for i=1,iconheight-1 do
					table.insert(forbiddenspots,tostring(row+i).."+"..tostring(column))
					table.insert(forbiders,iconlength)
				end
			end
			equipmentframes[i]:SetSize(length*iconlength+gap*(iconlength-1)/5,length*iconheight+gap*(iconheight-1)/5)
			equipmentframes[i].Color=Color(64,64,64,105)
			equipmentframes[i].Paint=function()
				surface.SetDrawColor(equipmentframes[i].Color)
				surface.DrawRect(0,0,length*iconlength+gap*(iconlength-1)/5,length*iconheight+gap*(iconheight-1)/5)
			end
			equipment[i] = vgui.Create("DButton", equipmentframes[i])
			equipment[i]:SetPos(2,2)
			equipment[i]:SetSize((length*iconlength)-4,(length*iconheight)-4)
			equipment[i]:SetText("")
			equipment[i].Color=Color(255, 255, 255, 255)
			local equipment_mat=Material(body.InventoryEquipment[i]["Texture"])
			equipment[i].Paint = function( sel, w, h )
				if IsValid(body) and body.InventoryEquipment and body.InventoryEquipment[i] and body.InventoryEquipment[i]["Instructions"]!="" and body.InventoryEquipment[i]["Instructions"]!=nil then
					surface.SetDrawColor( equipment[i].Color )
					surface.SetMaterial( equipment_mat )
					surface.DrawTexturedRect( 0, 0, (length*iconlength)-5, (length*iconheight)-5 )
				end
			end
			equipment[i].DoRightClick = function()
				if not(LocalPlayer().Equipment[body.InventoryEquipment[i]["Name"]]) and not(forbiddenItems[LocalPlayer().Role] and forbiddenItems[LocalPlayer().Role][body.InventoryEquipment[i]["Name"]] and forbiddenItems[LocalPlayer().Role][body.InventoryEquipment[i]["Name"]]!=LocalPlayer():GetNWString("Class")) then
					local hassimiliarEquipment=false
					for armorTyp,inf in pairs(HMCD_ArmorNames) do
						if HMCD_ArmorNames[armorTyp][body.InventoryEquipment[i].Name] then
							if LocalPlayer():GetNWString(armorTyp)!="" then hassimiliarEquipment=true break end
						end
					end
					if not(hassimiliarEquipment) then
						net.Start("hmcd_giveequipment")
						net.WriteEntity(body)
						net.WriteInt(i,13)
						net.SendToServer()
						body.InventoryEquipment[i]=nil
						equipment[i]:Remove()
						equipmentframes[i]:Remove()
						if MainPanel.PanelPartition then 
							MainPanel.PanelPartition:Remove()
							MainPanel.PreviewIconFrame:Remove()
							if MainPanel.PickUp then
								MainPanel.PickUp:Remove()
							end
							if MainPanel.Unload then 
								MainPanel.Unload:Remove()
							end
							if MainPanel.Poison then
								MainPanel.Poison:Remove()
							end
							if PoisonFood then
								PoisonFood:Remove()
							end
							if PoisonTouch then
								PoisonTouch:Remove()
							end
							if PoisonBlade then
								PoisonBlade:Remove()
							end
							if MainPanel.TextBox then
								MainPanel.TextBox:Remove()
							end
							if MainPanel.Slider then
								MainPanel.Slider:Remove()
							end
							if MainPanel.AmmoTake then
								MainPanel.AmmoTake:Remove()
							end
							Frame:SetTall(450)
							MainPanel:SetTall(420)
						end
					else
						LocalPlayer():PrintMessage(HUD_PRINTTALK,"You already have armor for this part of body!")
					end
				else
					LocalPlayer():PrintMessage(HUD_PRINTTALK,"You already have this or a similar item!")
				end
			end
			equipment[i].DoClick = function()
				if body.InventoryEquipment and not(equipment[i].NextClick) or equipment[i].NextClick<CurTime() then
					--[[equipmentframes[i].Color=Color(128,128,128,105)
					equipmentframes[i].Holding=true
					timer.Simple(.05,function()
						if IsValid(body.InventoryEquipment) and IsValid(equipmentframes[i]) then 
							equipmentframes[i].Holding=false
						end
					end)]]
					if MainPanel.PanelPartition then 
						MainPanel.PanelPartition:Remove()
						MainPanel.PreviewIconFrame:Remove()
						if MainPanel.TextBox then
							MainPanel.TextBox:Remove()
						end
						if MainPanel.Slider then
							MainPanel.Slider:Remove()
						end
						if MainPanel.AmmoTake then
							MainPanel.AmmoTake:Remove()
						end
						if MainPanel.PickUp then
							MainPanel.PickUp:Remove()
						end
						if MainPanel.Unload then 
							MainPanel.Unload:Remove()
						end
						if MainPanel.Poison then
							MainPanel.Poison:Remove()
						end
						if PoisonFood then
							PoisonFood:Remove()
						end
						if PoisonTouch then
							PoisonTouch:Remove()
						end
						if PoisonBlade then
							PoisonBlade:Remove()
						end
						Frame:SetTall(450)
						MainPanel:SetTall(420)
					end
					local PanelPartition=vgui.Create("DPanel",MainPanel)
					PanelPartition:SetPos(0,Frame:GetTall())
					PanelPartition:SetSize(Frame:GetWide(),20)
					PanelPartition.Entitynum=i
					MainPanel.PanelPartition=PanelPartition
					local partx,party = PanelPartition:GetPos()
					Frame:SetTall(party+250)
					MainPanel:SetTall(party+245)
					PanelPartition.Paint=function()
						surface.SetDrawColor(64,64,64,105)
						surface.DrawRect(0,0,MainPanel:GetWide(),MainPanel:GetTall()+3)
					end
					PreviewIconFrame=vgui.Create("DPanel",MainPanel)
					PreviewIconFrame:SetPos(5, MainPanel:GetTall()-175)
					if iconlength==1 and iconheight==1 then
						PreviewIconFrame:SetSize(75*iconlength,75*iconheight)
					else
						PreviewIconFrame:SetSize(equipmentframes[i]:GetWide(),equipmentframes[i]:GetTall())
					end
					PreviewIconFrame.Paint=function()
						surface.SetDrawColor(64,64,64,105)
						surface.DrawRect(0,0,PreviewIconFrame:GetWide(),PreviewIconFrame:GetTall())
					end
					MainPanel.PreviewIconFrame=PreviewIconFrame
					PreviewIcon=vgui.Create("DButton",PreviewIconFrame)
					if iconlength==1 and iconheight==1 then
						PreviewIcon:SetPos(10,10)
						PreviewIcon:SetSize(60*iconlength,60*iconheight)
					else
						PreviewIcon:SetPos(2,2)
						PreviewIcon:SetSize(equipment[i]:GetWide(),equipment[i]:GetTall())
					end
					PreviewIcon:SetText("")
					PreviewIcon.Paint = function( sel, w, h )
						if body.InventoryEquipment and body.InventoryEquipment[i] and body.InventoryEquipment[i]["Instructions"]!="" then
							surface.SetDrawColor( 255, 255, 255, 255 )
							surface.SetMaterial( equipment_mat )
							surface.DrawTexturedRect( 0, 0, PreviewIcon:GetWide(), PreviewIcon:GetTall() )
						end
					end
					local instructions = body.InventoryEquipment[i]["Instructions"]
					if string.find(instructions,"\n",1,true)!=nil then
						instructions=string.Left(instructions,string.find(instructions,"\n",1,true))
					end
					local postofind=35
					local lineamt=1
					if postofind<string.len(instructions) then
						while postofind<string.len(instructions) do
							local spacefound = string.find(instructions, " ", postofind,false)
							if spacefound!=nil then
								instructions = string.SetChar(instructions,spacefound,"\n")
							end
							postofind=postofind+35
							lineamt=lineamt+1
						end
					end
					local previewposx,previewposy=PreviewIconFrame:GetPos()
					TextBox = vgui.Create("DLabel",MainPanel)
					TextBox:SetPos(PreviewIcon:GetWide()+50,previewposy)
					TextBox:SetSize(250,45+lineamt*10)
					TextBox:SetText(instructions)
					MainPanel.TextBox=TextBox
					PickUp = vgui.Create("DButton", MainPanel)
					PickUp:SetPos(PanelPartition:GetWide()-100,MainPanel:GetTall()-150)
					PickUp:SetSize(80,50)
					PickUp:SetText("Take item")
					MainPanel.PickUp=PickUp
					PickUp.DoClick = function()
						if not(LocalPlayer().Equipment[body.InventoryEquipment[i]["Name"]]) and not(forbiddenItems[LocalPlayer().Role] and forbiddenItems[LocalPlayer().Role][body.InventoryEquipment[i]["Name"]] and forbiddenItems[LocalPlayer().Role][body.InventoryEquipment[i]["Name"]]!=LocalPlayer():GetNWString("Class")) then
							local hassimiliarEquipment=false
							for armorTyp,inf in pairs(HMCD_ArmorNames) do
								if HMCD_ArmorNames[armorTyp][body.InventoryEquipment[i].Name] then
									if LocalPlayer():GetNWString(armorTyp)!="" then hassimiliarEquipment=true break end
								end
							end
							if not(hassimiliarEquipment) then
								net.Start("hmcd_giveequipment")
								net.WriteEntity(body)
								net.WriteInt(i,13)
								net.SendToServer()
								body.InventoryEquipment[i]=nil
								equipment[i]:Remove()
								equipmentframes[i]:Remove()
								if MainPanel.PanelPartition then 
									MainPanel.PanelPartition:Remove()
									MainPanel.PreviewIconFrame:Remove()
									if MainPanel.TextBox then
										MainPanel.TextBox:Remove()
									end
									if MainPanel.Slider then
										MainPanel.Slider:Remove()
									end
									if MainPanel.AmmoTake then
										MainPanel.AmmoTake:Remove()
									end
									if MainPanel.PickUp then
										MainPanel.PickUp:Remove()
									end
									if MainPanel.Unload then 
										MainPanel.Unload:Remove()
									end
									if MainPanel.Poison then
										MainPanel.Poison:Remove()
									end
									if PoisonFood then
										PoisonFood:Remove()
									end
									if PoisonTouch then
										PoisonTouch:Remove()
									end
									if PoisonBlade then
										PoisonBlade:Remove()
									end
									Frame:SetTall(450)
									MainPanel:SetTall(420)
								end
							else
								LocalPlayer():PrintMessage(HUD_PRINTTALK,"You already have armor for this part of body!")
							end
						else
							LocalPlayer():PrintMessage(HUD_PRINTTALK,"You already have this or a similar item!")
						end
					end
					local poisontouch=false
					if LocalPlayer():HasWeapon("wep_jack_hmcd_poisonliquid") then poisontouch=true end
					if poisontouch then
						Poison = vgui.Create("DButton", MainPanel)
						Poison:SetPos(PanelPartition:GetWide()-100,MainPanel:GetTall()-210)
						Poison:SetSize(80,50)
						Poison:SetText("Poison with...")
						MainPanel.Poison=Poison
						Poison.DoClick=function()
							if poisontouch then
								PoisonTouch = vgui.Create("DButton", MainPanel)
								PoisonTouch:SetPos(PanelPartition:GetWide()-100,MainPanel:GetTall()-210)
								PoisonTouch:SetSize(80,50)
								PoisonTouch:SetText("VX Vial")
								PoisonTouch.DoClick=function()
									net.Start("hmcd_remove")
									net.WriteEntity(LocalPlayer():GetWeapon("wep_jack_hmcd_poisonliquid"))
									net.SendToServer()
									sound.Play("snd_jack_hmcd_needleprick.wav",LocalPlayer():GetShootPos(),45,math.random(90,110))
									body.InventoryEquipment[i].ContactPoisoned=true
									body.InventoryEquipment[i].Poisoner=LocalPlayer()
									net.Start("hmcd_updateinventory_equipment_sv")
									net.WriteEntity(body)
									net.WriteInt(i,13)
									net.WriteTable(body.InventoryEquipment[i])
									net.SendToServer()
									PoisonTouch:Remove()
								end
							end
							Poison:Remove()
						end
					end
				end
			end
			mul=mul+iconlength
		end
	end
	Frame.Think=function()
		local bind=input.LookupBinding("+reload")
		local code=input.GetKeyCode(bind)
		if (not(IsValid(body)) or not(LocalPlayer():Alive()) or LocalPlayer().Unconscious or (LocalPlayer():EyePos():Distance(body:GetPos())>75) or input.IsKeyDown(code)) and IsValid(Frame) then
			Frame:Close()
		end
		for i, button in pairs(itemframes) do
			if body.Inventory and not(body.Inventory[i]) and IsValid(itemframes[i]) then
				itemframes[i]:Remove()
			end
			if IsValid(button) then
				local mousex,mousey = MainPanel:ScreenToLocal(gui.MousePos())
				local buttonx,buttony = button:GetPos()
				local sizex,sizey = button:GetSize()
				if not(button.Holding)then
					if mousex>=buttonx and mousex<=buttonx+sizex and mousey>=buttony and mousey<=buttony+sizey then
						button.Color=Color(96,96,96,105)
					else
						button.Color=Color(64,64,64,105)
					end
				end
			end
		end
		for i, button in pairs(ammoframes) do
			if IsValid(button) then
				local mousex,mousey = MainPanel:ScreenToLocal(gui.MousePos())
				local buttonx,buttony = button:GetPos()
				local sizex,sizey = button:GetSize()
				if not(button.Holding)then
					if mousex>=buttonx and mousex<=buttonx+sizex and mousey>=buttony and mousey<=buttony+sizey then
						button.Color=Color(96,96,96,105)
					else
						button.Color=Color(64,64,64,105)
					end
				end
			end
			if body.InventoryAmmo and not(body.InventoryAmmo[i]) and IsValid(ammoframes[i]) then
				ammoframes[i]:Remove()
			end
			if IsValid(ammocount[i]) and body.InventoryAmmo and body.InventoryAmmo[i] and ammocount[i].OldAmt!=body.InventoryAmmo[i]["Amount"] then
				ammocount[i].OldAmt=body.InventoryAmmo[i]["Amount"]
				ammocount[i]:SetText(tostring(body.InventoryAmmo[i]["Amount"]))
				if IsValid(Slider) then
					if Slider.AmmoType==body.InventoryAmmo[i]["Name"] then
						Slider:SetMax(body.InventoryAmmo[i]["Amount"])
						if Slider:GetValue()>Slider:GetMax() then
							Slider:SetValue(Slider:GetMax())
						end
					end
				end
			end
		end
		for i, button in pairs(equipmentframes) do
			if body.InventoryEquipment and not(body.InventoryEquipment[i]) and IsValid(equipmentframes[i]) then
				equipmentframes[i]:Remove()
			end
			if IsValid(button) then
				local mousex,mousey = MainPanel:ScreenToLocal(gui.MousePos())
				local buttonx,buttony = button:GetPos()
				local sizex,sizey = button:GetSize()
				if not(button.Holding)then
					if mousex>=buttonx and mousex<=buttonx+sizex and mousey>=buttony and mousey<=buttony+sizey then
						button.Color=Color(96,96,96,105)
					else
						button.Color=Color(64,64,64,105)
					end
				end
			end
		end
	end
end

-- Zombie buy menu

local zombietypes={ -- 1 = description, 2 = zombie class, 3 = icon, 4 = points
	["Shambler"]={"This is the weakest and most versatile zombie.","npc_zombie","vgui/zombie/zombie",10},
	["Crawler"]={"This is a zombie missing the lower part of it's torso.",{"npc_zombie_torso","npc_fastzombie_torso"},"vgui/zombie/crawler",20},
	["Sprinter"]={"This is the quickest and most enduring zombie.","npc_fastzombie","vgui/zombie/fast",40},
	["Bloater"]={"This is a bloated, slow-moving zombie.","npc_poisonzombie","vgui/zombie/poisonous",25},
	["Deceased Soldier"]={"This is a zombie wearing Level III armor.","npc_zombine","vgui/zombie/zombine",50}
}

local powers={ -- 1 = description, 2 = icon, 3 = cost, 4 = icon color
	["Resurrection"]={"With this ability, you will be able to take control of a zombie. Warning: Only works with shamblers!",Material("vgui/zombie/ressurection"),50},
	["Fake Death"]={"Use this ability to make your zombies pretend to be dead/wake up.",Material("vgui/zombie/zzz"),.5,Color(55,55,55,255)},
	["Suicide Bomber"]={"Use this ability to plant an armed grenade in the selected zombie's hand. (Hold CTRL while planting in order to make the grenade automatically explode when someone approaches.)",Material("vgui/wep_jack_hmcd_oldgrenade"),45},
	["Obliterator"]={"Use this ability to remove zombies that you no longer need.",Material("vgui/zombie/kill"),1},
	["Surprise Box"]={"Use this ability to spawn a zombie in a container you're looking at (It has to be breakable!) Holding CTRL will result in a new prop being created.",Material("vgui/zombie/crate"),25},
	["Room Trapper"]={"With this ability you can temporarily close the door you're currently looking at.",Material("vgui/zombie/door"),15},
	["Fleshy Nest"]={"With this ability you can spawn a nest which will spawn dead players as the undead.",Material("vgui/zombie/nest"),70}
}

net.Receive("hmcd_zombie_points",function()
	LocalPlayer().ZPoints=LocalPlayer().ZPoints+net.ReadInt(13)
end)

net.Receive("hmcd_mutation_points",function()
	LocalPlayer().MutationPoints=net.ReadInt(13)
end)

local mutations={
	["Infection"]={
		["Air"]={
			[1]={"Coughing and sneezing","Infected players will transmit the disease via coughing and sneezing.",Material("vgui/zombie/mut_cough1"),2},
			[2]={"Fake symptoms","Players who are not fully infected will transmit the disease via coughing and sneezing. The infection spreads better through the air now.",Material("vgui/zombie/mut_cough2"),4},
			[3]={"Bloody coughing","Zombies can now spread the infection by coughing. Infected players now cough up blood.",Material("vgui/zombie/mut_cough3"),6}
		},
		["Blood"]={
			[1]={"Contagious blood","The infection will be able to occur if it enters the player's bloodstream.",Material("vgui/zombie/mut_blood1"),4},
			[2]={"Hemopthisis","Infected players and zombies will now throw up blood. Infection spreads easier through the blood now.",Material("vgui/zombie/mut_blood2"),6},
			[3]={"Fleshy horrors","Bloated zombies will spawn fleshy blebs, which explode when damaged, splattering everyone in it's radius with blood and gore. An infected wound can no longer be disinfected.",Material("vgui/zombie/mut_blood3"),8}
		}
	},
	["Shambler"]={
		["Shambler"]={
			[1]={"Heightened senses","Shamblers can now sharpen their senses, allowing them to sense closest humans. Shamblers now have tougher skin, longer claws, as well as slow regeneration. They can now dash quicker.",Material("vgui/zombie/mut_shambler1"),4},
			[2]={"Rage mode","When damaged, shamblers now fall into a state of rage. Shamblers now have tougher skin, longer claws, as well as regeneration. They can now dash quicker.",Material("vgui/zombie/mut_shambler2"),6},
			[3]={"Second chance","The shamblers can now continue fighting after dying, although only with the upper torso remaining. Shamblers now have tougher skin, longer claws, as well as fast regeneration. They can now dash quicker.",Material("vgui/zombie/mut_shambler3"),8}
		}
	}
}

function GM:OpenZMMenu()
	local BuyMenu=vgui.Create("DFrame")
	local w,h=ScrW()/5.25,ScrH()/2.25
	BuyMenu:SetPos(ScrW()-w-20,ScrH()-h-20)
	BuyMenu:SetSize(w,h)
	BuyMenu:SetTitle("")
	BuyMenu:SetVisible(true)
	BuyMenu:SetDraggable(true)
	BuyMenu:ShowCloseButton(true)
	BuyMenu.OnClose=function()
		LocalPlayer().BuyMenu=nil
	end
	BuyMenu.Paint=function()
		surface.SetDrawColor(60,60,60,255)
		surface.DrawRect(0,0,BuyMenu:GetWide(),BuyMenu:GetTall()+3)
	end
	LocalPlayer().BuyMenu=BuyMenu
	local MainPanel = vgui.Create( "DPanel", BuyMenu )
	MainPanel:SetPos(5,25)
	MainPanel:SetSize(w-10,h-30)
	MainPanel.Paint=function()
		surface.SetDrawColor(80,80,80,255)
		surface.DrawRect(0,0,MainPanel:GetWide(),MainPanel:GetTall()+3)
	end
	local MutationsPanel = vgui.Create( "DPanel", BuyMenu )
	MutationsPanel:SetPos(5,25)
	MutationsPanel:SetSize(w-10,h-30)
	MutationsPanel.Paint=function()
		surface.SetDrawColor(80,80,80,255)
		surface.DrawRect(0,0,MutationsPanel:GetWide(),MutationsPanel:GetTall()+3)
	end
	local sheet = vgui.Create( "DPropertySheet", BuyMenu )
	sheet:Dock( FILL )

	sheet:AddSheet("Buy menu",MainPanel,nil)
	sheet:AddSheet("Mutations",MutationsPanel,nil)
	sheet.CurSheet="Buy menu"
	local ZPoints=vgui.Create( "DLabel", BuyMenu )
	ZPoints:SetPos(5, -1)
	ZPoints:SetSize(50, 50)
	ZPoints:SetFont("MersRadialSmall_QM")
	ZPoints:SetTextColor( Color( 255, 255, 255, 255 ) )
	local text
	if not(LocalPlayer().ZPoints) then
		text="Points: 0"
	else
		text="Points: "..LocalPlayer().ZPoints
	end
	ZPoints:SetText(text)
	ZPoints:SizeToContents()
	sheet.OnActiveTabChanged=function(pan,oldPan,newPan)
		sheet.CurSheet=newPan:GetText()
		if sheet.CurSheet=="Buy menu" then
			ZPoints:SetText("Points: "..LocalPlayer().ZPoints)
		else
			ZPoints:SetText("Mutation points: "..LocalPlayer().MutationPoints)
		end
		ZPoints:SizeToContents()
	end
	local curpoints=LocalPlayer().ZPoints or 0
	local curmutationpoints=LocalPlayer().MutationPoints or 0
	BuyMenu.Think=function()
		if LocalPlayer().ZPoints and LocalPlayer().ZPoints!=curpoints and sheet.CurSheet=="Buy menu" then
			curpoints=LocalPlayer().ZPoints
			ZPoints:SetText("Points: "..LocalPlayer().ZPoints)
			ZPoints:SizeToContents()
		elseif LocalPlayer().MutationPoints!=curmutationpoints and sheet.CurSheet=="Mutations" then
			curmutationpoints=LocalPlayer().MutationPoints
			ZPoints:SetText("Mutation points: "..LocalPlayer().MutationPoints)
			ZPoints:SizeToContents()
		end
	end
	local curpos,curpanel=5,0
	for name,tabl in pairs(zombietypes) do
		curpanel=curpanel+1
		local zpanel_size=ScrH()/21.6
		local ZPanel_BG=vgui.Create("DButton",MainPanel)
		ZPanel_BG:SetPos(5,curpos)
		ZPanel_BG:SetSize(zpanel_size,zpanel_size)
		ZPanel_BG:SetText("")
		ZPanel_BG:SetVisible(true)
		ZPanel_BG.Color=Color(50,50,50,255)
		ZPanel_BG.Paint=function()
			surface.SetDrawColor(ZPanel_BG.Color)
			surface.DrawRect(0,0,ZPanel_BG:GetWide(),ZPanel_BG:GetTall()+3)
		end
		local ZPanel=vgui.Create("DButton",MainPanel)
		ZPanel:SetPos(5,curpos)
		ZPanel:SetSize(zpanel_size,zpanel_size)
		ZPanel:SetText("")
		ZPanel:SetVisible(true)
		ZPanel.Color=Color(255,255,255,255)
		ZPanel.Num=curpanel
		ZPanel.Paint=function()
			surface.SetMaterial(Material(tabl[3]))
			surface.SetDrawColor(ZPanel.Color)
			surface.DrawTexturedRect( 0, 0, ZPanel:GetWide(), ZPanel:GetTall() )
		end
		ZPanel.DoClick=function()
			if LocalPlayer().ZM_ChosenPanel!=ZPanel.Num then
				LocalPlayer().ZM_ChosenPanel=ZPanel.Num
				LocalPlayer().ChosenZombie={tabl[2],tabl[4]}
				LocalPlayer().ChosenPower=nil
			else
				LocalPlayer().ZM_ChosenPanel=nil
				LocalPlayer().ChosenZombie=nil
			end
		end
		ZPanel.OnRemove=function()
			hook.Remove("Think",tostring(ZPanel.Num).."CheckMousePos")
		end
		local ZPanel_Desc=vgui.Create("DButton",MainPanel)
		ZPanel_Desc:SetPos(5+zpanel_size,curpos)
		ZPanel_Desc:SetSize(w-zpanel_size-25,zpanel_size)
		ZPanel_Desc:SetVisible(true)
		ZPanel_Desc:SetText("")
		ZPanel_Desc.Color=Color(40,40,40,255)
		ZPanel_Desc.Paint=function()
			surface.SetDrawColor(ZPanel_Desc.Color)
			surface.DrawRect(0,0,ZPanel_Desc:GetWide(),ZPanel_Desc:GetTall()+3)
		end
		ZPanel_Desc.DoClick=ZPanel.DoClick
		local ZombName=vgui.Create( "DLabel", ZPanel_Desc )
		ZombName:SetPos(5, 0)
		ZombName:SetSize(50, 50)
		ZombName:SetTextColor( Color( 255, 255, 255, 255 ) )
		ZombName:SetFont("MersText1")
		ZombName:SetText(name)
		ZombName:SizeToContents()
		local Desc=vgui.Create( "DLabel", ZPanel_Desc )
		Desc:SetPos(5, zpanel_size/3)
		Desc:SetSize(50, 50)
		Desc:SetTextColor( Color( 255, 255, 255, 255 ) )
		Desc:SetFont("MersText1")
		local postofind=math.floor(ScrW()/56)
		local lineamt=1
		local zomb_desc=tabl[1]
		if postofind<string.len(zomb_desc) then
			while postofind<string.len(zomb_desc) do
				local spacefound = string.find(zomb_desc, " ", postofind,false)
				if spacefound!=nil then
					zomb_desc = string.SetChar(zomb_desc,spacefound,"\n")
				end
				postofind=postofind+math.floor(ScrW()/56)
				lineamt=lineamt+1
			end
		end
		Desc:SetText(zomb_desc)
		Desc:SizeToContents()
		local Cost=vgui.Create( "DLabel", ZPanel_Desc )
		Cost:SetPos(w-zpanel_size-105, zpanel_size/4)
		Cost:SetSize(50, 50)
		Cost:SetTextColor( Color( 255, 255, 255, 255 ) )
		Cost:SetFont("MersRadialSmall_QM")
		Cost:SetText(tabl[4].." Pts.")
		Cost:SizeToContents()
		curpos=curpos+zpanel_size+5
		hook.Add("Think",tostring(ZPanel.Num).."CheckMousePos",function()
			if not(IsValid(ZPanel)) then hook.Remove("Think",tostring(ZPanel.Num).."CheckMousePos") return end
			local x,y=input.GetCursorPos()
			x,y=ZPanel:ScreenToLocal(x,y)
			if (x>=0 and y>=0 and x<=w-20 and y<=zpanel_size) or (LocalPlayer().ZM_ChosenPanel and LocalPlayer().ZM_ChosenPanel==ZPanel.Num) then	
				ZPanel.Color=Color(40,40,40,255)
				ZPanel_Desc.Color=Color(30,30,30,255)
			else
				ZPanel.Color=Color(255,255,255,255)
				ZPanel_Desc.Color=Color(40,40,40,255)
			end
		end)
	end
	local curpos_x,items_in_column,firstpowerpos,highestpos=5,0,nil,nil
	for name,power in pairs(powers) do
		if not(firstpowerpos) then firstpowerpos=curpos end
		curpanel=curpanel+1
		local powerbutton_size=math.min((w-25-math.ceil(table.Count(powers)/2-1)*5)/math.ceil(table.Count(powers)/2),ScrH()/10.8)
		local PowerButton=vgui.Create("DButton",MainPanel)
		PowerButton:SetPos(curpos_x,curpos)
		PowerButton:SetSize(powerbutton_size,powerbutton_size)
		PowerButton:SetVisible(true)
		PowerButton:SetText("")
		PowerButton.Color=Color(50,50,50,255)
		PowerButton.Paint=function()
			surface.SetDrawColor(PowerButton.Color)
			surface.DrawRect(0,0,PowerButton:GetWide(),PowerButton:GetTall()+3)
		end
		PowerButton.Num=curpanel
		PowerButton.DoClick=function()
			if LocalPlayer().ZM_ChosenPanel!=PowerButton.Num then
				LocalPlayer().ChosenZombie=nil
				LocalPlayer().ZM_ChosenPanel=PowerButton.Num
				LocalPlayer().ChosenPower={name,power[3]}
			else
				LocalPlayer().ZM_ChosenPanel=nil
				LocalPlayer().ChosenPower=nil
			end
		end
		PowerButton.OnRemove=function()
			hook.Remove("Think",tostring(PowerButton.Num).."CheckMousePos")
			if IsValid(PowerButton.Desc) then PowerButton.Desc:Close() end
		end
		local PowerButton_Icon=vgui.Create("DButton",MainPanel)
		PowerButton_Icon:SetPos(curpos_x,curpos)
		PowerButton_Icon:SetSize(powerbutton_size,powerbutton_size)
		PowerButton_Icon:SetVisible(true)
		PowerButton_Icon:SetText("")
		PowerButton_Icon.Color=Color(255,255,255,255)
		if power[4]!=nil then PowerButton_Icon.Color=power[4] end
		PowerButton_Icon.Paint=function()
			surface.SetMaterial(power[2])
			surface.SetDrawColor(PowerButton_Icon.Color)
			surface.DrawTexturedRect( 0, 0, PowerButton_Icon:GetWide(), PowerButton_Icon:GetTall() )
		end
		PowerButton_Icon.DoClick=PowerButton.DoClick
		hook.Add("Think",tostring(PowerButton.Num).."CheckMousePos",function()
			if not(IsValid(PowerButton)) then hook.Remove("Think",tostring(PowerButton.Num).."CheckMousePos")
				if IsValid(PowerButton.Desc) then PowerButton.Desc:Close() end
				return
			end
			local x,y=input.GetCursorPos()
			x,y=PowerButton:ScreenToLocal(x,y)
			if (x>=0 and y>=0 and x<=powerbutton_size and y<=powerbutton_size) or (LocalPlayer().ZM_ChosenPanel and LocalPlayer().ZM_ChosenPanel==PowerButton.Num) then
				PowerButton.Color=Color(40,40,40,255)
				local col=Color(40,40,40,255)
				if power[4]!=nil then
					col=power[4]
					col.r=col.r/5
					col.g=col.g/5
					col.b=col.b/5
				end
				PowerButton_Icon.Color=col
			else
				PowerButton.Color=Color(50,50,50,255)
				local col=Color(255,255,255,255)
				if power[4]!=nil then col=power[4] end
				PowerButton_Icon.Color=col
			end
			if (x>=0 and y>=0 and x<=powerbutton_size and y<=powerbutton_size) then
				if not(IsValid(PowerButton.Desc)) then
					local PowerDesc=vgui.Create( "DFrame" )
					local posx,posy=BuyMenu:GetPos()
					PowerDesc:SetPos(posx-ScrW()/8, posy)
					PowerDesc:SetSize(ScrW()/8, BuyMenu:GetTall())
					PowerDesc.Paint=function()
						surface.SetDrawColor(60,60,60,255)
						surface.DrawRect(0,0,PowerDesc:GetWide(),PowerDesc:GetTall()+3)
					end
					PowerButton.Desc=PowerDesc
					PowerDesc:ShowCloseButton(false)
					PowerDesc:SetTitle("")
					local Power_MainPanel = vgui.Create( "DPanel", PowerDesc )
					Power_MainPanel:SetPos(5,5)
					Power_MainPanel:SetSize(PowerDesc:GetWide()-5,PowerDesc:GetTall()-10)
					Power_MainPanel.Paint=function()
						surface.SetDrawColor(80,80,80,255)
						surface.DrawRect(0,0,Power_MainPanel:GetWide(),Power_MainPanel:GetTall()+3)
					end
					local PowerButton_Copy=vgui.Create("DButton",Power_MainPanel)
					PowerButton_Copy:SetPos(5,5)
					PowerButton_Copy:SetSize(powerbutton_size,powerbutton_size)
					PowerButton_Copy:SetVisible(true)
					PowerButton_Copy:SetText("")
					PowerButton_Copy.Color=Color(50,50,50,255)
					PowerButton_Copy.Paint=function()
						surface.SetDrawColor(PowerButton_Copy.Color)
						surface.DrawRect(0,0,PowerButton_Copy:GetWide(),PowerButton_Copy:GetTall()+3)
					end
					local PowerButton_Icon_Copy=vgui.Create("DButton",Power_MainPanel)
					PowerButton_Icon_Copy:SetPos(5,5)
					PowerButton_Icon_Copy:SetSize(powerbutton_size,powerbutton_size)
					PowerButton_Icon_Copy:SetVisible(true)
					PowerButton_Icon_Copy:SetText("")
					PowerButton_Icon_Copy.Color=Color(255,255,255,255)
					if power[4]!=nil then PowerButton_Icon_Copy.Color=power[4] end
					PowerButton_Icon_Copy.Paint=function()
						surface.SetMaterial(power[2])
						surface.SetDrawColor(PowerButton_Icon_Copy.Color)
						surface.DrawTexturedRect( 0, 0, PowerButton_Icon_Copy:GetWide(), PowerButton_Icon_Copy:GetTall() )
					end
					local PowerName=vgui.Create( "DLabel", Power_MainPanel )
					PowerName:SetPos(powerbutton_size+10, 0)
					PowerName:SetSize(50, 50)
					PowerName:SetTextColor( Color( 255, 255, 255, 255 ) )
					PowerName:SetFont("MersRadialSmall_QM")
					PowerName:SetText(name)
					PowerName:SizeToContents()
					PowerName:SetPos((Power_MainPanel:GetWide()+powerbutton_size-PowerName:GetWide())/2,0)
					local postofind=math.floor(ScrW()/102)
					local lineamt=1
					local power_desc=power[1]
					if postofind<string.len(power_desc) then
						while postofind<string.len(power_desc) do
							local spacefound = string.find(power_desc, " ", postofind,false)
							if spacefound!=nil then
								power_desc = string.SetChar(power_desc,spacefound,"\n")
							end
							postofind=postofind+math.floor(ScrW()/102)
							lineamt=lineamt+1
						end
					end
					local PowerText=vgui.Create( "DLabel", Power_MainPanel )
					PowerText:SetPos(powerbutton_size+10, PowerName:GetTall())
					PowerText:SetSize(50, 50)
					PowerText:SetTextColor( Color( 255, 255, 255, 255 ) )
					PowerText:SetFont("MersText1")
					PowerText:SetText(power_desc)
					PowerText:SizeToContents()
					local PowerCost=vgui.Create( "DLabel", Power_MainPanel )
					PowerCost:SetPos(5,5+powerbutton_size)
					PowerCost:SetSize(50, 50)
					PowerCost:SetTextColor( Color( 255, 255, 255, 255 ) )
					PowerCost:SetFont("MersRadialSmall_QM")
					PowerCost:SetText(power[3].." Pts.")
					PowerCost:SizeToContents()
					PowerDesc:SetTall(powerbutton_size+PowerCost:GetTall()+15)
					Power_MainPanel:SetTall(powerbutton_size+PowerCost:GetTall()+5)
					if PowerText:GetTall()+PowerName:GetTall()>Power_MainPanel:GetTall() then
						PowerDesc:SetTall(PowerText:GetTall()+PowerName:GetTall()+15)
						Power_MainPanel:SetTall(PowerText:GetTall()+PowerName:GetTall()+5)
					end
				end
			else
				if IsValid(PowerButton.Desc) then PowerButton.Desc:Close() end
			end
		end)
		curpos=curpos+powerbutton_size+5
		items_in_column=items_in_column+1
		if items_in_column>=2 then
			if not(highestpos) then highestpos=curpos end
			items_in_column=0
			curpos_x=curpos_x+powerbutton_size+5
			curpos=firstpowerpos
		end
	end
	if not(highestpos) then
		BuyMenu:SetTall(curpos+90)
	else
		BuyMenu:SetTall(highestpos+90)
	end
	MainPanel:SetTall(BuyMenu:GetTall()-30)
	BuyMenu:SetPos(ScrW()-BuyMenu:GetWide()-5,ScrH()-BuyMenu:GetTall()-5)
	-- Mutations --
	curpos=5
	for name,ls in pairs(mutations) do
		local mutationName=vgui.Create("DLabel",MutationsPanel)
		mutationName:SetFont("MersRadialSmall_QM")
		mutationName:SetText(name)
		mutationName:SizeToContents()
		curpos=curpos+table.Count(ls)*w/20-mutationName:GetTall()/2
		mutationName:SetPos(5,curpos)
		local startMul=(1-table.Count(ls))/2
		for j,tabl in pairs(ls) do
			local curX=mutationName:GetWide()+10
			for k,cell in pairs(tabl) do
				local mutPan=vgui.Create("DButton",MutationsPanel)
				mutPan:SetPos(curX,curpos+startMul*w/10+mutationName:GetTall()/2-w/20)
				mutPan:SetSize(w/5,w/10)
				mutPan:SetText("")
				if self.ZombieMutations[j] and self.ZombieMutations[j]>=k then
					mutPan.Col=color_white
				else
					mutPan.Col=Color(155,155,155,255)
				end
				mutPan.Col1=Color(55,55,55,255)
				mutPan.Col2=Color(35,35,35,255)
				local width,height=mutPan:GetWide(),mutPan:GetTall()
				mutPan.Paint=function()
					if cell[3] then
						surface.SetDrawColor(mutPan.Col)
						surface.SetMaterial(cell[3])
						surface.DrawTexturedRect(0,0,width,height)
					else
						surface.SetDrawColor(mutPan.Col1)
						surface.DrawRect(0,0,width,height)
						surface.SetDrawColor(mutPan.Col2)
						surface.DrawRect(10,5,width-20,height-10)
					end
				end
				mutPan.DoClick=function()
					local curNum=self.ZombieMutations[j] or 0
					if k==curNum+1 then
						if LocalPlayer().MutationPoints>=cell[4] then
							if not(self.ZombieMutations[j]) then self.ZombieMutations[j]=0 end
							self.ZombieMutations[j]=self.ZombieMutations[j]+1
							net.Start("hmcd_mutation")
							net.WriteString(j)
							net.SendToServer()
							LocalPlayer().MutationPoints=LocalPlayer().MutationPoints-cell[4]
						else
							LocalPlayer():PrintMessage(HUD_PRINTTALK,"You don't have enough mutation points!")
						end
					elseif k>curNum+1 then
						LocalPlayer():PrintMessage(HUD_PRINTTALK,"You can't unlock this mutation yet!")
					else
						LocalPlayer():PrintMessage(HUD_PRINTTALK,"You already unlocked this mutation!")
					end
				end
				local desc
				mutPan.Think=function()
					local hovered=mutPan:IsHovered()
					if hovered and not(desc) then
						local MutationDesc=vgui.Create( "DFrame" )
						local posx,posy=BuyMenu:GetPos()
						MutationDesc:SetPos(posx-ScrW()/8, posy)
						MutationDesc:SetSize(ScrW()/8, BuyMenu:GetTall())
						MutationDesc.Paint=function()
							surface.SetDrawColor(60,60,60,255)
							surface.DrawRect(0,0,MutationDesc:GetWide(),MutationDesc:GetTall()+3)
						end
						MutationDesc:ShowCloseButton(false)
						MutationDesc:SetTitle("")
						desc=MutationDesc
						local Power_MainPanel = vgui.Create( "DPanel", MutationDesc )
						Power_MainPanel:SetPos(5,5)
						Power_MainPanel:SetSize(MutationDesc:GetWide()-10,MutationDesc:GetTall()-10)
						local text=""
						local curWidth=0
						local lins,titleLines={},{}
						local fontHeight,curlinePos
						for i,word in pairs(string.Explode(" ",cell[1])) do
							surface.SetFont("MersRadialSmall_QM")
							local width,height=surface.GetTextSize(word)
							local widthSpace=surface.GetTextSize(word.." ")
							if not(fontHeight) then fontHeight=height curlinePos=0 end
							if curWidth+width>Power_MainPanel:GetWide() then
								table.insert(titleLines,{text,curlinePos})
								curlinePos=curlinePos+fontHeight
								text=word
								curWidth=width
							else
								local space=""
								if text!="" then space=" " end
								text=text..space..word
								curWidth=curWidth+widthSpace
							end
						end
						table.insert(titleLines,{text,curlinePos})
						text=""
						curWidth=0
						curlinePos=curlinePos+fontHeight
						for i,word in pairs(string.Explode(" ",cell[2])) do
							surface.SetFont("MersRadialSmall_QM")
							local width,height=surface.GetTextSize(word)
							local widthSpace=surface.GetTextSize(word.." ")
							if curWidth+width>Power_MainPanel:GetWide() then
								table.insert(lins,{text,curlinePos})
								curlinePos=curlinePos+fontHeight
								text=word
								curWidth=width
							else
								local space=""
								if text!="" then space=" " end
								text=text..space..word
								curWidth=curWidth+widthSpace
							end
						end
						table.insert(lins,{text,curlinePos})
						local previewiconWidth=Power_MainPanel:GetWide()/2
						Power_MainPanel.Paint=function()
							surface.SetDrawColor(80,80,80,255)
							surface.DrawRect(0,0,Power_MainPanel:GetWide(),Power_MainPanel:GetTall()+3)
							if cell[3] then
								surface.SetDrawColor(255,255,255,255)
								surface.SetMaterial(cell[3])
								surface.DrawTexturedRect(5,5,Power_MainPanel:GetWide()-10,previewiconWidth)
							else
								surface.SetDrawColor(40,40,40,255)
								surface.DrawRect(5,5,Power_MainPanel:GetWide()-10,previewiconWidth)
							end
							for i,line in pairs(titleLines) do
								draw.SimpleText( line[1], "MersRadialSmall_QM", previewiconWidth, previewiconWidth+line[2]+5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
							end
							local lastHeight
							for i,line in pairs(lins) do
								draw.SimpleText( line[1], "MersRadialSmall_QM", 0, previewiconWidth+5+line[2], Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
								lastHeight=line[2]
							end
							draw.SimpleText( "Cost: "..cell[4].." Pts.", "MersRadialSmall_QM", 0, previewiconWidth+5+lastHeight+fontHeight*2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
						end
						mutPan.Col=Color(205,205,205,255)
						mutPan.Col1=Color(35,35,35,255) 
						mutPan.Col2=Color(15,15,15,255)
					elseif desc and not(hovered) then
						desc:Close()
						desc=nil
						if self.ZombieMutations[j] and self.ZombieMutations[j]>=k then
							mutPan.Col=color_white
						else
							mutPan.Col=Color(155,155,155,255)
						end
						mutPan.Col1=Color(55,55,55,255) 
						mutPan.Col2=Color(35,35,35,255)
					end
				end
				curX=curX+mutPan:GetWide()+5
			end
			curpos=curpos+5
			startMul=startMul+1
		end
		curpos=curpos+mutationName:GetTall()/2+table.Count(ls)*w/20+w/20
	end
end

local hints={
	[1]={{"gmod_undo","undo"}, " to enable your cursor"},
	[2]={nil, "F1 to open the buy menu"}
}

local instrs={
	[1]="In order to spawn a zombie, select any zombie in the buy menu, enable your cursor and click in a certain spot (Which should not be visible to anyone!)",
	[2]="You can guide zombies by selecting them and clicking RMB where they should go. In order to select a zombie, you can either click on a zombie while holding CTRL or you can deselect your chosen option in the buy menu and drag your mouse across the map. Every zombie in the red zone will be highlighted.",
	[3]="When the national guard arrives, they will attempt to evacuate the survivors. Should at least one survivor get evacuated, you will lose. During this period, you will get more points per second.",
	[4]="If you are tired of playing as a zombie and want to give up, type 'hmcd_giveup' into your console."
}

CreateClientConVar( "hmcd_showguidehint", "1", true, false, "If set to 1, a hint will pop up at the beginning of every zombie mode round (If you're the zombie).", 0, 1 )

function GM:OpenZMGuide()
	local showagain=GetConVar("hmcd_showguidehint"):GetInt()==1
	local ZGuide=vgui.Create("DFrame")
	local w,h=ScrW()/5.25,ScrH()/2.25
	ZGuide:SetPos(20,ScrH()-h-20)
	ZGuide:SetSize(w,h)
	ZGuide:SetTitle("")
	ZGuide:SetVisible(true)
	ZGuide:SetDraggable(true)
	ZGuide:ShowCloseButton(true)
	ZGuide.OnClose=function()
		if (showagain) then
			GetConVar("hmcd_showguidehint"):SetInt(1)
		else
			GetConVar("hmcd_showguidehint"):SetInt(0)
		end
	end
	LocalPlayer().GuideOpened=true
	ZGuide.Paint=function()
		surface.SetDrawColor(60,60,60,255)
		surface.DrawRect(0,0,ZGuide:GetWide(),ZGuide:GetTall()+3)
	end
	LocalPlayer().GuideMenu=ZGuide
	local MainPanel = vgui.Create( "DScrollPanel", ZGuide )
	MainPanel:SetPos(5,25)
	MainPanel:SetSize(w-10,h-30)
	MainPanel.Paint=function()
		surface.SetDrawColor(80,80,80,255)
		surface.DrawRect(0,0,MainPanel:GetWide(),MainPanel:GetTall()+3)
	end
	local Title=vgui.Create( "DLabel", MainPanel )
	Title:SetPos(MainPanel:GetWide()/2, 50)
	Title:SetSize(50, 50)
	Title:SetTextColor( Color( 255, 255, 255, 255 ) )
	Title:SetFont("MersRadialBig")
	Title:SetText("Zombie Guide")
	Title:SizeToContents()
	local curpos=Title:GetTall()+5
	local widest=0
	for i=1,#hints do
		local bind,instr=hints[i][1],hints[i][2]
		if istable(bind) then
			for j,b in pairs(bind) do
				if input.LookupBinding(b)!=nil then
					bind=b
					break
				end
			end
		end
		local Hint=vgui.Create( "DLabel", MainPanel )
		Hint:SetPos(5, curpos)
		Hint:SetSize(50, 50)
		Hint:SetTextColor( Color( 255, 255, 255, 255 ) )
		Hint:SetFont("MersRadialSmall_QM")
		if bind!=nil then
			local bindKey=not(istable(bind)) and input.LookupBinding(bind)
			if bindKey then
				bind=string.upper(bindKey)
			else
				bind=bind[1]
			end
		else
			bind=""
		end
		Hint:SetText("- "..bind..instr)
		Hint:SizeToContents()
		if Hint:GetWide()>widest then widest=Hint:GetWide() end
		local mul=1
		if i==#hints then mul=2 end
		curpos=curpos+(Hint:GetTall()+5)*mul
	end
	for i=1,#instrs do
		local Instr=vgui.Create( "DLabel", MainPanel )
		Instr:SetPos(5, curpos)
		Instr:SetSize(50, 50)
		Instr:SetTextColor( Color( 255, 255, 255, 255 ) )
		Instr:SetFont("MersRadialSmall_QM")
		local instructions=instrs[i]
		local postofind=ScrW()/50
		local lineamt=1
		if postofind<string.len(instructions) then
			while postofind<string.len(instructions) do
				local spacefound = string.find(instructions, " ", postofind,false)
				if spacefound!=nil then
					instructions = string.SetChar(instructions,spacefound,"\n")
				end
				postofind=postofind+math.floor(ScrW()/50)
				lineamt=lineamt+1
			end
		end
		Instr:SetText(instructions)
		Instr:SizeToContents()
		if Instr:GetWide()>widest then widest=Instr:GetWide() end
		curpos=curpos+Instr:GetTall()+5
	end
	local disable_size=ScrW()/5
	local Disable = vgui.Create("DButton", MainPanel)
	Disable:SetPos((widest+10-disable_size)/2,curpos)
	Disable:SetSize(disable_size,disable_size/8)
	Disable:SetText("")
	Disable.Color=Color(50,50,50,255)
	if not(showagain) then Disable.Color=Color(0,0,0,255) end
	Disable.Paint=function()
		surface.SetDrawColor(Disable.Color)
		surface.DrawRect(0,0,Disable:GetWide(),Disable:GetTall()+3)
	end
	local DisableText=vgui.Create( "DLabel", Disable )
	DisableText:SetPos(0, 0)
	DisableText:SetSize(50, 50)
	DisableText:SetTextColor( Color( 255, 255, 255, 255 ) )
	DisableText:SetFont("MersRadialSmall_QM")
	DisableText:SetText("Do not show this hint again")
	DisableText:SizeToContents()
	DisableText:SetPos((Disable:GetWide()-DisableText:GetWide())/2,(Disable:GetTall()-DisableText:GetTall())/2)
	Disable.DoClick=function()
		if showagain then
			showagain=false
			Disable.Color=Color(0,0,0,255)
		else
			showagain=true
			Disable.Color=Color(50,50,50,255)
		end
	end
	ZGuide:SetWide(widest+20)
	MainPanel:SetWide(widest+10)
	Title:SetPos((MainPanel:GetWide()-Title:GetWide())/2)
end

-- RTV

net.Receive("hmcd_mapvote_updatestatus_cs",function()
	local index,value,voter=net.ReadInt(13),net.ReadInt(13),net.ReadEntity()
	if not(GAMEMODE.MapVote_Progress) then GAMEMODE.MapVote_Progress={} end
	GAMEMODE.MapVote_Progress[index]=value
	if IsValid(voter) then
		voter.MapVoted=index
	end
end)

net.Receive("hmcd_mapvote_start",function()
	local timeleft,maps=net.ReadInt(13),net.ReadTable()
	GAMEMODE.VoteTime=CurTime()+timeleft
	GAMEMODE:OpenRTVMenu(maps)
end)

net.Receive("hmcd_mapvote_voicecheck_cs",function()
	local voices={}
	for i,ply in pairs(player.GetAll()) do
		local volume=ply:VoiceVolume()
		if volume>0 then
			voices[ply:EntIndex()]=volume
		end
	end
	net.Start("hmcd_mapvote_voicecheck")
	net.WriteTable(voices)
	net.SendToServer()
end)

function GM:OpenRTVMenu(maps)
	if not(GAMEMODE.MapVote_Progress) then GAMEMODE.MapVote_Progress={} end
	local RTV=vgui.Create("DFrame")
	RTV:SetPos(40,80)
	RTV:SetSize(ScrW()/3.25,ScrH()/1.25)
	RTV:SetTitle("")
	RTV:SetVisible(true)
	RTV:SetDraggable(true)
	RTV:ShowCloseButton(false)
	RTV:Center()
	RTV.OnClose=function()
		hook.Remove("Think","Timer")
	end
	RTV.Paint=function()
		surface.SetDrawColor(60,60,60,255)
		surface.DrawRect(0,0,RTV:GetWide(),RTV:GetTall()+3)
	end
	gui.EnableScreenClicker(true)
	local MainPanel = vgui.Create( "DScrollPanel", RTV )
	MainPanel:SetPos(5,25)
	MainPanel:SetSize(ScrW()/3.25-10,ScrH()/1.25-30)
	MainPanel.Paint=function()
		surface.SetDrawColor(80,80,80,255)
		surface.DrawRect(0,0,MainPanel:GetWide(),MainPanel:GetTall()+3)
	end
	local iconsize,iconpos=math.floor(ScrH()/17),5
	local progress=GAMEMODE.MapVote_Progress or {}
	local progressbars={}
	for i,name in pairs(maps) do
		local Bar = vgui.Create( "DButton", MainPanel )
		Bar:SetPos(4,iconpos)
		Bar:SetSize(MainPanel:GetWide()-4,iconsize)
		Bar:SetText("")
		Bar.Paint=function()
			surface.SetDrawColor(Color(110,0,0,255))
			surface.DrawRect(0,0,Bar:GetWide(),Bar:GetTall())
		end
		Bar.DoClick=function()
			if not(LocalPlayer().MapVoted==i) then
				local prevprogress=progress[LocalPlayer().MapVoted] or 0
				if LocalPlayer().MapVoted then
					prevprogress=prevprogress-math.Clamp(math.floor(100/#player.GetAll()),0,100)
					net.Start("hmcd_mapvote_updatestatus")
					net.WriteInt(LocalPlayer().MapVoted,13)
					net.WriteInt(prevprogress,13)
					net.SendToServer()
				end
				LocalPlayer().MapVoted=i
				local curprogress=progress[i] or 0
				curprogress=curprogress+math.Clamp(math.floor(100/#player.GetAll()),0,100)
				net.Start("hmcd_mapvote_updatestatus")
				net.WriteInt(i,13)
				net.WriteInt(curprogress,13)
				net.SendToServer()
			end
		end
		local ProgressBar = vgui.Create( "DButton", Bar )
		ProgressBar:SetPos(0,0)
		ProgressBar:SetSize(Bar:GetWide(),Bar:GetTall())
		ProgressBar:SetText("")
		ProgressBar.LastPercent=progress[i] or 0
		ProgressBar.DrawColor=Color(0,205,0,255)
		ProgressBar.Paint=function()
			local percent=progress[i] or 0
			local diff=percent-ProgressBar.LastPercent
			local mul=(100-diff)/25
			percent=math.Clamp(ProgressBar.LastPercent+diff*0.01*mul,0,100)/100
			ProgressBar.LastPercent=percent*100
			surface.SetDrawColor(ProgressBar.DrawColor)
			surface.DrawRect(0,0,ProgressBar:GetWide()*percent,ProgressBar:GetTall())
		end
		ProgressBar.DoClick=Bar.DoClick
		progressbars[i]=ProgressBar
		local MapIcon = vgui.Create( "DButton", Bar )
		MapIcon:SetPos(4,4)
		MapIcon:SetSize(Bar:GetWide()/8,Bar:GetTall()-8)
		MapIcon:SetText("")
		MapIcon.DoClick=Bar.DoClick
		local material=Material("maps/thumb/noicon.png")
		if file.Exists("maps/thumb/" .. name .. ".png", "GAME") then
			material=Material("maps/thumb/" .. name .. ".png")
		elseif file.Exists("maps/" .. name .. ".png", "GAME") then
			material=Material("maps/" .. name .. ".png")
		end
		MapIcon.Paint = function( sel, w, h )
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( material )
			surface.DrawTexturedRect( 0, 0, MapIcon:GetWide(), MapIcon:GetTall() )
		end
		local MapName=vgui.Create( "DLabel", Bar )
		MapName:SetPos(8+Bar:GetWide()/8, 4)
		MapName:SetSize(50, Bar:GetTall()-8)
		MapName:SetFont("MersRadialSmall")
		MapName:SetTextColor( Color( 255, 255, 255, 255 ) )
		MapName:SetText(name)
		MapName:SizeToContents()
		iconpos=iconpos+iconsize+5
	end
	local TimeLeft=vgui.Create( "DLabel", MainPanel )
	TimeLeft:SetPos(MainPanel:GetWide()/2, iconpos+5)
	TimeLeft:SetSize(50, 50)
	TimeLeft:SetFont("MersRadialSmall")
	TimeLeft:SetTextColor( Color( 255, 255, 255, 255 ) )
	TimeLeft:SetText(GAMEMODE.VoteTime-CurTime())
	TimeLeft:SizeToContents()
	RTV:SetTall(iconpos+95)
	MainPanel:SetTall(RTV:GetTall()-30)
	local x,y=TimeLeft:GetPos()
	hook.Add("Think","Timer",function()
		local secs=math.abs(math.Clamp(math.ceil(GAMEMODE.VoteTime-CurTime()),0,1000000))
		local mins=math.abs(math.floor(secs/60))
		if secs<=0 then
			local maxfound,winner,candidates=-1,nil,{}
			for i,progress in pairs(GAMEMODE.MapVote_Progress) do
				if progress>maxfound then
					winner=i
					maxfound=progress
				end
			end
			for i,progress in pairs(GAMEMODE.MapVote_Progress) do
				if i!=winner and progress==maxfound then
					table.insert(candidates,i)
				end
			end
			if #candidates>0 then winner=table.Random(candidates) end
			for i=0,1,0.5 do
				timer.Simple(i,function()
					if winner and progressbars[winner] then
						LocalPlayer():EmitSound("buttons/blip1.wav")
						progressbars[winner].DrawColor=Color(200,200,0,255)
						timer.Simple(.1,function()
							progressbars[winner].DrawColor=Color(0,205,0,255)
						end)
					end
				end)
			end
			hook.Remove("Think","Timer")
			net.Start("hmcd_mapvote_end")
			net.WriteString(maps[winner])
			net.SendToServer()
		end
		if secs<10 then secs="0"..tostring(secs) end
		if mins<10 then mins="0"..tostring(mins) end
		local text=tostring(mins)..":"..tostring(secs)
		TimeLeft:SetText(text)
		TimeLeft:SizeToContents()
		TimeLeft:SetPos(x-TimeLeft:GetWide()/1.5,y)
	end)
end

local buyCategories={
	["Pistols"]={
		["Beretta PX4-Storm SubCompact"]={texture=Material("vgui/wep_jack_hmcd_smallpistol"),cost=540,class="wep_jack_hmcd_pistol",attachments={HMCD_PISTOLSUPP,HMCD_LASERSMALL}},
		["Glock-17"]={texture=Material("vgui/entities/cw_nen_glock17"),cost=600,class="wep_jack_hmcd_glock17",attachments={HMCD_PISTOLSUPP,HMCD_LASERSMALL}},
		["USP"]={texture=Material("vgui/hud/tfa_ins2_usp_match"),cost=650,class="wep_jack_hmcd_usp",attachments={HMCD_OSPREY,HMCD_LASERSMALL}},
		["Walther P22"]={texture=Material("vgui/wep_jack_hmcd_suppressed"),cost=300,class="wep_jack_hmcd_suppressed",attachments={HMCD_PISTOLSUPP,HMCD_LASERSMALL}},
		["CZ-75"]={texture=Material("vgui/hud/tfa_ins2_cz75"),cost=1000,class="wep_jack_hmcd_cz75a",attachments={HMCD_PISTOLSUPP,HMCD_LASERSMALL}},
		["Manurhin MR96"]={texture=Material("vgui/wep_jack_hmcd_revolver"),cost=400,class="wep_jack_hmcd_revolver",attachments={HMCD_PISTOLSUPP},team="t"}
	},
	["Heavy weapons"]={
		["SPAS-12"]={texture=Material("vgui/hud/tfa_ins2_spas12"),width=2,cost=1700,class="wep_jack_hmcd_spas",attachments={HMCD_SHOTGUNSUPP}},
		["Remington 870"]={texture=Material("vgui/wep_jack_hmcd_shotgun"),width=2,cost=1000,class="wep_jack_hmcd_shotgun",attachments={HMCD_SHOTGUNSUPP,HMCD_KOBRA,HMCD_AIMPOINT,HMCD_EOTECH,HMCD_LASERBIG}},
		["M249"]={texture=Material("vgui/inventory/weapon_m249"),width=2,cost=5100,class="wep_jack_hmcd_m249",attachments={HMCD_RIFLESUPP,HMCD_KOBRA,HMCD_AIMPOINT,HMCD_EOTECH,HMCD_LASERBIG}}
	},
	["Rifles"]={
		["AR-15"]={texture=Material("vgui/wep_jack_hmcd_assaultrifle"),width=2,cost=2500,class="wep_jack_hmcd_assaultrifle",attachments={HMCD_RIFLESUPP,HMCD_KOBRA,HMCD_AIMPOINT,HMCD_EOTECH,HMCD_LASERBIG}},
		["KAR98K"]={texture=Material("vgui/wep_jack_hmcd_rifle"),width=2,cost=3600,class="wep_jack_hmcd_rifle",attachments={HMCD_RIFLESUPP,HMCD_SCOPE}},
		["AKM"]={texture=Material("vgui/inventory/weapon_nam_akm"),width=2,cost=2700,class="wep_jack_hmcd_akm",attachments={HMCD_PBS,HMCD_KOBRA,HMCD_AIMPOINT,HMCD_EOTECH,HMCD_LASERBIG}},
		["SR-25"]={texture=Material("vgui/hud/tfa_ins2_sr25_eft"),width=2,cost=4900,class="wep_jack_hmcd_sr25",attachments={HMCD_KOBRA,HMCD_AIMPOINT,HMCD_EOTECH,HMCD_LASERBIG}}
	},
	["SMGs"]={
		["MP7"]={texture=Material("vgui/hud/tfa_ins2_mp7"),width=2,cost=1750,class="wep_jack_hmcd_mp7",attachments={HMCD_PISTOLSUPP,HMCD_KOBRA,HMCD_AIMPOINT,HMCD_EOTECH,HMCD_LASERSMALL}},
		["MP5A4"]={texture=Material("vgui/hud/tfa_ins2_mp5a4"),width=2,cost=1300,class="wep_jack_hmcd_mp5",attachments={HMCD_PISTOLSUPP}}
	},
	["Utility"]={
		["M87"]={texture=Material("vgui/wep_jack_hmcd_flashbang"),cost=350,class="wep_jack_hmcd_flashbang"},
		["Type 59 Grenade"]={texture=Material("vgui/wep_jack_hmcd_oldgrenade"),cost=250,class="wep_jack_hmcd_oldgrenade_dm",team="t"},
		["Taser"]={texture=Material("vgui/wep_jack_hmcd_taser"),cost=300,class="wep_jack_hmcd_taser"},
		["Molotov"]={texture=Material("vgui/inventory/weapon_molotov"),cost=150,class="wep_jack_hmcd_molotovtest",team="t"},
		["M67 Grenade"]={texture=Material("vgui/hud/tfa_ins2_m67"),cost=300,class="wep_jack_hmcd_m67",team="ct"},
		["Rappelling Tool"]={texture=Material("vgui/wep_jack_hmcd_zipline"),cost=200,class="wep_jack_hmcd_zipline",allowedMap="hmcd_helicopterz"}
	},
	["Ammo"]={
		["5.7x16mm (.22 long rifle)"]={ammoType="AlyxGun",amt=20,cost=4},
		["9x19mm (9mm luger/parabellum)"]={ammoType="Pistol",amt=30,cost=17},
		["5.56x45mm (.223 remington)"]={ammoType="SMG1",amt=30,cost=18},
		["18.5x70mmR (12 gauge shotshell)"]={ammoType="Buckshot",amt=12,cost=9},
		["7x57mm (7mm mauser)"]={ammoType="AR2",amt=20,cost=14},
		["7.62x51 NATO"]={ammoType="StriderMinigun",amt=20,cost=20},
		["4.6x30mm"]={ammoType="HelicopterGun",amt=40,cost=24},
		["7.62x39mm"]={ammoType="SniperRound",amt=30,cost=12},
		["X26 Taser Cartridge"]={ammoType="SniperPenetratedRound",amt=1,cost=6},
		["9x29mmR (.38 special)"]={ammoType="357",amt=12,cost=12,team="t"}
	},
	["Equipment"]={
		["Level IIIA Armor"]={texture=Material("vgui/icons/armor01"),cost=215,class=tostring(HMCD_ARMOR3A)},
		["Level III Armor"]={texture=Material("vgui/icons/armor02"),cost=500,class=tostring(HMCD_ARMOR3)},
		["Advanced Combat Helmet"]={texture=Material("vgui/icons/helmet"),cost=350,class=tostring(HMCD_ACH)},
		["Ballistic Mask"]={texture=Material("vgui/icons/ballisticmask"),cost=420,class=tostring(HMCD_BALLISTICMASK)},
		["Night Vision Goggles"]={texture=Material("vgui/icons/nvg"),cost=1000,class=tostring(HMCD_NVG)},
		["LED flashlight"]={texture=Material("vgui/hud/hmcd_flash"),cost=75,class=tostring(HMCD_FLASHLIGHT)}
	},
	["Melee"]={
		["SOG M37 Seal Pup"]={texture=Material("vgui/wep_jack_hmcd_knife"),cost=200,class="wep_jack_hmcd_knife"},
		["CQC Tactical Knife"]={texture=Material("vgui/hud/tfa_iw7_tactical_knife"),cost=200,class="wep_jack_hmcd_combatknife"},
		["S&W CH0014"]={texture=Material("vgui/wep_jack_hmcd_pocketknife"),cost=50,class="wep_jack_hmcd_pocketknife"},
		["Claw Hammer"]={texture=Material("vgui/wep_jack_hmcd_hammer"),cost=75,class="wep_jack_hmcd_hammer",team="t"},
		["Butcher Knife"]={texture=Material("vgui/hud/tfa_nmrih_cleaver"),cost=250,class="wep_jack_hmcd_cleaver",team="t"},
		["Police Tonfa"]={texture=Material("vgui/wep_zac_hmcd_policebaton"),width=2,cost=100,class="wep_jack_hmcd_baton",team="ct"},
		["Lead Pipe"]={texture=Material("vgui/hud/tfa_nmrih_lpipe"),width=2,cost=100,class="wep_jack_hmcd_leadpipe",team="t"},
		["Battering Ram"]={texture=Material("vgui/wep_jack_hmcd_ram"),width=2,cost=600,class="wep_jack_hmcd_ram",team="ct"}
	},
	["Medicine"]={
		["Large Bandage"]={texture=Material("vgui/wep_jack_hmcd_bandage"),cost=120,class="wep_jack_hmcd_bandagebig"},
		["Small Bandage"]={texture=Material("vgui/wep_jack_hmcd_bandage"),cost=75,class="wep_jack_hmcd_bandage"},
		["First-Aid Kit"]={texture=Material("vgui/wep_jack_hmcd_medkit"),cost=300,class="wep_jack_hmcd_medkit"},
		["Morphine Syrette"]={texture=Material("vgui/wep_jack_hmcd_morphine"),cost=500,class="wep_jack_hmcd_morphine"},
		["Epinephrine Autoinjector"]={texture=Material("vgui/wep_jack_hmcd_adrenaline"),cost=400,class="wep_jack_hmcd_adrenaline"},
		["Pain Killers"]={texture=Material("vgui/wep_jack_hmcd_painpills"),cost=150,class="wep_jack_hmcd_painpills"}
	}
}

local atts_simplified={
	[HMCD_PISTOLSUPP]="Suppressor",
	[HMCD_RIFLESUPP]="Suppressor",
	[HMCD_SHOTGUNSUPP]="Suppressor",
	[HMCD_LASERSMALL]="Laser",
	[HMCD_LASERBIG]="Laser",
	[HMCD_KOBRA]="Sight",
	[HMCD_AIMPOINT]="Sight2",
	[HMCD_EOTECH]="Sight3",
	[HMCD_PBS]="Suppressor",
	[HMCD_OSPREY]="Suppressor",
	[HMCD_SCOPE]="Scope"
}

local HMCD_BuyZones={
	["de_dust2"]={
		["t"]={Vector(-679,-810,134),500},
		["ct"]={Vector(254,2411,-125),400}
	}
}

concommand.Add("hmcd_buymenu", function( ply, cmd, args )
	if GAMEMODE.Mode!="CS" or not(LocalPlayer():Alive()) then return end
	local info=HMCD_BuyZones[game.GetMap()]
	if info and info[ply.Role][1]:DistToSqr(ply:GetPos())>info[ply.Role][2]^2 then ply:PrintMessage(HUD_PRINTTALK,"You can only buy equipment at your spawn!") return end
	if GAMEMODE.RoundStartTime+45<CurTime() then ply:PrintMessage(HUD_PRINTTALK,"You can no longer buy equipment!") return end
	if LocalPlayer().BuyMenu then
		LocalPlayer().BuyMenu:Close()
	else
		GAMEMODE:OpenBuyMenu()
	end
end)

local weapon_rewards={
	["wep_jack_hmcd_suppressed"]=400,
	["wep_jack_hmcd_hands"]=2000,
	["wep_jack_hmcd_knife"]=1500,
	["wep_jack_hmcd_combatknife"]=1500,
	["wep_jack_hmcd_cleaver"]=1250,
	["wep_jack_hmcd_leadpipe"]=1500,
	["wep_jack_hmcd_hammer"]=1600,
	["wep_jack_hmcd_baton"]=1750,
	["wep_jack_hmcd_pocketknife"]=1600,
	["wep_jack_hmcd_assaultrifle"]=200,
	["wep_jack_hmcd_akm"]=200,
	["wep_jack_hmcd_sr25"]=200,
	["wep_jack_hmcd_m249"]=100,
	["wep_jack_hmcd_shotgun"]=400
}

net.Receive("hmcd_cs_money",function()
	LocalPlayer().Money=LocalPlayer().Money+(weapon_rewards[net.ReadString()] or 300)
end)

function GM:OpenBuyMenu()
	hook.Add("PostRenderVGUI","DrawMoney",function()
		draw.SimpleText( LocalPlayer().Money.."$", "MersRadial", ScrW()/2, ScrH(), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		if LocalPlayer().HoveredAttachment then
			if LocalPlayer().HoveredAttachment.pan:IsHovered() then
				local x,y=input.GetCursorPos()
				surface.SetFont("MersRadialSmall")
				surface.SetTextPos(x+ScrW()/150,y)
				surface.SetTextColor(Color(255,255,255,255))
				surface.DrawText(LocalPlayer().HoveredAttachment.money.."$")
			else
				LocalPlayer().HoveredAttachment=nil
			end
		end
	end)
	local Frame=vgui.Create("DFrame")
	Frame:SetPos(40,80)
	Frame:SetSize(ScrW()/3.25,ScrH()/1.25)
	Frame:SetTitle("")
	Frame:SetVisible(true)
	Frame:SetDraggable(true)
	Frame:ShowCloseButton(true)
	Frame:Center()
	Frame.Paint=function()
		surface.SetDrawColor(60,60,60,255)
		surface.DrawRect(0,0,Frame:GetWide(),Frame:GetTall()+3)
	end
	Frame.OnClose=function()
		LocalPlayer().BuyMenu=nil
		hook.Remove("PostRenderVGUI","DrawMoney")
	end
	local buyZone=HMCD_BuyZones[game.GetMap()]
	local home
	Frame.Think=function()
		if IsValid(home) then
			local bind=input.LookupBinding("+reload")
			local code=input.GetKeyCode(bind)
			if input.IsKeyDown(code) then
				home:DoClick()
			end
		end
		if (GAMEMODE.RoundStartTime+45<CurTime()) or (buyZone and buyZone[LocalPlayer().Role][1]:DistToSqr(LocalPlayer():GetPos())>buyZone[LocalPlayer().Role][2]^2) then Frame:Close() end
	end
	Frame:MakePopup()
	LocalPlayer().BuyMenu=Frame
	local MainPanel = vgui.Create( "DScrollPanel", Frame )
	MainPanel:SetPos(5,25)
	MainPanel:Dock(FILL)
	MainPanel.Paint=function()
		surface.SetDrawColor(80,80,80,255)
		surface.DrawRect(0,0,MainPanel:GetWide(),MainPanel:GetTall()+3)
	end
	local curPos,height=5,ScrH()/8
	local categories={}
	local origHeight=Frame:GetTall()
	for name,info in pairs(buyCategories) do
		local category=MainPanel:Add("DButton")
		category:SetSize(0,height)
		category:Dock(TOP)
		category:DockMargin( 0, 0, 0, 5 )
		category:SetText("")
		surface.SetFont("MersRadialSmall")
		local textWidth,textHeight=surface.GetTextSize(name)
		local currentlyHovered=false
		category.Paint=function(panel,w,h)
			local hovered=category:IsHovered()
			if currentlyHovered!=hovered then
				if currentlyHovered==false then
					surface.PlaySound("buttonrollover.wav")
				end
				currentlyHovered=hovered
			end
			if hovered then
				surface.SetDrawColor(Color(40,40,40,255))
			else
				surface.SetDrawColor(Color(50,50,50,255))
			end
			surface.DrawRect(0,0,w,h)
			surface.SetFont("MersRadialSmall")
			if hovered then
				surface.SetTextColor(Color(205,205,205,255))
			else
				surface.SetTextColor(Color(255,255,255,255))
			end
			surface.SetTextPos((w-textWidth)/2,(h-textHeight)/2)
			surface.DrawText(name)
		end
		local wepPanels={}
		category.DoClick=function()
			surface.PlaySound("buttonclick.wav")
			for i,cat in pairs(categories) do
				cat:SetVisible(false)
			end
			local currentPos=5
			MainPanel:GetVBar():SetScroll(0)
			for wepName,wepInfo in pairs(info) do
				if not((wepInfo.team and wepInfo.team!=LocalPlayer().Role) or (wepInfo.allowedMap and wepInfo.allowedMap!=game.GetMap())) then
					local wepPanel=MainPanel:Add("DButton")
					wepPanel:SetSize(0,height)
					wepPanel:Dock(TOP)
					wepPanel:DockMargin( 0, 0, 0, 5 )
					wepPanel:SetText("")
					surface.SetFont("MersRadialSmall_QM")
					local wepWidth,wepHeight=surface.GetTextSize(wepName)
					local iscurrentlyHovered=false
					local iconWidth=wepInfo.width or 1
					local slider
					if wepInfo.ammoType then
						local w,h=MainPanel:GetWide(),wepPanel:GetTall()
						slider=vgui.Create("DNumSlider",wepPanel)
						slider:SetPos(w/6,h-slider:GetTall())
						slider:SetWide(w/2)
						slider:SetDecimals(0)
						slider:SetMin(1)
						slider:SetMax(100)
						slider:SetValue(1)
						slider.OnValueChanged=function(panel,val)
							slider:SetValue(math.Round(val))
						end
					end
					wepPanel.Paint=function(panel,w,h)
						local isHovered=wepPanel:IsHovered()
						if iscurrentlyHovered!=isHovered then
							if iscurrentlyHovered==false then
								surface.PlaySound("buttonrollover.wav")
							end
							iscurrentlyHovered=isHovered
						end
						if isHovered then
							surface.SetDrawColor(Color(40,40,40,255))
						else
							surface.SetDrawColor(Color(50,50,50,255))
						end
						surface.DrawRect(0,0,h*iconWidth,h)
						surface.DrawRect(h*iconWidth+5,0,w-(h+5)*2-h*(iconWidth-1),h)
						surface.DrawRect(w-h,0,h,h)
						local texture=wepInfo.texture
						if wepInfo.ammoType then texture=RoundTexturesInv[wepInfo.ammoType] end
						surface.SetDrawColor(Color(255,255,255,255))
						surface.SetMaterial(texture)
						surface.DrawTexturedRect(5,5,h*iconWidth-5,h-5)
						surface.SetFont("MersRadialSmall_QM")
						if isHovered then
							surface.SetTextColor(Color(205,205,205,255))
						else
							surface.SetTextColor(Color(255,255,255,255))
						end
						local cost=wepInfo.cost or 1000
						if slider then cost=cost*slider:GetValue() end
						local numWidth,numHeight=surface.GetTextSize(cost.."$")
						surface.SetTextPos(w-(h+numWidth)/2,(h-numHeight)/2)
						surface.DrawText(cost.."$")
						surface.SetTextPos(h*iconWidth+5+(w-(h+5)*2-h*(iconWidth-1)-wepWidth)/2,(h-wepHeight)/2)
						surface.DrawText(wepName)
						if slider then
							local packWidth,packHeight=surface.GetTextSize("("..wepInfo.amt..")")
							surface.SetTextPos(h+5+(w-(h+5)*2-packWidth)/2,slider:GetY()-packHeight/2-5)
							surface.DrawText("("..wepInfo.amt..")")
						end
					end
					wepPanel.DoClick=function()
						local cost=wepInfo.cost
						if wepInfo.amt then cost=wepInfo.cost*slider:GetValue() end
						if LocalPlayer().Money>=cost then
							if not(wepInfo.class and (LocalPlayer():HasWeapon(wepInfo.class) or LocalPlayer().Equipment[HMCD_EquipmentNames[tonumber(wepInfo.class)]])) then
								local hassimiliarEquipment=false
								if name=="Equipment" then
									for armorTyp,inf in pairs(HMCD_ArmorNames) do
										if HMCD_ArmorNames[armorTyp][wepName] then
											if LocalPlayer():GetNWString(armorTyp)!="" then hassimiliarEquipment=true break end
										end
									end
								end
								if not(hassimiliarEquipment) then
									surface.PlaySound("buttonclick.wav")
									LocalPlayer().Money=LocalPlayer().Money-cost
									net.Start("hmcd_csbuy_give")
									net.WriteString(wepInfo.class or wepInfo.ammoType)
									if wepInfo.amt then
										net.WriteInt(wepInfo.amt*slider:GetValue(),13)
									end
									net.SendToServer()
									if tonumber(wepInfo.class) then
										LocalPlayer().Equipment[HMCD_EquipmentNames[tonumber(wepInfo.class)]]=true
									end
								else
									LocalPlayer():PrintMessage(HUD_PRINTTALK,"You already have armor for this part of body!")
									surface.PlaySound("weapon_cant_buy.wav")
								end
							else
								surface.PlaySound("weapon_cant_buy.wav")
								LocalPlayer():PrintMessage(HUD_PRINTTALK,"You already have this item!")
							end
						else
							surface.PlaySound("weapon_cant_buy.wav")
							LocalPlayer():PrintMessage(HUD_PRINTTALK,"You don't have enough money!")
						end
					end
					if wepInfo.attachments then
						for j,att in pairs(wepInfo.attachments) do
							local attPanel=vgui.Create("DButton",wepPanel)
							local w,h=MainPanel:GetWide(),wepPanel:GetTall()
							local decrease=math.Round(#wepInfo.attachments/2)
							if #wepInfo.attachments % 2 == 0 then decrease=decrease+0.5 end
							attPanel:SetPos(h*iconWidth+5+(w-(h+5)*2-h*(iconWidth-1)-height/4)/2+(height/4+5)*(j-decrease),wepPanel:GetTall()-height/4-5)
							attPanel:SetSize(height/4,height/4)
							attPanel:SetText("")
							local isHov=false
							local attMaterial=Material(HMCD_EquipmentInfo[att][4])
							attPanel.Paint=function(panel,w,h)
								local isHovered=attPanel:IsHovered()
								if isHov!=isHovered then
									if isHov==false then
										surface.PlaySound("buttonrollover.wav")
									end
									isHov=isHovered
								end
								if isHovered then
									LocalPlayer().HoveredAttachment={pan=attPanel,money=HMCD_EquipmentInfo[att].cost}
									surface.SetDrawColor(Color(80,80,80,255))
								else
									surface.SetDrawColor(Color(100,100,100,255))
								end
								surface.DrawRect(0,0,w,h)
								surface.SetMaterial(attMaterial)
								if isHovered then
									surface.SetDrawColor(Color(80,80,80,255))
								else
									surface.SetDrawColor(Color(255,255,255,255))
								end
								surface.DrawTexturedRect(5,5,w-10,h-10)
							end
							attPanel.DoClick=function()
								if LocalPlayer():HasWeapon(wepInfo.class) then
									local wep=LocalPlayer():GetWeapon(wepInfo.class)
									if LocalPlayer().Money>=HMCD_EquipmentInfo[att].cost then
										local canAttach=true
										if wep:GetNWBool(atts_simplified[att]) then
											LocalPlayer():PrintMessage(HUD_PRINTTALK, "You already have this attachment!")
											canAttach=false
										elseif att==HMCD_LASERBIG and (wep:GetNWBool("Sight") or wep:GetNWBool("Sight2") or wep:GetNWBool("Sight3")) and not(wep.MultipleRIS) then
											LocalPlayer():PrintMessage(HUD_PRINTTALK, "You can't apply this attachment! There isn't enough space!")
											canAttach=false
										elseif (att==HMCD_EOTECH or att==HMCD_KOBRA or att==HMCD_AIMPOINT) and wep:GetNWBool("Laser") and not(wep.MultipleRIS) then
											LocalPlayer():PrintMessage(HUD_PRINTTALK, "You can't apply this attachment! There isn't enough space!")
											canAttach=false
										elseif (att==HMCD_KOBRA or att==HMCD_AIMPOINT or att==HMCD_EOTECH) and (wep:GetNWBool("Sight") or wep:GetNWBool("Sight2") or wep:GetNWBool("Sight3")) then
											LocalPlayer():PrintMessage(HUD_PRINTTALK, "You already have a sight attached!")
											canAttach=false
										end
										if canAttach then
											net.Start("hmcd_csbuy_give")
											net.WriteString(tostring(att))
											net.WriteEntity(wep)
											net.SendToServer()
											LocalPlayer().Money=LocalPlayer().Money-HMCD_EquipmentInfo[att].cost
											surface.PlaySound("buttonclick.wav")
										else
											surface.PlaySound("weapon_cant_buy.wav")
										end
									else
										LocalPlayer():PrintMessage(HUD_PRINTTALK,"You don't have enough money!")
										surface.PlaySound("weapon_cant_buy.wav")
									end
								else
									surface.PlaySound("weapon_cant_buy.wav")
									LocalPlayer():PrintMessage(HUD_PRINTTALK,"You don't have this weapon!")
								end
							end
						end
					end
					currentPos=currentPos+wepPanel:GetTall()+5
					table.insert(wepPanels,wepPanel)
				end
			end
			local homePanel=MainPanel:Add("DButton")
			homePanel:SetSize(0,height)
			homePanel:Dock(TOP)
			homePanel:DockMargin( MainPanel:GetWide()/4, 0, MainPanel:GetWide()/4, 5 )
			homePanel:SetText("")
			home=homePanel
			surface.SetFont("MersRadialSmall")
			local homeWidth,homeHeight=surface.GetTextSize("Home")
			local iscurrentlyHovered=false
			homePanel.Paint=function(panel,w,h)
				local isHovered=homePanel:IsHovered()
				if iscurrentlyHovered!=isHovered then
					if iscurrentlyHovered==false then
						surface.PlaySound("buttonrollover.wav")
					end
					iscurrentlyHovered=isHovered
				end
				if isHovered then
					surface.SetDrawColor(Color(40,40,40,255))
				else
					surface.SetDrawColor(Color(50,50,50,255))
				end
				surface.DrawRect(0,0,w,h)
				surface.SetFont("MersRadialSmall")
				if isHovered then
					surface.SetTextColor(Color(205,205,205,255))
				else
					surface.SetTextColor(Color(255,255,255,255))
				end
				surface.SetTextPos((w-homeWidth)/2,(h-homeHeight)/2)
				surface.DrawText("Home")
			end
			homePanel.DoClick=function()
				MainPanel:GetVBar():SetScroll(0)
				Frame:SetTall(origHeight)
				MainPanel:Dock(FILL)
				surface.PlaySound("buttonclick.wav")
				for i,pan in pairs(wepPanels) do
					pan:Remove()
					wepPanels[i]=nil
				end
				for i,pan in pairs(categories) do
					pan:SetVisible(true)
				end
			end
			currentPos=currentPos+homePanel:GetTall()
			if(currentPos<MainPanel:GetTall()) then
				MainPanel:Dock(NODOCK)
				MainPanel:SetTall(currentPos+20)
				Frame:SetTall(currentPos+30)
			end
			table.insert(wepPanels,homePanel)
		end
		table.insert(categories,category)
		curPos=curPos+category:GetTall()+5
	end
	Frame:Center()
end

-- Forgiveness menu --

net.Receive("hmcd_forgive",function()
	LocalPlayer().ForgiveTable=net.ReadTable()
	LocalPlayer().ForgiveTime=CurTime()+11
end)

function GM:OpenForgivenessMenu()
	LocalPlayer().ForgivenessMenu=true
	local DermaPanel=vgui.Create("DFrame")
	local size=ScrW()/8
	DermaPanel:SetSize(size,size)
	DermaPanel:SetTitle("Forgiveness Menu")
	DermaPanel:SetVisible(true)
	DermaPanel:SetDraggable(true)
	DermaPanel:ShowCloseButton(true)
	DermaPanel:MakePopup()
	DermaPanel:Center()
	DermaPanel.OnClose=function()
		LocalPlayer().ForgivenessMenu=nil
	end

	local MainPanel=vgui.Create("DPanel",DermaPanel)
	MainPanel:SetPos(size/40,size/12.8)
	MainPanel:SetSize(19*size/20,size/1.1)
	MainPanel.Paint=function(pnl,w,h)
		surface.SetDrawColor(0,20,40,255)
		surface.DrawRect(0,0,w,h+3)
		draw.SimpleText( "How much guilt should be reduced?", "MersText1", w/2, 0, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	end
	surface.SetFont("MersText1")
	local titleWidth,titleHeight=surface.GetTextSize( "How much guilt should be reduced?" )
	local curPos=titleHeight+size/35
	local plyLines={}
	local longestLine=titleWidth+size/20
	for i,info in pairs(LocalPlayer().ForgiveTable) do
		local halfForgive
		local curWidth=size/35
		local nick = vgui.Create("DLabel",MainPanel)
		nick:SetPos(curWidth,curPos)
		nick:SetFont("MersRadialSmall")
		nick:SetText(info[1])
		local col=info[3]:ToColor()
		nick:SetColor(col)
		nick:SizeToContents()
		curWidth=curWidth+nick:GetWide()+5
		local forgive=vgui.Create("DButton",MainPanel)
		forgive:SetPos(curWidth,curPos)
		forgive:SetSize(size/4,nick:GetTall())
		forgive:SetText("")
		forgive.Paint=function(panel,w,h)
			local textColor,panelColor=color_white,Color(155,155,155,255)
			if forgive:IsHovered() then
				panelColor=Color(105,105,105,255)
				textColor=Color(205,205,205,255)
			end
			surface.SetDrawColor(panelColor)
			surface.DrawRect(0,0,w,h)
			draw.SimpleText( "100%", "MersRadialSmall_QM", w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		forgive.DoClick=function()
			halfForgive:Remove()
			forgive:Remove()
			nick:Remove()
			plyLines[i]=nil
			curPos=titleHeight+size/35
			for i,line in pairs(plyLines) do
				for j,pan in pairs(line) do
					pan:SetY(curPos)
				end
				curPos=curPos+line[1]:GetTall()+5
			end
			LocalPlayer().ForgiveTable[i]=nil
			net.Start("hmcd_forgive_tosv")
			net.WriteString(info[2])
			net.WriteInt(1,3)
			net.SendToServer()
			if table.IsEmpty(plyLines) then DermaPanel:Close() end
		end
		curWidth=curWidth+forgive:GetWide()+5
		halfForgive=vgui.Create("DButton",MainPanel)
		halfForgive:SetPos(curWidth,curPos)
		halfForgive:SetSize(size/4,nick:GetTall())
		halfForgive:SetText("")
		halfForgive.Paint=function(panel,w,h)
			local textColor,panelColor=color_white,Color(155,155,155,255)
			if halfForgive:IsHovered() then
				panelColor=Color(105,105,105,255)
				textColor=Color(205,205,205,255)
			end
			surface.SetDrawColor(panelColor)
			surface.DrawRect(0,0,w,h)
			draw.SimpleText( "50%", "MersRadialSmall_QM", w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		halfForgive.DoClick=function()
			halfForgive:Remove()
			forgive:Remove()
			nick:Remove()
			plyLines[i]=nil
			curPos=titleHeight+size/35
			for i,line in pairs(plyLines) do
				for j,pan in pairs(line) do
					pan:SetY(curPos)
				end
				curPos=curPos+line[1]:GetTall()+5
			end
			LocalPlayer().ForgiveTable[i]=nil
			net.Start("hmcd_forgive_tosv")
			net.WriteString(info[2])
			net.WriteInt(2,3)
			net.SendToServer()
			if table.IsEmpty(plyLines) then DermaPanel:Close() end
		end
		curWidth=curWidth+halfForgive:GetWide()+5+size/17.5
		if curWidth>longestLine then longestLine=curWidth end
		table.insert(plyLines,{nick,forgive,halfForgive})
		curPos=curPos+nick:GetTall()+5
	end
	MainPanel:SetSize(longestLine-size/20,curPos)
	DermaPanel:SetSize(longestLine,size/12.8+curPos*1.1)
	DermaPanel:Center()
end

net.Receive("hmcd_dm_zone",function()
	local pos=net.ReadVector()
	local radius=net.ReadInt(17)
	local speedMul=net.ReadInt(6)
	local startTime=CurTime()+20
	local mat=Material("hmcd_dmzone")
	LocalPlayer().ZoneSound=CreateSound(LocalPlayer(),"ambient/levels/citadel/citadel_drone_loop5.wav")
	hook.Add("PostDrawTranslucentRenderables","RenderDMZone",function(bDrawingDepth,bDrawingSkybox,isDraw3DSkybox)
		if isDraw3DSkybox then return end
		local newRadius=radius
		if CurTime()>=startTime then
			newRadius=radius-(CurTime()-startTime)*5*speedMul
		end
		render.SetMaterial(mat)
		render.SuppressEngineLighting(true)
		render.DrawSphere(pos,-newRadius,50,50)
		render.SuppressEngineLighting(false)
		local dist=LocalPlayer():GetPos():Distance(pos)
		local diff=math.abs(newRadius-dist)
		if diff<500 then
			LocalPlayer().ZoneSound:PlayEx((250-diff)/250,100 + CurTime() % 1)
		elseif LocalPlayer().ZoneSound:IsPlaying() then
			LocalPlayer().ZoneSound:Stop()
		end
		if newRadius<=0 then LocalPlayer().ZoneSound:Stop() hook.Remove("PostDrawTranslucentRenderables","RenderDMZone") end
	end)
end)