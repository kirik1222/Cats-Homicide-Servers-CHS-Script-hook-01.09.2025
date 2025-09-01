if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 65
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
SWEP.ViewModel = "models/weapons/v_jj_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_jj_fraggrenade.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_oldgrenade");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_oldgrenade"
SWEP.PrintName = "Type 59 Grenade"
SWEP.Instructions	= "This is a cheap Chinese clone of an old Soviet RGD-5 offensive hand grenade. It has a lethality radius of 3 meters and casualty radius of 9 meters. This one was grabbed from a terrorist-bound black-market arms shipment.\n\nLeft click to arm and throw.\nHold LMB to delay the throw.\nRight click while holding LMB to remove the safety handle.\nRight click to place on a surface and rig as a booby trap."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=3
SWEP.SwayScale=3
SWEP.Weight=3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false
SWEP.ViewModelFlip=true
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
SWEP.CarryWeight=1000
SWEP.CommandDroppable=true
SWEP.ENT="ent_jack_hmcd_oldgrenade"
SWEP.PullPinAnim="pullpin"
SWEP.PullPinRate=.75
SWEP.PinOutTime=.8
SWEP.PinOutSound="weapons/m67/m67_pullpin.wav"
SWEP.ThrowReadyDelay=1.2
SWEP.DrawAnim="deploy"
SWEP.DrawRate=.6
SWEP.Riggable=true
SWEP.RigRate=.75
SWEP.RigPinTime=.8
SWEP.RigTime=1.3
SWEP.RigReturnTime=3
SWEP.RigNextFire=4.5
SWEP.ShouldPop=true
SWEP.ThrowAnim="throw"
SWEP.ThrowRate=1.5
SWEP.ThrowSound="weapons/m67/m67_throw_01.wav"
SWEP.ThrowInitialPunch=Angle(-10,-5,0)
SWEP.SecondaryPunchDelay=0.15
SWEP.ThrowSecondaryPunch=Angle(20,10,0)
SWEP.ThrowDelay=0.35
SWEP.MinExplodeTime=3
SWEP.MaxExplodeTime=4
SWEP.SpoonModel="models/weapons/arc9/darsu_eft/skobas/rgd5_skoba.mdl"
SWEP.VMPos=Vector(0,-1,1)
