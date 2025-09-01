--[[if(SERVER)then
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

SWEP.Base="wep_jack_hmcd_grenade_base"
SWEP.ViewModel = "models/weapons/c_grenade_h.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_grenade");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_grenade"
SWEP.PrintName = "M83 Frag Grenade"
SWEP.Instructions	= "This is an offensive hand grenade manufactured by the combine.\n\nLeft click to arm and throw."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=3
SWEP.SwayScale=3
SWEP.Weight	= 3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false
SWEP.ViewModelFlip=false
SWEP.UseHands=true
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
SWEP.CarryWeight=1000
SWEP.Hidden=100
SWEP.NextBeep=0
SWEP.TickInterval=1.5
SWEP.TickAmount=0
SWEP.Stackable=true
SWEP.CommandDroppable=true
SWEP.ENT="ent_jack_hmcd_grenade"
SWEP.PullPinAnim="draw"
SWEP.PullPinRate=.75
SWEP.PinOutSound="weapons/m67/m67_pullpin.wav"
SWEP.ThrowSound="weapons/m67/m67_throw_01.wav"
SWEP.ThrowReadyDelay=1.5
SWEP.PinOutTime=.57
SWEP.Riggable=true
SWEP.RigRate=1
SWEP.RigPinTime=.45
SWEP.RigTime=1.2
SWEP.RigAnim="draw"
SWEP.RigReturnTime=1
SWEP.RigNextFire=3
SWEP.DrawAnim="drawbacklow"
SWEP.RotateRigGrenade=Angle(0,0,90)
SWEP.CustomTimer=true

function SWEP:SetupDataTables()
	self:NetworkVar("Bool",0,"SpoonOut")
	self:NetworkVar("Float",0,"NextBeep")
	self:NetworkVar("Float",1,"TickInterval")
	self:NetworkVar("Int",0,"Amount")
end

function SWEP:Initialize()
	self:SetSpoonOut(false)
	self:SetNextBeep(0)
	self:SetTickInterval(1.5)
	self:SetAmount(3)
	self:SetHoldType("grenade")
	self.Thrown=false
end

function SWEP:OnStartPrimary()
	self.Hidden=0
	timer.Simple(1,function()
		if IsValid(self) and self.Owner!=NULL and self.Owner:GetActiveWeapon()==self then
			self:DoBFSAnimation("drawbackhigh")
		end
	end)
end

function SWEP:OnStartSecondary()
	self.Hidden=0
end

function SWEP:Deploy()
	if not(IsFirstTimePredicted())then return end
	self.DownAmt=10
	self.Hidden=100
	self:SetSpoonOut(false)
	self:SetNextBeep(0)
	self:DoBFSAnimation("deploy")
	self.Owner:GetViewModel():SetPlaybackRate(.6)
	self:SetNextPrimaryFire(CurTime()+1)
	self:SetNextSecondaryFire(CurTime()+1)
	return true
end

function SWEP:OnSpawnGrenade(Grenade)
	Grenade.TickAmount=self.TickAmount
	Grenade.NextBeep=self.NextBeep
	Grenade.TickInterval=self.TickInterval
end

function SWEP:OnEjectSpoon()
	if CLIENT then return end
	local thrower=self.Owner
	if IsValid(thrower.fakeragdoll) then
		thrower=thrower.fakeragdoll
		local grenade=thrower.Wep
		if grenade.PinOutModel then
			--grenade:SetModel(grenade.PinOutModel)
			--grenade:PhysicsInit(SOLID_VPHYSICS)
				
			--local phys=grenade:GetPhysicsObject()
			--phys:Wake()
		end
	end
end

function SWEP:Think()
	if self.SpawnedSpoon then
		if self.NextBeep<CurTime() or self.NextBeep==nil then
			self.NextBeep = CurTime()+self.TickInterval
			self:EmitSound("weapons/grenade/tick1.wav")
			self.TickInterval=math.max(self.TickInterval/2,0.3)
			self.TickAmount=self.TickAmount+1
			if self.TickAmount==6 then
				if SERVER then
					self:DropGrenade()
				end
				self:SetNextPrimaryFire(CurTime()+4)
				self.PinOut=false
				self.TickAmount=0
				self.TickInterval=1.5
				self.NextBeep=0
				self.SpawnedSpoon=false
				self:SetSpoonOut(false)
				self:SetNextBeep(0)
				self:SetTickInterval(1.5)
			end
		end
	end
	if self.PinOut and self.ReadyToThrow then
		if self.Owner:KeyDown(IN_ATTACK) and self.Owner:KeyDown(self:GetSpoonReleaseKey()) and not(self.SpawnedSpoon) then
			self:SetSpoonOut(true)
			self:EjectSpoon()
			if SERVER and IsValid(self.Owner.fakeragdoll) then
				local nade=self.Owner.fakeragdoll.Wep
				nade:SetArmed(true)
				print(self.NextBeep,"hey")
				nade:SetNextBeep(math.max(self.NextBeep-CurTime(),0))
				nade:SetTickInterval(self.TickInterval)
			end
		end
		if not(self.Owner:KeyDown(IN_ATTACK)) then
			self.SpawnedSpoon=false
			self:SetSpoonOut(false)
			self:SetNextBeep(0)
			self:SetTickInterval(1.5)
			self.PinOut=false
			timer.Simple(1,function()
				if IsValid(self) then
					self.TickAmount=0
					self.TickInterval=1.5
					self.NextBeep=0
				end
			end)
			self:DoBFSAnimation("throw")
			self:EmitSound("weapons/m67/m67_throw_01.wav")
			self.Owner:GetViewModel():SetPlaybackRate(1.5)
			self.Owner:SetAnimation(PLAYER_ATTACK1)
			self.Owner:ViewPunch(Angle(-10,-5,0))
			timer.Simple(0.15,function()
				if(IsValid(self))then
					self.Owner:ViewPunch(Angle(20,10,0))
				end
			end)
			timer.Simple(0.35,function()
				if(IsValid(self))then
					self:ThrowGrenade()
				end
			end)
			self:SetNextPrimaryFire(CurTime()+1)
			self:SetNextSecondaryFire(CurTime()+1)
			if self:GetAmount()==0 and SERVER then self.NotLoot=true timer.Simple(1,function() if(IsValid(self))then self:Remove() end end) end
		end
	end
	if(SERVER)then
		local HoldType="grenade"
		if(self.Owner:KeyDown(IN_SPEED))then
			HoldType="normal"
		end
		self:SetHoldType(HoldType)
	end
end

if(CLIENT)then

	local DownAmt=0
	function SWEP:GetViewModelPosition(pos,ang)
		if not(self.DownAmt)then self.DownAmt=0 end
		if self.Owner:KeyDown(IN_SPEED) and not(self.Owner:KeyDown(IN_ATTACK)) then
			self.DownAmt=math.Clamp(self.DownAmt+.2,0,20)
		else
			self.DownAmt=math.Clamp(self.DownAmt-.2,0,20)
		end
		pos=pos-ang:Up()*(self.DownAmt+self.Hidden)+ang:Forward()*-1+ang:Right()
		return pos,ang
	end
	
	local mat_glow=Material( "sprites/redglow1")
	
	function SWEP:DrawWorldModel()
		if(GAMEMODE:ShouldDrawWeaponWorldModel(self))then
			if self:GetSpoonOut() then
				if not(self.WModel)then
					self.WModel=ClientsideModel("models/weapons/w_npcnade.mdl")
					self.WModel:SetPos(self.Owner:GetPos())
					self.WModel:SetParent(self.Owner)
					self.WModel:SetNoDraw(true)
				end
				local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
				if((pos)and(ang))then
					self.WModel:SetRenderOrigin(pos+ang:Forward()*3+ang:Right()*2+ang:Up()*0)
					ang:RotateAroundAxis(ang:Forward(),180)
					ang:RotateAroundAxis(ang:Right(),-15)
					ang:RotateAroundAxis(ang:Up(),70)
					self.WModel:SetRenderAngles(ang)
					self.WModel:DrawModel()
				end
				if self.NextBeep<CurTime() then
					self.material=mat_glow
					self.NextBeep=CurTime()+self:GetTickInterval()
					self:SetNextBeep(self.NextBeep)
					timer.Simple(.1,function()
						if IsValid(self) then
							self.material=nil
						end
					end)
				end
			else
				if IsValid(self.WModel) then self.WModel:Remove() self.WModel=nil end
				self:DrawModel()
			end
			if self.material then
				local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
				render.SetMaterial(self.material)
				render.DrawSprite( pos+ang:Up()*-3.7+ang:Right()*3+ang:Forward()*4, 13, 13, color_white)
			end
		end
	end
end]]

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
SWEP.ViewModel = "models/weapons/c_grenade_h.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_grenade");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_grenade"
SWEP.PrintName = "M83 Frag Grenade"
SWEP.Instructions	= "This is an offensive hand grenade manufactured by the combine.\n\nLeft click to arm and throw."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=3
SWEP.SwayScale=3
SWEP.Weight	= 3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false
SWEP.ViewModelFlip=false
SWEP.UseHands=true
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
SWEP.CarryWeight=1000
SWEP.Hidden=100
SWEP.PinOut=false
SWEP.SpawnedSpoon=false
SWEP.NextBeep=0
SWEP.NextTime=1.5
SWEP.TickAmount=0
SWEP.Stackable=true
SWEP.CommandDroppable=true
SWEP.ENT="ent_jack_hmcd_grenade"

