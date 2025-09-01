AddCSLuaFile()

SWEP.PrintName = "Ballistic Shield"
SWEP.Instructions	= "This is a protection device made out of UHMWPE that is designed to stop or deflect bullets fired at their carrier."

SWEP.Slot = 1
SWEP.SlotPos = 3
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false	

SWEP.Spawnable = false

SWEP.ViewModel = ""
SWEP.WorldModel = "models/bshields/hshield.mdl"
SWEP.ViewModelFOV = 10
SWEP.CommandDroppable=true
SWEP.NoHolster=false
SWEP.HomicideSWEP=true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.ENT="ent_jack_hmcd_shield"
SWEP.DeathDroppable=true
SWEP.HolsterSlot=4
SWEP.HolsterPos=Vector(0,-10,0)
SWEP.HolsterAng=Angle(90,270,180)

function SWEP:Initialize()
	self:SetHoldType("slam")
end

function SWEP:Think()
	return
end

function SWEP:Holster()
	if SERVER then
		if self and self.shield then self.shield:Remove() end
	end
	return true
end
function SWEP:HMCDOnDrop()
	if IsValid(self.shield) then
		self.shield:Remove()
	end
	local Ent=ents.Create(self.ENT)
	Ent.HmcdSpawned=self.HmcdSpawned
	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
	Ent:Spawn()
	Ent:Activate()
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity()/2)
	self:Remove()
end

function SWEP:PrimaryAttack()
	return
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Reload()
	return
end

function SWEP:OnRemove()
	if IsValid(self.shield) then self.shield:Remove() end
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel(false)

		if IsValid(self.shield) then 
			return
		end

		self:SetNoDraw(true)
		local crouchadd=0
		if self.Owner:Crouching() then
			crouchadd=-17
		end
		self.shield = ents.Create("prop_physics")
		self.shield:SetModel(self.WorldModel)
		self.shield:SetPos(self.Owner:GetPos() + Vector(0, 0, 50+crouchadd) + (self.Owner:GetForward() * 12.5))
		self.shield:SetAngles(Angle(0, self.Owner:EyeAngles().y - 1, 0))
		self.shield:SetParent(self.Owner)

		self.shield:Fire("SetParentAttachmentMaintainOffset", "eyes", 0.01)
		self.shield:SetCollisionGroup(COLLISION_GROUP_WORLD)

		self.shield:Spawn()
		self.shield:Activate()
	end

	return true
end

function SWEP:DrawWorldModel()	
	self:DrawModel()
end