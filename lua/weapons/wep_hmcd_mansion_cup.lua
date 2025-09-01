if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	SWEP.ViewModelFOV = 75

	SWEP.Slot = 1
	SWEP.SlotPos = 1

	killicon.AddFont("wep_zac_hmcd_policebaton", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))

	function SWEP:Initialize()
		--wat
	end

	function SWEP:DrawViewModel()	
		return false
	end

	function SWEP:DrawWorldModel()	
		self:DrawModel()
	end

	function SWEP:DrawHUD()
		--
	end
end

SWEP.Base="weapon_base"

SWEP.ViewModel = "models/mu_hmcd_mansion/cup.mdl"
SWEP.WorldModel = "models/mu_hmcd_mansion/cup.mdl"

SWEP.PrintName="Cup"




if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_hmcd_mansion_cup");SWEP.BounceWeaponIcon=false end

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=3
SWEP.SwayScale=3
SWEP.Weight	= 3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.CommandDroppable=true

SWEP.Spawnable			= false
SWEP.AdminOnly			= true

SWEP.Primary.Delay			= 0.5
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 120
SWEP.Primary.NumShots		= 1	
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Force			= 900
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic   	= true
SWEP.Primary.Ammo         	= "none"

SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"

SWEP.ENT="ent_hmcd_mansion_cup"
SWEP.DownAmt=0
SWEP.HomicideSWEP=true
SWEP.CarryWeight=500

function SWEP:SetupDataTables()
		self:NetworkVar("Int",0,"HA")
		self:NetworkVar("Int",1,"PA")
		self:NetworkVar("Int",2,"BL")
		self:NetworkVar("Int",3,"BO")
		self:NetworkVar("Int",4,"CAP")
		self:NetworkVar("Int",5,"NE")
		self:NetworkVar("String",0,"TColour")
end

function SWEP:Initialize()
	self:SetHoldType("slam")
	self.DownAmt=20
	self.Nextsec=CurTime()
	
if(SERVER)then

	if(self.Tea_HA==nil)then
		self.Tea_HA,self.Tea_PA,self.Tea_BL,self.Tea_BO,self.Tea_NE,self.Tea_CAP=0,0,0,0,0,0

	end	

	end
	
	if(self:GetCAP()==0)then
		self.Instructions	= "Cup of nothing, fill it with something and then drink!\n\nLMB to drink.\nRMB while looking at food or something else to fill."	
		self.InfoMarkup = nil		
	else
			self.Instructions	= "Cup of tea, Contains ".. self:GetCAP() .."/5 ingredients:\n\nBleed ".. self:GetBL() .."\nPain ".. self:GetPA() .."\nBoost ".. self:GetBO() .."\nHarm ".. self:GetHA() .."\nNeutral ".. self:GetNE() .." \n\nLMB to drink.\nRMB while looking at food or something else to fill."
			self.InfoMarkup = nil		
	end	
end


function SWEP:PrimaryAttack()
	if(self.Owner:KeyDown(IN_SPEED) or self:GetCAP()==0)then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if(SERVER)then
		if((self.Poisoned)and(self.Owner.Murderer))then
			self.Owner:PrintMessage(HUD_PRINTCENTER,"This is poisoned!")
			self:SetNextPrimaryFire(CurTime()+1)
			return
		end
		self.Owner:ViewPunch(Angle(-30,0,0))
		sound.Play("snd_jack_hmcd_drink"..math.random(1,3)..".wav",self.Owner:GetShootPos(),60,math.random(100,110))
			local Boost=math.Clamp(self.Owner.FoodBoost-CurTime(),0,1000)
			Boost=Boost+self:GetBO()
			self.Owner.FoodBoost=CurTime()+Boost
			umsg.Start("HMCD_FoodBoost",self.Owner)
			umsg.Short(Boost)
			umsg.End()
			
			local Boost=math.Clamp(self.Owner.PainBoost-CurTime(),0,1000)
			Boost=Boost+self:GetPA()
			self.Owner.PainBoost=CurTime()+Boost
			umsg.Start("HMCD_PainBoost",self.Owner)
			umsg.Short(Boost)
			umsg.End()		
				
				local Dam=DamageInfo()
				Dam:SetAttacker(self.Owner)
				Dam:SetInflictor(self.Weapon)
				Dam:SetDamage(self:GetHA())
				Dam:SetDamageType(DMG_SLASH)			
				self.Owner:TakeDamageInfo(Dam)
			
			self.Owner.Bleedout=math.Clamp(self.Owner.Bleedout-self:GetBL(),0,1000)
			
			self:SetHA(0)
			self:SetPA(0)
			self:SetBL(0)
			self:SetBO(0)
			self:SetCAP(0)
			self:SetNE(0) 


			timer.Simple(0.2,function()		--WASUP?
			net.Start("mansion_client_tea")
			net.Send(self.Owner)
			end)

			self:SetTColour("255 255 255")
			
		if(self.Poisoned)then HMCD_Poison(self.Owner,self.Poisoner,true) end
		
		
		--self:Remove()
	end
	
