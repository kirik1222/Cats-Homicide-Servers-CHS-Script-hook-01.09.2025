AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName		= "Bear Trap"
ENT.SWEP="wep_jack_hmcd_beartrap"
ENT.Model="models/stiffy360/beartrap.mdl"
ENT.Sequence="OpenIdle"
ENT.CollisionGroup=COLLISION_GROUP_NONE
if(SERVER)then
	
	function ENT:PickUp(ply)
		local SWEP=self.SWEP
		if not(ply:HasWeapon(self.SWEP) or self.Triggered)then
			self:EmitSound("Grenade.ImpactHard",60,90)
			ply:Give(self.SWEP)
			ply:GetWeapon(self.SWEP).HmcdSpawned=self.HmcdSpawned
			ply:GetWeapon(self.SWEP).Poisoned=self.Poisoned
			ply:GetWeapon(self.SWEP).Poisoner=self.Poisoner
			self:Remove()
			ply:SelectWeapon(SWEP)
		else
			ply:PickupObject(self)
		end
	end
	
	local legBones={
		[19]=true,
		[20]=true,
		[21]=true,
		[23]=true,
		[24]=true,
		[25]=true
	}
	
	local damageMuls={
		[6]=20,
		[5]=20
	}
	
	function ENT:StartTouch(ply)
		if not IsValid(ply) or not IsValid(self) then return end
		if self:GetSequence() != 0 and self:GetSequence() != 2 then
			self:SetPlaybackRate(1)
			self:SetCycle(0)
			self:SetSequence("Snap")
			self:EmitSound("beartrap.wav")
			constraint.RemoveAll(self)
			timer.Simple(0.1, function()
				if not IsValid(self) then return end
				local Pos = self:LocalToWorld(self:OBBCenter())+Vector(0,0,5)
				self:SetSequence("ClosedIdle")
				if self:IsEntSoft(ply) then
					for i=1,20 do
						local Tr=util.TraceLine({start=Pos,endpos=ply:GetPos()+VectorRand()*50})
						util.Decal("Blood",Tr.HitPos+Tr.HitNormal,Tr.HitPos-Tr.HitNormal)
					end
				end
				if not(ply:IsPlayer() or ply:IsRagdoll()) then
					local DamageAmt=math.random(30,35)
					local Dam=DamageInfo()
					Dam:SetAttacker(self.Attacker)
					Dam:SetInflictor(self)
					Dam:SetDamage(DamageAmt)
					Dam:SetDamageForce(Vector(0,0,0))
					Dam:SetDamageType(DMG_SLASH)
					Dam:SetDamagePosition(ply:GetPos())
					ply:TakeDamageInfo(Dam)
				end
			end)
			if ply:IsPlayer() or ply:GetClass()=="prop_ragdoll" then
				local owner=ply
				if IsValid(ply:GetRagdollOwner()) and ply:GetRagdollOwner():Alive() then owner=ply:GetRagdollOwner() end
				if self.Poisoned or self.ContactPoisoned then
					local poisonsApplied={}
					if self.Poisoned then table.insert(poisonsApplied,"Curare") end
					if self.ContactPoisoned then table.insert(poisonsApplied,"VX") end
					self.Poisoned=nil
					self.ContactPoisoned=nil
					if owner:IsPlayer() then
						HMCD_Poison(owner,self.Poisoner, table.Random(poisonsApplied))
					end
				end
				local minDist,bestBone=1000000,0
				for i=0,ply:GetBoneCount()-1 do
					local pos=ply:GetBonePosition(i)
					local dist=pos:DistToSqr(self:GetPos())
					if dist<minDist then
						minDist=dist
						bestBone=i
					end
				end
				if legBones[bestBone] then
					if owner:IsPlayer() then owner.SpeedMul=owner.SpeedMul*.25 end
				end
				local info={}
				info.Bone=bestBone
				info.Name="BearTrap"
				if not(ply.SpecialAccs) then ply.SpecialAccs={} end
				ply.SpecialAccs["BearTrap"]=info
				net.Start("hmcd_special_acc")
				net.WriteEntity(ply)
				net.WriteTable(info)
				net.Send(player.GetAll())
				self.Triggered=true
				timer.Simple(.3,function()
					if IsValid(self) then
						self:Remove()
					end
				end)
				local pos=ply:GetBonePosition(bestBone)
				local DamageAmt=math.random(30,35)*(damageMuls[bestBone] or 1)
				local Dam=DamageInfo()
				Dam:SetAttacker(self.Attacker)
				Dam:SetInflictor(self)
				Dam:SetDamage(DamageAmt)
				Dam:SetDamageForce(Vector(0,0,0))
				Dam:SetDamageType(DMG_SLASH)
				Dam:SetDamagePosition(pos)
				ply:TakeDamageInfo(Dam)
			end
			return
		end
	end

	function ENT:IsEntSoft(ent)
		return ((ent:IsNPC())or(ent:IsPlayer())or(ent:GetClass()=="prop_ragdoll"))
	end
end