function SWEP:SetupDataTables()
	self:NetworkVar("Bool",0,"Spoon")
	self:NetworkVar("Float",0,"Beeping")
	self:NetworkVar("Float",1,"NextTime")
	self:NetworkVar("Int",0,"Amount")
end

function SWEP:Holster(newWep)
	self.PinOut=false
	return true
end

function SWEP:Initialize()
	self:SetSpoon(false)
	self:SetBeeping(0)
	self:SetNextTime(1.5)
	self:SetAmount(3)
	self:SetHoldType("grenade")
	self.Thrown=false
end

function SWEP:HMCDOnDrop()
	local Ent=ents.Create(self.ENT)
	Ent.HmcdSpawned=self.HmcdSpawned
	Ent:SetPos(self:GetPos()+Vector(0,0,40))
	Ent:SetAngles(self:GetAngles())
	Ent:Spawn()
	Ent:Activate()
	Ent:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector()*165+self:GetVelocity()/2)
	self:SetAmount(self:GetAmount()-1)
	if self:GetAmount()==0 then self:Remove() end
end

function SWEP:SecondaryAttack()
	--
end

function SWEP:PrimaryAttack()
	if not(IsFirstTimePredicted())then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	self.Hidden=0
	self.ReadyToThrow=false
	self:DoBFSAnimation("draw")
	timer.Simple(1,function()
		if IsValid(self) and self.Owner!=NULL and self.Owner:GetActiveWeapon()==self then
			self:DoBFSAnimation("drawbackhigh")
		end
	end)
	self.Owner:GetViewModel():SetPlaybackRate(.75)
	timer.Simple(.57,function()
		if IsValid(self) and self.Owner!=NULL and self.Owner:GetActiveWeapon()==self then
			self.PinOut=true
			self:EmitSound("weapons/m67/m67_pullpin.wav")
		end
	end)
	timer.Simple(1.5,function()
		if IsValid(self) and self.Owner!=NULL and self.Owner:GetActiveWeapon()==self then
			self.ReadyToThrow=true
			if not(self.Owner:KeyDown(IN_ATTACK)) then self:EmitSound("weapons/m67/m67_throw_01.wav") end
		end
	end)
	self:SetNextPrimaryFire(CurTime()+4)
	self:SetNextSecondaryFire(CurTime()+4)
