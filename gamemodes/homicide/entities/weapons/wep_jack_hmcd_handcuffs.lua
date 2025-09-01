if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	SWEP.ViewModelFOV = 55

	SWEP.Slot = 1
	SWEP.SlotPos = 3

	killicon.AddFont("wep_jack_hmcd_axe", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))

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

SWEP.ViewModel = "models/weapons/spy/handcuffs.mdl"
SWEP.WorldModel = "models/weapons/spy/w_handcuffs.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_handcuffs");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_handcuffs"
SWEP.PrintName = "Handcuffs"
SWEP.Instructions	= "This is a restraint device designed to secure an individual's wrists in proximity to each other.\nLMB to put them on the detained person."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=3
SWEP.SwayScale=3
SWEP.Weight	= 3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.CommandDroppable=true
SWEP.ENT="ent_jack_hmcd_handcuffs"

SWEP.Spawnable			= true
SWEP.AdminOnly			= true

SWEP.Primary.Delay			= 0.5
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 30
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
SWEP.DeathDroppable=false
SWEP.HomicideSWEP=true
SWEP.CarryWeight=500
SWEP.Stackable=true

function SWEP:Initialize()
	self:SetHoldType("slam")
	self:SetAmount(1)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Int",0,"Amount")
end

function SWEP:PrimaryAttack()
	local Ent,HitPos,HitNorm=HMCD_WhomILookinAt(self.Owner,.5,80)
	if not(IsValid(Ent)) then return end
	if not(Ent:IsPlayer() or Ent:GetClass()=="prop_ragdoll") then return end
	if (Ent.CuffedBehind or Ent.CuffedFront) then return end
	--for i=0,10 do PrintTable(self.Owner:GetViewModel():GetAnimInfo(i)) end
	if not(self.Owner.Stamina) then return end
	if(self.Owner.Stamina<25)then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	if not(IsFirstTimePredicted())then
		timer.Simple(.2,function() if(IsValid(self))then self:DoBFSAnimation("aim") end end)
		return
	end
	self:DoBFSAnimation("fire")
	self:SetNextPrimaryFire(CurTime()+6)
	timer.Simple(.1,function()
		if(IsValid(self))then
			self.Owner:SetAnimation(PLAYER_ATTACK1)
		end
	end)
	timer.Simple(.2,function()
		if(IsValid(self))then
			--self:DoBFSAnimation("punch")
			timer.Simple(.1,function()
				if(IsValid(self) and IsValid(self.Owner) and IsValid(HMCD_WhomILookinAt(self.Owner,.5,80)) and (HMCD_WhomILookinAt(self.Owner,.5,80):IsPlayer() or HMCD_WhomILookinAt(self.Owner,.5,80):GetClass()=="prop_ragdoll"))then
					self:Cuff()
				end
			end)
		end
	end)
end

function SWEP:Deploy()
	if not(IsFirstTimePredicted())then
		self:DoBFSAnimation("draw")
		self.Owner:GetViewModel():SetPlaybackRate(1)
		return
	end
	self:DoBFSAnimation("draw")
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self:SetNextPrimaryFire(CurTime()+.5)
	return true
end

function SWEP:SecondaryAttack()
	--
end
function SWEP:Think()
	if SERVER then
		if self.Suspect then
			local Ent=util.QuickTrace(self.Owner:GetShootPos(),self.Owner:GetAimVector()*80,{self.Owner}).Entity
			if not(IsValid(Ent)) or self.Suspect!=Ent or self.Owner.fake then
				if timer.Exists(tostring(self.Owner).."ArrestTimer") then
					self.Suspect=nil
					timer.Remove(tostring(self.Owner).."ArrestTimer")
					if self:GetAmount()>0 then
						self:DoBFSAnimation("draw")
					end
					self:SetNextPrimaryFire(CurTime()+1)
					self:SetNextSecondaryFire(CurTime()+1)
				end
			end
		end
	end
end

