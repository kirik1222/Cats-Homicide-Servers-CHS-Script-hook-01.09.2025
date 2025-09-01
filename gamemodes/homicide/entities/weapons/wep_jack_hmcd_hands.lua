if SERVER then
	AddCSLuaFile()

	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
else
	SWEP.PrintName			= translate and translate.hands or "Hands"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 1
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false

	SWEP.ViewModelFOV		= 45
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_hands")
	SWEP.BounceWeaponIcon=false

	local HandTex,ClosedTex=surface.GetTextureID("vgui/hud/hmcd_hand"),surface.GetTextureID("vgui/hud/hmcd_closedhand")
	function SWEP:DrawHUD()
		local Fake=self.Owner:GetNWEntity("Fake")
		if not(GetViewEntity()==LocalPlayer())then return end
		if not(self:GetFists() or IsValid(Fake)) then
			local Tr=util.QuickTrace(self.Owner:GetShootPos(),self.Owner:GetAimVector()*self.ReachDistance,{self.Owner})
			if(Tr.Hit)then
				if(self:CanPickup(Tr.Entity))then
					local Size=math.Clamp((1-((Tr.HitPos-self.Owner:GetShootPos()):Length()/self.ReachDistance)^2),.2,1)
					if(self.Owner:KeyDown(IN_ATTACK2))then
						surface.SetTexture(ClosedTex)
					else
						surface.SetTexture(HandTex)
					end
					surface.SetDrawColor(Color(255,255,255,255*Size))
					surface.DrawTexturedRect(ScrW()/2-(64*Size),ScrH()/2-(64*Size),128*Size,128*Size)
				end
			end
		end
	end
end

SWEP.SwayScale=3
SWEP.BobScale=3

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "These are your hands. Use them however you see fit. Defend yourself, attack people, move objects, etc.\n\nLMB to raise fists/punch.\nRELOAD to lower fists.\nRELOAD while holding a prop to freeze it in mid air.\nE while holding a prop to rotate it.\nWhen fists are down, press RMB to carry things.\nWhen fists are up, press RMB to block attacks.\nRELOAD while holding someone's hand to check their pulse."

SWEP.Spawnable			= false
SWEP.AdminOnly		= true

SWEP.HoldType = "normal"

SWEP.ViewModel	= "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel	= "models/props_junk/cardboard_box004a.mdl"

SWEP.AttackSlowDown=.5

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ReachDistance=60
SWEP.HomicideSWEP=true
SWEP.NextPulseCheck=0
SWEP.NextPump=0
SWEP.DangerLevel=0
SWEP.NotLoot=true
SWEP.UseHands=true

function SWEP:SetupDataTables()
	self:NetworkVar("Float",0,"NextIdle")
	self:NetworkVar("Bool",2,"Fists")
	self:NetworkVar("Float",1,"NextDown")
	self:NetworkVar("Bool",3,"Blocking")
end

function SWEP:PreDrawViewModel(vm,wep,ply)
	if IsValid(self.Owner:GetNWEntity("Fake")) then return true end
	vm:SetMaterial("engine/occlusionproxy")
end

function SWEP:Initialize()
	self:SetNextIdle(CurTime()+5)
	self:SetNextDown(CurTime()+5)
	self:SetHoldType(self.HoldType)
	self:SetFists(false)
	self:SetBlocking(false)
end

function SWEP:Deploy()
	if not(IsFirstTimePredicted())then
		self:DoBFSAnimation("fists_draw")
		self.Owner:GetViewModel():SetPlaybackRate(.1)
		return
	end
	self:SetNextPrimaryFire(CurTime()+.1)
	self:SetFists(false)
	self.DangerLevel=0
	self:SetNextDown(CurTime())
	self:DoBFSAnimation("fists_draw")
	return true
end

function SWEP:Holster()
	self:OnRemove()
	return true
end

function SWEP:CanPrimaryAttack()
	return true
