AddCSLuaFile()
ENT.Type = "anim"
ENT.Base="ent_jack_hmcd_eq_base"
ENT.ImpactSound="physics/metal/weapon_impact_soft3.wav"
ENT.Model="models/weapons/upgrades/a_suppressor_ak.mdl"
ENT.EquipmentNum=HMCD_PBS
if(SERVER)then
	function ENT:Initialize()
		self.Entity:SetModel("models/weapons/upgrades/a_suppressor_ak.mdl")
		--self.Entity:SetColor(Color(100,100,100,255))
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(15)
			phys:Wake()
			phys:EnableMotion(true)
		end
	end
	function ENT:PickUp(ply)
		if(not(ply.HasAkSuppressor))then
			ply.HasAkSuppressor=true
			self:EmitSound("physics/metal/weapon_impact_soft3.wav",65,100)
			self:Remove()
			net.Start("hmcd_aksuppressorpickup")
			net.WriteEntity(ply)
			net.WriteBit(ply.HasAkSuppressor)
			net.Broadcast()
		end
	end
elseif(CLIENT)then
	--
end