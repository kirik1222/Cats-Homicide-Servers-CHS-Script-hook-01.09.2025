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
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_zombhands")
	SWEP.BounceWeaponIcon=false
end

SWEP.SwayScale=3
SWEP.BobScale=3

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "These are your zombified hands. They're no energy sword, but they still pack a wallop.\n\nLMB to clobber.\nRMB to direct fellow zombies (as an alpha zombie).\nRMB to grab a person standing in front of you. (as a regular zombie).\nRMB while in mid-air and facing a wall to cling to it (as an alpha zombie).\nRELOAD to recall fellow zombies (as an alpha zombie).\nRELOAD to dash (as a regular zombie)."

SWEP.Spawnable			= false
SWEP.AdminOnly		= true

SWEP.HoldType = "normal"

SWEP.ViewModel	= Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel	= "models/weapons/w_crowbar.mdl"

SWEP.AttackSlowDown=.1

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
SWEP.NextAnim=0

SWEP.NextClimbSound = 0
SWEP.Rate = 1
SWEP.Base="wep_jack_hmcd_melee_base"
SWEP.DamageForceDiv=5
SWEP.ForceOffset=4500
SWEP.DangerLevel=100
SWEP.Infected=true
SWEP.NextHoldCheck=0

function SWEP:SetupDataTables()
	self:NetworkVar("Float",0,"NextIdle")
end

function SWEP:PreDrawViewModel(vm,wep,ply)
	--vm:SetMaterial("engine/occlusionproxy") -- Hide that view model with hacky material
end

function SWEP:Initialize()
	if SERVER then
		self.OldMinDamage=self.MinDamage
		self.OldMaxDamage=self.MaxDamage
		self.OldReachDistance=self.ReachDistance
		self.MinDamage=self.MinDamage*((GAMEMODE.ZombieMutations["Shambler"] or 0)/2+1)
		self.MaxDamage=self.MaxDamage*((GAMEMODE.ZombieMutations["Shambler"] or 0)/2+1)
		self.ReachDistance=self.ReachDistance*((GAMEMODE.ZombieMutations["Shambler"] or 0)/6+1)
		if GAMEMODE.ZombieMutations["Shambler"] then
			timer.Simple(0.1,function()
				if IsValid(self) and IsValid(self.Owner) then
					local ind=self:EntIndex()
					self.Owner:SendLua("Entity("..ind.."):LengthenClaws("..GAMEMODE.ZombieMutations["Shambler"]..")")
				end
			end)
		end
	end
	self:SetNextIdle(CurTime()+5)
	self:SetHoldType(self.HoldType)
	self:SetClimbing(false)
end

function SWEP:Deploy()
	if self.ClawsLength then
		self:LengthenClaws(self.ClawsLength)
	end
	self:SetNextPrimaryFire(CurTime()+.1)
	return true
end

function SWEP:Holster()
	self:OnRemove()
	if CLIENT then
		local vm=self.Owner:GetViewModel()
		if IsValid(vm) then
			for i=9,20 do
				vm:ManipulateBonePosition(i,Vector(0,0,0))
			end
			for i=25,36 do
				vm:ManipulateBonePosition(i,Vector(0,0,0))
			end
		end
	end
	return true
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PlayHitSound()
	self.Owner:EmitSound("npc/zombie/claw_strike"..math.random(3)..".wav")
end

function SWEP:PlayHitObjectSound()
	sound.Play("Flesh.ImpactHard",self:GetPos(),65,math.random(90,110))
end

function SWEP:PlayMissSound()
	self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(2)..".wav")
end

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("npc/zombie/zo_attack"..math.random(2)..".wav")
end

function SWEP:PlayIdleSound()
	self.Owner:EmitSound("npc/zombie/zombie_voice_idle"..math.random(14)..".wav")
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("npc/zombie/zombie_alert"..math.random(3)..".wav")
end

