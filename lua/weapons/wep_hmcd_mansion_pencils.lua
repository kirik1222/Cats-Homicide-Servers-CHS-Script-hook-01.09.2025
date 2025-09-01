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

SWEP.ViewModel = "models/mu_hmcd_mansion/weapon_pencils/v_pencil.mdl"
SWEP.WorldModel = "models/mu_hmcd_mansion/weapon_pencils/w_pencil.mdl"
--models/mu_hmcd_mansion/weapon_pencils/w_pencil.mdl
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_hmcd_mansion_pencils");SWEP.BounceWeaponIcon=false end
SWEP.PrintName = "Pencil"
SWEP.Instructions	= "This is your magical pencil, it can change its color to another, just think about it. Use it to draw something.\n\nHOLD RELOAD to open color menu.\nLMB to swing while in attack mode.\nRMB to draw while in draw mode.\nRMB + RELOAD to change between modes."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= "You know, where is 'mansion_sheetdots' convar."
SWEP.BobScale=3
SWEP.SwayScale=3
SWEP.Weight	= 3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false
SWEP.DangerLevel=35

SWEP.AttackSlowDown=.45
SWEP.FuckedWorldModel=true

SWEP.Spawnable			= true
SWEP.AdminOnly			= true

SWEP.Primary.Delay			= 1
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 120
SWEP.Primary.NumShots		= 1	
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Force			= 900
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic   	= true
SWEP.Primary.Ammo         	= "none"

SWEP.CommandDroppable=true

SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"
SWEP.HomicideSWEP=true
SWEP.CarryWeight=600
--SWEP.HolsterSlot=1
--SWEP.HolsterPos=Vector(-3,-33,6)
--SWEP.HolsterAng=Angle(90,180,0)
SWEP.Poisonable=true
SWEP.ENT="ent_hmcd_mansion_pencils"

function SWEP:SetupDataTables()
	self:NetworkVar("Float",0,"NextIdle")
	self:NetworkVar("Bool",0,"HookAdd")
	self:NetworkVar("Bool",1,"Mode")
	self:NetworkVar("Int",0,"PrevOwnerID")
	self:NetworkVar("String",0,"DColour")
end

function SWEP:Initialize()
	self:SetNextIdle(CurTime()+1)
	self:SetHoldType("melee")
	self.ALLOWOPENMENU=true
	self:SetHookAdd(false)
	
	self:SetMode(true) 
	NextMode=CurTime()
	
end

function SWEP:PrimaryAttack()
--self.Owner:GetViewModel():SetColor(Color(0,0,255))--DEBUG
if(self:GetMode()==true)then return end
	local Ent,HitPos,HitNorm=HMCD_WhomILookinAt(self.Owner,.35,70)
	if not(IsFirstTimePredicted())then
		self.Owner:GetViewModel():SetPlaybackRate(1)
		return
	end
	if(self.Owner.Stamina<6)then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
		self:DoBFSAnimation("attack")
		self:UpdateNextIdle()
		self.Owner:GetViewModel():SetPlaybackRate(1)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self:SetNextPrimaryFire(CurTime()+0.75)
	if(SERVER)then timer.Simple(.05,function() if(IsValid(self))then sound.Play("weapons/slam/throw.wav",self:GetPos(),85,math.random(90,110)) end end) end
		timer.Simple(.15,function()
			if(IsValid(self))then
				self:AttackFront()
			end
	end)
end

function SWEP:Deploy()

		 
--print(self:GetHookAdd())
--self.Owner:GetViewModel():SetColor(self.DColour or Color(0,0,0))
	self:SetPrevOwnerID(self.Owner:EntIndex())
if(IsFirstTimePredicted())then
	
end
	if not(IsFirstTimePredicted())then
		self:DoBFSAnimation("draw_idle")
		self.Owner:GetViewModel():SetPlaybackRate(.1)
		return
	end
	local col = string.ToColor(self:GetDColour())
		self.Owner:GetViewModel():SetColor(col or Color(0,0,0))
		if(self:GetMode()==true)then
		self:DoBFSAnimation("draw_idle")
		else
		self:DoBFSAnimation("draw_attack")
		end
		self:UpdateNextIdle()
	if(SERVER)then sound.Play("physics/wood/wood_crate_impact_soft3.wav",self.Owner:GetPos(),55,math.random(90,110)) end
	return true
