AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.SWEP="wep_jack_hmcd_snowball"
ENT.Model="models/zerochain/props_christmas/snowballswep/zck_w_snowballswep.mdl"
ENT.Mass=1
ENT.ImpactSound="player/footsteps/snow6.wav"
if(SERVER)then

	GAMEMODE.Snowmen=GAMEMODE.Snowmen or {}
	
	hook.Add("PostCleanupMap","CleanSnowmen",function()
		table.Empty(GAMEMODE.Snowmen)
	end)
	
	function ENT:PickUp(ply)
		if(self.Armed)then return end
		if((GAMEMODE.ZOMBIE)and(ply.Murderer))then return end
		local SWEP=self.SWEP
		if not(ply:HasWeapon(self.SWEP))then
			self:EmitSound("weapons/snowball/zck_snowball_pickup01.wav")
			ply:Give(self.SWEP)
			ply:GetWeapon(self.SWEP).HmcdSpawned=self.HmcdSpawned
			self:Remove()
			ply:SelectWeapon(SWEP)
		else
			ply:PickupObject(self)
		end
	end
	
	local snowman_parts={
		[1]={
			mdl="models/props/cs_office/snowman_face.mdl",
			lpos=Vector(0,0,25),
			lang=angle_zero
		},
		[2]={
			mdl="models/props/cs_office/snowman_arm.mdl",
			lpos=Vector(-13.35,4.2,15.4),
			lang=Angle(-3.4,157,-2.4)
		},
		[3]={
			mdl="models/props/cs_office/snowman_arm.mdl",
			lpos=Vector(13.8,-3,15),
			lang=Angle(3,-1.44,-0.3)
		}
	}
	
	local function spawnSnowman(tr)
		local pos=tr.HitPos
		local ang=tr.HitNormal:Angle()
		ang:RotateAroundAxis(ang:Right(),-90)
		ang.y=(tr.HitPos-tr.StartPos):Angle().y-90
		local body=ents.Create("prop_physics")
		body:SetPos(pos+vector_up*21.7)
		body:SetAngles(ang)
		body:SetModel("models/props/cs_office/snowman_body.mdl")
		body:Spawn()
		body:GetPhysicsObject():Sleep()
		
		local entities={body}
		
		for i,info in pairs(snowman_parts) do
			local part=ents.Create("prop_physics")
			part:SetPos(body:LocalToWorld(info.lpos))
			part:SetAngles(body:LocalToWorldAngles(info.lang))
			part:SetModel(info.mdl)
			part:Spawn()
			part:GetPhysicsObject():Sleep()
			table.insert(entities,part)
		end
		
		timer.Simple(0,function()
			if body!=NULL then
				for i,part in pairs(entities) do
					if part==NULL then continue end
					if part!=body then
						constraint.Weld(part,body,0,0,8000,true)
					else
						constraint.Weld(part,tr.Entity,0,0,16000)
					end
				end
			end
		end)
		
		local effData=EffectData()
		effData:SetScale(3)
		for i=1,5 do
			effData:SetOrigin(pos+vector_up*(i-1)*10)
			util.Effect("eff_jack_hmcd_poof",effData)
		end
		
		local start=CurTime()
		local str=body:EntIndex().."_Appear"
		local col=Color(255,255,255,0)
		for i,ent in pairs(entities) do
			ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
			ent:SetColor(col)
		end
		hook.Add("Think",str,function()
			col.a=math.min(((CurTime()-start)*10)^4,255)
			for i,ent in pairs(entities) do
				if ent==NULL then continue end
				ent:SetColor(col)
			end
			if col.a==255 then hook.Remove("Think",str) end
		end)
	end
	
	function ENT:PhysicsCollide(data,phys)
		if self.Thrown then
			self.Thrown=false
			self:EmitSound("weapons/snowball/snowball_impact0"..math.random(1,2)..".wav")
			local effData=EffectData()
			effData:SetOrigin(data.HitPos)
			effData:SetScale(1)
			util.Effect("eff_jack_hmcd_poof",effData)
			SafeRemoveEntityDelayed(self, 0.1)
			local snowmen=GAMEMODE.Snowmen
			local foundSnowman
			for pos in pairs(snowmen) do
				if pos:DistToSqr(data.HitPos)<100^2 then
					foundSnowman=pos
					break
				end
			end
			if not(foundSnowman) then foundSnowman=data.HitPos snowmen[foundSnowman]=0 end
			snowmen[foundSnowman]=snowmen[foundSnowman]+1
			if snowmen[foundSnowman]==5 then
				snowmen[foundSnowman]=nil
				local norm=data.OurOldVelocity:GetNormalized()
				spawnSnowman(util.TraceLine({
					start=data.HitPos-norm,
					endpos=data.HitPos+norm,
					filter=self
				}))
			end
		elseif(data.DeltaTime>.1)then
			self:EmitSound(self.ImpactSound,math.Clamp(data.Speed/3,20,65),math.random(100,120))
			self:GetPhysicsObject():SetVelocity(self:GetPhysicsObject():GetVelocity()*.9)
		end
	end
	
	function ENT:Throw()
		self.Armed=true
	end
	
	function ENT:StartTouch(ply)
		--
	end
	
elseif(CLIENT)then
	function ENT:Initialize()
		--
	end
	function ENT:Draw()
		self:DrawModel()
	end
	function ENT:Think()
		--
	end
	function ENT:OnRemove()
		--
	end
end