function SWEP:SecondaryAttack()
	if self.Owner.fake then return end
	if self.Owner.ZombieMaster then
		if self:GetClimbSurface() and not(self:NearGround())then
			self:StartClimbing()
		elseif SERVER then
			local Zombs=self:GetZombies()
			table.insert(Zombs,self.Owner)
			local Tr=util.QuickTrace(self.Owner:GetShootPos(),self.Owner:GetAimVector()*3000,Zombs)
			if(Tr.Hit)then
				self:PlayAlertSound()
				self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_POINT)
				self:DirectZombies(Tr.HitPos+Tr.HitNormal*10,Zombs,Tr.Entity)
				self:SetNextPrimaryFire(CurTime()+1)
				self:SetNextSecondaryFire(CurTime()+2)
			end
		end
	elseif SERVER then
		if IsValid(self:GetHolding()) then
			self:SetHolding()
		else
			local tr=util.QuickTrace(self.Owner:GetShootPos(),self.Owner:GetAimVector()*65,self.Owner)
			if IsValid(tr.Entity) then
				if tr.Entity:IsPlayer() and math.abs(tr.Entity:GetPos().z-self.Owner:GetPos().z)<35 and not(tr.Entity:GetNWBool("ZombieHeld")) then
					local wep=tr.Entity:GetActiveWeapon()
					if not(IsValid(wep) and wep.GetHolding and IsValid(wep:GetHolding())) then
						self:SetHolding(tr.Entity)
						tr.Entity.lastRagdollEndTime=CurTime()+360
						self:SetNextPrimaryFire(CurTime()+1)
						self:SetNextSecondaryFire(CurTime()+2)
					end
				elseif tr.Entity:IsRagdoll() and tr.Entity.fleshy and ((tr.Entity.BitsEaten or 0)<10 or (IsValid(tr.Entity:GetRagdollOwner()) and tr.Entity:GetRagdollOwner():Alive())) and not(string.find(tr.Entity:GetModel(),"zomb")) then
					local infoList={}
					local curVest,curHelmet,curMask=tr.Entity:GetNWString("Bodyvest"),tr.Entity:GetNWString("Helmet"),tr.Entity:GetNWString("Mask")
					local hitgroup=HMCD_GetRagdollHitgroup(tr.Entity,tr.PhysicsBone)
					if HMCD_ArmorProtection[curVest] and HMCD_ArmorProtection[curVest][hitgroup] then 
						table.insert(infoList,HMCD_ArmorProtection[curVest][hitgroup])
					end
					if HMCD_ArmorProtection[curHelmet] and HMCD_ArmorProtection[curHelmet][hitgroup] then
						table.insert(infoList,HMCD_ArmorProtection[curHelmet][hitgroup])
					end
					if HMCD_ArmorProtection[curMask] and HMCD_ArmorProtection[curMask][hitgroup] then
						table.insert(infoList,HMCD_ArmorProtection[curMask][hitgroup])
					end
					local armorHit
					if #infoList>0 then
						armorHit=true
						for i,info in pairs(infoList) do
							if info[3] then
								if istable(info[3][1]) then
									for i,inf in pairs(info[3]) do
										armorHit=HMCD_CheckArmor(tr.Entity,self.Owner:GetShootPos(),tr.HitPos,inf)
										if armorHit then break end
									end
								else
									armorHit=HMCD_CheckArmor(tr.Entity,self.Owner:GetShootPos(),tr.HitPos,info[3])
								end
							end
						end
					end
					if armorHit then self:SetNextSecondaryFire(CurTime()+1) return end
					if not(tr.Entity.BitsEaten) then tr.Entity.BitsEaten=0 end
					if not(self.Owner.EatCount) then self.Owner.EatCount=0 end
					self.Owner.EatCount=self.Owner.EatCount+1
					for i=9,11 do
						self.Owner:ManipulateBoneScale(i,Vector(1,1,math.min((self.Owner.EatCount+89)/90,1.75)))
					end
					tr.Entity.BitsEaten=tr.Entity.BitsEaten+1
					local master
					for j,ply in pairs(player.GetAll()) do
						if ply.ZombieMaster then master=ply break end
					end
					if master then
						net.Start("hmcd_zombie_points")
						net.WriteInt(5,13)
						net.Send(master)
						if tr.Entity.BitsEaten==10 then
							master.MutationPoints=master.MutationPoints+1
							net.Start("hmcd_mutation_points")
							net.WriteInt(master.MutationPoints,13)
							net.Send(master)
						end
					end
					SuppressHostEvents(NULL)
					local eateff = EffectData()
					eateff:SetEntity(tr.Entity)
					eateff:SetOrigin(tr.HitPos)
					eateff:SetNormal(tr.HitPos)
					util.Effect("BloodImpact", eateff)
					SuppressHostEvents(self.Owner)
					tr.Entity:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav")
					self:SetNextSecondaryFire(CurTime()+1)
					--zomb:PlayScene("scenes/eat_corpse.vcd")
					local owner=tr.Entity:GetRagdollOwner()
					if IsValid(owner) and owner:Alive() then
						owner:SetHealth(owner:Health()-math.random(5,7))
						local mul=(GAMEMODE.ZombieMutations["Blood"] or 0)/2
						if mul>0 then
							owner:AddBacteria(35*mul,CurTime())
						end
						owner:ApplyPain(25)
						self.Owner:SetHealth(math.Clamp(self.Owner:Health()+math.random(5,7),0,300))
						owner.Bleedout=owner.Bleedout+10
						if owner:Health()<=0 then
							owner.LastDamageType=HMCD_DamageTypes[DMG_SLASH]
							owner.LastAttacker=self.Owner
							owner.LastAttackerName=self.Owner.BystanderName
							owner:Kill()
						end
					else
						if not(tr.Entity.Bleedout) then tr.Entity.Bleedout=0 end
						tr.Entity.Bleedout=tr.Entity.Bleedout+10
					end
				end
			end
		end
	end
