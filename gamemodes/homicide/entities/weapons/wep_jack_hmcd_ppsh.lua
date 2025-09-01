if ( SERVER ) then
	AddCSLuaFile()
else
	killicon.AddFont( "wep_jack_hmcd_assaultrifle", "HL2MPTypeDeath", "1", Color( 255, 0, 0 ) )
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/hud/tfa_smc_ppsh_drum")
end
SWEP.IconTexture="vgui/hud/tfa_smc_ppsh_drum"
SWEP.IconLength=3
SWEP.IconHeight=2
SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName		= "PPSH-41"
SWEP.Instructions	= "This is an open-bolt, blowback submachine gun firing 9x19mm Parabellum rounds. \n\nLMB to fire.\nRMB to aim.\nRELOAD to reload.\nShot placement counts.\nCrouching helps stability.\nBullets can ricochet and penetrate."
SWEP.Primary.ClipSize			= 71
SWEP.ViewModel		= "models/weapons/smc/ppsh/v_ppsh_drum_mag.mdl"
SWEP.WorldModel		= "models/weapons/smc/ppsh/w_ppshdrummag.mdl"
SWEP.UseHands=true
SWEP.ViewModelFlip=false
SWEP.Damage=30
SWEP.FuckedWorldModel=true
SWEP.SprintPos=Vector(10,8,0)
SWEP.SprintAng=Angle(-30,60,0)
SWEP.AimPos=Vector(-2.55, -1.5, 0.9)
SWEP.AimAng=Angle(1,3.425,-2)
SWEP.ReloadTime=5
SWEP.ReloadRate=1
SWEP.AmmoType="Pistol"
SWEP.TriggerDelay=0.06
SWEP.Primary.Automatic=true
SWEP.Recoil=.3
SWEP.Supersonic=true
SWEP.Accuracy=.99
SWEP.ShotPitch=100
SWEP.ENT="ent_jack_hmcd_ppsh"
SWEP.DeathDroppable=true
SWEP.CommandDroppable=true
SWEP.CloseFireSound="smg_mac10/mac10_fire_01.wav"
--SWEP.FarFireSound="snd_jack_hmcd_smp_far.wav"
--SWEP.CloseFireSound="mp5k/mp5k_fp.wav"
SWEP.FarFireSound="mp5k/mp5k_dist.wav"
SWEP.SuppressedFireSound="mp5k/mp5k_suppressed_fp.wav"
SWEP.BarrelLength=6
SWEP.FireAnimRate=1
SWEP.DrawAnim="base_draw"
SWEP.FireAnim="Fire"
SWEP.IronFireAnim="iron fire 2"
SWEP.ReloadAnim="empty reload"
SWEP.TacticalReloadAnim="reload"
SWEP.AimTime=6
SWEP.BearTime=7
SWEP.HipHoldType="crossbow"
SWEP.AimHoldType="smg"
SWEP.DownHoldType="passive"
SWEP.MuzzleEffect="pcf_jack_mf_spistol"
SWEP.MuzzleEffectSuppressed="pcf_jack_mf_suppressed"
SWEP.HipFireInaccuracy=.05
SWEP.HolsterSlot=1
SWEP.HolsterPos=Vector(2.3,-8,0)
SWEP.HolsterAng=Angle(160,10,180)
SWEP.CarryWeight=2500
SWEP.NextFireTime=0
SWEP.ScopeDotPosition=Vector(0,0,0)
SWEP.ScopeDotAngle=Angle(0,0,0)
SWEP.ShellEffect="eff_jack_hmcd_919"
SWEP.VMShellInfo={lang=Angle(0,-60,0)}
SWEP.MuzzlePos={25,-10,1}
SWEP.ReloadAdd=0.8
SWEP.ReloadSounds={
	{"weapons/ppsh/ppsh_magout.wav",1.2,"Both"},
	{"weapons/ppsh/ppsh_magin.wav",3.55,"EmptyOnly"},
	{"weapons/ppsh/ppsh_magin.wav",4,"FullOnly"},
	{"weapons/ppsh/ppsh_boltback.wav",4.7,"EmptyOnly"}
}
SWEP.MagDelay=1.2
SWEP.BulletDir={400,2.85,-1}
SWEP.SuicidePos=Vector(4,7,-28)
SWEP.SuicideAng=Angle(110,2,90)
SWEP.SuicideTime=10
SWEP.SuicideType="Rifle"
SWEP.MagEntity="ent_jack_hmcd_ppshmag"
SWEP.MuzzleInfo={
	["Bone"]="Weapon",
	["Offset"]=Vector(0,-2,30)
}
SWEP.Attachments={
	["Viewer"]={
		["Weapon"]={
			pos={
				right=1,
				up=-0.5,
				forward=6
			},
			ang={
				forward=180,
				right=10
			}
		}
	}
}
SWEP.NPCAnims={
	[ ACT_RANGE_ATTACK1 ] 				= ACT_RANGE_ATTACK_SMG1,
	[ ACT_RELOAD ] 					= ACT_RELOAD_SMG1,
	[ ACT_IDLE ] 						= ACT_IDLE_SMG1,
	[ ACT_IDLE_ANGRY ] 				= ACT_RANGE_ATTACK_SMG1,
	[ ACT_WALK ] 						= ACT_WALK_RIFLE,
	[ ACT_IDLE_RELAXED ] 				= ACT_IDLE_RELAXED,
	[ ACT_IDLE_STIMULATED ] 			= ACT_IDLE_STIMULATED,
	[ ACT_IDLE_AGITATED ] 				= ACT_IDLE_ANGRY_SMG1,
	[ ACT_WALK_RELAXED ] 				= ACT_WALK_RELAXED,
	[ ACT_WALK_STIMULATED ] 			= ACT_WALK_STIMULATED,
	[ ACT_WALK_AGITATED ] 				= ACT_WALK_AIM_RIFLE,
	[ ACT_RUN_RELAXED ] 				= ACT_RUN_RELAXED,
	[ ACT_RUN_STIMULATED ] 			= ACT_RUN_STIMULATED,
	[ ACT_RUN_AGITATED ] 				= ACT_RUN_AIM_RIFLE,
	[ ACT_IDLE_AIM_RELAXED ] 			= ACT_IDLE_RELAXED,
	[ ACT_IDLE_AIM_STIMULATED ] 		= ACT_IDLE_AIM_STIMULATED,
	[ ACT_IDLE_AIM_AGITATED ] 			= ACT_IDLE_ANGRY_SMG1,
	[ ACT_WALK_AIM_RELAXED ] 			= ACT_WALK_RELAXED,
	[ ACT_WALK_AIM_STIMULATED ] 		= ACT_WALK_AIM_STIMULATED,
	[ ACT_WALK_AIM_AGITATED ] 			= ACT_WALK_AIM_RIFLE,
	[ ACT_RUN_AIM_RELAXED ] 			= ACT_RUN_RELAXED,
	[ ACT_RUN_AIM_STIMULATED ] 		= ACT_RUN_AIM_STIMULATED,
	[ ACT_RUN_AIM_AGITATED ] 			= ACT_RUN_AIM_RIFLE,
	[ ACT_WALK_AIM ] 					= ACT_WALK_AIM_RIFLE,
	[ ACT_WALK_CROUCH ] 				= ACT_WALK_CROUCH,
	[ ACT_WALK_CROUCH_AIM ] 			= ACT_WALK_CROUCH_AIM,
	[ ACT_RUN ] 						= ACT_RUN_RIFLE,
	[ ACT_RUN_AIM ] 					= ACT_RUN_AIM_RIFLE,
	[ ACT_RUN_CROUCH ] 				= ACT_RUN_CROUCH,
	[ ACT_RUN_CROUCH_AIM ] 			= ACT_RUN_CROUCH_AIM,
	[ ACT_GESTURE_RANGE_ATTACK1 ] 		= ACT_GESTURE_RANGE_ATTACK_SMG1,
	[ ACT_RANGE_AIM_LOW ] 				= ACT_RANGE_AIM_SMG1_LOW,
	[ ACT_RANGE_ATTACK1_LOW ] 			= ACT_RANGE_ATTACK_SMG1,
	[ ACT_RELOAD_LOW ] 				= ACT_RELOAD,
	[ ACT_GESTURE_RELOAD ] 			= ACT_GESTURE_RELOAD,
	[ ACT_MELEE_ATTACK1 ] 				= ACT_MELEE_ATTACK1
}