AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName		= "Pencil"
ENT.SWEP="wep_hmcd_mansion_pencils"
--ENT.ImpactSound="physics/metal/metal_solid_impact_soft1.wav"
	function ENT:SetupDataTables()
		self:NetworkVar("String",0,"DColour")
	end
	
	function ENT:Initialize()
	if(SERVER)then
		self.Entity:SetModel("models/mu_hmcd_mansion/weapon_pencils/w_pencil.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(5)
			phys:Wake()
			phys:EnableMotion(true)
		end
		if(self.DColour== nil)then self.DColour=ColorRand() end
		self:SetColor(self.DColour or Color(0,0,0))
			self:SetDColour(tostring(self.DColour))
			
	end
	end 
	function ENT:PickUp(ply)
		local SWEP=self.SWEP
		if not(ply:HasWeapon(self.SWEP))then
			ply:Give(self.SWEP)
			ply:GetWeapon(self.SWEP).HmcdSpawned=self.HmcdSpawned
			ply:SelectWeapon(self.SWEP)
			ply:GetWeapon("wep_hmcd_mansion_pencils"):SetDColour(self:GetDColour())
			self:Remove()
			ply:SelectWeapon(SWEP)
		else
			ply:PickupObject(self)
		end
	end
