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
SWEP.Base="weapon_base"
SWEP.ViewModel = "models/weapons/v_molotov_b.mdl"
SWEP.WorldModel = "models/w_models/weapons/w_jj_pipebomb.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_pipebomb");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_pipebomb"
SWEP.PrintName = "Pipe Bomb"
SWEP.Instructions	= "This improvised explosive device is a heavy-gauge steel pipe filled with black powder and surrounded by nails. It has a simple short pyrotechnic fuze. This device achieves high detonation speed and shrapnel projection through tight containment of the black powder (a low explosive). It's still not as deadly or reliable as a proper grenade, though.\n\nLMB to light and throw."
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
SWEP.Primary.Automatic   	= false
SWEP.Primary.Ammo         	= "none"
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
SWEP.CommandDroppable=true
SWEP.ENT="ent_jack_hmcd_pipebomb"
SWEP.CarryWeight=1200
SWEP.DrawAnim="base_draw"
SWEP.UseHands=true
SWEP.InsHands=true
SWEP.IgniteAnim="pullback_high"
SWEP.ThrowAnim="throw"
function SWEP:Initialize()
	self:SetHoldType("grenade")
	self.Thrown=false
	self:SetRopeIgnited(false)
end
function SWEP:SetupDataTables()
	self:NetworkVar("Bool",0,"RopeIgnited")
end
function SWEP:PrimaryAttack()
	if not(IsFirstTimePredicted())then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	self:DoBFSAnimation(self.IgniteAnim)
	timer.Simple(.2,function()
		self:EmitSound("weapons/molotov/handling/molotov_lighter_open.wav")
	end)
	timer.Simple(.55,function()
		self:EmitSound("weapons/molotov/handling/molotov_lighter_strike.wav")
		self:SetRopeIgnited(true)
		if CLIENT then
			ParticleEffectAttach("molotov_lighter", PATTACH_ABSORIGIN_FOLLOW, self, 1)
		end
	end)
	timer.Simple(.9,function()
		self:EmitSound("weapons/molotov/handling/molotov_ignite.wav")
	end)
	timer.Simple(1.85,function()
		self.StartedIgnition=true
	end)
	self:SetNextPrimaryFire(CurTime()+5)
	self:SetNextSecondaryFire(CurTime()+5)
end
function SWEP:DoBFSAnimation(anim)
	if((self.Owner)and(self.Owner.GetViewModel))then
		local vm=self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
	end
end
function SWEP:Deploy()
	if not(IsFirstTimePredicted())then return end
	self:DoBFSAnimation(self.DrawAnim)
	self:SetNextPrimaryFire(CurTime()+1)
	self:SetNextSecondaryFire(CurTime()+1)
	return true
end
function SWEP:ThrowGrenade()
	if(CLIENT)then return end
	self.CommandDroppable=false
	self.Owner:SetLagCompensated(true)
	local Grenade=ents.Create("ent_jack_hmcd_pipebomb")
	Grenade.HmcdSpawned=self.HmcdSpawned
	Grenade:SetAngles(VectorRand():Angle())
	Grenade:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*1)
	Grenade.Owner=self.Owner
	Grenade:Spawn()
	Grenade:Activate()
	Grenade:GetPhysicsObject():SetVelocity(self.Owner:GetVelocity()+self.Owner:GetAimVector()*750)
	Grenade:Arm()
	self.Owner:SetLagCompensated(false)
	timer.Simple(.1,function() if(IsValid(self))then self:Remove() end end)
end
function SWEP:SecondaryAttack()
	--
end
function SWEP:Think()
	if self.StartedIgnition and not(self.Owner:KeyDown(IN_ATTACK)) then
		if SERVER then
			self.StartedIgnition=false
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
		local HoldType="grenade"
		if(self.Owner:KeyDown(IN_SPEED))then
			HoldType="normal"
		end
		self:SetHoldType(HoldType)
	end
end
function SWEP:HMCDOnDrop()
	local Ent=ents.Create(self.ENT)
	Ent.HmcdSpawned=self.HmcdSpawned
	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
	Ent:Spawn()
	Ent:Activate()
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity()/2)
	self:Remove()
end
function SWEP:Reload()
	--
end
function SWEP:ViewModelDrawn(vm)
		if not(self.VMSuppModel)then
		self.VMSuppModel=ClientsideModel(self.WorldModel)
		self.VMSuppModel:SetPos(vm:GetPos())
		self.VMSuppModel:SetParent(vm)
		self.VMSuppModel:SetNoDraw(true)
		self.VMSuppModel:SetModelScale(.7,0)
	else
		local matr=vm:GetBoneMatrix(vm:LookupBone("Weapon"))
		local pos,ang=matr:GetTranslation(),matr:GetAngles()
		self.VMSuppModel:SetRenderOrigin(pos+ang:Up()*-3+ang:Right()*-1+ang:Forward()*0)
		ang:RotateAroundAxis(ang:Up(),90)
		ang:RotateAroundAxis(ang:Forward(),0)
		ang:RotateAroundAxis(ang:Right(),0)
		self.VMSuppModel:SetRenderAngles(ang)
		self.VMSuppModel:DrawModel()
	end
end
if(CLIENT)then
	local DownAmt=0
	function SWEP:GetViewModelPosition(pos,ang)
		if not(self.DownAmt)then self.DownAmt=0 end
		if(self.Owner:KeyDown(IN_SPEED) and not(self:GetRopeIgnited()))then
			self.DownAmt=math.Clamp(self.DownAmt+.1,0,20)
		else
			self.DownAmt=math.Clamp(self.DownAmt-.15,0,60)
		end
		pos=pos-ang:Up()*(self.DownAmt)
		ang:RotateAroundAxis(ang:Up(),0)
		return pos,ang
	end
	function SWEP:DrawWorldModel()
		local Pos,Ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		if(self.DatWorldModel)then
			if((Pos)and(Ang)and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
				self.DatWorldModel:SetRenderOrigin(Pos+Ang:Forward()*3.5+Ang:Right()*2-Ang:Up()*1)
				Ang:RotateAroundAxis(Ang:Right(),180)
				--Ang:RotateAroundAxis(Ang:Right(),90)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel=ClientsideModel("models/w_models/weapons/w_jj_pipebomb.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			--self.DatWorldModel:SetModelScale(1,0)
		end
	end
end