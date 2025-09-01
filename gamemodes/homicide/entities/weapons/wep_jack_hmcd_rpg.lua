if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 50
	SWEP.Slot = 2
	SWEP.SlotPos = 2
	killicon.AddFont("wep_jack_hmcd_bow", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))
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
SWEP.IconTexture="vgui/inventory/weapon_rpg7.vmt"
SWEP.IconLength=4
SWEP.IconHeight=2
SWEP.Base="wep_jack_hmcd_firearm_base"
SWEP.ViewModel = "models/weapons/tfa_ins2/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/tfa_ins2/w_rpg.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/inventory/weapon_rpg7.vmt");SWEP.BounceWeaponIcon=false end
SWEP.PrintName = "RPG-7"
SWEP.Instructions	= "This is a portable, reusable, unguided, shoulder-launched, anti-tank rocket-propelled grenade launcher.\n\nRMB to draw/aim.\nLMB to fire.\nRELOAD to reload."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=2
SWEP.SwayScale=2
SWEP.Weight	= 3
SWEP.AimTime=5
SWEP.BearTime=9
SWEP.TriggerDelay=1
SWEP.UseHands=true
SWEP.SprintPos=Vector(5,-1,-2)
SWEP.SprintAng=Angle(-20,70,-40)
SWEP.AimPos=Vector(-2.82, 0, -1.2)
SWEP.AimAng=Angle(2.97, -0.26, 4)
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false
SWEP.ViewModelFlip=false
SWEP.Spawnable			= true
SWEP.AdminOnly			= true
SWEP.Primary.Delay			= 0.5
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 120
SWEP.Primary.NumShots		= 1	
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= 1
SWEP.Primary.Force			= 900
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic   	= false
SWEP.FuckedWorldModel=true
SWEP.Primary.Ammo         	= "RPG_Round"
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
SWEP.NextCheck=1
SWEP.ReloadAnim="base_reload"
SWEP.ENT="ent_jack_hmcd_rpg"
SWEP.ReloadType="magazine"
SWEP.BarrelLength=14
SWEP.CommandDroppable=true
SWEP.CloseFireSound="weapons/ins2rpg7/rpg7_fp.wav"
SWEP.FarFireSound="weapons/rpg7/rpg7_dist.wav"
SWEP.DeathDroppable=true
SWEP.AimHoldType="rpg"
SWEP.HipHoldType="rpg"
SWEP.DownHoldType="passive"
SWEP.HolsterSlot=1
SWEP.CanAmmoShow=true
SWEP.AmmoType="RPG_Round"
SWEP.AmmoName="40mm Rocket"
SWEP.AmmoPoisonable=false
SWEP.ReloadRate=1
SWEP.ReloadTime=4.5
SWEP.NoBulletInChamber=true
SWEP.CarryWeight=10000
SWEP.ReloadSounds={
	{"weapons/ins2rpg7/handling/rpg7_fetch.wav",.5,"Both"},
	{"weapons/ins2rpg7/handling/rpg7_load1.wav",2.2,"Both"},
	{"weapons/ins2rpg7/handling/rpg7_load2.wav",2.9,"Both"},
	{"weapons/ins2rpg7/handling/rpg7_endgrab.wav",3.4,"Both"}
}
function SWEP:Initialize()
	self:SetRocketGone(self:Clip1()!=1 and not(self.Owner:IsNPC()))
	self.NextFrontBlockCheckTime=CurTime()
	self:SetHoldType(self.HipHoldType)
	self:SetAiming(0)
	self:SetSprinting(0)
	self:SetReady(true)
	timer.Simple(.1,function()
		if IsValid(self) then
			self:EnforceHolsterRules(self)
		end
	end)
	if self.Owner:IsNPC() and SERVER then
		hook.Add("Think",self,function()
			if IsValid(self.Owner) and self.Owner:Health()>0 and self.Owner:GetActivity()==ACT_RELOAD and not(self.Reloading) then
				self.Reloading=true
				timer.Simple(self.Owner:SequenceDuration(self.Owner:GetSequence()),function()
					if IsValid(self) and IsValid(self.Owner) and self.Owner:Health()>0 then
						self:SetRocketGone(false)
					end
				end)
			end
		end)
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool",0,"Ready")
	self:NetworkVar("Int",0,"Aiming")
	self:NetworkVar("Int",1,"Sprinting")
	self:NetworkVar("Bool",1,"Reloading")
	self:NetworkVar("Bool",2,"RocketGone")
	self:NetworkVar("Bool",3,"Suiciding")
