/*---------------------------------------------------------
	EFFECT:Init(data)
---------------------------------------------------------*/

local decalByMat={
	[MAT_ANTLION]="Impact.Antlion",
	[MAT_BLOODYFLESH]="Impact.BloodyFlesh",
	[MAT_FLESH]="Impact.Flesh",
	[MAT_CONCRETE]="Impact.Concrete",
	[MAT_GLASS]="Impact.Glass",
	[MAT_METAL]="Impact.Metal",
	[MAT_SAND]="Impact.Sand",
	[MAT_WOOD]="Impact.Wood"
}

function EFFECT:Init(data)
	local vOffset = data:GetOrigin()
	
	local Scayul=data:GetScale()
	self.Scale=Scayul
	self.Position=vOffset
	
	self.Pos=vOffset
	self.Scayul=Scayul
	local Normal=data:GetNormal()
	if Normal==Vector(0,0,1) then Normal=Vector() end
	self.Siyuz=1
	self.DieTime=CurTime()+.1
	self.Opacity=1
	self.TimeToDie=CurTime()+0.015*self.Scale
	
	if(self:WaterLevel()==3)then return end
	
	local Emitter=ParticleEmitter(vOffset)
	for i=0,1000*Scayul do
		local sprite="sprites/mat_jack_nsmokethick"
		local particle = Emitter:Add(sprite,vOffset)
		if(particle)then
			particle:SetVelocity(20000*(Normal+VectorRand())*Scayul)
			particle:SetAirResistance(0)
			particle:SetGravity(VectorRand())
			particle:SetDieTime(.04*Scayul)
			particle:SetStartAlpha(1)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(1, 20)*Scayul)
			particle:SetEndSize(math.Rand(20, 50)*Scayul)
			particle:SetRoll(math.Rand(-3,3))
			particle:SetRollDelta(math.Rand(-2,2))
			particle:SetLighting(true)
			local darg=math.Rand(150,255)
			particle:SetColor(darg,darg,darg)
			particle:SetCollide(true)
			particle:SetBounce(0)
			particle:SetCollideCallback(function(part,hitpos,hitnormal)
				hitnormal:Mul(10)
				part:SetStartAlpha(math.Rand(50,255))
				part:SetLifeTime(0)
				part:SetDieTime(math.Rand(.01,1.5))
				part:SetVelocity(hitnormal)
				hitnormal:Div(10)
				local trStart=hitpos+hitnormal
				local trDir=-hitnormal
				trDir:Mul(2)
				hitpos:Sub(hitnormal)
				util.Decal(decalByMat[util.QuickTrace(trStart,trDir).MatType] or "ExplosiveGunshot",trStart,hitpos)
			end)
		end
	end
	Emitter:Finish()
end
/*---------------------------------------------------------
	EFFECT:Think()
---------------------------------------------------------*/
function EFFECT:Think()
	return false
end
/*---------------------------------------------------------
	EFFECT:Render()
---------------------------------------------------------*/
function EFFECT:Render()
	--wat
end