end

function SWEP:SecondaryAttack()
--MANSION_DEATH_LIST[Entity(1):SteamID()]=3
--Anyone?
end

if(SERVER)then
	
	net.Receive("mansion_dcolour", function()
		local ent = net.ReadEntity()
		local tbl = net.ReadTable()
		if(tbl.a==nil)then tbl.a=255 end
		if(tbl.r==nil)then tbl.r=255 end
		if(tbl.g==nil)then tbl.g=255 end
		if(tbl.b==nil)then tbl.b=255 end
		--local col = Color(tbl.r, tbl.g, tbl.b, tbl.a)
		ent:SetDColour(tbl.r.." "..tbl.g.." "..tbl.b.." "..tbl.a)
	end)
	
	net.Receive("mansion_dscale", function()
		local ent = net.ReadEntity()
		local int = net.ReadInt(4)

		ent.DScale = int
	end)
end

if(CLIENT)then

end

function SWEP:Think()
	if(self:GetHookAdd()==false)then		--FUCKING SHIT TON OF BUGS HERE

		if(SERVER)then
		net.Start( "mansion_client_pencil"	)
		net.Send(self.Owner)
		--print(self.Owner)
		end	
	
		self:SetHookAdd(true)		--theres something there
	
	end
	
	local Time=CurTime()
	if(self:GetNextIdle()<Time)then
	if(self:GetMode()==true)then
		self:DoBFSAnimation("idle_draw")
	else
		self:DoBFSAnimation("idle_attack")
	end	
			self:UpdateNextIdle() 
	end
	if self.FistCanAttack && self.FistCanAttack < CurTime() then
		self.FistCanAttack = nil
		--self:SendWeaponAnim( ACT_VM_IDLE )
		self.IdleTime = CurTime() + 0.1
	end	
	if self.FistHit && self.FistHit < CurTime() then
		self.FistHit = nil
		--self:AttackTrace()
	end
	if(SERVER)then
		local HoldType="normal"
		if(self.Owner:KeyDown(IN_SPEED))then
			HoldType="normal"
		else
			HoldType="melee"
		end
		self:SetHoldType(HoldType)
	end
	if(self.Owner:KeyDown(IN_ATTACK2) and self.Owner:KeyDown(IN_RELOAD) and NextMode<CurTime())then
		if(self:GetMode()==true)then
			self:DoBFSAnimation("draw_to_attack") 
			self:SetMode(false)
		elseif(self:GetMode()==false)then
			self:DoBFSAnimation("attack_to_draw") 
			self:SetMode(true)
		end
		self:SetNextPrimaryFire(CurTime()+1)
		self:UpdateNextIdle()
		NextMode=CurTime()+1
	end
	
	local ENT=self.Owner:GetEyeTraceNoCursor().Entity
	if(IsValid(ENT) and ENT:GetClass()=='ent_hmcd_mansion_sheet' and self:GetMode()==true)then


		if(self.Owner:KeyDown(IN_ATTACK2))then
		local function WorldToScreen(vWorldPos,vPos,vScale,aRot)
			local vWorldPos=vWorldPos-vPos
			vWorldPos:Rotate(Angle(0,-aRot.y,0))
			vWorldPos:Rotate(Angle(-aRot.p,0,0))
			vWorldPos:Rotate(Angle(0,0,-aRot.r))
			return vWorldPos.x/vScale,(-vWorldPos.y)/vScale
			end
			local lookAtX,lookAtY = WorldToScreen(self.Owner:GetEyeTrace().HitPos or Vector(0,0,0),ENT:GetPos()+ENT:GetAngles():Up()*1, 0.1, ENT:GetAngles())
			--ENT.X=lookAtX
			--ENT.Y=lookAtY						--Old and shitty..
			--ENT.Colour = self.DColour or Color(0,0,0)
			--ENT.Scale = self.DScale or 4
			--ENT.Update=true
			ENT:DrawDot(lookAtX,lookAtY,string.ToColor(self:GetDColour()) or Color(0,0,0),self.DScale or 4)
			end
	end
	if(IsValid(self.Frame) and self.Owner:KeyReleased(IN_RELOAD))then
		self.Frame:Close()
		
	end
	if(self.Owner:KeyReleased(IN_RELOAD))then
		self.ALLOWOPENMENU=true
	end
end