end

local rpgWarnings={
	["combine"]={
		["male"]={
			"npc/combine_soldier/vo/displace.wav",
			"npc/combine_soldier/vo/displace2.wav",
			"npc/combine_soldier/vo/ripcordripcord.wav",
			"npc/metropolice/vo/shit.wav"
		}
	},
	["cp"]={
		["male"]={
			"npc/metropolice/vo/watchit.wav",
			"npc/metropolice/vo/movingtocover.wav",
			"npc/metropolice/vo/lookout.wav",
			"npc/metropolice/vo/shit.wav",
			"npc/metropolice/vo/getdown.wav"
		}
	},
	["rebel"]={
		["male"]={
			"vo/npc/male01/getdown02.wav",
			"vo/npc/male01/headsup01.wav",
			"vo/npc/male01/headsup02.wav",
			"vo/npc/male01/incoming02.wav",
			"vo/npc/male01/runforyourlife01.wav",
			"vo/npc/male01/runforyourlife02.wav",
			"vo/npc/male01/runforyourlife03.wav",
			"vo/npc/male01/startle01.wav",
			"vo/npc/male01/strider_run.wav",
			"vo/npc/male01/uhoh.wav",
			"vo/npc/male01/watchout.wav",
			"vo/canals/male01/stn6_incoming.wav"
		},
		["female"]={
			"vo/npc/female01/getdown02.wav",
			"vo/npc/female01/headsup01.wav",
			"vo/npc/female01/headsup02.wav",
			"vo/npc/female01/incoming02.wav",
			"vo/npc/female01/runforyourlife01.wav",
			"vo/npc/female01/runforyourlife02.wav",
			"vo/npc/female01/startle01.wav",
			"vo/npc/female01/strider_run.wav",
			"vo/npc/female01/uhoh.wav",
			"vo/npc/female01/watchout.wav"
		}
	}
}

rpgWarnings["npc_combine_s"]=rpgWarnings["combine"]
rpgWarnings["npc_sniper"]=rpgWarnings["combine"]
rpgWarnings["npc_citizen"]=rpgWarnings["rebel"]
rpgWarnings["npc_metropolice"]=rpgWarnings["cp"]

