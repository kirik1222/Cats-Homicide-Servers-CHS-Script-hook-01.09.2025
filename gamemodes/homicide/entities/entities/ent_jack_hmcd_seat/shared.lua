ENT.Type="anim"
ENT.Base="base_anim"

local vehicleHoldTypes_exceptions={
	["normal"]="rollercoaster",
	["smg"]="smg1"
}

function ENT:SharedSetDriver(oldDriver,driver)
	local str=self:EntIndex().."_SeatHook"
	if IsValid(driver) then
		driver.HMCDVehicle=self
		driver:SetCustomCollisionCheck(true)
		-- local steer=0
		hook.Add("CalcMainActivity",str,function(ply,velocity)
			if ply==driver then
				driver.HMCDVehicle=self
				ply:SetGroundEntity(self)
				local wep=ply:GetActiveWeapon()
				local seq
				if wep.GetHoldType then
					local holdType=wep:GetHoldType()
					seq="sit_"..(vehicleHoldTypes_exceptions[holdType] or holdType)
				else
					seq=""
				end
				self:ManipulateDriverBone()
				--[[local goal=0
				if ply:KeyDown(IN_MOVERIGHT) then goal=1 elseif ply:KeyDown(IN_MOVELEFT) then goal=-1 else goal=0 end
				steer=steer+math.Clamp(goal-steer,-FrameTime()*3,FrameTime()*3)
				ply:SetPoseParameter( "vehicle_steer", steer )
				return ACT_DRIVE_JEEP,-1]]
				return ACT_MP_STAND_IDLE,ply:LookupSequence(seq)
			end
		end)
		hook.Add("SetupMove",str,function(ply,mvd,cmd)
			if ply==driver then
				mvd:SetOrigin(self:GetPos()+self:GetUp()*5)
				mvd:SetVelocity(self:GetAbsVelocity())
				mvd:SetMoveAngles(mvd:GetAngles())
			end
		end)
		hook.Add("FinishMove",str,function(ply)
			if ply==driver then
				ply:AddFlags(3)
			end
		end)
		hook.Add("StartCommand",str,function(ply,cmd)
			if ply==driver then
				cmd:RemoveKey(IN_JUMP)
				cmd:RemoveKey(IN_DUCK)
			end
		end)
		hook.Add("ShouldCollide",str,function(ent1,ent2)
			if not(ent1==driver or ent2==driver) then return end
			return false
		end)
	elseif oldDriver!=NULL then
		oldDriver.HMCDVehicle=nil
		oldDriver:SetCustomCollisionCheck(false)
		oldDriver:ManipulateBoneAngles(0,angle_zero,false)
		oldDriver:RemoveFlags(FL_DUCKING)
		hook.Remove("SetupMove",str)
		hook.Remove("StartCommand",str)
		hook.Remove("FinishMove",str)
		hook.Remove("CalcMainActivity",str)
		hook.Remove("ShouldCollide",str)
	end
end

local manipulateAng=Angle(0,0,0)

function ENT:ManipulateDriverBone()
	local seatAng=self:GetAngles()
	local driver=self:GetDriver()
	local yaw=math.NormalizeAngle(driver:EyeAngles().y-seatAng.y)
	local dir=1
	local roll=yaw
	local pitch=seatAng.p
	local pitchShift_yaw=pitch*yaw/90
	local pitchShift_roll=pitch*(90-yaw)/90
	if yaw>90 then
		dir=-1
		pitchShift_yaw=pitch*(180-yaw)/90
	elseif yaw<0 then
		pitchShift_roll=pitch*(90+yaw)/90
		if yaw<-90 then
			roll=-180-yaw
			pitchShift_yaw=pitch*(-180-yaw)/90
		end
	end
	local seatRoll=seatAng.r
	manipulateAng.yaw=-seatRoll*(math.abs(yaw)-90)/90+pitchShift_yaw
	manipulateAng.roll=-seatRoll+seatRoll*(90-roll)/90*dir+pitchShift_roll
	driver:ManipulateBoneAngles(0,manipulateAng,false)
end