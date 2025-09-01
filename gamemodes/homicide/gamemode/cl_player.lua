
GM.Roles=GM.Roles or {}

local PlayerMeta=FindMetaTable("Player")

local EntityMeta=FindMetaTable("Entity")

function EntityMeta:GetRagdollOwner()
	return self:GetNWEntity("RagdollOwner")
end

net.Receive("hmcd_gaycheck",function()
	net.Start("hmcd_gaycheck")
	net.WriteBool(steamworks.IsSubscribed("3324663643") or steamworks.IsSubscribed("3028582090"))
	net.SendToServer()
end)

net.Receive("hmcd_equipment",function()
	local num=net.ReadInt(6)
	if num!=HMCD_REMOVEEQUIPMENT then
		local eq=HMCD_EquipmentNames[num]
		if not(LocalPlayer().Equipment) then LocalPlayer().Equipment={} end
		local hasEq=tobool(net.ReadBit())
		if not(hasEq) then hasEq=nil end
		LocalPlayer().Equipment[eq]=hasEq
	else
		LocalPlayer().Equipment={}
	end
end)

net.Receive("hmcd_role",function()
	local steamID,role=net.ReadString(),net.ReadString()
	if steamID==LocalPlayer():SteamID() then LocalPlayer().Role=role LocalPlayer().QName=nil end
	GAMEMODE.Roles[steamID]=role
end)

net.Receive("hmcd_act",function()
	LocalPlayer():ConCommand("act "..net.ReadString())
end)

local physFix={
	["models/zombie/classic_legs.mdl"]={
		[1]=9,
		[2]=10,
		[3]=12,
		[4]=13,
		[5]=14,
		[6]=11
	}
}

local tournament_list={
	["t"]={"STEAM_0:0:66280843","STEAM_0:0:171889129","STEAM_0:1:456680881","STEAM_0:1:15604037","STEAM_0:0:244049991","STEAM_0:1:81850653","STEAM_0:1:482713275"},
	["ct"]={"STEAM_0:1:209886229","STEAM_0:1:104041137","STEAM_0:0:27665623","STEAM_0:1:151603548","STEAM_0:1:53574495","STEAM_0:1:596934151","STEAM_0:1:11130054"}
}

concommand.Add("hmcd_tournament_list",function()
	for i,list in pairs(tournament_list) do
		for j,id in pairs(list) do
			steamworks.RequestPlayerInfo( util.SteamIDTo64( id ), function( steamName )
				LocalPlayer():PrintMessage(HUD_PRINTTALK,steamName.." = "..string.upper(i))
			end )
		end
	end
end)

net.Receive("hmcd_csrag",function()
	local ent,mod,position=net.ReadEntity(),net.ReadString(),net.ReadVector()
	local rag=ClientsideRagdoll(mod)
	if not(IsValid(rag)) then return end
	local fix=physFix[mod] or {}
	if IsValid(ent) then
		for i=0,rag:GetPhysicsObjectCount()-1 do
			local phys=rag:GetPhysicsObjectNum(i)
			local Pos, Ang = ent:GetBonePosition( ent:TranslatePhysBoneToBone( fix[i] or i ) )
			phys:SetPos(Pos)
			phys:SetAngles(Ang)
			phys:SetVelocity(ent:GetVelocity()/4)
		end
	else
		rag:GetPhysicsObject():SetPos(position)
	end
	table.insert(GAMEMODE.CSRags,rag)
	rag:SetNoDraw(false)
	rag:DrawShadow(true)
end)

net.Receive("hmcd_radio_static",function()
	local sound="radiorandom/radio"..math.random(1,10)..".wav"
	LocalPlayer():EmitSound("radio/voip_static_loop.wav")
	LocalPlayer():EmitSound(sound)
	local StopTime=CurTime()+SoundDuration(sound)
	hook.Add("Think",tostring(LocalPlayer()).."RadioStatic",function()
		if not(IsValid(LocalPlayer())) then hook.Remove("Think",tostring(LocalPlayer()).."RadioStatic") return end
		if CurTime()>StopTime or not(LocalPlayer():HasWeapon("wep_jack_hmcd_walkietalkie")) then
			LocalPlayer():StopSound("radio/voip_static_loop.wav")
			LocalPlayer():EmitSound("radio/voip_end_transmit_beep_0"..math.random(1,8)..".wav")
			LocalPlayer():StopSound(sound)
			hook.Remove("Think",tostring(LocalPlayer()).."RadioStatic")
		end
	end)
end)

local glowMat=Material("sprites/glow04_noz")

local laserline = Material("cable/smoke")

net.Receive("hmcd_stop_healingbeam",function()
	local jesus=net.ReadEntity()
	if not(IsValid(jesus)) then return end
	jesus.BeamRemovalStart=CurTime()
end)

net.Receive("hmcd_start_healingbeam",function()
	local jesus=net.ReadEntity()
	if not(IsValid(jesus)) then return end
	local str=jesus:EntIndex().."_EmittingBeam"
	local lPly=LocalPlayer()
	local start=CurTime()
	hook.Add("PostDrawTranslucentRenderables",str,function()
		if not(IsValid(jesus)) then hook.Remove("PostDrawTranslucentRenderables",str) return end
		local beamMul
		if jesus.BeamRemovalStart then
			beamMul=math.max(1-(CurTime()-jesus.BeamRemovalStart),0)
			if beamMul==0 then
				hook.Remove("PostDrawTranslucentRenderables",str)
				jesus.BeamRemovalStart=nil
				return
			end
		else
			beamMul=math.min(CurTime()-start,1)
		end
		local aimVec
		local eye1_shared,eye2_shared
		local rag=jesus:GetNWEntity("DeathRagdoll")
		local eyeEnt
		local shootPos
		local eyeAng
		if IsValid(rag) then
			eyeEnt=rag
			local eyeInfo=eyeEnt:GetAttachment(eyeEnt:LookupAttachment("eyes"))
			eyeAng=eyeInfo.Ang
			shootPos=eyeInfo.Pos
			aimVec=eyeAng:Forward()
		else
			aimVec=jesus:GetAimVector()
			shootPos=jesus:GetShootPos()
			eyeAng=jesus:EyeAngles()
			eyeEnt=jesus
		end
		
		local eye_mid=shootPos+eyeAng:Forward()*6
		local eyeAng_right=eyeAng:Right()
		eye1_shared=eye_mid+eyeAng_right*2
		eye2_shared=eye_mid-eyeAng_right*2
		
		local eye1,eye2
		local mat=eyeEnt:GetBoneMatrix(eyeEnt:LookupBone("ValveBiped.Bip01_Head1"))
		local pos,ang=mat:GetTranslation(),mat:GetAngles()
		if (jesus!=lPly and lPly.Spectatee!=jesus) or huy then
			eye1,eye2=pos+ang:Right()*4+ang:Forward()*4.5+ang:Up()*1,pos+ang:Right()*4+ang:Forward()*4.5+ang:Up()*-1
		else
			eye1=eye1_shared
			eye2=eye2_shared
		end
		local yellow=Color(255,255,0)
		yellow.a=beamMul*255
		render.SetMaterial(glowMat)
		render.DrawSprite(eye1,10,10,yellow)
		render.DrawSprite(eye2,10,10,yellow)
		local traceDist=100000*beamMul^4
		local tr1=util.TraceLine({
			start=eye1_shared,
			endpos=eye1_shared+aimVec*traceDist,
			filter=eyeEnt,
			mask=MASK_OPAQUE_AND_NPCS
		})
		local tr2=util.TraceLine({
			start=eye2_shared,
			endpos=eye2_shared+aimVec*traceDist,
			filter=eyeEnt,
			mask=MASK_OPAQUE_AND_NPCS
		})
		render.SetMaterial(laserline)
		
		local endWidth=2*beamMul^4
		
		render.StartBeam(2)
		render.AddBeam(eye1, endWidth, endWidth, yellow)
		render.AddBeam(tr1.HitPos, endWidth, endWidth, yellow)
		render.EndBeam()
		
		render.StartBeam(2)
		render.AddBeam(eye2, endWidth, endWidth, yellow)
		render.AddBeam(tr2.HitPos, endWidth, endWidth, yellow)
		render.EndBeam()
	end)
end)

