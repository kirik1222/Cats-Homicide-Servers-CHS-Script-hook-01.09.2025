if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	SWEP.ViewModelFOV = 75

	SWEP.Slot = 1
	SWEP.SlotPos = 1

	killicon.AddFont("wep_zac_hmcd_policebaton", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))

	function SWEP:Initialize()
		--wat
	end

	function SWEP:DrawViewModel()	
		return false
	end

	function SWEP:DrawWorldModel()	
		self:DrawModel()
	end

	function SWEP:DrawHUD()
		--
	end
end

SWEP.Base="weapon_base"

SWEP.ViewModel = "models/mu_hmcd_mansion/weapon_cuestick/v_cuestick.mdl"
SWEP.WorldModel = "models/mu_hmcd_mansion/weapon_cuestick/w_cuestick.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_hmcd_mansion_cuestick");SWEP.BounceWeaponIcon=false end
SWEP.PrintName = "Cue Stick"
SWEP.Instructions	= "This is a 59 inches long stick, item of sporting equipment essential to the games of pool, snooker and carom billiards.\n\nLMB to hit\nRMB to aim\nE+RMB to adjust hit force\nRELOAD to reset hit force\nHit force reseting to 1000 with hit or redeploying."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=3
SWEP.SwayScale=3
SWEP.Weight	= 3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false
SWEP.DangerLevel=60

SWEP.AimPos=Vector(1, 0, 4)
SWEP.AimAng=Angle(2.97, -0.26, 4)
SWEP.AimTime=5
SWEP.BearTime=9
SWEP.FuckedWorldModel=true
SWEP.AttackSlowDown=0.75

SWEP.Spawnable			= true
SWEP.AdminOnly			= true

SWEP.Primary.Delay			= 1
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 120
SWEP.Primary.NumShots		= 1	
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Force			= 900
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic   	= true
SWEP.Primary.Ammo         	= "none"

SWEP.NextCheck=1
SWEP.CommandDroppable=true
SWEP.AimHoldType="ar2"
SWEP.HipHoldType="shotgun"
SWEP.DownHoldType="passive"
SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"
SWEP.HomicideSWEP=true
SWEP.CarryWeight=1000
SWEP.NoHolster=true
--SWEP.HolsterSlot=1
--SWEP.HolsterPos=Vector(5,-5,3)
--SWEP.HolsterAng=Angle(0,90,90)
SWEP.DeathDroppable=true
SWEP.Poisonable=false
SWEP.ENT="ent_hmcd_mansion_cuestick"

--THE HELL HAPPENING HERE?

function SWEP:Initialize()

	self:SetNextIdle(CurTime()+1)
		self:SetHoldType(self.HipHoldType)
		self:SetAimedC(false)
		self:SetAiming(0)
		self:SetSprinting(0)
		self.RFA=true
		self.AimedC=false
		self:SetReady(true)
		self.Power=1000
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float",0,"NextIdle")
	self:NetworkVar("Bool",2,"AimedC")
	self:NetworkVar("Bool",0,"Ready")
	self:NetworkVar("Int",0,"Aiming")
	self:NetworkVar("Int",1,"Sprinting")
	self:NetworkVar("Bool",1,"Reloading")
end

function SWEP:PrimaryAttack()
	local Ent,HitPos,HitNorm=HMCD_WhomILookinAt(self.Owner,.35,70)
	if not(IsFirstTimePredicted())then
		self.Owner:GetViewModel():SetPlaybackRate(1)
		return
	end
	if(self.Owner.Stamina<9)then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	if(self:GetAimedC()==false) then 
	self:DoBFSAnimation("stab")
	timer.Simple(.35,function()
		if(IsValid(self))then
			self:AttackFront()
		end
	end)
	else
	self:DoBFSAnimation("aim_stab")
	timer.Simple(.05,function()
		if(IsValid(self))then
			self:AttackFront()
		end
	end)
	end
	self:UpdateNextIdle()
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self:SetNextPrimaryFire(CurTime()+1)

end

function SWEP:Deploy()
	if not(IsFirstTimePredicted())then
	self:SetAimedC(false)
	self.AimedC=false
		self:DoBFSAnimation("draw")
		self.Owner:GetViewModel():SetPlaybackRate(.1)
		return
	end
	self.Power=1000
	self.AimedC=false
	self:SetAimedC(false)
	self:DoBFSAnimation("draw")
	self:UpdateNextIdle()
	if(SERVER)then sound.Play("Flesh.ImpactSoft",self.Owner:GetPos(),55,math.random(90,110)) end
	return true
