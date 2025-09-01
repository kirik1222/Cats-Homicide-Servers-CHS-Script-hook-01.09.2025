AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName		= "PPSH-40 Magazine"
ENT.ImpactSound="weapon_impact_soft1.wav"
ENT.Model="models/weapons/smc/ppsh/w_ppshdrum.mdl"
if(SERVER)then
	function ENT:PickUp(ply)
		ply:PickupObject(self)
	end
end