end

function SWEP:StartClimbing()
	if self:GetClimbing() then return end

	self:SetClimbing(true)

	self:SetNextSecondaryFire(CurTime() + 0.5)
end

function SWEP:StopClimbing()
	if not self:GetClimbing() then return end

	self:SetClimbing(false)

	self:SetNextSecondaryFire(CurTime())
end

function SWEP:SetClimbing(climbing)
	self:SetDTBool(1, climbing)
end

function SWEP:GetClimbing()
	return self:GetDTBool(1)
end

function SWEP:SetDashing(dashing)
	self:SetDTBool(2, dashing)
end

function SWEP:GetDashing()
	return self:GetDTBool(2)
end

function SWEP:SetHolding(ent)
	local prevHeld=self:GetHolding()
	if IsValid(prevHeld) then
		prevHeld.lastRagdollEndTime=0
		prevHeld:SetNWBool("ZombieHeld",false)
		prevHeld:SetDuckSpeed(prevHeld.PreviousDuckSpeed)
		prevHeld.PreviousDuckSpeed=nil
		if prevHeld.JumpPower then
			prevHeld.JumpPower=nil
		else
			prevHeld:SetJumpPower(prevHeld.OldJumpPower)
			prevHeld.OldJumpPower=nil
		end
		self.Owner:SetJumpPower(self.Owner.OldJumpPower)
		self.Owner.OldJumpPower=nil
		self.Owner:SetDuckSpeed(self.Owner.PreviousDuckSpeed)
		self.Owner.PreviousDuckSpeed=nil
	end
	self:SetDTEntity(1,ent)
	if IsValid(ent) then
		ent.PreviousDuckSpeed=ent:GetDuckSpeed()
		ent:SetDuckSpeed(500)
		if not(ent.Role=="killer") then
			ent.JumpPower=0
		else
			ent.OldJumpPower=ent:GetJumpPower()
			ent:SetJumpPower(0)
		end
		self.Owner.PreviousDuckSpeed=self.Owner:GetDuckSpeed()
		self.Owner:SetDuckSpeed(500)
		self.Owner.OldJumpPower=self.Owner:GetJumpPower()
		self.Owner:SetJumpPower(0)
		ent:SetNWBool("ZombieHeld",true)
	end
