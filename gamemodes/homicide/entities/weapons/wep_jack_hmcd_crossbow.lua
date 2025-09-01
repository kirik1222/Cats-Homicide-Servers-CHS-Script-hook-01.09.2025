if ( SERVER ) then
	AddCSLuaFile()
else
	killicon.AddFont( "wep_jack_hmcd_rifle", "HL2MPTypeDeath", "1", Color( 255, 0, 0 ) )
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_crossbow")
end
SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.IconTexture="vgui/wep_jack_hmcd_crossbow"
SWEP.IconLength=2
SWEP.PrintName		= "Crossbow"
SWEP.Instructions	= "This is a ranged weapon that fires red-hot bolts of steel rebar, constructed by Resistance fighters from the scavenged junk and debris.\nRMB to aim.\nRELOAD to reload.\nShot placement counts.\nCrouching helps stability."
SWEP.Primary.ClipSize			= 1
SWEP.ViewModel		= "models/weapons/c_crossbow_h.mdl"
SWEP.WorldModel		= "models/weapons/w_crossbow.mdl"
SWEP.ViewModelFlip=false
SWEP.Damage=115
SWEP.UseHands=true
SWEP.SprintPos=Vector(15,-3,-6)
SWEP.SprintAng=Angle(0,60,-30)
SWEP.AimPos=Vector(-6,-9,.5)
SWEP.AltAimPos=Vector(1.8,-3.3,1.5)
SWEP.AimAng=Angle(1,0,0)
SWEP.ReloadTime=4.5
SWEP.ReloadRate=.75
SWEP.ReloadSound=""
SWEP.AmmoType="Thumper"
SWEP.TriggerDelay=.2
SWEP.Recoil=0.5
SWEP.Supersonic=false
SWEP.Accuracy=.9999
SWEP.ShotPitch=100
SWEP.ENT="ent_jack_hmcd_crossbow"
SWEP.DeathDroppable=true
SWEP.CommandDroppable=true
SWEP.CycleType=""
SWEP.ReloadType="magazine"
SWEP.DrawAnim="draw"
SWEP.DrawAnimEmpty="draw_empty"
SWEP.FireAnim="fire"
SWEP.ReloadAnim="reload"
SWEP.CloseFireSound="weapons/crossbow/fire1.wav"
SWEP.FarFireSound=""
SWEP.ShellType=""
SWEP.Scoped=true
SWEP.ViewModelFOV = 60
SWEP.ScopeFoV=15
SWEP.ScopedSensitivity=.1
SWEP.BarrelLength=18
SWEP.AimTime=6.25
SWEP.BearTime=9
SWEP.FuckedWorldModel=true
SWEP.HipHoldType="shotgun"
SWEP.AimHoldType="ar2"
SWEP.DownHoldType="passive"
SWEP.MuzzleEffect=""
SWEP.HolsterSlot=1
SWEP.HipFireInaccuracy=.05
SWEP.CarryWeight=2000
SWEP.MuzzlePos={0,0,0}
SWEP.DrawRate=1
SWEP.NoBulletInChamber=true
SWEP.ReloadAdd=0
SWEP.ReloadSounds={
	{"weapons/crossbow/crossbow_draw.wav", 0.9, "Both"},
	{"weapons/crossbow/bolt_load"..math.random(1,2)..".wav", 3, "Both"}
}
SWEP.BulletDir={400,0.3,-1}
SWEP.Attachments={
	["Viewer"]={
		["Weapon"]={
			pos={
				right=-1.4,
				up=0,
				forward=0
			},
			ang={
				forward=180,
				right=15
			}
		}
	}
}

function SWEP:AltPrimaryFire()
	if(CLIENT)then return end
	self.Owner:SetLagCompensated(true)
	local Bolt=ents.Create("ent_jack_hmcd_arrow")
	Bolt.Model="models/crossbow_bolt.mdl"
	Bolt.FleshyImpactSound="weapons/crossbow/bolt_skewer1.wav"
	Bolt.Damage=160
	Bolt.PenetrationPower=70
	Bolt.HmcdSpawned=self.HmcdSpawned
	Bolt:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*50+self.Owner:GetRight()*2+self.Owner:GetUp()*-0.5)
	Bolt.Owner=self.Owner
	local Ang=self.Owner:GetAimVector():Angle()
	Ang:RotateAroundAxis(Ang:Right(),-180)
	Bolt:SetAngles(Ang)
	Bolt.Fired=true
	Bolt.InitialDir=self.Owner:GetAimVector()
	Bolt.InitialVel=self.Owner:GetVelocity()
	Bolt.Poisoned=self.Owner.HMCD_AmmoPoisoned
	self.Owner.HMCD_AmmoPoisoned=false
	Bolt:Spawn()
	Bolt:Activate()
	self.Owner:SetLagCompensated(false)
	self.Owner:GetViewModel():SetSkin(0)
end