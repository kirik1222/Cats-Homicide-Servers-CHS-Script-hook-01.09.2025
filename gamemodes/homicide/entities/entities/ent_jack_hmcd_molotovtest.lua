AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName		= "Molotov"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.IsLoot=true
ENT.SWEP="wep_jack_hmcd_molotovtest"

if(SERVER)then
	function ENT:Initialize()
		self:SetModel("models/weapons/w_molotov.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(5)
		end
		timer.Simple(.1,function()
			if self.Ignited then
				ParticleEffectAttach("molotov_trail", PATTACH_ABSORIGIN_FOLLOW, self, 0)
			end
		end)
		self.Detonated=false
		self.Ignited=false
		self.SpawnTime=CurTime()
		self.Radius=200
		self.BurnDamage={}
	end
	function ENT:PickUp(ply)
		if(self.Armed)then return end
		if(self.Ignited)then return end
		local SWEP=self.SWEP
		if not(ply:HasWeapon(self.SWEP))then
			self:EmitSound("GlassBottle.ImpactHard",60,90)
			ply:Give(self.SWEP)
			ply:GetWeapon(self.SWEP).HmcdSpawned=self.HmcdSpawned
			self:Remove()
			ply:SelectWeapon(SWEP)
		else
			ply:PickupObject(self)
		end
	end
	function ENT:CanPassThrough(ent)
		return string.find(ent:GetClass(),"prop_") or ent:IsPlayer() or string.find(ent:GetClass(),"ent") or string.find(ent:GetClass(),"npc") or HMCD_ExplosiveType(ent)==3
	end
	function ENT:IgniteEntities()
		for key,ent in pairs(ents.FindInSphere( self:GetPos(), self.Radius )) do
			local Tr = util.QuickTrace(self:GetPos(),ent:GetPos()-self:GetPos(),{self,ent})
			local Diffz = self:GetPos().z-ent:GetPos().z
			if self:Visible(ent) and self:CanBeIgnited(ent) and math.abs(Diffz)<20 then 
				local mass
				if ent:GetPhysicsObject() then
					mass = ent:GetPhysicsObject():GetMass()
				else
					mass = 100
				end
				self:ModifiedIgnite(ent,math.random(mass*0.15,mass*0.2))
			end
		end
	end
	function ENT:ModifiedIgnite(ent,ignitetime,isRDM)
		local curIgniteTime=0
		if IsValid(ent.CurrentFire) then curIgniteTime=ent.CurrentFire:GetInternalVariable("lifetime")-CurTime() end
		ent:Ignite(curIgniteTime+ignitetime)
		if isRDM then
			local owner=ent
			if IsValid(ent:GetRagdollOwner()) and ent:GetRagdollOwner():Alive() then owner=ent:GetRagdollOwner() end
			if owner:IsPlayer() and IsValid(self.Owner) then owner.LastIgniter=self.Owner end
		end
	end
	function ENT:CanBeIgnited(ent)
		return HMCD_Flammables[ent:GetMaterialType()] or (ent:IsPlayer() and ent:Alive()) or HMCD_ExplosiveType(ent)==3 or ent:IsNPC() or ent.GasolineAmt
	end
	function ENT:Think()
		if self.Detonated then
			--[[if not(self.ReadyToDelete) then
				local Gas=ents.Create("ent_jack_hmcd_carbon")
				Gas:SetPos(self:GetPos())
				Gas.HmcdSpawned=self.HmcdSpawned
				Gas.Owner=self.Owner
				Gas:Spawn()
				Gas:Activate()
				Gas:GetPhysicsObject():SetVelocity(Vector(math.random(100,150),math.random(100,150),math.random(200,300)))
			end]]
			for i,ent in pairs(ents.FindInSphere( self:GetPos(), self.Radius )) do
				local Diffz = self:GetPos().z-ent:GetPos().z
				if (self:Visible(ent)) and math.abs(Diffz)<20 and not(self.ReadyToDelete) then
					local attacker=self.Owner
					if not(IsValid(attacker)) then attacker=game.GetWorld() end
					local Dmg=DamageInfo()
					if CurTime()-self.SpawnTime>=10 then
						Dmg:SetAttacker(game.GetWorld())
						if IsValid(attacker) then
							local owner=ent
							if IsValid(ent:GetRagdollOwner()) and ent:GetRagdollOwner():Alive() then ent=ent:GetRagdollOwner() end
							if owner:IsPlayer() then owner.LastAttacker=attacker owner.LastAttackerName=attacker.BystanderName end
						end
					else
						Dmg:SetAttacker(attacker)
					end
					Dmg:SetInflictor(self)
					Dmg:SetDamageType(DMG_BURN)
					Dmg:SetDamagePosition(self:GetPos())
					Dmg:SetDamageForce(vector_origin)
					Dmg:SetDamage(3)
					ent:TakeDamageInfo(Dmg)
					if self:CanBeIgnited(ent) then
						local mass
						if IsValid(ent:GetPhysicsObject()) then
							mass=ent:GetPhysicsObject():GetMass()
						else
							mass=100
						end
						if not(self.BurnDamage[ent]) then self.BurnDamage[ent]=0 end
						self.BurnDamage[ent]=self.BurnDamage[ent]+3
						if ent.GasolineAmt or math.random(10,self.BurnDamage[ent])>13 then
							self:ModifiedIgnite(ent,math.random(mass*0.15,mass*0.2),CurTime()-self.SpawnTime<10)
							self.BurnDamage[ent]=nil
						end
					end
				end
			end
			self.BurnDamage[NULL]=nil
			for ent in pairs(self.BurnDamage) do
				self.BurnDamage[ent]=self.BurnDamage[ent]-0.2
				if self.BurnDamage[ent]==0 then self.BurnDamage[ent]=nil end
			end
			if self.ReadyToDelete then self:Remove() end
			if self.Crispiness<1 and self.Detonated then
				self:StopSound("weapons/molotov/molotov_burn.wav")
				sound.Play("weapons/molotov/molotov_burn_extinguish.wav",self:GetPos(),75,100)
				self:Remove() 
			end
		end
		self:NextThink(CurTime()+.25)
		return true
	end
	function ENT:Detonate()
		if(self:WaterLevel()>=3)then
			self.Armed=false
			self.Ignited=false
			self:Extinguish()
			local effectdata = EffectData()
			effectdata:SetEntity(self)
			util.Effect("ParticleEffectStop", effectdata)		
			return 
		end
		if(self.Detonated)then return end
		self.Detonated=true
		local hitpos = util.QuickTrace(self:GetPos()+vector_up,-vector_up*500,{self}).HitPos
		local Pos,Attacker=self:LocalToWorld(self:OBBCenter())+Vector(0,0,5),self.Owner
		self:IgniteEntities()
		self:EmitSound("weapons/molotov/molotov_burn.wav")
		self:Extinguish()
		self.Crispiness=225
		self:SetMaterial("models/hands/hands_color")
		self:SetPos(hitpos)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		timer.Simple(31,function()
			if IsValid(self) then
				self.ReadyToDelete=true
			end
		end)
		local effectdata = EffectData()
		effectdata:SetAngles(self:GetAngles())
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetEntity(self)
		util.Effect("eff_jack_hmcd_fancyfire", effectdata)
		
		local Fire=ents.Create("ent_jack_hmcd_fire")
		Fire.Initiator=self.Owner
		Fire:SetPos(self:GetPos())
		Fire.SpawnTime=CurTime()-10
		Fire:Spawn()
		Fire:Activate()
	end
	function ENT:PhysicsCollide(data,physobj)
		if(data.DeltaTime>.1)then
			self:EmitSound("GlassBottle.ImpactHard")
			self:GetPhysicsObject():SetVelocity(self:GetPhysicsObject():GetVelocity()*.9)
			if self.Ignited then
				self:Detonate()
			end
		end
	end
	function ENT:Light()
		if(self:WaterLevel()>=3)then return end
		self.Ignited=true
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:SetDTBool(0,true)
	end
	function ENT:StartTouch(ply)
		--
	end
end