end

function SWEP:GetHolding()
	return self:GetDTEntity(1)
end

SWEP.IsClimbing = SWEP.GetClimbing

function SWEP:OnRemove()
	if(IsValid(self.Owner) && CLIENT && self.Owner:IsPlayer())then
		local vm=self.Owner:GetViewModel()
		if(IsValid(vm)) then 
			for i=9,20 do
				vm:ManipulateBonePosition(i,Vector(0,0,0))
			end
			for i=25,36 do
				vm:ManipulateBonePosition(i,Vector(0,0,0))
			end
		end
	end
	if SERVER then self:SetHolding() end
end

local meta = FindMetaTable("Player")
local climbtrace = {mask = MASK_SOLID_BRUSHONLY, mins = Vector(-5, -5, -5), maxs = Vector(5, 5, 5)}

function SWEP:GetClimbSurface()
	local owner = self:GetOwner()

	local fwd = owner:SyncAngles():Forward()
	local up = owner:GetUp()
	local pos = owner:GetPos()
	local height = owner:OBBMaxs().z
	local tr
	local ha
	for i=5, height, 5 do
		if not tr or not tr.Hit then
			climbtrace.start = pos + up * i
			climbtrace.endpos = climbtrace.start + fwd * 36
			tr = util.TraceHull(climbtrace)
			ha = i
			if tr.Hit and not tr.HitSky then break end
		end
	end

	if tr.Hit and not tr.HitSky then
		climbtrace.start = pos + up * ha --tr.HitPos + tr.HitNormal
		climbtrace.endpos = climbtrace.start + owner:SyncAngles():Up() * (height - ha)
		local tr2 = util.TraceHull(climbtrace)
		if tr2.Hit and not tr2.HitSky then
			return tr2
		end

		return tr
	end
end
function SWEP:NearGround()
	return util.QuickTrace(self:GetPos()+vector_up*-20,-vector_up*-20,{self}).Hit
end
function meta:SyncAngles()
	local ang = self:EyeAngles()
	ang.pitch = 0
	ang.roll = 0
	return ang
end
meta.GetAngles = meta.SyncAngles
function SWEP:PlayClimbSound()
	self:EmitSound("player/footsteps/metalgrate"..math.random(4)..".wav")
end
function SWEP:Think()
	local HoldType="fist"
	local Time=CurTime()
	local owner=self.Owner
	local seq = owner:SelectWeightedSequence( ACT_ZOMBIE_CLIMB_UP )
	local rate = 0
	local vel = self.Owner:GetVelocity()
	local speed = vel:LengthSqr()
	if(self:GetNextIdle()<Time)then
		self:SendWeaponAnim(ACT_VM_IDLE)
		self:UpdateNextIdle()
	end
	if(SERVER)then 
		self:SetHoldType(HoldType)
		if self.NextHoldCheck<Time then
			self.NextHoldCheck=Time+.1
			local heldEnt=self:GetHolding()
			if IsValid(heldEnt) and (self.Owner.fake or heldEnt.fake or self.Owner:GetPos():DistToSqr(heldEnt:GetPos())>5500) then
				self:SetHolding()
			end
		end
	end
	if self:GetClimbing() then
		--self.Owner:DoAnimationEvent(ACT_ZOMBIE_CLIMB_UP)
		if self:GetClimbSurface() and owner:KeyDown(IN_ATTACK2) then
			if Time >= self.NextClimbSound and IsFirstTimePredicted() then
				local speed = owner:GetVelocity():LengthSqr()
				if speed >= 2500 then
					if speed >= 12000 then
						self.NextClimbSound = Time + 0.25
					else
						self.NextClimbSound = Time + 0.8
					end
					self:PlayClimbSound()
				end
			end
			if Time >= self.NextAnim then
				self.NextAnim = Time + self.Owner:SequenceDuration( seq )
			end
		else
			self:StopClimbing()
		end
	end
	self:Move(self.Owner)
