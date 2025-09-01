if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	SWEP.ViewModelFOV = 55

	SWEP.Slot = 5
	SWEP.SlotPos = 3

	killicon.AddFont("wep_jack_hmcd_walkietalkie", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))

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

SWEP.ViewModel = "models/sirgibs/ragdoll/css/terror_arctic_radio.mdl"
SWEP.WorldModel = "models/sirgibs/ragdoll/css/terror_arctic_radio.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_walkietalkie");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_walkietalkie"
SWEP.PrintName = "Walkie Talkie"
SWEP.Instructions	= "This is an average consumer-grade medium-range walkie talkie. Use it to communicate (or to spy on communications).\n\nWith this in hand, anything you say in chat is broadcast to all individuals who also have a walkie talkie in their possession, regardless of distance or line-of-sight.\n\nPress LMB to increase the frequency.\nPress RMB to decrease the frequency.\nR to check current frequency.\nE+R to toggle."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=3
SWEP.SwayScale=3
SWEP.Weight	= 3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.CommandDroppable=false
SWEP.DeathDroppable=false

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

SWEP.ENT="ent_jack_hmcd_walkietalkie"
SWEP.DownAmt=0
SWEP.HomicideSWEP=true
SWEP.CarryWeight=800
SWEP.CommandDroppable=true
SWEP.Frequencies={"79.7","88.5","91.5","110.9","118.8","123.0","131.8","146.2","156.7","167.9"}
SWEP.NextToggle=0
SWEP.Disabled=false
SWEP.AllowDuringBuytime=true

function SWEP:Initialize()
	self:SetHoldType("normal")
	self.DownAmt=20
	self:SetFrequency(self.Frequencies[1])
	self.CurrentPos=1
	if SERVER then
		timer.Simple(.1,function()
			if IsValid(self) then
				self.Owner:SetName(self.Owner:GetName())
				for i,ply in pairs(player.GetAll()) do
					local wep=ply:GetWeapon("wep_jack_hmcd_walkietalkie")
					if ply!=self.Owner and IsValid(wep) and wep:GetFrequency()==self:GetFrequency() and not(IsValid(ply.Mics["Ents"][self.Owner:EntIndex()])) then
						self:CreateMic(ply,self.Owner)
						if ply:GetActiveWeapon()==wep then self:CreateMic(ply,self.Owner) end
					end
				end
				for i,radio in pairs(ents.FindByClass("ent_jack_hmcd_walkietalkie")) do
					if radio.Frequency==self:GetFrequency() then
						self:CreateMic(self.Owner,radio)
					end
				end
			end
		end)
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar("String",0,"Frequency")
end

function SWEP:PrimaryAttack()
	if SERVER and not(self.Disabled) then
		if self.Frequencies[self.CurrentPos+1] then
			self.CurrentPos=self.CurrentPos+1
		else
			self.CurrentPos=1
		end
		self.Owner:EmitSound("radiotune.mp3",90,math.random(90,110))
		self:SetFrequency(self.Frequencies[self.CurrentPos])
		self.Owner:PrintMessage(HUD_PRINTCENTER,"Frequency switched to "..self:GetFrequency().." MHz")
		self:SetNextPrimaryFire(CurTime()+1.2)
		self:SetNextSecondaryFire(CurTime()+1.2)
		self.NextToggle=CurTime()+1.2
		for i,mic in pairs(self.Owner.Mics["Ents"]) do
			mic:Remove()
		end
		local ind=self.Owner:EntIndex()
		for i,ply in pairs(player.GetAll()) do
			if ply.Mics and ply.Mics["Ents"][self.Owner:EntIndex()] then
				ply.Mics["Ents"][self.Owner:EntIndex()]:Remove()
				ply.Mics["Ents"][self.Owner:EntIndex()]=nil
				ply.Mics["Players"][self.Owner:EntIndex()]=nil
			end
			ply:SendLua("if not(GAMEMODE.RadioHolders) then GAMEMODE.RadioHolders={} end GAMEMODE.RadioHolders[tonumber("..ind..")]="..self:GetFrequency())
		end
		self.Owner.Mics["Players"]={}
		self.Owner.Mics["Ents"]={}
		for i,ply in pairs(player.GetAll()) do
			local wep=ply:GetWeapon("wep_jack_hmcd_walkietalkie")
			if IsValid(wep) and wep:GetFrequency()==self:GetFrequency() and ply!=self.Owner and not(IsValid(self.Owner.Mics["Ents"][ply:EntIndex()])) then
				self:CreateMic(self.Owner,ply)
				if ply:GetActiveWeapon()==wep then self:CreateMic(ply,self.Owner) end
			end
		end
		for i,radio in pairs(ents.FindByClass("ent_jack_hmcd_walkietalkie")) do
			if radio.Frequency==self:GetFrequency() then
				self:CreateMic(self.Owner,radio)
			end
		end
	end