function SWEP:Cuff()
	if(CLIENT)then return end
	self.Owner:LagCompensation(true)
	local Ent=HMCD_WhomILookinAt(self.Owner,.5,80)
	local delay = 5
	if Ent:GetClass() == "prop_ragdoll" then delay = 2 end
	local AimVec,Mul=self.Owner:GetAimVector(),1
	sound.Play("weapons/357/357_reload1.wav",self.Owner:GetShootPos(),65,math.random(60,70))
	self.Owner:LagCompensation(false)
	self.Suspect=Ent
	timer.Create(tostring(self.Owner).."ArrestTimer", delay, 1, function()
		local Tr=util.QuickTrace(self.Owner:GetShootPos(),self.Owner:GetAimVector()*60,{self.Owner})
		local pos,ang=Ent:GetBonePosition(Ent:LookupBone("ValveBiped.Bip01_Spine2"))
		local front,back=ang:Right()*-10,ang:Right()*5
		local IsBehind = Tr.HitPos:DistToSqr(pos+front)>Tr.HitPos:DistToSqr(pos+back)
		self.Suspect=nil
		Ent.CuffedBehind=IsBehind
		Ent.CuffedFront=not(IsBehind)
		self:DoBFSAnimation("draw")
		if Ent:IsRagdoll() then
			local sets=0
			local dir=7
			if Ent.CuffedFront or Ent.TiedFront then dir=-10 end
			local pos,ang = Ent:GetBonePosition(Ent.spine_bone)
			local hand2 = Ent:GetPhysicsObjectNum(Ent:TranslateBoneToPhysBone(Ent.lhand_bone))	
			local hand1 = Ent:GetPhysicsObjectNum(Ent:TranslateBoneToPhysBone(Ent.rhand_bone))
			hand1:Wake()
			hand2:Wake()
			local index=self.Owner:EntIndex()
			hook.Add("Think",index.."Uncuff",function()
				if not(IsValid(hand1)) then hook.Remove("Think",index.."Uncuff") return end
				hand1:SetPos(pos+ang:Right()*dir)
				hand2:SetPos(pos+ang:Right()*dir)
			end)
			local ownerInd=self.Owner:EntIndex()
			timer.Simple(.1,function()
				hook.Remove("Think",ownerInd.."Uncuff")
				Ent.handcuffs=constraint.Weld( Ent, Ent, 7, 5, 0, false, false )
			end)
		end
		local owner=Ent
		if owner:IsRagdoll() and IsValid(owner:GetRagdollOwner()) and owner:GetRagdollOwner():Alive() then owner=owner:GetRagdollOwner() end
		if owner:IsPlayer() then
			net.Start("hmcd_cuffed")
			net.WriteBit(true)
			net.Send(owner)
			if owner.Role=="killer" and not(GAMEMODE.Mode=="Zombie") then
				GAMEMODE:EndTheRound(7,self.Owner)
			end
			local add=0
			owner.CuffedBehind=IsBehind
			owner.CuffedFront=not(IsBehind)
			if owner.CuffedFront then add=30 end
			owner:ManipulateBoneAngles(owner:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(20-add, 8.8-add, 0))
			owner:ManipulateBoneAngles(owner:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(15, 0-add, 0))
			owner:ManipulateBoneAngles(owner:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0-add, 75))
			owner:ManipulateBoneAngles(owner:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(-15, 0-add, 0))
			owner:ManipulateBoneAngles(owner:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0-add, -75))
			owner:ManipulateBoneAngles(owner:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(-20+add*0.5, 16.6-add, 0))
			owner:SelectWeapon("wep_jack_hmcd_hands")
		end
		self:SetAmount(self:GetAmount()-1)
		if self:GetAmount()==0 then self:Remove() end
	end)
end

function SWEP:Reload()
	--
end

function SWEP:DoBFSAnimation(anim)
	local vm=self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
end

function SWEP:Holster()
	if timer.Exists(tostring(self.Owner).."ArrestTimer") then
		self.Suspect=nil
		timer.Remove(tostring(self.Owner).."ArrestTimer")
	end
	return true
end

function SWEP:HMCDOnDrop()
	local Ent=ents.Create(self.ENT)
	Ent.HmcdSpawned=self.HmcdSpawned
	Ent:SetPos(self.Owner:GetPos()+Vector(0,0,50))
	Ent:SetAngles(self:GetAngles())
	Ent.Poisoned=self.Poisoned
	Ent:Spawn()
	Ent:Activate()
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity()/2+self.Owner:GetAimVector()*250)
	self:SetAmount(self:GetAmount()-1)
	if self:GetAmount()==0 then self:Remove() end
end

if(CLIENT)then
	local DownAmt=0
	function SWEP:GetViewModelPosition(pos,ang)
		if(self.Owner:KeyDown(IN_SPEED))then
			DownAmt=math.Clamp(DownAmt+.6,0,50)
		elseif(self.Owner.HasCuffs==false)then
			DownAmt=math.Clamp(DownAmt+.6,0,50)
		else
			DownAmt=math.Clamp(DownAmt-.6,0,50)
		end
		ang:RotateAroundAxis(ang:Forward(),-10)
		return pos+ang:Up()*-2-ang:Forward()*(DownAmt-5)-ang:Up()*DownAmt+ang:Right()*3,ang
	end
	function SWEP:DrawWorldModel()
		local Pos,Ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		if(self.DatWorldModel)then
			if((Pos)and(Ang)and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
				self.DatWorldModel:SetRenderOrigin(Pos+Ang:Forward()*12+Ang:Right()*-8-Ang:Up()*14)
				Ang:RotateAroundAxis(Ang:Up(),270)
				Ang:RotateAroundAxis(Ang:Right(),0)
				Ang:RotateAroundAxis(Ang:Forward(),170)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel=ClientsideModel("models/weapons/spy/handcuffs.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
		end
	end
end