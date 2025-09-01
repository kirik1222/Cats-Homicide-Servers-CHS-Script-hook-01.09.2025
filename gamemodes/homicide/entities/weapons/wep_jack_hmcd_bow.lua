if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 75
	SWEP.Slot = 2
	SWEP.SlotPos = 2
	killicon.AddFont("wep_jack_hmcd_bow", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))
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
SWEP.Base="wep_jack_hmcd_firearm_base"
SWEP.ViewModel = "models/weapons/v_snij_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snij_awp.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_bow");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_bow"
SWEP.IconHeight=2
SWEP.IconLength=2
SWEP.PrintName = "Hunting Bow"
SWEP.Instructions	= "This is a modern aluminum-fiberglass compound bow with a draw force of 290 newtons, used (with broadhead arrows) to take medium-sized north-american game.\n\nRMB to draw/aim.\nLMB to fire."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=2
SWEP.SwayScale=2
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
SWEP.Primary.Ammo         	= "XBowBolt"
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
SWEP.NextCheck=0
SWEP.ENT="ent_jack_hmcd_bow"
SWEP.CommandDroppable=true
SWEP.DeathDroppable=true
SWEP.HolsterSlot=1
SWEP.HolsterPos=Vector(5,-12,-5)
SWEP.HolsterAng=Angle(90,5,170)
SWEP.CanAmmoShow=true
SWEP.AmmoType="XBowBolt"
SWEP.AmmoName="Broadhead Arrow"
SWEP.AmmoPoisonable=true
SWEP.CarryWeight=3500
SWEP.BearTime=7
SWEP.SprintPos=Vector(0,0,0)
SWEP.SprintAng=Angle(-30,0,0)
SWEP.AimAng=Angle(0,0,-70)
SWEP.AimPos=Vector(-1.5,-3,-3)
SWEP.HipHoldType="ar2"
SWEP.AimHoldType="ar2"
SWEP.DownHoldType="passive"
SWEP.Attachments={
	["Owner"]={
		["BowSight"]={
			bone="Dummy003",
			pos={
				right=-7,
				forward=10,
				up=-0.5
			},
			ang={
				forward=180
			},
			scale=.7,
			model="models/bowsight/hunter_sights.mdl"
		}
	},
	["Viewer"]={
		["Weapon"]={
			pos={
				right=0,
				up=0,
				forward=3
			},
			ang={
				forward=180
			}
		},
		["Magazine"]={
			model="models/bowsight/hunter_sights.mdl",
			pos={
				forward=19,
				up=7.5,
				right=0.5
			},
			ang={
				forward=-90
			},
			scale=.7
		}
	}
}
SWEP.TriggerDelay=2.5
function SWEP:Initialize()
	self:SetNWBool("BowSight",true)
	self:SetReady(true)
	self:SetHoldType("ar2")
	timer.Simple(.1,function()
		if IsValid(self) then
			self:EnforceHolsterRules(self)
		end
	end)
end
function SWEP:SetupDataTables()
	self:NetworkVar("Bool",0,"Reloading")
	self:NetworkVar("Bool",1,"Suiciding")
	self:NetworkVar("Bool",2,"Ready")
end
function SWEP:PrimaryAttack()
	--for i=0,10 do PrintTable(self.Owner:GetViewModel():GetAnimInfo(i)) end
	if not(IsFirstTimePredicted())then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	if(self:GetReloading())then return end
	if(self.Owner:GetAmmoCount(self.Primary.Ammo)<1)then
		if(CLIENT)then
			self.Owner.AmmoShow=CurTime()+2
		end
		return
	end
	if(self.AimPerc<100)then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:DoBFSAnimation("awm_fire")
	self.Owner:GetViewModel():SetPlaybackRate(.45)
	local Pitch=math.random(90,110)
	self:EmitSound("snd_jack_hmcd_bowshoot.wav",50,Pitch)
	if(SERVER)then
		sound.Play("snd_jack_hmcd_bowshoot.wav",self.Owner:GetShootPos(),60,Pitch)
		sound.Play("snd_jack_hmcd_arrowwhiz.wav",self.Owner:GetShootPos()+self.Owner:GetAimVector()*50,60,Pitch)
	end
	self:FireArrow()
	self:TakePrimaryAmmo(1)
	self:SetReloading(true)
	util.ScreenShake(self.Owner:GetShootPos(),7,255,.1,20)
	timer.Simple(.01,function()
		if(self.Owner:GetAmmoCount(self.Primary.Ammo)>0)then self:EmitSound("snd_jack_hmcd_bowload.wav",55,100) end
	end)
	timer.Simple(2.5,function()
		if(IsValid(self))then
			self:SetReloading(false)
			self:DoBFSAnimation("awm_idle")
			if(CLIENT)then
				self.Owner.AmmoShow=CurTime()+2
			end
		end
	end)
	self.Owner:ViewPunch(Angle(0,-1,0))
	self:SetNextPrimaryFire(CurTime()+2.75)