end

local pickupWhiteList = {
	["prop_ragdoll"] = true,
	["prop_physics"] = true,
	["prop_physics_multiplayer"] = true,
	["func_physbox"] = true
}

function SWEP:CanPickup(ent)
	if self.Owner.Lost then return false end
	if string.find(ent:GetModel(),"zombie")!=nil then return false end
	if ent:IsNPC() then return false end
	if self.Owner:GetGroundEntity()==ent then return false end
	if(ent.IsLoot)then return true end
	local class=ent:GetClass()
	if pickupWhiteList[class] or string.find(class,"gf2") then return true end
	return false
end

function SWEP:SecondaryAttack()
	if not(IsFirstTimePredicted())then return end
	if(self:GetFists())then return end
	if(self.Owner.fakeragdoll) then return end
	if SERVER then
		self:SetCarrying()
		local tr = self.Owner:GetEyeTraceNoCursor()
		if((IsValid(tr.Entity))and(self:CanPickup(tr.Entity))and not(tr.Entity:IsPlayer()))then
			local Dist=(self.Owner:GetShootPos()-tr.HitPos):Length()
			if(Dist<self.ReachDistance)then
				if(tr.Entity.ContactPoisoned)then
					if(self.Owner.Role=="killer")then
						self.Owner:PrintMessage(HUD_PRINTTALK,"This is poisoned!")
						return
					else
						tr.Entity.ContactPoisoned=false
						HMCD_Poison(self.Owner,tr.Entity.Poisoner,"VX")
					end
				end
				sound.Play("Flesh.ImpactSoft",self.Owner:GetShootPos(),65,math.random(90,110))
				self:SetCarrying(tr.Entity,tr.PhysicsBone,tr.HitPos,Dist)
				tr.Entity.Touched=true
				self:ApplyForce()
			end
		elseif((IsValid(tr.Entity))and(tr.Entity:IsPlayer()))then
			local Dist=(self.Owner:GetShootPos()-tr.HitPos):Length()
			if(Dist<self.ReachDistance)then
				sound.Play("Flesh.ImpactSoft",self.Owner:GetShootPos(),65,math.random(90,110))
				self.Owner:SetVelocity(self.Owner:GetAimVector()*20)
				tr.Entity:SetVelocity(-self.Owner:GetAimVector()*50)
				self.Owner:ApplyStamina(-2)
				self:SetNextSecondaryFire(CurTime()+.25)
			end
		end
	end
end

function SWEP:ApplyForce()
	local target = self.Owner:GetAimVector() * self.CarryDist + self.Owner:GetShootPos()
	local phys = self.CarryEnt:GetPhysicsObjectNum(self.CarryBone)
	if IsValid(phys) then
		local TargetPos=phys:GetPos()
		if(self.CarryPos)then TargetPos=self.CarryEnt:LocalToWorld(self.CarryPos) end
		local vec = target - TargetPos
		local len,mul = vec:Length(),self.CarryEnt:GetPhysicsObjectNum(0):GetMass()
		if((len>self.ReachDistance)or(mul>170))then
			self:SetCarrying()
			return
		end
		if(self.CarryEnt:GetClass()=="prop_ragdoll")then 
			mul=mul*2
			if self.LightBone then mul=mul/6 end
		end
		vec:Normalize()
		local avec,velo=vec*len,phys:GetVelocity()-self.Owner:GetVelocity()
		local CounterDir,CounterAmt=velo:GetNormalized(),velo:Length()
		if(self.CarryPos)then
			phys:ApplyForceOffset((avec-velo/2)*mul,self.CarryEnt:LocalToWorld(self.CarryPos))
		else
			phys:ApplyForceCenter((avec-velo/2)*mul)
		end
		phys:ApplyForceCenter(Vector(0,0,mul))
		phys:AddAngleVelocity(-phys:GetAngleVelocity()/10)
	end
