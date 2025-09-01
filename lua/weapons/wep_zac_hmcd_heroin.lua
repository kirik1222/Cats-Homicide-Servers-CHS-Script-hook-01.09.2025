if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	SWEP.ViewModelFOV = 65

	SWEP.Slot = 5
	SWEP.SlotPos = 2

	killicon.AddFont("wep_zac_hmcd_heroin", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))

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

SWEP.ViewModel = "models/heroin/heroin.mdl"
SWEP.WorldModel = "models/heroin/heroin.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_zac_hmcd_heroin");SWEP.BounceWeaponIcon=false end
SWEP.PrintName = "Heroin Syringe"
SWEP.Instructions	= "Heroin, also known as diamorphine among other names, is an opioid most commonly used as a recreational drug for its euphoric effects. Heroin is made from the milk of opium poppy flowers.\n\nLBM to inject drug. If you are Murderer you can inject drug to other players RMB"
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=2
SWEP.SwayScale=2
SWEP.Weight	= 3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.CommandDroppable=true

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
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"


SWEP.ENT="ent_zac_hmcd_heroin"
SWEP.DownAmt=0
SWEP.HomicideSWEP=true
SWEP.CarryWeight=300


function SWEP:SetupDataTables()
	--
end

function SWEP:PrimaryAttack()
	if not(IsFirstTimePredicted())then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	self:SetNextPrimaryFire(CurTime()+1)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if(CLIENT)then return end
	sound.Play("snd_jack_hmcd_needleprick.wav",self.Owner:GetShootPos()+VectorRand(),60,math.random(90,110))
	sound.Play("snd_jack_hmcd_needleprick.wav",self.Owner:GetShootPos()+VectorRand(),50,math.random(90,110))
	sound.Play("snd_jack_hmcd_needleprick.wav",self.Owner:GetShootPos()+VectorRand(),40,math.random(90,110))
	local Ply,LifeID=self.Owner,self.Owner.LifeID
	self:Remove()
	timer.Simple(2,function()
		if((IsValid(Ply))and(Ply:Alive()))then
			Ply:SetHighOnDrugs(true)
			--self:Remove()
			Ply:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
		Ply:SetHealth(Ply:Health()+35)
		HMCD_PainMoan(Ply,true)
		end
	end)
	timer.Simple(20,function()
		if((IsValid(Ply))and(Ply:Alive())and(Ply.LifeID==LifeID))then
			Ply:SetHighOnDrugs(false)
			--HMCD_Poison(Ply)
			Ply:SetHealth(Ply:Health() - 35)
			umsg.Start("HMCD_StatusEffect",Ply)
	        umsg.String("INTOXICATED")
		    umsg.End()
			HMCD_StaminaPenalize(Ply,20)
			Ply:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
			HMCD_PainMoan(Ply,true)
		end
	end)
	
	timer.Simple(55,function()
		if((IsValid(Ply))and(Ply:Alive())and(Ply.LifeID==LifeID))then
			Ply:SetHighOnDrugs(false)
			Ply:Freeze(true)
			Ply:SetHealth(Ply:Health() - 35)
			HMCD_PainMoan(Ply,true)
			umsg.Start("HMCD_StatusEffect",Ply)
			umsg.String("INTOXICATED")
			HMCD_StaminaPenalize(Ply,20)
			umsg.End()
		end
	end)
	timer.Simple(85,function()
		if((IsValid(Ply))and(Ply:Alive())and(Ply.LifeID==LifeID))then
			Ply:SetHighOnDrugs(false)
			Ply:Freeze(false)
			--Ply:ViewPunch(Angle(30,55,0))
			HMCD_PainMoan(Ply,true)
			umsg.Start("HMCD_StatusEffect",Ply)
			umsg.String("Released...")
			umsg.End()
		end
	end)
	timer.Simple(180,function()
		if((IsValid(Ply))and(Ply:Alive())and(Ply.LifeID==LifeID))then
			Ply:SetHighOnDrugs(true)
			Ply:Freeze(true)
			HMCD_PainMoan(Ply,true)
			umsg.Start("HMCD_StatusEffect",Ply)
			umsg.String("ABDOMINAL PAIN")
			HMCD_StaminaPenalize(Ply,5)
			umsg.End()
		end
	end)
	timer.Simple(200,function()
		if((IsValid(Ply))and(Ply:Alive())and(Ply.LifeID==LifeID))then
			Ply:SetHighOnDrugs(false)
			Ply:Freeze(false)
			Ply:SetHealth(-1)
			Ply:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
			HMCD_PainMoan(Ply,true)
			umsg.Start("HMCD_StatusEffect",Ply)
			umsg.String("HEART ATTACK")
			HMCD_StaminaPenalize(Ply,100)
			umsg.End()
	end
	end)
	
	timer.Simple(205,function()
		if((IsValid(Ply))and(Ply:Alive())and(Ply.LifeID==LifeID))then
			Ply:SetHighOnDrugs(false)
			Ply:Freeze(false)
			--Ply:SetHealth(-1)
			Ply:ViewPunch(Angle(math.random(-500,500),math.random(-500,500),math.random(-500,500)))
			HMCD_PainMoan(Ply,true)
			if(Ply:Health()<30)then
			if(math.random(0,1)==0)then
		Ply:Kill()
		else
		umsg.Start("HMCD_StatusEffect",Ply)
			umsg.String("YOU SURVIVED HEART ATTACK")
			umsg.End()
			HMCD_StaminaPenalize(Ply,1000)
		end
		else
		umsg.Start("HMCD_StatusEffect",Ply)
			umsg.String("YOU SURVIVED HEART ATTACK")
			umsg.End()
			HMCD_StaminaPenalize(Ply,1000)
		end
		end
	end)
	timer.Simple(40,function()
		if((IsValid(Ply))and(Ply:Alive())and(Ply.LifeID==LifeID))then
					Ply:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
					HMCD_PainMoan(Ply,true)
					umsg.Start("HMCD_StatusEffect",Ply)
			umsg.String("DIFFICULT TO BREATHE")
			HMCD_StaminaPenalize(Ply,20)
			umsg.End()
		end
	end)
	timer.Simple(65,function()
		if((IsValid(Ply))and(Ply:Alive())and(Ply.LifeID==LifeID))then
					Ply:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
					HMCD_PainMoan(Ply,true)
					umsg.Start("HMCD_StatusEffect",Ply)
			umsg.String("DIFFICULT TO BREATHE")
			HMCD_StaminaPenalize(Ply,20)
			umsg.End()
		end
	end)
	timer.Simple(75,function()
		if((IsValid(Ply))and(Ply:Alive())and(Ply.LifeID==LifeID))then
					Ply:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
					HMCD_PainMoan(Ply,true)
					umsg.Start("HMCD_StatusEffect",Ply)
			umsg.String("DIFFICULT TO BREATHE")
			HMCD_StaminaPenalize(Ply,20)
			umsg.End()
		end
	end)
		timer.Simple(95,function()
		if((IsValid(Ply))and(Ply:Alive())and(Ply.LifeID==LifeID))then
					Ply:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
					HMCD_PainMoan(Ply,true)
					umsg.Start("HMCD_StatusEffect",Ply)
			umsg.String("DIFFICULT TO BREATHE")
			HMCD_StaminaPenalize(Ply,20)
			umsg.End()
		end
	end)
		timer.Simple(105,function()
		if((IsValid(Ply))and(Ply:Alive())and(Ply.LifeID==LifeID))then
					Ply:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
					HMCD_PainMoan(Ply,true)
					umsg.Start("HMCD_StatusEffect",Ply)
			umsg.String("DIFFICULT TO BREATHE")
			HMCD_StaminaPenalize(Ply,20)
			umsg.End()
		end
	end)
	end

