--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:LFSCalcViewFirstPerson( view, ply )
	return view
end

function ENT:LFSCalcViewThirdPerson( view, ply )
	return view
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	local THR = RPM / self:GetLimitRPM()
	
	if self.ENG then
		self.ENG:ChangePitch( math.Clamp( math.min(RPM / self:GetIdleRPM(),1) * 100+ Doppler + THR * 20,0,255) )
		self.ENG:ChangeVolume( math.Clamp(THR,0.8,1) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "lfs_custom/ah6/rotor_loop.wav" )
		self.ENG:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:SoundStop()
	if self.ENG then
		self.ENG:Stop()
	end
end

function ENT:AnimFins()
end

function ENT:AnimRotor()
	local RotorBlown = self:GetRotorDestroyed()
	

	if not RotorBlown then
		local RPM = self:GetRPM()
		local PhysRot = RPM < 700
		self.RPM = self.RPM and (self.RPM + RPM * FrameTime() * (PhysRot and 3 or 0.5)) or 0
		
		
		self:SetBodygroup( 5, PhysRot and 0 or 1 ) 
		
	end
	
	local Rot1 = Angle(self.RPM,0,0)
	Rot1:Normalize() 
	
	local Rot2 = Angle(self.RPM,0,0)
	Rot2:Normalize() 
	
	self:ManipulateBoneAngles( 4, Rot2 )
	
	self:ManipulateBoneAngles( 5, Rot1 )
	
end

function ENT:AnimCabin()
end

function ENT:AnimLandingGear()
end

function ENT:ExhaustFX()
end