end

function SWEP:OnRemove()
	if IsValid(self.Owner) then
		if CLIENT and self.Owner:IsPlayer() then
			local vm=self.Owner:GetViewModel()
			if(IsValid(vm)) then vm:SetMaterial("") end
		end
	end
end

function SWEP:SetCarrying(ent,bone,pos,dist)
	if IsValid(ent) then
		self.CarryEnt = ent
		self.CarryEnt.Carrier=self.Owner
		self.CarryBone = bone
		self.CarryDist=dist
		local lhand,rhand=ent:LookupBone("ValveBiped.Bip01_L_Hand"),ent:LookupBone("ValveBiped.Bip01_R_Hand")
		local hands
		if lhand and rhand then
			hands={ent:TranslateBoneToPhysBone(lhand),ent:TranslateBoneToPhysBone(rhand)}
		end
		self.LightBone=ent:GetPhysicsObjectNum(bone):GetMass()<3
		self.HandBones=hands
		if not(ent:GetClass()=="prop_ragdoll")then
			self.CarryPos=ent:WorldToLocal(pos)
		else
			self.CarryPos=nil
		end
		ent.LastCarrier=self.Owner
	else
		if IsValid(self.CarryEnt) then
			self.CarryEnt.Carrier=nil
		end
		self.CarryEnt = nil
		self.CarryBone = nil
		self.CarryPos = nil
		self.CarryDist=nil
	end
end

function SWEP:CheckPulse(ply)
	if not(ply.fleshy) then return end
	if self.NextPulseCheck>=CurTime() then return end
	local owner=ply:GetRagdollOwner()
	local name=ply:GetNWString("bystanderName")
	self.NextPulseCheck=CurTime()+1
	local pulse
	if not(ply.Hostage) then
		if not(IsValid(owner)) then
			self.Owner:PrintMessage(HUD_PRINTTALK,""..name.." has no pulse.")
			return
		end
		if(string.find(owner:GetNWString("Bodyvest"),"Combine")) then
			self.Owner:PrintMessage(HUD_PRINTTALK,""..name.."'s armor is too thick to feel the pulse.")
			return
		end
		if not(owner:Alive()) or (owner.Role=="killer" and GAMEMODE.Mode=="Zombie") then
			self.Owner:PrintMessage(HUD_PRINTTALK,""..name.." has no pulse.")
			return
		end
		if owner.LifeID!=ply.LifeID or owner.Pulse<40 then
			self.Owner:PrintMessage(HUD_PRINTTALK,""..name.." has no pulse.")
			return
		end
		pulse=owner.Pulse
	else
		pulse=ply:Health()
		if pulse<=0 then
			self.Owner:PrintMessage(HUD_PRINTTALK,""..name.." has no pulse.")
			return
		end
	end
	if pulse>=60 and pulse<=90 then
		self.Owner:PrintMessage(HUD_PRINTTALK,""..name.." has a normal pulse.")
		return
	elseif pulse<60 then
		self.Owner:PrintMessage(HUD_PRINTTALK,""..name.." has a low pulse.")
		return
	elseif pulse>90 and pulse<120 then
		self.Owner:PrintMessage(HUD_PRINTTALK,""..name.." has a strong pulse.")
		return
	else
		self.Owner:PrintMessage(HUD_PRINTTALK,""..name.." has a very strong pulse.")
		return
	end
end