net.Receive("hmcd_sound_tocl",function(len)
	local str=net.ReadString()
	local ent
	if 8*(#str+1)==len then
		ent=LocalPlayer()
	else
		ent=net.ReadEntity()
	end
	if not(IsValid(ent)) then return end
	ent:EmitSound(str)
	if str=="crawlspace.mp3" and not(LocalPlayer().Lost) then
		local nextThump=CurTime()+1
		hook.Add("Think","Disconnecting",function()
			if nextThump<CurTime() then
				local players={}
				for i,ply in pairs(player.GetAll()) do if not(ply.Hidden or ply==LocalPlayer()) then table.insert(players,ply) end end
				if table.IsEmpty(players) then
					hook.Remove("Think","Disconnecting")
				else
					local rand,ind=table.Random(players)
					rand.Hidden=true
					players[ind]=nil
					nextThump=CurTime()+1.9
					local steamID=rand:SteamID()
					if steamID=="NULL" then steamID="BOT" end
					chat.AddText(color_white, ":offline: Player ", color_red, rand:Nick(), color_grey, " (" .. steamID	.. ") ", color_white, "has left the server: " .. "Disconnected by user.")				
				end
			end
		end)
	end
end)

net.Receive("hmcd_players_disappear",function()
	LocalPlayer().Lost=true
	for i,ply in pairs(player.GetAll()) do
		if ply!=LocalPlayer() then
			ply.RenderOverride=function() end
		end
	end
	for i,rag in pairs(ents.FindByClass("prop_ragdoll")) do
		rag.RenderOverride=function() end
	end
end)

net.Receive("hmcd_flashlight_light",function(len)
	local ply,on=net.ReadEntity(),tobool(net.ReadBit())
	if on and IsValid(ply) then
		if ply:IsPlayer() then
			ply.HMCD_Flashlight=render.GetLightColor(ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_R_Hand")):GetTranslation())
		else
			ply.HMCD_Flashlight=render.GetLightColor(ply:GetPos())
		end
	else
		ply.HMCD_Flashlight=nil
	end
end)

net.Receive("hmcd_nvg",function()
	local Dude=net.ReadEntity()
	Dude.NVGon=tobool(net.ReadBit())
end)

net.Receive("hmcd_roulette",function()
	local wep=net.ReadEntity()
	wep.DrumPos=net.ReadUInt(5)
	wep.DrumBullets=net.ReadTable()
	wep:EnableRoulette()
end)

local specialAccs={
	["BearTrap"]={
		PosInfo={
			["male"]={
				Vec=Vector(0,-4,0),
				Ang=Angle(0,0,90)
			},
			["female"]={
				Vec=Vector(0,-4,0),
				Ang=Angle(0,0,90)
			}
		},
		Sequence="ClosedIdle",
		Model="models/stiffy360/beartrap.mdl"
	},
	["Headcrab"]={
		Bone="ValveBiped.Bip01_Head1",
		PosInfo={
			["male"]={
				Vec=Vector(8.5,-3,0),
				Ang=Angle(100,180,90)
			},
			["female"]={
				Vec=Vector(7,-4,0),
				Ang=Angle(100,180,90)
			}
		},
		Model="models/headcrabclassic.mdl",
		BonePositions={
			[13]=Vector(5,-3,-3),
			[14]=Vector(0,-1,0.5),
			[15]=Vector(0,0.5,0.5),
			[16]=Vector(0,-5,-5)
		},
		BoneAngles={
			[2]=Angle(0,-60,0),
			[3]=Angle(0,-90,0),
			[8]=Angle(0,-60,0),
			[9]=Angle(0,-60,0),
			[10]=Angle(0,60,0),
			[11]=Angle(0,60,0)
		}
	},
	["Headcrab_Fast"]={
		Bone="ValveBiped.Bip01_Head1",
		PosInfo={
			["male"]={
				Vec=Vector(5,-10,1),
				Ang=Angle(100,180,90)
			},
			["female"]={
				Vec=Vector(3,-12,1),
				Ang=Angle(90,180,90)
			}
		},
		BoneAngles={
			[7]=Angle(0,-40,20),
			[8]=Angle(0,-30,-60),
			[9]=Angle(0,30,0),
			[10]=Angle(0,-30,-60),
			[11]=Angle(0,-60,0),
			[13]=Angle(0,-60,0),
			[15]=Angle(0,-60,0),
			[16]=Angle(0,-60,0)
		},
		Model="models/headcrab.mdl"
	},
	["Headcrab_Black"]={
		Bone="ValveBiped.Bip01_Head1",
		PosInfo={
			["male"]={
				Vec=Vector(1,-2,0),
				Ang=Angle(90,180,90)
			},
			["female"]={
				Vec=Vector(3,-2,0),
				Ang=Angle(90,180,90)
			}
		},
		BoneAngles={
			[4]=Angle(0,80,-50),
			[5]=Angle(-30,0,0),
			[7]=Angle(30,80,30),
			[8]=Angle(30,-30,0),
			[19]=Angle(160,60,90),
			[20]=Angle(90,120,-60),
			[21]=Angle(0,-90,0),
			[22]=Angle(0,-30,0)
		},
		Model="models/headcrabblack.mdl"
	}
}

net.Receive("hmcd_special_acc",function()
	local ply,info=net.ReadEntity(),net.ReadTable()
	if not(IsValid(ply)) then return end
	if info.Name then
		if not(ply.ExtraAccs) then ply.ExtraAccs={} ply.ExtraAcc={} end
		local name=info.Name
		ply.ExtraAccs[info.Name]={}
		info.Name=nil
		for i,el in pairs(info) do
			ply.ExtraAccs[name][i]=el
		end
		for i,el in pairs(specialAccs[name]) do
			if not(ply.ExtraAccs[name][i]) then ply.ExtraAccs[name][i]=el end
		end
		if string.find(name,"Headcrab") then ply.Headcrabbed=true end
		if ply.ExtraAccs[name].Bone and isstring(ply.ExtraAccs[name].Bone) then ply.ExtraAccs[name].Bone=ply:LookupBone(ply.ExtraAccs[name].Bone) end
	else
		if ply.ExtraAcc then
			for i,acc in pairs(ply.ExtraAcc) do
				ply.ExtraAcc[i]:Remove()
			end
		end
		ply.ExtraAccs=nil
		ply.ExtraAcc=nil
		ply.Headcrabbed=nil
	end
end)

net.Receive("hmcd_setinventory",function()
	local body,items,ammo,equipment=net.ReadEntity(),net.ReadTable(),net.ReadTable(),net.ReadTable()
	body.Inventory=items
	body.InventoryAmmo=ammo
	body.InventoryEquipment=equipment
	local rpg
	if body.Inventory then
		for i,item in pairs(body.Inventory) do
			if item["Class"]=="wep_jack_hmcd_rpg" then
				rpg=item
				break
			end
		end
	end
	if rpg and body.RenderedWeapons and body.RenderedWeapons["wep_jack_hmcd_rpg_DrawPos"] then
		local rocket=0
		if rpg["Ammo"]<1 then rocket=1 end
		body.RenderedWeapons["wep_jack_hmcd_rpg_DrawPos"]:SetBodygroup(1,rocket)
	end
end)

net.Receive("hmcd_cuffed",function()
	LocalPlayer().Cuffed=tobool(net.ReadBit())
end)

net.Receive("hmcd_bloodlevel",function()
	local ply,level=net.ReadEntity(),net.ReadInt(14)
	ply.BloodLevel=level
end)

net.Receive("hmcd_pepperspray",function()
	local ply,pepper=net.ReadEntity(),net.ReadInt(11)
	ply.PepperSpray=pepper
	if ply.PepperSpray<1 then
		if ply.StartBlink then
			if ply.EyesDir==1 then
				ply.EyeCloseLevel=math.min(255*(CurTime()-ply.StartBlink)*2,255)
			else
				ply.EyeCloseLevel=math.max(0,(ply.EyeCloseLevel or 255)-255*(CurTime()-ply.StartBlink)*2)
			end
			ply.StartBlink=CurTime()
			ply.NextBlink=0
		end
		ply.EyesDir=1
	end
	if (not(ply.NextBlink) or ply.NextBlink<CurTime()) then
		ply.StartBlink=CurTime()
		ply.EyesDir=(ply.EyesDir or -1)*-1
		if ply.EyesDir==1 then
			ply.NextBlink=CurTime()+3
		else
			ply.NextBlink=CurTime()+0.5
		end
		local w,h=ScrW(),ScrH()
		local ind=ply:EntIndex()
		local str="Blink_"..ind
		if not(hook.GetTable()["RenderScreenspaceEffects"][str]) then
			hook.Add("RenderScreenspaceEffects",str,function()
				if not(IsValid(ply)) then hook.Remove("RenderScreenspaceEffects",str) return end
				local t=CurTime()
				
				local spectatee=LocalPlayer()
				if IsValid(GAMEMODE.Spectatee) then spectatee=GAMEMODE.Spectatee end
				if spectatee==ply then
					if ply.EyesDir==1 then
						surface.SetDrawColor(Color(0,0,0,255*(t-ply.StartBlink)*2))
					else
						surface.SetDrawColor(Color(0,0,0,math.max(0,(ply.EyeCloseLevel or 255)-255*(t-ply.StartBlink)*2)))
					end
					surface.DrawRect( -5,-5,w+5,h+5 )
				end
				if ply.PepperSpray<1 and (ply.EyeCloseLevel or 255)-255*(t-ply.StartBlink)*2<=0 then
					hook.Remove("RenderScreenspaceEffects",str)
					ply.EyesDir=nil
					ply.StartBlink=nil
					ply.EyeCloseLevel=nil
				end
			end)
		end
	end
end)

net.Receive("hmcd_chlorine",function()
	local ply,chlorine=net.ReadEntity(),net.ReadInt(11)
	ply.Chlorine=chlorine
end)


net.Receive("hmcd_breakbone",function()
	local typ,amt=net.ReadString(),net.ReadInt(6)
	if not(LocalPlayer().BrokenBones) then LocalPlayer().BrokenBones={} end
	LocalPlayer().BrokenBones[typ]=amt
end)

net.Receive("hmcd_damageorgan",function()
	local ply,organ=net.ReadEntity(),net.ReadString()
	if organ=="Heart" then
		ply.HeartShotTime=CurTime()
		ply.HeartShotMul=1
	elseif organ=="CarotidArtery" then
		ply.HeartShotTime=CurTime()
		ply.HeartShotMul=30
	else
		ply.HeartShotTime=nil
		ply.HeartShotMul=nil
	end
end)

net.Receive("hmcd_adrenaline",function()
	net.ReadEntity().Adrenaline=net.ReadUInt(9)
end)

net.Receive("hmcd_morphine",function()
	net.ReadEntity().Morphine=net.ReadUInt(10)
end)

net.Receive("hmcd_pulse",function()
	local ent=net.ReadEntity()
	if IsValid(ent) then
		ent.Pulse=net.ReadInt(9)
		if ent:GetRagdollOwner() then ent:GetRagdollOwner().Pulse=ent.Pulse end
	end
end)

net.Receive("hmcd_bulletwoosh",function()
	local rand=math.random(1,27)
	if rand<10 then rand="0"..rand end
	LocalPlayer():EmitSound("weapons/bullets/fx/subsonic_"..rand..".wav")
end)

net.Receive("hmcd_updatespeed",function()
	local wep,sprinting=net.ReadEntity(),tobool(net.ReadBit())
	if IsValid(wep) then wep.InSprint=sprinting end
end)

net.Receive("hmcd_updateaim",function()
	local wep,aiming=net.ReadEntity(),tobool(net.ReadBit())
	if IsValid(wep) then wep.InAttack=aiming end
end)

net.Receive("chattext_msg", function (len)
	local msgs = {}
	while true do
		local i = net.ReadUInt(8)
		if i == 0 then break end
		local str = net.ReadString()
		local col = net.ReadVector()
		table.insert(msgs, Color(col.x, col.y, col.z))
		if str=="The {ROLE} died in mysterious circumstances." then
			str=string.Replace(Translate("mysterious_death"),"{ROLE}",string.lower(Translate("killer",nil,GAMEMODE.MainMode,GAMEMODE.Mode)))
		end
		table.insert(msgs, str)
	end

	chat.AddText(unpack(msgs))
end)

net.Receive("msg_clients", function (len)
	local lines = {}
	while net.ReadUInt(8) != 0 do
		local r = net.ReadUInt(8)
		local g = net.ReadUInt(8)
		local b = net.ReadUInt(8)
		local text = net.ReadString()
		table.insert(lines, {color = Color(r, g, b), text = text})
	end
	for k, line in pairs(lines) do
		MsgC(line.color, line.text)
	end
end)

function scare()
	local curAlpha=255
	local w,h=ScrW(),ScrH()
	for i=1,10 do
		sound.PlayFile( "sound/sound.wav", "", function( alert ) if ( IsValid( alert ) ) then alert:Play() end end )
	end
	local snd=CreateSound(LocalPlayer(),"sound/sound.wav")
	snd:PlayEx(1,100)
	local scareMat=Material("models/eu_homicide/brick")
	local lastUpdate=0
	hook.Add("RenderScreenspaceEffects","Scare",function()
		if not(snd:IsPlaying()) then
			snd:PlayEx(1,100)
			for i=1,10 do
				sound.PlayFile( "sound/sound.wav", "", function( alert ) if ( IsValid( alert ) ) then alert:Play() end end )
			end
		end
		gui.HideGameUI()
		input.SetCursorPos(ScrW()/2,ScrH()/2)
		surface.SetDrawColor(Color(255,255,255,255))
		surface.SetMaterial(scareMat)
		surface.DrawTexturedRect(-5,-5,w+5,h+5)
		surface.SetDrawColor(Color(255,255,255,curAlpha))
		surface.DrawRect(-5,-5,w+5,h+5)
		if lastUpdate<CurTime() then curAlpha=math.Clamp(curAlpha*-1,-255,255) lastUpdate=CurTime()+0.05 end
		for i,pan in pairs(vgui.GetWorldPanel():GetChildren()) do
			if pan.Close then pan:Close() end
		end
	end)
end

local NextFake=0

local possessableNPCs={
	["npc_metropolice"]=true,
	["npc_combine_s"]=true,
	["ent_jack_hmcd_spawnnest"]=true
}

local nextHeadlightToggle=0

local nestBuyInfo={
	[1]=40
}

hook.Add("PlayerBindPress","HMCD_PlayerBindPress",function(ply,bind,pressed)
	if (ply.Cuffed and not(IsValid(ply:GetNWEntity("Fake")))) and ply:Alive() and (bind=="+attack" or bind=="+attack2" or bind=="+use" or bind=="lastinv" or bind=="invprev" or bind=="invnext") then
		return true
	end
	if bind=="+zoom" and NextFake<CurTime() then
		NextFake=CurTime()+0.1
		RunConsoleCommand("fake", LocalPlayer() )
	end
	if(not(GetViewEntity()==ply))then
		RunConsoleCommand("hmcd_lockedcontrols",bind)
	end
	if (GAMEMODE.Mode=="Zombie")and(ply.Role=="killer")then
		if (bind=="gmod_undo" or bind=="undo") and LocalPlayer().ZombieMaster then
			if LocalPlayer().ClickerEnabled then
				gui.EnableScreenClicker(false)
				LocalPlayer().ClickerEnabled=false
			else
				gui.EnableScreenClicker(true)
				LocalPlayer().ClickerEnabled=true
			end
		elseif bind=="impulse 100" and LocalPlayer().ZVUnlocked and not(!LocalPlayer().ZombieMaster and !LocalPlayer():Alive()) and not(LocalPlayer():GetNWString("Class")=="fast") then
			if (not(ply.NextVisionChange) or ply.NextVisionChange<CurTime()) then
				ply.NextVisionChange=CurTime()+.75
				ply.ZombieVisionStart=CurTime()
				ply.ZombieVisionOnChange=ply.ZombieVision
				ply.ZombieVisionDir=(ply.ZombieVisionDir or -1)*-1
				if ply.ZombieVisionDir==1 then
					ply:EmitSound("npc/stalker/breathing3.wav", 0, 230)
				else
					ply:EmitSound('npc/zombie/zombie_pain6.wav',100,110)
				end
			end
		end
	end
	if IsValid(LocalPlayer().Nest) and string.find(bind,"slot") then
		local num=tonumber(bind[5])
		if nestBuyInfo[num] then
			if LocalPlayer().ZPoints>=nestBuyInfo[num] then
				if LocalPlayer().Nest:GetNWInt(num.."_zombs")<10 then
					net.Start("hmcd_nest_add")
					net.WriteInt(num,5)
					net.WriteEntity(LocalPlayer().Nest)
					net.SendToServer()
					LocalPlayer().ZPoints=LocalPlayer().ZPoints-nestBuyInfo[num]
				else
					LocalPlayer():PrintMessage(HUD_PRINTTALK,"The nest can't fit any more zombies of this type!")
				end
			else
				LocalPlayer():PrintMessage(HUD_PRINTTALK,"You don't have enough points!")
			end
		end
	end
	if bind=="+use" and GAMEMODE.Mode=="Zombie" and ply.Role=="killer" and ply:Alive() and not(IsValid(ply:GetNWEntity("Fake"))) then return true end
	if bind=="impulse 100" then
		if not(LocalPlayer().ForgivenessMenu or ply:Alive()) and LocalPlayer().ForgiveTable and not(table.IsEmpty(LocalPlayer().ForgiveTable)) then
			GAMEMODE:OpenForgivenessMenu()
		end
	end
	if bind=="+use" and not(LocalPlayer():Alive()) and (GAMEMODE.Mode=="Hl2_WT" or GAMEMODE.Mode=="Zombie") and LocalPlayer():Team()==2 then
		local tr=LocalPlayer():GetEyeTrace()
		if IsValid(tr.Entity) and possessableNPCs[tr.Entity:GetClass()] and not(LocalPlayer().ZombieMaster) then
			if not(LocalPlayer().NextPossess and LocalPlayer().NextPossess>CurTime()) then
				LocalPlayer().QName=nil
				net.Start("hmcd_possess_npc")
				net.WriteEntity(tr.Entity)
				net.SendToServer()
			else
				local secs=math.Round(LocalPlayer().NextPossess-CurTime())
				local ending="s"
				if secs<=1 then secs="" ending="" else secs=secs.." " end
				LocalPlayer():PrintMessage(HUD_PRINTTALK,"You have to wait for another "..secs.."second"..ending.." before possessing this NPC!")
			end
		end
	end
	if (bind=="+attack" or bind=="+attack2") and GAMEMODE.SpectateTime and GAMEMODE.SpectateTime>CurTime() and not(LocalPlayer():Alive()) then
		return true
	end
end)

local shakeMul={
	["russian"]=0.8,
	["ukrainian"]=0.8,
	["killer"]=0.5,
	["combine"]=0.5,
	["police"]=0.5,
	["swat"]=0.5,
	["natguard"]=0.5,
	["freeman"]=0.5,
	["terminator"]=0
}

local WDir=VectorRand():GetNormalized()

hook.Add("CreateMove","HMCD_CreateMove",function(cmd)
	local ply=LocalPlayer()
	local Wep=ply:GetActiveWeapon()
	if IsValid(Wep) then
		if Wep.AimPerc and Wep.AimPerc>=99 then
			local Amt,Sporadicness=30,20
			if(ply:Crouching())then Amt=Amt/2 end
			if shakeMul[ply.Role] then Amt=Amt*shakeMul[ply.Role] end
			if((Wep.Scoped and (not(Wep.DetachableScope) or Wep.DrawnAttachments["Scope"]))and((ply:KeyDown(IN_FORWARD))or(ply:KeyDown(IN_BACK))or(ply:KeyDown(IN_MOVELEFT))or(ply:KeyDown(IN_MOVERIGHT))))then
				Sporadicness=Sporadicness*2
				Amt=Amt*2
			end
			if ply.HeldBreath then
				Sporadicness=Sporadicness/2
				Amt=Amt/2
			end
			--local adrenalineMul=(200+(ply.Adrenaline or 0)*5)/200
			--Amt=Amt*adrenalineMul
			Amt=Amt*(1+(math.max((ply.Pulse or 60)-90,0)/25))
			if Wep.BipodAmt==100 then
				Sporadicness=Sporadicness*.1
				Amt=Amt*.1
			end
			local S=.05
			local EAng=cmd:GetViewAngles()
			local FT=FrameTime()
			WDir=(WDir+FT*VectorRand()*Sporadicness):GetNormalized()
			EAng.pitch=math.NormalizeAngle(EAng.pitch+WDir.z*FT*Amt*S)
			EAng.yaw=math.NormalizeAngle(EAng.yaw+WDir.x*FT*Amt*S)
			cmd:SetViewAngles(EAng)
		end
		if Wep.BipodAngle then
			local ang = cmd:GetViewAngles()
				
			local EA = ply:EyeAngles()
			local dif = math.AngleDifference(EA.y, Wep.BipodAngle.y)
				
			if dif >= 30 then
				ang.y = Wep.BipodAngle.y + 30
			elseif dif <= -30 then
				ang.y = Wep.BipodAngle.y - 30
			end
			
			dif = math.AngleDifference(EA.p, Wep.BipodAngle.p)
		
			if EA.p >= 30 then
				ang.p = 30
			elseif EA.p <= -10 then
				ang.p = -10
			end
			cmd:SetViewAngles(ang)
		end
		if (Wep.GetPouncing and Wep:GetPouncing()) or (Wep.GetHolding and IsValid(Wep:GetHolding())) then
			cmd:SetForwardMove(0)
			cmd:SetSideMove(0)
			cmd:SetUpMove(0)
		end
	end
	if GAMEMODE.Mode=="CS" and GAMEMODE.RoundStartTime+25>CurTime() then
		cmd:SetForwardMove(0)
		cmd:SetSideMove(0)
	end
	if ply:GetNWBool("ZombieHeld") then
		cmd:SetForwardMove(0)
		cmd:SetSideMove(0)
		cmd:SetUpMove(0)
	end
end)

hook.Add("UpdateAnimation", "Zombie Climb", function(ply, velocity, maxseqgroundspeed)
	local wep = ply:GetActiveWeapon()
	if wep.GetClimbing then
		--ply:DoAnimationEvent(ACT_ZOMBIE_CLIMB_UP)
		if wep:GetClimbing() then
			local vel = ply:GetVelocity()
			local speed = vel:LengthSqr()
			if speed > 64 then --8^2
				ply:SetPlaybackRate(math.Clamp(speed / 25600, 0, 1) * (vel.z < 0 and -1 or 1)) --160^2
			else
				ply:SetPlaybackRate(0)
			end

			return true
		end
	end
	if wep.GetClimbingFast then
		if not(ply:IsOnGround()) then
	
			if wep:GetClimbingFast() then
				local vel = ply:GetVelocity()
				local speed = vel:LengthSqr()
				if speed > 64 then --8^2
					ply:SetPlaybackRate(math.Clamp(speed / 25600, 0, 1) * (vel.z < 0 and -1 or 1)) --160^2
				else
					ply:SetPlaybackRate(0)
				end

				return true
			end
			

			if ply:GetCycle()==1 then
				ply:SetCycle(0)
			end

			return true
		end
		if wep:GetPouncing() then
			ply:SetPlaybackRate(0.25)
			ply:SetCycle(0)
		end
		if wep:GetSwinging() then
			if not(ply.PlayingFZAttack) then
				ply.PlayingFZAttack=true
				ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_FRENZY)
			end
		elseif ply.PlayingFZAttack then
			ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_TAUNT_ZOMBIE)
			ply:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
			ply.PlayingFZAttack=nil
		end
	end
end)

