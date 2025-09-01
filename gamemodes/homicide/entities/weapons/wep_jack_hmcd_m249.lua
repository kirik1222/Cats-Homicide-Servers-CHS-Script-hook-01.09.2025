if ( SERVER ) then
	AddCSLuaFile()
else
	killicon.AddFont( "wep_jack_hmcd_assaultrifle", "HL2MPTypeDeath", "1", Color( 255, 0, 0 ) )
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/inventory/weapon_m249")
end
SWEP.IconTexture="vgui/inventory/weapon_m249"
SWEP.IconLength=3
SWEP.IconHeight=2
SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName		= "M249"
SWEP.Instructions	= "This is a gas-operated, air-cooled, belt-fed, automatic weapon that fires 5.56x45mm rounds.\n\nLMB to fire.\nRMB to aim.\nRELOAD to reload.\nShot placement counts.\nCrouching helps stability.\nBullets can ricochet and penetrate."
SWEP.Primary.ClipSize			= 200
SWEP.ViewModel		= "models/weapons/v_m249.mdl"
SWEP.WorldModel		= "models/weapons/w_m249.mdl"
SWEP.ViewModelFlip=false
SWEP.Damage=90
SWEP.ViewModelFOV = 60
SWEP.Primary.Automatic=true
SWEP.SprintPos=Vector(9,-1,-3)
SWEP.SprintAng=Angle(-20,60,-40)
SWEP.AimPos=Vector(-2.05,-2,0.95)
SWEP.CloseAimPos=Vector(.45,0,0)
SWEP.AltAimPos=Vector(-1.902,-3.2,.13)
SWEP.ReloadRate=1
SWEP.UseHands=true
SWEP.AmmoType="SMG1"
SWEP.TriggerDelay=.059
SWEP.Recoil=.5
SWEP.AttBone="LidCont"
SWEP.LaserAngle=Angle(-90.65,-90,0.6)
SWEP.Supersonic=true
SWEP.Accuracy=.999
SWEP.ShotPitch=100
SWEP.ENT="ent_jack_hmcd_m249"
SWEP.FuckedWorldModel=true
SWEP.DeathDroppable=true
SWEP.CommandDroppable=true
SWEP.CycleType="auto"
SWEP.ReloadType="magazine"
SWEP.DrawAnim="base_draw"
SWEP.FireAnim="base_fire_1"
SWEP.IronFireAnim="iron_fire_1"
SWEP.BipodFireAnim="deployed_fire_1"
SWEP.BipodIronFireAnim="deployed_iron_fire_1"
SWEP.ReloadAnimEmpty="base_reload_empty"
SWEP.ReloadAnim="base_reload"
SWEP.ReloadAnimHalf="base_reload_half"
SWEP.BipodReloadAnimEmpty="deployed_reload_empty"
SWEP.BipodReloadAnim="deployed_reload"
SWEP.BipodReloadAnimHalf="deployed_reload_half"
SWEP.CloseFireSound="rifle_win1892/win1892_fire_01.wav"
--SWEP.SuppressedFireSound="snd_jack_hmcd_supppistol.wav"
--SWEP.FarFireSound="snd_jack_hmcd_ar_far.wav"
--SWEP.CloseFireSound="m249/m249_fp.wav"
SWEP.ShellAttachment=3
SWEP.WMShellAttachment=2
SWEP.AdditionalShellEffects={"M249Link"}
SWEP.FarFireSound="m249/m249_dist.wav"
SWEP.SuppressedFireSound="m249/m249_suppressed_fp.wav"
SWEP.ShellType=""
SWEP.BarrelLength=18
SWEP.FireAnimRate=1
SWEP.AimTime=6
SWEP.BearTime=7
SWEP.HipHoldType="shotgun"
SWEP.AimHoldType="ar2"
SWEP.DownHoldType="passive"
SWEP.MuzzleEffect="pcf_jack_mf_mrifle2"
SWEP.MuzzleEffectSuppressed="pcf_jack_mf_suppressed"
SWEP.HipFireInaccuracy=.05
SWEP.HolsterSlot=1
SWEP.CarryWeight=6000
SWEP.ScopeDotPosition=Vector(0,0,0)
SWEP.ScopeDotAngle=Angle(0,0,0)
SWEP.NextFireTime=0
SWEP.BipodFireAnim={"deployed_fire_1","deployed_fire_2"}
SWEP.BipodIronFireAnim={"deployed_iron_fire_1","deployed_iron_fire_2"}
SWEP.InsHands=true
SWEP.MuzzlePos={25.5,-5.1-4.1}
SWEP.BulletDir={400,2,-1.5}
SWEP.BipodUsable=true
SWEP.BipodPlaceAnim="deployed_in"
SWEP.BipodRemoveAnim="deployed_out"
SWEP.BipodDeploySound={.5,"weapons/m249/handling/m249_bipoddeploy.wav"}
SWEP.BipodRemoveSound={.5,"weapons/m249/handling/m249_bipodretract.wav"}
SWEP.BipodOffset=10
SWEP.BipodAimOffset=Vector(0,2.05,-0.95)
SWEP.SuicidePos=Vector(3.5,6.5,-29)
SWEP.SuicideAng=Angle(100,0,90)
SWEP.SuicideTime=10
SWEP.SuicideType="Rifle"
SWEP.MuzzleInfo={
	["Bone"]="A_Muzzle",
	["Offset"]=Vector(30,2,-2)
}

