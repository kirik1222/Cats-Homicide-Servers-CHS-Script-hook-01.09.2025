if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 50
	SWEP.Slot = 4
	SWEP.SlotPos = 2
	killicon.AddFont("wep_jack_hmcd_oldgrenade", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))
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
SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = "models/props_combine/combine_mine01.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_breachcharge");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_breachcharge"
SWEP.PrintName = "Breach Charge"
SWEP.Instructions	= "This is an explosive device used to force open closed and/or locked doors.\n\nLeft click to place on a door."
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
SWEP.UseHands=true
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
SWEP.CarryWeight=1000
function SWEP:Initialize()
	self:SetHoldType("slam")
	self.Thrown=false
end
function SWEP:SetupDataTables()
	--
end
function SWEP:Holster()
	if IsValid(self.Owner:GetViewModel()) then
		self.Owner:GetViewModel():ManipulateBonePosition(40,Vector(0,0,0))
	end
	return true
end
function SWEP:OnRemove()
	if self.Attached==true then
		self.Owner:GetViewModel():ManipulateBonePosition(40,Vector(0,0,0))
	end
end
function SWEP:PrimaryAttack()
	if not(IsFirstTimePredicted())then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	local Tr=util.QuickTrace(self.Owner:GetShootPos(),self.Owner:GetAimVector()*65,{self.Owner})
	if not IsValid(Tr.Entity) then return end
	if not((Tr.Entity:GetClass()=="func_door_rotating") or (Tr.Entity:GetClass()=="prop_door_rotating") or (Tr.Entity:GetClass()=="func_door") or (Tr.Entity:GetClass()=="func_physbox")) then return end
	self:DoBFSAnimation("tripmine_attach1")
	timer.Simple(.2,function()
		self:DoBFSAnimation("tripmine_attach2")
		self.Attached=true
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end)
	timer.Simple(.4,function()
		self:SetCharge()
	end)
	self:SetNextPrimaryFire(CurTime()+4)
	self:SetNextSecondaryFire(CurTime()+4)
end
function SWEP:Deploy()
	if not(IsFirstTimePredicted())then return end
	--for i=0,10 do PrintTable(self.Owner:GetViewModel():GetAnimInfo(i)) end
	self.DownAmt=10
	self.Attached=false
	self:DoBFSAnimation("tripmine_idle")
	self.Owner:GetViewModel():SetPlaybackRate(.6)
	self:SetNextPrimaryFire(CurTime()+1)
	self:SetNextSecondaryFire(CurTime()+1)
	return true
end

function SWEP:SetCharge()
	if(CLIENT)then return end
	self.Owner:SetLagCompensated(true)
	local Tr=util.QuickTrace(self.Owner:GetShootPos(),self.Owner:GetAimVector()*65,{self.Owner})
	if(Tr.Entity) and ((Tr.Entity:GetClass()=="func_door_rotating") or (Tr.Entity:GetClass()=="prop_door_rotating") or (Tr.Entity:GetClass()=="func_door") or (Tr.Entity:GetClass()=="func_physbox"))then
		local Grenade=ents.Create("ent_jack_hmcd_breachcharge")
		local Ang = Tr.HitNormal:Angle()
		Ang:RotateAroundAxis(Ang:Forward(),90)
		Ang:RotateAroundAxis(Ang:Right(),-90)
		Grenade.HmcdSpawned=self.HmcdSpawned
		Grenade:SetAngles(Ang)
		Grenade:SetPos(Tr.HitPos+Tr.HitNormal*-1)
		Grenade:SetParent(Tr.Entity)
		Grenade.Owner=self.Owner
		Grenade.Rigged=true
		Grenade:Spawn()
		Grenade:Activate()
		timer.Simple(.2,function() if(IsValid(self))then self:Remove() end end)
	end
	self.Owner:SetLagCompensated(false)
end