end

function SWEP:CreateMic(listener,speaker)
	local mic=ents.Create("env_microphone")
	mic:SetName("micro_"..mic:EntIndex())
	mic:SetPos(listener:GetPos())
	mic:SetParent(listener)
	mic:SetKeyValue("target",mic:GetName())
	mic:SetKeyValue("speaker_dsp_preset","59")
	mic:SetKeyValue("Sensitivity","1")
	if speaker:GetClass()=="ent_jack_hmcd_walkietalkie" then
		mic:SetKeyValue("MaxRange","125")
	else
		mic:SetKeyValue("MaxRange","250")
	end
	if not(speaker:IsPlayer()) then speaker:SetName("speaker_"..speaker:EntIndex()) end
	mic:AddFlags(16)
	mic:Fire("SetSpeakerName",speaker:GetName())
	mic:Spawn()
	mic:Activate()
	mic:Fire("Disable")
	listener.Mics["Ents"][speaker:EntIndex()]=mic
	listener.Mics["Players"][speaker:EntIndex()]=speaker
end

function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime()+1)
	self.DownAmt=20
	if SERVER then
		for i,ply in pairs(player.GetAll()) do
			local wep=ply:GetWeapon("wep_jack_hmcd_walkietalkie")
			if IsValid(wep) and wep:GetFrequency()==self:GetFrequency() and ply!=self.Owner and not(IsValid(self.Owner.Mics["Ents"][ply:EntIndex()])) then
				self:CreateMic(self.Owner,ply)
			end
		end
		for i,radio in pairs(ents.FindByClass("ent_jack_hmcd_walkietalkie")) do
			if radio.Frequency==self:GetFrequency() and not(radio.Deleting) then
				self:CreateMic(self.Owner,radio)
			end
		end
	end
	return true
end

function SWEP:Holster(newWep)
	if SERVER then
		for i,mic in pairs(self.Owner.Mics["Ents"]) do
			mic:Remove()
		end
		self.Owner.Mics["Players"]={}
		self.Owner.Mics["Ents"]={}
	end
	return true
end

function SWEP:OnRemove()
	if SERVER and IsValid(self.LastOwner) and self.LastOwner.Mics then
		for i,mic in pairs(self.LastOwner.Mics["Ents"]) do
			mic:Remove()
		end
		self.LastOwner.Mics["Players"]={}
		self.LastOwner.Mics["Ents"]={}
		local ind=self.LastOwner:EntIndex()
		for i,ply in pairs(player.GetAll()) do
			if ply.Mics and ply.Mics["Ents"][self.LastOwner:EntIndex()] then
				ply.Mics["Ents"][self.LastOwner:EntIndex()]=nil
				ply.Mics["Players"][self.LastOwner:EntIndex()]=nil
			end
			ply:SendLua("if GAMEMODE.RadioHolders then GAMEMODE.RadioHolders[tonumber("..ind..")]=nil end")
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER and not(self.Disabled) then
		if self.Frequencies[self.CurrentPos-1] then
			self.CurrentPos=self.CurrentPos-1
		else
			self.CurrentPos=#self.Frequencies
		end
		self.Owner:EmitSound("radiotune.mp3",90,math.random(90,110))
		self:SetFrequency(self.Frequencies[self.CurrentPos])
		self.Owner:PrintMessage(HUD_PRINTCENTER,"Frequency switched to "..self:GetFrequency().." MHz")
		self:SetNextPrimaryFire(CurTime()+1.2)
		self:SetNextSecondaryFire(CurTime()+1.2)
		self.NextToggle=CurTime()+1.2
		for i,mic in pairs(self.Owner.Mics["Ents"]) do
			mic:Remove()
		end
		local ind=self.Owner:EntIndex()
		for i,ply in pairs(player.GetAll()) do
			if ply.Mics and ply.Mics["Ents"][self.Owner:EntIndex()] then
				ply.Mics["Ents"][self.Owner:EntIndex()]:Remove()
				ply.Mics["Ents"][self.Owner:EntIndex()]=nil
				ply.Mics["Players"][self.Owner:EntIndex()]=nil
			end
			ply:SendLua("if not(GAMEMODE.RadioHolders) then GAMEMODE.RadioHolders={} end GAMEMODE.RadioHolders[tonumber("..ind..")]="..self:GetFrequency())
		end
		self.Owner.Mics["Players"]={}
		self.Owner.Mics["Ents"]={}
		for i,ply in pairs(player.GetAll()) do
			local wep=ply:GetWeapon("wep_jack_hmcd_walkietalkie")
			if IsValid(wep) and wep:GetFrequency()==self:GetFrequency() and ply!=self.Owner and not(IsValid(self.Owner.Mics["Ents"][ply:EntIndex()])) then
				self:CreateMic(self.Owner,ply)
				if ply:GetActiveWeapon()==wep then self:CreateMic(ply,self.Owner) end
			end
		end
	end