SWEP.Attachments={
	["Owner"]={
		["Suppressor"]={
			bone="A_Suppressor",
			pos={
				right=11,
				forward=-2.05,
				up=-0.05
			},
			ang={
				up=180,
				right=90
			},
			scale=.7,
			model="models/cw2/attachments/556suppressor.mdl",
			num=HMCD_RIFLESUPP
		},
		["Laser"]={
			bone="LidCont",
			pos={
				right=-4,
				forward=-0.2,
				up=0.3
			},
			ang={
				up=90
			},
			scale=.5,
			model="models/cw2/attachments/anpeq15.mdl",
			aimpos=Vector(-2.05,-1.5,0.25),
			bipodpos=Vector(0,2,-0.2),
			num=HMCD_LASERBIG
		},
		["Sight"]={
			bone="LidCont",
			pos={
				right=-3,
				forward=-0.2,
				up=0.5
			},
			ang={
				up=270
			},
			scale=.7,
			model="models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl",
			sightpos={
				right=9.15,
				forward=-0.3,
				up=1.45
			},
			sightang={
				up=-90
			},
			aimpos=Vector(-1.95,-1.5,0.25),
			bipodpos=Vector(0,2,-0.2),
			num=HMCD_KOBRA
		},
		["Sight2"]={
			bone="LidCont",
			pos={
				right=-3.2,
				forward=-0.2,
				up=0.5
			},
			ang={
				up=270
			},
			scale=.7,
			model="models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl",
			sightpos={
				right=9.15,
				forward=-0.3,
				up=1.5
			},
			sightang={
				up=-90
			},
			aimpos=Vector(-1.95,-1.5,0.17),
			bipodpos=Vector(0,2,-.05),
			num=HMCD_AIMPOINT
		},
		["Sight3"]={
			bone="LidCont",
			pos={
				right=-3.2,
				forward=-0.2,
				up=0.5
			},
			ang={
				up=270
			},
			scale=.7,
			model="models/weapons/tfa_ins2/upgrades/a_optic_eotech.mdl",
			sightpos={
				right=9.15,
				forward=-0.3,
				up=1.55
			},
			sightang={
				up=-90
			},
			aimpos=Vector(-1.95,-1.5,0.15),
			bipodpos=Vector(0,2,-.05),
			num=HMCD_EOTECH
		}
	},
	["Viewer"]={
		["Weapon"]={
			pos={
				right=1,
				forward=5,
				up=-1
			},
			ang={
				forward=180,
			}
		},
		["Suppressor"]={
			pos={
				forward=13.5,
				up=-7.4,
				right=1.1
			},
			ang={
				right=270,
				up=90,
				forward=270
			},
			scale=.9,
			model="models/cw2/attachments/556suppressor.mdl"
		},
		["Laser"]={
			pos={
				forward=7,
				up=-6.4,
				right=1.2
			},
			ang={
				forward=180,
				up=180
			},
			scale=.9,
			model="models/cw2/attachments/anpeq15.mdl"
		},
		["Sight"]={
			pos={
				forward=6,
				up=-6.4,
				right=1
			},
			ang={
				forward=180
			},
			scale=.9,
			model="models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl"
		},
		["Sight2"]={
			pos={
				forward=6,
				up=-6.6,
				right=1
			},
			ang={
				forward=180
			},
			scale=.9,
			model="models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl"
		},
		["Sight3"]={
			pos={
				forward=6,
				up=-6.6,
				right=1
			},
			ang={
				forward=180
			},
			scale=.9,
			model="models/weapons/tfa_ins2/upgrades/a_optic_eotech.mdl"
		}
	}
}
function SWEP:GetReloadAnim()
	local vmBG=self.Owner:GetViewModel():GetBodygroup(1)
	local name
	if vmBG==16 then
		name="ReloadAnim"
	elseif vmBG==0 then
		name="ReloadAnimEmpty"
	else
		name="ReloadAnimHalf"
	end
	if self.BipodAmt==100 then name="Bipod"..name end
	return self[name]
end

function SWEP:ReloadTime()
	local vmBG=self.Owner:GetViewModel():GetBodygroup(1)
	if vmBG==0 then
		if self.BipodAmt==100 then
			return 10.25
		else
			return 11
		end
	elseif vmBG==16 then
		if self.BipodAmt==100 then
			return 8.5
		else
			return 9
		end
	else
		if self.BipodAmt==100 then
			return 9.25
		else
			return 9.75
		end
	end
