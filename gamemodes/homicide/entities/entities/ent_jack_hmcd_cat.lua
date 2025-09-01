AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName		= "Cat"
ENT.SWEP="wep_jack_hmcd_cat"
ENT.ImpactSound="Flesh.ImpactSoft"
ENT.Model="models/dingus/dingus.mdl"
ENT.Mass=15
ENT.Scale=.5
ENT.NextMeow=0
ENT.Attackers={}
if(SERVER)then
	function ENT:Initialize()
		if not(self.Attackers) then self.Attackers={} end
		self.Entity:SetModel(self.Model)
		if self.Scale then self.Entity:SetModelScale(self.Scale,0) end
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(self.Mass)
			phys:Wake()
			phys:EnableMotion(true)
		end
	end
	function ENT:PickUp(ply)
		if self.Attacking then return end
		local ind=ply:EntIndex()
		if self.Attackers[ind] and self.Attackers[ind]>10 then
			self:EmitSound("cat/meowbad.wav")
			self.Attacking=true
			timer.Simple(1,function()
				if IsValid(self) and IsValid(ply) then
					local shootPos,pos=ply:GetShootPos(),self:GetPos()
					self:GetPhysicsObject():SetVelocity((shootPos-pos)*6)
					local str=self:EntIndex().."_Attacking"
					local attackEnd=CurTime()+2
					hook.Add("Think",str,function()
						if not(IsValid(self) and IsValid(ply)) or attackEnd<CurTime() then
							self.Attacking=false
							hook.Remove("Think",str)
						else
							if ply:GetShootPos():DistToSqr(self:GetPos())<900 then
								local dmginfo=DamageInfo()
								dmginfo:SetDamagePosition(util.QuickTrace(self:GetPos(),(ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))-self:GetPos()):GetNormalized()*1000,self).HitPos)
								dmginfo:SetDamageType(DMG_SLASH)
								dmginfo:SetDamage(10)
								dmginfo:SetAttacker(self)
								GAMEMODE:ScalePlayerDamage(ply,HITGROUP_HEAD,dmginfo)
								ply:TakeDamageInfo(dmginfo)
								self.Attacking=false
								hook.Remove("Think",str)
							end
						end
					end)
				end
			end)
			return
		end
		local SWEP=self.SWEP
		if not(ply:HasWeapon(SWEP))then
			self:EmitSound(self.ImpactSound,60,100)
			ply:Give(SWEP)
			ply:GetWeapon(self.SWEP).HmcdSpawned=self.HmcdSpawned
			ply:GetWeapon(self.SWEP).Attackers=self.Attackers
			self:Remove()
			ply:SelectWeapon(SWEP)
		else
			ply:PickupObject(self)
		end
	end
	function ENT:CanSeePly(ply,pos)
		return ply:Alive() and ply:GetPos():DistToSqr(pos)<90000 and ply:Visible(self) and not(self.Attackers[ply:EntIndex()] and self.Attackers[ply:EntIndex()]>10)
	end
	function ENT:Think()
		local pos=self:GetPos()
		if not(IsValid(self.Owner)) then
			--if not(self.Attackers) then self.Attackers={} end
			local potentialOwners={}
			for i,ply in pairs(player.GetAll()) do
				if self:CanSeePly(ply,pos) then
					table.insert(potentialOwners,{ply,self.Attackers[ply:EntIndex()] or 0})
				end
			end
			table.SortByMember(potentialOwners,2,true)
			if not(table.IsEmpty(potentialOwners)) then self.Owner=potentialOwners[1][1] end
		else
			if not(self:CanSeePly(self.Owner,pos)) then
				self.Owner=nil
			elseif not(self.Attacking) then
				self:GetPhysicsObject():SetVelocity(self:GetVelocity()+(self.Owner:GetPos()-pos):GetNormalized()*100)
				if self.NextMeow<CurTime() then
					self.NextMeow=CurTime()+math.Rand(3,5)
					local rand=math.random(1,5)
					if rand==1 then rand="" end
					self:EmitSound("cat/meow"..rand..".wav")
				end
			end
		end
		self:NextThink(CurTime()+.5)
		return true
	end
	function ENT:OnTakeDamage(dmginfo)
		local attacker=dmginfo:GetAttacker()
		if IsValid(attacker.Owner) then attacker=attacker.Owner end
		if attacker:IsPlayer() then
			local ind=attacker:EntIndex()
			if not(self.Attackers[ind]) then self.Attackers[ind]=0 end
			self.Attackers[ind]=self.Attackers[ind]+dmginfo:GetDamage()
		end
	end
end