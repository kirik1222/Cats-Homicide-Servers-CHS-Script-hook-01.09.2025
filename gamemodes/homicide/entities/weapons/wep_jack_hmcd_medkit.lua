if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	SWEP.ViewModelFOV = 55

	SWEP.Slot = 3
	SWEP.SlotPos = 3

	killicon.AddFont("wep_jack_hmcd_medkit", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))

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
SWEP.ViewModel = "models/w_models/weapons/w_eq_medkit.mdl"
SWEP.WorldModel = "models/w_models/weapons/w_eq_medkit.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_medkit");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_medkit"
SWEP.PrintName = "First-Aid Kit"
SWEP.Instructions	= "This is a civilian-grade first-aid kit containing hemostatic agents, bandages, antibiotics, disinfectants, pain relievers and some basic rations.\n\nLMB to fix self\nRMB to fix another"
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=3
SWEP.SwayScale=3
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

SWEP.ENT="ent_jack_hmcd_medkit"
SWEP.DownAmt=0
SWEP.HomicideSWEP=true
SWEP.CarryWeight=1800
SWEP.Poisonable=true

function SWEP:Initialize()
	self:SetHoldType("slam")
	self.DownAmt=20
	self:SetAmount(1)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Int",0,"Amount")
end

function SWEP:PrimaryAttack()
	if(self.Owner:KeyDown(IN_SPEED))then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if(SERVER)then
		local hasBacteria=false
		if self.Owner.ZombieBacteria then
			for i,tabl in pairs(self.Owner.ZombieBacteria) do
				if CurTime()-tabl[2]<100 then hasBacteria=true break end
			end
		end
		if((self.Owner.Bleedout<=0)and(self.Owner:Health()>99) and not(hasBacteria))then return end
		if self.Poisoned and self.Owner.Role=="killer" then
			self.Owner:PrintMessage(HUD_PRINTCENTER,"This is poisoned!")
			self:SetNextPrimaryFire(CurTime()+1)
			return
		end
		sound.Play("snd_jack_hmcd_bandage.wav",self.Owner:GetShootPos(),60,math.random(90,110))
		if self.Owner.Role=="terminator" then return end
		if(self.Poisoned)then
			HMCD_Poison(self.Owner,self.Poisoner,"Curare")
		end
		self.Owner:ViewPunch(Angle(-10,0,0))
		self.Owner.Bleedout=math.Clamp(self.Owner.Bleedout-50,0,1000)
		if not(self.Owner.StomachContents["Painkillers"]) then self.Owner.StomachContents["Painkillers"]={} end
		table.insert(self.Owner.StomachContents["Painkillers"],120)
		if not(self.Owner.DigestedContents["HealthJuice"]) then self.Owner.DigestedContents["HealthJuice"]=0 end
		self.Owner.DigestedContents["HealthJuice"]=self.Owner.DigestedContents["HealthJuice"]+50
		if self.Owner.ZombieBacteria and not(self.Infected) then
			self.Owner:RemoveBacteria(100)
		end
		if self.Infected then
			self.Owner:AddBacteria(45,CurTime()-101)
		end
		self.Owner:RemoveAllDecals()
		if IsValid(self.Owner.FakeWep) and self.Owner.FakeWep.Amount then self.Owner.FakeWep.Amount=self.Owner.FakeWep.Amount-1 end
		self:SetAmount(self:GetAmount()-1)
		self:SetNextPrimaryFire(CurTime()+2)
		self:SetNextSecondaryFire(CurTime()+2)
		if self:GetAmount()==0 then
			self:Remove()
		end
	end
end

function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime()+1)
	self.DownAmt=20
	return true
end