function SWEP:Think()
	if((IsValid(self.Owner))and(self.Owner:KeyDown(IN_ATTACK2))and not(self:GetFists()))then
		if IsValid(self.CarryEnt) and not(IsValid(self.Owner:GetGroundEntity()) and self.Owner:GetGroundEntity()==self.CarryEnt) then
			self:ApplyForce()
		end
	elseif self.CarryEnt then
		self:SetCarrying()
	end
	if((self:GetFists())and(self.Owner:KeyDown(IN_ATTACK2))) then
		self:SetNextPrimaryFire(CurTime()+.1)
		self:SetBlocking(true)
	else
		self:SetBlocking(false)
	end
	local HoldType="fist"
	if(self:GetFists())then
		HoldType="fist"
		local Time=CurTime()
		if(self:GetNextIdle()<Time)then
			self:DoBFSAnimation("fists_idle_0"..math.random(1,2))
			self:UpdateNextIdle()
		end
		if(self:GetBlocking())then
			self:SetNextDown(Time+1)
			HoldType="camera"
		end
		if((self:GetNextDown()<Time)or(self.Owner:KeyDown(IN_SPEED)))then
			self:SetNextDown(Time+1)
			self:SetFists(false)
			self.DangerLevel=0
			self:SetBlocking(false)
		end
	else
		HoldType="normal"
		self:DoBFSAnimation("fists_draw")
	end
	if((IsValid(self.CarryEnt))or(self.CarryEnt))then
		HoldType="magic"
	end
	if(self.Owner:KeyDown(IN_SPEED))then HoldType="normal" end
	if(SERVER)then
		if self.Owner:KeyDown(IN_RELOAD) and self.HandBones and (self.HandBones[1]==self.CarryBone or self.HandBones[2]==self.CarryBone) then
			self:CheckPulse(self.CarryEnt)
		end
		self:SetHoldType(HoldType)
	end
end

function SWEP:PrimaryAttack()
	local vehicle=self.Owner:GetVehicle()
	if IsValid(vehicle) and IsValid(vehicle:GetParent()) and vehicle:GetParent().Base=="lunasflightschool_basescript_heli" then return end
	if(self.Owner.fakeragdoll) then return end
	if(self.Owner:KeyDown(IN_ATTACK2)) then
		if IsValid(self.CarryEnt) then
			local owner=self.CarryEnt:GetRagdollOwner()
			if IsValid(self.CarryEnt) and HMCD_GetRagdollHitgroup(self.CarryEnt,self.CarryBone)==2 and IsValid(owner) and owner.DrownTime then
				local Tr=util.QuickTrace(self.CarryEnt:GetPos(),vector_up*-10,{self.CarryEnt,self.Owner})
				if not(self.CarryEnt.NextPump) then self.CarryEnt.NextPump=0 end
				if Tr.Hit and self.CarryEnt.NextPump<CurTime() then
					local phys = self.CarryEnt:GetPhysicsObjectNum(self.CarryBone)
					if not(self.CarryEnt.Pumps) then self.CarryEnt.Pumps=0 self.CarryEnt.PumpsRequired=math.random(20,30) end
					self.CarryEnt.Pumps=self.CarryEnt.Pumps+1
					phys:ApplyForceCenter(Vector(0,0,-5000))
					if self.CarryEnt.Pumps>=self.CarryEnt.PumpsRequired and not((owner.DigestedContents["RightLung_BloodLevel"] or 0) + (owner.DigestedContents["LeftLung_BloodLevel"] or 0) == 90) then
						owner.DrownTime=nil
						owner.HeartAttack=nil
						owner.NextAgonalMoan=nil
						if owner:CanWakeUp() then
							owner:SetUnconscious(false)
						end
						self.CarryEnt.Pumps=nil
						self.CarryEnt.PumpsRequired=nil
					end
					self.CarryEnt.NextPump=CurTime()+0.5
				end
			end
		end
		return 
	end
	local side="fists_left"
	if(math.random(1,2)==1)then side="fists_right" end
	self:SetNextDown(CurTime()+7)
	if not(self:GetFists())then
		self:SetFists(true)
		self.DangerLevel=40
		self:DoBFSAnimation("fists_draw")
		self:SetNextPrimaryFire(CurTime()+.35)
		return
	end
	if(self:GetBlocking())then return end
	if not(self.Owner.Stamina)then return end
	if(self.Owner.Stamina<5)then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	if not(IsFirstTimePredicted())then
		self:DoBFSAnimation(side)
		self.Owner:GetViewModel():SetPlaybackRate(1.25)
		return
	end
	self.Owner:ViewPunch(Angle(0,0,math.random(-2,2)))
	self:DoBFSAnimation(side)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:GetViewModel():SetPlaybackRate(1.25)
	self:UpdateNextIdle()
	if(SERVER)then
		self.Owner:ApplyStamina(-4)
		sound.Play("weapons/slam/throw.wav",self:GetPos(),65,math.random(90,110))
		self.Owner:ViewPunch(Angle(0,0,math.random(-2,2)))
		timer.Simple(.075,function()
			if(IsValid(self))then
				self:AttackFront()
			end
		end)
	end
	self:SetNextPrimaryFire(CurTime()+.35)
	self:SetNextSecondaryFire(CurTime()+.35)