function SWEP:PrimaryAttack()
	if(self:GetSprinting()>10)then return end
	if not(self:GetReady())then return end
	if IsValid(self.Owner:GetNWEntity("Fake")) then return end
	--for i=0,10 do PrintTable(self.Owner:GetViewModel():GetAnimInfo(i)) end
	if not(IsFirstTimePredicted())then return end
	if(self.Owner.KeyDown and self.Owner:KeyDown(IN_SPEED))then return end
	if(self:GetReloading())then return end
	if not(self:Clip1()>0)then
		self:EmitSound("snd_jack_hmcd_click.wav",55,100)
		if(CLIENT)then
			LocalPlayer().AmmoShow=CurTime()+2
		end
		return
	end
	self:DoBFSAnimation("base_fire")
	local BackblastMul=1
	local DamageAmt=130
	local Pitch=math.random(90,110)
	if SERVER then
		local victims=player.GetAll()
		table.Add(victims,ents.FindByClass("npc_combine_s"))
		table.Add(victims,ents.FindByClass("npc_sniper"))
		table.Add(victims,ents.FindByClass("npc_citizen"))
		table.Add(victims,ents.FindByClass("npc_metropolice"))
		for i,ply in ipairs(victims) do
			local plyRole=ply.Role or ply:GetClass()
			if ply:Health()>0 and ply!=self.Owner and self.Owner.Role!=ply.Role and rpgWarnings[plyRole] and ply:Visible(self.Owner) and not(ply.Disposition and ply:Disposition(self.Owner)==D_LI) then
				local posnormal=(self.Owner:GetPos()-ply:GetPos()):GetNormalized()
				local aimvector=ply:GetAimVector()
				local DotProduct=aimvector:DotProduct(posnormal)
				local ApproachAngle=(-math.deg(math.asin(DotProduct))+90)
				if ApproachAngle<=60 then
					local neededTable
					local class=ply:GetNWString("Class")
					if rpgWarnings[class] and rpgWarnings[class][ply.ModelSex] then
						neededTable=rpgWarnings[class][ply.ModelSex]
					else
						neededTable=rpgWarnings[plyRole][ply.ModelSex]
					end
					local Rand=table.Random(neededTable)
					ply.tauntsound=Rand
					ply:EmitSound(Rand)
					local BeepTime=SoundDuration(Rand)
					ply.NextTaunt=CurTime()+BeepTime
					if ply.Role=="combine" or NPC_RELATIONSHIPS["Combine"][plyRole] then
						local role,maxOn,maxOff="combine_soldier",4,6
						if ply:GetNWString("Class")=="cp" then role="metropolice" maxOn=2 maxOff=4 end
						ply:EmitSound("npc/"..role.."/vo/on"..math.random(1,maxOn)..".wav")
						timer.Simple(BeepTime,function()
							if IsValid(ply) and ply:Health()>0 then
								ply:EmitSound("npc/"..role.."/vo/off"..math.random(1,maxOff)..".wav")
							end
						end)
					end
					break
				end
			end
		end
	end
	timer.Simple(.3,function()
		if IsValid(self) then
			self.Owner:SetAnimation(PLAYER_ATTACK1)
			if SERVER then
				self:SetRocketGone(true)
				local backblastEnts=ents.FindInCone( self.Owner:GetShootPos()+self.Owner:EyeAngles():Forward()*-20+self.Owner:EyeAngles():Right()*9+self.Owner:EyeAngles():Up()*-5, -self.Owner:GetAimVector(), 100, math.cos( math.rad( 45 ) ) )
				local tr=util.QuickTrace(self.Owner:GetShootPos(),self.Owner:EyeAngles():Forward()*-20+self.Owner:EyeAngles():Right()*9+self.Owner:EyeAngles():Up()*-5,{self.Owner})
				if IsValid(tr.Entity) and not(table.HasValue(backblastEnts,tr.Entity)) then table.insert(backblastEnts,tr.Entity) end
				for i,ent in pairs(backblastEnts) do
					if(ent.Health) and ent:Health()>0 and self.Owner:Visible(ent) then
						local DamageAmt=130
						local Dam=DamageInfo()
						Dam:SetAttacker(self.Owner)
						Dam:SetInflictor(self.Weapon)
						Dam:SetDamage(DamageAmt)
						Dam:SetDamageForce(self.Owner:GetAngles():Forward()*-100)
						if ent:IsPlayer() or ent:IsRagdoll() then
							Dam:SetDamageType(DMG_DROWNRECOVER)
						else
							Dam:SetDamageType(DMG_CLUB)
						end
						Dam:SetDamagePosition(ent:GetPos())
						ent:TakeDamageInfo(Dam)
					end
				end
			end
			if(SERVER)then
				local Dist=75
				if(self.Suppressed)then Dist=55 end
				if((self.SuppressedPistol) or (self.SuppressedRifle)) and (self.SuppressedFireSound)then 
					sound.Play(self.SuppressedFireSound,self.Owner:GetShootPos()-vector_up,Dist,Pitch)
				else
					self.Owner:EmitSound(self.CloseFireSound)
					self.Owner:EmitSound(self.FarFireSound)
				end
				if(self.ExtraFireSound)then sound.Play(self.ExtraFireSound,self.Owner:GetShootPos()+VectorRand(),Dist-5,Pitch) end
			end
			self:FireRocket()
			self:TakePrimaryAmmo(1)
			--if(self.Owner:GetAmmoCount(self.Primary.Ammo)<1)then
			--end
			util.ScreenShake(self.Owner:GetShootPos(),7,255,.1,20)
			if self.Owner.ViewPunch then self.Owner:ViewPunch(Angle(0,-1,0)) end
			ParticleEffect("ins_weapon_rpg_backblast",self.Owner:GetShootPos()+self.Owner:GetAimVector()*-100,-self.Owner:EyeAngles())
		end
	end)
	self:SetNextPrimaryFire(CurTime()+1)
