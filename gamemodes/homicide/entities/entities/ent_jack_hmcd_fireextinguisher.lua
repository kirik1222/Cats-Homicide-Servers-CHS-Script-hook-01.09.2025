AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName		= "Fire Extinguisher"
ENT.SWEP="wep_jack_hmcd_firextinguisher"
ENT.ImpactSound="physics/metal/metal_solid_impact_soft1.wav"
ENT.SecondSound="physics/metal/metal_canister_impact_hard3.wav"
ENT.BigTable={}
ENT.SmallTable={}
if(SERVER)then
	function ENT:Initialize()
		self.Entity:SetModel("models/weapons/tfa_nmrih/w_tool_extinguisher.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		if not(self.SprayAmount) then self.SprayAmount=1500 end
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(10)
			phys:Wake()
			phys:EnableMotion(true)
		end
	end
	function ENT:Think()
		if self.ShotThrough and self.SprayAmount>0 then
			if not(self.SoundPlaying) then
				self.SoundPlaying=true
				self:EmitSound("fire_extinguisher/fire_extinguisger_startloop.wav",60,120)
			end
			local selfPos=self:GetPos()
			for i,info in pairs(self.BigTable) do
				if self.SprayAmount>0 then
					self.SprayAmount=self.SprayAmount-1
					local effectdata=EffectData()
					local pos,dir=info[1],info[2]
					local hitPos=self:LocalToWorld(pos)
					dir=self:LocalToWorld(dir)-hitPos
					dir:Normalize()
					effectdata:SetNormal(dir)
					effectdata:SetOrigin(hitPos)
					effectdata:SetEntity(self)
					effectdata:SetAttachment(1)
					local Tr=util.QuickTrace( hitPos, dir*150, self )
					if Tr.Hit then
						util.Decal("FireExt_"..math.random(1,2),Tr.HitPos-Tr.HitNormal,Tr.HitPos+Tr.HitNormal)
						if Tr.Entity:IsOnFire() then
							if SERVER then
								if IsValid(Tr.Entity.CurrentFire) then 
									local timeLeft=Tr.Entity.CurrentFire:GetInternalVariable("lifetime")-CurTime()
									Tr.Entity.CurrentFire:SetSaveValue("lifetime",CurTime()+timeLeft/2)
								end
							end
						end
						if Tr.Entity:GetClass()=="ent_jack_hmcd_molotovtest" and Tr.Entity.Detonated then
							Tr.Entity.Crispiness=Tr.Entity.Crispiness-1
						end
					else
						for key,ent in pairs(ents.FindInSphere( Tr.HitPos, 300 )) do
							if ent:GetClass()=="ent_jack_hmcd_fire" then
								ent.Radius=math.Clamp(ent.Radius-1,0,1000)
								if ent.Radius<=20 then
									SafeRemoveEntity(ent)
								end
							end
							if ent:GetClass()=="env_fire" then
								ent:SetHealth(ent:Health()-1)
								if ent:Health()<0 then ent:Remove() end
							end
						end
					end
					util.Effect("eff_jack_hmcd_fireextparticle", effectdata)
				else
					self:StopSound("fire_extinguisher/fire_extinguisger_startloop.wav")
				end
			end
		else
			self:StopSound("fire_extinguisher/fire_extinguisger_startloop.wav")
		end
		self:NextThink(CurTime())
		return true
	end
	function ENT:OnTakeDamage(dmg)
		if not(dmg:IsDamageType(DMG_BULLET) or dmg:IsDamageType(DMG_BUCKSHOT)) then return end
		self.ShotThrough=true
		self.Attacker=dmg:GetAttacker()
		local dmgPos=dmg:GetDamagePosition()
		local hitPos=self:WorldToLocal(dmgPos)
		local dir=(self:GetPos()-dmgPos):GetNormalized()
		local hitNormal=util.TraceLine({
			start=dmgPos-dir*5,
			endpos=dmgPos+dir*10,
			ignoreworld=true,
			filter={self},
			whitelist=true
		}).HitNormal
		hitNormal=self:WorldToLocal(dmgPos+hitNormal)
		table.insert(self.BigTable,{hitPos,hitNormal})
	end
	function ENT:PickUp(ply)
		local SWEP=self.SWEP
		if not(ply:HasWeapon(SWEP)) and not(self.ShotThrough) then
			self:EmitSound(self.ImpactSound,60,100)
			ply:Give(SWEP)
			ply:GetWeapon(self.SWEP).HmcdSpawned=self.HmcdSpawned
			ply:GetWeapon(SWEP).Poisoned=self.Poisoned
			ply:GetWeapon(SWEP):SetAmount(self.SprayAmount)
			ply:GetWeapon(SWEP).Poisoner=self.Poisoner
			self:Remove()
			ply:SelectWeapon(SWEP)
		else
			ply:PickupObject(self)
		end
	end
	function ENT:PhysicsCollide(data,ent)
		if(data.DeltaTime>.1)then
			self:EmitSound(self.ImpactSound,math.Clamp(data.Speed/3,20,65),math.random(100,120))
			if(self.SecondSound)then sound.Play(self.SecondSound,self:GetPos(),math.Clamp(data.Speed/3,20,65),math.random(100,120)) end
		end
	end
elseif(CLIENT)then
	--
end