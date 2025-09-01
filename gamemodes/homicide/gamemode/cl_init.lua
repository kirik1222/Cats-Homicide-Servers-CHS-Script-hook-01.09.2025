include( "shared.lua" )
AddCSLuaFile( "shared.lua" )
include( "cl_player.lua" )
include( "cl_rounds.lua" )
include( "cl_hud.lua" )
include( "cl_endroundboard.lua" )
include( "cl_scoreboard.lua" )
include( "cl_spectate.lua")
include( "cl_qmenu.lua" )
include( "value.lua" )

CreateClientConVar( "hmcd_language", "english", true, true, "Changes the language.")

GM.SpectateTime = 0
GM.CSRags={}

local EntityMeta=FindMetaTable("Entity")

CreateClientConVar( "homicide_fov", 0, true, true, "Sets current FoV to the given number. Set to 0 to use default FoV.", 0, 200 )

cvars.AddChangeCallback( "homicide_fov", function(newValue) 
	local fov=newValue
	local wep=LocalPlayer():GetActiveWeapon()
	if IsValid(wep) then
		if not(wep.OldFoV) then wep.OldFoV=wep.ViewModelFOV end
		if fov==0 then fov=wep.OldFoV end
		wep.ViewModelFOV=fov
	end
end)

hook.Add("OnViewModelChanged","HMCD_OnViewModelChanged",function(viewmodel, oldModel, newModel )
	local wep=LocalPlayer():GetActiveWeapon()
	if IsValid(wep) then
		if not(wep.OldFoV) then wep.OldFoV=wep.ViewModelFOV end
		local Con=GetConVar( "homicide_fov" )  
		local fov=Con:GetInt()
		if fov==0 then fov=wep.OldFoV end
		wep.ViewModelFOV=fov
	end
end)

hook.Add("OnEntityCreated","FixFoV",function(ent)
	if IsValid(ent) and ent:IsWeapon() then
		timer.Simple(.01,function()
			if not(ent.OldFoV) then ent.OldFoV=ent.ViewModelFOV end
			local Con=GetConVar( "homicide_fov" )  
			local fov=Con:GetInt()
			if fov==0 then fov=ent.OldFoV end
			ent.ViewModelFOV=fov
			hook.Remove("Think","WaitForSWEP")
		end)
	end
	LocalPlayer().NextFoVCheck=CurTime()+.01
end)

