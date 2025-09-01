if ( SERVER ) then
AddCSLuaFile()
else
killicon.AddFont( "wep_jack_hmcd_dbarrel", "HL2MPTypeDeath", "1", Color( 255, 0, 0 ) )
SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_dbarrel")
end
SWEP.IconLength=2
SWEP.IconTexture="vgui/wep_jack_hmcd_dbarrel"
SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName		= "IZH-43 Sawed Off"
SWEP.Instructions	= "This is a shotgun with two parallel barrels, allowing two shots to be fired in quick succession. It fires 12-gauge 2-3/4 inch cartridges.\n\nLMB to fire.\nRMB to aim.\nRELOAD to reload.\nShot placement counts."
SWEP.Primary.ClipSize			= 2
SWEP.SlotPos=2
SWEP.ViewModel		= "models/weapons/ethereal/v_sawnoff_db.mdl"
SWEP.WorldModel		= "models/weapons/ethereal/w_sawnoff_db.mdl"
SWEP.ViewModelFlip=false
SWEP.UseHands=true
SWEP.Damage=15
SWEP.NumProjectiles=8
SWEP.Spread=.0285
SWEP.SprintPos=Vector(5,-1,-1)
SWEP.SprintAng=Angle(-15,50,-35)
SWEP.AimPos=Vector(-1.7,-1,1.5)
SWEP.ReloadRate=1
SWEP.AmmoType="Buckshot"
SWEP.FireAnim="base_fire"
SWEP.LastFireAnim="base_firelast"
SWEP.ReloadAnim="base_reloadempty"
SWEP.TacticalReloadAnim="base_reload"
SWEP.AimTime=5
SWEP.BearTime=7
SWEP.TriggerDelay=.1
SWEP.Recoil=1
SWEP.Supersonic=false
SWEP.Accuracy=1
SWEP.HipFireInaccuracy=.05
SWEP.CloseFireSound="shtg_remington870/remington_fire_01.wav"
--SWEP.CloseFireSound="toz_shotgun/toz_fp.wav"
SWEP.SuppressedFireSound="toz_shotgun/toz_suppressed_fp.wav"
SWEP.FarFireSound="toz_shotgun/toz_dist.wav"
 -- SWEP.CycleSound="snd_jack_hmcd_shotpump.wav"
SWEP.ENT="ent_jack_hmcd_dbarrel"
SWEP.MuzzleEffect="pcf_jack_mf_mshotgun"
SWEP.CommandDroppable=true
SWEP.DeathDroppable=true
SWEP.DrawAnim="base_draw"
SWEP.UseHands=true
SWEP.ShellAttachment=4
SWEP.WMShellAttachment=2
SWEP.ShellInfo={randomizePos=3,velMul=0.01,noSmoke=true}
SWEP.HipHoldType="shotgun"
SWEP.AimHoldType="ar2"
SWEP.DownHoldType="passive"
SWEP.FuckedWorldModel=true
SWEP.ReloadType="clip"
SWEP.CycleType="auto"
SWEP.BarrelLength=7
SWEP.HolsterSlot=1
SWEP.CarryWeight=3200
SWEP.InsHands=true
SWEP.ReloadTime=4.3
SWEP.ReloadAdd=1.5
SWEP.MuzzlePos={15,6,-1}
SWEP.MagDelay=1.3
SWEP.ShellEffect=""
SWEP.ShellEffectReload="eff_jack_hmcd_12gauge"
SWEP.NoBulletInChamber=true
SWEP.SuicidePos=Vector(3,9.5,-25.5)
SWEP.SuicideAng=Angle(110,2,90)
SWEP.SuicideTime=10
SWEP.SuicideType="SMG"
SWEP.ReloadSounds={
	{"weapons/toz66/breakopen.wav", .4, "Both"},
	{"weapons/toz66/shellgrab.wav", 1.2, "FullOnly"},
	{"weapons/toz66/shellgrab1.wav", 1.3, "FullOnly"},
	{"weapons/toz66/shellinsert"..math.random(1,2)..".wav", 2.6, "FullOnly"},
	{"weapons/toz66/breakclose.wav", 3.5, "FullOnly"},
	{"weapons/toz66/shellseject.wav", 1.1, "EmptyOnly"},
	{"weapons/toz66/shellinsert"..math.random(1,2)..".wav", 3, "EmptyOnly"},
	{"weapons/toz66/shellinsert"..math.random(1,2)..".wav", 3.9, "EmptyOnly"},
	{"weapons/toz66/breakclose.wav", 4.8, "EmptyOnly"}
}
SWEP.MuzzleInfo={
	["Bone"]="A_Muzzle",
	["Offset"]=Vector(30,3,0)
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
				right=10
			}
		}
	}
}