function SWEP:AttackFront()
	self.Owner:ViewPunch(Angle(2,0,0))
	if(CLIENT)then return end
	self.Owner:LagCompensation(true)
	HMCD_StaminaPenalize(self.Owner,5)
	local Ent,HitPos,HitNorm=HMCD_WhomILookinAt(self.Owner,.35,70)

	local AimVec,Mul=self.Owner:GetAimVector(),1
	if((IsValid(Ent))or((Ent)and(Ent.IsWorld)and(Ent:IsWorld())))then
		local SelfForce=30
		local DamageAmt=math.random(8,10)
		if(self:IsEntSoft(Ent))then
				if((self.Poisoned)and(Ent:IsPlayer()))then
				HMCD_Poison(Ent,self.Owner)
				self.Poisoned=false
				end
				util.Decal("Blood",HitPos+HitNorm,HitPos-HitNorm)
				local edata = EffectData()
				edata:SetStart(self.Owner:GetShootPos())
				edata:SetOrigin(HitPos)
				edata:SetNormal(HitNorm)
				edata:SetEntity(Ent)
				util.Effect("BloodImpact",edata,true,true)
			sound.Play("snd_jack_hmcd_slash.wav",HitPos,70,math.random(80,90))
		else
			sound.Play("snd_jack_hmcd_knifehit.wav",HitPos,65,math.random(90,110))
		end
		local Dam=DamageInfo()
		Dam:SetAttacker(self.Owner)
		Dam:SetInflictor(self.Weapon)
		Dam:SetDamage(DamageAmt*Mul)
		Dam:SetDamageForce(AimVec*Mul/100)
		Dam:SetDamageType(DMG_SLASH)
		Dam:SetDamagePosition(HitPos)
		Ent:TakeDamageInfo(Dam)
		local Phys=Ent:GetPhysicsObject()
		if(IsValid(Phys))then
			if(Ent:IsPlayer())then 
			Ent:SetVelocity(-Ent:GetVelocity()/2) 
			end
			Phys:ApplyForceOffset(AimVec*25*Mul,HitPos)
			self.Owner:SetVelocity(-AimVec*SelfForce/100)
		end
	end
	self.Owner:LagCompensation(false)
end


function SWEP:Reload()


	if(CLIENT and self.ALLOWOPENMENU and !IsValid(self.Frame) and not self.Owner:KeyDown(IN_ATTACK2)) then
--print(self.DColour)
		local Frame = vgui.Create("DFrame")
		Frame:SetSize(250, 250)
		Frame:Center()
		Frame:MakePopup()
		Frame:SetTitle( "Color" )
		Frame.Target = self
		
		--Frame.Paint = function( sel, w, h ) -- 'function Frame:Paint( w, h )' works too
		--	print(self.DColour)
		--	draw.RoundedBox( 5, 0, 0, w, h, self.DColour or Color(0,0,0) )
		--end
		self.Frame = Frame
		--[[
		
		local Panel = vgui.Create("DPanel", Frame)
		Panel:SetSize(25, 10)
		Panel:SetPos(125, 8)
		Panel.Paint = function( sel, w, h ) -- 'function Frame:Paint( w, h )' works too
			draw.RoundedBox( 0, -1, -1, w+2, h+2, Color(0,0,0) )
			draw.RoundedBox( 0, 0, 0, w, h, self.DColour or Color(0,0,0) )
		end
]]
		
		local Mixer = vgui.Create("DColorPalette", Frame)
		Mixer:SetPos(5, 28)
		Mixer:SetButtonSize( 30 )
		Mixer:SetSize(265, 200)
		--Mixer:Dock(TOP)
	

		local Apply = vgui.Create("DButton", Frame)
		Apply:SetPos(5, 230)
		Apply:SetSize(241, 16)
		Apply:SetText("Eraser")
		Apply.Target = self
		function Apply:DoClick()
		if not(IsValid(self.Target))then return end
		local DColour = self.Target:GetDColour()
		if(DColour == nil)then DColour=Color(0,0,0) end
		value={
		['r']=DColour.r,
		['g']=DColour.g, 
		['b']=DColour.b,
		['a']=0
		}
			net.Start("mansion_dcolour")
				net.WriteEntity(self.Target)
				net.WriteTable(value)
			net.SendToServer()	
			Frame:Close()
			self.Target.ALLOWOPENMENU=false
		end
		
		local Slider = vgui.Create("DNumSlider", Frame)
		Slider:SetPos(5, 210)
		Slider:SetSize(200, 16)
		Slider:SetMin(1)
		Slider:SetMax(4)
		Slider:SetDecimals(0)
		Slider:SetText("Brush scale")
		Slider:SetValue(self.DScale or 4)
		Slider.Target = self
		--self.Slider=Slider
		Slider.OnValueChanged = function( s, value )
		self.DScale = math.Round(value)
		end
		
		function Frame:OnClose()
		if not(IsValid(self.Target))then return end
		--print(Slider:GetValue())
			net.Start("mansion_dscale")
				net.WriteEntity(self.Target)
				net.WriteInt(math.Round(Slider:GetValue()) or 1, 4)
			net.SendToServer()				
		end
		--[[
		local Scale = vgui.Create("DButton", Frame)
		Scale:SetPos(176, 211)
		Scale:SetSize(70, 16)
		Scale:SetText("Set scale")
		Scale.Target = self
		function Scale:DoClick()
		print(Slider:GetValue())
		self.Target.DScale = math.Round(Slider:GetValue())

			net.Start("mansion_dscale")
				net.WriteEntity(self)
				net.WriteInt(math.Round(Slider:GetValue()))
			net.SendToServer()			
		
			Frame:Close()
			self.Target.ALLOWOPENMENU=false
		end
		]]
		Mixer.OnValueChanged = function( s, value )
		if not(IsValid(self))then return end
		self:SetDColour(tostring(Color(math.Round(value.r, 2), math.Round(value.g, 2), math.Round(value.b, 2))))
		self.Owner:GetViewModel():SetColor(Color(value.r,value.g,value.b) or Color(0,0,0))
			net.Start("mansion_dcolour")
				net.WriteEntity(self)
				net.WriteTable(value)
			net.SendToServer()			
			Frame:Close()
			self.ALLOWOPENMENU=false
		end
	end