end

function SWEP:SecondaryAttack()
	--
end

function SWEP:Think()
	local Time=CurTime()
	if(self:GetNextIdle()<Time)then
		if(self:GetAimedC()==true)then
		self:DoBFSAnimation("idle_aim")
		end
		if(self:GetAimedC()==false)then
		self:DoBFSAnimation("idle")
		end
		self:UpdateNextIdle()
	end
	if self.FistCanAttack && self.FistCanAttack < CurTime() then
		self.FistCanAttack = nil
		--self:SendWeaponAnim( ACT_VM_IDLE )
		self.IdleTime = CurTime() + 0.1
	end	
	if self.FistHit && self.FistHit < CurTime() then
		self.FistHit = nil
		--self:AttackTrace()
	end
	if(SERVER)then
		local HoldType="normal"
		if(self.Owner:KeyDown(IN_SPEED))then
			HoldType="normal"
		else
			HoldType="melee"
		end
		self:SetHoldType(HoldType)
	end
	
		if(SERVER)then 
		local Sprintin,Aimin,AimAmt,SprintAmt=self.Owner:KeyDown(IN_SPEED),self.Owner:KeyDown(IN_ATTACK2),self:GetAiming(),self:GetSprinting()
		--local HoldType="ar2"
		if(self.Owner:KeyDown(IN_SPEED))then
			HoldType="passive"
		end
		--self:SetHoldType(HoldType)
		if(self.Owner:KeyDown(IN_ATTACK2) and self.Owner:KeyDown(IN_USE))then
		self.Power=self.Power+10
		self.Owner:PrintMessage(HUD_PRINTCENTER,self.Power)
		if(self.Power>3000)then self.Power=1000 end
		end
		
		if(self.Owner:KeyDown(IN_ATTACK2) and self.RFA==true and self.AimedC==false)then 
		
		self:DoBFSAnimation("idle_to_aim") 
		timer.Simple(0.5,function()
		self.RFA=true
		--self.Aimed=false
		end)
		self:SetNextPrimaryFire(CurTime()+1)
		self.RFA=false
		self.AimedC=true
		self:SetAimedC(true)
		self:UpdateNextIdle()
		end 
		if(not (self.Owner:KeyDown(IN_ATTACK2)) and self.RFA==true and self.AimedC==true)then 
				self:DoBFSAnimation("aim_to_idle") 
		timer.Simple(0.5,function()
		self.RFA=true
		--self.Aimed=false
		end)
		self:SetNextPrimaryFire(CurTime()+1)
		self:UpdateNextIdle()
		self.AimedC=false
		self:SetAimedC(false)
		self.RFA=false
		end
	if(self.NextCheck<CurTime())then
		self.NextCheck=CurTime()+.1
		--if(self.AimedC)then self:UpdateNextIdle() end
		if((self.Owner:KeyDown(IN_ATTACK2))and not(self.Owner:KeyDown(IN_SPEED))and(self.Owner:OnGround()))then
			self:SetAiming(math.Clamp(self:GetAiming()+10,0,100))
		else
			self:SetAiming(math.Clamp(self:GetAiming()-10,0,100))
			--self:DoBFSAnimation("aim_to_idle")
		end
	end
		if((Aimin)and not(self.Owner:Crouching()))then
			HoldType=self.AimHoldType
		else
			HoldType=self.HipHoldType
		end
		self:SetHoldType(HoldType)
				if( Sprintin and self:GetReady())then
			self:SetSprinting(math.Clamp(SprintAmt+40*(1/(self.BearTime)),0,100))
			self:SetAiming(math.Clamp(AimAmt-40*(1/(self.AimTime)),0,100))
		elseif((Aimin)and(self.Owner:OnGround())and not((self.CycleType=="manual")and(self.LastFire+.75>CurTime())))then
			self:SetAiming(math.Clamp(AimAmt+20*(1/(self.AimTime)),0,100))
			self:SetSprinting(math.Clamp(SprintAmt-20*(1/(self.BearTime)),0,100))
		else
			self:SetAiming(math.Clamp(AimAmt-40*(1/(self.AimTime)),0,100))
			self:SetSprinting(math.Clamp(SprintAmt-20*(1/(self.BearTime)),0,100))
		end
		local HoldType=self.HipHoldType
		if(SprintAmt>90)then
			HoldType=self.DownHoldType
		elseif((Aimin)and not(self.Owner:Crouching()))then
			HoldType=self.AimHoldType
		else
			HoldType=self.HipHoldType
		end
		self:SetHoldType(HoldType)
	end
