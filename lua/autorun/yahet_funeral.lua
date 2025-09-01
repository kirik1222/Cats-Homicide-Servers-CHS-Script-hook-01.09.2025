if CLIENT then
	net.Receive("cemetery_babayka",function()
		local ply=LocalPlayer()
		local dir=ply:GetVelocity():GetNormalized()
		if dir==Vector(0,0,0) then dir=(ply:GetPos()-Vector(-247,827,128)):GetNormalized() end
		dir.z=-0.05
		local babaykaPos=util.TraceLine({
			start=ply:GetShootPos(),
			endpos=ply:GetShootPos()+dir*10000,
			mask=MASK_PLAYERSOLID_BRUSHONLY
		}).HitPos+vector_up*40
		spawnBabayka(babaykaPos)
	end)
	net.Receive("lightning_strike",function()
		local distance=net.ReadUInt(13)
		local snd
		if distance<=1000 then
			snd="thunder_close.mp3"
		elseif distance<1700 then
			snd="thunder_mid.mp3"
		elseif distance>=1700 and distance<=20000 then
			snd="thunder_far.mp3"
		end
		surface.PlaySound(snd)
	end)
	local dirs={
		{Vector(0,-64,0),Angle(0,0,-90),0.5,32},
		{Vector(0,64,0),Angle(180,0,90),0.5,32},
		{Vector(64,0,0),Angle(180,-90,90),0.5,32},
		{Vector(-64,0,0),Angle(180,90,90),0.5,32},
		{Vector(0,-128,0),Angle(0,0,-90),1,32},
		{Vector(0,128,0),Angle(180,0,90),1,32},
		{Vector(128,0,0),Angle(180,-90,90),1,32},
		{Vector(-128,0,0),Angle(180,90,90),1,32},
		{Vector(0,-256,0),Angle(0,0,-90),2,32},
		{Vector(0,256,0),Angle(180,0,90),2,32},
		{Vector(256,0,0),Angle(180,-90,90),2,32},
		{Vector(-256,0,0),Angle(180,90,90),2,32}
	}
	local rainMat=Material("graveyard/rain")
	function startRain()
		rainSound=CreateSound(LocalPlayer(),"ambient/weather/rumble_rain.wav")
		local timeMul=CurTime()
		local rainStart=CurTime()
		local col=Color(255,255,255,0)
		hook.Add("PostDrawTranslucentRenderables","Rain",function(a,b,c)
			local pos=LocalPlayer():GetShootPos()
			local mul=(CurTime()-timeMul)
			col.a=math.min((CurTime()-rainStart),150)
			rainSound:PlayEx((CurTime()-rainStart)/150,100)
			for i,dir in pairs(dirs) do
				local xAmt,yAmt=dir[3],dir[4]
				cam.Start3D2D(pos+dir[1],dir[2],1)
					surface.SetDrawColor( col )
					surface.SetMaterial( rainMat )
					surface.DrawTexturedRectUV( -128*xAmt, -512*yAmt-1024*mul, 256*xAmt, 1024*yAmt, 0, 0, xAmt, yAmt )
					if mul>=8 then timeMul=CurTime() end
				cam.End3D2D()
			end
		end)
	end
	net.Receive("burial_start",function()
		surface.PlaySound("sadsong.mp3")
		startRain()
	end)
	net.Receive("newplayer_check",function()
		old_fadedist=GetConVar("cl_detaildist"):GetInt()
		RunConsoleCommand("cl_detaildist","4000")
		if tobool(net.ReadBit()) then startRain() end
	end)
	surface.CreateFont( "TombstoneText", {
		font = "Times New Roman",
		extended = false,
		size = 60,
		weight = 500,
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
	surface.CreateFont( "MersRadialBig" , {
		font = "coolvetica",
		size = math.ceil(ScrW() / 24),
		weight = 500,
		antialias = true,
		italic = false
	})
	local citation='"I guess that'
	citation=citation.."'"
	citation=citation..'s it."'
	TOMBSTONES={
		[-1]={Material("graveyard/nigger"),{"George Floyd","1973-2020","Life is not measured","by the number of","breaths we take, but by","the moments that take","our breath away."}},
		[1]={Material("graveyard/trans"),{"A Man","1998-2021","Rest in power!"},1,0.5},
		[2]={Material("graveyard/server"),{"Server","2019-2022","April Fools"}},
		[3]={Material("graveyard/mcnutt"),[2]={"Ronnie McNutt","1987-2020",citation}},
		[4]={Material("graveyard/griggs"),{"Griggs","20??-2022","Turned into a furry"}}
	}
	local glow=Material("sprites/redglow1")
	function spawnBabayka(pos)
		local ang=pos:Angle()
		sound.Play( "babayka.wav", pos, 140, math.random(150,170) )
		hook.Add("PostDrawOpaqueRenderables","babayka",function(a,b,c)
			local eyeAng=LocalPlayer():EyeAngles()
			render.SetMaterial(glow)
			cam.Start3D()
				cam.IgnoreZ(true)
				render.DrawSprite(pos+eyeAng:Right()*25+eyeAng:Up()*30,32,32)
				render.DrawSprite(pos+eyeAng:Right()*-25+eyeAng:Up()*30,32,32)
				cam.IgnoreZ(false)
			cam.End3D()
		end)
		timer.Simple(3,function()
			hook.Remove("PostDrawOpaqueRenderables","babayka")
		end)
	end
	hook.Add( "Initialize","MapCheck",function()
		if game.GetMap()=="yahet_funeral" then
			local EntityMeta=FindMetaTable("Entity")
			function EntityMeta:GetPlayerColor()
				return self:GetNWVector("playerColor")
			end
		end
	end)
	hook.Add("ShutDown","Restore_Convars",function()
		if GetConVar("cl_detaildist"):GetInt()==4000 then
			RunConsoleCommand("cl_detaildist",old_fadedist)
		end
	end)
	hook.Add("PostCleanupMap","RainRemove",function()
		hook.Remove("PostDrawTranslucentRenderables","Rain")
		if IsValid(rainSound) then rainSound:Remove() end
	end)
else
	if game.GetMap()!="yahet_funeral" then return end
	util.AddNetworkString("cemetery_babayka")
	util.AddNetworkString("burial_start")
	util.AddNetworkString("lightning_strike")
	util.AddNetworkString("newplayer_check")
	FREE_TOMBSTONES={}
	for i=1,90 do table.insert(FREE_TOMBSTONES,i) end
	hook.Add("PreCleanupMap","Tombstone_ReAdd",function()
		FREE_TOMBSTONES={}
		for i=1,90 do table.insert(FREE_TOMBSTONES,i) end
	end)
	local nextCheck=0
	hook.Add("Think","Babayka",function()
		if nextCheck<CurTime() then
			nextCheck=CurTime()+1
			for i,ply in pairs(player.GetAll()) do
				if not(ply.BeingTeleported) and Vector(-247,827,128):DistToSqr(ply:GetPos())>3800000 then
					net.Start("cemetery_babayka")
					net.Send(ply)
					ply.BeingTeleported=true
					timer.Simple(1,function()
						if IsValid(ply) then
							if IsValid(ply.fakeragdoll) then
								for i=0,ply.fakeragdoll:GetPhysicsObjectCount()-1 do
									ply.fakeragdoll:GetPhysicsObjectNum(i):SetPos(Vector(-247,881,128))
								end
							end
							ply:ExitVehicle() 
							ply:SetPos(Vector(-247,881,128))
							ply.BeingTeleported=false
						end
					end)
				end
			end
			if IsValid(negr) then
				local pos=negr:GetPos()
				if util.QuickTrace(pos,vector_up*-20,negr).Entity==ents.FindByName("coffin")[1] and util.QuickTrace(pos,vector_up*20,negr).Entity==ents.FindByName("coffin_lid")[1] then
					local mins,maxs=Vector(-311,809,64),Vector(-199,856,100)
					if pos.x>mins.x and pos.y>mins.y and pos.z>mins.z and pos.x<maxs.x and pos.y<maxs.y and pos.z<maxs.z then
						local shovel=ents.FindByName("shovel")[1]
						local sPos=shovel:GetPos()
						mins,maxs=Vector(-311,809,64),Vector(-199,856,192)
						if sPos.x>mins.x and sPos.y>mins.y and sPos.z>mins.z and sPos.x<maxs.x and sPos.y<maxs.y and sPos.z<maxs.z then
							bury()
						end
					end
				end
			end
		end
	end)
	hook.Add( "PlayerInitialSpawn", "PlayerLoad", function( ply )
		hook.Add( "SetupMove", ply, function( self, ply, _, cmd )
			if self == ply and not cmd:IsForced() then
				hook.Remove( "SetupMove", self )
				net.Start("newplayer_check")
				net.WriteBit(IsValid(negr) and negr.Buried)
				net.Send(ply)
			end
		end )
	end )
	local positions={
		[0]={
			[1]=Vector(-235.79,739.98,134.05),
			[2]=Angle(-0.7,-89.02,7.71)
		},
		[1]={
			[1]=Vector(-224.53,740.15,131.7),
			[2]=Angle(0.53,-2.8,90)
		},
		[2]={
			[1]=Vector(-215.11,747.42,132.89),
			[2]=Angle(9.78,162.36,244.57)
		},
		[3]={
			[1]=Vector(-215.86,732,132.93),
			[2]=Angle(12.32,-161.81,298.7)
		},
		[4]={
			[1]=Vector(-226.73,728.3,130.26),
			[2]=Angle(-62.21,89.89,10.01)
		},
		[5]={
			[1]=Vector(-226.69,733.82,140.36),
			[2]=Angle(-11.92,105.95,95.4)
		},
		[6]={
			[1]=Vector(-226.09,751.01,130.76),
			[2]=Angle(-64.55,-91.08,169.51)
		},
		[7]={
			[1]=Vector(-226.17,745.97,141.09),
			[2]=Angle(-14.14,-104.97,86.18)
		},
		[8]={
			[1]=Vector(-235.86,743.9,133.73),
			[2]=Angle(7.43,179.9,270.14)
		},
		[9]={
			[1]=Vector(-253.55,743.91,131.71),
			[2]=Angle(4.8,179.86,270)
		},
		[10]={
			[1]=Vector(-209.37,739.41,134),
			[2]=Angle(14.95,-3.3,250.38)
		},
		[11]={
			[1]=Vector(-235.72,736.06,133.8),
			[2]=Angle(7.77,-179.7,272.15)
		},
		[12]={
			[1]=Vector(-253.41,735.99,131.68),
			[2]=Angle(4.13,-179.8,271.78)
		},
		[13]={
			[1]=Vector(-269.9,735.92,130.33),
			[2]=Angle(-62.22,-173.61,263.89)
		},
		[14]={
			[1]=Vector(-270.03,743.95,130.17),
			[2]=Angle(-65.16,173.8,277.38)
		}
	}
	local function spawnNegr()
		negr=ents.Create("prop_ragdoll")
		negr:SetModel("models/player/group01/male_01.mdl")
		negr.playerColor=Vector(0,0.098,0.215)
		negr:SetNWVector("playerColor",negr.playerColor)
		negr:SetSubMaterial(3,"models/humans/male/group01/young")
		negr:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		negr:SetNWString("bystanderName","Patrol Agent SGM Lt MSG SSG Sgt 1SG Lt CPL Sgt SFC Police Officer Edna Nomad3 Leader1")
		negr.ModelSex="male"
		negr.ClothingType="young"
		negr:Spawn()
		for i,info in pairs(positions) do
			local phys=negr:GetPhysicsObjectNum(i)
			phys:SetPos(info[1])
			phys:SetAngles(info[2])
		end
		timer.Simple(.1,function()
			if IsValid(negr) then
				local hat=ents.Create("prop_physics")
				hat:SetModel("models/cowboyhat.mdl")
				local pos,ang=negr:GetBonePosition(negr:LookupBone("ValveBiped.Bip01_Head1"))
				hat:SetParent(negr)
				hat:SetPos(pos+ang:Forward()*6+ang:Right()*-0.5)
				ang:RotateAroundAxis(ang:Up(),30)
				ang:RotateAroundAxis(ang:Right(),-90)
				ang:RotateAroundAxis(ang:Up(),-90)
				hat:SetAngles(ang)
				hat:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
				hat:SetModelScale(.74,0)
				hat:Spawn()
				hat:Fire("SetParentAttachmentMaintainOffset", "anim_attachment_head", 0.1)
			end
		end)
	end
	hook.Add("PostCleanupMap","NegrSpawn",function()
		spawnNegr()
		for i,ent in pairs(ents.FindByClass("func_brush")) do
			ent:SetPos(Vector(-255,832,48))
		end
		hook.Remove("Think","Burying")
		hook.Remove("Think","Lightning")
	end)
	hook.Add("Initialize","NegrSpawn",function()
		timer.Simple(1,function()
			spawnNegr()
			for i,ent in pairs(ents.FindByClass("func_brush")) do
				ent:SetPos(Vector(-255,832,48))
			end
		end)
	end)
	function bury()
		net.Start("burial_start")
		net.Broadcast()
		negr.Buried=true
		local nextBury=0
		local curBury=1
		local shovel=ents.FindByName("shovel")[1]
		local phys=shovel:GetPhysicsObject()
		shovel:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		phys:EnableMotion(false)
		phys:AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
		hook.Add("Think","Burying",function()
			if nextBury<CurTime() then
				nextBury=CurTime()+3
				shovel:SetPos(Vector(-255,890,154))
				shovel:SetAngles(Angle(-21,-90,0))
				sound.Play("digging.wav",Vector(-250,832,128))
				timer.Simple(1,function()
					if hook.GetTable()["Think"]["Burying"] then
						if IsValid(shovel) then
							shovel:SetPos(Vector(-255,874,160))
							shovel:SetAngles(Angle(-70,-84,0))
						end
						for i,ent in pairs(ents.FindInSphere(Vector(-255,832,48),1)) do
							if ent:GetClass()=="func_brush" then
								ent:SetPos(ent:GetPos()+vector_up*(8+16*curBury))
								break
							end
						end
						curBury=curBury+1
						if curBury==5 then
							hook.Remove("Think","Burying") 
							timer.Simple(1,function() 
								if IsValid(shovel) then
									shovel:SetCollisionGroup(COLLISION_GROUP_NONE)
									local phys=shovel:GetPhysicsObject()
									phys:EnableMotion(true)
									phys:ClearGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
									phys:Wake()
								end
							end)
							local dirtpile=ents.Create("prop_dynamic")
							dirtpile:SetPos(Vector(-255,832,126.1))
							dirtpile:SetAngles(Angle(0,90,0))
							dirtpile:SetModel("models/dirtpile.mdl")
							dirtpile:SetSolid(SOLID_VPHYSICS)
							dirtpile:Spawn()
							local col=Color(255,255,255,0)
							local sign=ents.Create("true_sign")
							sign:SetPos(Vector(-194,832,151))
							sign:SetAngles(Angle(10,90,0))
							sign:SetRenderMode(RENDERMODE_TRANSCOLOR)
							sign:SetColor(col)
							sign:Spawn()
							local start=CurTime()
							hook.Add("Think","Burying",function()
								col.a=math.min((CurTime()-start)*10,255)
								sign:SetColor(col)
								if col.a==255 then hook.Remove("Think","Burying") end
							end)
							local nextStrike=start+math.random(40,90)
							hook.Add("Think","Lightning",function()
								if nextStrike<CurTime() then
									nextStrike=CurTime()+math.random(40,90)
									lightning(math.random(900,4500))
								end
							end)
						end
						for i,ent in pairs(ents.GetAll()) do
							if ent:IsSolid() and ent:GetClass()!="func_brush" then
								local pos
								if ent:IsPlayer() then pos=ent:EyePos() else pos=ent:GetPos() end
								local mins,maxs=Vector(-311,809,64),Vector(-199,856,64+16*curBury)
								if pos.x>mins.x and pos.y>mins.y and pos.z>mins.z and pos.x<maxs.x and pos.y<maxs.y and pos.z<maxs.z then
									if ent:IsPlayer() then
										ent:Kill()
									else
										for j=0,ent:GetPhysicsObjectCount()-1 do
											local phys=ent:GetPhysicsObjectNum(j)
											phys:EnableMotion(false)
											phys:EnableCollisions(false)
										end
										if ent:IsRagdoll() then
											local owner=ent:GetNWEntity("RagdollOwner")
											if IsValid(owner) and owner:Alive() then owner:Kill() end
										end
									end
								end
							end
						end
					end
				end)
			end
		end)
	end
	function lightning(distance)
		timer.Simple(distance/299792458,function()
			local lightning=ents.FindByName("lightning")[1]
			lightning:Fire("toggle")
			timer.Simple(.05,function() lightning:Fire("toggle") end)
		end)
		timer.Simple(distance/343,function()
			net.Start("lightning_strike")
			net.WriteUInt(distance,13)
			net.Broadcast()
		end)
	end
end