end

--[[
SWEP.MinDamage=2
SWEP.MaxDamage=4
SWEP.DamageType=DMG_CLUB
SWEP.DamageForceDiv=1
SWEP.ForceOffset=500
SWEP.Force=500
SWEP.SoftImpactSounds={
	{"Flesh.ImpactSoft",0,65,{90,110}}
}
SWEP.HardImpactSounds={
	{"Flesh.ImpactSoft",0,65,{90,110}}
}
]]

function SWEP:AttackFront()
	if(CLIENT)then return end
	self.Owner:LagCompensation(true)
	local Ent,HitPos,HitNorm,Hitbox=HMCD_WhomILookinAt(self.Owner,.3,55)
	local AimVec=self.Owner:GetAimVector()
	if((IsValid(Ent))or((Ent)and(Ent.IsWorld)and(Ent:IsWorld())))then
		local owner=Ent
		if IsValid(Ent:GetRagdollOwner()) and Ent:GetRagdollOwner():IsPlayer() and Ent:GetRagdollOwner():Alive() then owner=Ent:GetRagdollOwner() end
		if Ent:GetClass()=="prop_ragdoll" then
			local Tr=util.QuickTrace(self.Owner:GetShootPos(),self.Owner:GetAimVector()*self.ReachDistance,{self.Owner})
			Hitbox=HMCD_GetRagdollHitgroup(Ent,Tr.PhysicsBone)
		end
		local SelfForce,Mul=125,1
		if(self:IsEntSoft(Ent))then
			SelfForce=25
			if((Ent:IsPlayer())and(IsValid(Ent:GetActiveWeapon()))and(Ent:GetActiveWeapon().GetBlocking)and(Ent:GetActiveWeapon():GetBlocking()))then
				local pos,ang=Ent:GetBonePosition(Ent:LookupBone("ValveBiped.Bip01_R_Hand"))
				ang:RotateAroundAxis(ang:Right(),90)
				if util.IntersectRayWithOBB( self.Owner:GetShootPos(), self.Owner:GetAimVector()*self.ReachDistance, pos+ang:Right()*5, ang, Vector(-10,-10,-7), Vector(10,10,7) )!= nil then
					sound.Play("Flesh.ImpactSoft",HitPos,65,math.random(90,110))
					Mul=Mul*0.2
					local pos_l=Ent:GetBonePosition(Ent:LookupBone("ValveBiped.Bip01_L_Hand"))
					local startpos=self.Owner:GetShootPos()+self.Owner:GetAimVector()*3
					if startpos:DistToSqr(pos_l)>startpos:DistToSqr(pos) then Hitbox=HITGROUP_RIGHTARM else Hitbox=HITGROUP_LEFTARM end
				else
					sound.Play("Flesh.ImpactHard",HitPos,65,math.random(90,110))
				end
			else
				sound.Play("Flesh.ImpactHard",HitPos,65,math.random(90,110))
			end
		else
			sound.Play("Flesh.ImpactSoft",HitPos,65,math.random(90,110))
		end
		local DamageAmt=math.random(2,4)
		if self.Owner.Role=="terminator" then Mul=Mul*10 end
		local Dam=DamageInfo()
		Dam:SetAttacker(self.Owner)
		Dam:SetInflictor(self.Weapon)
		Dam:SetDamage(DamageAmt*Mul)
		Dam:SetDamageForce(AimVec*Mul^3)
		Dam:SetDamageType(DMG_CLUB)
		Dam:SetDamagePosition(HitPos)
		if owner:IsPlayer() or owner:IsRagdoll() or owner:IsNPC() then
			GAMEMODE:ScalePlayerDamage(owner,Hitbox,Dam)
		end
		Dam:SetDamage(math.Clamp(Dam:GetDamage(),0,DamageAmt))
		Ent:TakeDamageInfo(Dam)
		local Phys=Ent:GetPhysicsObject()
		if(IsValid(Phys))then
			if(Ent:IsPlayer())then Ent:SetVelocity(AimVec*SelfForce*1.5) end
			Phys:ApplyForceOffset(AimVec*5000*Mul,HitPos)
			self.Owner:SetVelocity(AimVec*SelfForce*.8)
		end
		if(Ent:GetClass()=="func_breakable_surf")then
			if(math.random(1,20/Mul)==1)then 
				if not(self.Owner.Role=="combine") then
					if (Ent.Poisoned or Ent.ContactPoisoned) then
						HMCD_Poison(self.Owner,Ent.Poisoner,"VX")
					end
					if not(self.Owner.Bleedout) then self.Owner.Bleedout=0 end
					self.Owner.Bleedout=self.Owner.Bleedout+2
				end
				Ent:Fire("break","",0)
			end
		end
		
		if self.Owner.Role=="terminator" then

			if((IsValid(Ent))and(HMCD_IsDoor(Ent))and not(Ent:GetNoDraw() or Ent.Unbreakable))then
				HMCD_BlastThatDoor(Ent,(Ent:GetPos()-self:GetPos()):GetNormalized()*3000)
			elseif(Ent:GetClass()=="func_breakable")then
				Ent:Fire("break","",0)
			end
			
			local Constraints=constraint.FindConstraints(Ent,"Rope")
			if(Constraints)then
				local Const=table.Random(Constraints)
				if((Const)and(Const.Constraint))then
					Const.Constraint:Remove()
					sound.Play("Wood_Furniture.Break",Ent:GetPos(),60,100)
				end
			end
		
		end
		

	end
	self.Owner:LagCompensation(false)
