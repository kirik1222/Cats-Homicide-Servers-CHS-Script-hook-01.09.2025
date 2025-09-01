if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	SWEP.ViewModelFOV = 55

	SWEP.Slot = 3
	SWEP.SlotPos = 2

	killicon.AddFont("wep_jack_hmcd_food", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))

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

SWEP.ViewModel = "models/birbake/birbake.mdl"
SWEP.WorldModel = "models/birbake/birbake.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_birbake");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_birbake"
SWEP.PrintName = "Birbake"
SWEP.Instructions	= "C выходом с зоны!!!.\n\nLMB to eat."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=3
SWEP.SwayScale=3
SWEP.Weight	= 3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.CommandDroppable=true

SWEP.Spawnable			= true
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

SWEP.ENT="ent_jack_hmcd_birbake"
SWEP.DownAmt=0
SWEP.HomicideSWEP=true
SWEP.CarryWeight=1500

function SWEP:Initialize()
	self:SetHoldType("duel")
	self.DownAmt=20
end

function SWEP:PrimaryAttack()
	if(self.Owner.JawBroken)then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if(SERVER)then
		if((self.Poisoned)and(self.Owner.Murderer))then
			self.Owner:PrintMessage(HUD_PRINTCENTER,"This is poisoned!")
			self:SetNextPrimaryFire(CurTime()+1)
			return
		end
		sound.Play("snd_jack_hmcd_eat"..math.random(1,4)..".wav",self.Owner:GetShootPos(),60,math.random(90,100))
		local owner=self.Owner
		timer.Simple(.1,function()
			local str=owner:EntIndex().."_CakeEaten"
			owner:EmitSound("birbo_out_of_prison/dudelka.mp3",100,math.random(90,100))
			local effectAmt=0
			local nextEffect=0
			hook.Add("Think",str,function()
				if not(IsValid(owner)) then hook.Remove("Think",str) return end
				if nextEffect<CurTime() then
					nextEffect=CurTime()+.05
					local pos=owner:LocalToWorld(owner:OBBCenter())+VectorRand()*10
					local edata = EffectData()
					edata:SetStart(pos)
					edata:SetOrigin(pos)
					edata:SetNormal(pos:GetNormalized())
					edata:SetEntity(owner)
					edata:SetRadius(10)
					util.Effect("balloon_pop",edata,true,true)
					effectAmt=effectAmt+1
					if effectAmt==50 then
						owner:EmitSound("birbo_out_of_prison/fnaf-yay-children.mp3",100,math.random(90,100))
						hook.Remove("Think",str)
					end
				end
			end)
		end)
		if not(self.Owner.BrokenBones["Intestines"] or self.Owner.BrokenBones["Stomach"]) then
			if not(self.Owner.StomachContents["Food"]) then self.Owner.StomachContents["Food"]={} end
			table.insert(self.Owner.StomachContents["Food"],666)
		end
		if self.Infected then
			self.Owner:AddBacteria(45,CurTime()-101)
		end
		if(self.Poisoned)then HMCD_Poison(self.Owner,self.Poisoner,"CyanidePowder") end
		self:SetNextPrimaryFire(CurTime()+1)
		self:Remove()
	end
end

function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime()+1)
	self.DownAmt=20
	return true
end

function SWEP:SecondaryAttack()
	--
end

function SWEP:Think()
	if(SERVER)then
		local HoldType="duel"
		if(self.Owner:KeyDown(IN_SPEED))then
			HoldType="normal"
		end
		self:SetHoldType(HoldType)
	end
end

function SWEP:Reload()
	--
end

function SWEP:HMCDOnDrop()
	local Ent=ents.Create(self.ENT)
	Ent.HmcdSpawned=self.HmcdSpawned
	Ent.Poisoned=self.Poisoned
	Ent.Poisoner=self.Poisoner
	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
	Ent:Spawn()
	Ent:Activate()
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity()/2)
	self:Remove()
end

if(CLIENT)then
	function SWEP:GetViewModelPosition(pos,ang)
		if not(self.DownAmt)then self.DownAmt=0 end
		if(self.Owner:KeyDown(IN_SPEED))then
			self.DownAmt=math.Clamp(self.DownAmt+.2,0,20)
		else
			self.DownAmt=math.Clamp(self.DownAmt-.2,0,20)
		end
		pos=pos-ang:Up()*(self.DownAmt+20)+ang:Forward()*25+ang:Right()*7
		ang:RotateAroundAxis(ang:Up(),90)
		ang:RotateAroundAxis(ang:Right(),-10)
		ang:RotateAroundAxis(ang:Forward(),-10)
		return pos,ang
	end
	function SWEP:DrawWorldModel()
		local Pos,Ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		if(self.DatWorldModel)then
			if((Pos)and(Ang)and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
				self.DatWorldModel:SetRenderOrigin(Pos+Ang:Forward()*4-Ang:Up()*3+Ang:Right()*10)
				Ang:RotateAroundAxis(Ang:Right(),180)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel=ClientsideModel(self.WorldModel)
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
		end
	end
end