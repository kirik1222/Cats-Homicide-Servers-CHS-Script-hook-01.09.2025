if ( SERVER ) then
	AddCSLuaFile()
else
	killicon.AddFont( "wep_jack_hmcd_sr25", "HL2MPTypeDeath", "1", Color( 255, 0, 0 ) )
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/hud/tfa_ins2_sr25_eft")
end

SWEP.IconTexture="vgui/hud/tfa_ins2_sr25_eft"
SWEP.IconLength=3
SWEP.IconHeight=2
SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName		= "SR-25"
SWEP.Instructions	= "This is a designated marksman rifle/semi-automatic sniper rifle firing 7.62×51mm NATO caliber. \n\nLMB to fire.\nRMB to aim.\nRELOAD to reload.\nShot placement counts.\nCrouching helps stability.\nBullets can ricochet and penetrate."
SWEP.Primary.ClipSize			= 21
SWEP.ViewModel		= "models/weapons/v_sr25_eft.mdl"
SWEP.WorldModel		= "models/weapons/w_sr25_ins2_eft.mdl"
SWEP.ViewModelFlip=false
SWEP.UseHands=true
SWEP.InsHands=true
SWEP.Damage=115
SWEP.SprintPos=Vector(10,5,-2)
SWEP.SprintAng=Angle(0,90,0)
SWEP.AimPos=Vector(-1.8,-1,1.25)
SWEP.AltAimPos=Vector(1.95,-3,.5)
SWEP.ReloadTime=5
SWEP.ReloadAdd=1
SWEP.ReloadRate=.75
-- SWEP.ReloadSound="snd_jack_hmcd_boltreload.wav"
-- SWEP.CycleSound="snd_jack_hmcd_boltcycle.wav"
SWEP.AmmoType="StriderMinigun"
SWEP.TriggerDelay=.2
SWEP.Recoil=0.5
SWEP.Supersonic=true
SWEP.Accuracy=.9999
SWEP.ShotPitch=100
SWEP.ENT="ent_jack_hmcd_sr25"
SWEP.DeathDroppable=true
SWEP.CommandDroppable=true
SWEP.SightRifle=false
SWEP.SightRifle2=false
SWEP.SightRifle3=false
SWEP.LaserRifle=false
SWEP.SuppressedRifle=true
SWEP.AttBone="A_LaserFlashlight"
SWEP.LaserAngle=Angle(0,0,0)
SWEP.CycleType="auto"
SWEP.ReloadType="magazine"
SWEP.DrawAnim="base_draw"
SWEP.DrawAnimEmpty="base_draw_empty"
SWEP.FireAnim="base_fire"
SWEP.IronFireAnim="iron_fire"
SWEP.LastFireAnim="base_fire_last"
SWEP.LastIronFireAnim="iron_fire_last"
SWEP.ReloadAnim="base_reload_empty"
SWEP.TacticalReloadAnim="base_reload"
-- SWEP.ReloadAnim="awm_reload"
--SWEP.CloseFireSound="rifle_sako85/sako_fire_01.wav"
--SWEP.FarFireSound="snd_jack_hmcd_snp_far.wav"
SWEP.SuppressedFireSound="m14/m14_suppressed_fp.wav"
SWEP.CloseFireSound="rifle_win1892/win1892_fire_01.wav"
SWEP.FarFireSound="m4a1/m4a1_dist.wav"
SWEP.ShellType=""
SWEP.BarrelLength=19
SWEP.AimTime=6.25
SWEP.BearTime=9
SWEP.FuckedWorldModel=true
SWEP.HipHoldType="shotgun"
SWEP.AimHoldType="ar2"
SWEP.DownHoldType="passive"
SWEP.MuzzleEffect="pcf_jack_mf_mrifle2"
SWEP.MuzzleEffectSuppressed="pcf_jack_mf_suppressed"
SWEP.HipFireInaccuracy=.07
SWEP.HolsterSlot=1
SWEP.CarryWeight=5000
SWEP.ShellEffect="eff_jack_hmcd_76251"
SWEP.ShellAttachment=3
SWEP.MagEntity="ent_jack_hmcd_sr25mag"
SWEP.MuzzlePos={25.5,-5.1,-0.1}
SWEP.ScopeDotAngle=Angle(0,0,0)
SWEP.ScopeDotPosition=Vector(0,0,0)
SWEP.ReloadSounds={
	{"weapons/tfa_ins2_sr25_eft/m14_magout.wav", .7, "Both"},
	{"weapons/tfa_ins2_sr25_eft/m14_magin.wav", 3.2, "Both"},
	{"weapons/tfa_ins2_sr25_eft/m16_hit.wav", 3.7, "Both"},
	{"weapons/tfa_ins2_sr25_eft/m14_boltrelease.wav", 4.9, "EmptyOnly"}
}
SWEP.BulletDir={400,2.5,-1.5}
SWEP.SuicidePos=Vector(4,11,-32.5)
SWEP.SuicideAng=Angle(110,2,90)
SWEP.SuicideTime=10
SWEP.SuicideType="Rifle"
SWEP.SuicideSuppr=Vector(3,2,-6.5)
SWEP.MultipleRIS=true
SWEP.MuzzleInfo={
	["Bone"]="A_Muzzle",
	["Offset"]=Vector(30,1,-2)
}
SWEP.Attachments={
	["Owner"]={
		["Suppressor"]={
			bone="A_Suppressor",
			pos={
				right=19,
				forward=-2.5,
				up=-3.75
			},
			ang={
				up=93,
				forward=30
			},
			model="models/weapons/upgrades/w_sr25_silencer.mdl"
		},
		["Laser"]={
			bone="A_LaserFlashlight",
			pos={
				right=0,
				forward=4,
				up=0.5
			},
			ang={
				forward=90,
				up=180
			},
			scale=.7,
			model="models/cw2/attachments/anpeq15.mdl",
			num=HMCD_LASERBIG
		},
		["Sight"]={
			bone="A_Optic",
			pos={
				right=-0.65,
				forward=0,
				up=0
			},
			ang={
				up=90,
				right=90
			},
			scale=.7,
			model="models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl",
			sightpos={
				right=0.3,
				forward=0,
				up=20
			},
			sightang={
				up=-90,
				forward=180,
				right=90
			},
			aimpos=Vector(-1.8,-3,.5),
			num=HMCD_KOBRA
		},
		["Sight2"]={
			bone="A_Optic",
			pos={
				right=-0.5,
				forward=0,
				up=0
			},
			ang={
				up=90,
				right=90
			},
			scale=.7,
			model="models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl",
			sightpos={
				right=0.5,
				forward=0,
				up=20
			},
			sightang={
				up=-90,
				forward=180,
				right=90
			},
			aimpos=Vector(-1.8,-3,.275),
			num=HMCD_AIMPOINT
		},
		["Sight3"]={
			bone="A_Optic",
			pos={
				right=-0.65,
				forward=0,
				up=0
			},
			ang={
				up=90,
				right=90
			},
			scale=.7,
			model="models/weapons/tfa_ins2/upgrades/a_optic_eotech.mdl",
			sightpos={
				right=0.4,
				forward=0,
				up=20
			},
			sightang={
				up=-90,
				forward=180,
				right=90
			},
			aimpos=Vector(-1.8,-3,.425),
			num=HMCD_EOTECH
		}
	},
	["Viewer"]={
		["Weapon"]={
			pos={
				right=1.25,
				up=-1,
				forward=5
			},
			ang={
				forward=180
			}
		},
		["Suppressor"]={
			pos={
				forward=6,
				up=-8.5,
				right=0
			},
			ang={
				up=5,
				forward=20
			},
			model="models/weapons/upgrades/w_sr25_silencer.mdl"
		},
		["Laser"]={
			pos={
				forward=22.5,
				up=-4.6,
				right=0.25
			},
			ang={
				forward=-90,
				up=180
			},
			scale=.7,
			model="models/cw2/attachments/anpeq15.mdl"
		},
		["Sight"]={
			pos={
				forward=7.8,
				up=-5.8,
				right=1
			},
			ang={
				forward=180
			},
			model="models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl"
		},
		["Sight2"]={
			pos={
				forward=7.8,
				up=-6,
				right=1.3
			},
			ang={
				forward=180
			},
			model="models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl"
		},
		["Sight3"]={
			pos={
				forward=7.8,
				up=-6,
				right=1.1
			},
			ang={
				forward=180
			},
			model="models/weapons/tfa_ins2/upgrades/a_optic_eotech.mdl"
		}
	}
}