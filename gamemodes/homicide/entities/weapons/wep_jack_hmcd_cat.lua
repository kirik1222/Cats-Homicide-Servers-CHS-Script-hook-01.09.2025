if SERVER then
	AddCSLuaFile()
else
	SWEP.PrintName			= "Cat"	
	SWEP.Slot			= 2
	SWEP.SlotPos			= 7
    SWEP.DrawCrosshair        = false
    SWEP.BounceWeaponIcon   = false
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_cat")
end

SWEP.Instructions        = "This is a furry animal with a long tail and sharp claws. Use it to treat your physical and mental condition."

SWEP.Base = "weapon_base"

SWEP.IconTexture="vgui/wep_jack_hmcd_cat"
SWEP.Spawnable	= true
SWEP.AdminOnly	= false
SWEP.HoldType = "duel"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-3.385, -1.29, 0.507), angle = Angle(0, 0, 0) },
	["v_weapon.elite_right"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-1.254, -0.774, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -80.047) },
	["v_weapon.elite_left"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, -30), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 71.204) }
}
SWEP.Primary.ClipSize        = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic        = true
SWEP.Primary.Ammo            = "None" 

SWEP.Secondary.ClipSize        = -1 
SWEP.Secondary.DefaultClip    = -1 
SWEP.Secondary.Automatic    = true 
SWEP.Secondary.Ammo            = "none"
SWEP.CommandDroppable = true
SWEP.ENT="ent_jack_hmcd_cat"
SWEP.NextThinkTime=0

if SERVER then
	function SWEP:Think()
		if self.NextThinkTime<CurTime() then
			local maxHP=self.Owner:GetMaxHealth()
			if not(self.Healing) then
				if self.Owner:Health()<maxHP or self.Owner.Bleedout>0 then
					self.Healing=true
					self.Owner:EmitSound("cat/catsamloop.wav")
				end
			else
				local hp=math.min(self.Owner:Health()+1,maxHP)
				self.Owner:SetHealth(hp)
				self.Owner.Bleedout=math.max(self.Owner.Bleedout-1,0)
				if self.Owner.Bleedout==0 and hp==maxHP then self.Healing=false self.Owner:StopSound("cat/catsamloop.wav") end
			end
			self.NextThinkTime=CurTime()+1
		end
	end
end

function SWEP:HMCDOnDrop()
	if self.CommandDroppable then
		local Ent=ents.Create(self.ENT)
		Ent.HmcdSpawned=self.HmcdSpawned
		Ent:SetPos(self:GetPos())
		Ent:SetAngles(self:GetAngles())
		Ent.Poisoned=self.Poisoned
		Ent.Infected=self.Infected
		Ent.Owner=self.Owner
		Ent.Attackers=self.Attackers
		Ent:Spawn()
		Ent:Activate()
		Ent:GetPhysicsObject():SetVelocity(self:GetVelocity()/2)
		self:Remove()
	end
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Initialize()

	self:SetHoldType ( "duel" )

end

function SWEP:Holster()
	
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	if IsValid(self.Owner) then self.Owner:StopSound("cat/catsamloop.wav") end
	if SERVER then self.Healing=false end
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

if CLIENT then

	local DownAmt=0
	function SWEP:GetViewModelPosition(pos,ang)
		if(self.Owner:KeyDown(IN_SPEED))then
			DownAmt=math.Clamp(DownAmt+.1,0,50)
		else
			DownAmt=math.Clamp(DownAmt-.1,0,15)
		end
		return pos-ang:Up()*DownAmt+ang:Forward()*-3,ang
	end

	function SWEP:ViewModelDrawn(vm)
		self:UpdateBonePositions(vm)
		if not(self.Cat) then
			self.Cat=ClientsideModel("models/dingus/dingus.mdl")
			self.Cat:SetPos(self:GetPos())
			self.Cat:SetAngles(self:GetAngles())
			self.Cat:SetParent(self)
			self.Cat:SetModelScale(.5,0)
			self.Cat:SetNoDraw(true)
		end
		local matr=vm:GetBoneMatrix(vm:LookupBone("ValveBiped.Bip01_R_Hand"))
		if matr then
			local pos,ang=matr:GetTranslation(),matr:GetAngles()
			self.Cat:SetPos(pos + ang:Forward() * 2.5 + ang:Right() * 2.5 + ang:Up() * 3.5 )
			ang:RotateAroundAxis(ang:Up(), -10)
			ang:RotateAroundAxis(ang:Right(), -200)
			ang:RotateAroundAxis(ang:Forward(), 80)
			self.Cat:SetAngles(ang)
			self.Cat:DrawModel()
		end
	end

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			local loopthrough = self.ViewModelBoneMods
			allbones = {}
			for i=0, vm:GetBoneCount() do
				local bonename = vm:GetBoneName(i)
				if (self.ViewModelBoneMods[bonename]) then 
					allbones[bonename] = self.ViewModelBoneMods[bonename]
				else
					allbones[bonename] = { 
						scale = Vector(1,1,1),
						pos = Vector(0,0,0),
						angle = Angle(0,0,0)
					}
				end
			end
			
			loopthrough = allbones
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end
	
	function SWEP:DrawWorldModel()
		if not(self.WCat) then
			self.WCat=ClientsideModel("models/dingus/dingus.mdl")
			self.WCat:SetPos(self:GetPos())
			self.WCat:SetAngles(self:GetAngles())
			self.WCat:SetParent(self)
			self.WCat:SetModelScale(.824,0)
			self.WCat:SetNoDraw(true)
		end
		local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		self.WCat:SetPos(pos + ang:Forward() * -1.5 + ang:Right() * 8.5 + ang:Up() * 3.5 )
		ang:RotateAroundAxis(ang:Up(), -20)
		ang:RotateAroundAxis(ang:Right(), 180)
		ang:RotateAroundAxis(ang:Forward(), 0)
		self.WCat:SetAngles(ang)
		self.WCat:DrawModel()
	end
	
end

