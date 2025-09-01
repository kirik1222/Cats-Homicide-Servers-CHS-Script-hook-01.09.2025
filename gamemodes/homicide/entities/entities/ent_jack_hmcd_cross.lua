AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName		= "Cross"
ENT.ImpactSound="Wood.ImpactHard"
ENT.Progress=0
ENT.IsLoot=true
if(SERVER)then
	util.AddNetworkString("hmcd_crossinteraction_start")
	util.AddNetworkString("hmcd_crossinteraction_stop")
	function ENT:Initialize()
		--self.Entity:SetModel("models/crucifix/cross.mdl")
		self.Entity:SetModel("models/props/cross/cross.mdl")
		self.Entity:SetModelScale(2,0)
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(100)
			phys:Wake()
			phys:EnableMotion(false)
		end
	end
	function ENT:StopUsing()
		hook.Remove("Think",self:EntIndex().."_BeingUsed")
		self.StopUsingTime=CurTime()
		self.LastProgress=self.Progress
		if IsValid(self.CurUser) then
			net.Start("hmcd_crossinteraction_stop")
			net.Send(self.CurUser)
			self.CurUser=nil
		end
	end
	function ENT:Use(ply)
		if self:GetPhysicsObject():IsMotionEnabled() then return end
		if ply.Role!="follower" then return end
		if IsValid(self.CurUser) then return end
		self.CurUser=ply
		self.StopUsingTime=nil
		self.LastProgress=self.Progress
		local str=self:EntIndex().."_BeingUsed"
		local start=CurTime()
		net.Start("hmcd_crossinteraction_start")
		net.WriteFloat(self.Progress)
		net.Send(self.CurUser)
		hook.Add("Think",str,function()
			local shouldStop=false
			if not(IsValid(self) and IsValid(self.CurUser)) then self:StopUsing() return end
			if self:GetPhysicsObject():IsMotionEnabled() then self:StopUsing() return end
			if self.CurUser:GetUseEntity()!=self then self:StopUsing() return end
			self.Progress=math.min(self.LastProgress+(CurTime()-start)/10,1)
			if self.Progress==1 then
				self:StopUsing()
				self:GetPhysicsObject():EnableMotion(true)
				self.Progress=nil
			end
		end)
	end
	function ENT:Think()
		if self.Progress and self.Progress>0 and self.StopUsingTime then
			self.Progress=math.max(self.LastProgress-(CurTime()-self.StopUsingTime)/15,0)
		end
	end
else
	net.Receive("hmcd_crossinteraction_stop",function()
		hook.Remove("HUDPaint","TakingCrossDown")
	end)
	net.Receive("hmcd_crossinteraction_start",function()
		local progress=net.ReadFloat()
		local w,h=ScrW(),ScrH()
		local boxWidth,boxHeight=w/2,h/20
		local text=Translate("taking_cross_down")
		local start=CurTime()
		hook.Add("HUDPaint","TakingCrossDown",function()
			draw.SimpleText( text, "DermaLarge", w/2, (h-w/200-boxHeight)/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			surface.SetDrawColor(color_white)
			surface.DrawOutlinedRect( (w-boxWidth)/2, (h-boxHeight)/2, boxWidth, boxHeight, w/200 )
			surface.DrawRect((w-boxWidth)/2, (h-boxHeight)/2, boxWidth*math.min((10*progress+CurTime()-start)/10,1),boxHeight)
		end)
	end)
end