end

function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime()+1)
	self.DownAmt=20
	self.Nextsec=CurTime()
	return true
end

function SWEP:SecondaryAttack()
	if(self.Nextsec>CurTime())then return end
	self.Nextsec=CurTime()+1 

		local trace =	self.Owner:GetEyeTrace()
		local model = 	trace.Entity:GetModel()
		local class = 	trace.Entity:GetClass() 
		if(MANSION_TEA_ALLOWEDCLASS[class] and trace.HitPos:DistToSqr(self.Owner:EyePos())<10000)then
		--PrintTable(MANSION_TEA_TRANSLATE[model])
		if(SERVER and self:GetCAP()<5)then
		local ha = MANSION_TEA_TRANSLATE[model]['ha']
		local pa = MANSION_TEA_TRANSLATE[model]['pa']
		local bl = MANSION_TEA_TRANSLATE[model]['bl']	
		local bo = MANSION_TEA_TRANSLATE[model]['bo']	
		local ne = MANSION_TEA_TRANSLATE[model]['ne']		
		
		if(ha~=nil)then
		self:SetHA(math.Clamp(self:GetHA()-ne,0,1000))--ofc you cant get 1000..??
		self:SetPA(math.Clamp(self:GetPA()-ne,0,1000))
		self:SetBL(math.Clamp(self:GetBL()-ne,0,1000))
		self:SetBO(math.Clamp(self:GetBO()-ne,0,1000))
		self:SetNE(math.Clamp(self:GetNE()+ne,0,1000))
		
		self:SetHA(math.Clamp(self:GetHA()+ha,0,1000))
		self:SetPA(math.Clamp(self:GetPA()+pa,0,1000))
		self:SetBL(math.Clamp(self:GetBL()+bl,0,1000))
		self:SetBO(math.Clamp(self:GetBO()+bo,0,1000))
		
		else
		local neu=math.random(0,5)
		local har=math.random(0,5)
		local pai=math.random(0,8)
		local bos=math.random(0,8)
		local ble=math.random(0,8)
		
		self:SetHA(math.Clamp(self:GetHA()-ne,0,1000))
		self:SetPA(math.Clamp(self:GetPA()-ne,0,1000))
		self:SetBL(math.Clamp(self:GetBL()-ne,0,1000))
		self:SetBO(math.Clamp(self:GetBO()-ne,0,1000))
		self:SetNE(math.Clamp(self:GetNE()+ne,0,1000))
		
		self:SetHA(math.Clamp(self:GetHA()+ha,0,1000))
		self:SetPA(math.Clamp(self:GetPA()+pa,0,1000))
		self:SetBL(math.Clamp(self:GetBL()+bl,0,1000))
		self:SetBO(math.Clamp(self:GetBO()+bo,0,1000))		
		
		end
		
		self:SetCAP(self:GetCAP()+1)
		
		local Tea_COLOR=string.ToColor(self:GetTColour())
		
		Tea_COLOR['r']=Tea_COLOR['r']-(self:GetPA())*5+(self:GetHA())*5
		Tea_COLOR['g']=Tea_COLOR['g']-(self:GetHA())*5+(self:GetNE())*5
		Tea_COLOR['b']=Tea_COLOR['b']-(self:GetBO())*5+(self:GetHA())*5
		
		local col = tostring(Tea_COLOR)
		--print(col)
		self:SetTColour(col)
		
		sound.Play("snd_jack_hmcd_drink".. 3 ..".wav",self.Owner:GetShootPos(),60,math.random(100,110))		
			--print(self:GetCAP())
			timer.Simple(0.2,function()		--WASUP?
			net.Start("mansion_client_tea")
			net.Send(self.Owner)
			end)
		--if(SERVER)then
		trace.Entity:Remove()
		--end
		end

		end
	

end