end
function SWEP:FireArrow()
	if(CLIENT)then return end
	self.Owner:SetLagCompensated(true)
	local Arrow=ents.Create("ent_jack_hmcd_arrow")
	Arrow.CollisionSound="snd_jack_hmcd_arrow.wav"
	Arrow.HmcdSpawned=self.HmcdSpawned
	Arrow:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*20)
	Arrow.Owner=self.Owner
	local Ang=self.Owner:GetAimVector():Angle()
	Ang:RotateAroundAxis(Ang:Right(),-90)
	Arrow:SetAngles(Ang)
	Arrow.Fired=true
	Arrow.InitialDir=self.Owner:GetAimVector()
	Arrow.ModelScale=2
	Arrow.InitialVel=self.Owner:GetVelocity()
	Arrow.Poisoned=self.Owner.HMCD_AmmoPoisoned
	self.Owner.HMCD_AmmoPoisoned=false
	Arrow:Spawn()
	Arrow:Activate()
	self.Owner:SetLagCompensated(false)
end
function SWEP:Deploy()
	if not(IsFirstTimePredicted())then return end
	if not((self)and(self.Owner)and(self.Owner.GetViewModel))then return end
	self.DownAmt=10
	self:DoBFSAnimation("awm_draw")
	if(self.Owner:GetAmmoCount(self.Primary.Ammo)>0)then self:EmitSound("snd_jack_hmcd_bowload.wav",55,150) end
	self.Owner:GetViewModel():SetPlaybackRate(.5)
	self:SetNextPrimaryFire(CurTime()+2)
	self:EnforceHolsterRules(self)
	return true
end
function SWEP:Reload()
	if(CLIENT)then
		self.Owner.AmmoShow=CurTime()+2
	end
end
if(CLIENT)then
	local Aim,Forward,Passive=0,0,0
	function SWEP:PreDrawViewModel(vm,wep,ply)
		if(self.Owner:GetAmmoCount(self.Primary.Ammo)<1)then
			vm:SendViewModelMatchingSequence(vm:LookupSequence("awm_draw"))
		end
	end
	--[[local SightTex=Material("sprites/mat_jack_hmcd_bowsight")
	function SWEP:DrawHUD()
		if((self.AimPerc==100)and not((self.Owner:KeyDown(IN_MOVERIGHT))or(self.Owner:KeyDown(IN_BACK))or(self.Owner:KeyDown(IN_FORWARD))or(self.Owner:KeyDown(IN_MOVELEFT))))then
			local Col=render.GetLightColor(self.Owner:GetShootPos()+self.Owner:GetAimVector()*20)
			surface.SetDrawColor(math.Clamp(510*Col.x,0,255),math.Clamp(510*Col.y,0,255),math.Clamp(510*Col.z,0,255))
			surface.SetMaterial(SightTex)
			surface.DrawTexturedRect(ScrW()/2-43,ScrH()/2-65,128,128)
		end
	end]] -- ugly 2d sight...
	function SWEP:ViewModelDrawn(vm)
		if not(self.BowSight)then
			self.BowSight=ClientsideModel("models/bowsight/hunter_sights.mdl")
			self.BowSight:SetPos(vm:GetPos())
			self.BowSight:SetParent(vm)
			self.BowSight:SetNoDraw(true)
			self.BowSight:SetModelScale(.7,0)
		else
			local matr=vm:GetBoneMatrix(vm:LookupBone("Dummy003"))
			local pos,ang=matr:GetTranslation(),matr:GetAngles()
			self.BowSight:SetRenderOrigin(pos-ang:Right()*7+ang:Forward()*10-ang:Up()*0.5)
			ang:RotateAroundAxis(ang:Up(),0)
			ang:RotateAroundAxis(ang:Forward(),180)
			ang:RotateAroundAxis(ang:Right(),0)
			self.BowSight:SetRenderAngles(ang)
			self.BowSight:DrawModel()
		end
	end
	function SWEP:DrawWorldModel()
		if self.Owner:GetNoDraw() then return end
		local Pos,Ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		if(self.DatWorldModel)then
			if((Pos)and(Ang)and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
				self.DatWorldModel:SetRenderOrigin(Pos+Ang:Forward()*3)
				Ang:RotateAroundAxis(Ang:Up(),0)
				Ang:RotateAroundAxis(Ang:Right(),0)
				Ang:RotateAroundAxis(Ang:Forward(),180)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel=ClientsideModel("models/weapons/w_snij_awp.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
		end
		if(self.WBowSight)then
			if((Pos)and(Ang)and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
				self.WBowSight:SetRenderOrigin(Pos+Ang:Forward()*19+Ang:Right()*0.5+Ang:Up()*7.5)
				Ang:RotateAroundAxis(Ang:Up(),0)
				Ang:RotateAroundAxis(Ang:Right(),0)
				Ang:RotateAroundAxis(Ang:Forward(),-90)
				self.WBowSight:SetRenderAngles(Ang)
				self.WBowSight:DrawModel()
			end
		else
			self.WBowSight=ClientsideModel("models/bowsight/hunter_sights.mdl")
			self.WBowSight:SetPos(self:GetPos())
			self.WBowSight:SetParent(self)
			self.WBowSight:SetModelScale(.7,0)
			self.WBowSight:SetNoDraw(true)
		end
	end
end