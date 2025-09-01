if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	SWEP.ViewModelFOV = 55

	SWEP.Slot = 5
	SWEP.SlotPos = 4

	killicon.AddFont("wep_jack_hmcd_phone", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))

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

SWEP.ViewModel = "models/lt_c/tech/cellphone.mdl"
SWEP.WorldModel = "models/lt_c/tech/cellphone.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_phone");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_phone"
SWEP.PrintName = "Cellular Telephone"
SWEP.Instructions	= "This is an android smartphone that can be used to call the police, causing them to arrive sooner.\n\nLMB to dial 911."
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

SWEP.ENT="ent_jack_hmcd_phone"
SWEP.DownAmt=0
SWEP.HomicideSWEP=true
SWEP.CarryWeight=500

function SWEP:Initialize()
	self:SetHoldType("slam")
	self.DownAmt=20
	self:SetCalling(false)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool",0,"Calling")
end

function SWEP:PrimaryAttack()
	if(self.Owner:KeyDown(IN_SPEED))then return end
	if(self:GetCalling())then return end
	if not(GAMEMODE.PoliceTime) then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime()+1)
	if(SERVER)then
		self:SetCalling(true)
		sound.Play("snd_jack_hmcd_phone_dial.wav",self.Owner:GetShootPos(),60,100)
		local DatTime=nil
		if self.Owner.Role!="killer" then
			timer.Simple(.7,function()
				if IsValid(self) and self.Owner:GetActiveWeapon()==self then
					local sendTable={self.Owner}
					for i,ply in pairs(player.GetAll()) do
						if ply.Spectatee==self.Owner then
							table.insert(sendTable,ply)
						end
					end
					net.Start("hmcd_sound_tocl")
					net.WriteString("snd_jack_hmcd_phone_voice.wav")
					net.WriteEntity(self.Owner)
					net.Send(sendTable)
				end
			end)
		end
		timer.Simple(2,function()
			if IsValid(self) and self.Owner:Alive() and not(self.Owner.BrokenBones["Jaw"]) and self.Owner:GetActiveWeapon()==self then
				self.Owner:ConCommand("hmcd_taunt help")
				if self.Owner.Role=="killer" then
					self.Owner:PrintMessage(HUD_PRINTTALK,"You pretend to call the police.")
				end
			end
		end)
		timer.Simple(4,function()
			if not(IsValid(self)) then return end
			if self.Owner:GetActiveWeapon()!=self then return end
			if self.Owner.BrokenBones["Jaw"] then return end
			if game.GetMap()=="gm_apartments" then
				if not self.Owner.Role=="killer" then
					self.Owner:PrintMessage(HUD_PRINTTALK,"Help won't arrive.")
				end
				return
			end
			
			if self.Owner.Role=="killer" then
				self:Remove()
				return
			else
				if GAMEMODE.PoliceTime then
					local Until=GAMEMODE.PoliceTime-CurTime()
					if(Until>0)then
						DatTime=Until/2
						GAMEMODE.PoliceTime=CurTime()+DatTime
					end
					GAMEMODE.NotifiedAboutCyanide=self.Owner.NotifiedAboutCyanide
				else
					DatTime=0
				end
			end
			
			local policeName="police"
			if GAMEMODE.MainMode=="SOE" then policeName="national guard" end
			if DatTime then
				local unitsLeft,unitName,ending
				if(DatTime>60)then
					unitsLeft=math.min(math.Round(DatTime/60),1)
					unitName="minute"
				else
					unitsLeft=math.ceil(DatTime)
					unitName="second"
				end
				if unitsLeft!=1 then ending="s" else ending="" end
				self.Owner:PrintMessage(HUD_PRINTTALK,"The "..policeName.." will be here in "..unitsLeft.." "..unitName..ending..".")
			end
			for i,ply in pairs(team.GetPlayers(2)) do
				if ply.Role=="killer" then
					ply:PrintMessage(HUD_PRINTTALK,"Someone called the "..policeName.."!")
				end
			end
			self:Remove()
		end)
		timer.Simple(5,function()
			if IsValid(self) then
				self:SetCalling(false)
			end
		end)
	end
end

function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime()+1)
	self.DownAmt=20
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
end

function SWEP:Reload()
	--
end

function SWEP:HMCDOnDrop()
	local Ent=ents.Create(self.ENT)
	Ent.HmcdSpawned=self.HmcdSpawned
	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
	Ent:Spawn()
	Ent:Activate()
	if(self.Throw)then
		Ent:GetPhysicsObject():SetVelocity(self:GetVelocity()*2)
	else
		Ent:GetPhysicsObject():SetVelocity(self:GetVelocity()/2)
	end
	self:Remove()
end

if(CLIENT)then
	function SWEP:PreDrawViewModel(vm,ply,wep)
		if(self:GetCalling())then
			vm:SetSkin(3)
		else
			vm:SetSkin(2)
		end
	end
	function SWEP:GetViewModelPosition(pos,ang)
		if not(self.DownAmt)then self.DownAmt=0 end
		if(self.Owner:KeyDown(IN_SPEED))then
			self.DownAmt=math.Clamp(self.DownAmt+.2,0,20)
		else
			self.DownAmt=math.Clamp(self.DownAmt-.2,0,20)
		end
		pos=pos-ang:Up()*(self.DownAmt+3)+ang:Forward()*12+ang:Right()*6
		ang:RotateAroundAxis(ang:Right(),-90)
		ang:RotateAroundAxis(ang:Up(),10)
		ang:RotateAroundAxis(ang:Forward(),-110)
		return pos,ang
	end
	function SWEP:DrawWorldModel()
		local Pos,Ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		if(self.DatWorldModel)then
			if((Pos)and(Ang)and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
				self.DatWorldModel:SetRenderOrigin(Pos+Ang:Forward()*4+Ang:Right()*2-Ang:Up()*2)
				Ang:RotateAroundAxis(Ang:Right(),120)
				--Ang:RotateAroundAxis(Ang:Right(),90)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel=ClientsideModel("models/lt_c/tech/cellphone.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetSkin(2)
		end
	end
end