AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName		= "Cup"
ENT.SWEP="wep_hmcd_mansion_cup"
ENT.ImpactSound="Pottery.ImpactSoft"
	function ENT:SetupDataTables()
		self:NetworkVar("Int",0,"HA")
		self:NetworkVar("Int",1,"PA")
		self:NetworkVar("Int",2,"BL")
		self:NetworkVar("Int",3,"BO")
		self:NetworkVar("Int",4,"CAP")
		self:NetworkVar("Int",5,"NE")
		self:NetworkVar("String",0,"TColour")
	end
	
	function ENT:Initialize()
	if(SERVER)then
		self.Entity:SetModel("models/mu_hmcd_mansion/cup.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(6)
			phys:Wake()
			phys:EnableMotion(true)
		end
	--	print(self.Tea_CAP)
		if(self.Tea_CAP == nil)then 
			self:SetHA(0)
			self:SetPA(0)
			self:SetBL(0)
			self:SetBO(0)
			self:SetCAP(0)
			self:SetNE(0)
			self:SetTColour("255 255 255")
			--self:SetCOLOR)Color(255,255,255)
		else
			self:SetHA(self.Tea_HA)
			self:SetPA(self.Tea_PA)
			self:SetBL(self.Tea_BL)
			self:SetBO(self.Tea_BO)
			self:SetCAP(self.Tea_CAP)
			self:SetNE(self.Tea_NE)	
			self:SetTColour(self.Tea_COLOR)			
		end
		 if(self.Tea_COLOR~=nil)then
		local col = string.ToColor(self.Tea_COLOR)
		col['r']=math.Clamp(col['r'],0,255)
		col['g']=math.Clamp(col['g'],0,255)
		col['b']=math.Clamp(col['b'],0,255)
		self:SetColor(col)
		else
		self:SetColor(Color(255,255,255)) 
		end
		--print(1555,self.Tea_CAP)
		--self:SetColor(self.DColour or Color(0,0,0))
			
	end
	end 
	function ENT:PickUp(ply)
		local SWEP=self.SWEP
		if not(ply:HasWeapon(self.SWEP))then
			ply:Give(self.SWEP)
			ply:GetWeapon(self.SWEP).HmcdSpawned=self.HmcdSpawned
			ply:SelectWeapon(self.SWEP)
			
			local ha,pa,bl,bo,ne,cap=self:GetHA(),self:GetPA(),self:GetBL(),self:GetBO(),self:GetNE(),self:GetCAP()
			--print(123,self:GetHA())
			ply:GetWeapon(SWEP):SetHA(self:GetHA())
			ply:GetWeapon(SWEP):SetPA(self:GetPA())
			ply:GetWeapon(SWEP):SetBL(self:GetBL())
			ply:GetWeapon(SWEP):SetBO(self:GetBO())
			ply:GetWeapon(SWEP):SetNE(self:GetNE())
			ply:GetWeapon(SWEP):SetCAP(self:GetCAP())
			ply:GetWeapon(SWEP):SetTColour(self:GetTColour())
	
			ply:SelectWeapon(SWEP)
			--ply:GetWeapon("wep_hmcd_mansion_cup"):SetDColour(self:GetDColour())
			self:Remove()
			

			--ply:GetWeapon("wep_hmcd_mansion_cup"):SetCOLOR=self:SetCOLOR
			
		else
			ply:PickupObject(self)
		end
	end
	
	
	function ENT:NormalizeColor(Col)
		Colour = Color(math.Round(1/255*Col['r'],2),math.Round(1/255*Col['g'],2),math.Round(1/255*Col['b'],2))
		return Colour['r'],Colour['g'],Colour['b']
	end
	
	
	function ENT:Draw()--drarfing a tea
		self.Angle = self:GetAngles()
		self.Pos = self:GetPos()	
		if(self:GetCAP()>0)then
			self:SetBodygroup(0,1) 
			self:SetupBones()
				local matrix = self:GetBoneMatrix(0)
				local pos = matrix:GetTranslation()
				local ang = matrix:GetAngles()	
			
			self:SetBonePosition(1,pos+(self:GetCAP()*0.3)*self.Angle:Up(),self.Angle+Angle(0,0,90))
				self:DrawModel()
			--print(string.ToColor(self:GetTColour()))
			--render.SetColorModulation(self:NormalizeColor(string.ToColor(self:GetTColour()) or Color(0,0,0)))		
			
		else
		self:DrawModel()
		end


	end