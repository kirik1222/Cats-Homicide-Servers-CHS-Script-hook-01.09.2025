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

SWEP.ViewModel = "models/zac/c_kitchenknife.mdl"
SWEP.WorldModel = "models/mu_hmcd_mansion/weapon_knives/w_kitchenknife.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_hmcd_mansion_knife");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_hmcd_mansion_knife"
SWEP.PrintName = "Kitchen Knife"
SWEP.Instructions	= "This is a knife with a wooden grip and sharp stainless steel blade.\n\nLMB to swing."
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
SWEP.HomicideSWEP=true
SWEP.CommandDroppable=true
SWEP.ENT="ent_jack_hmcd_kitchenknife"
SWEP.UseHands=true
SWEP.Poisonable=true
SWEP.CarryWeight=500
SWEP.DangerLevel=45
SWEP.StaminaPenalize=5	
SWEP.WooshSound={"weapons/slam/throw.wav",55,{90,110}}
SWEP.Force=125
SWEP.MinDamage=7
SWEP.MaxDamage=13
SWEP.DamageType=DMG_SLASH
SWEP.HardImpactSounds={
	{"snd_jack_hmcd_knifehit.wav",0,60,{90,110}}
}
SWEP.SoftImpactSounds={
	{"snd_jack_hmcd_slash.wav",0,60,{90,110}}
}
SWEP.BloodDecals=2
SWEP.ViewPunch=Angle(2,0,0)
SWEP.DrawSound={"snd_jack_hmcd_knifedraw.wav",55,{90,110}}
SWEP.DrawAnim="draw"
SWEP.DrawPlayback=1
SWEP.DrawDelay=0
SWEP.CanUpdateIdle=true
SWEP.ForceOffset=25
SWEP.HoldType="melee"
SWEP.IdleAnim="idle"
SWEP.AttackAnim="attack"
SWEP.AttackPlayback=1
SWEP.AttackDelay=.5
SWEP.AttackFrontDelay=.15
SWEP.RunHoldType="normal"
SWEP.ReachDistance=80
SWEP.DamageForceDiv=100
if(CLIENT)then
	local DownAmt=0
	function SWEP:GetViewModelPosition(pos,ang)
		if(self.Owner:KeyDown(IN_SPEED))then
			DownAmt=math.Clamp(DownAmt+.1,0,16)
		else
			DownAmt=math.Clamp(DownAmt-.1,0,16)
		end
		ang:RotateAroundAxis(ang:Right(),0)
		return pos+ang:Forward()*3-ang:Up()*(DownAmt-3),ang
	end
	function SWEP:DrawWorldModel()
		if(GAMEMODE:ShouldDrawWeaponWorldModel(self))then
			self:DrawModel()
		end
	end
end