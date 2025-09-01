AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName		= "Ammo"
ENT.ImpactSound="physics/metal/weapon_impact_soft1.wav"
ENT.PickupSound="snd_jack_hmcd_ammobox.wav"

if(SERVER)then

	local skins={
		["AlyxGun"]="models/hmcd_ammobox_22",
		["Pistol"]="models/hmcd_ammobox_9",
		["357"]="models/hmcd_ammobox_38",
		["Buckshot"]="models/hmcd_ammobox_12",
		["AR2"]="models/hmcd_ammobox_792",
		["SMG1"]="models/hmcd_ammobox_556",
		["AirboatGun"]="models/hmcd_ammobox_nails",
		["StriderMinigun"]="models/ammo76251/smg",
		["SniperRound"]="models/ammo76239/smg",
		["SniperPenetratedRound"]="models/defcon/taser/taser"
	}

	local numbers={
		["AlyxGun"]=150,
		["12mmRound"]=100,
		["Pistol"]=50,
		["357"]=50,
		["AirboatGun"]=40,
		["Buckshot"]=30,
		["AR2"]=30,
		["SMG1"]=30,
		["XBowBolt"]=20,
		["StriderMinigun"]=30,
		["SniperRound"]=30,
		["HelicopterGun"]=30,
		["Gravity"]=30,
		["Thumper"]=20,
		["9mmRound"]=50,
		["Hornet"]=30,
		["SniperPenetratedRound"]=5,
		["CombineCannon"]=5,
		["RPG_Round"]=1,
		["MP5_Grenade"]=1
	}

	local models={
		["12mmRound"]="models/cat/918box.mdl",
		["StriderMinigun"]="models/items/ammo_76251.mdl",
		["XBowBolt"]="models/items/ammo/ammo_arrow_box.mdl",
		["HelicopterGun"]="models/4630_ammobox.mdl",
		["SniperRound"]="models/items/ammo_76239.mdl",
		["Gravity"]="models/items/combine_rifle_cartridge01.mdl",
		["Thumper"]="models/items/crossbowrounds.mdl",
		["MP5_Grenade"]="models/items/combine_rifle_ammo01.mdl",
		["9mmRound"]="models/ammo/beanbag9_ammo.mdl",
		["Hornet"]="models/ammo/beanbag12_ammo.mdl",
		["SniperPenetratedRound"]="models/ammo/taser_ammo.mdl",
		["CombineCannon"]="models/eu_homicide/145ammobox.mdl",
		["RPG_Round"]="models/weapons/tfa_ins2/w_rpg7_projectile.mdl"
	}

	local pileEntities={
		["XBowBolt"]={"ent_jack_hmcd_arrow",1,vars={ModelScale=2,CollisionSound="snd_jack_hmcd_arrow.wav",CollisionGroup=COLLISION_GROUP_WEAPON}},
		["RPG_Round"]={"ent_jack_hmcd_ammo",5}
	}
	
	local impactSounds={
		["RPG_Round"]="Canister.ImpactHard"
	}
	
	local pickupSounds={
		["RPG_Round"]="Canister.ImpactHard"
	}

	function ENT:Initialize()
		if not(self.Rounds) then self:Fill() end
		if pileEntities[self.AmmoType] and self.Rounds<40 then
			if not(pileEntities[self.AmmoType][1]=="ent_jack_hmcd_ammo" and self.Rounds<=1) then
				self:SpawnAsPile()
				return
			end
		end
		if not(self.AmmoType)then self.AmmoType="Pistol" end
		self.Entity:SetModel(models[self.AmmoType] or "models/props_lab/box01a.mdl")
		if skins[self.AmmoType] then
			self.Entity:SetMaterial(skins[self.AmmoType])
		end
		if impactSounds[self.AmmoType] then
			self.ImpactSound=impactSounds[self.AmmoType]
		end
		if pickupSounds[self.AmmoType] then
			self.PickupSound=pickupSounds[self.AmmoType]
		end
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(self.UseType or SIMPLE_USE)
		self:DrawShadow(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(15)
			phys:Wake()
			phys:EnableMotion(true)
		end
	end
	
	function ENT:SpawnAsPile()
		if not(self.Rounds) then self:Fill() end
		local Entities={}
		local pileEnt=pileEntities[self.AmmoType]
		for i=1,self.Rounds do
			local Ent=ents.Create(pileEnt[1])
			Ent.HmcdSpawned=true
			Ent:SetPos(self:GetPos()+VectorRand()*pileEnt[2])
			Ent:SetAngles(self:GetAngles())
			if pileEnt[1]=="ent_jack_hmcd_ammo" then
				Ent.Rounds=1
				Ent.AmmoType=self.AmmoType
				Ent.UseType=CONTINUOUS_USE
			end
			if pileEnt.vars then
				for var,val in pairs(pileEnt.vars) do
					Ent[var]=val
				end
			end
			Ent:Spawn()
			Ent:Activate()
			Entities[i]=Ent
		end
		for i,ent1 in pairs(Entities) do
			for j,ent2 in pairs(Entities) do
				if ent1!=ent2 then
					local constr=constraint.Weld(ent1,ent2,0,0,5000,true,false)
					if constr then
						constr.PickupAble=true
					end
				end
			end
		end
		self:Remove()
	end
	
	function ENT:PickUp(ply)
		ply:GiveAmmo(self.Rounds,self.AmmoType,true)
		local Pitch=100
		if(self.AmmoType=="AR2")then Pitch=80 elseif(self.AmmoType=="Buckshot")then Pitch=70 end
		self:EmitSound(self.PickupSound,65,Pitch)
		self:Remove()
	end
	
	function ENT:Fill()
		self.Rounds=math.ceil(math.random(1,numbers[self.AmmoType])^math.Rand(0,1)) -- random between 1 and NUM, heavily weighted toward the lower numbers
	end
	
end