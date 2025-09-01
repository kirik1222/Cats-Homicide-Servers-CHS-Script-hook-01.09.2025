
local lifeDefault="60"
local shellLife_convar=CreateClientConVar("hmcd_caselife",lifeDefault,true,false,"How long a bullet case should exist upon being ejected. Set to 0 to never remove.",0)

local function shellLife_change(name,oldVal,newVal)
	if not(tonumber(newVal)) then
		print("Incorrect format. Reverting to default value.")
		shellLife_convar:SetString(lifeDefault)
		return
	end
	if newVal==0 then newVal=math.huge end
	for i,shell in pairs(GAMEMODE.Shells) do
		shell.LifeTime=newVal
		shell.DeathTime=shell.CreationTime+newVal
	end
end

cvars.AddChangeCallback("hmcd_caselife",shellLife_change,"ChangeLifeTime")

local limitDefault="0"

local shellLimit_convar=CreateClientConVar("hmcd_caselimit",limitDefault,true,false,"If set to a number greater than zero, the oldest bullet cases ejected will start disappearing if the total number of bullet cases exceeds given number.",0)

local function checkShellLimit()
	local shellLimit=shellLimit_convar:GetInt()
	if shellLimit!=0 then
		local curTime=CurTime()
		local curShellAmt=table.Count(GAMEMODE.Shells)
		if curShellAmt>shellLimit then
			for i=1,curShellAmt-shellLimit do
				local shell=GAMEMODE.Shells[i]
				if shell.DeathTime>curTime then
					shell.DeathTime=curTime
				end
			end
		end
	end
end

local function shellLimit_change(name,oldVal,newVal)
	if not(tonumber(newVal)) then
		print("Incorrect format. Reverting to default value.")
		shellLimit_convar:SetString(limitDefault)
		return
	end
	checkShellLimit()
end

cvars.AddChangeCallback("hmcd_caselimit",shellLimit_change,"CheckShellLimit")

hook.Add("PostCleanupMap","CleanShells",function()
	for i,shell in pairs(GAMEMODE.Shells) do
		shell.DeathTime=CurTime()
	end
end)

local bronzeShell_impacts={"player/pl_shell1.wav","player/pl_shell2.wav","player/pl_shell3.wav"}
local shotgunShell_impacts={"weapons/fx/tink/shotgun_shell1.wav"}

local shellInfo={
	["Buckshot"]={
		mdl="models/kali/weapons/black_ops/magazines/ammunition/12 gauge shotgun shell.mdl",
		impactSounds=shotgunShell_impacts,
		pitch=90,
		collisionBounds={Vector(-0.5,-1.2,-0.5),Vector(0.5,1.6,0.5)},
		bgs={
			[1]=1
		}
	},
	["Pistol"]={
		mdl="models/shells/fhell_9x19mm.mdl",
		impactSounds=bronzeShell_impacts,
		pitch=90,
		collisionBounds={Vector(-0.5,-0.25,-0.25),Vector(0.3,0.25,0.25)}
	},
	["357"]={
		mdl="models/shells/fhell_9x19mm.mdl",
		impactSounds=bronzeShell_impacts,
		pitch=85,
		collisionBounds={Vector(-0.5,-0.25,-0.25),Vector(0.3,0.25,0.25)},
		color=Color(255,215,0),
		velMul=0,
		angVelMul=0.1,
		noSmoke=true,
		randomizePos=2
	},
	["SMG1"]={
		mdl="models/shells/fhell_556.mdl",
		impactSounds=bronzeShell_impacts,
		pitch=80,
		collisionBounds={Vector(-0.75,-0.25,-0.25),Vector(1.05,0.25,0.25)}
	},
	["M249Link"]={
		mdl="models/shells/fhell_m249.mdl",
		impactSounds={"weapons/shells/m249_link_concrete_01.wav","weapons/shells/m249_link_concrete_02.wav",
		"weapons/shells/m249_link_concrete_03.wav","weapons/shells/m249_link_concrete_04.wav",
		"weapons/shells/m249_link_concrete_05.wav","weapons/shells/m249_link_concrete_06.wav",
		"weapons/shells/m249_link_concrete_07.wav","weapons/shells/m249_link_concrete_08.wav"},
		pitch=90,
		collisionBounds={Vector(-0.625,-0.5,-0.15),Vector(0.425,0.5,0.15)},
		velMul=0.17,
		noSmoke=true
	},
	["CombineCannon"]={
		mdl="models/shells/fhell_556.mdl",
		impactSounds=bronzeShell_impacts,
		pitch=75,
		collisionBounds={Vector(-0.75,-0.25,-0.25),Vector(1.05,0.25,0.25)},
		scale=2,
		velMul=0,
		noSmoke=true,
	},
	["Hornet"]={
		mdl="models/kali/weapons/black_ops/magazines/ammunition/12 gauge shotgun shell.mdl",
		impactSounds=shotgunShell_impacts,
		pitch=100,
		material="models/kali/weapons/bo/beretta682/beanbag",
		collisionBounds={Vector(-0.5,-1.2,-0.5),Vector(0.5,1.6,0.5)},
		bgs={
			[1]=1
		}
	},
	["12mmRound"]={
		mdl="models/shells/fhell_9x18mm.mdl",
		impactSounds=bronzeShell_impacts,
		pitch=93,
		collisionBounds={Vector(-0.5,-0.25,-0.25),Vector(0.3,0.25,0.25)}
	},
	["HelicopterGun"]={
		mdl="models/shells/fhell_556.mdl",
		impactSounds=bronzeShell_impacts,
		pitch=90,
		collisionBounds={Vector(-0.75,-0.25,-0.25),Vector(1.05,0.25,0.25)}
	},
	["SniperRound"]={
		mdl="models/shells/fhell_762x39.mdl",
		impactSounds=bronzeShell_impacts,
		pitch=80,
		collisionBounds={Vector(-0.75,-0.25,-0.25),Vector(0.8,0.25,0.25)}
	},
	["StriderMinigun"]={
		mdl="models/shells/fhell_556.mdl",
		impactSounds=bronzeShell_impacts,
		pitch=80,
		collisionBounds={Vector(-0.75,-0.25,-0.25),Vector(1.05,0.25,0.25)},
		scale=1.25
	},
	["AlyxGun"]={
		mdl="models/shells/fhell_9x19mm.mdl",
		impactSounds=bronzeShell_impacts,
		pitch=95,
		collisionBounds={Vector(-0.5,-0.25,-0.25),Vector(0.3,0.25,0.25)},
		scale=0.8
	}
}

