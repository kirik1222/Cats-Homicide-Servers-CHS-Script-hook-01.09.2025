AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName		= "Easter cake"
ENT.SWEP="wep_jack_hmcd_eastercake"
ENT.ImpactSound="physics/body/body_medium_impact_soft5.wav"
ENT.Model="models/easter_kulich/kulich.mdl"
ENT.Infectable=true
if(SERVER)then
	function ENT:PickUp(ply)
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
end