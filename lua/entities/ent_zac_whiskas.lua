AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName		= "Whiskas"
ENT.Spawnable = true
ENT.SWEP = "weapon_whiskas"

ENT.ImpactSound="physics/body/body_medium_impact_soft5.wav"

if(SERVER)then
	function ENT:Initialize()
		self.Entity:SetModel("models/whiskas/whiskas.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		if(WHISKAS_HMCDMODES[engine.ActiveGamemode()])then
			local newent = ents.Create("ent_zac_hmcd_whiskas")
			newent:SetPos(self:GetPos())
			newent:SetAngles(self:GetAngles())
			newent:Spawn()
			newent:Activate()
			self:Remove()
			return
		end
		
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(5)
			phys:Wake()
			phys:EnableMotion(true)
		end
	end
	function ENT:Use(ply)
		local SWEP=self.SWEP
		if not(ply:HasWeapon(SWEP))then
			self:EmitSound(self.ImpactSound,60,100)
			ply:Give(SWEP)
			ply:SelectWeapon(SWEP)
			self:Remove()
		else
			ply:PickupObject(self)
		end
	end
elseif(CLIENT)then
	--
end