function SWEP:SecondaryAttack()
	local Dude,Pos=HMCD_WhomILookinAt(self.Owner,.3,50)
	--print(Dude:GetPhysicsObject():GetMass())
	--[[local vec = "Vector("..math.Round(self.Owner:GetPos().x,0)..","..math.Round(self.Owner:GetPos().y,0)..","..math.Round(self.Owner:GetPos().z+15,0).."),"
	if SERVER then
		if not huy then huy="{" end
		huy=huy..vec
	end
	local Tr=util.QuickTrace(self.Owner:EyePos(),self.Owner:EyeAngles():Forward()*1000,{self,self.Owner})
	if CLIENT then return end
	local ent = ents.Create( "hmcd_zombie" )
	ent:SetKeyValue( "disableshadows", "1" )
	ent:SetPos( Tr.HitPos +Vector(0,0,10))
	ent:SetAngles( self.Owner:GetAngles() )
	ent:SetModel( "" )
	ent.HmcdSpawned=true
	ent.Owner=self.Owner
	ent:SetColor( 255, 255, 255, 0 )
	ent.Model=self.Owner:GetModel()
	ent:Spawn()
	ent:Activate()
	local ply=player.GetAll()[2]
	if IsValid(ply.hat) then
		ply.hat:Remove()
	end
	local hat = ents.Create("ent_jack_hmcd_hat")
	if not IsValid(hat) then return end
	local accinfo=HMCD_Accessories["purse"]
	local pos,ang=ply:GetBonePosition(ply:LookupBone(accinfo[2]))
	local PosInfo=accinfo[3]
	if ply.ModelSex=="female" then PosInfo=accinfo[4] end
	pos=pos+ang:Right()*PosInfo[1].x+ang:Forward()*PosInfo[1].y+ang:Up()*PosInfo[1].z
	ang:RotateAroundAxis(ang:Right(),PosInfo[2].p)
	ang:RotateAroundAxis(ang:Up(),PosInfo[2].y)
	ang:RotateAroundAxis(ang:Forward(),PosInfo[2].r)
	hat:SetPos(pos)
	hat:SetAngles(ang)
	hat.WModel=accinfo[1]

	hat:SetParent(ply)

	ply.hat = hat

	hat:Spawn()]]
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
function SWEP:DoBFSAnimation(anim)
	if((self.Owner)and(self.Owner.GetViewModel))then
		local vm=self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
	end
end
function SWEP:FireAnimationEvent(pos,ang,event,name)
	return true -- I do all this, bitch
end
if(CLIENT)then
	local DownAmt=0
	function SWEP:GetViewModelPosition(pos,ang)
		if not(self.DownAmt)then self.DownAmt=0 end
		if(self.Owner:KeyDown(IN_SPEED))then
			self.DownAmt=math.Clamp(self.DownAmt+.2,0,20)
		else
			self.DownAmt=math.Clamp(self.DownAmt-.2,0,20)
		end
		pos=pos-ang:Up()*(self.DownAmt)+ang:Forward()*-1+ang:Right()
		return pos,ang
	end
	function SWEP:ViewModelDrawn(vm)
		if not(self.BreachCharge)then
			self.BreachCharge=ClientsideModel("models/props_combine/combine_mine01.mdl")
			self.BreachCharge:SetPos(vm:GetPos())
			self.BreachCharge:SetParent(vm)
			self.BreachCharge:SetNoDraw(true)
			self.BreachCharge:SetModelScale(.42,0)
		else
			local matr=vm:GetBoneMatrix(vm:LookupBone("ValveBiped.Bip01_R_Finger2"))
			local pos,ang=matr:GetTranslation(),matr:GetAngles()
			local Mul=0
			if self.Attached then Mul=-50 end
			self.BreachCharge:SetRenderOrigin(pos-ang:Right()*-1.2+ang:Forward()*4.3-ang:Up()*Mul)
			ang:RotateAroundAxis(ang:Up(),0)
			ang:RotateAroundAxis(ang:Forward(),90)
			ang:RotateAroundAxis(ang:Right(),30)
			self.BreachCharge:SetRenderAngles(ang)
			self.BreachCharge:DrawModel()
		end
		vm:ManipulateBonePosition(40,Vector(0,0,-50))
		--self.BreachCharge=nil
	end
	function SWEP:DrawWorldModel()
		if(GAMEMODE:ShouldDrawWeaponWorldModel(self))then
			if not(self.WModel)then
				self.WModel=ClientsideModel(self.WorldModel)
				self.WModel:SetPos(self.Owner:GetPos())
				self.WModel:SetParent(self.Owner)
				self.WModel:SetNoDraw(true)
				self.WModel:SetModelScale(.42,0)
			else
				local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
				if((pos)and(ang))then
					self.WModel:SetRenderOrigin(pos+ang:Right()+ang:Up()*1+ang:Forward()*7+ang:Right()*3)
					ang:RotateAroundAxis(ang:Forward(),150)
					ang:RotateAroundAxis(ang:Right(),10)
					self.WModel:SetRenderAngles(ang)
					self.WModel:DrawModel()
				end
			end
		end
	end
end