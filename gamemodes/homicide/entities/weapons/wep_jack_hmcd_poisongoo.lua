if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	SWEP.ViewModelFOV = 65

	SWEP.Slot = 3
	SWEP.SlotPos = 4

	killicon.AddFont("wep_jack_hmcd_poisongoo", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))

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

SWEP.ViewModel = "models/Items/Flare.mdl"
SWEP.WorldModel = "models/Items/Flare.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_poisongoo");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_poisongoo"
SWEP.PrintName = "Curare Vial"
SWEP.Instructions	= "This is a tiny vial home-prepared, highly concentrated alkaloid extract from various curare-bearing plant sources. It is a potent blood-poison, and can be applied to any cutting or penetrating instrument.\n\nLMB to open menu"
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
SWEP.HomicideSWEP=true
SWEP.NoHolsterForce=true
SWEP.LastMenuOpen=0

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:SetupDataTables()
	--
end

function SWEP:PrimaryAttack()
	if(self.Owner:KeyDown(IN_SPEED))then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if CLIENT and IsFirstTimePredicted() then
		self:OpenTheMenu()
	end
	self:SetNextPrimaryFire(CurTime()+0.5)
end

function SWEP:Deploy()
	if not(IsFirstTimePredicted())then return end
	self.DownAmt=8
	self:SetNextPrimaryFire(CurTime()+1)
	return true
end

function SWEP:Holster()
	self:OnRemove()
	return true
end

function SWEP:OnRemove()
	if(IsValid(self.Owner) && CLIENT && self.Owner:IsPlayer())then
		local vm=self.Owner:GetViewModel()
		if(IsValid(vm)) then vm:SetMaterial("") end
	end
end

function SWEP:SecondaryAttack()
	--
end

function SWEP:Think()
	--
end

function SWEP:Reload()
	--
end

if(CLIENT)then
	
	function SWEP:OpenTheMenu()
		if not(self.Owner:Alive())then return end
		local Ply,Weps,Poisonables=LocalPlayer(),self.Owner:GetWeapons(),{}
		for key,wep in pairs(Weps) do
			if wep.Poisonable or (wep.AmmoPoisonable and self.Owner:GetAmmoCount(wep.AmmoType)>0) then table.insert(Poisonables,wep) end
		end
		local tr=util.QuickTrace(self.Owner:GetShootPos(),self.Owner:GetAimVector()*65,self.Owner)
		if IsValid(tr.Entity) and tr.MatType==MAT_GLASS then
			table.insert(Poisonables,tr.Entity)
		end
		if table.IsEmpty(Poisonables) then LocalPlayer():PrintMessage(HUD_PRINTTALK,"You have no items to poison!") return end
		local W,H=ScrW(),ScrH()
		local DermaPanel=vgui.Create("DFrame")
		DermaPanel:SetPos(0,0)
		DermaPanel:SetSize(210,35+#Poisonables*55)
		DermaPanel:SetTitle("Poison Weapon")
		DermaPanel:SetVisible(true)
		DermaPanel:SetDraggable(true)
		DermaPanel:ShowCloseButton(true)
		DermaPanel:MakePopup()
		DermaPanel:Center()
		local MainPanel=vgui.Create("DPanel",DermaPanel)
		MainPanel:SetPos(5,25)
		MainPanel:SetSize(200,5+#Poisonables*55)
		MainPanel:SetVisible(true)
		MainPanel.Paint=function()
			surface.SetDrawColor(0,20,40,255)
			surface.DrawRect(0,0,MainPanel:GetWide(),MainPanel:GetTall())
		end
		for key,wep in pairs(Poisonables)do
			local PButton=vgui.Create("Button",MainPanel)
			PButton:SetSize(190,50)
			PButton:SetPos(5,-50+key*55)
			if(wep.Poisonable)then
				PButton:SetText("Poison "..wep:GetPrintName())
			elseif(wep.AmmoPoisonable)then
				PButton:SetText("Poison "..wep.AmmoName)
			else
				PButton:SetText("Glass Object")
			end
			PButton:SetVisible(true)
			PButton.DoClick=function()
				local arg
				if wep:IsWeapon() then arg=wep:GetClass() else arg="" end
				self.Owner:ConCommand("hmcd_apply_poison "..arg)
				DermaPanel:Close()
			end
		end
	end
	
	function SWEP:PreDrawViewModel(vm,ply,wep)
		vm:SetMaterial("debug/env_cubemap_model")
	end
	
	function SWEP:GetViewModelPosition(pos,ang)
		if not(self.DownAmt)then self.DownAmt=8 end
		if(self.Owner:KeyDown(IN_SPEED))then
			self.DownAmt=math.Clamp(self.DownAmt+.1,0,8)
		else
			self.DownAmt=math.Clamp(self.DownAmt-.1,0,8)
		end
		local NewPos=pos+ang:Forward()*40-ang:Up()*(18+self.DownAmt)+ang:Right()*15
		return NewPos,ang
	end
	
	function SWEP:DrawWorldModel()
		local Pos,Ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		if(self.DatWorldModel)then
			if((Pos)and(Ang)and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
				self.DatWorldModel:SetRenderOrigin(Pos+Ang:Forward()*4-Ang:Up()*0+Ang:Right()*1.5)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel=ClientsideModel("models/Items/Flare.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetMaterial("debug/env_cubemap_model")
			self.DatWorldModel:SetNoDraw(true)
			self.DatWorldModel:SetModelScale(.5,0)
		end
	end
	
	function SWEP:ViewModelDrawn()
		--
	end

elseif(SERVER)then
	
	concommand.Add("hmcd_apply_poison",function(ply,cmd,args)
		if not(ply:Alive())then return end
		if not(ply:HasWeapon("wep_jack_hmcd_poisongoo")) then return end
		local wep=args[1]
		if not(wep) then
			local prop=util.QuickTrace(ply:GetShootPos(),ply:GetAimVector()*65,ply).Entity
			if prop:GetMaterialType()==MAT_GLASS then
				prop.Poisoned=true
				prop.Poisoner=ply
				ply:StripWeapon("wep_jack_hmcd_poisongoo")
				ply:EmitSound("snd_jack_hmcd_drink1.wav",55,120)
			end
			return
		end
		if ply:HasWeapon(wep) then
			wep=ply:GetWeapon(wep)
			if not(wep.Poisoned) then
				if wep.Poisonable then
					wep.Poisoned=true
					wep.Poisoner=ply
					ply:StripWeapon("wep_jack_hmcd_poisongoo")
					ply:SelectWeapon(wep:GetClass())
					ply:EmitSound("snd_jack_hmcd_drink1.wav",55,120)
				elseif wep.AmmoPoisonable and ply:GetAmmoCount(wep.AmmoType)>0 then
					ply.HMCD_AmmoPoisoned=true
					ply:StripWeapon("wep_jack_hmcd_poisongoo")
					ply:SelectWeapon(wep:GetClass())
					ply:EmitSound("snd_jack_hmcd_drink1.wav",55,120)
				end
			end
		end
	end)
	
end