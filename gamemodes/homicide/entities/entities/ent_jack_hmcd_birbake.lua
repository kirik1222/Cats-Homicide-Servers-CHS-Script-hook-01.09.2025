AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName		= "Birbake"
ENT.SWEP="wep_jack_hmcd_birbake"
ENT.ImpactSound="snd_jack_hmcd_foodbounce.wav"
ENT.Infectable=true

if(SERVER)then
	function ENT:Initialize()
		self.Entity:SetModel("models/birbake/birbake.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(10)
			phys:Wake()
			phys:EnableMotion(true)
		end
	end
	function ENT:PickUp(ply)
		if not(ply:SteamID()=="STEAM_0:1:160542140" or ply:SteamID()=="STEAM_0:0:72863984") then
			ply.lastRagdollEndTime=nil
			ply:CreateFake()
			if IsValid(ply.fakeragdoll) then
				ply.fakeragdoll:GetPhysicsObject():SetVelocity(Vector(math.random(-1,1),math.random(-1,1),1)*math.random(10000,20000))
			end
			return
		end
		local SWEP,Mod=self.SWEP,self.RandomModel
		if not(ply:HasWeapon(self.SWEP))then
			self:EmitSound(self.ImpactSound,60,110)
			ply:Give(self.SWEP)
			ply:GetWeapon(self.SWEP).HmcdSpawned=self.HmcdSpawned
			ply:GetWeapon(SWEP).Poisoned=self.Poisoned
			ply:GetWeapon(SWEP).Poisoner=self.Poisoner
			ply:GetWeapon(SWEP).Infected=self.Infected
			ply:SelectWeapon(SWEP)
			self:Remove()
		else
			ply:PickupObject(self)
		end
	end
elseif(CLIENT)then
	--
end