end

local function reset_bgs(self)
	local totalAmmo=self.Owner:GetAmmoCount(self.AmmoType)+self:Clip1()
	self.Owner:GetViewModel():SetBodygroup(1,math.min(totalAmmo,16))
end

local reloadSounds_full={
	{"weapons/m249/handling/m249_coveropen.wav", 0.9, "Both"},
	{"weapons/m249/handling/m249_magout.wav", 2, "Both"},
	{"weapons/m249/handling/m249_fetchmag.wav", 3, "Both", reset_bgs},
	{"weapons/m249/handling/m249_magin.wav", 4.7, "Both"},
	{"weapons/m249/handling/m249_bulletjingle.wav", 5.5, "Both"},
	{"weapons/m249/handling/m249_coverclose.wav", 7, "Both"}
}

local reloadSounds_full_bipod={
	{"weapons/m249/handling/m249_coveropen.wav", 0.9, "Both"},
	{"weapons/m249/handling/m249_magout.wav", 2, "Both"},
	{"weapons/m249/handling/m249_fetchmag.wav", 3, "Both", reset_bgs},
	{"weapons/m249/handling/m249_magin.wav", 4.7, "Both"},
	{"weapons/m249/handling/m249_bulletjingle.wav", 5.5, "Both"},
	{"weapons/m249/handling/m249_coverclose.wav", 6.8, "Both"}
}

local reloadSounds_halfFull={
	{"weapons/m249/handling/m249_coveropen.wav", 0.9, "Both"},
	{"weapons/m249/handling/m249_beltremove.wav", 1.9, "Both"},
	{"weapons/m249/handling/m249_magout.wav", 3, "Both"},
	{"weapons/m249/handling/m249_fetchmag.wav", 4, "Both", reset_bgs},
	{"weapons/m249/handling/m249_magin.wav", 5.7, "Both"},
	{"weapons/m249/handling/m249_bulletjingle.wav", 6.5, "Both"},
	{"weapons/m249/handling/m249_coverclose.wav", 7.9, "Both"}
}

local reloadSounds_halfFull_bipod={
	{"weapons/m249/handling/m249_coveropen.wav", 0.9, "Both"},
	{"weapons/m249/handling/m249_beltremove.wav", 1.9, "Both"},
	{"weapons/m249/handling/m249_magout.wav", 3, "Both"},
	{"weapons/m249/handling/m249_fetchmag.wav", 4, "Both", reset_bgs},
	{"weapons/m249/handling/m249_magin.wav", 5.5, "Both"},
	{"weapons/m249/handling/m249_bulletjingle.wav", 6.3, "Both"},
	{"weapons/m249/handling/m249_coverclose.wav", 7.65, "Both"}
}

local reloadSounds_empty={
	{"weapons/m249/handling/m249_boltback.wav", 1, "Both"},
	{"weapons/m249/handling/m249_boltrelease.wav", 1.3, "Both"},
	{"weapons/m249/handling/m249_coveropen.wav", 2.8, "Both"},
	{"weapons/m249/handling/m249_magout.wav", 4, "Both"},
	{"weapons/m249/handling/m249_fetchmag.wav", 5, "Both", reset_bgs},
	{"weapons/m249/handling/m249_magin.wav", 6.7, "Both"},
	{"weapons/m249/handling/m249_bulletjingle.wav", 7.7, "Both"},
	{"weapons/m249/handling/m249_coverclose.wav", 9.02, "Both"}
}

local reloadSounds_empty_bipod={
	{"weapons/m249/handling/m249_boltback.wav", 1, "Both"},
	{"weapons/m249/handling/m249_boltrelease.wav", 1.3, "Both"},
	{"weapons/m249/handling/m249_coveropen.wav", 2.8, "Both"},
	{"weapons/m249/handling/m249_magout.wav", 4, "Both"},
	{"weapons/m249/handling/m249_fetchmag.wav", 5, "Both", reset_bgs},
	{"weapons/m249/handling/m249_magin.wav", 6.5, "Both"},
	{"weapons/m249/handling/m249_bulletjingle.wav", 7.3, "Both"},
	{"weapons/m249/handling/m249_coverclose.wav", 8.62, "Both"}
}

function SWEP:ReloadSounds()
	local vmBG=self.Owner:GetViewModel():GetBodygroup(1)
	if vmBG==0 then
		if self.BipodAmt==100 then return reloadSounds_empty_bipod end
		return reloadSounds_empty
	elseif vmBG==16 then
		if self.BipodAmt==100 then return reloadSounds_full_bipod end
		return reloadSounds_full
	else
		if self.BipodAmt==100 then return reloadSounds_halfFull_bipod end
		return reloadSounds_halfFull		
	end
end