end

function SWEP:AttackFront()
--SHITCODE TIME
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	--self.Owner:ViewPunch(Angle(2,0,0))
	if(CLIENT)then return end
	self.Owner:LagCompensation(true)
	HMCD_StaminaPenalize(self.Owner,10)
	if(self:GetAimedC()==false) then 
	self.Owner:ViewPunch(Angle(2,0,0))
	Ent,HitPos,HitNorm=HMCD_WhomILookinAt(self.Owner,.15,90)
	local AimVec,Mul=self.Owner:GetAimVector(),1
	if((IsValid(Ent))or((Ent)and(Ent.IsWorld)and(Ent:IsWorld())))then
		local SelfForce=30
		local DamageAmt=math.random(13,18)
		if(self:IsEntSoft(Ent))then
			sound.Play("snd_jack_hmcd_axehit.wav",HitPos,65,math.random(190,210))
		else
			sound.Play("snd_jack_hmcd_hammerhit.wav",HitPos,70,math.random(160,180))
		end
		local Dam=DamageInfo()
		Dam:SetAttacker(self.Owner)
		Dam:SetInflictor(self.Weapon)
		Dam:SetDamage(DamageAmt*Mul)
		Dam:SetDamageForce(AimVec*Mul/100)
		Dam:SetDamageType(DMG_CLUB)	
		Dam:SetDamagePosition(HitPos)
		Ent:TakeDamageInfo(Dam)
		local Phys=Ent:GetPhysicsObject()
		if(IsValid(Phys))then
			if(Ent:IsPlayer())then 
			Ent:SetVelocity(-Ent:GetVelocity()/2) 
			end
			Phys:ApplyForceOffset(AimVec*3000*Mul,HitPos)
			self.Owner:SetVelocity(-AimVec*SelfForce/100)
			self.Power=1000
		end
		self.AimedC=false
		self:SetAimedC(false)
	end
	
	
	else
	self.Owner:ViewPunch(Angle(-2,0,0))
	Ent,HitPos,HitNorm=HMCD_WhomILookinAt(self.Owner,.01,130)
	local AimVec,Mul=self.Owner:GetAimVector(),1
	if((IsValid(Ent))or((Ent)and(Ent.IsWorld)and(Ent:IsWorld())))then
		local SelfForce=30
		local DamageAmt=math.random(9,11)
		if(self:IsEntSoft(Ent))then
			sound.Play("snd_jack_hmcd_axehit.wav",HitPos,65,math.random(190,210))
		else
			sound.Play("snd_jack_hmcd_hammerhit.wav",HitPos,70,math.random(160,180))
		end
		local Dam=DamageInfo()
		Dam:SetAttacker(self.Owner)
		Dam:SetInflictor(self.Weapon)
		Dam:SetDamage(DamageAmt*Mul)
		Dam:SetDamageForce(AimVec*Mul/100)
		Dam:SetDamageType(DMG_CLUB)	
		Dam:SetDamagePosition(HitPos)
		Ent:TakeDamageInfo(Dam)
		local Phys=Ent:GetPhysicsObject()
		if(IsValid(Phys))then
			if(Ent:IsPlayer())then 
			Ent:SetVelocity(-Ent:GetVelocity()/2) 
			end
			Phys:ApplyForceOffset(Vector((AimVec*self.Power*Mul).x,(AimVec*self.Power*Mul).y,0),Phys:GetPos())
			self.Owner:SetVelocity(-AimVec*SelfForce/100)
			self.Power=1000
		end
		--self.AimedC=false
		--self:SetAimedC(false)
	end	
	
	
	end
	
	if(IsValid(self))then sound.Play("weapons/iceaxe/iceaxe_swing1.wav",self:GetPos(),85,math.random(90,110)) end
	self.Owner:LagCompensation(false)
end

function SWEP:Reload()
	self.Power=1000
	self.Owner:PrintMessage(HUD_PRINTCENTER,self.Power)