end

function SWEP:Deploy()
	if not(IsFirstTimePredicted())then return end
	--for i=0,10 do PrintTable(self.Owner:GetViewModel():GetAnimInfo(i)) end
	self.DownAmt=10
	self.Hidden=100
	self:SetSpoon(false)
	self:SetBeeping(0)
	self:DoBFSAnimation("deploy")
	self.Owner:GetViewModel():SetPlaybackRate(.6)
	self:SetNextPrimaryFire(CurTime()+1)
	self:SetNextSecondaryFire(CurTime()+1)
	return true
end

function SWEP:ThrowGrenade()
	if(CLIENT)then return end
	self.Owner:SetLagCompensated(true)
	local Grenade=ents.Create("ent_jack_hmcd_grenade")
	Grenade.HmcdSpawned=self.HmcdSpawned
	Grenade:SetAngles(VectorRand():Angle())
	Grenade:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector())
	Grenade.Owner=self.Owner
	Grenade.SpawnedSpoon=self.SpawnedSpoon
	Grenade.TickAmount=self.TickAmount
	Grenade:SetBeeping(self.NextBeep)
	Grenade:SetNextTime(self.NextTime)
	Grenade.CollisionGroup=COLLISION_GROUP_NONE
	Grenade:Arm()
	Grenade:Spawn()
	Grenade:Activate()
	Grenade:GetPhysicsObject():SetVelocity(self.Owner:GetVelocity()+self.Owner:GetAimVector()*1000)
	self.Owner:SetLagCompensated(false)
