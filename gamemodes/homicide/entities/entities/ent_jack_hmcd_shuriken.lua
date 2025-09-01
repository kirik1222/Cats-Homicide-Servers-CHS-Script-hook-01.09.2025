AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName		= "Knife"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.MurdererLoot=true

if(SERVER)then
	function ENT:Initialize()
		self:SetModel("models/jaanus/shuriken_small.mdl")
		self:PhysicsInitBox(Vector(-2,-2,-1),Vector(2,2,1))
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(3)
		end
		self.HitSomething=false
	end

	function ENT:Use(ply)
		if not(ply:HasWeapon("wep_jack_hmcd_shuriken")) then
			if(self.ContactPoisoned)then
				if(ply.Role=="killer")then
					ply:PrintMessage(HUD_PRINTTALK,"This is poisoned!")
					return
				else
					self.ContactPoisoned=false
					HMCD_Poison(ply,self.Poisoner,"VX")
				end
			end
			ply:Give("wep_jack_hmcd_shuriken")
			ply:GetWeapon("wep_jack_hmcd_shuriken").HmcdSpawned=self.HmcdSpawned
			self:Remove()
			ply:SelectWeapon("wep_jack_hmcd_shuriken")
			ply:GetWeapon("wep_jack_hmcd_shuriken").Poisoned=self.Poisoned
			ply:GetWeapon("wep_jack_hmcd_shuriken").Infected=self.Infected
		end
	end

	function ENT:Think()
		if((self:GetVelocity():Length()>300)and not(self.HitSomething))then
			self:EmitSound("snd_jack_hmcd_tinyswish.wav",70,math.random(90,110))
		end
		--[[if(self.HitSomething)then
			for key,ply in pairs(ents.FindInSphere(self:GetPos(),30))do
				if((ply:IsPlayer())and(ply.Murderer))then
					ply:Give("wep_jack_hmcd_shuriken")
					ply:GetWeapon("wep_jack_hmcd_shuriken").HmcdSpawned=self.HmcdSpawned
					self:Remove()
					ply:SelectWeapon("wep_jack_hmcd_shuriken")
					ply:GetWeapon("wep_jack_hmcd_shuriken").Poisoned=self.Poisoned
				end
			end
		end]]
		self:NextThink(CurTime()+.1)
		return true
	end

	local function addangle(ang,ang2)
		ang:RotateAroundAxis(ang:Up(),ang2.y) -- yaw
		ang:RotateAroundAxis(ang:Forward(),ang2.r) -- roll
		ang:RotateAroundAxis(ang:Right(),ang2.p) -- pitch
	end

	function ENT:PhysicsCollide(data,physobj)
		local ply = data.HitEntity
		if ply:IsPlayer() or ply:IsNPC() or (ply:IsRagdoll() and ply.fleshy) then
			local owner=ply
			if IsValid(ply:GetRagdollOwner()) then
				owner=ply:GetRagdollOwner()
			end
			if((self.Thrown)and not(self.HitSomething))then
				local norm=data.HitPos-self:GetPos()
				norm:Normalize()
				local hitgroup=0
				local hitPos
				local hitgroupTr=util.QuickTrace(data.HitPos-norm*3,norm*666,self)
				if hitgroupTr.Entity==ply then
					if ply:IsRagdoll() then
						hitgroup=HMCD_GetRagdollHitgroup(ply,hitgroupTr.PhysicsBone)
					else
						hitgroup=hitgroupTr.HitGroup
					end
					hitPos=hitgroupTr.HitPos
				end
				self.HitSomething=true
				local dmg = DamageInfo()
				dmg:SetDamage(math.random(5,9))
				dmg:SetAttacker(self:GetOwner())
				dmg:SetDamageType(DMG_SLASH)
				dmg:SetDamageForce(data.OurOldVelocity)
				dmg:SetDamagePosition(hitPos or data.HitPos)
				GAMEMODE:ScalePlayerDamage(owner,hitgroup,dmg)
				dmg:SetDamage(math.Clamp(dmg:GetDamage(),0,9))
				ply:TakeDamageInfo(dmg)
				if dmg:GetDamage()>1 then
					self:EmitSound("snd_jack_hmcd_knifestab.wav",55,math.random(90,110))
					if self.Poisoned and owner:IsPlayer()then
						HMCD_Poison(owner,self:GetOwner(),"Curare")
						self.Poisoned=false
					end
					if self.Infected and owner:IsPlayer() then
						GAMEMODE:Infect(owner)
					end
					if(ply.Infected) then
						self.Infected=true
					end
					local edata = EffectData()
					edata:SetStart(self:GetPos())
					edata:SetOrigin(self:GetPos())
					edata:SetNormal(vector_up)
					edata:SetEntity(ply)
					util.Effect("BloodImpact",edata,true,true)
				else
					self:EmitSound("snd_jack_hmcd_knifehit.wav",70,math.random(90,110))
				end
				addangle(ply:GetAngles(), Angle(-60,0,0))
			end
		elseif(data.DeltaTime>.1)then
			self:EmitSound("snd_jack_hmcd_knifehit.wav",70,math.random(90,110))
		end
		self.HitSomething=true
	end
	function ENT:StartTouch(ply)
		--[[if((ply:IsPlayer())and(ply.Murderer))then
			ply:Give("wep_jack_hmcd_shuriken")
			ply:GetWeapon("wep_jack_hmcd_shuriken").HmcdSpawned=self.HmcdSpawned
			self:Remove()
		end]]
	end
elseif(CLIENT)then
	function ENT:Initialize()
		--self.Emitter = ParticleEmitter(self:GetPos())
		self.NextPart = CurTime() 
	end

	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Think()
		local pos = self:GetPos()
		local client = LocalPlayer()

		if false then

			if client:GetPos():Distance(pos) > 1000 then return end

			self.Emitter:SetPos(pos)
			self.NextPart = CurTime() + math.Rand(0, 0.02)
			local vec = VectorRand() * 3
			local pos = self:LocalToWorld(vec)
			local particle = self.Emitter:Add( "particle/snow.vmt", pos)
			particle:SetVelocity(  Vector(0,0, 4) )
			particle:SetDieTime( 7 )
			particle:SetStartAlpha( 140 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 5 )
			particle:SetEndSize( 6 )   
			particle:SetRoll( 0 )
			particle:SetRollDelta( 0 )
			particle:SetColor( 0, 0, 0 )
			//particle:SetGravity( Vector( 0, 0, 10 ) )
		end
	end

	function ENT:OnRemove()
		--self.Emitter:Finish()
	end
end