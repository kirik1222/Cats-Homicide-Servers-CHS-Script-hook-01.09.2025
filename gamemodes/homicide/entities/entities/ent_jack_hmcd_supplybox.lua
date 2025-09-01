AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName		= "Supply Box"
ENT.Model="models/items/item_item_crate.mdl"
if(SERVER)then
	function ENT:Initialize()
		self.Entity:SetModel(self.Model)
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:SetUseType(SIMPLE_USE)
		self:SetHealth(25)
		self:DrawShadow(true)
	end
	local loot={
		{"ent_jack_hmcd_ammo",itemInfo={
			AmmoType={"Buckshot","Pistol","HelicopterGun","Gravity"},
			Rounds={50,100}
		}
		},
		{{"ent_jack_hmcd_medkit"},{"ent_jack_hmcd_bandagebig"},{"ent_jack_hmcd_bandage"}},
		{{"ent_jack_hmcd_grenade"},{"ent_jack_hmcd_grenade"},{"ent_jack_hmcd_grenade"}},
		{"ent_jack_hmcd_healthvial"}
	}
	function ENT:OnTakeDamage(dmginfo)
		local dam=dmginfo:GetDamage()
		self:SetHealth(self:Health()-dam)
		if self:Health()<=0 then
			local info=table.Random(loot)
			local entsToSpawn
			if istable(info[1]) then entsToSpawn=info else entsToSpawn={info} end
			for i,entInfo in pairs(entsToSpawn) do
				local ent=ents.Create(entInfo[1])
				if entInfo.itemInfo then
					for i,val in pairs(entInfo.itemInfo) do
						local setVal=val
						if istable(val) then setVal=table.Random(val) end
						ent[i]=setVal
					end
				end
				ent:SetPos(self:GetPos())
				ent:Spawn()
			end
			self:EmitSound("Wood.Break",60)
			self:GibBreakServer(dmginfo:GetDamageForce())
			self:Remove()
		end
	end
end