end

function SWEP:DoBFSAnimation(anim)
	local vm=self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
end

function SWEP:UpdateNextIdle()
	local vm=self.Owner:GetViewModel()
	self:SetNextIdle(CurTime()+vm:SequenceDuration())
end

function SWEP:IsEntSoft(ent)
	return ((ent:IsNPC())or(ent:IsPlayer())or(ent:GetClass()=="prop_ragdoll"))
end


function SWEP:OnDrop()
	local Ent=ents.Create(self.ENT)
	Ent.HmcdSpawned=self.HmcdSpawned
	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
	Ent:Spawn()
	Ent:Activate()
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity()/2)
	self:Remove()
end
if(CLIENT)then
	local DownAmt=0
	function SWEP:GetViewModelPosition(pos,ang)
		if(self.Owner:KeyDown(IN_SPEED))then
			DownAmt=math.Clamp(DownAmt+.1,0,4)
		else
			DownAmt=math.Clamp(DownAmt-.1,0,4)
		end
		ang:RotateAroundAxis(ang:Right(),0)
		return pos-ang:Up()*1-ang:Forward()*(0+DownAmt)-ang:Up()*DownAmt,ang
	end
	function SWEP:DrawWorldModel()
		if(GAMEMODE:ShouldDrawWeaponWorldModel(self))then
			self:DrawModel()
		end
	end
	local Crouched=0
	local LastSprintGotten=0
	local LastAimGotten=0
	local LastExtraAim=0
	function SWEP:GetViewModelPosition(pos,ang)
		if not(IsValid(self.Owner))then return pos,ang end
		local FT=FrameTime()
		local SprintGotten=Lerp(.1,LastSprintGotten,self:GetSprinting())
		LastSprintGotten=SprintGotten
		local AimGotten=Lerp(.1,LastAimGotten,self:GetAiming())
		LastAimGotten=AimGotten
		local Aim,Sprint,Up,Forward,Right=AimGotten,SprintGotten/100,ang:Up(),ang:Forward(),ang:Right()
		local ExtraAim=0
		if((self.Owner:KeyDown(IN_FORWARD))or(self.Owner:KeyDown(IN_BACK))or(self.Owner:KeyDown(IN_MOVELEFT))or(self.Owner:KeyDown(IN_MOVERIGHT)))then
			ExtraAim=Lerp(4*FT,LastExtraAim,1)
		else
			ExtraAim=Lerp(4*FT,LastExtraAim,0)
		end
		LastExtraAim=ExtraAim
		local Vec=self.AimPos*(Aim/100)
		if((self.CloseAimPos)and(Aim>0))then Vec=Vec+self.CloseAimPos*ExtraAim end
		if((Aim>0)and(self:GetReady())and(self.AimAng))then
			ang:RotateAroundAxis(ang:Right(),self.AimAng.p*Aim/100)
			ang:RotateAroundAxis(ang:Up(),self.AimAng.y*Aim/100)
			ang:RotateAroundAxis(ang:Forward(),self.AimAng.r*Aim/100)
		end

		pos=pos+Vec.x*Right+Vec.y*Forward+Vec.z*Up
		if(self.Owner:KeyDown(IN_DUCK))then Crouched=math.Clamp(Crouched+.01,0,1) else Crouched=math.Clamp(Crouched-.01,0,1) end
		Crouched=Crouched*(1-(Aim/100))
		pos=pos+Up*Crouched
		return pos,ang
	end
end

function SWEP:DrawWorldModel()
	if((IsValid(self.Owner))and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
		if(self.FuckedWorldModel)then
			if not(self.WModel)then
				self.WModel=ClientsideModel(self.WorldModel)
				self.WModel:SetPos(self.Owner:GetPos())
				self.WModel:SetParent(self.Owner)
				self.WModel:SetNoDraw(true)
			else
				local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
				if((pos)and(ang))then
					self.WModel:SetRenderOrigin(pos+ang:Right()*1+ang:Forward()*32+ang:Up()*-7)
					ang:RotateAroundAxis(ang:Forward(),0)
					ang:RotateAroundAxis(ang:Right(),-100)
					ang:RotateAroundAxis(ang:Up(),0)
					self.WModel:SetRenderAngles(ang)
					self.WModel:DrawModel()
				end
			end
		else
			self:DrawModel()
		end
	end
end