local AppearanceMenuOpen=false
local function OpenMenu()
	if(AppearanceMenuOpen)then return end
	AppearanceMenuOpen=true
	local Frame=vgui.Create("DFrame")
	Frame:SetPos(40,80)
	Frame:SetSize(600,450)
	Frame:SetTitle("Homicide Custom Appearance")
	Frame:SetVisible(true)
	Frame:SetDraggable(true)
	Frame:ShowCloseButton(true)
	Frame:MakePopup()
	Frame:Center()
	Frame.OnClose=function()
		hook.Remove("Think","AccInfo")
		AppearanceMenuOpen=false
		modelPanel:Remove()
		for i=0,5 do
			if timer.Exists(tostring(LocalPlayer()).."ResetTimer"..tostring(i).."") then
				timer.Remove(tostring(LocalPlayer()).."ResetTimer"..tostring(i).."")
			end
		end
	end
	local MainPanel=vgui.Create("DPanel",Frame)
	MainPanel:SetPos(305,25)
	MainPanel:SetSize(290,420)
	MainPanel.Paint=function()
		surface.SetDrawColor(21,37,51,255)
		surface.DrawRect(0,0,MainPanel:GetWide(),MainPanel:GetTall()+3)
	end
	--
	local x,y = Frame:GetPos()
	local matindex = HMCD_FindClothingIndex(LocalPlayer():GetModel())
	modelPanel = Frame:Add( "DModelPanel" )
	modelPanel:SetPos( 0, 25 )
	modelPanel:SetSize( 300, 420 )
	modelPanel:SetModel( LocalPlayer():GetModel() )
	modelPanel.Entity:SetSubMaterial(matindex,LocalPlayer():GetSubMaterial(matindex))
	modelPanel.clothes=LocalPlayer():GetSubMaterial(matindex)
	modelPanel.clothes = string.Right(modelPanel.clothes,7)
	modelPanel.clothes = string.Replace(modelPanel.clothes,"/","")
	modelPanel.color=LocalPlayer():GetPlayerColor()
	modelPanel.Entity:SetNWVector("playerColor",modelPanel.color)
	modelPanel.Entity.GetPlayerColor=function(modelEnt)
		return modelEnt:GetNWVector("playerColor")
	end
	for i=0,9 do
		modelPanel.clothes = string.Replace(modelPanel.clothes,tostring(i),"")
	end
	local modelsex
	if string.find(modelPanel:GetModel(),"female") then modelsex="female" elseif string.find(modelPanel:GetModel(),"male") then modelsex="male" end
	modelPanel.Entity:SetNWVarProxy("Accessory",function(ent,name,oldVal,newVal)
		if IsValid(ent.AccessoryModel) --[[and oldVal!=newVal]] then
			ent.AccessoryModel:Remove()
			ent.AccessoryModel=nil
		end
	end)
	modelPanel.Entity:SetNWString("Accessory",LocalPlayer():GetNWString("Accessory"))
	modelPanel.Entity.RenderOverride=function()
		modelPanel.Entity:DrawModel()
		GAMEMODE:RenderAccessories(modelPanel.Entity)
	end
	
	local TLabel=vgui.Create("DLabel",MainPanel)
	TLabel:SetPos(10,0)
	TLabel:SetSize(100,40)
	TLabel:SetText("Name")
	local Text=vgui.Create("DTextEntry",MainPanel)
	Text:SetPos(10,30)
	Text:SetSize(270,20)
	Text:SetText(LocalPlayer():GetNWString("bystanderName"))
	local MdlSelect=vgui.Create("DComboBox",MainPanel)
	MdlSelect:SetPos(10,60)
	MdlSelect:SetSize(150,20)
	local modelname = modelPanel:GetModel()
	local numb=1
	for i=1,9 do
		if string.find(string.Right(modelPanel:GetModel(),7),i)!=nil then numb=i break end
	end
	if string.find(modelname,"female")!=nil then modelname="female" else modelname="male" end
	modelname=tostring(modelname.."0"..numb)
	MdlSelect:SetValue(modelname)
	for k,v in pairs(HMCD_ValidModels)do MdlSelect:AddChoice(v) end
	MdlSelect.OnSelect=function(panel,index,value)
		local startpos = 4
		if string.Left(value,2)=="fe" then startpos=6 modelsex="female" else modelsex="male" end
		local value1 = string.Left(value,startpos)
		local value2 = string.Right(value,2)
		local result = tostring(value1.."_"..value2)
		modelPanel:SetModel("models/player/group01/"..result..".mdl")
		matindex=HMCD_FindClothingIndex("models/player/group01/"..result..".mdl")
		modelPanel.Entity:SetSubMaterial(matindex,"models/humans/"..value1.."/group01/"..modelPanel.clothes)
		modelPanel.Entity:SetSkin(LocalPlayer():GetSkin())
		modelPanel.Entity:SetNWVector("playerColor",modelPanel.color)
	end
	local CLabel=vgui.Create("DLabel",MainPanel)
	CLabel:SetPos(10,160)
	CLabel:SetSize(100,40)
	CLabel:SetText("Clothing Color")
	local Mixer=vgui.Create("DColorMixer",MainPanel)
	Mixer:SetPos(10,190)
	Mixer:SetSize(250,100)
	Mixer:SetPalette(false)
	Mixer:SetAlphaBar(false)
	Mixer:SetWangs(true)
	Mixer:SetColor(Color(LocalPlayer():GetPlayerColor().r*255,LocalPlayer():GetPlayerColor().g*255,LocalPlayer():GetPlayerColor().b*255))
	Mixer.ValueChanged=function(col)
		local vector = Vector(Mixer:GetColor().r/255,Mixer:GetColor().g/255,Mixer:GetColor().b/255)
		modelPanel.Entity:SetNWVector("playerColor",vector)
		modelPanel.color = vector
	end
	local CSelect=vgui.Create("DComboBox",MainPanel)
	CSelect:SetPos(10,300)
	CSelect:SetSize(150,20)
	if modelPanel.clothes!=nil and modelPanel.clothes!="" then
		CSelect:SetValue(modelPanel.clothes)
	else
		CSelect:SetValue("Clothing Style")
	end
	for k,v in pairs(HMCD_ValidClothes)do CSelect:AddChoice(v) end
	function CSelect:OnSelect( index, text, data )
		if modelsex then
			modelPanel.Entity:SetSubMaterial(matindex,"models/humans/"..modelsex.."/group01/"..text)
			modelPanel.clothes=text
		end
	end
	local ASelect=vgui.Create("DComboBox",MainPanel)
	ASelect:SetPos(10,330)
	ASelect:SetSize(150,20)
	if LocalPlayer():GetNWString("Accessory")!="" then
		ASelect:SetValue(LocalPlayer():GetNWString("Accessory"))
	else
		ASelect:SetValue("Accessory")
	end
	for k,v in pairs(HMCD_Accessories) do if not(v.notAllowed) then ASelect:AddChoice(k) end end
	function ASelect:OnSelect( index, text, data )
		modelPanel.Entity:SetNWString("Accessory",text)
	end
	local ClearButton=vgui.Create("DButton",MainPanel)
	ClearButton:SetText("Clear Identity")
	ClearButton.Warnings=0
	ClearButton:SetPos(170,300)
	ClearButton:SetSize(110,50)
	ClearButton.DoClick=function()
		if ClearButton.Warnings==0 then
			for i=0,5 do
				timer.Create(tostring(LocalPlayer()).."ResetTimer"..tostring(i).."", i, 1, function()
					if ClearButton!=nil and ClearButton.Warnings!=0 then
						if i!=5 then
							ClearButton:SetText("Are you sure?\n          "..5-i.."")
						else
							ClearButton:SetText("Clear Identity")
							ClearButton.Warnings=0
						end
					end
				end)
			end
			ClearButton.Warnings=ClearButton.Warnings+1
		elseif ClearButton.Warnings==1 then
			file.Delete("homicide_identity.txt")
			RunConsoleCommand("homicide_identity_reset")
			ClearButton:SetText("Clear Identity")
			ClearButton.Warnings=0
			for i=0,5 do
				if timer.Exists(tostring(LocalPlayer()).."ResetTimer"..tostring(i).."") then
					timer.Remove(tostring(LocalPlayer()).."ResetTimer"..tostring(i).."")
				end
			end
		end
	end
	local DermaButton=vgui.Create("DButton",MainPanel)
	DermaButton:SetText("SET IDENTITY")
	DermaButton:SetPos(10,370)
	DermaButton:SetSize(270,40)
	DermaButton.DoClick=function()
		local Name,Maudel,R,G,B,Clothes,Accessory=Text:GetValue(),MdlSelect:GetValue(),Mixer:GetColor().r/255,Mixer:GetColor().g/255,Mixer:GetColor().b/255,CSelect:GetValue(),ASelect:GetValue()
		RunConsoleCommand("homicide_identity",Name,Maudel,R,G,B,Clothes,Accessory)
		local RawData=tostring(Name).."\n"..tostring(Maudel).."\n"..tostring(R).."\n"..tostring(G).."\n"..tostring(B).."\n"..tostring(Clothes).."\n"..tostring(Accessory)
		file.Write("homicide_identity.txt",RawData)
		Frame:Close()
		AppearanceMenuOpen=false
	end
