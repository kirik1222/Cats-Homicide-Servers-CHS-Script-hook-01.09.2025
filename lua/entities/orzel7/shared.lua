-- DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Orzel-7"
ENT.Author = "ProtOS"
ENT.Information = ""
ENT.Category = "[LFS] ProtOS"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.MDL = "models/protos/bomba/orzel_7_penis.mdl"

ENT.AITEAM = 1

ENT.Mass = 10000
ENT.Inertia = Vector(800000,800000,800000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(0,0,0)
ENT.SeatAng = Angle(0,0,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2600
ENT.LimitRPM = 3200

ENT.RotorPos = Vector(180,0,50)
ENT.WingPos = Vector(70,0,50)
ENT.ElevatorPos = Vector(-280,0,50)
ENT.RudderPos = Vector(-330,0,50)

ENT.MaxVelocity = 2000

ENT.MaxThrust = 20000

ENT.MaxTurnPitch = 500
ENT.MaxTurnYaw = 600
ENT.MaxTurnRoll = 400

ENT.MaxPerfVelocity = 1400

ENT.MaxHealth = 30000
ENT.MaxShield = 400

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 2000

ENT.MaxPrimaryAmmo = 2000

--ENT.MaxShield = 200
function ENT:AddDataTables()
	self:NetworkVar( "Bool",21, "RearHatch" )
end
sound.Add( {
	name = "ORZEL_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "orzel/xwing_shoot.wav"
} )

sound.Add( {
	name = "ORZEL_ENGINE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 115,
	sound = "orzel/loop.wav"
} )

sound.Add( {
	name = "ORZEL_TAKEOFF",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = {"orzel/takeoff_1.wav","orzel/takeoff_2.wav"}
} )

sound.Add( {
	name = "ORZEL_BOOST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = {"orzel/boost_1.wav","orzel/boost_2.wav"}
} )

sound.Add( {
	name = "ORZEL_LANDING",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "orzel/landing.wav"
} )

sound.Add( {
	name = "ORZEL_DIST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "orzel/dist.wav"
} )