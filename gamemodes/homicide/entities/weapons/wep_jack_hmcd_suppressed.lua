if ( SERVER ) then
	AddCSLuaFile()
else
	killicon.AddFont( "wep_jack_hmcd_suppressed", "HL2MPTypeDeath", "1", Color( 255, 0, 0 ) )
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_suppressed")
end
SWEP.IconTexture="vgui/wep_jack_hmcd_suppressed"
SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName		= "Walther P22"
SWEP.Instructions	= "This is a semi-auto plinking pistol with a ten-round magazine and a homemade suppressor. It fires .22LR. Use it to kill innocents discreetly.\n\nLMB to fire.\nRMB to aim.\nRELOAD to reload.\nShot placement counts.\nCrouching helps stability.\nBullets can ricochet and penetrate."
SWEP.Primary.ClipSize = 11
SWEP.SlotPos=2
SWEP.ViewModel		= "models/weapons/c_ins2_pist_p99.mdl"
SWEP.WorldModel		= "models/weapons/w_p99.mdl"
SWEP.ViewModelFlip=false
SWEP.Damage=10
SWEP.SprintPos=Vector(2,.5,-12)
SWEP.SprintAng=Angle(80,0,0)
SWEP.AimPos=Vector(-1.85,0,.4)
SWEP.AltAimPos=Vector(-2.1,0,.7)
SWEP.AimAng=Angle(0.6,0,0)
SWEP.EjectType="auto"
SWEP.FuckedWorldModel=true
SWEP.ReloadRate=.75
SWEP.ReloadSound=""
SWEP.AmmoType="AlyxGun"
SWEP.TriggerDelay=.1
SWEP.ShellType=""
SWEP.Recoil=.5
SWEP.Supersonic=false
SWEP.Accuracy=.985
SWEP.CloseFireSound="hndg_mkiii/mkiii_fire_01.wav"
--SWEP.SuppressedFireSound="snd_jack_hmcd_supppistol.wav"
--SWEP.FarFireSound="snd_jack_hmcd_suppburst.wav"
--SWEP.CloseFireSound="m9/m9_fp.wav"
SWEP.FarFireSound="m9/m9_dist.wav"
SWEP.SuppressedFireSound="m9/m9_suppressed_fp.wav"
SWEP.ENT="ent_jack_hmcd_suppressed"
SWEP.FireAnim="base_fire"
SWEP.IronFireAnim="iron_fire_1"
SWEP.LastFireAnim="base_firelast"
SWEP.UseHands=true
SWEP.DrawAnim="base_draw"
SWEP.DrawAnimEmpty="empty_draw"
SWEP.TacticalReloadAnim="base_reload"
SWEP.ReloadAnim="base_reloadempty"
SWEP.DeathDroppable=false
SWEP.CommandDroppable=true
SWEP.MuzzleEffect="pcf_jack_mf_spistol"
SWEP.MuzzleEffectSuppressed="pcf_jack_mf_suppressed"
SWEP.HipFireInaccuracy=.02
SWEP.BarrelLength=1
SWEP.AttBone="barrel"
SWEP.LaserAngle=Angle(89.7,0,0)
SWEP.LaserOffset=Angle(-0.75,0,0)
SWEP.CarryWeight=1200
SWEP.ShellAttachment=3
SWEP.WMShellAttachment=2
SWEP.ShellEffect="eff_jack_hmcd_22"
SWEP.MuzzlePos={7.6,-5.07,0}
SWEP.ReloadAdd=0.25
SWEP.ReloadTime=3.25
SWEP.ReloadSounds={
	{"weapons/p99/magout.wav", 0.7, "Both"},
	{"weapons/p99/magin_2.wav", 2, "Both"},
	{"weapons/p99/magin.wav", 2.5, "Both"},
	{"weapons/p99/slideforward.wav", 3.1, "EmptyOnly"}
}
SWEP.MagEntity="ent_jack_hmcd_glock17mag"
SWEP.DeployVolume=50
SWEP.BulletDir={400,2.25,-4}
SWEP.SuicideAng=Angle(110,30,90)
SWEP.SuicidePos=Vector(10,3,-13)
SWEP.SuicideSuppr=Vector(3,2,-6.5)
SWEP.MuzzleInfo={
	["Bone"]="barrel",
	["Offset"]=Vector(20,2,-1)
}
SWEP.Attachments={
	["Owner"]={
		["Suppressor"]={
			bone="barrel",
			pos={
				right=6,
				forward=0.85,
				up=0.7
			},
			ang={
				forward=181,
				right=90
			},
			scale=.7,
			model="models/cw2/attachments/9mmsuppressor.mdl",
			num=HMCD_PISTOLSUPP
		},
		["Laser"]={
			bone="barrel",
			pos={
				right=2.5,
				forward=0.1,
				up=-0.1
			},
			ang={
				up=-90
			},
			scale=.7,
			model="models/weapons/tfa_ins2/upgrades/laser_pistol.mdl",
			num=HMCD_LASERSMALL
		}
	},
	["Viewer"]={
		["Weapon"]={
			pos={
				right=1,
				up=-2,
				forward=3.7
			},
			ang={
				forward=180,
				right=10
			}
		},
		["Suppressor"]={
			pos={
				forward=12.4,
				up=-5.5,
				right=-0.1
			},
			ang={
				right=262,
				forward=90
			},
			scale=.9,
			model="models/cw2/attachments/9mmsuppressor.mdl"
		},
		["Laser"]={
			pos={
				forward=8.8,
				up=-4,
				right=1.3
			},
			ang={
				right=170,
				up=180
			},
			scale=.9,
			model="models/weapons/tfa_ins2/upgrades/laser_pistol.mdl"
		}
	}
}