end

concommand.Add("homicide_appearance_menu",function(ply,cmd,args)
	OpenMenu()
end)

local HMCD_SkillAwards={
	{"pt",4.6,999999},
	{"au",3.7,4.6},
	{"pd",2.9,3.7},
	{"ir",2.2,2.9},
	{"os",1.6,2.2},
	{"ru",1.1,1.6},
	{"ag",.7,1.1},
	{"sn",.4,.7},
	{"ni",.2,.4},
	{"cu",0,.2}
}
local HMCD_ExperienceAwards={
	{"10",15360,999999},
	{"9",7680,15360},
	{"8",3840,7680},
	{"7",1920,3840},
	{"6",960,1920},
	{"5",480,960},
	{"4",240,480},
	{"3",120,240},
	{"2",60,120},
	{"1",0,60}
}

function PlayerMeta:GetAward()
	local Ribbon,Medal,Merit,Demerit,XP=nil,nil,self.HMCD_Merit or 0,self.HMCD_Demerit or 1,self.HMCD_Experience or 0
	if(XP<10)then return Ribbon,Medal end
	local SK=Merit/Demerit
	for key,tab in pairs(HMCD_SkillAwards)do
		if((SK>tab[2])and(SK<=tab[3]))then Medal="vgui/mats_jack_awards/"..tab[1] break end
	end
	for key,tab in pairs(HMCD_ExperienceAwards)do
		if((XP>tab[2])and(XP<=tab[3]))then Ribbon="vgui/mats_jack_awards/"..tab[1] break end
	end
	return Ribbon,Medal
