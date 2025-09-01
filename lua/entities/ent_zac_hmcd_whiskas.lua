AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName		= "Whiskas"
ENT.Spawnable = false
ENT.SWEP="wep_zac_hmcd_whiskas"
ENT.ImpactSound="physics/body/body_medium_impact_soft5.wav"

WHISKAS_HMCDMODES = {
	["homicided"] = true,
	["homicide"] = true,
}

if(SERVER)then
	function ENT:Initialize()
		self.Entity:SetModel("models/whiskas/whiskas.mdl")
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
	end
	function ENT:PickUp(ply)
		local SWEP=self.SWEP
		if not(ply:HasWeapon(SWEP))then
			self:EmitSound(self.ImpactSound,60,100)
			if(!WHISKAS_HMCDMODES[engine.ActiveGamemode()])then
				ply:Give("weapon_whiskas")
			else
				ply:Give(SWEP)
				ply:GetWeapon(SWEP).HmcdSpawned=self.HmcdSpawned
				ply:GetWeapon(SWEP).Poisoned=self.Poisoned
				ply:GetWeapon(SWEP).Poisoner=self.Poisoner
			end
			self:Remove()
			ply:SelectWeapon(SWEP)
		else
			ply:PickupObject(self)
		end
	end
elseif(CLIENT)then
	--
end

if(!WHISKAS_HMCDMODES[engine.ActiveGamemode()])then
	-- local regENT = scripted_ents.GetStored("ent_zac_hmcd_whiskas").t
	-- regENT.Base = "base_anim"
	scripted_ents.Alias("ent_zac_hmcd_whiskas","ent_zac_whiskas")
end