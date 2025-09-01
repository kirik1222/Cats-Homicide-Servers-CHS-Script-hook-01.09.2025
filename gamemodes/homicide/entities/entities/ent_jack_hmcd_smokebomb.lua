AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName		= "Rauchbombe"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.IsLoot=true
if(SERVER)then
	function ENT:Initialize()
		self.Entity:SetModel("models/props_junk/jlare.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:EnableMotion(true)
		end
		self.BurnoutTime=CurTime()+30
		self.NextSmokeTime=CurTime()+.25
		self.Think=self.BurnThink
		for i,ply in pairs(player.GetAll()) do
			if ply.NextCough and ply.NextCough<CurTime() then ply.NextCough=nil end
		end
	end

	function ENT:Use(ply)
		ply:PickupObject(self)
	end

	function ENT:BurnThink()
		if(self.BurnoutTime<CurTime())then self:StopSound("snd_jack_hmcd_flare.wav") self.Think=nil self:SetNWBool("Burntout",true) end
		if(self:WaterLevel()>=3)then self.BurnoutTime=CurTime() return end
		if(self.NextSmokeTime<CurTime())then
			self.NextSmokeTime=CurTime()+.5
			ParticleEffect("pcf_jack_smokebomb3",self:GetPos(),Angle(0,0,0),self)
		end
		self:EmitSound("snd_jack_hmcd_flare.wav",65,math.random(95,105))
		for i,ply in pairs(player.GetAll()) do
			local watcher=ply
			if IsValid(ply.fakeragdoll) then watcher=ply.fakeragdoll end
			if ply:Alive() and watcher:Visible(self) and watcher:GetPos():DistToSqr(self:GetPos())<40000 and not(ply:GetNWString("Mask")=="Gas Mask" or ply.Role=="combine") then
				if not(ply.NextCough) then ply.NextCough=CurTime()+math.random(4,5) end
				if ply.NextCough<CurTime() then
					ply:Cough()
					ply.NextCough=CurTime()+math.random(4,5)
				end
			end
		end
		self:NextThink(CurTime()+.15)
		return true
	end
elseif(CLIENT)then
	local Glow=Material("sprites/mat_jack_basicglow")
	local col=Color(255,0,0,255)
	function ENT:Initialize()
		--
	end
	function ENT:Draw()
		if not(self:GetNWBool("Burntout")) then
			render.SetMaterial(Glow)
			
			col.g=math.random(150,220)
			col.b=math.random(125,150)
			
			render.DrawSprite(self:GetPos(),50,50,col)
		end
		self:DrawModel()
	end
end