end

local armorTypes={"Mask","Helmet","Bodyvest"}

local armorInfo={ -- right forward up
	["Level III"]={"models/sal/acc/armor01.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(-12.5,-50,0),Angle(0,80,90),.9},["female"]={Vector(-10,-46,0),Angle(0,80,90),.8},["color"]=Vector(.3,.3,.3)},
	["Level IIIA"]={"models/sal/acc/armor01.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(-12.5,-50,0),Angle(0,80,90),.9},["female"]={Vector(-10,-46,0),Angle(0,80,90),.8}},
	["Gas Mask"]={"models/gasmasks/m40.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(2.3,3,-0.4),Angle(90,0,100),.95},["female"]={Vector(2.3,2.3,-0.2),Angle(90,0,100),.85}},
	["NVG"]={"models/arctic_nvgs/nvg_gpnvg.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(-0.75,1.4,0),Angle(90,-90,180)},["female"]={Vector(-0.5,0,0),Angle(90,-90,180)}},
	["ACH"]={"models/barney_helmet.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(1,1,0),Angle(0,-80,-90)},["female"]={Vector(1,1,0),Angle(0,-80,-90),.9},["material"]="models/mat_jack_hmcd_armor",["color"]=Vector(.7,.7,.7)},
	["RiotHelm"]={"models/eu_homicide/helmet.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(0,3,0),Angle(0,-80,-90)},["female"]={Vector(0,1,0),Angle(0,-80,-90),.9}},
	["PoliceVest"]={"models/eu_homicide/armor_on.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(-4,-9,0),Angle(0,80,90)},["female"]={Vector(-3,-12,0),Angle(0,80,90)}},
	["Ballistic Mask"]={"models/jmod/ballistic_mask.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(0.5,3.5,0),Angle(0,-80,-90)},["female"]={Vector(1,3,0),Angle(0,-80,-90),.9},["color"]=Vector(.1,.1,.1)},
	["Motorcycle"]={"models/dean/gtaiv/helmet.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(-0.5,3.8,0),Angle(90,270,180)},["female"]={Vector(-0.5,2.3,0),Angle(90,270,180)},func=function(csMod,ply) csMod:SetSkin(ply:GetNWInt("Helmet_Color")) end}
}

local ZombTypes={
	["npc_zombie"]=true,
	["npc_zombie_torso"]=true,
	["npc_fastzombie"]=true,
	["npc_fastzombie_torso"]=true,
	["npc_poisonzombie"]=true,
	["npc_zombine"]=true
}

local function jetpack_fuelburn(jetpack)
	if jetpack.NextEmit<CurTime() then
		local owner=jetpack.Owner
		if IsValid(owner:GetRagdollOwner()) then owner=owner:GetRagdollOwner() end
			if owner:IsPlayer() and owner:Alive() then
			jetpack.NextEmit=CurTime()+.1
			local effData=EffectData()
			effData:SetEntity(jetpack.Owner)
			util.Effect("eff_jack_hmcd_jetfuel",effData)
		end
	end
end

function GM:RenderAccessories(ply)
	if not(ply.ModelSex) then
		if string.find(ply:GetModel(),"female") then ply.ModelSex="female" else ply.ModelSex="male" end
		ply.CurArmor={}
	end
	local accName=ply:GetNWString("Accessory")
	local AccInfo=HMCD_Accessories[accName]
	if AccInfo and AccInfo[1] and not(AccInfo.isHat and ply:GetNWString("Helmet")!="") then
		if not(ply.AccessoryModel) then
			ply.AccessoryModel=ClientsideModel(AccInfo[1])
			ply.AccessoryModel:SetPos(ply:GetPos())
			ply.AccessoryModel:SetParent(ply)
			ply.AccessoryModel.Owner=ply
			ply.AccessoryModel:SetSkin(AccInfo[3])
			local scale=AccInfo.scale or AccInfo[ply.ModelSex][3]
			if AccInfo.models and AccInfo.models then
				local info
				local mod=ply:GetModel()
				for model,inf in pairs(AccInfo.models) do
					if string.find(mod,model) then info=inf break end
				end
				if info then
					ply.AccessoryModel.PosInfo=info
					scale=info.scale or scale
				end
			end
			if scale then ply.AccessoryModel:SetModelScale(scale,0) end
			local Mats=ply.AccessoryModel:GetMaterials()
			for key,mat in pairs(Mats) do
				ply.AccessoryModel:SetSubMaterial(key-1,mat)
			end
			ply.AccessoryModel:SetNoDraw(true)
			ply.AccessoryModel:SetPredictable(true)
			if accName=="jetpack" then
				ply.AccessoryModel.NextEmit=0
				ply.AccessoryModel.ExtraDraw=jetpack_fuelburn
			end
		end
		local PosInfo=ply.AccessoryModel.PosInfo or AccInfo[ply.ModelSex]
		local Mat=ply:GetBoneMatrix(ply:LookupBone(AccInfo[2]))
		if not(Mat) then return end
		local Pos,Ang=Mat:GetTranslation(),Mat:GetAngles()
		if Pos and Ang then
			Pos=Pos+Ang:Right()*PosInfo[1].x+Ang:Forward()*PosInfo[1].y+Ang:Up()*PosInfo[1].z
			Ang:RotateAroundAxis(Ang:Right(),PosInfo[2].p)
			Ang:RotateAroundAxis(Ang:Up(),PosInfo[2].y)
			Ang:RotateAroundAxis(Ang:Forward(),PosInfo[2].r)
			ply.AccessoryModel:SetRenderOrigin(Pos)
			ply.AccessoryModel:SetRenderAngles(Ang)
			ply.AccessoryModel:DrawModel()
			if ply.AccessoryModel.ExtraDraw then ply.AccessoryModel:ExtraDraw() end
		end
	elseif IsValid(ply.AccessoryModel) then
		ply.AccessoryModel:Remove()
		ply.AccessoryModel=nil
	end
	if ZombTypes[ply:GetClass()] then return end
	for i,armorType in pairs(armorTypes) do
		local armor=ply:GetNWString(armorType)
		if armorInfo[armor] and (not(ply.ShouldDrawArmor) or ply.ShouldDrawArmor[armorType]) then
			local AccInfo=armorInfo[armor]
			local PosInfo=AccInfo[ply.ModelSex]
			if not(ply.CurArmor[armorType]) then
				ply.CurArmor[armorType]=ClientsideModel(AccInfo[1])
				if AccInfo.material then
					ply.CurArmor[armorType]:SetMaterial(AccInfo.material)
				end
				if AccInfo.func then
					AccInfo.func(ply.CurArmor[armorType],ply)
				end
				ply.CurArmor[armorType]:SetPos(ply:GetPos())
				ply.CurArmor[armorType]:SetParent(ply)
				local Scale=PosInfo[3]
				if Scale then
					ply.CurArmor[armorType]:SetModelScale(Scale,0)
				end
				local Mats=ply.CurArmor[armorType]:GetMaterials()
				for key,mat in pairs(Mats) do
					ply.CurArmor[armorType]:SetSubMaterial(key-1,mat)
				end
				ply.CurArmor[armorType]:SetNoDraw(true)
			end
			local Mat=ply:GetBoneMatrix(ply:LookupBone(AccInfo[2]))
			if Mat then
				local Pos,Ang=Mat:GetTranslation(),Mat:GetAngles()
				if Pos and Ang then
					Pos=Pos+Ang:Right()*PosInfo[1].x+Ang:Forward()*PosInfo[1].y+Ang:Up()*PosInfo[1].z
					Ang:RotateAroundAxis(Ang:Right(),PosInfo[2].p)
					Ang:RotateAroundAxis(Ang:Up(),PosInfo[2].y)
					Ang:RotateAroundAxis(Ang:Forward(),PosInfo[2].r)
					ply.CurArmor[armorType]:SetRenderOrigin(Pos)
					ply.CurArmor[armorType]:SetRenderAngles(Ang)
					local R,G,B=render.GetColorModulation()
					if(AccInfo["color"])then
						render.SetColorModulation(AccInfo["color"].x,AccInfo["color"].y,AccInfo["color"].z)
					end
					ply.CurArmor[armorType]:DrawModel()
					render.SetColorModulation(R,G,B)
				end
			end
		elseif ply.CurArmor[armorType] then
			ply.CurArmor[armorType]:Remove()
			ply.CurArmor[armorType]=nil
		end
	end
	if ply.WepsToRender then
		for class,atts in pairs(ply.WepsToRender) do
			for j,att in pairs(atts) do
				if not(ply.RenderedWeapons[class.."_"..j]) then
					ply.RenderedWeapons[class.."_"..j]=ClientsideModel(att[3])
					ply.RenderedWeapons[class.."_"..j]:SetPos(ply:GetPos())
					ply.RenderedWeapons[class.."_"..j]:SetParent(ply)
					if att[4] then
						ply.RenderedWeapons[class.."_"..j]:SetModelScale(att[4],0)
					end
					if att.bodygroups then
						for i,val in pairs(att.bodygroups) do
							ply.RenderedWeapons[class.."_"..j]:SetBodygroup(i,val)
						end
					end
					if att.func then
						att.func(ply)
					end
					local Mats=ply.RenderedWeapons[class.."_"..j]:GetMaterials()
					for key,mat in pairs(Mats) do
						ply.RenderedWeapons[class.."_"..j]:SetSubMaterial(key-1,mat)
					end
					ply.RenderedWeapons[class.."_"..j]:SetNoDraw(true)
				end
				local Mat=ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_Spine4"))
				if Mat then
					local Pos,Ang=Mat:GetTranslation(),Mat:GetAngles()
					if Pos and Ang then
						local Dist=0
						if ply:GetNWString("Bodyvest")!="" then Dist=2 end
						Pos=Pos+Ang:Right()*(att[1].x+Dist)+Ang:Forward()*att[1].y+Ang:Up()*att[1].z
						--Pos=Pos+Ang:Right()*Dist
						Ang:RotateAroundAxis(Ang:Right(),att[2].p)
						Ang:RotateAroundAxis(Ang:Up(),att[2].y)
						Ang:RotateAroundAxis(Ang:Forward(),att[2].r)
						ply.RenderedWeapons[class.."_"..j]:SetRenderOrigin(Pos)
						ply.RenderedWeapons[class.."_"..j]:SetRenderAngles(Ang)
						ply.RenderedWeapons[class.."_"..j]:DrawModel()
					end
				end
			end
		end
	end
	if ply.ExtraAccs then
		for name,acc in pairs(ply.ExtraAccs) do
			if not(ply.ExtraAcc[name]) then
				ply.ExtraAcc[name]=ClientsideModel(acc.Model)
				ply.ExtraAcc[name]:SetPos(ply:GetPos())
				ply.ExtraAcc[name]:SetParent(ply)
				if acc.BonePositions then
					for i,vec in pairs(acc.BonePositions) do
						ply.ExtraAcc[name]:ManipulateBonePosition(i,vec)
					end
				end
				if acc.BoneAngles then
					for i,ang in pairs(acc.BoneAngles) do
						ply.ExtraAcc[name]:ManipulateBoneAngles(i,ang)
					end
				end
				if acc.Sequence then
					ply.ExtraAcc[name]:SetSequence(acc.Sequence)
				end
				if acc.Scale then
					ply.ExtraAcc[name]:SetModelScale(acc.Scale,0)
				end
				if acc.bodygroups then
					for i,val in pairs(acc.bodygroups) do
						ply.ExtraAcc[name]:SetBodygroup(i,val)
					end
				end
				local Mats=ply.ExtraAcc[name]:GetMaterials()
				for key,mat in pairs(Mats) do
					ply.ExtraAcc[name]:SetSubMaterial(key-1,mat)
				end
				ply.ExtraAcc[name]:SetNoDraw(true)
			end
			local Mat=ply:GetBoneMatrix(acc.Bone)
			if not(Mat) then return end
			local Pos,Ang=Mat:GetTranslation(),Mat:GetAngles()
			if Pos and Ang then
				local PosInfo=acc.PosInfo[ply.ModelSex]
				Pos=Pos+Ang:Right()*PosInfo.Vec.x+Ang:Forward()*PosInfo.Vec.y+Ang:Up()*PosInfo.Vec.z
				Ang:RotateAroundAxis(Ang:Up(),PosInfo.Ang.p)
				Ang:RotateAroundAxis(Ang:Right(),PosInfo.Ang.y)
				Ang:RotateAroundAxis(Ang:Forward(),PosInfo.Ang.r)
				ply.ExtraAcc[name]:SetRenderOrigin(Pos)
				ply.ExtraAcc[name]:SetRenderAngles(Ang)
				ply.ExtraAcc[name]:DrawModel()
			end
		end
	end
end

local SBones={
	["Pistol"]={
		[false]={
			["ValveBiped.Bip01_R_Forearm"]={Angle(0, -110, 0),Angle(0, -70, 30)},
			["ValveBiped.Bip01_R_Hand"]={Angle(45, -50, 0),Angle(25, -120, 0),Vector(0,0,0),Vector(2,2,2)}
		},
		[true]={
			["ValveBiped.Bip01_R_Forearm"]={Angle(30, -10, 0),Angle(60, -10, -60)},
			["ValveBiped.Bip01_R_Hand"]={Angle(40, -110, 50),Angle(90, -50, 50),Vector(0,0,0),Vector(2,2,0)}
		}
	},
	["Rifle"]={
		[false]={
			["ValveBiped.Bip01_R_Forearm"]={Angle(5, 70, -30),Angle(0, 0, 0),Vector(3,0,0)},
			["ValveBiped.Bip01_R_Hand"]={Angle(180, 0, 0),Angle(0, 0, 0),Vector(2,-2,0)},
			["ValveBiped.Bip01_R_UpperArm"]={Angle(0, -20, 0),Angle(0, 0, 0),Vector(0,0,0)},
			["ValveBiped.Bip01_R_Finger0"]={Angle(0, 0, 0),Angle(0, 0, 0),Vector(1.25,1,0.5)},
			["ValveBiped.Bip01_R_Finger1"]={Angle(0, 0, 0),Angle(0, 0, 0),Vector(0,1,1)},
			["ValveBiped.Bip01_L_Forearm"]={Angle(50, -10, 10),Angle(0, 0, 0)},
			["ValveBiped.Bip01_L_Hand"]={Angle(90, 0, 90),Angle(0, 0, 0)},
			["ValveBiped.Bip01_L_UpperArm"]={Angle(0, -30, 0),Angle(0, 0, 0)}
		},
		[true]={
			["ValveBiped.Bip01_R_Forearm"]={Angle(5, 70, -30),Angle(0, 0, 0),Vector(3,0,0)},
			["ValveBiped.Bip01_R_Hand"]={Angle(165, 10, 0),Angle(0, 0, 0),Vector(2,-2,0)},
			["ValveBiped.Bip01_R_UpperArm"]={Angle(0, -20, 0),Angle(0, 0, 0),Vector(0,0,0)},
			["ValveBiped.Bip01_R_Finger0"]={Angle(0, 0, 0),Angle(0, 0, 0),Vector(1.25,1,0.5)},
			["ValveBiped.Bip01_R_Finger1"]={Angle(0, 0, 0),Angle(0, 0, 0),Vector(0,1,1)},
			["ValveBiped.Bip01_L_Forearm"]={Angle(50, -10, 10),Angle(0, 0, 0)},
			["ValveBiped.Bip01_L_Hand"]={Angle(90, 0, 90),Angle(0, 0, 0)},
			["ValveBiped.Bip01_L_UpperArm"]={Angle(0, -30, 0),Angle(0, 0, 0)}
		}
	},
	["SMG"]={
		[false]={
			["ValveBiped.Bip01_R_Forearm"]={Angle(5, 0, -30),Angle(5, 70, -30)},
			["ValveBiped.Bip01_R_Hand"]={Angle(120, -10, 0),Angle(180, 0, 0),Vector(0,0,0),Vector(2,-2,0)},
			["ValveBiped.Bip01_R_UpperArm"]={Angle(0, 0, 0),Angle(0, -20, 0)},
			["ValveBiped.Bip01_L_Forearm"]={Angle(30, -80, 60),Angle(30, -50, 20)},
			["ValveBiped.Bip01_L_Hand"]={Angle(-60, 0, 0),Angle(0, 0, 0)},
			["ValveBiped.Bip01_L_UpperArm"]={Angle(-30, -30, 0),Angle(-10, 0, 0)}
		},
		[true]={
			["ValveBiped.Bip01_R_Forearm"]={Angle(5, 0, -30),Angle(5, 70, -30)},
			["ValveBiped.Bip01_R_Hand"]={Angle(120, -10, 0),Angle(160, 10, 0),Vector(0,0,0),Vector(2,-2,0)},
			["ValveBiped.Bip01_R_UpperArm"]={Angle(0, 0, 0),Angle(0, -20, 0)},
			["ValveBiped.Bip01_L_Forearm"]={Angle(30, -60, 60),Angle(30, -30, 20)},
			["ValveBiped.Bip01_L_Hand"]={Angle(-30, 0, 0),Angle(0, 0, 0)},
			["ValveBiped.Bip01_L_UpperArm"]={Angle(-10, -40, 0),Angle(-10, 0, 0)}
		}
	}
}

local matLight=Material("sprites/light_ignorez")
hook.Add("PostPlayerDraw","HMCD_PostPlayerDraw",function( ply, flags )
	local wep=ply:GetActiveWeapon()
	if IsValid(wep) and wep.GetSuiciding and wep:GetSuiciding() then
		if ply.SuicideDir!=1 then ply.SuicideDir=1 ply.SuicideStartTime=CurTime()-(ply.SuicideProgress or 0) end
		for bone,angl in pairs(SBones[wep.SuicideType][ply:Crouching() or ply:GetNWBool("Crouching")]) do
			local neededTable=1
			if wep:GetNWBool("Suppressor") then neededTable=2 end
			local neededAngle=angl[neededTable]
			local neededPos=angl[neededTable+2]
			if not(ply.SuicideProgress) then ply.SuicideProgress=0 end
			local mul=2
			if ply:GetNWBool("GhostSuiciding") then mul=.2 end
			ply.SuicideProgress=math.Clamp((CurTime()-ply.SuicideStartTime)*mul, 0, 1)	
			ply:ManipulateBoneAngles(ply:LookupBone(bone),neededAngle*ply.SuicideProgress)
			if neededPos then
				ply:ManipulateBonePosition(ply:LookupBone(bone),neededPos*ply.SuicideProgress)
			end
			if (ply:Crouching() or ply:GetNWBool("Crouching")) and not(ply.CTRLHolding) then
				ply.CTRLHolding=true
				ply.SuicideProgress=0
			elseif not(ply:Crouching() or ply:GetNWBool("Crouching")) and (ply.CTRLHolding) then
				ply.CTRLHolding=false
				ply.SuicideProgress=0
			end
		end
	else
		if ply.SuicideDir!=-1 then ply.SuicideDir=-1 if ply.SuicideProgress then ply.SuicideStartTime=CurTime()+ply.SuicideProgress/2 else ply.SuicideStartTime=CurTime() end end
		if ply.SuicideProgress and ply.SuicideProgress>0.01 then
			ply.SuicideProgress=math.Clamp((ply.SuicideStartTime-CurTime())*2, 0, 1)
			local typ=wep.SuicideType or "Rifle"
			for bone,angl in pairs(SBones[typ][ply:Crouching() or ply:GetNWBool("Crouching")]) do
				local neededTable=1
				if wep:GetNWBool("Suppressor") then neededTable=2 end
				local neededAngle=angl[neededTable]
				local neededPos=angl[neededTable+2]
				ply:ManipulateBoneAngles(ply:LookupBone(bone),neededAngle*(ply.SuicideProgress or 0))
				if neededPos then
					ply:ManipulateBonePosition(ply:LookupBone(bone),neededPos*(ply.SuicideProgress or 0))
				end
			end
		end
	end
	if(ply.HMCD_Flashlight)then
		local Mat=ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_R_Hand"))
		local Pos,Ang=Mat:GetTranslation(),Mat:GetAngles()
		local handPos=Pos+Ang:Forward()*2+Ang:Right()*1
		local SelfPos=LocalPlayer():EyePos()
		local ToVec=SelfPos-handPos
		local DotProduct=ToVec:GetNormalized():Dot(ply:GetAimVector())
		if(DotProduct>0)then
			local Visible=!util.QuickTrace(SelfPos,-ToVec,{LocalPlayer(),ply}).Hit
			if(Visible)then
				local lightLevel=render.GetLightColor(handPos)
				ply.HMCD_Flashlight=LerpVector(FrameTime(),ply.HMCD_Flashlight,lightLevel)
				lightLevel=math.max(2-ply.HMCD_Flashlight.x-ply.HMCD_Flashlight.y-ply.HMCD_Flashlight.z,0.25)
				render.SetMaterial(matLight)
				render.DrawSprite(handPos,75*DotProduct*lightLevel,75*DotProduct*lightLevel,Color(255,255,255,150*DotProduct))
				render.DrawSprite(handPos,25*DotProduct*lightLevel,25*DotProduct*lightLevel,Color(255,255,255,255*DotProduct))
			end
		end
	end
	--[[local pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Spine4"))
	pos=pos+ang:Right()*-8+ang:Forward()*-1.5+ang:Up()*-2.5
	render.DrawWireframeSphere( pos, 3, 10, 10,Color( 0, 255, 0 ))
	
	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Spine4"))
	pos=pos+ang:Right()*-9+ang:Forward()*-6.5+ang:Up()*-2.5
	render.DrawWireframeSphere( pos, 3, 10, 10,Color( 0, 255, 0 ))
	
	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Spine4"))
	pos=pos+ang:Right()*-8+ang:Forward()*-1.5+ang:Up()*4
	render.DrawWireframeSphere( pos, 3, 10, 10,Color( 0, 255, 0 ))
	
	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Spine4"))
	pos=pos+ang:Right()*-9+ang:Forward()*-6.5+ang:Up()*4
	render.DrawWireframeSphere( pos, 3, 10, 10,Color( 0, 255, 0 ))
	
	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Spine4"))
	pos=pos+ang:Right()*-9+ang:Forward()*-4+ang:Up()*0.75
	render.DrawWireframeSphere( pos, 3, 10, 10,Color( 255, 0, 0 ))
	
	
	
	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Pelvis"))
	pos=pos+ang:Right()*-6+ang:Forward()*-4+ang:Up()*4.5
	render.DrawWireframeSphere( pos, 2.25, 10, 10, Color( 0, 0, 255 ))
	
	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Pelvis"))
	pos=pos+ang:Right()*-7+ang:Forward()*-1+ang:Up()*4.5
	render.DrawWireframeSphere( pos, 1.5, 10, 10, Color( 0, 0, 255 ))
	
	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Pelvis"))
	pos=pos+ang:Right()*-6+ang:Forward()*4+ang:Up()*4.5
	render.DrawWireframeSphere( pos, 2.5, 10, 10, Color( 0, 255, 255 ))
	
	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Pelvis"))
	pos=pos+ang:Right()*-5+ang:Forward()*1.25+ang:Up()*4
	render.DrawWireframeSphere( pos, 1.25, 10, 10, Color( 0, 255, 255 ))

	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Pelvis"))
	pos=pos+ang:Right()*-1+ang:Forward()*4+ang:Up()*4
	render.DrawWireframeSphere( pos, 3, 10, 10, Color( 255, 0, 255 ))
	
	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Pelvis"))
	pos=pos+ang:Right()*-1+ang:Forward()*0+ang:Up()*4
	render.DrawWireframeSphere( pos, 3, 10, 10, Color( 255, 0, 255 ))
	
	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Pelvis"))
	pos=pos+ang:Right()*-1+ang:Forward()*-4+ang:Up()*4
	render.DrawWireframeSphere( pos, 3, 10, 10, Color( 255, 0, 255 ))
	
	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Pelvis"))
	pos=pos+ang:Right()*3+ang:Forward()*0+ang:Up()*4
	render.DrawWireframeSphere( pos, 2, 10, 10, Color( 255, 255, 255 ))
	
	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Pelvis"))
	pos=pos+ang:Right()*-5+ang:Forward()*3+ang:Up()*-4
	render.DrawWireframeSphere( pos, 1.5, 10, 10, Color( 255, 255, 0 ))
	
	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Pelvis"))
	pos=pos+ang:Right()*-3+ang:Forward()*3+ang:Up()*-4
	render.DrawWireframeSphere( pos, 1.5, 10, 10, Color( 255, 255, 0 ))
	
	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Pelvis"))
	pos=pos+ang:Right()*-5+ang:Forward()*-3+ang:Up()*-4
	render.DrawWireframeSphere( pos, 1.5, 10, 10, Color( 255, 255, 0 ))
	
	pos,ang=ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Pelvis"))
	pos=pos+ang:Right()*-3+ang:Forward()*-3+ang:Up()*-4
	render.DrawWireframeSphere( pos, 1.5, 10, 10, Color( 255, 255, 0 ))]]
end)

hook.Add("KeyPress","HMCD_KeyPress",function(ply,key)
	if (key==IN_USE and ply:KeyDown(IN_ATTACK2)) or (key==IN_ATTACK2 and ply:KeyDown(IN_USE)) then
		local tr=util.QuickTrace(ply:GetShootPos(),ply:GetAimVector()*65,{ply})
		if IsValid(tr.Entity) and tr.Entity:IsRagdoll() and ply:GetNWEntity("Fake")!=tr.Entity and not(string.find(tr.Entity:GetModel(),"zomb") or ply.Lost or string.find(tr.Entity:GetModel(),"charple")) then
			GAMEMODE:LootBody(tr.Entity)
		end
	end
end)

-- VOICE CHAT --

hook.Add("PlayerStartVoice","HMCD_PlayerStartVoice",function(ply)
	if IsValid(ply) then
		local spectatee=LocalPlayer()
		if IsValid(GAMEMODE.Spectatee) and GAMEMODE.Spectatee:IsPlayer() then spectatee=GAMEMODE.Spectatee end
		local dis,MaxDist=ply:GetPos():DistToSqr(spectatee:GetPos()),2250000
		if not(GAMEMODE.Mode=="Strange") then
			if dis>=MaxDist and GAMEMODE.Roles[ply:SteamID()]=="combine" and ply:Alive() and GAMEMODE.Roles[spectatee:SteamID()]=="combine" then
				LocalPlayer():EmitSound("npc/combine_soldier/vo/on"..math.random(1,4)..".wav")
			end
			if GAMEMODE.RadioHolders and GAMEMODE.RadioHolders[ply:EntIndex()] and spectatee:HasWeapon("wep_jack_hmcd_walkietalkie") and not(LocalPlayer().staticPlaying) and tostring(GAMEMODE.RadioHolders[ply:EntIndex()])==spectatee:GetWeapon("wep_jack_hmcd_walkietalkie"):GetFrequency() then
				if dis>=MaxDist then
					LocalPlayer():EmitSound("radio/voip_static_loop.wav")
					LocalPlayer().staticPlaying=true
				end
				if ply==LocalPlayer() then
					LocalPlayer().RadioToggled=true
					net.Start("hmcd_radio_toggle")
					net.WriteEntity(ply)
					net.WriteBit(true)
					net.SendToServer()
				end
			end
		end
		if ply!=LocalPlayer() and (ply:Alive() or LocalPlayer():Alive()) then return true end
	end
end)

hook.Add("PlayerEndVoice","HMCD_PlayerEndVoice",function(ply)
	local radioSpeaking=false
	for i,playah in pairs(player.GetAll()) do
		local dis,MaxDist=playah:GetPos():DistToSqr(ply:GetPos()),2250000
		if playah!=ply and GAMEMODE.RadioHolders and GAMEMODE.RadioHolders[playah:EntIndex()] and playah:VoiceVolume()>0 and dis>=MaxDist then
			local wep=ply:GetWeapon("wep_jack_hmcd_walkietalkie")
			if not(IsValid(wep) and wep:GetFrequency()!=tostring(GAMEMODE.RadioHolders[playah:EntIndex()])) then
				radioSpeaking=true
				break
			end
		end
	end
	if not(radioSpeaking) then
		if LocalPlayer().staticPlaying then 
			LocalPlayer():StopSound("radio/voip_static_loop.wav")
			LocalPlayer():EmitSound("radio/voip_end_transmit_beep_0"..math.random(1,8)..".wav")
			LocalPlayer().staticPlaying=false
		end
	end
	if ply==LocalPlayer() and LocalPlayer().RadioToggled then
		LocalPlayer().RadioToggled=false
		net.Start("hmcd_radio_toggle")
		net.WriteEntity(ply)
		net.WriteBit(false)
		net.SendToServer()
	end
	if GAMEMODE.Roles[ply:SteamID()]=="combine" and ply:Alive() and ply:GetPos():DistToSqr(LocalPlayer():GetPos())>=2250000 and GAMEMODE.Roles[LocalPlayer():SteamID()]=="combine" then
		LocalPlayer():EmitSound("npc/combine_soldier/vo/off"..math.random(1,6)..".wav")
	end
end)
-- VOICE CHAT --