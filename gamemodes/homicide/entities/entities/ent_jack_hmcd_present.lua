AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName		= "Gift Box"
ENT.Model="models/items/cs_gift.mdl"
if(SERVER)then
	--[[function ENT:Initialize()
		self.Entity:SetModel("models/draganm_custom/pumpkin_pack/jackolantd_0"..math.random(1,2)..".mdl")
		self:PrecacheGibs()
		self:SetBodygroup(1,1)
		self.Entity:SetSkin(math.random(0,3))
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(20)
			phys:Wake()
			phys:EnableMotion(true)
		end
	end]]
	function ENT:PickUp(ply)
		if math.random(1,100)!=1 then
			local edata = EffectData()
			edata:SetStart(self:GetPos())
			edata:SetOrigin(self:GetPos())
			edata:SetNormal(self:GetPos():GetNormalized())
			edata:SetEntity(self)
			edata:SetRadius(10)
			util.Effect("balloon_pop",edata,true,true)
			GAMEMODE:SpawnLoot(self:GetPos(),false,true)
			self:GibBreakServer( Vector(0,0,0) )
			self:Remove()
			ply:AddMerit(1)
		else
			self.IEDAttacker=ply
			self:ExplodeIED()
		end
	end
--[[else
	function ENT:Draw()
		self:DrawModel()
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			dlight.Pos = self:GetPos()+self:GetUp()*3
			dlight.r = 255
			dlight.g = 90
			dlight.b = 0
			dlight.brightness = 1
			dlight.Decay = 256
			dlight.Size =  math.min(256,100)
			dlight.DieTime = CurTime() + 1
			dlight.style = 6
		end
	end]]
end