end

SWEP.AttackFrontDelay=.65
SWEP.AttackPlayback=1
SWEP.AttackDelay=1.5

function SWEP:PrimaryAttack()
	if self.Owner.fake then return end
	local side=ACT_VM_HITCENTER
	if(math.random(1,2)==1)then side=ACT_VM_SECONDARYATTACK end
	if not(IsFirstTimePredicted())then
		self:SendWeaponAnim(side)
		return
	end
	local div=1
	if self.Owner:GetNWString("Class")=="torso" then div=2 end
	self.Owner:ViewPunch(Angle(0,0,math.random(-2,2)))
	self:SendWeaponAnim(side)
	self.Owner:GetViewModel():SetPlaybackRate(self.AttackPlayback*div)
	self:UpdateNextIdle()
	self.Owner:DoAttackEvent()
	if(SERVER)then self:PlayAttackSound() end
	if(SERVER)then
		timer.Simple(self.AttackFrontDelay/div,function()
			if(IsValid(self))then
				self:AttackFront()
			end
		end)
	end
	self:SetNextPrimaryFire(CurTime()+self.AttackDelay/div)
	self:SetNextSecondaryFire(CurTime()+1)
end

SWEP.MinDamage=15
SWEP.MaxDamage=25
SWEP.DamageType=DMG_SLASH
SWEP.Force=50
SWEP.BloodDecals=1
SWEP.CanBreakDoors=true
SWEP.BreakDoorChance=10
SWEP.NotLoot=true
SWEP.NextDash=0
SWEP.NextReload=0

local ZombTypes={"npc_zombie","npc_zombie_torso","npc_fastzombie","npc_fastzombie_torso","npc_poisonzombie","npc_zombine"}

function SWEP:GetZombies()
	local Result={}
	for i,typ in pairs(ZombTypes) do
		for j,npc in pairs(ents.FindByClass(typ)) do
			table.insert(Result,npc)
		end
	end
	return Result
end

function SWEP:Reload()
	if self.Owner.fake or self.Owner:GetNWString("Class")=="torso" then return end
	if(self.NextReload>CurTime())then return end
	self.NextReload=CurTime()+2
	if(SERVER)then
		if self.Owner.ZombieMaster then
			self:SetNextPrimaryFire(CurTime()+2)
			self:SetNextSecondaryFire(CurTime()+2)
			local Zombs=self:GetZombies()
			table.insert(Zombs,self.Owner)
			self:PlayIdleSound()
			self.Owner:DoAnimationEvent(ACT_SIGNAL_GROUP)
			self:DirectZombies(self.Owner:GetShootPos(),Zombs)
		elseif self.NextDash<CurTime() then
			self.NextDash=CurTime()+10
			self:SetDashing(true)
			local owner=self.Owner
			local lifeID=owner.LifeID
			local speedMul=(GAMEMODE.ZombieMutations["Shambler"] or 0)/2 + 1
			owner:SetWalkSpeed(100*speedMul)
			owner:SetMaxSpeed(100*speedMul)
			owner:SetRunSpeed(100*speedMul)
			owner:SetJumpPower(200)
			owner:SetSlowWalkSpeed(100*speedMul)
			timer.Simple(5,function()
				if IsValid(owner) and owner:Alive() and owner.LifeID==lifeID then
					owner:SetWalkSpeed(50)
					owner:SetMaxSpeed(50)
					owner:SetRunSpeed(50)
					owner:SetJumpPower(150)
					owner:SetSlowWalkSpeed(50)
					self:SetDashing(false)
				end
			end)
		end
	end
