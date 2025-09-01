if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	SWEP.ViewModelFOV = 65

	SWEP.Slot = 5
	SWEP.SlotPos = 2

	killicon.AddFont("wep_jack_hmcd_adrenaline", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))

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

SWEP.ViewModel = "models/morphine_syrette/v_morphine.mdl"
SWEP.WorldModel = "models/morphine_syrette/morphine.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_morphine");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_morphine"
SWEP.PrintName = "Morphine Syrette"
SWEP.Instructions	= "This is a collapsible tube fitted with a hypodermic needle and containing a single dose of morphine. Use it to suppress pain and/or bring a person to consciousness.\n\nLMB to inject drug into yourself.\nRMB to inject drug into another."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=2
SWEP.SwayScale=2
SWEP.Weight	= 3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

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

SWEP.UseHands=true
SWEP.ENT="ent_jack_hmcd_morphine"
SWEP.CommandDroppable=true
SWEP.HomicideSWEP=true

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:SetupDataTables()
	--
end

function SWEP:DoBFSAnimation(anim)
	local vm=self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
end

function SWEP:PrimaryAttack()
	if not(IsFirstTimePredicted())then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	self:SetNextPrimaryFire(CurTime()+3)
	self:SetNextSecondaryFire(CurTime()+3)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:DoBFSAnimation("inject")
	if(CLIENT)then return end
	timer.Simple(2, function()
		if IsValid(self) then
			self.Owner:ViewPunch(Angle(2,0,0))
			for i=1,3 do
				sound.Play("snd_jack_hmcd_needleprick.wav",self.Owner:GetShootPos()+VectorRand(),60,math.random(90,110))
			end
		end
	end)
	local Ply,LifeID=self.Owner,self.Owner.LifeID
	timer.Simple(2.1, function()
		if IsValid(self) and self.Owner:GetActiveWeapon()==self then
			self:Remove()
			timer.Simple(1.9, function()
				if IsValid(Ply) and Ply:Alive() and LifeID==Ply.LifeID then
					if not(Ply.StomachContents["Morphine"]) then Ply.StomachContents["Morphine"]={} end
					table.insert(Ply.StomachContents["Morphine"],300)
				end
			end)
		end
	end)
end

function SWEP:Deploy()
	if not(IsFirstTimePredicted())then return end
	--self.DownAmt=8
	self:DoBFSAnimation("draw")
	self:SetNextPrimaryFire(CurTime()+1)
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:OnRemove()
	--
end

function SWEP:SecondaryAttack(reload)
	local startPos
	local filter=self.Owner
	if IsValid(self.Owner.fakeragdoll) then
		filter={self.Owner,self.Owner.fakeragdoll,self.Owner.fakeragdoll.Wep}
		startPos=self.Owner.fakeragdoll:GetBonePosition(self.Owner.fakeragdoll:LookupBone("ValveBiped.Bip01_R_Hand"))
	else
		startPos=self.Owner:GetShootPos()
	end
	local tr=util.QuickTrace(startPos,self.Owner:GetAimVector()*80,filter)
	local Ent=tr.Entity
	if not(IsValid(Ent)) then return end
	if IsValid(self.Owner.fakeragdoll) and not(reload) then return end
	if not(Ent:IsPlayer() or (Ent:IsRagdoll() and Ent.fleshy)) then return end
	self:DoBFSAnimation("inject_to_smb")
	if(CLIENT)then return end
	timer.Simple(2, function()
		if IsValid(self.Owner.fakeragdoll) then
			filter={self.Owner,self.Owner.fakeragdoll,self.Owner.fakeragdoll.Wep}
			startPos=self.Owner.fakeragdoll:GetBonePosition(self.Owner.fakeragdoll:LookupBone("ValveBiped.Bip01_R_Hand"))
		else
			startPos=self.Owner:GetShootPos()
		end
		tr=util.QuickTrace(startPos,self.Owner:GetAimVector()*80,filter)
		if IsValid(tr.Entity) and (tr.Entity:IsPlayer() or (tr.Entity:IsRagdoll() and tr.Entity.fleshy)) then
			self.Owner:ViewPunch(Angle(2,0,0))
			for i=1,3 do
				sound.Play("snd_jack_hmcd_needleprick.wav",self.Owner:GetShootPos()+VectorRand(),60,math.random(90,110))
			end
			timer.Simple(.1,function()
				if IsValid(self) then
					Ent=tr.Entity
					self:Remove()
					if IsValid(Ent:GetRagdollOwner()) and Ent:GetRagdollOwner():Alive() then Ent=Ent:GetRagdollOwner() end
					local LifeID=Ent.LifeID
					timer.Simple(4, function()
						if IsValid(Ent) and Ent:IsPlayer() then
							if not(Ent.StomachContents["Morphine"]) then Ent.StomachContents["Morphine"]={} end
							table.insert(Ent.StomachContents["Morphine"],300)
						end
					end)
				end
			end)
		else
			self:DoBFSAnimation("draw")
		end
	end)
	self:SetNextPrimaryFire(CurTime()+3)
	self:SetNextSecondaryFire(CurTime()+3)
end

function SWEP:Think()
	--
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
	Ent:Spawn()
	Ent:Activate()
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity()/2)
	self:Remove()
end

if(CLIENT)then
	function SWEP:GetViewModelPosition(pos,ang)
		if not(self.DownAmt)then self.DownAmt=8 end
		if(self.Owner:KeyDown(IN_SPEED))then
			self.DownAmt=math.Clamp(self.DownAmt+.1,0,16)
		else
			self.DownAmt=math.Clamp(self.DownAmt-.1,0,8)
		end
		local NewPos=pos+ang:Forward()*-6-ang:Up()*(3+self.DownAmt)+ang:Right()*1
		ang:RotateAroundAxis(ang:Right(),0)
		return NewPos,ang
	end
	function SWEP:DrawWorldModel()
		local Pos,Ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		if(self.DatWorldModel)then
			if((Pos)and(Ang)and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
				self.DatWorldModel:SetRenderOrigin(Pos+Ang:Forward()*6-Ang:Up()*2+Ang:Right()*1)
				Ang:RotateAroundAxis(Ang:Right(),-30)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel=ClientsideModel("models/morphine_syrette/morphine.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetModelScale(1,0)
		end
	end
	function SWEP:ViewModelDrawn()
		--
	end
end