hook.Add("ClientSignOnStateChanged","HMCD_ClientSignOnStateChanged",function(userID,oldState,newState)
	if newState==SIGNONSTATE_FULL then
		if(file.Exists("homicide_identity.txt","DATA"))then
			local RawData=string.Split(file.Read("homicide_identity.txt","DATA"),"\n")
			if(#RawData==7)then
				local DatName,DatAccessory=string.Replace(RawData[1]," ","_"),string.Replace(RawData[7]," ","_")
				LocalPlayer():ConCommand("homicide_identity "..DatName.." "..RawData[2].." "..RawData[3].." "..RawData[4].." "..RawData[5].." "..RawData[6].." "..DatAccessory)
			else
				LocalPlayer():ChatPrint("Homicide: incorrect number of lines in homicide_identity.txt!")
			end
		end
		local file=file.Read("materials/overlays/ba_gasmask.vmt","THIRDPARTY")
		if file and string.find(file,"no_draw") then
			local w,h=ScrW(),ScrH()
			hook.Add("RenderScreenspaceEffects","LOL_LMAO",function()
				surface.SetDrawColor(Color(0,0,0,255))
				surface.DrawRect(-10,-10,w+10,h+10)
				draw.SimpleText( "REMOVE THE GAS MASK TEXTURE REPLACER.", "MersRadial", w/2, h/2, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end)
		end
		timer.Simple(10,function()
			LocalPlayer():SetHull(Vector(-10,-10,0),Vector(10,10,72))
			LocalPlayer():SetHullDuck(Vector(-10,-10,0),Vector(10,10,39))
		end)
	end
end)

function GM:Initialize()
	RegisterLangs()
end

function GM:ShouldDrawWeaponWorldModel(wep)
	if(self.Spectating)then
		local Dude=self.Spectatee
		if((Dude)and(IsValid(Dude))and(Dude:IsPlayer())and(Dude:Alive())) and not(self.SpectateMode==5) then
			if(Dude==wep.Owner)then
				return false
			end
		end
	end
	if wep.Owner:GetNoDraw() or LocalPlayer().Lost then return false end
	return true
end

hook.Add("AdjustMouseSensitivity","HMCD_AdjustMouseSensitivity",function( s )
	local mul,ply=1,LocalPlayer()
	local wep=ply:GetActiveWeapon()
	if ply:KeyDown(IN_SPEED) then mul=mul*0.35 end
	if wep.AimPerc and wep.AimPerc>99 then
		local aimMul=0.5
		if wep.Scoped and (not(wep.DetachableScope) or wep.DrawnAttachments["Scope"]) then aimMul=wep.ScopedSensitivity end
		mul=mul*aimMul
	end
	return mul
end)

local NextEntCheck,NextHolsterUpdate,nextpointadd,nextmenuopen,nextclick,NextVolumeCheck=0,0,0,0,0,0

local ZombTypes={
	["npc_zombie"]=true,
	["npc_zombie_torso"]=true,
	["npc_fastzombie"]=true,
	["npc_fastzombie_torso"]=true,
	["npc_poisonzombie"]=true,
	["npc_zombine"]=true
}

local function CountZombies()
	local count=0
	for typ,bool in pairs(ZombTypes) do
		count=count+#ents.FindByClass(typ)
	end
	return count
end

local HMCD_NoZombieSpawn={
	["zs_storm_hmcd"]={
		{Vector(259, -760, 291),Vector(-537, 64, -70)}
	}
}

local nextghostthink=0

local footstepsnds={
	[84]={"player/footsteps/tile1.wav","player/footsteps/tile2.wav","player/footsteps/tile3.wav","player/footsteps/tile4.wav"},
	[68]={"player/footsteps/dirt1.wav","player/footsteps/dirt2.wav","player/footsteps/dirt3.wav"},
	[87]={"player/footsteps/wood1.wav","player/footsteps/wood2.wav","player/footsteps/wood3.wav","player/footsteps/wood4.wav"},
	[77]={"player/footsteps/metal1.wav","player/footsteps/metal2.wav","player/footsteps/metal3.wav","player/footsteps/metal4.wav"},
	[68]={"physics/cardboard/cardboard_box_impact_soft1.wav","physics/cardboard/cardboard_box_impact_soft2.wav","physics/cardboard/cardboard_box_impact_soft3.wav","physics/cardboard/cardboard_box_impact_soft4.wav"},
	[67]={"player/footsteps/concrete1.wav","player/footsteps/concrete2.wav","player/footsteps/concrete3.wav","player/footsteps/concrete4.wav"},
	[78]={"player/footsteps/sand1.wav","player/footsteps/sand2.wav","player/footsteps/sand3.wav","player/footsteps/sand4.wav"},
	[85]={"player/footsteps/grass1.wav","player/footsteps/grass2.wav","player/footsteps/grass3.wav","player/footsteps/grass4.wav"}
}

hook.Add("Think","HMCD_Think",function()
	local ply=LocalPlayer()
	local Time=CurTime()
	local WillHolsterUpdate
	if NextHolsterUpdate<Time then
		NextHolsterUpdate=Time+.1
		WillHolsterUpdate=true
	end
	for i,playah in ipairs(player.GetAll()) do
		if playah.PainToAdd then
			local oldPain=playah.Pain
			playah.Pain=Lerp(FrameTime(),playah.Pain,playah.PainToAdd)
			if math.abs(playah.PainToAdd-playah.Pain)<0.001 then playah.PainToAdd=nil end
		end
		if WillHolsterUpdate then
			local allowedWeapons={}
			for j,wep in pairs(playah:GetWeapons()) do
				local class=wep:GetClass()
				if HMCD_AttachmentInfo[class] and playah:GetActiveWeapon()!=wep then
					if not(playah.WepsToRender) then playah.WepsToRender={} playah.RenderedWeapons={} end
					if not(playah.WepsToRender[class]) then
						playah.WepsToRender[class]={}
						for att,info in pairs(HMCD_AttachmentInfo[class]) do
							if att=="DrawPos" or wep:GetNWBool(att) then
								playah.WepsToRender[class][att]=info
							end
						end
					end
					allowedWeapons[class]=true
				end
			end
			if playah.WepsToRender then
				for class,wep in pairs(playah.WepsToRender) do
					if not(allowedWeapons[class]) then
						playah.WepsToRender[class]=nil
						for j,info in pairs(HMCD_AttachmentInfo[class]) do
							if IsValid(playah.RenderedWeapons[class.."_"..j]) then
								playah.RenderedWeapons[class.."_"..j]:Remove() 
								playah.RenderedWeapons[class.."_"..j]=nil
							end
						end
					end
				end
			end
		end
	end
	if WillHolsterUpdate then
		for i,rag in ipairs(ents.FindByClass("prop_ragdoll")) do
			if not(rag.HolsterWeps) and rag:GetNWString("HolsterWeps")!="" then
				if not(rag.WepsToRender) then rag.WepsToRender={} rag.RenderedWeapons={} end
				rag.HolsterWeps=util.JSONToTable(rag:GetNWString("HolsterWeps"))
				for class,info in pairs(rag.HolsterWeps) do
					rag.WepsToRender[class]={}
					for att,bool in pairs(info) do
						rag.WepsToRender[class][att]=HMCD_AttachmentInfo[class][att]
					end
				end
			end
		end
	end
	if NextEntCheck<Time then
		NextEntCheck=Time+.1
		
		if ply.Ringing and ply.RingTime and ply.RingTime<Time then
			ply.RingTime=nil
			ply.Ringing:FadeOut(5)
			timer.Simple(5,function()
				if not(ply.RingTime) then
					ply:SetDSP(0)
				end
			end)
		end
		
		local spectatee,spectateRag=ply
		
		if IsValid(GAMEMODE.Spectatee) and GAMEMODE.Spectatee:IsPlayer() then spectatee=GAMEMODE.Spectatee spectateRag=GAMEMODE.Spectatee:GetNWEntity("Fake") end
		
		local tr = spectatee:GetEyeTraceNoCursor()
		if spectatee:Alive() and IsValid(tr.Entity) and not(tr.Entity==GAMEMODE.Spectatee or tr.Entity==spectateRag) and tr.HitPos:DistToSqr(tr.StartPos) < 3600 and not(string.find(tr.Entity:GetModel(),"zomb")) then
			ply.LastLookedCanHide=HMCD_PersonContainers[tr.Entity:GetModel()]!=nil and GetViewEntity()==ply and not(GAMEMODE.Mode=="Zombie" and GAMEMODE.Roles[spectatee:SteamID()]=="killer")
			if not(ply.Lost) and tr.Entity:GetNWString("bystanderName")!="" then
				ply.LastLooked=tr.Entity
				ply.LastLookedName=tr.Entity:GetNWString("bystanderName")
				ply.LastLookedColor=tr.Entity:GetPlayerColor() or Vector()
				ply.LookedFade=Time
				ply.LastLookedIsRag=tr.Entity:IsRagdoll() and not(GAMEMODE.Mode=="Zombie" and GAMEMODE.Roles[spectatee:SteamID()]=="killer")
			end
			if ply.LastLookedCanHide then
				ply.LookedFade=Time
				ply.LastLooked=nil
			end
		end
	end
	
	if(ply.NVGon) and ply:Alive() then
		if not(IsValid(ply.NVG))then
			ply.NVG=ProjectedTexture()
			ply.NVG:SetTexture("effects/flashlight001")
			ply.NVG:SetBrightness(.05)
		else
			local Dir=ply:GetAimVector()
			local Ang=Dir:Angle()
			ply.NVG:SetPos(ply:EyePos()+Dir*10)
			ply.NVG:SetAngles(Ang)
			ply.NVG:SetConstantAttenuation(.2)
			local FoV=ply:GetFOV()
			ply.NVG:SetFOV(FoV)
			ply.NVG:SetFarZ(150000/FoV)
			ply.NVG:Update()
		end
	elseif IsValid(ply.NVG) then
		ply.NVG:Remove()
		ply.NVG=nil
	end
	
	-- ZOMBIE MODE --
	if GAMEMODE.Mode=="Zombie" then
		--[[if NextVolumeCheck<Time then
			NextVolumeCheck=Time+.5
			for i,playah in ipairs(player.GetAll()) do
				local volume=playah:VoiceVolume()
				for typ,bool in pairs(ZombTypes) do
					for j,zomb in ipairs(ents.FindByClass(typ)) do
						local dist=playah:GetPos():DistToSqr(zomb:GetPos())
						if dist<1000000*volume then
							local vec=playah:GetPos()
							vec.x=math.Round(vec.x)
							vec.y=math.Round(vec.y)
							vec.z=math.Round(vec.z)
							if not(zomb:IsNPC()) then LocalPlayer():PrintMessage(HUD_PRINTTALK,"PLEASE TELL THE ADMIN THAT YOU SAW THIS MESSAGE: "..tostring(zomb)) end
							net.Start("hmcd_volumetrigger_zombie")
							net.WriteEntity(zomb)
							net.WriteVector(vec)
							net.SendToServer()
						end
					end
				end
			end
		end]]
		local ply=LocalPlayer()
		if ply.ZombieMaster and nextpointadd<Time then
			nextpointadd=Time+1
			local add,maxp=1,100
			if GAMEMODE.PoliceArrived then add=5 end
			if not(ply.ZPoints) then ply.ZPoints=0 end
			if ply.ZPoints<maxp then
				ply.ZPoints=math.Clamp(ply.ZPoints+add,0,maxp)
			end
		end
		if ply.ClickerEnabled then
			if input.IsMouseDown(107) and nextclick<Time then
				nextclick=Time+0.25
				local vec=gui.ScreenToVector( input.GetCursorPos() )
				local tr=util.QuickTrace(ply:GetShootPos(),vec*100000,{ply})
				local inmenu=false
				if (IsValid(ply.BuyMenu)) then
					local x,y=input.GetCursorPos()
					x,y=ply.BuyMenu:ScreenToLocal(x,y)
					if x>=0 and y>=0 and x<=ply.BuyMenu:GetWide() and y<=ply.BuyMenu:GetTall() then	
						inmenu=true
					end
				end
				if (IsValid(ply.GuideMenu)) then
					local x,y=input.GetCursorPos()
					x,y=ply.GuideMenu:ScreenToLocal(x,y)
					if x>=0 and y>=0 and x<=ply.GuideMenu:GetWide() and y<=ply.GuideMenu:GetTall() then	
						inmenu=true
					end
				end
				if not(input.IsKeyDown(KEY_LCONTROL) or input.IsKeyDown(KEY_RCONTROL)) or ((ply.ChosenPower and (ply.ChosenPower[1]=="Suicide Bomber" or ply.ChosenPower[1]=="Surprise Box")) and not(IsValid(tr.Entity) and ZombTypes[tr.Entity:GetClass()] and not(ply.ChosenPower[1]=="Suicide Bomber" and tr.Entity:GetNWString("Accessory")!="grenade"))) then
					if ply.ChosenZombie and not(inmenu) then
						local zombie,cost=ply.ChosenZombie[1],ply.ChosenZombie[2]
						if istable(zombie) then zombie=table.Random(zombie) end
						if ply.ZPoints>=cost then
							local spawnseen=false
							for i,survivor in pairs(player.GetAll()) do
								if not(GAMEMODE.Roles[survivor:SteamID()]=="killer") and survivor:Alive() then
									local cansee=not(util.QuickTrace(survivor:GetShootPos(),survivor:WorldToLocal(tr.HitPos+Vector(0,0,10)),{survivor}).Hit)
									if cansee then spawnseen=true break end
								end
							end
							local forbiddenZone=false
							if HMCD_NoZombieSpawn[game.GetMap()] then
								for i,info in pairs(HMCD_NoZombieSpawn[game.GetMap()]) do
									if HMCD_InsideVolume(tr.HitPos,info[1],info[2]) then
										forbiddenZone=true
										break
									end
								end
							end
							if not(spawnseen or forbiddenZone) then
								local trcheck=util.QuickTrace(tr.HitPos,-vector_up*1000)
								if(trcheck.Fraction==0) then
									if CountZombies()<10*#player.GetAll() then
										net.Start("hmcd_zombie_spawn")
										net.WriteString(zombie)
										net.WriteVector(tr.HitPos)
										net.SendToServer()
										ply.ZPoints=math.Clamp(ply.ZPoints-cost,0,10000)
									else
										ply:PrintMessage(HUD_PRINTTALK,"You can't spawn any more zombies!")
									end
								end
							end
						end
					elseif ply.ChosenPower and not(inmenu) then
						local name,cost=ply.ChosenPower[1],ply.ChosenPower[2]
						if ply.ZPoints>=cost then
							local success=false
							if name=="Resurrection" then
								if tr.Entity and tr.Entity:GetClass()=="npc_zombie" and not(ply:GetNWBool("GettingResurrected")) then
									if not(ply:Alive()) then
										if ply.ZombiesMarked[tr.Entity:EntIndex()] then ply.ZombiesMarked[tr.Entity:EntIndex()]=nil end
										net.Start("hmcd_zombie_resurrection")
										net.WriteEntity(tr.Entity)
										net.WriteEntity(ply)
										net.SendToServer()
										success=true
									else
										ply:PrintMessage(HUD_PRINTTALK,"You cant use this ability! You are still alive!")
									end
								end
							elseif name=="Fake Death" then
								if IsValid(tr.Entity) and (ZombTypes[tr.Entity:GetClass()] or (tr.Entity:GetClass()=="prop_ragdoll" and tr.Entity:Health()>0)) then
									if ply.ZombiesMarked[tr.Entity:EntIndex()] then ply.ZombiesMarked[tr.Entity:EntIndex()]=nil end
									net.Start("hmcd_zombie_fake")
									net.WriteEntity(tr.Entity)
									net.SendToServer()
									success=true
								end
							elseif name=="Suicide Bomber" then
								print(tr.Entity.ZRigged)
								if IsValid(tr.Entity) and ((ZombTypes[tr.Entity:GetClass()]) or ((tr.Entity:GetClass()=="prop_ragdoll") and tr.Entity:Health()>0) or tr.Entity:GetNWBool("ZRigged")) and not(tr.Entity:GetNWString("Accessory")=="grenade") then
									local visible=false
									for i,survivor in pairs(player.GetAll()) do
										if not(GAMEMODE.Roles[survivor:SteamID()]=="killer") and survivor:Alive() then
											local cansee=not(util.QuickTrace(survivor:GetShootPos(),survivor:WorldToLocal(tr.HitPos+Vector(0,0,10)),{survivor}).Hit)
											if cansee then visible=true break end
										end
									end
									if not(visible) then
										local automatic=input.IsKeyDown(KEY_LCONTROL) or input.IsKeyDown(KEY_RCONTROL)
										net.Start("hmcd_zombie_rig")
										net.WriteEntity(tr.Entity)
										net.WriteBit(automatic)
										net.SendToServer()
										success=true
									end
								end
							elseif name=="Obliterator" then
								if tr.Entity and (string.find(tr.Entity:GetModel(),"zombie") or tr.Entity:GetClass()=="ent_jack_hmcd_spawnnest") and not(tr.Entity:GetRagdollOwner()==ply) then
									if ply.ZombiesMarked[tr.Entity:EntIndex()] then ply.ZombiesMarked[tr.Entity:EntIndex()]=nil end
									net.Start("hmcd_zombie_remove")
									net.WriteEntity(tr.Entity)
									net.SendToServer()
									success=true
								end
							elseif name=="Surprise Box" then
								local ctrl=input.IsKeyDown(KEY_LCONTROL) or input.IsKeyDown(KEY_RCONTROL)
								if not(ctrl) then
									if tr.Entity and table.HasValue(HMCD_PersonContainers,string.lower(tr.Entity:GetModel())) and tr.Entity:Health()>0 then
										if not(tr.Entity.ZRigged or tr.Entity:GetNWBool("ZRigged")) then
											tr.Entity.ZRigged=true
											net.Start("hmcd_zombie_proprig")
											net.WriteEntity(tr.Entity)
											net.SendToServer()
											success=true
										else
											ply:PrintMessage(HUD_PRINTTALK,"This prop had already been rigged!")
										end
									end
								else
									local visible=false
									for i,survivor in pairs(player.GetAll()) do
										if not(GAMEMODE.Roles[survivor:SteamID()]=="killer") and survivor:Alive() then
											local cansee=not(util.QuickTrace(survivor:GetShootPos(),tr.HitPos-survivor:GetShootPos(),{survivor}).Hit and util.QuickTrace(survivor:GetShootPos(),tr.HitPos-survivor:GetShootPos()+vector_up*10,{survivor}).Hit)
											if cansee then visible=true break end
										end
									end
									if not(visible) then
										net.Start("hmcd_zombie_propspawn")
										net.WriteVector(tr.HitPos)
										net.SendToServer()
										success=true
									end
								end
							elseif name=="Room Trapper" then
								if tr.Entity and HMCD_IsDoor(tr.Entity) then
									if not(tr.Entity:GetNWBool("ZLocked"))then
										net.Start("hmcd_zombie_doorlock")
										net.WriteEntity(tr.Entity)
										net.SendToServer()
										success=true
									else
										ply:PrintMessage(HUD_PRINTTALK,"This door is already locked!")
									end
								end
							elseif name=="Fleshy Nest" then
								if not(IsValid(ents.FindByClass("ent_jack_hmcd_spawnnest")[1])) then
									local visible,tooClose=false,false
									local minDist=1000000
									for i,survivor in pairs(player.GetAll()) do
										if not(GAMEMODE.Roles[survivor:SteamID()]=="killer") and survivor:Alive() then
											local cansee=not(util.QuickTrace(survivor:GetShootPos(),survivor:WorldToLocal(tr.HitPos+Vector(0,0,10)),{survivor}).Hit)
											if cansee then visible=true end
											local dist=survivor:GetPos():DistToSqr(tr.HitPos)
											if dist<minDist then tooClose=true end
										end
									end
									if not(visible) then
										if not(tooClose) then
											net.Start("hmcd_zombie_spawn")
											net.WriteString("ent_jack_hmcd_spawnnest")
											net.WriteVector(tr.HitPos)
											net.SendToServer()
											success=true
										else
											ply:PrintMessage(HUD_PRINTTALK,"You are too close to players!")
										end
									end
								else
									ply:PrintMessage(HUD_PRINTTALK,"You already have a nest!")
								end
							end
							if success then
								ply.ZPoints=math.Clamp(ply.ZPoints-cost,0,10000)
							end
						end
					elseif not(inmenu) then
						nextclick=0
						if not(ply.FirstDotChosen) then ply.FirstDotChosen=tr.HitPos end
						ply.SecondDotChosen=tr.HitPos
					end
				else
					if not(inmenu) then
						if tr.Entity and ZombTypes[tr.Entity:GetClass()] then
							local marked_z=tr.Entity
							if not(ply.ZombiesMarked) then ply.ZombiesMarked={} end
							if not(ply.ZombiesMarked[marked_z:EntIndex()]) then
								ply.ZombiesMarked[marked_z:EntIndex()]=true
							else
								ply.ZombiesMarked[marked_z:EntIndex()]=nil
							end
						end
					end
				end
			elseif input.IsMouseDown(108) and nextclick<Time then
				nextclick=Time+0.25
				if ply.ZombiesMarked then
					for ind,bool in pairs(ply.ZombiesMarked) do
						local npc=Entity(ind)
						if IsValid(npc) then
							local NPCPos=npc:GetPos()
							local WallCheck=util.TraceLine({start=ply:GetShootPos(),endpos=NPCPos+Vector(0,0,20),filter=zombs})
							if not(WallCheck.HitWorld)then
								local vec=gui.ScreenToVector( input.GetCursorPos() )
								local tr=util.QuickTrace(ply:GetShootPos(),vec*100000,{ply})
								--local Vec=(tr.HitPos-NPCPos):GetNormalized()
								local prop=tr.Entity
								if not(IsValid(prop)) then prop=nil end
								if IsValid(prop) and ZombTypes[prop:GetClass()] then prop=nil end
								net.Start("hmcd_zombie_direct")
								net.WriteVector(tr.HitPos)
								net.WriteEntity(npc)
								net.WriteEntity(prop)
								net.SendToServer()
							end
						else
							ply.ZombiesMarked[ind]=nil
						end
					end
				end
			end
		end
		if not(input.IsMouseDown(107)) then
			if ply.FirstDotChosen and ply.SecondDotChosen then
				for i,ent in pairs(ents.GetAll()) do
					if ZombTypes[ent:GetClass()] then
						local mins,maxs,pos=ply.FirstDotChosen, ply.SecondDotChosen,ent:GetPos()
						if mins.x>maxs.x then
							local temp=mins.x
							mins.x=maxs.x
							maxs.x=temp
						end
						if mins.y>maxs.y then
							local temp=mins.y
							mins.y=maxs.y
							maxs.y=temp
						end
						if mins.z>maxs.z then
							local temp=mins.z
							mins.z=maxs.z
							maxs.z=temp
						end
						if pos.x>=mins.x and pos.x<=maxs.x and pos.y>=mins.y and pos.y<=maxs.y and pos.z>=mins.z and pos.z<=maxs.z then
							if not(ply.ZombiesMarked[ent:EntIndex()]) then
								ply.ZombiesMarked[ent:EntIndex()]=true
							end
						end
					end
				end
			end
			ply.FirstDotChosen=nil
			ply.SecondDotChosen=nil
		end
		if input.IsKeyDown(KEY_F1) and ply.ZombieMaster and nextmenuopen<Time then
			nextmenuopen=Time+0.25
			if not(IsValid(ply.BuyMenu)) then
				GAMEMODE:OpenZMMenu()
			else
				ply.BuyMenu:Close()
			end
		end
		if input.IsKeyDown(KEY_F2) and nextmenuopen<Time and ply.ZombieMaster then
			nextmenuopen=Time+0.25
			if not(IsValid(ply.GuideMenu)) then
				GAMEMODE:OpenZMGuide()
			else
				ply.GuideMenu:Close()
			end
		end
		if GAMEMODE.EvacZone and not(ply.Role=="natguard" or ply.Role=="killer") and ply:Alive() then
			local body=ply
			if IsValid(ply:GetNWEntity("Fake")) then body=ply:GetNWEntity("Fake") end
			if body:GetPos():DistToSqr(GAMEMODE.EvacZone)<10000 then
				local guardfound=false
				for i,playah in pairs(player.GetAll()) do
					if GAMEMODE.Roles[playah:SteamID()]=="natguard" and playah:GetPos():DistToSqr(GAMEMODE.EvacZone)<10000 and playah:Alive() then
						guardfound=true
						break
					end
				end
				if guardfound then
					if not(ply.EvacTime) then ply.EvacTime=Time+5 end
				else
					ply.EvacTime=nil
				end
			else
				ply.EvacTime=nil
			end
		else
			ply.EvacTime=nil
		end
		if ply.EvacTime and ply.EvacTime<Time then
			ply.EvacTime=nil
			net.Start("hmcd_zombie_evac")
			net.WriteEntity(ply)
			net.SendToServer()
		end
	end
	-- ZOMBIE MODE --
	
	-- STRANGE MODE --
	if GAMEMODE.Mode=="Strange" and ply:Alive() then
		if nextghostthink<Time then
			nextghostthink=Time+2
			local tr1,tr2,tr3,tr4=util.QuickTrace(ply:GetPos(),Vector(200,0,-20),{ply}),util.QuickTrace(ply:GetPos(),Vector(-200,0,-20),{ply}),util.QuickTrace(ply:GetPos(),Vector(0,200,-20),{ply}),util.QuickTrace(ply:GetPos(),Vector(0,-200,-20),{ply})
			local inthedark=render.GetLightColor(tr1.HitPos):IsEqualTol(Vector(0,0,0),.001) and render.GetLightColor(tr2.HitPos):IsEqualTol(Vector(0,0,0),.001) and render.GetLightColor(tr3.HitPos):IsEqualTol(Vector(0,0,0),.001) render.GetLightColor(tr4.HitPos):IsEqualTol(Vector(0,0,0),.001)
			if(inthedark) then
				if not(ply.NextGhostTaunt) then ply.NextGhostTaunt=Time+10 end
				if ply.Equipment and ply.Equipment["Maglite ML300LX-S3CC6L Flashlight"] and ply.HMCD_Flashlight and math.random(1,10)==1 then
					ply.Equipment["Maglite ML300LX-S3CC6L Flashlight"]=nil
					net.Start("hmcd_removeequipment")
					net.WriteEntity(ply)
					net.WriteInt(HMCD_FLASHLIGHT,6)
					net.SendToServer()
				end
				for i,flashlight in pairs(ents.FindByClass("ent_jack_hmcd_flashlight")) do
					local cansee=not(util.QuickTrace(ply:GetShootPos(),ply:WorldToLocal(flashlight:GetPos()),{ply,flashlight}).Hit)
					if cansee and flashlight.HMCD_Flashlight and math.random(1,3)==1 then
						net.Start("hmcd_remove")
						net.WriteEntity(flashlight)
						net.SendToServer()
					end
				end
				if ply.NextGhostTaunt<Time and not(ply.HMCD_Flashlight) then
					local trace_found=nil
					for i=1,10 do
						local rand_vec=VectorRand()
						rand_vec.z=0
						local tr=util.QuickTrace(ply:GetPos(),rand_vec*5000,{ply})
						local dist=tr.HitPos:DistToSqr(ply:GetPos())
						trace_found=tr
						if dist>250000 and dist<950000 then break end
					end
					local randomevent=math.random(1,2)
					if randomevent==1 then
						local mattype=util.QuickTrace(trace_found.HitPos,-vector_up*1000).MatType
						for i=1,3 do
							timer.Simple(i,function()
								if footstepsnds[mattype]!=nil then
									sound.Play( table.Random(footstepsnds[mattype]), trace_found.HitPos)
								end
							end)
						end
					elseif randomevent==2 then
						sound.Play( "custom/breathing.wav", trace_found.HitPos)
					end
					ply.NextGhostTaunt=Time+25
					if not(ply.TauntsPlayed) then ply.TauntsPlayed=0 end
					ply.TauntsPlayed=ply.TauntsPlayed+1
					if ply.TauntsPlayed>=3 then
						net.Start("hmcd_ghost_consume")
						net.WriteEntity(ply)
						net.SendToServer()
					end
				end
			else
				ply.TauntsPlayed=0
				ply.NextGhostTaunt=nil
			end
		end
	end
	-- STRANGE MODE --
end)

local Shine=Material("models/debug/debugwhite")

hook.Add("PostDrawOpaqueRenderables","HMCD_PostDrawOpaqueRenderables",function(drawingDepth,drawingSkybox)
	local client=LocalPlayer()
	if client.ZombiesMarked then
		for i,bool in pairs(client.ZombiesMarked) do
			local zomb=Entity(i)
			if IsValid(zomb) and zomb:Health()>0 then
				render.SetBlend(1)
				render.ModelMaterialOverride(Shine)
				render.SuppressEngineLighting(true)
				render.SetColorModulation(.5,0,0)
				zomb:DrawModel()
				render.SetColorModulation(.5,0,0)
				render.SuppressEngineLighting(false)
				render.ModelMaterialOverride(nil)
				render.SetBlend(1)
			else
				client.ZombiesMarked[zomb:EntIndex()]=nil
			end
		end
	end
end)

local armorTypes={"Mask","Helmet","Bodyvest"}

local function lurkerSpawnFunc(ent,name,oldVal,newVal)
	if newVal then
		local lPly=LocalPlayer()
		ent.RenderOverride=function()
			if lPly:Alive() then
				ent:DrawModel()
			end
		end
	end
end

local function rag_GetPlayerColor(self)
	return self:GetNWVector("playerColor")
end

hook.Add("OnEntityCreated","HMCD_OnEntityCreated",function(ent)
	local isRag,isPly=ent:IsRagdoll(),ent:IsPlayer()
	if ent:IsNPC() then
		ent.RenderOverride=function()
			GAMEMODE:RenderAccessories(ent)
			ent:DrawModel()
		end
		if ent:GetClass()=="npc_citizen" then
			ent:SetNWVarProxy("isLurker",lurkerSpawnFunc)
		end
	elseif isRag then
		ent.GetPlayerColor=rag_GetPlayerColor
		if string.find(ent:GetModel(),"female") then 
			ent.BreathingBone="ValveBiped.Bip01_Spine2"
		else
			ent.BreathingBone="ValveBiped.Bip01_Spine"
		end
		timer.Simple(1,function()
			if IsValid(ent) and not(ent.Inventory) then
				net.Start("hmcd_inventory_inforeq")
				net.WriteEntity(LocalPlayer())
				net.WriteEntity(ent)
				net.SendToServer()
			end
		end)
		ent.breathingIn=true
		ent.breathingScale=0
		if ent:LookupBone(ent.BreathingBone) then
			ent.RenderOverride=function()
				local owner=ent:GetNWEntity("RagdollOwner")
				local ownerFine=IsValid(owner) and owner:Alive()
				if ownerFine or (ent.breathingScale and ent.breathingScale>-130) then
					local previousScale=ent:GetManipulateBoneScale(ent:LookupBone(ent.BreathingBone))
					local pulsemul=math.Clamp((owner.Pulse or 75)/75,0,1.5)
					if pulsemul>0 then
						if not(ownerFine) then pulsemul=.25 previousScale=previousScale*1.00001 end
						if ent.breathingIn and ownerFine then
							ent.breathingScale=ent.breathingScale+pulsemul
							ent:ManipulateBoneScale(ent:LookupBone(ent.BreathingBone),previousScale*1.0001)
							if ent.breathingScale>=130 then
								ent.breathingIn=false
							end
						else
							ent.breathingScale=ent.breathingScale-pulsemul
							ent:ManipulateBoneScale(ent:LookupBone(ent.BreathingBone),previousScale*.9999)
							if ent.breathingScale<=-130 then
								ent.breathingIn=true
							end
						end
					end
				end
				if not(LocalPlayer().Lost) then GAMEMODE:RenderAccessories(ent) ent:DrawModel() end
			end
		end
	elseif isPly then
		if LocalPlayer().Lost then 
			ent.RenderOverride=function() end
		else
			ent.RenderOverride=function()
				ent:DrawModel()
				GAMEMODE:RenderAccessories(ent)
			end
		end
	end
	if isPly or isRag then
		ent:SetNWVarProxy("Accessory",function(ent,name,oldVal,newVal)
			if IsValid(ent.AccessoryModel) --[[and oldVal!=newVal]] then
				ent.AccessoryModel:Remove()
				ent.AccessoryModel=nil
			end
		end)
		for i,typ in pairs(armorTypes) do
			ent:SetNWVarProxy( typ, function(ent,name,oldVal,newVal)
				if not(ent.ShouldDrawArmor) then ent.ShouldDrawArmor={} end
				ent.ShouldDrawArmor[typ]=not((newVal=="RiotHelm" or newVal=="PoliceVest") and string.find(ent:GetModel(),"monolithservers/mpd"))
				if ent.CurArmor and IsValid(ent.CurArmor[typ]) --[[and oldVal!=newVal]] then
					ent.CurArmor[typ]:Remove()
					ent.CurArmor[typ]=nil
				end
			end)
		end
	end
end)

local rescue_mat=Material("HUD/ct_victories_all-hostages-rescued")

hook.Add("PostDrawTranslucentRenderables","HMCD_PostDrawTranslucentRenderables",function()
	if LocalPlayer().FirstDotChosen and LocalPlayer().SecondDotChosen then
		render.SetMaterial(Shine)
		local maxs=LocalPlayer().SecondDotChosen-LocalPlayer().FirstDotChosen
		local mins=Vector(0,0,0)
		if mins.x>maxs.x then
			local temp=mins.x
			mins.x=maxs.x
			maxs.x=temp
		end
		if mins.y>maxs.y then
			local temp=mins.y
			mins.y=maxs.y
			maxs.y=temp
		end
		if mins.z>maxs.z then
			local temp=mins.z
			mins.z=maxs.z
			maxs.z=temp
		end
		render.SuppressEngineLighting(true)
		render.SetColorMaterial()
		render.DrawBox( LocalPlayer().FirstDotChosen, Angle(0,0,0), mins, maxs, Color( 255, 0, 0,50 ) )
		render.SuppressEngineLighting(false)
	end
	if GAMEMODE.PoliceArrived then
		if not(GAMEMODE.EvacZone) then GAMEMODE.EvacZone=HMCD_EvacuationZones[game.GetMap()] end
		if GAMEMODE.EvacZone then
			render.SetMaterial(rescue_mat)
			render.DrawSprite( GAMEMODE.EvacZone, 10, 10, Color( 255, 255, 255 ) )
		end
	end
end)

net.Receive("hmcd_jesus_resurrection",function()
	LocalPlayer():EmitSound("christ_risen.mp3")
end)

net.Receive("hmcd_sync",function()
	local enable=tobool(net.ReadBit())
	for i,ply in pairs(player.GetAll()) do 
		ply.Hidden=enable
	end
	LocalPlayer().Syncing=enable
end)

net.Receive("hmcd_death",function()
	GAMEMODE.SpectateTime=CurTime()+5
end)

net.Receive("hmcd_policearrive",function()
	GAMEMODE.PoliceArrived=true
end)

function GM:CalcView(ply,pos,ang,efovee,nearZ,farZ)
	local wep=ply:GetActiveWeapon()
	if IsValid(self.Spectatee) then ply=self.Spectatee end
	local Fake = ply:GetNWEntity("Fake")
	local Ent=GetViewEntity()
	if not(ply:IsPlayer() and ply:Alive()) then
		if self.SpectateTime>CurTime() and self.SpectateMode!=OBS_MODE_CHASE then
			local Rag=ply:GetNWEntity("DeathRagdoll")
			if(IsValid(Rag))then
				local PosAng=Rag:GetAttachment(Rag:LookupAttachment("eyes"))
				local CamData={
					origin=PosAng.Pos,
					angles=PosAng.Ang,
					fov=efovee,
					znear=nearZ,
					zfar=farZ
				}
				return CamData
			end
		end
	elseif IsValid(Fake) and self.SpectateMode!=OBS_MODE_CHASE then
		local PosAng=Fake:GetAttachment(Fake:LookupAttachment("eyes"))
		local CamData={
			origin=PosAng.Pos-(Vector(2,0,0)),
			angles=PosAng.Ang,
			fov=efovee,
			znear=nearZ,
			zfar=farZ
		}
		return CamData
	elseif(ply:IsPlayingTaunt())then
		local ViewPos=pos-ang:Forward()*75
		local Tr=util.QuickTrace(pos,ViewPos-pos,{ply})
		if(Tr.Hit)then ViewPos=Tr.HitPos end
		local CamData={
			origin=ViewPos,
			angles=ang,
			fov=efovee,
			znear=nearZ,
			zfar=farZ,
			drawviewer=true
		}
		return CamData
	elseif(ply:InVehicle())then
		local Mdl,Vec=ply:GetVehicle():GetModel(),vector_origin
		if not((Mdl=="models/airboat.mdl")or(Mdl=="models/buggy.mdl")or(Mdl=="models/vehicle.mdl"))then Vec=Vector(0,0,5) end
		local CamData={
			origin=pos+Vec,
			angles=ang,
			fov=efovee,
			znear=nearZ,
			zfar=farZ
		}
		return CamData
	elseif(Ent!=LocalPlayer())then
		local Pos=Ent:LocalToWorld(Ent:OBBCenter())
		local CamData={
			origin=Pos,
			angles=ang,
			fov=efovee,
			znear=nearZ,
			zfar=farZ
		}
		return CamData
	elseif IsValid(wep) and wep.BipodAmt and wep.BipodAmt>0 then
		local offset=wep.AttBipodPos or wep.BipodAimOffset
		local vm=ply:GetViewModel()
		local vmPos,vmAng=wep:GetViewModelPosition(pos,ang)
		local Pos=vmPos+vmAng:Forward()*offset[1]+vmAng:Right()*offset[2]+vmAng:Up()*offset[3]
		local CamData={
			origin=pos+(Pos-pos)*wep.AimPerc/100,
			angles=ang,
			fov=efovee,
			znear=nearZ,
			zfar=farZ
		}
		return CamData
	end
end

local rigmdl = "models/weapons/tfa_ins2/c_ins2_pmhands.mdl"

hook.Add("PreDrawPlayerHands", "HMCD_PreDrawPlayerHands", function(hands, vm, ply, wep)
	if not (IsValid(vm) or IsValid(wep)) then return end

	if not(IsValid(handsent)) then
		handsent = ClientsideModel(rigmdl)
	end

	if not IsValid(hands) then return end -- Hi Gmod Can Hands ????

	if wep.UseHands and vm:LookupBone("R ForeTwist") and not(vm:LookupBone("ValveBiped.Bip01_R_Hand")) then -- assuming we are ins2 only skeleton
		handsent:SetParent(vm)
		handsent:SetPos(vm:GetPos())
		handsent:SetAngles(vm:GetAngles())
		handsent:AddEffects(EF_BONEMERGE)
		handsent:AddEffects(EF_BONEMERGE_FASTCULL)
		handsent:InvalidateBoneCache()

		hands:SetParent(handsent)
		hands.Insurgency=true
		hands:AddEffects(EF_BONEMERGE)
		hands:AddEffects(EF_BONEMERGE_FASTCULL)
	else
		hands.Insurgency=nil
	end
end)

hook.Add("PreDrawViewModel","HMCD_PreDrawViewModel",function(vm,ply,wep)
	if IsValid(wep.Owner:GetNWEntity("Fake")) then return true end
end)

net.Receive("hmcd_sound",function()
	local snd,dir,dist=net.ReadString(),net.ReadNormal(),net.ReadUInt(32)
	
	local lPos=LocalPlayer():GetShootPos()
	for i,info in pairs(HMCD_Sounds[snd]) do
		local distLimit=info.dist*52.5
		if dist<=distLimit then
			timer.Simple(dist/52.5/343,function()
				local snd=info.snd
				if istable(snd) then snd=table.Random(snd) end
				EmitSound(snd,lPos+dir*math.min(dist,3000),0,CHAN_AUTO,1,info.sndLvl*(1-dist/distLimit/2),0,info.pitch or 100,0)
				util.ScreenShake(lPos, 0.9, 5, 0.5, 5, true)
			end)
		end
	end
end)