
SWEP.Base="wep_jack_hmcd_flashbang"
SWEP.ViewModel = "models/weapons/arc9/darsu_eft/c_zarya_2.mdl"
SWEP.WorldModel = "models/weapons/arc9/darsu_eft/w_zarya.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_zarya");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_zarya"
SWEP.PrintName = "Zarya-2"
SWEP.Instructions	= "This compact Russian stun grenade emits an intense, blinding flash of light combined with a powerful concussive blast designed to temporarily disorient enemies.\n\nLeft click to arm and throw.\nHold LMB to delay the throw.\nRight click while holding LMB to remove the safety handle."
SWEP.ENT="ent_jack_hmcd_zarya"
SWEP.PullPinAnim="fire_start"
SWEP.PinOutTime=.5
SWEP.PinOutSound="weapons/m67/m67_pullpin.wav"
SWEP.ThrowReadyDelay=1.1
SWEP.DrawAnim="draw"
SWEP.Riggable=true
SWEP.RigRate=1
SWEP.RigPinTime=.5
SWEP.RigTime=1.2
SWEP.RigAnim="fire_start"
SWEP.RigReturnTime=1.4
SWEP.RigNextFire=2.5
SWEP.ThrowAnim="fire1"
SWEP.ThrowRate=1.5
SWEP.ThrowSound="weapons/m67/m67_throw_01.wav"
SWEP.ThrowInitialPunch=Angle(-10,-5,0)
SWEP.SecondaryPunchDelay=0.15
SWEP.ThrowSecondaryPunch=Angle(20,10,0)
SWEP.ThrowDelay=0.3
SWEP.MinExplodeTime=2
SWEP.MaxExplodeTime=2
SWEP.SpoonModel="models/weapons/arc9/darsu_eft/skobas/zarya_skoba.mdl"
SWEP.VMPos=Vector(0,-1,0)
SWEP.NextThrowDelay=2
SWEP.KeepUpOnRun=true

function SWEP:SetupDataTables()
	self:NetworkVar("Int",0,"Amount")
end