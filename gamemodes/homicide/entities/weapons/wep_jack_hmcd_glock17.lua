if ( SERVER ) then
	AddCSLuaFile()
else
	killicon.AddFont( "wep_jack_hmcd_pistol", "HL2MPTypeDeath", "1", Color( 255, 0, 0 ) )
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/entities/cw_nen_glock17")
end
SWEP.IconTexture="vgui/entities/cw_nen_glock17"
SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName		= "Glock-17"
SWEP.Instructions	= "This is a polymer-framed, short recoil-operated, locked-breech semi-automatic pistol using 9x19mm rounds.\n\nLMB to fire.\nRMB to aim.\nRELOAD to reload.\nShot placement counts.\nCrouching helps stability.\nBullets can ricochet and penetrate."
SWEP.ViewModel		= "models/weapons/tfa_ins2/c_glock_p80.mdl"
SWEP.WorldModel		= "models/weapons/tfa_ins2/w_glock_p80.mdl"
SWEP.Primary.ClipSize			= 18
SWEP.ENT="ent_jack_hmcd_glock17"
SWEP.HolsterSlot=2
SWEP.DrawAnim="base_draw"
SWEP.DrawAnimEmpty="empty_draw"
SWEP.UseHands=true
SWEP.ReloadAnim="base_reloadempty"
SWEP.TacticalReloadAnim="base_reload"
SWEP.FireAnim="base_fire"..math.random(2,3)..""
SWEP.IronFireAnim="iron_fire_"..math.random(1,3)..""
SWEP.TriggerDelay=.15
SWEP.AttBone = "glock in my rari"
SWEP.FuckedWorldModel=true
SWEP.LastFireAnim="base_firelast"
SWEP.LastIronFireAnim="iron_fire_last"
SWEP.DeathDroppable=true
SWEP.CloseFireSound="hndg_glock17/glock_fire_01.wav"
--SWEP.FarFireSound="snd_jack_hmcd_smp_far.wav"
SWEP.MuzzleEffectSuppressed="pcf_jack_mf_suppressed"
--SWEP.SuppressedFireSound="snd_jack_hmcd_supppistol.wav"
--SWEP.CloseFireSound="m9/m9_fp.wav"
SWEP.FarFireSound="m9/m9_dist.wav"
SWEP.SuppressedFireSound="m9/m9_suppressed_fp.wav"
SWEP.ReloadSound=""
SWEP.ReloadTime=3.6
SWEP.SprintPos=Vector(5,0,-18)
SWEP.AimPos=Vector(-2.35,-2.1,1.45)
SWEP.AltAimPos=Vector(2,-2.1,1.1)
SWEP.HipFireInaccuracy=.04
SWEP.LaserAngle=Angle(180,0,0)
SWEP.CarryWeight=1200
SWEP.MagDelay=.7
SWEP.MagEntity="ent_jack_hmcd_glock17mag"
SWEP.MuzzlePos={13.3,-4,1.6}
SWEP.ViewModelFlip=false
SWEP.ReloadAdd=0.7
SWEP.ReloadSounds={
	{"weapons/ins2/p80/m9_magout.wav", 0.7, "Both"},
	{"weapons/ins2/p80/m9_magin.wav", 1.8, "Both"},
	{"weapons/ins2/p80/m9_maghit.wav", 2.1, "Both"},
	{"weapons/ins2/p80/m9_boltback.wav", 3.3, "EmptyOnly"},
	{"weapons/ins2/p80/m9_boltrelease.wav", 3.5, "EmptyOnly"}
}
SWEP.DeployVolume=60
SWEP.BulletDir={400,1.3,-1}
SWEP.SuicidePos=Vector(15,0,-20)
SWEP.SuicideAng=Angle(90,30,90)
SWEP.SuicideSuppr=Vector(4,0,-8)
SWEP.MuzzleInfo={
	["Bone"]="A_Muzzle",
	["Offset"]=Vector(20,2,-1)
}
SWEP.Attachments={
	["Owner"]={
		["Suppressor"]={
			bone="gun barrel in my ass",
			pos={
				right=-0.4,
				forward=-8,
				up=-1.25
			},
			ang={
				up=90
			},
			model="models/cw2/attachments/9mmsuppressor.mdl",
			num=HMCD_PISTOLSUPP
		},
		["Laser"]={
			bone="glock in my rari",
			pos={
				right=-0.4,
				forward=-4,
				up=0.15
			},
			ang={
				forward=90,
				right=180
			},
			scale=.7,
			model="models/weapons/tfa_ins2/upgrades/laser_pistol.mdl",
			num=HMCD_LASERSMALL
		}
	},
	["Viewer"]={
		["Weapon"]={
			pos={
				right=1.25,
				up=-2,
				forward=3.5
			},
			ang={
				forward=180,
				right=10
			}
		},
		["Suppressor"]={
			pos={
				forward=13.5,
				up=-3.65,
				right=1.25
			},
			ang={
				right=100,
				up=90,
				forward=290
			},
			model="models/cw2/attachments/9mmsuppressor.mdl"
		},
		["Laser"]={
			pos={
				forward=8.5,
				up=-3,
				right=1.2
			},
			ang={
				right=-10,
				forward=185
			},
			scale=.9,
			model="models/weapons/tfa_ins2/upgrades/laser_pistol.mdl"
		}
	}
}

--[[ -- Hybrid suppressor
	self.VMSuppModel3=ClientsideModel("models/cw2/attachments/556suppressor.mdl")
	self.VMSuppModel3:SetModelScale(.7,0)
	local matr=vm:GetBoneMatrix(vm:LookupBone("gun barrel in my ass"))
	self.VMSuppModel3:SetRenderOrigin(pos-ang:Right()*0.3+ang:Forward()*8-ang:Up()*-2.1)
	ang:RotateAroundAxis(ang:Up(),90)
	ang:RotateAroundAxis(ang:Forward(),180)
	ang:RotateAroundAxis(ang:Right(),0)
]]