end

function SWEP:Reload()
	if not(IsFirstTimePredicted())then return end
	self:SetFists(false)
	self.DangerLevel=0
	self:SetBlocking(false)
end

function SWEP:DrawWorldModel()
	-- no, do nothing
end

function SWEP:DoBFSAnimation(anim)
	local vm=self.Owner:GetViewModel()
	if IsValid(vm) then
		vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
	end
end

function SWEP:UpdateNextIdle()
	local vm=self.Owner:GetViewModel()
	if IsValid(self) and IsValid(vm) then
		self:SetNextIdle(CurTime()+vm:SequenceDuration())
	end
end

function SWEP:IsEntSoft(ent)
	return ent:IsNPC() or ent:IsPlayer() or (ent:IsRagdoll() and ent.fleshy)
end

if(CLIENT)then
	local BlockAmt=0
	function SWEP:GetViewModelPosition(pos,ang)
		if(self:GetBlocking())then
			BlockAmt=math.Clamp(BlockAmt+FrameTime()*1.5,0,1)
		else
			BlockAmt=math.Clamp(BlockAmt-FrameTime()*1.5,0,1)
		end
		pos=pos-ang:Up()*15*BlockAmt
		ang:RotateAroundAxis(ang:Right(),BlockAmt*60)
		return pos,ang
	end
end