AddCSLuaFile()
ENT.Base="ent_jack_hmcd_grenade_base"
ENT.SWEP="wep_jack_hmcd_m18"
ENT.Model="models/weapons/w_m18.mdl"
ENT.SpoonModel="models/weapons/arc9/darsu_eft/skobas/m18_skoba.mdl"
ENT.MinExplodeTime=2
ENT.MaxExplodeTime=2

if(SERVER)then

	function ENT:DetonateThink()
		if self.StopSmokeTime<=CurTime() or self:WaterLevel()==3 then
			self:StopSound("weapons/m18/m18_burn_loop.wav")
			self:EmitSound("weapons/m18/m18_burn_loop_end.wav")
			self.Think=nil
		end
		if self.NextSmoke<=CurTime() then
			self.NextSmoke=CurTime()+0.5
			ParticleEffect("pcf_jack_smokebomb3",self:GetPos(),angle_zero,self)
			
			local pos=self:GetPos()
			for i,ply in pairs(player.GetAll()) do
				if not(ply:Alive()) or ply:GetNWString("Mask")=="Gas Mask" or ply.Role=="combine" then return end
				local watcher=ply
				if IsValid(ply.fakeragdoll) then watcher=ply.fakeragdoll end
				if watcher:Visible(self) and watcher:EyePos():DistToSqr(pos)<40000 then
					if not(ply.NextCough) then ply.NextCough=CurTime()+math.random(4,5) end
					if ply.NextCough<CurTime() then
						ply:Cough()
						ply.NextCough=CurTime()+math.random(4,5)
					end
				end
			end
		end
		self:NextThink(CurTime())
		return true
	end
	
	function ENT:OnRemove()
		if self.StopSmokeTime and self.StopSmokeTime>CurTime() then
			self:StopSound("weapons/m18/m18_burn_loop.wav")
			self:EmitSound("weapons/m18/m18_burn_loop_end.wav")
		end
	end
	
	function ENT:Detonate()
		if self.Detonated then return end
		self.Detonated=true
		self:EmitSound("weapons/m18/m18_detonate.wav")
		if self:WaterLevel()==3 then
			self:EmitSound("weapons/m18/m18_burn_loop_end.wav")
			return
		end
		self.NextSmoke=0
		self.Think=self.DetonateThink
		local startLoopTime=SoundDuration("weapons/m18/m18_detonate.wav")*0.5
		self.StopSmokeTime=CurTime()+startLoopTime+SoundDuration("weapons/m18/m18_burn_loop.wav")*math.random(13,22)
		timer.Simple(startLoopTime,function()
			if IsValid(self) then
				self:EmitSound("weapons/m18/m18_burn_loop.wav")
			end
		end)
		self:NextThink(CurTime())
		self:SetSaveValue("nextthink",0)
		for i,ply in pairs(player.GetAll()) do
			if ply.NextCough and CurTime()-ply.NextCough>5 then ply.NextCough=nil end
		end
	end
	
end