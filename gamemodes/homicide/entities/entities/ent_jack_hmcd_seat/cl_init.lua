
include("shared.lua")

local seat=Entity(123)

local function adjustVehicleAng(seat,curAng)
	local seatAng=seat:GetAngles()
	local yawDiff=math.NormalizeAngle(seatAng.y-curAng.y)
	local seatRoll=seatAng.r
	curAng.r=curAng.r-(math.abs(yawDiff)-90)*seatRoll/90
	curAng.p=curAng.p-seatRoll
	
	
	--[[curAng.r=curAng.r+180
	curAng.y=-curAng.y
	curAng.p=-curAng.p]] -- КОГДА ПЕРЕВЕРНУТ В ТАЧКЕ
end

hook.Remove("CalcView","123_SeatHook",function(ply,origin,angles,fov,znear,zfar)
	local driver=seat:GetDriver()
	if ply==driver then
		local driverOrigin=seat:GetPos()+seat:GetUp()*40
		adjustVehicleAng(seat,angles)
		return {
			origin=driverOrigin,
			angles=angles,
			fov=fov
		}
	end
end)

hook.Remove("CalcViewModelView","123_SeatHook",function(wep,vm,oldPos,oldAng,newPos,newAng)
	local owner=wep.Owner

		
		local driverOrigin=seat:GetPos()+seat:GetUp()*40
		newPos:Set(driverOrigin)
		adjustVehicleAng(seat,newAng)
end)

local function driverCallback(seat,name,oldDriver,driver)
	local str=seat:EntIndex().."_SeatHook"
	seat:SharedSetDriver(oldDriver,driver)
	if IsValid(driver) then
		local startOrigin=driver:EyePos()
		local start=CurTime()
		hook.Add("CalcView",str,function(ply,origin,angles,fov,znear,zfar)
			if ply==driver and not(driver:ShouldDrawLocalPlayer()) then
				local timeMul=math.min((CurTime()-start)^1.5*2,1)
				local driverOrigin=seat:GetPos()+seat:GetUp()*40
				adjustVehicleAng(seat,angles)
				return {
					origin=startOrigin+(driverOrigin-startOrigin)*timeMul,
					angles=angles,
					fov=fov
				}
			end
		end)
		hook.Add("CalcViewModelView",str,function(wep,vm,oldPos,oldAng,newPos,newAng)
			local owner=wep.Owner
			if owner==driver then
				local timeMul=math.min((CurTime()-start)^1.5*2,1)
				local driverOrigin=seat:GetPos()+seat:GetUp()*40
				driverOrigin:Sub((driverOrigin-startOrigin)*(1-timeMul))
				newPos:Set(driverOrigin)
				adjustVehicleAng(seat,newAng)
			end
		end)
	elseif oldDriver!=NULL then
		--[[local startOrigin=oldDriver:EyePos()
		local start=CurTime()
		hook.Add("CalcView",str,function(ply,origin,angles,fov,znear,zfar)
			if ply==oldDriver then
				local timeMul=math.min((CurTime()-start)^1.5*2,1)
				if timeMul==1 then hook.Remove("CalcView",str) end
				return {
					origin=startOrigin+(origin-startOrigin)*timeMul,
					angles=angles,
					fov=fov				
				}
			end
		end)]]
		hook.Remove("CalcView",str)
		hook.Remove("CalcViewModelView",str)
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Entity",0,"Driver")
	self:NetworkVarNotify("Driver",driverCallback)
end

function ENT:OnRemove(fullupdate)
	if not(fullupdate) or self:IsDormant() then self:SetDriver(NULL) end
end