function SWEP:Deploy()
	if not(IsFirstTimePredicted())then return end
	self.DownAmt=8
	self:SetNextPrimaryFire(CurTime()+1)
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:OnRemove()
	--
end

function SWEP:SecondaryAttack()
if not(self.Owner.Murderer)then return end
	if not(IsFirstTimePredicted())then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	self:SetNextPrimaryFire(CurTime()+1)
	self:AttackFront()
end

function SWEP:Think()
		if(SERVER)then
		local HoldType="slam"
		if(self.Owner:KeyDown(IN_SPEED))then
			HoldType="normal"
		end
		self:SetHoldType(HoldType)
	end
end

function SWEP:Reload()
	--
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
function SWEP:PreDrawViewModel(vm,ply,wep)
		--
	end
	function SWEP:GetViewModelPosition(pos,ang)
		if not(self.DownAmt)then self.DownAmt=8 end
		if(self.Owner:KeyDown(IN_SPEED))then
			self.DownAmt=math.Clamp(self.DownAmt+.1,0,8)
		else
			self.DownAmt=math.Clamp(self.DownAmt-.1,0,8)
		end
		local NewPos=pos+ang:Forward()*30-ang:Up()*(8+self.DownAmt)+ang:Right()*10
		ang:RotateAroundAxis(ang:Right(),-190)
		return NewPos,ang
	end
	function SWEP:DrawWorldModel()
		local Pos,Ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		if(self.DatWorldModel)then
			if((Pos)and(Ang)and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
				self.DatWorldModel:SetRenderOrigin(Pos+Ang:Forward()*4-Ang:Up()*2+Ang:Right()*2)
				Ang:RotateAroundAxis(Ang:Right(),30)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel=ClientsideModel("models/heroin/heroin.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetModelScale(.6,0)
		end
	end
	function SWEP:ViewModelDrawn()
		--
	end
end

function SWEP:CanBackStab(ent)
	if not(ent:IsPlayer())then return false end
	local TrueVec=(self.Owner:GetPos()-ent:GetPos()):GetNormalized()
	local LookVec=ent:GetAimVector()
	local DotProduct=LookVec:DotProduct(TrueVec)
	local ApproachAngle=(-math.deg(math.asin(DotProduct))+90)
	local RelSpeed=(ent:GetPhysicsObject():GetVelocity()-self.Owner:GetVelocity()):Length()
	if((ApproachAngle<=120)or(RelSpeed>100))then
		return false
	else
		return true
	end
end

function SWEP:AttackFront()
	if(CLIENT)then return end
	self.Owner:LagCompensation(true)
	local Ent,HitPos,HitNorm=HMCD_WhomILookinAt(self.Owner,.2,60)
	local AimVec,Mul=self.Owner:GetAimVector(),1
	if((IsValid(Ent))and(Ent:IsPlayer()))then
		if(self:CanBackStab(Ent))then
			sound.Play("snd_jack_hmcd_needleprick.wav",Ent:GetShootPos(),50,math.random(90,110))
			sound.Play("snd_jack_hmcd_needleprick.wav",HitPos,40,math.random(90,110))
			self.Owner:ViewPunch(Angle(1,0,0))
			Ent:ViewPunch(Angle(-.05,0,0))
			-- covert poisoning FTW
			timer.Simple(2,function()
			local Ent,LifeID=Ent,Ent.LifeID
            if((IsValid(Ent))and(Ent:Alive())and(Ent.LifeID==LifeID))then
			Ent:SetHighOnDrugs(true)
			--self:Remove()
			Ent:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
		Ent:SetHealth(Ent:Health()+35)
		HMCD_PainMoan(Ent,true)
		end
	end)
	timer.Simple(20,function()
		if((IsValid(Ent))and(Ent:Alive())and(Ent.LifeID==LifeID))then
			Ent:SetHighOnDrugs(false)
			--HMCD_Poison(Ply)
			Ent:SetHealth(Ent:Health() - 35)
			umsg.Start("HMCD_StatusEffect",Ent)
	        umsg.String("INTOXICATED")
			HMCD_StaminaPenalize(Ent,20)
		    umsg.End()
			Ent:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
			HMCD_PainMoan(Ent,true)
		end
	end)
	
	timer.Simple(55,function()
		if((IsValid(Ent))and(Ent:Alive())and(Ent.LifeID==LifeID))then
			Ent:SetHighOnDrugs(false)
			Ent:Freeze(true)
			Ent:SetHealth(Ent:Health() - 35)
			HMCD_PainMoan(Ent,true)
			umsg.Start("HMCD_StatusEffect",Ent)
			umsg.String("INTOXICATED")
			HMCD_StaminaPenalize(Ent,20)
			umsg.End()
	end
	end)
	timer.Simple(85,function()
		if((IsValid(Ent))and(Ent:Alive())and(Ent.LifeID==LifeID))then
			Ent:SetHighOnDrugs(false)
			Ent:Freeze(false)
			--Ply:ViewPunch(Angle(30,55,0))
			HMCD_PainMoan(Ent,true)
			umsg.Start("HMCD_StatusEffect",Ent)
			umsg.String("Released...")
			umsg.End()
	end
	end)
	timer.Simple(180,function()
		if((IsValid(Ent))and(Ent:Alive())and(Ent.LifeID==LifeID))then
			Ent:SetHighOnDrugs(true)
			Ent:Freeze(true)
			HMCD_PainMoan(Ent,true)
			umsg.Start("HMCD_StatusEffect",Ent)
			umsg.String("ABDOMINAL PAIN")
			HMCD_StaminaPenalize(Ent,5)
			umsg.End()
	end
	end)
	timer.Simple(200,function()
	if((IsValid(Ent))and(Ent:Alive())and(Ent.LifeID==LifeID))then
			Ent:SetHighOnDrugs(false)
			Ent:Freeze(false)
			Ent:SetHealth(-1)
			Ent:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
			HMCD_PainMoan(Ent,true)
			umsg.Start("HMCD_StatusEffect",Ent)
			umsg.String("HEART ATTACK")
			HMCD_StaminaPenalize(Ent,100)
			umsg.End()
	end
	end)
	
	timer.Simple(205,function()
		if((IsValid(Ent))and(Ent:Alive())and(Ent.LifeID==LifeID))then
			Ent:SetHighOnDrugs(false)
			Ent:Freeze(false)
			--Ply:SetHealth(-1)
			Ent:ViewPunch(Angle(math.random(-500,500),math.random(-500,500),math.random(-500,500)))
			HMCD_PainMoan(Ent,true)
			if(Ent:Health()<30)then
			if(math.random(0,1)==0)then
		Ent:Kill()
		else
		umsg.Start("HMCD_StatusEffect",Ent)
			umsg.String("YOU SURVIVED HEART ATTACK")
			HMCD_StaminaPenalize(Ent,1000)
			umsg.End()
		end
		else
		umsg.Start("HMCD_StatusEffect",Ent)
			umsg.String("YOU SURVIVED HEART ATTACK")
			HMCD_StaminaPenalize(Ent,1000)
			umsg.End()
		end
		end
	end)
	timer.Simple(40,function()
		if((IsValid(Ent))and(Ent:Alive())and(Ent.LifeID==LifeID))then
					Ent:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
					HMCD_PainMoan(Ent,true)
					umsg.Start("HMCD_StatusEffect",Ent)
			umsg.String("DIFFICULT TO BREATHE")
			HMCD_StaminaPenalize(Ent,20)
			umsg.End()
		end
	end)
	timer.Simple(65,function()
		if((IsValid(Ent))and(Ent:Alive())and(Ent.LifeID==LifeID))then
					Ent:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
					HMCD_PainMoan(Ent,true)
					umsg.Start("HMCD_StatusEffect",Ent)
			umsg.String("DIFFICULT TO BREATHE")
			HMCD_StaminaPenalize(Ent,20)
			umsg.End()
		end
	end)
	timer.Simple(75,function()
		if((IsValid(Ent))and(Ent:Alive())and(Ent.LifeID==LifeID))then
					Ent:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
					HMCD_PainMoan(Ent,true)
					umsg.Start("HMCD_StatusEffect",Ent)
			umsg.String("DIFFICULT TO BREATHE")
			HMCD_StaminaPenalize(Ent,20)
			umsg.End()
		end
	end)
		timer.Simple(95,function()
		if((IsValid(Ent))and(Ent:Alive())and(Ent.LifeID==LifeID))then
					Ent:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
					HMCD_PainMoan(Ent,true)
					umsg.Start("HMCD_StatusEffect",Ent)
			umsg.String("DIFFICULT TO BREATHE")
			HMCD_StaminaPenalize(Ent,20)
			umsg.End()
		end
	end)
		timer.Simple(105,function()
		if((IsValid(Ent))and(Ent:Alive())and(Ent.LifeID==LifeID))then
					Ent:ViewPunch(Angle(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
					HMCD_PainMoan(Ent,true)
					umsg.Start("HMCD_StatusEffect",Ent)
			umsg.String("DIFFICULT TO BREATHE")
			HMCD_StaminaPenalize(Ent,20)
			umsg.End()
		end
	end)
			--HMCD_Poison(Ent,self.Owner)
			self:Remove()
		else
			self.Owner:PrintMessage(HUD_PRINTCENTER,"Must be behind!")
		end
	else
		sound.Play("snd_jack_hmcd_tinyswish.wav",self.Owner:GetShootPos(),50,math.random(90,110))
	end
	self.Owner:LagCompensation(false)
end