end

function SWEP:DoBFSAnimation(anim)
	local vm=self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
end

function SWEP:UpdateNextIdle()
	local vm=self.Owner:GetViewModel()
	self:SetNextIdle(CurTime()+vm:SequenceDuration())
end

function SWEP:IsEntSoft(ent)
	return ((ent:IsNPC())or(ent:IsPlayer())or(ent:GetClass()=="prop_ragdoll"))
end


function SWEP:OnDrop()
--hook.Remove( 'OnViewModelChanged', 'hmcd_mansion_pencils_viewmodel' )

	net.Start("mansion_pencil_clear")	
	net.WriteInt(self:GetPrevOwnerID() , 11)
	net.Send(Entity(self:GetPrevOwnerID()))	--Shitty patch... what else to do here?

	local Ent=ents.Create(self.ENT)
	Ent.HmcdSpawned=self.HmcdSpawned
	Ent.DColour=string.ToColor(self:GetDColour()) or Color(0,0,0)
	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
	Ent:Spawn()
	Ent:Activate()
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity()/2)
	self:Remove()
end

function SWEP:NormalizeColor(Col)
	--print(self.DColour)
	Colour = Color(math.Round(1/255*Col['r'],2),math.Round(1/255*Col['g'],2),math.Round(1/255*Col['b'],2))
	return Colour['r'],Colour['g'],Colour['b']
end

function SWEP:DrawWorldModel()
	if((IsValid(self.Owner))and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
		if(self.FuckedWorldModel)then
			if not(self.WModel)then
				self.WModel=ClientsideModel(self.WorldModel)
				self.WModel:SetPos(self.Owner:GetPos())
				self.WModel:SetParent(self.Owner)
				self.WModel:SetNoDraw(true)
			else
				local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
				if((pos)and(ang))then
					render.SetColorModulation(self:NormalizeColor(string.ToColor(self:GetDColour())or Color(0,0,0)))
					self.WModel:SetRenderOrigin(pos+ang:Right()*2+ang:Forward()*4+ang:Up()*0)
					ang:RotateAroundAxis(ang:Forward(),0)
					ang:RotateAroundAxis(ang:Right(),180)
					ang:RotateAroundAxis(ang:Up(),0)
					self.WModel:SetRenderAngles(ang)
					self.WModel:DrawModel()
					render.SetColorModulation(1,1,1)
				end
			end
		else
			self:DrawModel()
		end
	end
end