shellInfo["9mmRound"]=shellInfo["Pistol"]
shellInfo["AR2"]=shellInfo["SniperRound"]

GAMEMODE.Shells=GAMEMODE.Shells or {}

function EFFECT:Init(data)
	local wep=data:GetEntity()
	if not(IsValid(wep)) then self:Remove() return end
	
	local shellType=wep.AmmoType
	if wep.AdditionalShellEffects then
		if wep.CurAdditionalEffect then shellType=wep.AdditionalShellEffects[wep.CurAdditionalEffect] end
		
		local effectdata=EffectData()
		effectdata:SetEntity(wep)
		
		for i,eff in pairs(wep.AdditionalShellEffects) do
			if i<=(wep.CurAdditionalEffect or 0) then continue end
			wep.CurAdditionalEffect=i
			util.Effect("eff_jack_hmcd_bulletcase",effectdata)
		end
		wep.CurAdditionalEffect=nil
	end
	local info=shellInfo[shellType]
	
	local spectatee=LocalPlayer()
	if IsValid(GAMEMODE.Spectatee) then spectatee=GAMEMODE.Spectatee end
	
	local pos,ang
	local correctionInfo
	if wep.Owner==spectatee and GetViewEntity()==spectatee and not(wep.Owner:ShouldDrawLocalPlayer()) then
		local vm=spectatee:GetViewModel()
		if wep.VMShellBone then
			pos,ang=vm:GetBonePosition(vm:LookupBone(wep.VMShellBone))
		else
			local att=vm:GetAttachment(info.att or wep.VMShellAttachment or wep.ShellAttachment)
			pos,ang=att.Pos,att.Ang
		end
		correctionInfo=wep.VMShellInfo
	else
		local wModel
		if string.find(wep:GetClass(),"ent_jack") then wModel=wep else wModel=wep.WModel or wep end
		if wep.WMShellBone then
			pos,ang=wModel:GetBonePosition(wModel:LookupBone(wep.WMShellBone))
		else
			local att=wModel:GetAttachment(info.att or wep.WMShellAttachment or wep.ShellAttachment)
			pos,ang=att.Pos,att.Ang
		end
		correctionInfo=wep.WMShellInfo
	end
	
	if correctionInfo then
		pos,ang=LocalToWorld(correctionInfo.lpos or vector_origin,correctionInfo.lang or angle_zero,pos,ang)
	end
	
	if wep.ShellInfo then
		info=table.Copy(info)
		for i,val in pairs(wep.ShellInfo) do
			info[i]=val
		end
	end
	
	if info.randomizePos then pos:Add(VectorRand()*info.randomizePos) end
	
	self:SetPos(pos)
	self:SetAngles(ang)
	self:SetModel(info.mdl)
	
	if info.bgs then
		for i,bg in pairs(info.bgs) do
			self:SetBodygroup(i,bg)
		end
	end
	if info.material then
		self:SetMaterial(info.material)
	end
	
	self:PhysicsInitBox(unpack(info.collisionBounds))
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	if info.color then
		self:SetColor(info.color)
	end
	
	if info.scale then
		self:SetModelScale(info.scale,0)
	end
	
	local phys=self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetDamping(0,15)
		phys:SetVelocity(ang:Forward()*math.random(150, 300)*(info.velMul or 1))
		phys:AddAngleVelocity((VectorRand()*25000)*(info.angVelMul or 1))
		phys:SetMaterial("gmod_silent")
	end
	
	if not(info.noSmoke) then
		for i=1,2 do
			timer.Simple(i-1,function()
				if IsValid(self) then
					ParticleEffectAttach("pcf_jack_mf_barrelsmoke",PATTACH_POINT_FOLLOW,self,1)
				end
			end)
		end
	end
	
	local lifeTime=shellLife_convar:GetInt()
	if lifeTime==0 then lifeTime=math.huge end
	self.LifeTime=lifeTime
	self.CreationTime=CurTime()
	self.DeathTime=self.CreationTime+lifeTime
	self.Color=self:GetColor()
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)
	self.Info=info
	
	table.insert(GAMEMODE.Shells,self)
	
	checkShellLimit()
end

function EFFECT:Think()
	if self.DeathTime<CurTime() then
		self.Color.a=math.max(self.Color.a-2,0)
		self:SetColor(self.Color)
		if self.Color.a==0 then table.remove(GAMEMODE.Shells,1) self:Remove() end
	end
	return true
end

function EFFECT:PhysicsCollide(data,collider)
	if data.DeltaTime>.1 then
		self:EmitSound(table.Random(self.Info.impactSounds),math.min(20+data.Speed/8,65),self.Info.pitch+math.random(-10,10))
	end
end

function EFFECT:Render()
	self:DrawModel()
	local pos,ang=self:GetPos(),self:GetAngles()
	local mins,maxs=self:GetCollisionBounds()
	--render.DrawWireframeBox(pos,ang,mins,maxs)
end