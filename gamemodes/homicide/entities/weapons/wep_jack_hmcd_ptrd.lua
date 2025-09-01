if ( SERVER ) then
	AddCSLuaFile()
else
	killicon.AddFont( "wep_jack_hmcd_shotgun", "HL2MPTypeDeath", "1", Color( 255, 0, 0 ) )
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_ptrd")
end

SWEP.IconTexture="vgui/wep_jack_hmcd_ptrd"
SWEP.IconLength=4
SWEP.IconHeight=2
SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName		= "PTRD-41"
SWEP.Instructions	= "This is a single-shot anti-tank rifle using a 14.5×114 mm round.\n\nLMB to fire.\nRMB to aim.\nRELOAD to reload.\nShot placement does not count."
SWEP.Primary.ClipSize			= 1
SWEP.SlotPos=2
SWEP.ViewModel		= "models/gleb/c_ptrd.mdl"
SWEP.WorldModel		= "models/gleb/w_ptrd.mdl"
SWEP.ViewModelFlip=false
SWEP.Damage=600
SWEP.SprintPos=Vector(10,-1,-1)
SWEP.SprintAng=Angle(-20,70,-40)
SWEP.AimPos=Vector(-5.2,-1.5,2.7)
SWEP.ReloadRate=.5
SWEP.BipodReloadRate=.59
SWEP.AmmoType="CombineCannon"
SWEP.AimTime=5
SWEP.BearTime=7
SWEP.TriggerDelay=.1
SWEP.Recoil=5
SWEP.ReloadTime=7.3
SWEP.Supersonic=false
SWEP.Accuracy=.99
SWEP.HipFireInaccuracy=.07
SWEP.CloseFireSound="weapons/ptrd/ptrsfire.wav"
SWEP.SuppressedFireSound="toz_shotgun/toz_suppressed_fp.wav"
SWEP.FarFireSound="mosin/mosin_dist.wav"
SWEP.ENT="ent_jack_hmcd_ptrd"
SWEP.MuzzleEffect="pcf_jack_mf_mrifle2"
SWEP.MuzzleEffectSuppressed="pcf_jack_mf_suppressed"
SWEP.MuzzleAttachment	= "gbib"
SWEP.CommandDroppable=true
SWEP.DeathDroppable=true
SWEP.FireAnim="fire"
SWEP.DrawAnim="draw"
SWEP.DrawAnimEmpty="draw_empty"
SWEP.UseHands=true
SWEP.CockAnimDelay=.25
SWEP.HipHoldType="shotgun"
SWEP.AimHoldType="ar2"
SWEP.DownHoldType="passive"
SWEP.FuckedWorldModel=true
SWEP.ReloadType="magazine"
SWEP.BarrelLength=28
SWEP.HolsterSlot=1
SWEP.CarryWeight=8000
SWEP.ShellEffectReload="eff_jack_hmcd_145"
SWEP.MagDelay=1.8
SWEP.VMShellBone="zatvor"
SWEP.WMShellBone="bolt"
SWEP.WMShellInfo={lang=Angle(0,-90,0),lpos=Vector(6,0,0)}
SWEP.MuzzlePos={75.7,-5.7,2.1}
SWEP.BulletDir={400,2.5,-2}
SWEP.BipodUsable=true
SWEP.BipodPlaceAnim="hand_to_bipod"
SWEP.BipodRemoveAnim="bipod_to_hand"
SWEP.BipodPlaceAnimEmpty="hand_to_bipod_empty"
SWEP.BipodRemoveAnimEmpty="bipod_to_hand_empty"
SWEP.BipodFireAnim="fire_bipod"
SWEP.ReloadAnim="reload"
SWEP.BipodReloadAnim="reload_bipod"
SWEP.NoBulletInChamber=true
SWEP.BipodDeploySound={.8,"weapons/m249/handling/m249_bipoddeploy.wav"}
SWEP.BipodRemoveSound={.8,"weapons/m249/handling/m249_bipodretract.wav"}
SWEP.BipodOffset=12
SWEP.BipodAimOffset=Vector(0,5.2,-2.6)
SWEP.BipodRecoilMul=.1
SWEP.ShellEffect=""
SWEP.BipodReloadSounds={
	{"weapons/ptrd/boltback.wav", 1.4, "Both"},
	{"weapons/ptrd/coveropen.wav", 1.6, "Both"},
	{"weapons/ptrd/clipin.wav", 4.45, "Both"},
	{"weapons/ptrd/coverclose.wav", 5.65, "Both"},
	{"weapons/ptrd/boltrelease.wav", 6.1, "Both"}
}
SWEP.ReloadSounds={
	{"weapons/ptrd/boltback.wav", 1.4, "Both"},
	{"weapons/ptrd/coveropen.wav", 1.6, "Both"},
	{"weapons/ptrd/clipin.wav", 4.75, "Both"},
	{"weapons/ptrd/coverclose.wav", 5.45, "Both"},
	{"weapons/ptrd/boltrelease.wav", 5.95, "Both"}
}
SWEP.MuzzleInfo={
	["Bone"]="base",
	["Offset"]=Vector(0,-75,8)
}
SWEP.Attachments={
	["Viewer"]={
		["Weapon"]={
			pos={
				right=1,
				up=-1.5,
				forward=4
			},
			ang={
				forward=180,
				right=0
			}
		}
	}
}