function SWEP:Think()
if(CLIENT)then

	net.Receive("mansion_client_tea",function()
	if(self:GetCAP()==0)then
		self.Instructions	= "Cup of nothing, fill it with something and then drink!\n\nLMB to drink.\nRMB while looking at food or something else to fill."	
		self.InfoMarkup = nil		
	else
			self.Instructions	= "Cup of tea, Contains ".. self:GetCAP() .."/5 ingredients:\n\nBleed ".. self:GetBL() .."\nPain ".. self:GetPA() .."\nBoost ".. self:GetBO() .."\nHarm ".. self:GetHA() .."\nNeutral ".. self:GetNE() .." \n\nLMB to drink.\nRMB while looking at food or something else to fill."
			self.InfoMarkup = nil		
	end
			end)
			

			
		end



	if(SERVER)then
		local HoldType="slam"
		if(self.Owner:KeyDown(IN_SPEED))then
			HoldType="normal"
		end
		self:SetHoldType(HoldType)
	end
end


function SWEP:Reload()
	--
end

function SWEP:OnDrop()
	local Ent=ents.Create(self.ENT)
	Ent.HmcdSpawned=self.HmcdSpawned
	Ent.Poisoned=self.Poisoned
	Ent.Poisoner=self.Poisoner
	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
			Ent.Tea_HA=self:GetHA()
			Ent.Tea_PA=self:GetPA()
			Ent.Tea_BL=self:GetBL()
			Ent.Tea_BO=self:GetBO()
			Ent.Tea_CAP=self:GetCAP()
			Ent.Tea_NE=self:GetNE() 
			Ent.Tea_COLOR=self:GetTColour()
	Ent:Spawn()
	Ent:Activate()
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity()/2)
	self:Remove()
end

function SWEP:NormalizeColor(Col)
	Colour = Color(math.Round(1/255*Col['r'],2),math.Round(1/255*Col['g'],2),math.Round(1/255*Col['b'],2))
	return Colour['r'],Colour['g'],Colour['b']
end

if(CLIENT)then 


	function SWEP:PreDrawViewModel(vm,ply,wep)
		vm:SetModel('models/mu_hmcd_mansion/cup.mdl')
		if(self:GetCAP()~=nil and self:GetCAP()>0)then
		vm:SetBodygroup(0,1) 
		vm:SetupBones()
			local pos = vm:GetBonePosition(0)
			if pos == vm:GetPos() then
				pos = vm:GetBoneMatrix(0):GetTranslation()
			end		
		
		vm:SetBonePosition(1,pos+(self:GetCAP()*0.3)*vm:GetAngles():Up(),vm:GetAngles()+Angle(0,0,90))
		--print(string.ToColor(self:GetTColour()))
		render.SetColorModulation(self:NormalizeColor(string.ToColor(self:GetTColour()) or Color(0,0,0)))
		end
	end
	function SWEP:GetViewModelPosition(pos,ang)
		if not(self.DownAmt)then self.DownAmt=0 end
		if(self.Owner:KeyDown(IN_SPEED))then
			self.DownAmt=math.Clamp(self.DownAmt+.2,0,20)
		else
			self.DownAmt=math.Clamp(self.DownAmt-.2,0,20)
		end
		pos=pos-ang:Up()*(self.DownAmt+10)+ang:Forward()*25+ang:Right()*7
		ang:RotateAroundAxis(ang:Up(),90)
		ang:RotateAroundAxis(ang:Right(),-10)
		ang:RotateAroundAxis(ang:Forward(),-10)
		return pos,ang
	end
	function SWEP:DrawWorldModel()
		local Pos,Ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		if(self.DatWorldModel)then
			if((Pos)and(Ang)and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
				self.DatWorldModel:SetRenderOrigin(Pos+Ang:Forward()*3-Ang:Up()*-1-Ang:Right()*-5)
				Ang:RotateAroundAxis(Ang:Up(),130)
				Ang:RotateAroundAxis(Ang:Right(),180)
				Ang:RotateAroundAxis(Ang:Forward(),30)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:SetBodygroup(0,1) 
				self.DatWorldModel:SetupBones()
					local pos = self.DatWorldModel:GetBonePosition(0)
					if pos == self.DatWorldModel:GetPos() then
						pos = self.DatWorldModel:GetBoneMatrix(0):GetTranslation()
					end		
				
				self.DatWorldModel:SetBonePosition(1,pos+(self:GetCAP()*0.3)*self.DatWorldModel:GetAngles():Up(),self.DatWorldModel:GetAngles()+Angle(0,0,90))
				render.SetColorModulation(self:NormalizeColor(string.ToColor(self:GetTColour()) or Color(0,0,0)))
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel=ClientsideModel('models/mu_hmcd_mansion/cup.mdl')
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
		end
	end
end