if ( SERVER ) then
	AddCSLuaFile()
else
	killicon.AddFont( "wep_jack_hmcd_pistol", "HL2MPTypeDeath", "1", Color( 255, 0, 0 ) )
end
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_taser");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_taser"
SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName		= "X26 Taser"
SWEP.Instructions	= "This is a conducted electrical weapon firing two small barbed darts intended to puncture the skin of the target and cause neuromuscular incapacitation.\n\nLMB to fire.\nRMB to aim.\nRELOAD to reload."
SWEP.Primary.ClipSize			= 1
SWEP.AmmoType = "SniperPenetratedRound"
SWEP.HolsterSlot = 6
SWEP.ViewModel="models/defcon/taser/c_taser.mdl"
SWEP.WorldModel="models/defcon/taser/w_taser.mdl"
SWEP.ENT="ent_jack_hmcd_taser"
SWEP.UseHands=true
--CustomColor=Color(50,50,50,255)
SWEP.ShellType			= ""
SWEP.Traumatic=true
SWEP.Damage=0.1
SWEP.DeathDroppable=false
SWEP.FuckedWorldModel=true
SWEP.CommandDroppable=true
SWEP.ViewModelFlip=false
SWEP.CloseFireSound="realtasesound.wav"
SWEP.SprintPos=Vector(-4,0,5)
SWEP.SprintAng=Angle(-30,0,0)
SWEP.AimPos=Vector(-7.3,0,2.22)
SWEP.AttBone="bone_taser_body"
SWEP.LaserAngle=Angle(90,90,180)
SWEP.AltAimPos=Vector(1.95,-3,.5)
SWEP.FarFireSound=""
SWEP.MuzzleEffect=""
SWEP.HipFireInaccuracy=.04
SWEP.CarryWeight=400
SWEP.BarrelLength=3
SWEP.FuckedWorldModel=true
SWEP.FireAnim="fire"
SWEP.ReloadSound=""
SWEP.ShellEffect=""
SWEP.ReloadTime=4
SWEP.DrawRate=1.5
SWEP.NoBulletInChamber=true
SWEP.ReloadAdd=0
SWEP.BulletDir={0,0,0}
SWEP.LaserOffset=Angle(-0.5,0.1,0)
SWEP.DeployVolume=60
SWEP.Attachments={
	["Owner"]={
		["Laser"]={
			bone="bone_taser_body",
			pos={
				right=1,
				forward=0,
				up=0
			},
			ang={
				up=-90
			},
			scale=.1,
			model="models/weapons/tfa_ins2/upgrades/laser_pistol.mdl",
		}
	},
	["Viewer"]={
		["Weapon"]={
			pos={
				right=1,
				up=-2,
				forward=6
			},
			ang={
				forward=90,
				right=180,
				up=90
			}
		},
		["Laser"]={
			pos={
				forward=8,
				up=-2,
				right=1.3
			},
			ang={
				right=170,
				up=180
			},
			scale=.5,
			model="models/weapons/tfa_ins2/upgrades/laser_pistol.mdl"
		}
	}
}

function SWEP:AltPrimaryFire()
	if(CLIENT)then return end
	self.Owner:SetLagCompensated(true)
	local Dart=ents.Create("ent_jack_hmcd_arrow")
	Dart.HmcdSpawned=self.HmcdSpawned
	Dart:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*25+self.Owner:GetRight()*0.5)
	Dart.Owner=self.Owner
	local Ang=self.Owner:GetAimVector():Angle()
	Ang:RotateAroundAxis(Ang:Right(),-270)
	Dart:SetAngles(Ang)
	Dart.DropSpeed=.01
	Dart.Speed=10
	Dart.Fired=true
	Dart.InitialDir=self.Owner:GetAimVector()
	Dart.InitialVel=self.Owner:GetVelocity()
	Dart.Poisoned=self.Owner.HMCD_AmmoPoisoned
	self.Owner.HMCD_AmmoPoisoned=false
	Dart.CallbackFunc=function(dart,hitEnt)
		local owner=hitEnt
		if IsValid(owner:GetRagdollOwner()) and owner:GetRagdollOwner():Alive() then owner=owner:GetRagdollOwner() end
		dart:EmitSound("tazer.wav",60,100)
		if owner:IsPlayer() then
			local lifeID=owner.LifeID
			timer.Simple(.1,function()
				if IsValid(owner) and owner.LifeID==lifeID and not(owner.Stunned) then
					owner.Stunned=true
					owner:CreateFake()
				end
			end)
		end
		timer.Simple(8,function()
			if IsValid(hitEnt) then
				if IsValid(owner) and owner:IsPlayer() then owner.Stunned=false end
			end
			if IsValid(dart) then dart:StopSound("tazer.wav") end
		end)
	end
	Dart.Damage=1
	Dart.PenetrationPower=1
	Dart.Model="models/taser_grapl/taser_grapl.mdl"
	Dart:Spawn()
	Dart:Activate()
	local Dart2=ents.Create("ent_jack_hmcd_arrow")
	Dart2.HmcdSpawned=self.HmcdSpawned
	Dart2:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*25+self.Owner:GetRight()*-0.5)
	Dart2.Owner=self.Owner
	local Ang=self.Owner:GetAimVector():Angle()
	Ang:RotateAroundAxis(Ang:Right(),-270)
	Dart2:SetAngles(Ang)
	Dart2.Fired=true
	Dart2.InitialDir=self.Owner:GetAimVector()
	Dart2.InitialVel=self.Owner:GetVelocity()
	Dart2.Poisoned=self.Owner.HMCD_AmmoPoisoned
	self.Owner.HMCD_AmmoPoisoned=false
	Dart2.Damage=1
	Dart2.PenetrationPower=1
	Dart2.Model="models/taser_grapl/taser_grapl.mdl"
	Dart2.DropSpeed=Dart.DropSpeed
	Dart2.Speed=Dart.Speed
	Dart2:Spawn()
	Dart2:Activate()
	Dart2.CallbackFunc=Dart.CallbackFunc
	self.Owner:SetLagCompensated(false)
end