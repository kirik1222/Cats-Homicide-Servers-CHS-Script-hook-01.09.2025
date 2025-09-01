if ( SERVER ) then
	AddCSLuaFile()
else
	killicon.AddFont( "wep_jack_hmcd_shotgun", "HL2MPTypeDeath", "1", Color( 255, 0, 0 ) )
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_shotgun")
end

SWEP.IconTexture="vgui/wep_jack_hmcd_shotgun"
SWEP.IconLength=3
SWEP.IconHeight=2
SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName		= "Remington 870"
SWEP.Instructions	= "This is a typical civilian pump-action hunting shotgun. It has a 6-round magazine and fires 12-gauge 2-3/4 inch cartridges.\n\nLMB to fire.\nRMB to aim.\nRELOAD to reload.\nShot placement counts."
SWEP.Primary.ClipSize			= 6
SWEP.SlotPos=2
SWEP.ViewModel		= "models/weapons/gleb/c_870.mdl"
SWEP.WorldModel		= "models/weapons/w_shot_m3juper90.mdl"
SWEP.UseHands=true
SWEP.ViewModelFlip=false
SWEP.NoBulletInChamber=true
SWEP.Damage=15
SWEP.NumProjectiles=8
SWEP.Spread=.0285
SWEP.SprintPos=Vector(5,-1,-1)
SWEP.SprintAng=Angle(-20,70,-40)
SWEP.AimPos=Vector(-2.35,-1.5,1.3)
SWEP.AltAimPos=Vector(-1.95,-1.5,1.1)
SWEP.ReloadRate=.5
SWEP.AmmoType="Buckshot"
SWEP.SuppressedRifle=false
SWEP.SightRifle=false
SWEP.SightRifle2=false
SWEP.SightRifle3=false
SWEP.LaserRifle=false
SWEP.AttBone="body"
SWEP.AimTime=5
SWEP.BearTime=7
SWEP.TriggerDelay=.1
SWEP.LaserAngle=Angle(-90,-1.3,0.04)
SWEP.CycleTime=.9
SWEP.Recoil=1.5
SWEP.Supersonic=false
SWEP.Accuracy=.99
SWEP.HipFireInaccuracy=.07
SWEP.CloseFireSound="shtg_remington870/remington_fire_01.wav"
--SWEP.SuppressedFireSound="snd_jack_hmcd_supppistol.wav"
--SWEP.FarFireSound="snd_jack_hmcd_sht_far.wav"
--SWEP.CloseFireSound="toz_shotgun/toz_fp.wav"
SWEP.SuppressedFireSound="toz_shotgun/toz_suppressed_fp.wav"
SWEP.FarFireSound="toz_shotgun/toz_dist.wav"
SWEP.CycleSound="snd_jack_hmcd_shotpump.wav"
SWEP.ENT="ent_jack_hmcd_shotgun"
SWEP.MuzzleEffect="pcf_jack_mf_mshotgun"
SWEP.MuzzleEffectSuppressed="pcf_jack_mf_suppressed"
SWEP.MuzzleAttachment	= "gbib"
SWEP.CommandDroppable=true
SWEP.DeathDroppable=true
SWEP.WMShellAttachment=1
SWEP.WMShellInfo={lpos=Vector(-18.5,-0.5,-0.5),lang=Angle(90,0,0)}
SWEP.HipHoldType="shotgun"
SWEP.AimHoldType="ar2"
SWEP.DownHoldType="passive"
SWEP.FuckedWorldModel=true
SWEP.ReloadSound="snd_jack_shotguninsert.wav"
SWEP.ReloadType="individual"
SWEP.CycleType="manual"
SWEP.BarrelLength=10
SWEP.HolsterSlot=1
SWEP.HolsterPos=Vector(3.5,0,-4)
SWEP.HolsterAng=Angle(160,5,180)
SWEP.CarryWeight=5000
SWEP.ScopeDotPosition=Vector(0,0,0)
SWEP.ScopeDotAngle=Angle(0,0,0)
SWEP.MuzzlePos={25.7,-5.7,2.1}
SWEP.ShellDelay=.45
SWEP.BulletDir={400,1.95,-1.25}
SWEP.SuicidePos=Vector(3,7.5,-25.5)
SWEP.SuicideAng=Angle(110,2,90)
SWEP.SuicideTime=10
SWEP.SuicideType="Rifle"
SWEP.StallAnim="after_reload"
SWEP.StallTime=.1
SWEP.LoadAnim="insert"
SWEP.LoadFinishAnim="after_reload"
SWEP.StartReloadAnim="start_reload"
SWEP.MuzzleInfo={
	["Bone"]="body",
	["Offset"]=Vector(0,25,3)
}
SWEP.Attachments={
	["Owner"]={
		["Suppressor"]={
			bone="body",
			pos={
				right=7,
				forward=1.03,
				up=2.5
			},
			ang={
				up=-90
			},
			scale=.5,
			model="models/weapons/tfa_ins2/upgrades/att_suppressor_12ga.mdl",
			num=HMCD_SHOTGUNSUPP
		},
		["Laser"]={
			bone="body",
			pos={
				right=6.5,
				forward=-0.1,
				up=2.1
			},
			ang={
				up=90
			},
			scale=.5,
			model="models/cw2/attachments/anpeq15.mdl",
			aimpos=Vector(-2.35,-1.5,0.7),
			num=HMCD_LASERBIG
		},
		["Sight"]={
			bone="body",
			pos={
				right=6,
				forward=0,
				up=2
			},
			ang={
				up=-90
			},
			scale=.5,
			model="models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl",
			sightpos={
				right=20,
				forward=0,
				up=2.7
			},
			sightang={
				up=-90
			},
			aimpos=Vector(-2.35,-1.5,0.9),
			num=HMCD_KOBRA
		},
		["Sight2"]={
			bone="body",
			pos={
				right=6,
				forward=0,
				up=2.1
			},
			ang={
				up=-90
			},
			scale=.5,
			model="models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl",
			sightpos={
				right=15,
				forward=0,
				up=2.9
			},
			sightang={
				up=-90
			},
			aimpos=Vector(-2.35,-1.5,0.73),
			num=HMCD_AIMPOINT
		},
		["Sight3"]={
			bone="body",
			pos={
				right=6,
				forward=0,
				up=2.2
			},
			ang={
				up=-90
			},
			scale=.5,
			model="models/weapons/tfa_ins2/upgrades/a_optic_eotech.mdl",
			sightpos={
				right=20,
				forward=0,
				up=2.9
			},
			sightang={
				up=-90
			},
			aimpos=Vector(-2.35,-1.5,0.6),
			num=HMCD_EOTECH
		}
	},
	["Viewer"]={
		["Weapon"]={
			pos={
				right=1,
				up=1,
				forward=0
			},
			ang={
				forward=180,
				right=10
			}
		},
		["Suppressor"]={
			pos={
				forward=6.4,
				up=-6.3,
				right=2.4
			},
			ang={
				right=-10,
				forward=180
			},
			scale=.7,
			model="models/weapons/tfa_ins2/upgrades/att_suppressor_12ga.mdl"
		},
		["Laser"]={
			pos={
				forward=8.5,
				up=-6.3,
				right=0.8
			},
			ang={
				right=-10,
				forward=180,
				up=180
			},
			scale=.7,
			model="models/cw2/attachments/anpeq15.mdl"
		},
		["Sight"]={
			pos={
				forward=7.8,
				up=-6.3,
				right=0.9
			},
			ang={
				right=-10,
				forward=180
			},
			model="models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl"
		},
		["Sight2"]={
			pos={
				forward=7.8,
				up=-6.3,
				right=0.9
			},
			ang={
				right=-10,
				forward=180
			},
			model="models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl"
		},
		["Sight"]={
			pos={
				forward=7.8,
				up=-6.3,
				right=0.9
			},
			ang={
				right=-10,
				forward=180
			},
			model="models/weapons/tfa_ins2/upgrades/a_optic_eotech.mdl"
		}
	}
}