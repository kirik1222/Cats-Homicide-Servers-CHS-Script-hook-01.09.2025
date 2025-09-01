if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	SWEP.ViewModelFOV = 75

	SWEP.Slot = 1
	SWEP.SlotPos = 2

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

SWEP.ViewModel = "models/mu_hmcd_mansion/weapon_knives/v_kitchenknife.mdl"
SWEP.WorldModel = "models/mu_hmcd_mansion/weapon_knives/w_kitchenknife.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_hmcd_mansion_knife");SWEP.BounceWeaponIcon=false end
SWEP.PrintName = "Chef Knife"
SWEP.Instructions	= "A knife with wooden grip and sharp stainless steel blade. Intended for use in cooking.\n\nLMB to swing."
SWEP.Author			= ""
SWEP.Contact		= ""
--SWEP.Purpose		= "Kill her already."
SWEP.BobScale=3
SWEP.SwayScale=3
SWEP.Weight	= 3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false
SWEP.DangerLevel=60

SWEP.AttackSlowDown=1

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

SWEP.CommandDroppable=true

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
SWEP.CarryWeight=600
--SWEP.HolsterSlot=1
--SWEP.HolsterPos=Vector(-3,-33,6)
--SWEP.HolsterAng=Angle(90,180,0)
SWEP.Poisonable=true
SWEP.ENT="ent_hmcd_mansion_knife"

function SWEP:Initialize()
	self:SetNextIdle(CurTime()+1)
	self:SetHoldType("melee")
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float",0,"NextIdle")
end

function SWEP:PrimaryAttack()
	local Ent,HitPos,HitNorm=HMCD_WhomILookinAt(self.Owner,.35,70)
	if not(IsFirstTimePredicted())then
		self.Owner:GetViewModel():SetPlaybackRate(1)
		return
	end
	if(self.Owner.Stamina<6)then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
		self:DoBFSAnimation("attack_fancy")
	self:UpdateNextIdle()
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:SetNextPrimaryFire(CurTime()+0.75)
	if(SERVER)then timer.Simple(.05,function() if(IsValid(self))then sound.Play("weapons/slam/throw.wav",self:GetPos(),85,math.random(90,110)) end end) end
	timer.Simple(.15,function()
		if(IsValid(self))then
			self:AttackFront()
		end
	end)
end

function SWEP:Deploy()
	if not(IsFirstTimePredicted())then
		self:DoBFSAnimation("draw")
		self.Owner:GetViewModel():SetPlaybackRate(.1)
		return
	end
	self:DoBFSAnimation("draw")
	self:UpdateNextIdle()
	if(SERVER)then sound.Play("snd_jack_hmcd_knifedraw.wav",self.Owner:GetPos(),55,math.random(90,110)) end
	return true
end

function SWEP:SecondaryAttack()
	--
end

function SWEP:Think()
	local Time=CurTime()
	if(self:GetNextIdle()<Time)then
		self:DoBFSAnimation("idle")
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
end

function SWEP:AttackFront()
	self.Owner:ViewPunch(Angle(2,0,0))
	if(CLIENT)then return end
	self.Owner:LagCompensation(true)
	HMCD_StaminaPenalize(self.Owner,5)
	local Ent,HitPos,HitNorm=HMCD_WhomILookinAt(self.Owner,.35,70)

	local AimVec,Mul=self.Owner:GetAimVector(),1
	if((IsValid(Ent))or((Ent)and(Ent.IsWorld)and(Ent:IsWorld())))then
		local SelfForce=30
		local DamageAmt=math.random(8,12)
		if(self:IsEntSoft(Ent))then
				if((self.Poisoned)and(Ent:IsPlayer()))then
				HMCD_Poison(Ent,self.Owner)
				self.Poisoned=false
				end
				util.Decal("Blood",HitPos+HitNorm,HitPos-HitNorm)
				local edata = EffectData()
				edata:SetStart(self.Owner:GetShootPos())
				edata:SetOrigin(HitPos)
				edata:SetNormal(HitNorm)
				edata:SetEntity(Ent)
				util.Effect("BloodImpact",edata,true,true)
			sound.Play("snd_jack_hmcd_slash.wav",HitPos,70,math.random(80,90))
		else
			sound.Play("snd_jack_hmcd_knifehit.wav",HitPos,65,math.random(90,110))
		end
		local Dam=DamageInfo()
		Dam:SetAttacker(self.Owner)
		Dam:SetInflictor(self.Weapon)
		Dam:SetDamage(DamageAmt*Mul)
		Dam:SetDamageForce(AimVec*Mul/100)
		Dam:SetDamageType(DMG_SLASH)
		Dam:SetDamagePosition(HitPos)
		Ent:TakeDamageInfo(Dam)
		local Phys=Ent:GetPhysicsObject()
		if(IsValid(Phys))then
			if(Ent:IsPlayer())then 
			Ent:SetVelocity(-Ent:GetVelocity()/2) 
			end
			Phys:ApplyForceOffset(AimVec*25*Mul,HitPos)
			self.Owner:SetVelocity(-AimVec*SelfForce/100)
		end
	end
	self.Owner:LagCompensation(false)
end

function SWEP:Reload()
	--
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
end