end

function SWEP:DrawWorldModel()
	-- no, do nothing
end

function SWEP:DirectZombies(pos,zombs,attackprop)
	local SelfPos=self.Owner:GetShootPos()
	for key,npc in pairs(ents.FindInSphere(pos,2000))do
		if(npc.HMCD_Zomb)then
			local NPCPos=npc:GetPos()
			local Tr=util.TraceLine({start=SelfPos,endpos=NPCPos+Vector(0,0,20),filter=zombs})
			if not(Tr.Hit)then
				local Vec=(pos-NPCPos):GetNormalized()
				if(math.random(1,3)==2)then
					npc:SetLastPosition(NPCPos+Vec*400)
				else
					npc:SetLastPosition(pos)
				end
				npc:SetSchedule(SCHED_FORCED_GO_RUN)
				npc.PropToAttack=attackprop
			end
		end
	end
end

function SWEP:UpdateNextIdle()
	local vm=self.Owner:GetViewModel()
	self:SetNextIdle(CurTime()+vm:SequenceDuration())
end

function SWEP:IsEntSoft(ent)
	return ((ent:IsNPC())or(ent:IsPlayer())or(ent:GetClass()=="prop_ragdoll" and ent.fleshy))
end
local climblerp = 0
local forwardMul=0
if(CLIENT)then
	local BlockAmt=0
	function SWEP:GetViewModelPosition(pos,ang)
		BlockAmt=math.Clamp(BlockAmt-FrameTime()*1.5,0,1)
		pos=pos-ang:Up()*15*BlockAmt
		ang:RotateAroundAxis(ang:Right(),BlockAmt*60)
		climblerp = math.Approach(climblerp, self:IsClimbing() and 1 or 0, FrameTime() * ((climblerp + 1) ^ 3))
		forwardMul = math.Approach(forwardMul, IsValid(self:GetHolding()) and 1 or 0, FrameTime() * ((forwardMul + 1) ^ 3))
		ang:RotateAroundAxis(ang:Right(), 64 * climblerp)
		if climblerp > 0 then
			pos = pos + -8 * climblerp * ang:Up() + -12 * climblerp * ang:Forward() 
		end
		if forwardMul>0 then
			pos = pos + ang:Forward()*forwardMul*15
		end
		return pos,ang
	end
	function SWEP:LengthenClaws(amt)
		self.ClawsLength=amt
		local vm=self.Owner:GetViewModel()
		for i=9,20 do
			vm:ManipulateBonePosition(i,Vector(amt*2,0,0))
		end
		for i=25,36 do
			vm:ManipulateBonePosition(i,Vector(amt*2,0,0))
		end
	end
end
function SWEP:Move(mv)
	if self:GetClimbing() and not(self:NearGround()) then
		mv:SetMaxSpeed(0)
		--mv:SetMaxClientSpeed(0)

		local owner = self:GetOwner()
		local tr = self:GetClimbSurface()
		local angs = owner:SyncAngles()
		local dir = tr and tr.Hit and (tr.HitNormal.z <= -0.5 and (angs:Forward() * -1) or math.abs(tr.HitNormal.z) < 0.75 and tr.HitNormal:Angle():Up()) or Vector(0, 0, 1)
		local vel = Vector(0, 0, 4)

		if owner:KeyDown(IN_FORWARD) then
			owner:SetGroundEntity(nil)
			vel = vel + dir * 250 --160
		end
		if owner:KeyDown(IN_BACK) then
			vel = vel + dir * -250 ---160
		end

		if vel.z == 4 then
			if owner:KeyDown(IN_MOVERIGHT) then
				vel = vel + angs:Right() * 100 --60
			end
			if owner:KeyDown(IN_MOVELEFT) then
				vel = vel + angs:Right() * -100 ---60
			end
		end

		mv:SetLocalVelocity(vel)

		return true
	end
end