end

function SWEP:DropGrenade()
	if(CLIENT)then return end
	self.Owner:SetLagCompensated(true)
	local Grenade=ents.Create("ent_jack_hmcd_grenade")
	Grenade.HmcdSpawned=self.HmcdSpawned
	Grenade:SetAngles(VectorRand():Angle())
	Grenade:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector())
	Grenade.Owner=self.Owner
	Grenade.SpawnedSpoon=self.SpawnedSpoon
	Grenade.TickAmount=self.TickAmount
	Grenade:SetBeeping(self.NextBeep)
	Grenade:SetNextTime(self.NextTime)
	Grenade.CollisionGroup=COLLISION_GROUP_NONE
	Grenade:Arm()
	Grenade:Spawn()
	Grenade:Activate()
	Grenade:GetPhysicsObject():SetVelocity(self.Owner:GetVelocity())
	self.Owner:SetLagCompensated(false)
end

function SWEP:Think()
	if self.SpawnedSpoon then
		if self.NextBeep<CurTime() or self.NextBeep==nil then
			self.NextBeep = CurTime()+self.NextTime
			self:EmitSound("weapons/grenade/tick1.wav")
			self.NextTime=self.NextTime/2
			if self.NextTime < 0.3 then self.NextTime = 0.3 end
			self.TickAmount = self.TickAmount + 1
			if self.TickAmount == 6 then
				self:SetNextPrimaryFire(CurTime()+4)
				self.PinOut=false
				self:SetAmount(self:GetAmount()-1)
				self.TickAmount=0
				self.NextTime=1.5
				self.NextBeep=0
				self.SpawnedSpoon=false
				self:SetSpoon(false)
				self:SetBeeping(0)
				self:SetNextTime(1.5)
				if SERVER then
					self.Owner:SetLagCompensated(true)
					local Grenade=ents.Create("ent_jack_hmcd_grenade")
					Grenade.HmcdSpawned=self.HmcdSpawned
					Grenade:SetAngles(VectorRand():Angle())
					Grenade:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector())
					Grenade.Owner=self.Owner
					Grenade.SpawnedSpoon=self.SpawnedSpoon
					Grenade:Spawn()
					Grenade:Activate()
					Grenade:Detonate()
					Grenade:GetPhysicsObject():SetVelocity(self.Owner:GetVelocity())
					self.Owner:SetLagCompensated(false)
				end
			end
		end
	end
	if self.PinOut and self.ReadyToThrow then
		if self.Owner:KeyDown(IN_ATTACK) and self.Owner:KeyDown(IN_ATTACK2) and not(self.SpawnedSpoon) then
			self.SpawnedSpoon=true
			self:SetSpoon(true)
			if SERVER then
				sound.Play("weapons/m67/m67_spooneject.wav",self:GetPos(),65,100)
				local Spoon=ents.Create("prop_physics")
				Spoon.HmcdSpawned=self.HmcdSpawned
				Spoon:SetModel("models/weapons/arc9/darsu_eft/skobas/m67_skoba.mdl")
				Spoon:SetCollisionGroup(COLLISION_GROUP_WEAPON)
				Spoon:SetPos(self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")))
				Spoon:SetAngles(self.Owner:GetAngles())
				Spoon:SetNWBool("NoIED",true)
				Spoon:Spawn()
				Spoon:Activate()
			end
		end
		if not(self.Owner:KeyDown(IN_ATTACK)) then
			self:SetAmount(self:GetAmount()-1)
			self.SpawnedSpoon=false
			self:SetSpoon(false)
			self:SetBeeping(0)
			self:SetNextTime(1.5)
			self.PinOut=false
			timer.Simple(1,function()
				if IsValid(self) then
					self.TickAmount=0
					self.NextTime=1.5
					self.NextBeep=0
				end
			end)
			self:DoBFSAnimation("throw")
			self:EmitSound("weapons/m67/m67_throw_01.wav")
			self.Owner:GetViewModel():SetPlaybackRate(1.5)
			self.Owner:SetAnimation(PLAYER_ATTACK1)
			self.Owner:ViewPunch(Angle(-10,-5,0))
			timer.Simple(0.15,function()
				if(IsValid(self))then
					self.Owner:ViewPunch(Angle(20,10,0))
				end
			end)
			timer.Simple(0.35,function()
				if(IsValid(self))then
					self:ThrowGrenade()
				end
			end)
			self:SetNextPrimaryFire(CurTime()+1)
			self:SetNextSecondaryFire(CurTime()+1)
		end
	end
	if(SERVER)then
		local HoldType="grenade"
		if(self.Owner:KeyDown(IN_SPEED))then
			HoldType="normal"
		end
		self:SetHoldType(HoldType)
		if self:GetAmount()==0 then self.NotLoot=true timer.Simple(1,function() if(IsValid(self))then self:Remove() end end) end
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
		pos=pos-ang:Up()*(self.DownAmt+self.Hidden)+ang:Forward()*-1+ang:Right()
		return pos,ang
	end
	function SWEP:DrawWorldModel()
		if(GAMEMODE:ShouldDrawWeaponWorldModel(self))then
			if self:GetSpoon() then
				if not(self.WModel)then
					self.WModel=ClientsideModel("models/weapons/w_npcnade.mdl")
					self.WModel:SetPos(self.Owner:GetPos())
					self.WModel:SetParent(self.Owner)
					self.WModel:SetNoDraw(true)
				end
				local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
				if((pos)and(ang))then
					self.WModel:SetRenderOrigin(pos+ang:Forward()*3+ang:Right()*2)
					ang:RotateAroundAxis(ang:Forward(),180)
					ang:RotateAroundAxis(ang:Right(),-15)
					ang:RotateAroundAxis(ang:Up(),70)
					self.WModel:SetRenderAngles(ang)
					self.WModel:DrawModel()
				end
				if self.NextBeep<CurTime() then
					self.material = Material( "sprites/redglow1")
					self.NextBeep = CurTime()+self:GetNextTime()
					self:SetBeeping(self.NextBeep)
					timer.Simple(.1,function()
						self.material = nil
					end)
				end
			else
				if IsValid(self.WModel) then self.WModel:Remove() self.WModel=nil end
				self:DrawModel()
			end
			if self.material then
				local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
				cam.Start3D()
					render.SetMaterial( self.material )
					render.DrawSprite( pos+ang:Up()*-3.7+ang:Right()*3+ang:Forward()*4, 13, 13, color_white)
				cam.End3D()
			end
		end
	end
end