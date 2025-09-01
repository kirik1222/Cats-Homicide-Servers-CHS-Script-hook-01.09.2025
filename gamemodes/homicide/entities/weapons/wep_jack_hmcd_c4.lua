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
		if self.PlaceChargeTime then
			local w,h=ScrW(),ScrH()
			local boxWidth,boxHeight=w/2,h/20
			surface.SetDrawColor(Color(255,255,255,255))
			surface.DrawOutlinedRect( (w-boxWidth)/2, (h-boxHeight)/2, boxWidth, boxHeight, w/200 )
			surface.DrawRect((w-boxWidth)/2, (h-boxHeight)/2, boxWidth*(CurTime()-self.PlaceChargeTime)/10,boxHeight)
		end
	end
end
SWEP.Base="weapon_base"
SWEP.ViewModel = "models/weapons/v_c4_sec.mdl"
SWEP.WorldModel = "models/weapons/w_c4_ins.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_c4_charge");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_c4_charge"
SWEP.IconLength=2
SWEP.PrintName = "M112"
SWEP.Instructions	= "This is a 1.25-pound of Composition C4 packed in a Mylar-film container with a pressure-sensitive adhesive tape on one surface.\n\nLMB to place on a surface."
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
SWEP.InsHands=true
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
SWEP.Stackable=true
SWEP.CommandDroppable=true
SWEP.ENT="ent_jack_hmcd_c4"
function SWEP:SetupDataTables()
	self:NetworkVar("Int",0,"Amount")
end

function SWEP:Initialize()
	self:SetAmount(1)
	self:SetHoldType("slam")
	self.Thrown=false
end

function SWEP:OnRemove()
	local models=self.Hints
	if CLIENT then
		timer.Simple( 0, function()
			if not IsValid( self ) then
				if models then
					for i,hint in pairs(models) do hint:Remove() end
				end
			end
		end)
	end
end

function SWEP:Holster(newWep)
	if CLIENT and self.Hints then
		for i,hint in pairs(self.Hints) do hint:Remove() end
	end
	return true
end

function SWEP:PrimaryAttack()
	if not(IsFirstTimePredicted())then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	local csInfo=HMCD_CSInfo["Hints"][game.GetMap()]
	if not(csInfo) then return end
	local Tr=util.QuickTrace(self.Owner:GetShootPos(),self.Owner:GetAimVector()*65,{self.Owner})
	local isPlanted=false
	for i,c4 in pairs(ents.FindByClass("ent_jack_hmcd_c4")) do
		if c4:GetPos():DistToSqr(Tr.HitPos)<100 then isPlanted=true break end
	end
	if not(isPlanted) then
		local hitNum
		for i,info in pairs(csInfo) do
			if Tr.HitPos:DistToSqr(info[1])<100 then hitNum=i break end
		end
		if hitNum then
			self:DoBFSAnimation("base_plant")
			timer.Simple(.4,function()
				if IsValid(self) then
					self.PlaceChargeTime=CurTime()
					self.PlaceNum=hitNum
				end
			end)
			self:SetNextPrimaryFire(CurTime()+11)
		end
	end
end
function SWEP:Deploy()
	if not(IsFirstTimePredicted())then return end
	self:DoBFSAnimation("base_draw")
	if CLIENT then
		if not(self.Hints) then self.Hints={} end
		if HMCD_CSInfo["Hints"][game.GetMap()] then
			for i,info in pairs(HMCD_CSInfo["Hints"][game.GetMap()]) do
				local isPlanted=false
				for i,c4 in pairs(ents.FindByClass("ent_jack_hmcd_c4")) do
					if c4:GetPos()==info[1] then isPlanted=true break end
				end
				if not(isPlanted) then
					self.Hints[i]=ClientsideModel(self.WorldModel)
					self.Hints[i]:SetPos(info[1])
					self.Hints[i]:SetAngles(info[2])
					self.Hints[i]:SetMaterial("models/debug/debugwhite")
					self.Hints[i]:SetRenderMode(RENDERMODE_TRANSCOLOR)
					self.Hints[i]:SetColor(Color(255,255,0,50))
				end
			end
		end
	end
	self:SetNextPrimaryFire(CurTime()+1)
	return true
end

function SWEP:SecondaryAttack()
	--
end

function SWEP:Think()
	if(SERVER)then
		local HoldType="slam"
		if(self.Owner:KeyDown(IN_SPEED))then
			HoldType="normal"
		end
		self:SetHoldType(HoldType)
	end
	if self.PlaceChargeTime then
		local Tr=self.Owner:GetEyeTrace()
		if not(self.Owner:KeyDown(IN_ATTACK)) or Tr.HitPos:DistToSqr(HMCD_CSInfo["Hints"][game.GetMap()][self.PlaceNum][1])>100 then self.PlaceChargeTime=nil self.PlaceNum=nil self:SetNextPrimaryFire(CurTime()+1) self:DoBFSAnimation("base_draw") end
		if self.PlaceChargeTime and self.PlaceChargeTime+10<CurTime() then
			self.PlaceChargeTime=nil
			if SERVER then
				local info=HMCD_CSInfo["Hints"][game.GetMap()][self.PlaceNum]
				local Charge=ents.Create("ent_jack_hmcd_c4")
				Charge.HmcdSpawned=self.HmcdSpawned
				Charge:SetAngles(info[2])
				Charge:SetPos(info[1])
				Charge.Owner=self.Owner
				Charge:Spawn()
				Charge:Activate()
				Charge.Constraint=constraint.Weld(Charge,Tr.Entity,0,0,0,true,false)
				self:SetAmount(self:GetAmount()-1)
				timer.Simple(.2,function()
					if IsValid(self) then
						if self:GetAmount()==0 then
							self:Remove()
						else
							self:DoBFSAnimation("base_draw")
						end
					end
				end)
			end
			if CLIENT and self.Hints then
				self.Hints[self.PlaceNum]:Remove()
			end
			self.PlaceNum=nil
		end
	end
end

function SWEP:HMCDOnDrop()
	if IsValid(self.Owner) then
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
	function SWEP:DrawWorldModel()
		if(GAMEMODE:ShouldDrawWeaponWorldModel(self))then
			if not(self.WModel)then
				self.WModel=ClientsideModel(self.WorldModel)
				self.WModel:SetPos(self.Owner:GetPos())
				self.WModel:SetParent(self.Owner)
				self.WModel:SetNoDraw(true)
			else
				local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
				if((pos)and(ang))then
					self.WModel:SetRenderOrigin(pos+ang:Forward()*2+ang:Right()*3)
					ang:RotateAroundAxis(ang:Forward(),90)
					ang:RotateAroundAxis(ang:Right(),10)
					self.WModel:SetRenderAngles(ang)
					self.WModel:DrawModel()
				end
			end
		end
	end
end