function SWEP:SecondaryAttack(reload)
	if(self.Owner:KeyDown(IN_SPEED))then return end
	if IsValid(self.Owner.fakeragdoll) and not(reload) then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if(SERVER)then
		local startPos
		local filter=self.Owner
		if IsValid(self.Owner.fakeragdoll) then
			filter={self.Owner,self.Owner.fakeragdoll,self.Owner.fakeragdoll.Wep}
			startPos=self.Owner.fakeragdoll:GetBonePosition(self.Owner.fakeragdoll:LookupBone("ValveBiped.Bip01_R_Hand"))
		else
			startPos=self.Owner:GetShootPos()
		end
		local tr=util.QuickTrace(startPos,self.Owner:GetAimVector()*50,filter)
		local Dude,Pos=tr.Entity,tr.HitPos
		local canHeal=false
		if not(IsValid(Dude)) then return end
		if IsValid(Dude:GetRagdollOwner()) then canHeal=true Dude=Dude:GetRagdollOwner() end
		if (Dude:IsPlayer()) then canHeal=true end
		local hasBacteria=false
		if Dude.ZombieBacteria then
			for i,tabl in pairs(Dude.ZombieBacteria) do
				if CurTime()-tabl[2]<100 then hasBacteria=true break end
			end
		end
		if((IsValid(Dude))and(canHeal)and((Dude.Bleedout>0)or(Dude:Health()<100)or(hasBacteria)))then
			sound.Play("snd_jack_hmcd_bandage.wav",Pos,60,math.random(90,110))
			if Dude:IsPlayer() and Dude.Role!="terminator" then
				Dude:ViewPunch(Angle(-10,0,0))
				Dude.Bleedout=math.Clamp(Dude.Bleedout-70,0,1000)
				if not(Dude.StomachContents["Painkillers"]) then Dude.StomachContents["Painkillers"]={} end
				table.insert(Dude.StomachContents["Painkillers"],120)
				if not(Dude.DigestedContents["HealthJuice"]) then Dude.DigestedContents["HealthJuice"]=0 end
				Dude.DigestedContents["HealthJuice"]=Dude.DigestedContents["HealthJuice"]+50
				if Dude.ZombieBacteria then
					Dude:RemoveBacteria(100)
				end
				if self.Infected then
					Dude:AddBacteria(45,CurTime()-101)
				end
				Dude:RemoveAllDecals()
				if self.Poisoned then HMCD_Poison(Dude,self.Owner,"Curare") end
			end
			if IsValid(self.Owner.FakeWep) and self.Owner.FakeWep.Amount then self.Owner.FakeWep.Amount=self.Owner.FakeWep.Amount-1 end
			self:SetAmount(self:GetAmount()-1)
			self:SetNextPrimaryFire(CurTime()+2)
			self:SetNextSecondaryFire(CurTime()+2)
			if self:GetAmount()==0 then
				self:Remove()
			end
		end
	end
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
	if IsValid(self.Owner.fakeragdoll) and self:GetNextSecondaryFire()<CurTime() then
		self:SecondaryAttack(true)
	end
end

function SWEP:HMCDOnDrop()
	local Ent=ents.Create(self.ENT)
	Ent.HmcdSpawned=self.HmcdSpawned
	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
	Ent.Amount=self:GetAmount()
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
		if not(self.DownAmt)then self.DownAmt=0 end
		if(self.Owner:KeyDown(IN_SPEED))then
			self.DownAmt=math.Clamp(self.DownAmt+.2,0,20)
		else
			self.DownAmt=math.Clamp(self.DownAmt-.2,0,20)
		end
		pos=pos-ang:Up()*(self.DownAmt+8)+ang:Forward()*25+ang:Right()*12
		ang:RotateAroundAxis(ang:Forward(),-90)
		return pos,ang
	end
	function SWEP:DrawWorldModel()
		local Pos,Ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		if(self.DatWorldModel)then
			if((Pos)and(Ang)and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
				self.DatWorldModel:SetRenderOrigin(Pos+Ang:Forward()*3)
				Ang:RotateAroundAxis(Ang:Up(),90)
				Ang:RotateAroundAxis(Ang:Right(),90)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel=ClientsideModel("models/w_models/weapons/w_eq_medkit.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
		end
	end
end