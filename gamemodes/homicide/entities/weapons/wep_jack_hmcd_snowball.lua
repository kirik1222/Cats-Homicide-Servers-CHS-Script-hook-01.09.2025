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
SWEP.ViewModel = "models/weapons/v_brick.mdl"
SWEP.WorldModel = "models/zerochain/props_christmas/snowballswep/zck_w_snowballswep.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_snowball");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_snowball"
SWEP.PrintName = "Snowball"
SWEP.Instructions	= "This is a spherical object made from snow.\n\nLMB to throw."
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
SWEP.ENT="ent_jack_hmcd_snowball"
SWEP.DrawAnim="draw"
SWEP.CarryWeight=100
--models/w_models/weapons/w_eq_pipebomb.mdl
--models/w_models/weapons/w_eq_painpills.mdl
SWEP.UseHands=false
SWEP.HoldType="grenade"
SWEP.RunHoldType="normal"
SWEP.IdleAnim="idle"
SWEP.PrepareAnim="charge"
SWEP.ThrowAnim="throw"

function SWEP:PreDrawViewModel(vm,wep,ply)
	if IsValid(self.Owner:GetNWEntity("Fake")) then return true end
	vm:SetSubMaterial(0,"engine/occlusionproxy")
end

function SWEP:Deploy()
	if not(IsFirstTimePredicted())then
		self:DoBFSAnimation(self.DrawAnim)
		return
	end
	if self.DownAmt then
		self.DownAmt=20
	end
	self:DoBFSAnimation(self.DrawAnim)
	return true
end

function SWEP:DoBFSAnimation(anim)
	if((self.Owner)and(self.Owner.GetViewModel))then
		local vm=self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
		self.NextIdle=CurTime()+vm:SequenceDuration()*vm:GetPlaybackRate()
	end
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:SetupDataTables()
	
end

function SWEP:ThrowGrenade()
	if(CLIENT)then return end
	self.Owner:SetLagCompensated(true)
	self.CommandDroppable=false
	local Grenade=ents.Create("ent_jack_hmcd_snowball")
	Grenade.HmcdSpawned=self.HmcdSpawned
	Grenade:SetAngles(VectorRand():Angle())
	Grenade:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*1)
	Grenade.Owner=self.Owner
	Grenade.Thrown=true
	Grenade.CollisionGroup=COLLISION_GROUP_NONE
	Grenade:Spawn()
	Grenade:Activate()
	Grenade:Throw()
	Grenade.InitialDir=self.Owner:GetAimVector()
	Grenade:GetPhysicsObject():SetVelocity(self.Owner:GetVelocity()+self.Owner:GetAimVector()*750)
	self.Owner:SetLagCompensated(false)
	timer.Simple(.1,function() if(IsValid(self))then self:Remove() end end)
end

function SWEP:OnRemove()
	if IsValid(self.Owner) and CLIENT then
		local vm=self.Owner:GetViewModel()
		if(IsValid(vm)) then vm:SetSubMaterial(0,"") end
	end
end

function SWEP:Holster(newWep)
	if IsValid(self.Owner) and CLIENT then
		local vm=self.Owner:GetViewModel()
		if(IsValid(vm)) then vm:SetSubMaterial(0,"") end
	end
	return true
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

function SWEP:PrimaryAttack()
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

function SWEP:SecondaryAttack()
	--
end

function SWEP:Think()
	if self.Prepared and not(self.Owner:KeyDown(IN_ATTACK)) then
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
		pos=pos-ang:Up()*self.DownAmt
		return pos,ang
	end
	function SWEP:ViewModelDrawn(vm)
		if not(self.Snowball)then
			self.Snowball=ClientsideModel(self.WorldModel)
			self.Snowball:SetPos(vm:GetPos())
			self.Snowball:SetParent(vm)
			self.Snowball:SetNoDraw(true)
		else
			local matr=vm:GetBoneMatrix(vm:LookupBone("ValveBiped.Bip01_R_Hand"))
			local pos,ang=matr:GetTranslation(),matr:GetAngles()
			self.Snowball:SetRenderOrigin(pos+ang:Forward()*5+ang:Right()*2.5)
			self.Snowball:SetRenderAngles(ang)
			self.Snowball:DrawModel()
		end
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