end

function SWEP:Think()
	--
end

function SWEP:Reload()
	if SERVER and self.NextToggle<CurTime() then
		self.NextToggle=CurTime()+1.2
		self:SetNextPrimaryFire(self.NextToggle)
		self:SetNextSecondaryFire(self.NextToggle)
		if not(self.Owner:KeyDown(IN_USE)) then
			if not(self.Disabled) then
				self.Owner:PrintMessage(HUD_PRINTCENTER,self:GetFrequency().." MHz")
			else
				self.Owner:PrintMessage(HUD_PRINTCENTER,"Disabled")
			end
		else
			local ind=self.Owner:EntIndex()
			if self.Disabled then
				self:SetFrequency(self.Frequencies[self.CurrentPos])
				self.Owner:PrintMessage(HUD_PRINTCENTER,"Enabled")
				for i,ply in pairs(player.GetAll()) do
					local wep=ply:GetWeapon("wep_jack_hmcd_walkietalkie")
					if IsValid(wep) and wep:GetFrequency()==self:GetFrequency() and ply!=self.Owner and not(IsValid(self.Owner.Mics["Ents"][ply:EntIndex()])) then
						self:CreateMic(self.Owner,ply)
						if ply:GetActiveWeapon()==wep then self:CreateMic(ply,self.Owner) end
					end
					ply:SendLua("if not(GAMEMODE.RadioHolders) then GAMEMODE.RadioHolders={} end GAMEMODE.RadioHolders[tonumber("..ind..")]="..self:GetFrequency())
				end
				for i,radio in pairs(ents.FindByClass("ent_jack_hmcd_walkietalkie")) do
					if radio.Frequency==self:GetFrequency() then
						self:CreateMic(self.Owner,radio)
					end
				end
			else
				self:SetFrequency(self.Owner:Nick())
				self.Owner:PrintMessage(HUD_PRINTCENTER,"Disabled")
				for i,mic in pairs(self.Owner.Mics["Ents"]) do
					mic:Remove()
				end
				for i,ply in pairs(player.GetAll()) do
					if ply.Mics and ply.Mics["Ents"][self.LastOwner:EntIndex()] then
						ply.Mics["Ents"][self.LastOwner:EntIndex()]:Remove()
						ply.Mics["Ents"][self.LastOwner:EntIndex()]=nil
						ply.Mics["Players"][self.LastOwner:EntIndex()]=nil
					end
					ply:SendLua("if not(GAMEMODE.RadioHolders) then GAMEMODE.RadioHolders={} end GAMEMODE.RadioHolders[tonumber("..ind..")]=nil")
				end
				self.Owner.Mics["Players"]={}
				self.Owner.Mics["Ents"]={}
			end
			self.Owner:EmitSound("radiotune.mp3",90,math.random(90,110))
			self.Disabled=not(self.Disabled)
		end
	end
end

function SWEP:HMCDOnDrop()
	local Ent=ents.Create(self.ENT)
	Ent.HmcdSpawned=self.HmcdSpawned
	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
	Ent.Frequency=self:GetFrequency()
	Ent.Disabled=self.Disabled
	Ent.CurrentPos=self.CurrentPos
	Ent:Spawn()
	Ent:Activate()
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity()/2)
	self:Remove()
end
--[[if((ply)and(ply.Alive)and(ply:Alive())and(ply.HasWeapon)and(ply:HasWeapon("wep_jack_hmcd_walkietalkie")))then
	sound.Play("ambient/levels/prison/radio_random"..math.random(1,15)..".wav",self.Owner:GetShootPos(),75,math.random(95,105))
end]]
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
		pos=pos-ang:Up()*(self.DownAmt+47)+ang:Forward()*20+ang:Right()*5
		ang:RotateAroundAxis(ang:Up(),-90)
		--ang:RotateAroundAxis(ang:Right(),-10)
		--ang:RotateAroundAxis(ang:Forward(),-10)
		return pos,ang
	end
	function SWEP:DrawWorldModel()
		local Pos,Ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_L_Hand"))
		if(self.DatWorldModel)then
			if((Pos)and(Ang)and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
				self.DatWorldModel:SetRenderOrigin(Pos-Ang:Up()*50-Ang:Right()*8+Ang:Forward()*3)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel=ClientsideModel("models/sirgibs/ragdoll/css/terror_arctic_radio.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetModelScale(1.25,0)
		end
	end
end