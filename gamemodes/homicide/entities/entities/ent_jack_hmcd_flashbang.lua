AddCSLuaFile()
ENT.Base="ent_jack_hmcd_grenade_base"
ENT.SWEP="wep_jack_hmcd_flashbang"
ENT.Model="models/weapons/w_m84.mdl"
ENT.MinExplodeTime=2
ENT.MaxExplodeTime=2
ENT.SpoonModel="models/weapons/arc9/darsu_eft/skobas/m18_skoba.mdl"

if(SERVER)then

	ENT.CloseExplodeSound="weapons/m84/m84_detonate.wav"
	ENT.FarExplodeSound="weapons/m84/m84_detonate_dist.wav"

	local hearingProtectionMuls={
		[MAT_CONCRETE]=15,
		[MAT_METAL]=15,
		[MAT_SAND]=5,
		[MAT_DIRT]=5,
		[MAT_GRASS]=3,
		[MAT_WOOD]=5,
		[MAT_FOLIAGE]=0.2
	}

	util.AddNetworkString("hmcd_flashbang_explode")
	
	local function getAngBetweenVectors(vec1,vec2,spos)
		local vec3=vec1*vec2
		local ab=vec1[1]*vec2[1]+vec1[2]*vec2[2]+vec1[3]*vec2[3]
		return math.deg(math.acos(ab/(vec1:Length()*vec2:Length())))
	end
	
	local soundTr={
		mask=MASK_NPCWORLDSTATIC
	}
	
	local function checkIfOutside(startpos)
		local maxTries=10
		local outsideCount=0
		for i=1,10 do
			local dir=VectorRand()
			local pos=startpos
			for i=1,maxTries do
				dir:Mul(1000)
				soundTr.start=pos
				soundTr.endpos=pos+dir
				local tr=util.TraceLine(soundTr)
				if not(tr.Hit) or tr.HitSky then outsideCount=outsideCount+1 break end
				pos=tr.HitPos
				
				local hitAng=getAngBetweenVectors(-dir,tr.HitNormal)
				local ang=dir:Angle()
				ang:RotateAroundAxis(ang:Right(),(90-hitAng)*2*math.Rand(1,1.2))
				ang:RotateAroundAxis(ang:Up(),math.Rand(-5,5))
				dir=ang:Forward()
			end
		end
		return outsideCount>=5
	end
	
	function ENT:Detonate()
		if self.Detonated then return end
		local Pos,Ground,Attacker=self:LocalToWorld(self:OBBCenter())+Vector(0,0,5),self:NearGround(),self.Owner
		ParticleEffect("ins_flashbang_explosion",Pos,vector_up:Angle())
		
		local farSnd,closeSnd
		local isOutside
		if self.CloseOutsideExplodeSound then
			isOutside=checkIfOutside(self:GetPos())
		end
		if isOutside then
			closeSnd=self.CloseOutsideExplodeSound
			farSnd=self.FarOutsideExplodeSound
		else
			closeSnd=self.CloseExplodeSound
			farSnd=self.FarExplodeSound
		end
		timer.Simple(.01,function()
			if IsValid(self) then
				self:EmitSound(farSnd,140,100)
			end
		end)
		timer.Simple(.02,function()
			if IsValid(self) then
				self:EmitSound(closeSnd,80,100)
				self:Remove()
			end
		end)
		for i,ply in ipairs(player.GetAll()) do
			if not(ply:Alive()) then continue end
			local watchEnt=ply
			local spos,avec
			if IsValid(ply.fakeragdoll) then
				watchEnt=ply.fakeragdoll
				spos=watchEnt:EyePos()
				avec=watchEnt:EyeAngles():Forward()
			else
				spos=watchEnt:GetShootPos()
				avec=watchEnt:GetAimVector()
			end
			local pos=self:GetPos()
			local dist=spos:Distance(pos)
			local blindMul
			local ringMul=math.min(1000/dist,40)
			if watchEnt:Visible(self) then
				blindMul=1
				local TrueVec=(pos-spos):GetNormalized()
				local DotProduct=avec:DotProduct(TrueVec)
				local ApproachAngle=(-math.deg(math.asin(DotProduct))+90)
				blindMul=blindMul*180/ApproachAngle
				blindMul=math.Round(math.Clamp(blindMul*math.Clamp(200/dist,0,5),0,15))
			else
				blindMul=0
				local dir=(pos-spos):GetNormalized()
				local curpos=spos
				while true do
					local tr=util.QuickTrace(curpos,pos-curpos,watchEnt)
					if not(tr.Hit) or tr.Entity==self then break end
					local wallThickness=5
					local SearchPos=tr.HitPos
					while true do
						SearchPos=SearchPos+dir*5
						local PeneTrace=util.QuickTrace(SearchPos,-dir*5)
						if PeneTrace.StartSolid then
							wallThickness=wallThickness+5*(hearingProtectionMuls[PeneTrace.MatType] or 1)
						else
							curpos=PeneTrace.HitPos
							break
						end
					end
					ringMul=ringMul-wallThickness/100
					if ringMul<=0 then break end
				end
			end
			ringMul=math.max(ringMul,0)
			if ringMul>0 or blindMul>0 then
				net.Start("hmcd_blind")
				net.WriteEntity(ply)
				net.WriteInt(blindMul,5)	
				net.WriteInt(ringMul,7)
				net.Send(player.GetAll())
			end
		end
		local pos=self:GetPos()
		for i=1,3 do
			pos[i]=math.Round(pos[i])
		end
		net.Start("hmcd_flashbang_explode")
		net.WriteUInt(self:EntIndex(),13)
		net.WriteVector(pos)
		net.Broadcast()
	end
	
elseif(CLIENT)then
	
	net.Receive("hmcd_flashbang_explode",function()
		local dlight=DynamicLight(net.ReadUInt(13))
		if dlight then
			dlight.pos=net.ReadVector()
			dlight.r=255
			dlight.g=255
			dlight.b=255
			dlight.brightness=10
			dlight.Decay=1000
			dlight.Size=384
			dlight.DieTime=CurTime()+5
		end
	end)
	
end