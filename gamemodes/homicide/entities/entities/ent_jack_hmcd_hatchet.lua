AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName		= "Hatchet"
ENT.SWEP="wep_jack_hmcd_hatchet"
ENT.ImpactSound="physics/metal/metal_solid_impact_soft1.wav"
ENT.MurdererLoot=true
ENT.Infectable=true
ENT.NoHolster=true
if(SERVER)then

	function ENT:Initialize()
		self.Entity:SetModel("models/eu_homicide/w_hatchet.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(5)
			phys:Wake()
			phys:EnableMotion(true)
		end
		self.HitSomething=false
		self.Thinks=0
		self.HitEntity=nil
		self.HitPos=Vector(0,0,0)
		self.HatchetVelocity=Vector(0,0,0)
		if not(self.Thrown)then self:SetCollisionGroup(COLLISION_GROUP_WEAPON) end
	end
	
	function ENT:Think()
		--
	end
	
	function ENT:PhysicsCollide(data,phys)
		local ent=data.HitEntity
		if self.Thrown and not(self.HitSomething) then
			self.HitSomething=true
			local owner=ent
			if IsValid(ent:GetRagdollOwner()) then owner=ent:GetRagdollOwner() end
			if(ent:GetClass()=="func_breakable_surf")then
				ent:Fire("break","",0)
			end
			local tr=util.QuickTrace(self:GetPos()+self:GetAngles():Forward()*4+self:GetAngles():Right()*4,self:GetAngles():Forward()*500,self)
			self:EmitSound(self.ImpactSound,70,math.random(90,110))
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			if tr.Entity!=ent then return end
			local norm=data.HitPos-self:GetPos()
			norm:Normalize()
			local hitgroup=0
			local hitPos
			local hitgroupTr=util.QuickTrace(data.HitPos-norm*3,norm*666,self)
			if hitgroupTr.Entity==ply then
				if ply:IsRagdoll() then
					hitgroup=HMCD_GetRagdollHitgroup(ply,hitgroupTr.PhysicsBone)
				elseif owner:IsPlayer() or owner:IsNPC() then
					hitgroup=hitgroupTr.HitGroup
				end
				hitPos=hitgroupTr.HitPos
			end
			local Dmg,DmgAmt=DamageInfo(),math.random(20,30)
			Dmg:SetDamage(DmgAmt)
			Dmg:SetDamageForce(data.OurOldVelocity)
			Dmg:SetDamagePosition(hitPos or data.HitPos)
			Dmg:SetDamageType(DMG_SLASH)
			Dmg:SetAttacker(self.Owner)
			Dmg:SetInflictor(self)
			ent:TakeDamageInfo(Dmg)
			if owner:IsPlayer() or owner:IsNPC() or (owner:IsRagdoll() and owner.fleshy) then
				GAMEMODE:ScalePlayerDamage(ent,hitgroup,Dmg)
				Dmg:SetDamage(math.Clamp(Dmg:GetDamage(),0,30))
				if Dmg:GetDamage()>1 then
					self:EmitSound("snd_jack_hmcd_axehit.wav",75,math.random(110,130))
					if(owner:IsPlayer())then
						if(self.Poisoned)then
							self.Poisoned=false
							HMCD_Poison(owner,self.Owner,"Curare")
						end
						if(self.Infected) then
							if not(owner.ZombieBacteria) then owner.ZombieBacteria={} end
							table.insert(owner.ZombieBacteria,{45,CurTime()-101})
							local sum=0
							for i,tabl in pairs(owner.ZombieBacteria) do
								sum=sum+tabl[1]
							end
							if sum>=owner:Health()-(owner.MaxBlood-owner.BloodLevel)*0.08 then
								GAMEMODE:Infect(owner)
							end
						end
					end
					local edata=EffectData()
					edata:SetStart(self:GetPos())
					edata:SetOrigin(self:GetPos())
					edata:SetNormal(vector_up)
					edata:SetEntity(ent)
					util.Effect("BloodImpact",edata,true,true)
					timer.Simple(.05,function()
						for i=1,2 do
							local BloodTr=util.QuickTrace(data.HitPos-data.OurOldVelocity:GetNormalized()*10,data.OurOldVelocity:GetNormalized()*50,{self})
							if(BloodTr.Hit)then util.Decal("Blood",BloodTr.HitPos+BloodTr.HitNormal,BloodTr.HitPos-BloodTr.HitNormal) end
						end
					end)
				end
			else
				self:EmitSound("physics/metal/metal_solid_impact_hard1.wav",75,math.random(90,110))
			end
		else
			if(data.DeltaTime>.2)then self:EmitSound(self.ImpactSound,65,math.random(90,110)) end
		end
	end
	
	function ENT:PickUp(ply)
		if((self.Thrown)and not(self.HitSomething))then return end
		local SWEP=self.SWEP
		if not(ply:HasWeapon(SWEP))then
			if(self.ContactPoisoned)then
				if(ply.Role=="killer")then
					ply:PrintMessage(HUD_PRINTTALK,"This is poisoned!")
					return
				else
					self.ContactPoisoned=false
					HMCD_Poison(ply,self.Poisoner,"VX")
				end
			end
			ply:Give(SWEP)
			ply:GetWeapon(self.SWEP).HmcdSpawned=self.HmcdSpawned
			ply:GetWeapon(SWEP).Poisoned=self.Poisoned
			ply:GetWeapon(SWEP).Infected=self.Infected
			ply:SelectWeapon(SWEP)
			self:Remove()
			ply:SelectWeapon(SWEP)
		end
	end
	
elseif(CLIENT)then

	function ENT:Initialize()
		--
	end
	
end