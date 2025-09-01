if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	SWEP.ViewModelFOV = 65

	SWEP.Slot = 1
	SWEP.SlotPos = 1

	killicon.AddFont("wep_jack_hmcd_knife", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))

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

SWEP.Base="wep_jack_hmcd_melee_base"

SWEP.ViewModel = "models/weapons/combatknife/tactical_knife_iw7_vm.mdl"
SWEP.WorldModel = "models/weapons/combatknife/tactical_knife_iw7_wm.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/hud/tfa_iw7_tactical_knife");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/hud/tfa_iw7_tactical_knife"
SWEP.PrintName = "CQC Tactical Knife"
SWEP.Instructions	= "This is your trusty carbon-steel fixed-blade knife.\n\nLMB to stab.\nBackstabs do more damage."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=3
SWEP.SwayScale=3
SWEP.Weight	= 3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.AttackSlowDown=.1

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
--SWEP.CommandDroppable=true
SWEP.HomicideSWEP=true
SWEP.UseHands=true
--SWEP.ENT="ent_jack_hmcd_knife"
SWEP.Poisonable=true
SWEP.CarryWeight=500
SWEP.FuckedWorldModel=true
SWEP.StaminaPenalize=6	
SWEP.WooshSound={"weapons/slam/throw.wav",55,{90,110}}
SWEP.Force=125
SWEP.MinDamage=15
SWEP.MaxDamage=25
SWEP.DamageType=DMG_SLASH
SWEP.HardImpactSounds={
	{"snd_jack_hmcd_knifehit.wav",0,60,{90,110}}
}
SWEP.SoftImpactSounds={
	{"snd_jack_hmcd_knifestab.wav",0,50,{90,110}}
}
SWEP.BloodDecals=2
SWEP.ViewPunch=Angle(2,0,0)
SWEP.DrawSound={"snd_jack_hmcd_knifedraw.wav",55,{90,110}}
SWEP.DrawAnim="vm_knifeonly_raise"
SWEP.DrawPlayback=1
SWEP.DrawDelay=0
SWEP.ForceOffset=25
SWEP.HoldType="knife"
SWEP.AttackAnim="vm_knifeonly_stab"
SWEP.IdleAnim="idle"
SWEP.AttackDelay=.65
SWEP.AttackFrontDelay=.15
SWEP.RunHoldType="normal"
SWEP.ReachDistance=80
SWEP.DamageForceDiv=100
SWEP.BackStabMul=2

if(CLIENT)then
	local DownAmt=0
	function SWEP:GetViewModelPosition(pos,ang)
		if(self.Owner:KeyDown(IN_SPEED))then
			DownAmt=math.Clamp(DownAmt+.1,0,8)
		else
			DownAmt=math.Clamp(DownAmt-.1,0,8)
		end
		ang:RotateAroundAxis(ang:Right(),0)
		return pos-ang:Up()*1-ang:Forward()*(3+DownAmt)-ang:Up()*DownAmt+ang:Right()*-3,ang
	end
	function SWEP:DrawWorldModel()
	if((IsValid(self.Owner))and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
		if(self.FuckedWorldModel)then
			if not(self.WModel)then
				self.WModel=ClientsideModel(self.WorldModel)
				self.WModel:SetPos(self.Owner:GetPos())
				self.WModel:SetParent(self.Owner)
				self.WModel:SetNoDraw(true)
			else
				local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
				if((pos)and(ang))then
					self.WModel:SetRenderOrigin(pos+ang:Right()*1+ang:Forward()*3+ang:Up()*0)
					ang:RotateAroundAxis(ang:Forward(),10)
					ang:RotateAroundAxis(ang:Right(),-80)
					ang:RotateAroundAxis(ang:Up(),0)
					self.WModel:SetRenderAngles(ang)
					self.WModel:DrawModel()
				end
			end
		else
			self:DrawModel()
		end
	end
end
end