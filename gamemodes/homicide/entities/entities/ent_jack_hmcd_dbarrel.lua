AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_wep_base"
ENT.SWEP="wep_jack_hmcd_dbarrel"
ENT.ImpactSound="physics/metal/weapon_impact_soft3.wav"
ENT.Model="models/weapons/ethereal/w_sawnoff_db.mdl"
ENT.DefaultAmmoAmt=2
ENT.AmmoType="Buckshot"
ENT.MuzzlePos=Vector(19.2,-.4,1.6)
ENT.BulletDir=Vector(1,0,0)
ENT.Damage=15
ENT.NumProjectiles=8
ENT.TriggerDelay=.1
ENT.PhysicsBox={Vector(-6,-1,-5),Vector(18,1,5)}
ENT.CollisionBounds={Vector(-6,-1,-5),Vector(18,1,5)}
--[[ENT.BulletEjectPos=Vector(4.5,-.4,1.6)
ENT.BulletEjectDir=Vector(0,0,0)]]
ENT.ShellInfo={randomizePos=3,velMul=0.01,noSmoke=true}