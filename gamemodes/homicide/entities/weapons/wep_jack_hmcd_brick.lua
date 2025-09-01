if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 65
	SWEP.Slot = 4
	SWEP.SlotPos = 3
	killicon.AddFont("wep_jack_hmcd_molotov", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))
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
SWEP.Base="wep_jack_hmcd_melee_base"
SWEP.ViewModel = "models/weapons/v_brick.mdl"
SWEP.WorldModel = "models/weapons/w_brick.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_brick");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_brick"
SWEP.PrintName = "Brick"
SWEP.Instructions	= "This is a block used to build walls, pavements and other elements in masonry construction.\n\nLMB to swing.\nRMB to throw."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=3
SWEP.SwayScale=3
SWEP.Weight	= 3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false
SWEP.ViewModelFlip=false
SWEP.Spawnable			= true
SWEP.AdminOnly			= true
SWEP.Primary.Delay			= 0.5
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 120
SWEP.Primary.NumShots		= 1	
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Force			= 900
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic   	= true
SWEP.Primary.Ammo         	= "none"
SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"
SWEP.HomicideSWEP=true
SWEP.CommandDroppable=true
SWEP.ENT="ent_jack_hmcd_brick"
SWEP.DrawAnim="draw"
SWEP.CarryWeight=1200
--models/w_models/weapons/w_eq_pipebomb.mdl
--models/w_models/weapons/w_eq_painpills.mdl
SWEP.UseHands=false
SWEP.PrepareAnim="charge"
SWEP.ThrowAnim="throw"
SWEP.AttackAnim="attack"
SWEP.ViewAttackAnimDelay=.1
SWEP.AttackFrontDelay=.4
SWEP.AttackPlayback=.75
SWEP.AttackAnimDelay=.1
SWEP.StaminaPenalize=5
SWEP.ViewPunch=Angle(0,20,0)
SWEP.HoldType="grenade"
SWEP.RunHoldType="normal"
SWEP.HardImpactSounds={
	{"Concrete.ImpactHard",1,65,{90,110}},
	{"Concrete.ImpactHard",0,65,{90,110}},
	{"Concrete.ImpactHard",-1,65,{90,110}},
}
SWEP.SoftImpactSounds={
	{"Concrete.ImpactHard",1,65,{90,110}},
	{"Concrete.ImpactHard",0,65,{90,110}},
	{"Concrete.ImpactHard",-1,65,{90,110}},
	{"Flesh.ImpactHard",0,65,{90,110}}
}
SWEP.IdleAnim="idle"
SWEP.DamageType=DMG_CLUB
SWEP.MinDamage=10
SWEP.MaxDamage=15
SWEP.ForceOffset=1500
SWEP.DamageForceDiv=5
SWEP.ReachDistance=40
SWEP.WooshSound={"weapons/iceaxe/iceaxe_swing1.wav",65,{60,70}}
SWEP.PrehitViewPunch=Angle(0,-10,0)
SWEP.AttackDelay=1
SWEP.PrehitViewPunchDelay=.1
SWEP.Force=3500

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:SetupDataTables()

end

function SWEP:ThrowGrenade()
	if(CLIENT)then return end
	self.Owner:SetLagCompensated(true)
	local Grenade=ents.Create("ent_jack_hmcd_brick")
	Grenade.HmcdSpawned=self.HmcdSpawned
	Grenade:SetAngles(VectorRand():Angle())
	Grenade:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*1)
	Grenade.Owner=self.Owner
	Grenade.CollisionGroup=COLLISION_GROUP_NONE
	Grenade:Spawn()
	Grenade:Activate()
	Grenade:Throw()
	Grenade.InitialDir=self.Owner:GetAimVector()
	Grenade:GetPhysicsObject():SetVelocity(self.Owner:GetVelocity()+self.Owner:GetAimVector()*750)
	self.Owner:SetLagCompensated(false)
	timer.Simple(.1,function() if(IsValid(self))then self:Remove() end end)
end

function SWEP:SecondaryAttack()
	if not(IsFirstTimePredicted())then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	self:DoBFSAnimation(self.PrepareAnim)
	self.Owner:GetViewModel():SetPlaybackRate(.5)
	timer.Simple(.3,function()
		self.Prepared=true
	end)
	self:SetNextPrimaryFire(CurTime()+5)
	self:SetNextSecondaryFire(CurTime()+5)
end

function SWEP:Think()
	if self.Prepared and not(self.Owner:KeyDown(IN_ATTACK2)) then
		if SERVER then
			self.Prepared=false
			self.Owner:ViewPunch(Angle(-10,-5,0))
			sound.Play("weapons/m67/m67_throw_01.wav",self:GetPos(),100,100)
			self:DoBFSAnimation(self.ThrowAnim)
			timer.Simple(.3,function()
				self.Owner:ViewPunch(Angle(20,10,0))
				self:ThrowGrenade()
			end)
		end
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
	if(SERVER)then
		local HoldType=self.HoldType
		if(self.Owner:KeyDown(IN_SPEED))then
			HoldType=self.RunHoldType
		end
		self:SetHoldType(HoldType)
		if self.NextAttackFront and self.NextAttackFront<CurTime() then
			self:AttackFront()
		end
	end
end
if(CLIENT)then
	local DownAmt=0
	function SWEP:GetViewModelPosition(pos,ang)
		if not(self.DownAmt)then self.DownAmt=0 end
		if(self.Owner:KeyDown(IN_SPEED))then
			self.DownAmt=math.Clamp(self.DownAmt+.1,0,20)
		else
			self.DownAmt=math.Clamp(self.DownAmt-.15,0,60)
		end
		pos=pos-ang:Up()*(self.DownAmt)
		return pos,ang
	end
	function SWEP:DrawWorldModel()
		local Pos,Ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		if(self.DatWorldModel)then
			if((Pos)and(Ang)and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
				self.DatWorldModel:SetRenderOrigin(Pos+Ang:Forward()*3.5+Ang:Right()*2.5-Ang:Up()*1)
				Ang:RotateAroundAxis(Ang:Right(),0)
				Ang:RotateAroundAxis(Ang:Right(),90)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel=ClientsideModel(self.WorldModel)
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
		end
	end
end