end

function SWEP:FireRocket()
	if(CLIENT)then return end
	self.Owner:SetLagCompensated(true)
	local Rocket=ents.Create("ent_ins2rpgrocket1")
	Rocket.HmcdSpawned=self.HmcdSpawned
	Rocket:SetPos(self.Owner:GetShootPos()+self.Owner:GetAimVector()*60)
	Rocket.Owner=self.Owner
	local Ang=self.Owner:GetAimVector():Angle()
	Rocket:SetAngles(Ang)
	Rocket.Fired=true
	Rocket.InitialDir=self.Owner:GetAimVector()
	Rocket.InitialVel=self.Owner:GetVelocity()
	Rocket:Spawn()
	Rocket:Activate()
	Rocket:SetOwner(self.Owner)
	phys = Rocket:GetPhysicsObject()
	self.Owner:SetLagCompensated(false)
	local eyeAng = self.Owner:EyeAngles()
	local forward = eyeAng:Forward()
	if IsValid(phys) then
		Rocket:SetVelocity(forward * 2996)
	end
end

function SWEP:Deploy()
	if(self:Clip1()==0)then 
		self:DoBFSAnimation("empty_draw")
	end
	if not(IsFirstTimePredicted())then return end
	if not((self)and(self.Owner)and(self.Owner.GetViewModel))then return end
	self.DownAmt=40
	self.Owner:GetViewModel():SetPlaybackRate(.5)
	if(Reloading==0)then
		self:SetNextPrimaryFire(CurTime()+2)
	end
	self:SetRocketGone(self:Clip1()!=1)
	self:EnforceHolsterRules(self)
	self:SetReady(false)
	self:EmitSound("snd_jack_hmcd_pistoldraw.wav",70,self.HandlingPitch)
	timer.Simple(1.5,function() if(IsValid(self))then self:SetReady(true) end end)
	return true
end

function SWEP:HMCDOnDrop()
	local Ent=ents.Create(self.ENT)
	Ent.HmcdSpawned=self.HmcdSpawned
	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
	Ent:Spawn()
	if self:Clip1()==0 then Ent:SetBodygroup(1, 1) end
	Ent:Activate()
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity()/2)
	self:Remove()
end

if(CLIENT)then
	local nextRocketCheck=0
	function SWEP:DrawWorldModel()
		if self.Owner:GetNoDraw() then return end
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
						self.WModel:SetRenderOrigin(pos+ang:Right()+ang:Up()*-1)
						ang:RotateAroundAxis(ang:Forward(),180)
						ang:RotateAroundAxis(ang:Right(),10)
						self.WModel:SetRenderAngles(ang)
						if nextRocketCheck<CurTime() then
							nextRocketCheck=CurTime()+.1
							if self:GetRocketGone() and self.WModel:GetBodygroup(1)==0 then
								self.WModel:SetBodygroup( 1,1 )
							elseif not(self:GetRocketGone()) and self.WModel:GetBodygroup(1)==1 then
								self.WModel:SetBodygroup( 1,0 )
							end
						end
						self.WModel:DrawModel()
					end
				end
			else
				self:DrawModel()
			end
		end
	end
end