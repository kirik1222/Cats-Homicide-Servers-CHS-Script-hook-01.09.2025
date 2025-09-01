----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------[[
--           JJJJJJJJJJJ                                   kkkkkkkk                                                                                            d::::::d                       --
--           J:::::::::J                                   k::::::k                                                                                            d::::::d                       --
--           J:::::::::J                                   k::::::k                                                                                            d::::::d                       --
--           JJ:::::::JJ                                   k::::::k                                                                                            d:::::d                        --
--             J:::::J  aaaaaaaaaaaaa      cccccccccccccccc k:::::k    kkkkkkkaaaaaaaaaaaaa  rrrrr   rrrrrrrrr   uuuuuu    uuuuuunnnn  nnnnnnnn        ddddddddd:::::d   aaaaaaaaaaaaa        --
--             J:::::J  a::::::::::::a   cc:::::::::::::::c k:::::k   k:::::k a::::::::::::a r::::rrr:::::::::r  u::::u    u::::un:::nn::::::::nn    dd::::::::::::::d   a::::::::::::a       --
--             J:::::J  aaaaaaaaa:::::a c:::::::::::::::::c k:::::k  k:::::k  aaaaaaaaa:::::ar:::::::::::::::::r u::::u    u::::un::::::::::::::nn  d::::::::::::::::d   aaaaaaaaa:::::a      --
--             J:::::j           a::::ac:::::::cccccc:::::c k:::::k k:::::k            a::::arr::::::rrrrr::::::ru::::u    u::::unn:::::::::::::::nd:::::::ddddd:::::d            a::::a      --
--             J:::::J    aaaaaaa:::::ac::::::c     ccccccc k::::::k:::::k      aaaaaaa:::::a r:::::r     r:::::ru::::u    u::::u  n:::::nnnn:::::nd::::::d    d:::::d     aaaaaaa:::::a      --
-- JJJJJJJ     J:::::J  aa::::::::::::ac:::::c              k:::::::::::k     aa::::::::::::a r:::::r     rrrrrrru::::u    u::::u  n::::n    n::::nd:::::d     d:::::d   aa::::::::::::a      --
-- J:::::J     J:::::J a::::aaaa::::::ac:::::c              k:::::::::::k    a::::aaaa::::::a r:::::r            u::::u    u::::u  n::::n    n::::nd:::::d     d:::::d  a::::aaaa::::::a      --
-- J::::::J   J::::::Ja::::a    a:::::ac::::::c     ccccccc k::::::k:::::k  a::::a    a:::::a r:::::r            u:::::uuuu:::::u  n::::n    n::::nd:::::d     d:::::d a::::a    a:::::a      --
-- J:::::::JJJ:::::::Ja::::a    a:::::ac:::::::cccccc:::::ck::::::k k:::::k a::::a    a:::::a r:::::r            u:::::::::::::::uun::::n    n::::nd::::::ddddd::::::dda::::a    a:::::a      --
--  JJ:::::::::::::JJ a:::::aaaa::::::a c:::::::::::::::::ck::::::k  k:::::ka:::::aaaa::::::a r:::::r             u:::::::::::::::un::::n    n::::n d:::::::::::::::::da:::::aaaa::::::a      --
--    JJ:::::::::JJ    a::::::::::aa:::a cc:::::::::::::::ck::::::k   k:::::ka::::::::::aa:::ar:::::r              uu::::::::uu:::un::::n    n::::n  d:::::::::ddd::::d a::::::::::aa:::a     --
--      JJJJJJJJJ       aaaaaaaaaa  aaaa   cccccccccccccccckkkkkkkk    kkkkkkkaaaaaaaaaa  aaaarrrrrrr                uuuuuuuu  uuuunnnnnn    nnnnnn   ddddddddd   ddddd  aaaaaaaaaa  aaaa     --
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]
if ( SERVER ) then
	AddCSLuaFile()
else
	killicon.AddFont( "wep_jack_hmcd_smallpistol", "HL2MPTypeDeath", "1", Color( 255, 0, 0 ) )
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_smallpistol")
	SWEP.BounceWeaponIcon=false
end
SWEP.IconTexture="vgui/wep_jack_hmcd_smallpistol"
SWEP.Base = "weapon_base"
SWEP.Slot			= 2
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.ViewModelFlip	= true
SWEP.ViewModelFOV	= 70
SWEP.ViewModel		= "models/weapons/gleb/c_px4.mdl"
SWEP.WorldModel		= "models/weapons/w_matt_mattpx4v1.mdl"
SWEP.HoldType		= "pistol"
SWEP.BobScale=1.5
SWEP.SwayScale=1.5
SWEP.Weight			= 5
SWEP.AutoSwitchTo	= true
SWEP.AutoSwitchFrom	= false
SWEP.Spawnable		= true
SWEP.AdminOnly		= true

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""

SWEP.Primary.Sound				= "snd_jack_hmcd_smp_close.wav"
SWEP.Primary.Damage				= 120
SWEP.Primary.NumShots			= 1
SWEP.Primary.Recoil				= 5
SWEP.Primary.Cone				= 1
SWEP.Primary.Delay				= 3
SWEP.Primary.ClipSize			= 11
SWEP.Primary.DefaultClip		= 0
SWEP.Primary.Tracer				= 1
SWEP.Primary.Force				= 420
SWEP.Primary.TakeAmmoPerBullet	= false
SWEP.Primary.Automatic			= false
SWEP.Primary.Ammo				= "Pistol"

SWEP.Secondary.Sound				= ""
SWEP.Secondary.Damage				= 10
SWEP.Secondary.NumShots				= 1
SWEP.Secondary.Recoil				= 1
SWEP.Secondary.Cone					= 0
SWEP.Secondary.Delay				= 0.25
SWEP.Secondary.ClipSize				= -1
SWEP.Secondary.DefaultClip			= -1
SWEP.Secondary.Tracer				= -1
SWEP.Secondary.Force				= 5
SWEP.Secondary.TakeAmmoPerBullet	= false
SWEP.Secondary.Automatic			= false
SWEP.Secondary.Ammo					= "none"

SWEP.BarrelMustSmoke=false
SWEP.AimTime=3
SWEP.BearTime=3
SWEP.SprintPos=Vector(-4,0,-10)
SWEP.SprintAng=Angle(80,0,0)
SWEP.AimPos=Vector(2.05,0,1.45)
SWEP.Alt=0
SWEP.DeathDroppable=true
SWEP.CanAmmoShow=true
SWEP.CommandDroppable=true
SWEP.ENT="ent_jack_hmcd_smallpistol"
SWEP.MuzzleSmoke=false
SWEP.Damage=30
SWEP.MuzzleEffect="pcf_jack_mf_spistol"
SWEP.MuzzleEffectSuppressed="pcf_jack_mf_suppressed"
SWEP.ReloadTime=3
SWEP.ReloadRate=.6
SWEP.ReloadSound=""
--SWEP.CloseFireSound="snd_jack_hmcd_smp_close.wav"
--SWEP.FarFireSound="snd_jack_hmcd_smp_far.wav"
SWEP.CloseFireSound="m9/m9_fp.wav"
SWEP.FarFireSound="m9/m9_dist.wav"
SWEP.HipHoldType="pistol"
SWEP.AimHoldType="revolver"
SWEP.DownHoldType="normal"
SWEP.AmmoType="Pistol"
SWEP.BarrelLength=1
SWEP.HandlingPitch=100
SWEP.TriggerDelay=.15
SWEP.CycleTime=0
SWEP.Recoil=1
SWEP.Supersonic=true
SWEP.Accuracy=.99
SWEP.Spread=0
SWEP.NumProjectiles=1
SWEP.ShotPitch=100
SWEP.VReloadTime=0
SWEP.HipFireInaccuracy=.25
SWEP.CycleType="auto"
SWEP.ReloadType="magazine"
SWEP.LastFire=0
SWEP.FireAnim="shoot1"
SWEP.DrawAnim="draw"
SWEP.ReloadAnim="reload"
SWEP.ReloadInterrupted=false
SWEP.HomicideSWEP=true
SWEP.Holster=false
SWEP.ShellEffect="eff_jack_hmcd_919"
SWEP.NextBipodTime=0
SWEP.BipodDeployed=false
SWEP.BipodSensitivity = {x = -0.3, z = 0.3, p = 0.1, r = 0.1}
SWEP.ShellDelay=0
SWEP.ShellAttachment=2
SWEP.ReloadMul=1
SWEP.MagPos={10,-30,0}
SWEP.MagDelay=.7
SWEP.MuzzlePos={6.9,-2.1,1.6}
SWEP.SmokeEffect="pcf_jack_mf_barrelsmoke"
SWEP.DrawRate=.5
SWEP.ReloadAdd=0
SWEP.DangerLevel=90
SWEP.BulletVelocity=360
SWEP.PreviousBodygroups={}
SWEP.SuicideTime=5
SWEP.SuicideType="Pistol"
SWEP.DrawnAttachments={}
SWEP.WDrawnAttachments={}
SWEP.SprintAddMul=300
SWEP.SuicideAddMul=300
SWEP.AimAddMul=300
SWEP.AimPerc=0
SWEP.SprintingWeapon=0
SWEP.SuicideAmt=0
SWEP.BipodAmt=0
SWEP.FrontBlockedPerc=0
SWEP.FrontBlocked=0
SWEP.InertiaScale=1

if SERVER then
	concommand.Add("suicide",function(ply,cmd,args)
		local wep=ply:GetActiveWeapon()
		if not(wep.SuicidePos and wep.SuicideAng) or wep:GetNWBool("GhostSuiciding") or not(wep:GetReady()) then return end
		if IsValid(wep) and wep.GetSuiciding then
			if wep:GetSuiciding() then
				wep:SetSuiciding(false)
				ply:SetDSP(0)
			else
				if not(wep:GetNWBool("Suppressor") and wep.SuicideType=="Rifle") then
					wep:SetSuiciding(true)
					ply:SetDSP(130)
				else
					ply:PrintMessage(HUD_PRINTTALK,"Your weapon is too long. Take the suppressor off.")
				end
			end
		end
	end)
end

function SWEP:Shell()
	if self.ShellEffect=="" then return end
	if not IsValid(self.Owner) then return end
	if (not(IsFirstTimePredicted()) or self.Owner:Health()<=0)then return end
	local effectdata = EffectData()
	effectdata:SetEntity(self)
	util.Effect("eff_jack_hmcd_bulletcase",effectdata)
end

function SWEP:ShellReload(amt)
	if self.ShellEffectReload=="" then return end
	if not IsValid(self.Owner) then return end
	if (not(IsFirstTimePredicted()) or self.Owner:Health()<=0)then return end
	local fakeWep=self.Owner.FakeWep
	local effectdata=EffectData()
	if IsValid(fakeWep) then
		effectdata:SetEntity(fakeWep)
	else
		effectdata:SetEntity(self)
	end
	for i=1,amt or 1 do
		util.Effect("eff_jack_hmcd_bulletcase",effectdata)
	end
end

local npcAim={
	["npc_combine_s"]=WEAPON_PROFICIENCY_PERFECT,
	["npc_metropolice"]=WEAPON_PROFICIENCY_VERY_GOOD,
	["npc_citizen"]=WEAPON_PROFICIENCY_VERY_GOOD
}

local recoilControlByRole={
	["russian"]=0.8,
	["ukrainian"]=0.8,
	["killer"]=0.5,
	["combine"]=0.5,
	["freeman"]=0.5,
	["jesus"]=0.25,
	["terminator"]=0.25
}

function SWEP:Initialize()
	self.NextFrontBlockCheckTime=CurTime()
	if not(self.Owner:IsNPC()) then
		self:SetHoldType(self.HipHoldType)
	else
		self:SetHoldType(self.AimHoldType)
	end
	self:SetReady(true)
	self:SetSuiciding(false)
	self:SetLaserEnabled(false)
	if(self.CustomColor)then self:SetColor(self.CustomColor) end
	self:SetReloading(false)
	timer.Simple(.1,function()
		if IsValid(self) then
			self:EnforceHolsterRules(self)
		end
	end)
	if self.Owner:IsNPC() and SERVER then
		self.NPCAltFireTime=CurTime()+math.random(30,60)
		self.Owner.Elite=self.Owner:GetModel()=="models/combine_super_soldier.mdl"
		if npcAim[self.Owner:GetClass()] then
			timer.Simple(0,function()
				if IsValid(self) then
					self.RoundsInMag=self:Clip1()
					self.Owner:SetCurrentWeaponProficiency(npcAim[self.Owner:GetClass()])
				end
			end)
		end
		if self.NPCAnims then self.ActivityTranslateAI=self.NPCAnims end
		hook.Add("Think",self,function()
			if IsValid(self.Owner) and self.Owner.GetEnemy then
				local enemy=self.Owner:GetEnemy()
				if IsValid(enemy) then
					local body
					if enemy.GetRagdollEntity then body=enemy:GetRagdollEntity() end
					if IsValid(body) then
						local ang=(body:GetPos()-self.Owner:GetPos()):Angle()
						ang.r=0
						ang.p=0
						self.Owner:SetAngles(ang)
						if not(self.Reloading) and self:GetNextPrimaryFire()<=CurTime() and self:Clip1()>0 and self.Owner:Visible(body) then
							self:SetAnimation(PLAYER_ATTACK1)
							self:PrimaryAttack()
							local delay=self.TriggerDelay*2
							if self:Clip1()==0 then delay=self.ReloadTime end
							self:SetNextPrimaryFire(CurTime()+delay)
						end
					end
					if enemy.TFALean and math.abs(enemy.TFALean)>.9 then
						if self.Owner:VisibleVec(enemy:GetShootPos()) then
							local posnormal=(enemy:GetPos()-self.Owner:EyePos()):GetNormalized()
							local aimvector=self.Owner:EyeAngles():Forward()
							local DotProduct=aimvector:DotProduct(posnormal)
							local ApproachAngle=(-math.deg(math.asin(DotProduct))+90)
							if ApproachAngle<=60 then
								local ang=(enemy:GetShootPos()-self.Owner:GetPos()):Angle()
								ang.r=0
								ang.p=0
								self.Owner:SetAngles(ang)
								if not(self.Reloading) and self:GetNextPrimaryFire()<=CurTime() and self:Clip1()>0 then
									self:SetAnimation(PLAYER_ATTACK1)
									self:PrimaryAttack()
									local delay=self.TriggerDelay*2
									if self:Clip1()==0 then delay=self.ReloadTime end
									self:SetNextPrimaryFire(CurTime()+delay)
								end
							end
						end
					end
				else
					for i,ply in pairs(player.GetAll()) do
						if ply.TFALean and math.abs(ply.TFALean)>.9 and ply:Alive() and self.Owner:Disposition(ply)==D_HT then
							if self.Owner:VisibleVec(ply:GetShootPos()) then
								local posnormal=(ply:GetPos()-self.Owner:EyePos()):GetNormalized()
								local aimvector=self.Owner:EyeAngles():Forward()
								local DotProduct=aimvector:DotProduct(posnormal)
								local ApproachAngle=(-math.deg(math.asin(DotProduct))+90)
								if ApproachAngle<=60 then
									local ang=(ply:GetShootPos()-self.Owner:GetPos()):Angle()
									ang.r=0
									ang.p=0
									self.Owner:SetAngles(ang)
									if not(self.Reloading) and self:GetNextPrimaryFire()<=CurTime() and self:Clip1()>0 then
										self:SetAnimation(PLAYER_ATTACK1)
										self:PrimaryAttack()
										local delay=self.TriggerDelay*2
										if self:Clip1()==0 then delay=self.ReloadTime end
										self:SetNextPrimaryFire(CurTime()+delay)
									end
									self.Owner:UpdateEnemyMemory(ply,ply:GetShootPos())
									break
								end
							end
						end
					end
				end
			end
			if not(self.Reloading) and self.Owner.GetActivity and self.Owner:GetActivity()==ACT_RELOAD then
				self.Reloading=true
				self.RoundsInMag=nil
				local reloadSounds=self.ReloadSounds
				if reloadSounds then
					if isfunction(reloadSounds) then
						reloadSounds=reloadSounds(self)
					end
					local TacticalReload=self:Clip1()>0
					local mul=1
					if self.Owner:GetCurrentWeaponProficiency()>2 then mul=0.5 end
					for i,sndinfo in pairs(reloadSounds) do
						timer.Simple(sndinfo[2]*mul,function()
							if IsValid(self) and self.NextReload and IsValid(self.Owner) and (sndinfo[3]=="Both" or (sndinfo[3]=="EmptyOnly" and not(TacticalReload)) or (sndinfo[3]=="FullOnly" and (TacticalReload))) then
								self.Weapon:EmitSound(sndinfo[1],65,100)
								if sndinfo[4] then sndinfo[4](self) end
								lastSound=sndinfo[1]
							end
						end)
					end
				elseif self.ReloadSound and not(self.Reloading) then
					self.Weapon:EmitSound(self.ReloadSound,65,100)
				end
				local dur=self.Owner:SequenceDuration(self.Owner:SelectWeightedSequence(ACT_RELOAD))
				if dur<0.2 then dur=self.Owner:SequenceDuration(self.Owner:SelectWeightedSequence(self.ReloadSequence or ACT_RELOAD_SMG1)) end
				timer.Simple(dur,function()
					if IsValid(self) then self.Reloading=false end
				end)
			end
		end)
	end
end

function SWEP:PreDrawViewModel()
	local vm = self.Owner:GetViewModel()
	if self:GetClass()=="wep_jack_hmcd_ar2" then
		if (self.Owner:KeyDown(IN_ATTACK) and self:Clip1()>0 and self:GetReady()==true and self.SprintingWeapon<10 and not self.FrontallyBlocked and not(self.Owner:KeyDown(IN_USE) and not(self.Owner:GetAmmoCount(self.AltAmmoType)>0))) or self.NextAltFireTime>=CurTime() then
			vm:SetSkin(1)
		else
			vm:SetSkin(0)
		end
	end
	if((self.Scoped and not(self.DetachableScope and !self.DrawnAttachments["Scope"]))and(self.AimPerc>=99))then
		return true
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool",0,"Ready")
	self:NetworkVar("Bool",1,"Reloading")
	self:NetworkVar("Bool",2,"Suiciding")
	self:NetworkVar("Bool",3,"LaserEnabled")
end

function SWEP:AltFire()
	if(CLIENT)then return end
	self.Owner:SetLagCompensated(true)
	local EnergyBall=ents.Create("ent_jack_hmcd_energyball")
	EnergyBall.HmcdSpawned=self.HmcdSpawned
	EnergyBall:SetAngles(VectorRand():Angle())
	local pos=self.Owner:GetShootPos()+self.Owner:GetAimVector()
	EnergyBall:SetPos(pos)
	EnergyBall.Owner=self.Owner
	EnergyBall.Safe=true
	EnergyBall:Spawn()
	EnergyBall:Activate()
	EnergyBall:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector()*700)
	self.Owner:SetLagCompensated(false)	
end

function SWEP:PrimaryAttack()
	self.ReloadInterrupted=true
	if not(self:GetReady())then return end
	if(self.SprintingWeapon>10)then return end
	if self.Reloading then return end
	if IsValid(self.Owner:GetNWEntity("Fake")) then return end
	if self:GetClass()=="wep_jack_hmcd_ar2" and ((self.Owner.KeyDown and self.Owner:KeyDown(IN_USE)) or (self.Owner.Elite and self.NPCAltFireTime<CurTime() and 1==2)) and self.NextAltFireTime<CurTime() then
		if not(self.Owner.Elite) then
			if not(self.Owner:GetAmmoCount(self.AltAmmoType)>0)then
				self:EmitSound("snd_jack_hmcd_click.wav",55,100)
				self:SetNextPrimaryFire(CurTime()+0.1)
				return
			end
			self.Owner:RemoveAmmo(1,self.AltAmmoType)
			self:DoBFSAnimation("shake")
			ParticleEffectAttach("precharge_fire",PATTACH_POINT_FOLLOW,self.Owner:GetViewModel(),1)
		else
			self.NPCAltFireTime=CurTime()+math.random(30,60)
		end
		self.NextAltFireTime=CurTime()+2
		self:EmitSound("weapons/hmcd_ar2/ar2_charge.wav",55,100)
		timer.Simple(0.75,function()
			if IsValid(self) then
				self:DoBFSAnimation("IR_fire2")
				self:EmitSound("weapons/hmcd_ar2/ar2_secondary_fire.wav",55,100)
			end
		end)
		timer.Simple(1.5,function()
			if IsValid(self) then
				self.Owner:EmitSound("weapons/hmcd_ar2/ar2_boltpull.wav",55,100)
			end
		end)
		timer.Simple(0.8,function()
			if IsValid(self) then
				self:AltFire()
				self.Owner:SetAnimation(PLAYER_ATTACK1)
			end
		end)
		return
	end
	if self.NextAltFireTime and self.NextAltFireTime>CurTime() then return end
	if not(IsFirstTimePredicted() or self.Primary.Automatic)then
		if((self:Clip1()==1)and(self.LastFireAnim))then
			if not(self.AimPerc>99) or not(self.LastIronFireAnim) then
				self:DoBFSAnimation(self.LastFireAnim)
			else
				self:DoBFSAnimation(self.LastIronFireAnim)
			end
		elseif(self:Clip1()==2)and(self.MidEmptyFireAnim)then
			if not(self.AimPerc>99) or not(self.MidEmptyIronFireAnim) then
				self:DoBFSAnimation(self.MidEmptyFireAnim)
			else
				self:DoBFSAnimation(self.MidEmptyIronFireAnim)
			end
		elseif(self:Clip1()>0)then
			if not(self.AimPerc>99) or not(self.IronFireAnim) then
				self:DoBFSAnimation(self.FireAnim)
			else
				self:DoBFSAnimation(self.IronFireAnim)
			end
		end
		if self.CockAnim and self.CockAnimDelay then
			timer.Simple(self.CockAnimDelay,function()
				if self and self.Owner and self.Owner:GetActiveWeapon()==self then
					if not(self.AimPerc>99) or not(self.IronCockAnim) then
						self:DoBFSAnimation(self.CockAnim)
					else
						self:DoBFSAnimation(self.IronCockAnim)
					end
				end
			end)
		end
		return
	end
	if SERVER and self.Owner:GetNWString("Class")=="cp" and (self:Clip1()==1 or self:Clip1()==math.Round(self.Primary.ClipSize/4)) and (not(self.Owner.NextTaunt) or self.Owner.NextTaunt<CurTime()) then
		local seen=false
		for i,ply in pairs(player.GetAll()) do
			if ply:Alive() and ply!=self.Owner and ply:GetNWString("Class")=="cp" and ply:Visible(self.Owner) then seen=true break end
		end
		if seen then
			local snd="npc/metropolice/vo/backmeupimout.wav"
			if self:Clip1()>1 then snd="npc/metropolice/vo/runninglowonverdicts.wav" end
			self.Owner.tauntsound=snd
			self.Owner:EmitSound(snd)
			self.Owner.NextTaunt=CurTime()+SoundDuration(snd)
			local BeepTime=SoundDuration(snd)
			self.Owner.NextTaunt=CurTime()+BeepTime
			if self.Owner.Role=="combine" then
				self.Owner:EmitSound("npc/metropolice/vo/on"..math.random(1,2)..".wav")
				local owner=self.Owner
				timer.Simple(BeepTime,function()
					if IsValid(owner) and owner:Alive() then
						owner:EmitSound("npc/metropolice/vo/off"..math.random(1,4)..".wav")
					end
				end)
			end
		end
	end
	self.CurrentDamage=self.Damage
	self.LastFire=CurTime()
	if not(self:Clip1()>0) then
		local canClick=true
		if self.NextFireTime then
			if self.NextFireTime<CurTime() then
				canClick=true
				self.NextFireTime = CurTime() + 0.5
			else
				canClick=false
			end
		end
		if canClick then
			self:EmitSound(self.DryFireSound or "snd_jack_hmcd_click.wav",55,100)
		end
		if(CLIENT)then
			self.Owner.AmmoShow=CurTime()+2
		end
		return
	end
	local suppressed=self:GetNWBool("Suppressor")
	local WaterMul=1
	local Hippy=self.HipFireInaccuracy
	if(self.Owner:WaterLevel()>=3)then WaterMul=.5 end
	local dmgAmt,InAcc=self.Damage*WaterMul,(1-self.Accuracy)
	if not(self.AimPerc>99 or (self:GetNWBool("Laser") and self:GetLaserEnabled()) or self.BipodAmt>99 or self.Owner:IsNPC())then InAcc=InAcc+Hippy end
	local ang=self.Owner:GetAimVector():Angle()
	local dirMul=1
	if self.ViewModelFlip then dirMul=-1 end
	local Right,Up,Forward=ang:Right(),ang:Up(),ang:Forward()
	ang:RotateAroundAxis(Right,self.SprintAng.p*self.FrontBlockedPerc)
	ang:RotateAroundAxis(Up,self.SprintAng.y*self.FrontBlockedPerc*dirMul)
	ang:RotateAroundAxis(Forward,self.SprintAng.r*self.FrontBlockedPerc*dirMul)
	local BulletTraj=(ang:Forward()+VectorRand()*InAcc):GetNormalized()
	local bullet = {}
	bullet.Num = self.NumProjectiles
	if self.BipodAmt==100 then
		local offset=self.BipodAimOffset
		local bipodPos,bipodAng=self:GetNWVector("BipodPos")+Vector(0,0,self.BipodOffset),self.Owner:EyeAngles()
		bullet.Src=bipodPos+bipodAng:Forward()*offset[1]+bipodAng:Right()*offset[2]+bipodAng:Up()*offset[3]
		bullet.Dir = BulletTraj
	elseif self.SuicideAmt==0 then
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = BulletTraj
	else
		local posHand=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		local posHead=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_Head1"))
		bullet.Src=posHand+(posHead-posHand):GetNormalized()*5
		bullet.Dir=(posHead-posHand):GetNormalized()
		if self.SuicideAmt>90 then
			local bloodColor=self.Owner:GetBloodColor()
			local effect
			if bloodColor==BLOOD_COLOR_RED then
				local tr=util.QuickTrace(bullet.Src,bullet.Dir*100,{self.Owner})
				util.Decal("Blood",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
				effect="BloodImpact"
			elseif bloodColor==BLOOD_COLOR_MECH then
				effect="ManhackSparks"
			end
			if effect then
				local edata = EffectData()
				edata:SetStart(posHead)
				edata:SetOrigin(posHead)
				edata:SetNormal(posHead)
				edata:SetEntity(self.Owner)
				util.Effect(effect,edata,true,true)
			end
			if SERVER and self.Owner.Role!="terminator" then
				self.Owner.LastHitLocation=HITGROUP_HEAD
				local dmginfo=DamageInfo()
				dmginfo:SetDamage(self.Damage*self.NumProjectiles)
				dmginfo:SetDamagePosition(posHead)
				dmginfo:SetDamageType(DMG_BULLET)
				dmginfo:SetAttacker(self.Owner)
				dmginfo:SetInflictor(self)
				GAMEMODE:ScalePlayerDamage(self.Owner,HITGROUP_HEAD,dmginfo)
				self.Owner:TakeDamageInfo(dmginfo)
			end
		end
	end
	--local vm = self.Owner:GetViewModel()
	--bullet.Dir = (vm:GetAngles():Forward()*self.BulletDir[1]+vm:GetAngles():Right()*self.BulletDir[2]+vm:GetAngles():Up()*self.BulletDir[3]+VectorRand()*InAcc):GetNormalized()
	bullet.Spread = Vector(self.Spread,self.Spread,0)
	bullet.Tracer = 0
	bullet.Force = dmgAmt/10
	bullet.Damage = dmgAmt
	if self.AltPrimaryFire then
		self:AltPrimaryFire()
	else
		self.Owner:FireBullets(bullet)
		if self.ShellDelay>0 then
			timer.Simple(self.ShellDelay,function()
				if IsValid(self)then
					self:Shell()
				end
			end)
		else
			self:Shell()
		end
	end
	if(self.Supersonic)then
		self:BallisticSnap(BulletTraj)
	end
	if((self:Clip1()==1)and(self.LastFireAnim))then
		if not(self.AimPerc>99) or not(self.LastIronFireAnim) then
			self:DoBFSAnimation(self.LastFireAnim)
		else
			self:DoBFSAnimation(self.LastIronFireAnim)
		end
	elseif(self:Clip1()==2)and(self.MidEmptyFireAnim)then
			if not(self.AimPerc>99) or not(self.MidEmptyIronFireAnim) then
				self:DoBFSAnimation(self.MidEmptyFireAnim)
			else
				self:DoBFSAnimation(self.MidEmptyIronFireAnim)
			end
	elseif(self:Clip1()>0)then
		if not(self.AimPerc>99) or not(self.IronFireAnim) then
			self:DoBFSAnimation(self.FireAnim)
		else
			self:DoBFSAnimation(self.IronFireAnim)
		end
	end
	if self.CockAnim and self.CockAnimDelay then
		timer.Simple(self.CockAnimDelay,function()
			if self.Owner:GetActiveWeapon()==self then
				if not(self.AimPerc>99) or not(self.IronCockAnim) then
					self:DoBFSAnimation(self.CockAnim)
				else
					self:DoBFSAnimation(self.IronCockAnim)
				end
			end
		end)
	end
	if(self.FireAnimRate and self.Owner.GetViewModel)then 
		self.Owner:GetViewModel():SetPlaybackRate(self.FireAnimRate) 
		if self:GetClass()=="wep_jack_hmcd_combinesniper" then
			timer.Simple(.015,function() 
				if IsValid(self) then
					self.Owner:GetViewModel():SetPlaybackRate(1) 
				end
			end)
		end
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	local Pitch=self.ShotPitch*math.Rand(.9,1.1)
	if self:GetClass()=="wep_jack_hmcd_taser" then Pitch=100 end
	if(SERVER)then
		local Dist=75
		if suppressed and self.SuppressedFireSound then 
			self.Owner:EmitSound(self.SuppressedFireSound)
		else
			local closeSnd=self.CloseFireSound
			if istable(closeSnd) then closeSnd=table.Random(closeSnd) end
			self.Owner:EmitSound(closeSnd,Dist,Pitch)
			self.Owner:EmitSound(self.FarFireSound,Dist*2,Pitch)
			if(self.ExtraFireSound)then sound.Play(self.ExtraFireSound,self.Owner:GetShootPos()+VectorRand(),Dist-5,Pitch) end
		end
		if(self.CycleType=="manual")then
			timer.Simple(.1,function()
				if((IsValid(self))and(IsValid(self.Owner)))then
					self:EmitSound(self.CycleSound,55,100)
				end
			end)
		end
	end
	if self.MuzzleEffect!="" then
		local eff=self.MuzzleEffect
		if suppressed then eff=self.MuzzleEffectSuppressed end
		local isFirstPerson
		if CLIENT then
			local spectatee=LocalPlayer()
			if IsValid(GAMEMODE.Spectatee) then spectatee=GAMEMODE.Spectatee end
			if self.Owner==spectatee and GetViewEntity()==spectatee and not(self.Owner:ShouldDrawLocalPlayer()) then isFirstPerson=true end
		end
		if isFirstPerson then
			local info=self.MuzzleInfo
			if info then
				local vm=self.Owner:GetViewModel()
				local pos,ang=vm:GetBonePosition(vm:LookupBone(info.Bone))
				if info.reverseangle then ang.r=-ang.r end
				ParticleEffect(eff,pos+ang:Forward()*info.Offset[1]+ang:Right()*info.Offset[2]+ang:Up()*info.Offset[3],self.Owner:EyeAngles(),self)
			end
		else
			local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
			local position=pos+ang:Forward()*self.MuzzlePos[1]+ang:Up()*self.MuzzlePos[2]+ang:Right()*self.MuzzlePos[3]
			if suppressed then position=position+ang:Forward()*6 end
			ParticleEffect(eff,position,ang,self)
		end
	end
	self.BarrelMustSmoke=true
	local Ang,Rec=self.Owner:EyeAngles(),self.Recoil
	if self:GetNWBool("Suppressor") then Rec=Rec*.5 end
	if recoilControlByRole[self.Owner.Role] then Rec=Rec*recoilControlByRole[self.Owner.Role] end
	if self.Owner.Role=="jesus" then Rec=Rec*.25 end
	if not(self.Owner:IsOnGround()) then Rec=Rec*2 end
	if self.BipodAmt==100 then Rec=Rec*(self.BipodRecoilMul or .4) end
	if Rec>=5 then
		if SERVER and self.Owner.CreateFake then
			self.Owner.lastRagdollEndTime=nil
			self:TakePrimaryAmmo(1)
			self.Owner:CreateFake()
			self.Owner.fakeragdoll:GetPhysicsObject():SetVelocity(-self.Owner:GetAimVector()*1000)
			return
		end
	else
		local RecoilY=math.Rand(.015,.03)*Rec
		local RecoilX=math.Rand(-.03,.05)*Rec
		if self.Owner:EyeAngles().p<=-87 then RecoilY=0 end
		if (SERVER and game.SinglePlayer() or CLIENT) then
			local newAng=(Ang:Forward()+RecoilY*Ang:Up()+Ang:Right()*RecoilX):Angle()
			if math.abs(self.Owner:EyeAngles().y-newAng.y)>10 then newAng.y=self.Owner:EyeAngles().y end
			self.Owner:SetEyeAngles(newAng)
		end
		if not(self.Owner:OnGround()) then self.Owner:SetVelocity(-self.Owner:GetAimVector()*10) end
		if self.Owner:IsPlayer() then
			self.Owner:ViewPunchReset()
			self.Owner:ViewPunch(Angle(RecoilY*-100*math.min(Rec,2),RecoilX*-100*math.min(Rec,2),0))
		else
			if not(self.BurstFire) then
				self.BurstFire=true
				local rand=math.random(1,6)
				for i=1,rand do
					timer.Simple(self.TriggerDelay*i*2,function()
						if IsValid(self) and self.Owner!=NULL and self:GetNextPrimaryFire()<=CurTime() and not(self.Reloading) then
							self:SetAnimation(PLAYER_ATTACK1)
							self:PrimaryAttack()
							if i==rand then self.BurstFire=nil end
						end
					end)
				end
			end
			if not(self.RoundsInMag) then self.RoundsInMag=self:Clip1() end
			self.RoundsInMag=self.RoundsInMag-1
		end
	end
	self:TakePrimaryAmmo(1)
	local Extra=0
	if(self.Owner:WaterLevel()>=3)then Extra=1 end
	self:SetNextPrimaryFire(CurTime()+self.TriggerDelay+self.CycleTime+Extra)
end

function SWEP:BarrelSmoke()
	local ent=self.Owner:GetViewModel()
	local ent2 = self.WorldModel
	if(ent)then ParticleEffectAttach(self.SmokeEffect,PATTACH_POINT_FOLLOW,ent,1) end
	--if(ent2)then ParticleEffectAttach("pcf_jack_mf_barrelsmoke",PATTACH_POINT_FOLLOW,ent2,"muzzle_flash") end
end

function SWEP:SecondaryAttack()
	
end

local nextBipodCheck=0

function SWEP:Think()
	local Time=CurTime()
	self:EnforceFrontBlock()
	if self:GetClass()=="wep_jack_hmcd_m249" and SERVER then
		local vm=self.Owner:GetViewModel()
		local curBodygroup=vm:GetBodygroup(1)
		if self:Clip1()<17 and not(self.NextReload) and curBodygroup!=self:Clip1() then
			vm:SetBodygroup(1,self:Clip1())
		end
		if self:Clip1()>16 and not(self.NextReload) and curBodygroup!=16 then
			vm:SetBodygroup(1,16)
		end
	end
	if(self.BarrelMustSmoke)then
		if(math.random(1,25)==4)then self:BarrelSmoke();self.BarrelMustSmoke=false end
	end
	if nextBipodCheck<Time then
		nextBipodCheck=Time+0.1
		if self.BipodEntity then
			if not(IsValid(self.BipodEntity)) then
				self:ToggleBipods() 
			else
				local entFound=false
				for i,ent in pairs(ents.FindInSphere(self.BipodPos,25)) do
					if ent==self.BipodEntity then entFound=true break end
				end
				if not(entFound) then self:ToggleBipods() end
			end
		end
		if self.BipodPos then
			if(math.abs(self.BipodPos.z-self.Owner:EyePos().z))>25 then
				self:ToggleBipods()
			end
		end
	end
	if(SERVER)then
		if self.NextReload and self.NextReload<Time then
			self.NextReload=nil
			if((IsValid(self))and(IsValid(self.Owner)))then
				if self.SetRocketGone then
					self:SetRocketGone(false)
					if IsValid(self.Owner.FakeWep) then
						self.Owner.FakeWep:SetBodygroup(1,0)
					end
				end
				self:SetReady(true)
				local Missing,Have=self.Primary.ClipSize-self:Clip1(),self.Owner:GetAmmoCount(self.AmmoType)
				if(Missing<=Have)then
					if self:Clip1()<=0 and not(self.NoBulletInChamber) then
						self.Owner:RemoveAmmo(Missing-1,self.AmmoType)
						self:SetClip1(self.Primary.ClipSize-1)
					else
						self.Owner:RemoveAmmo(Missing,self.AmmoType)
						self:SetClip1(self.Primary.ClipSize)
					end
				elseif(Missing>Have)then
					self:SetClip1(self:Clip1()+Have)
					self.Owner:RemoveAmmo(Have,self.AmmoType)
				end
				if IsValid(self.Owner.FakeWep) then self.Owner.FakeWep.RoundsInMag=self:Clip1() self.Owner.FakeWep.Reloading=false end
			end
		end
		if((self.ReloadType=="individual")and(self:GetReloading()))then
			if(self.VReloadTime<Time)then
				if((self:Clip1()<self.Primary.ClipSize)and(self.Owner:GetAmmoCount(self.AmmoType)>0)and not(self.ReloadInterrupted))then
					self:SetClip1(self:Clip1()+1)
					self.Owner:RemoveAmmo(1,self.AmmoType)
					self:StallAnimation(self.StallAnim, self.StallTime)
					timer.Simple(.01,function() self:ReadyAfterAnim(self.LoadAnim) end)
					if self.ReloadSoundDelay then
						timer.Simple(self.ReloadSoundDelay,function()
							if IsValid(self) then
								sound.Play(self.ReloadSound,self.Owner:GetShootPos(),55,100)
							end
						end)
					else
						sound.Play(self.ReloadSound,self.Owner:GetShootPos(),55,100)
					end
				else
					self:SetReloading(false)
					self:ReadyAfterAnim(self.LoadFinishAnim)
					timer.Simple(.25,function()
						if((IsValid(self))and(IsValid(self.Owner))) and self.CycleSound and not(self.NoCocking) then self:EmitSound(self.CycleSound,55,90) end
					end)
					timer.Simple(self.LoadFinishTime or .5,function()
						if((IsValid(self))and(IsValid(self.Owner)))then 
							self:SetReady(true)
							if IsValid(self.Owner.FakeWep) then self.Owner.FakeWep.RoundsInMag=self:Clip1() self.Owner.FakeWep.Reloading=false end
						end
					end)
				end
			end
		end
		local HoldType=self.HipHoldType
		if(self.Owner:KeyDown(IN_SPEED)) or self:GetSuiciding() or self.FrontBlockedPerc>0.1 then
			HoldType=self.DownHoldType
		elseif((self.AimPerc>50)and not(self.Owner:Crouching()))then
			HoldType=self.AimHoldType
		else
			HoldType=self.HipHoldType
		end
		self:SetHoldType(HoldType)
	end
	
	local InAttack,InSpeed=self.InAttack or self.Owner:KeyDown(IN_ATTACK2),self.InSprint or self.Owner:KeyDown(IN_SPEED)
	
	local ready=self:GetReady()
	local AimPerc = self.AimPerc
	local Reloading,Sprinting,Blocked = self.Reloading,self.SprintingWeapon,tobool(self.FrontBlocked or 0)
	local AimChanged = IsChanged( InAttack, "aimin", self ) and (not(self.NextAimChange) or self.NextAimChange<Time)
	local SprintChanged = IsChanged( InSpeed, "sprint", self ) and (not(self.NextSprintChange) or self.NextSprintChange<Time) or IsChanged( self:GetReady(), "ready", self )
	local BlockedChanged = IsChanged( Blocked, "frontblocked", self )
	local DeployTimeChanged = ( self.DeployTime~=nil and IsChanged( self.DeployTime<=Time, "deploy", self ) )
	local Cycling = self.Cycling or false
	local GroundChanged=IsChanged( self.Owner:OnGround(), "grounded", self )
	self.changed=GroundChanged or BlockedChanged or DeployTimeChanged or IsChanged( self.Reloading, "reload", self ) or IsChanged( Cycling, "cycling", self )
			
	if(AimChanged or SprintChanged or self.changed)then --Long as duck
		if AimChanged or GroundChanged or BlockedChanged then self.NextAimChange=Time+0.2 self.AimStartTime=Time end
		if SprintChanged then self.NextSprintChange=Time+0.2 self.SprintStartTime=Time self.AimStartTime=Time end
		self.SprintOnChange=self.SprintingWeapon or 0
		self.AimingOnChange=self.AimPerc or 0
		self.changed=false
	end
	
	self.changed=IsChanged( self:GetSuiciding(), "suiciding", self )
	
	if self.changed then
		self.SuicideStartTime=Time
		self.SuicideOnChange=self.SuicideAmt or 0
		self.changed=false
	end
	
	local bipodPos=self:GetNWVector("BipodPos")
	
	if IsChanged( bipodPos, "bipod", self ) then
		self.BipodStartTime=Time
		self.BipodOnChange=self.BipodAmt or 0
		if bipodPos!=Vector() then
			self.BipodAngle=self.Owner:EyeAngles()
		else
			self.BipodAngle=nil
		end
	end
	
	local Suiciding=self:GetSuiciding()
	local AimDiff=Time-self.AimStartTime
	if AimDiff>0 then
		if(InAttack and !Reloading and !Blocked and !Cycling and !Suiciding and Sprinting<100 and !InSpeed and self.Owner:OnGround())then
			if not(AimPerc>=100)then
				self.AimPerc=math.Clamp(AimDiff*self.AimAddMul,0,100)	
			end
		elseif not(AimPerc<=0)then
			self.AimPerc=math.Clamp(self.AimingOnChange-AimDiff*self.AimAddMul,0,100)
		end
	end
	
	local SprintDiff=Time-self.SprintStartTime
	if SprintDiff>0 then
		if(InSpeed and not(Reloading or Cycling or Suiciding) and ready)then
			if(Sprinting~=100)then
				local diff=SprintDiff
				if self.FrontBlockedPerc and self.FrontBlockedPerc>diff then diff=self.FrontBlockedPerc end
				self.SprintingWeapon=math.Clamp(diff*self.SprintAddMul,0,100)
			end
		elseif(Sprinting~=0)then
			self.SprintingWeapon=math.Clamp(self.SprintOnChange-SprintDiff*self.SprintAddMul,0,100)
		end
	end
	
	local SuicideDiff=Time-self.SuicideStartTime
	if Suiciding then
		local mul=self.SuicideAddMul
		if self.Owner:GetNWBool("GhostSuiciding") then mul=mul*.1 end
		self.SuicideAmt=math.Clamp(SuicideDiff*mul,0,100)
	else
		self.SuicideAmt=math.Clamp(self.SuicideOnChange-SuicideDiff*self.SuicideAddMul,0,100)
	end
	
	if self.BipodUsable then
		local BipodDiff=Time-self.BipodStartTime
		if bipodPos!=Vector() then
			self.BipodAmt=math.Clamp(BipodDiff*150,0,100)
		else
			self.BipodAmt=0
		end
	end
end

local reloadSpeedByRole={
	["russian"]=0.8,
	["ukrainian"]=0.8,
	["combine"]=0.5,
	["freeman"]=0.5,
	["jesus"]=0.25,
	["terminator"]=0.5
}

function SWEP:Reload()
	self.ReloadInterrupted=false
	if not(IsFirstTimePredicted())then return end
	if not((IsValid(self))and(IsValid(self.Owner)))then return end
	if not(self:GetReady())then return end
	if(self.SprintingWeapon>0)then return end
	if self.SuicideAmt>0 then return end
	if self.Owner.Unconscious then return end
	if(CLIENT)then
		self.Owner.AmmoShow=CurTime()+2
	end
	if((self:Clip1()<self.Primary.ClipSize)and(self.Owner:GetAmmoCount(self.AmmoType)>0))then
		local TacticalReload=self:Clip1()>0
		if self:GetClass()=="wep_jack_hmcd_dbarrel" then TacticalReload=(self:Clip1()>=1 or self.Owner:GetAmmoCount("Buckshot")==1) end
		self:SetReady(false)
		self.Owner:SetAnimation(PLAYER_RELOAD)
		local Mul=reloadSpeedByRole[self.Owner.Role] or 1
		local ReloadAdd=0
		local reloadTime
		if isfunction(self.ReloadTime) then
			reloadTime=self:ReloadTime()
		else
			reloadTime=self.ReloadTime
		end
		if not(TacticalReload) then ReloadAdd=self.ReloadAdd end
		local ReloadTime=(reloadTime+ReloadAdd)*Mul
		if self:GetClass()=="wep_jack_hmcd_revolver" then
			timer.Simple(self.MagDelay,function()
				if IsValid(self)then
					self:ShellReload(self.Primary.ClipSize-self:Clip1())
				end
			end)
		elseif self:GetClass()=="wep_jack_hmcd_dbarrel" then
			timer.Simple(self.MagDelay,function()
				if IsValid(self)then
					local amt = 1
					if not(TacticalReload) then amt=2 end
					self:ShellReload(amt)	
				end
			end)
		elseif self.ShellEffectReload then
			timer.Simple(self.MagDelay*Mul,function()
				if IsValid(self) then
					self:ShellReload()
				end
			end)
		end
		if (self:Clip1()<2 or self:GetClass()=="wep_jack_hmcd_rifle") and self.MagEntity then
			if(SERVER)then
				timer.Simple(self.MagDelay*Mul,function()
					local Mag=ents.Create(self.MagEntity)
					Mag.HmcdSpawned=self.HmcdSpawned
					Mag:SetAngles(VectorRand():Angle())
					if IsValid(self.Owner.fakeragdoll) then
						Mag:SetPos(self.Owner.fakeragdoll:GetBonePosition(self.Owner.fakeragdoll:LookupBone("ValveBiped.Bip01_R_Hand")))
					else
						Mag:SetPos(self.Owner:GetShootPos()+self.Owner:GetForward()*self.MagPos[1]+self.Owner:GetUp()*self.MagPos[2]+self.Owner:GetRight()*self.MagPos[3])
					end
					Mag.Owner=self.Owner
					Mag:Spawn()
					Mag:Activate()
				end)
			end
		end
		if(SERVER)then
			if IsValid(self.Owner.FakeWep) then self.Owner.FakeWep.Reloading=true end
			local reloadSounds=self.ReloadSounds
			if reloadSounds then
				if isfunction(reloadSounds) then reloadSounds=reloadSounds(self) end
				for i,sndinfo in pairs(reloadSounds) do
					timer.Simple(sndinfo[2]*Mul,function()
						if IsValid(self) and self.NextReload and self.Owner:GetActiveWeapon()==self and (sndinfo[3]=="Both" or (sndinfo[3]=="EmptyOnly" and not(TacticalReload)) or (sndinfo[3]=="FullOnly" and (TacticalReload))) then
							self.Weapon:EmitSound(sndinfo[1],65,100)
							if sndinfo[4] then sndinfo[4](self) end
						end
					end)
				end
			end
			if self:GetClass()=="wep_jack_hmcd_crossbow" then
				timer.Simple(3.2*Mul,function()
					if IsValid(self) then
						self.Owner:GetViewModel():SetSkin(1)
					end
				end)
			end
		end
		if self.ReloadType=="clip" or self.ReloadType=="magazine" then
			if self.GetReloadAnim then
				self:DoBFSAnimation(self:GetReloadAnim())
			elseif self:Clip1()==1 and self.MidEmptyReloadAnim then
				self:DoBFSAnimation(self.MidEmptyReloadAnim)
			elseif TacticalReload and self.TacticalReloadAnim then
				self:DoBFSAnimation(self.TacticalReloadAnim)
			elseif self.BipodAmt>99 and self.BipodReloadAnim then
				self:DoBFSAnimation(self.BipodReloadAnim)
			else
				self:DoBFSAnimation(self.ReloadAnim)
			end
			self.Owner:GetViewModel():SetPlaybackRate(self.ReloadRate/Mul)
			self.Weapon:EmitSound(self.ReloadSound,65,100)
			if(SERVER)then
				self.NextReload=CurTime()+ReloadTime
			end
		elseif(self.ReloadType=="individual")then
			self:SetReloading(true)
			self:ReadyAfterAnim(self.StartReloadAnim,self.StartReloadRate)
		end
	end
end

function SWEP:ReadyAfterAnim(anim,rate)
	self:DoBFSAnimation(anim)
	local mul=1/(reloadSpeedByRole[self.Owner.Role] or 1)*(rate or 1)
	local reloadRate=self.ReloadRate*mul
	self.Owner:GetViewModel():SetPlaybackRate(reloadRate)
	local Time=(self.Owner:GetViewModel():SequenceDuration()/reloadRate)+.01
	self.VReloadTime=CurTime()+Time
end

function SWEP:Deploy()
	self.AimPerc=0
	self.SprintingWeapon=0
	self.SuicideAmt=0
	self.BipodAmt=0
	self:SetSuiciding(false)
	if self.Bodygroups and SERVER then 
		local vm=self.Owner:GetViewModel()
		for i,bgroup in pairs(self.Bodygroups) do
			self.PreviousBodygroups[i]=vm:GetBodygroup(i)
			vm:SetBodygroup(i,bgroup)
		end
	end
	if self.Owner.GetViewModel and IsValid(self.Owner:GetViewModel()) then
		self.Owner:GetViewModel():SetSkin(0)
	end
	if self.Owner.DamagedArms and self.HolsterSlot==1 then self.Owner:HMCDDropWeapon(self) end
	if((IsValid(self))and(IsValid(self.Owner)))then
		if not(IsFirstTimePredicted())then
			self:DoBFSAnimation(self.DrawAnim)
			self.Owner:GetViewModel():SetPlaybackRate(.1)
			return
		end
		if self:Clip1()>0 then
			self:DoBFSAnimation(self.DrawAnim)
			if self:GetClass()=="wep_jack_hmcd_crossbow" then self.Owner:GetViewModel():SetSkin(1) end
		elseif self.DrawAnimEmpty then
			self:DoBFSAnimation(self.DrawAnimEmpty)
			if self:GetClass()=="wep_jack_hmcd_crossbow" then self.Owner:GetViewModel():SetSkin(0) end
		end
		if self.Owner.GetViewModel then self.Owner:GetViewModel():SetPlaybackRate(self.DrawRate) end
		self:SetReady(false)
		if not(self.SilentDeploy) then
			self:EmitSound("snd_jack_hmcd_pistoldraw.wav",self.DeployVolume or 70,self.HandlingPitch)
		end
		self:EnforceHolsterRules(self)
		timer.Simple(1.5,function() if(IsValid(self))then self:SetReady(true) end end)
		return true
	end
end

function SWEP:EnforceHolsterRules(newWep)
	self.NextReload=nil
	if(CLIENT)then return end
	if not(newWep==self)then return end -- only enforce rules for us
	if self.Owner.InfiniteWepSlot then return end
	local holsterSlotCounter=1
	local maxAllowed=1
	if self.Owner.Role=="freeman" then maxAllowed=2 end
	for key,wep in pairs(self.Owner:GetWeapons())do
		if((wep.HolsterSlot)and(self.HolsterSlot)and(wep.HolsterSlot==self.HolsterSlot)and not(wep==self))then -- conflict
			holsterSlotCounter=holsterSlotCounter+1
			if holsterSlotCounter>maxAllowed then
				self.Owner:HMCDDropWeapon(wep)
			end
		end
	end
end

function SWEP:StallAnimation(anim,time)
	self:DoBFSAnimation(anim)
	self.VReloadTime=self.VReloadTime+.1
	self.Owner:GetViewModel():SetPlaybackRate(.1)
end

function SWEP:DoBFSAnimation(anim)
	if((self.Owner)and(self.Owner.GetViewModel)) then
		local vm=self.Owner:GetViewModel()
		if istable(anim) then anim=table.Random(anim) end
		vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
	end
end

function SWEP:Holster(newWep)
	if self.Owner:GetNWBool("GhostSuiciding") then return false end
	if self:GetClass()=="wep_jack_hmcd_ar2" then
		if self.Owner.GetViewModel and IsValid(self.Owner:GetViewModel())then
			self.Owner:GetViewModel():SetSkin(0)
		end
	end
	for i,bgroup in pairs(self.PreviousBodygroups) do
		if IsValid(self.Owner:GetViewModel()) then
			self.Owner:GetViewModel():SetBodygroup(i,bgroup)
		end
	end
	self:SetNWVector("BipodPos",Vector())
	self.BipodPos=nil
	self.BipodEntity=nil
	self.PreviousBodygroups={}
	self:EnforceHolsterRules(newWep)
	self:CleanLaser()
	self:SetReloading(false)
	self:SetReady(false)
	if self:GetSuiciding() then
		self.Owner:SetDSP(0)
	end
	return true
end

function SWEP:OnRemove()
	self:CleanLaser()
end

function SWEP:OnRestore()
end

function SWEP:Precache()
end

function SWEP:OwnerChanged()
	if not(self.FirstOwner) then self.FirstOwner=self.Owner end
end

SWEP.BlockOnChange=0
SWEP.FrontBlockTime=0

function SWEP:EnforceFrontBlock()
	local ShootVec,Ang,ShootPos=self.Owner:GetAimVector(),self.Owner:GetAngles(),self.Owner:GetShootPos()
	local OverallLength = self.BarrelLength
	if self:GetNWBool("Suppressor") then OverallLength=OverallLength+3 end
	ShootPos=ShootPos+ShootVec*15
	local trace = util.TraceLine({
		start=ShootPos-Ang:Forward()*5,
		endpos=ShootPos+(ShootVec*(OverallLength))+Ang:Forward()*15,
		filter=self.Owner
	})
	if trace.Hit and self.BipodAmt<1 then
		if trace.StartSolid then trace.Fraction=0 end
		if self.FrontBlocked==0 then self.FrontBlockTime=CurTime() end
		self.FrontBlocked=1
		self.FrontBlockedPerc=math.Clamp((CurTime()-self.FrontBlockTime)*self.SprintAddMul/100,0,1-trace.Fraction)
	else
		if self.FrontBlocked==1 then self.FrontBlockTime=CurTime() self.BlockOnChange=self.FrontBlockedPerc end
		self.FrontBlocked=0
		self.FrontBlockedPerc=math.Clamp(self.BlockOnChange-(CurTime()-self.FrontBlockTime)*self.SprintAddMul/100,0,1)
	end
end

function SWEP:HMCDOnDrop()
	if self:GetSuiciding() and IsValid(self.LastOwner) then
		self.LastOwner:SetDSP(0)
	end
	self.NextReload=nil
	local Ent=ents.Create(self.ENT)
	Ent.HmcdSpawned=self.HmcdSpawned
	Ent:SetPos(self:GetPos())
	Ent:SetAngles(self:GetAngles())
	if self.Attachments and self.Attachments["Owner"] then
		for attachment,info in pairs(self.Attachments["Owner"]) do
			Ent:SetNWBool(attachment,self:GetNWBool(attachment))
		end
	end
	if self.GetLaserEnabled and Ent.SetLaserEnabled then Ent:SetLaserEnabled(self:GetLaserEnabled()) end
	Ent:Spawn()
	Ent:Activate()
	Ent.DrumBullets=self.DrumBullets
	Ent.DrumPos=self.DrumPos
	Ent.RoundsInMag=self.RoundsInMag or self:Clip1()
	Ent:GetPhysicsObject():SetVelocity(self:GetVelocity()/2)
	self:Remove()
end

function SWEP:BallisticSnap(traj)
	if(CLIENT)then return end
	if not(self.Supersonic)then return end
	if(self.NumProjectiles>1)then return end
	local Src=self.Owner:GetShootPos()
	local TrDat={
		start=Src,
		endpos=Src+traj*20000,
		filter={self.Owner}
	}
	local Tr,EndPos=util.TraceLine(TrDat),Src+traj*20000
	if((Tr.Hit)or(Tr.HitSky))then
		EndPos=Tr.HitPos
	end
	local Dist=(EndPos-Src):Length()
	if(Dist>1000)then
		for i=1,math.floor(Dist/500)do
			local SoundSrc=Src+traj*i*500
			for key,ply in pairs(player.GetAll())do
				if not(ply==self.Owner)then
					local PlyPos=ply:GetPos()
					if((PlyPos-SoundSrc):Length()<1000)then
						local Snd="snd_jack_hmcd_bc_"..math.random(1,7)..".wav"
						local Pitch=math.random(90,110)
						sound.Play(Snd,ply:GetShootPos(),50,Pitch)
					end
				end
			end
		end
	end
end

function SWEP:ToggleBipodAnims(toggle)
	if toggle==nil then
		toggle=self:GetNWVector("BipodPos")!=vector_origin
	end
	if toggle then
		if self.BipodFireAnim then
			local temp=self.BipodFireAnim
			self.BipodFireAnim=self.FireAnim
			self.FireAnim=temp
		end
		if self.BipodIronFireAnim then
			local temp=self.BipodIronFireAnim
			self.BipodIronFireAnim=self.IronFireAnim
			self.IronFireAnim=temp
		end
		if self.BipodReloadRate then
			local temp=self.BipodReloadRate
			self.BipodReloadRate=self.ReloadRate
			self.ReloadRate=temp
		end
		if self.BipodReloadSounds then
			local temp=self.BipodReloadSounds
			self.BipodReloadSounds=self.ReloadSounds
			self.ReloadSounds=temp
		end
	else
		if self.BipodFireAnim then
			local temp=self.BipodFireAnim
			self.BipodFireAnim=self.FireAnim
			self.FireAnim=temp
		end
		if self.BipodIronFireAnim then
			local temp=self.BipodIronFireAnim
			self.BipodIronFireAnim=self.IronFireAnim
			self.IronFireAnim=temp
		end
		if self.BipodReloadRate then
			local temp=self.BipodReloadRate
			self.BipodReloadRate=self.ReloadRate
			self.ReloadRate=temp
		end
		if self.BipodReloadSounds then
			local temp=self.BipodReloadSounds
			self.BipodReloadSounds=self.ReloadSounds
			self.ReloadSounds=temp
		end
	end
end

if SERVER then -- shithole? yeah it's a shithole
	util.AddNetworkString("hmcd_bipodupdate")
else
	net.Receive("hmcd_bipodupdate",function()
		local wep,bipodOn=net.ReadEntity(),net.ReadBool()
		if not(IsValid(wep)) then return end
		wep:ToggleBipodAnims(bipodOn==true)
	end)
end

function SWEP:ToggleBipods()
	if self.BipodUsable and SERVER then
		if not(self.BipodPos) then
			if (self.NextBipodTime and self.NextBipodTime>CurTime()) or self.FrontBlockedPerc>0.1 then return end
			for i=0.5,1.5,0.25 do
				local tr=util.QuickTrace(self.Owner:GetShootPos(),self.Owner:GetAimVector()*self.BarrelLength*i,{self.Owner})
				if tr.Hit then return end
				tr=util.QuickTrace(tr.HitPos,-vector_up*20,{self.Owner})
				if tr.Hit and self.Owner:GetShootPos().z-tr.HitPos.z<=25 then
					local vec=tr.HitPos
					vec.x=math.Round(vec.x)
					vec.y=math.Round(vec.y)
					vec.z=math.Round(vec.z)
					self:SetNWVector("BipodPos",vec)
					net.Start("hmcd_bipodupdate") -- AAAAAAAAAAAHAHAHAHAAAAAAAAAAAAAAAA
					net.WriteEntity(self)
					net.WriteBool(true)
					net.Send(self.Owner)
					self.BipodStartTime=CurTime()
					self.BipodPos=vec
					if self.NextReload then
						self.NextReload=nil
						self:SetReady(true)
					end
					if IsValid(tr.Entity) then self.BipodEntity=tr.Entity end
					if self.BipodPlaceAnim then
						if not(self.BipodPlaceAnimEmpty and self:Clip1()==0) then
							self:DoBFSAnimation(self.BipodPlaceAnim)
						else
							self:DoBFSAnimation(self.BipodPlaceAnimEmpty)
						end
					end
					self:ToggleBipodAnims()
					if self.BipodDeploySound then
						timer.Simple(self.BipodDeploySound[1],function()
							self.Owner:EmitSound(self.BipodDeploySound[2],55,100)
						end)
					end
					self:SetNextPrimaryFire(CurTime()+1.25)
					break
				end
			end
		else
			self.NextBipodTime=CurTime()+1.75
			self:SetNWVector("BipodPos",Vector())
			net.Start("hmcd_bipodupdate") -- AAAAAAAAAAAHAHAHAHAAAAAAAAAAAAAAAA
			net.WriteEntity(self)
			net.Send(self.Owner)
			self.BipodStartTime=CurTime()
			self.BipodPos=nil
			self.BipodEntity=nil
			if self.NextReload then
				self.NextReload=nil
				self:SetReady(true)
			end
			if self.BipodRemoveAnim then
				if not(self.BipodRemoveAnimEmpty and self:Clip1()==0) then
					self:DoBFSAnimation(self.BipodRemoveAnim)
				else
					self:DoBFSAnimation(self.BipodRemoveAnimEmpty)
				end
			end
			self:ToggleBipodAnims()
			if self.BipodRemoveSound then
				timer.Simple(self.BipodRemoveSound[1],function()
					if IsValid(self) then
						self.Owner:EmitSound(self.BipodRemoveSound[2],55,100)
					end
				end)
			end
			self:SetNextPrimaryFire(CurTime()+1.25)
		end
	end
end

if(CLIENT)then
	local LastAimGotten=0
	local LastSuicideGotten=0
	local LastSprintGotten=0
	local LastBipodGotten=0
	local LastBipodPos=Vector(0,0,0)
	local LastAngGotten=Angle(0,0,0)
	function SWEP:GetViewModelPosition(pos,ang)
		if LocalPlayer()!=self.Owner then self:Think() end
		local FrontBlocked = self.FrontBlocked or 0
		local FrontBlockedPerc = self.FrontBlockedPerc or 0
		local Sprint = math.Clamp(self.SprintingWeapon/100,0,1)
		
		local AimGotten=Lerp(.05,LastAimGotten,self.AimPerc/100)
		LastAimGotten=AimGotten
		local Bipod=Lerp(.05,LastBipodGotten,self.BipodAmt/100)
		LastBipodGotten=Bipod
		local Aim=AimGotten
		local SuicideGotten=Lerp(.05,LastSuicideGotten,self.SuicideAmt/100)
		LastSuicideGotten=SuicideGotten
		local Suicide=SuicideGotten
		local Up,Forward,Right=ang:Up(),ang:Forward(),ang:Right()
		local SprintGotten=Lerp(.05,LastSprintGotten,(self.SprintingWeapon/100)*(1-FrontBlocked*(1-Sprint))+FrontBlockedPerc*(1-Sprint))	
		LastSprintGotten=SprintGotten
		local Sprint=SprintGotten		
		--[[
		local AngGotten=LerpAngle(.05,LastAngGotten or Angle(0,0,0),self:GetAngleWeapon() or Angle(0,0,0))	
		LastAngGotten=AngGotten
		local Ang=AngGotten
	]]
		--local ang=vm:GetAngles()
		if(self.InertiaScale~=0)then
			if(oldAng==nil)then oldAng = ang end
			if(angDiff==nil)then angDiff=Angle(0,0,0) end
			local sensitivity=self.CarryWeight/714*self.InertiaScale
			angDiff = LerpAngle(math.Clamp(FrameTime(),0,1), angDiff, ang - oldAng)
			oldAng = ang
			ang = ang - angDiff * sensitivity
			self.AngleWeapon=ang
		end

		ang:RotateAroundAxis(Right,self.SprintAng.p*Sprint)
		ang:RotateAroundAxis(Up,self.SprintAng.y*Sprint)
		ang:RotateAroundAxis(Forward,self.SprintAng.r*Sprint)
		
		if self.SuicideAng then	
			ang:RotateAroundAxis(ang:Right(),self.SuicideAng.p*Suicide)
			ang:RotateAroundAxis(ang:Up(),self.SuicideAng.y*Suicide)
			ang:RotateAroundAxis(ang:Forward(),self.SuicideAng.r*Suicide)
		end
		
		if self.AimAng then
			ang:RotateAroundAxis(Right,self.AimAng.p*Aim)
			ang:RotateAroundAxis(Up,self.AimAng.y*Aim)
			ang:RotateAroundAxis(Forward,self.AimAng.r*Aim)
		end
		local kposAdd=Vector(0,0,0)
		if self:GetNWBool("Suppressor") and self.SuicideSuppr then kposAdd=self.SuicideSuppr end
		local aimPos=self.AttAimPos or self.AimPos
		if Bipod>0.1 then aimPos=Vector(0,0,0) end
		local npos=LerpVector( Aim, Vector( 0, 0, 0 ), aimPos )
		local spos=LerpVector( Sprint, Vector( 0, 0, 0 ), self.SprintPos )
		local kpos=LerpVector( Suicide, Vector( 0, 0, 0 ), (self.SuicidePos or Vector(0,0,0))+kposAdd )
		local curbipodPos=self:GetNWVector("BipodPos")
		local bipodPos=LerpVector( Bipod, Vector( 0, 0, 0 ), LastBipodPos+Vector(0,0,self.BipodOffset)-self.Owner:GetAimVector()*self.BarrelLength-pos )
		if curbipodPos!=vector_origin then
			LastBipodPos=curbipodPos
		end
		return pos+Right*(npos[1]+spos[1]+kpos[1])+Forward*(npos[2]+spos[2]+kpos[2])+Up*(npos[3]+spos[3]+kpos[3])+bipodPos,ang
	end 
	function SWEP:ViewModelDrawn(vm)
		if self.Attachments and self.Attachments["Owner"] then
			for attachment,info in pairs(self.Attachments["Owner"]) do
				if self:GetNWBool(attachment) then
					if not(self.DrawnAttachments[attachment])then
						self.DrawnAttachments[attachment]=ClientsideModel(info.model)
						self.DrawnAttachments[attachment]:SetPos(vm:GetPos())
						self.DrawnAttachments[attachment]:SetParent(vm)
						self.DrawnAttachments[attachment]:SetNoDraw(true)
						if info.scale then
							self.DrawnAttachments[attachment]:SetModelScale(info.scale,0)
						end
						if info.material then
							self.DrawnAttachments[attachment]:SetMaterial(info.material)
						end
						if info.sightang then
							if not(self.SightInfo) then self.SightInfo={14-info.num,self.DrawnAttachments[attachment]} end
						end
						if info.aimpos then self.AttAimPos=info.aimpos end
						if info.bipodpos then self.AttBipodPos=info.bipodpos end
					else
						local matr=vm:GetBoneMatrix(vm:LookupBone(info.bone))
						if matr then
							local pos,ang=matr:GetTranslation(),matr:GetAngles()
							if info.reverseangle then ang.r=-ang.r end
							self.DrawnAttachments[attachment]:SetRenderOrigin(pos+ang:Right()*info.pos.right+ang:Forward()*info.pos.forward+ang:Up()*info.pos.up)
							if info.sightang then
								local angCopy=matr:GetAngles()
								if info.sightang.up then
									angCopy:RotateAroundAxis(angCopy:Up(),info.sightang.up)
								end
								if info.sightang.forward then
									angCopy:RotateAroundAxis(angCopy:Forward(),info.sightang.forward)
								end
								if info.sightang.right then
									angCopy:RotateAroundAxis(angCopy:Right(),info.sightang.right)
								end
								self.ScopeDotAngle=angCopy
								self.ScopeDotPosition=pos+ang:Right()*info.sightpos.right+ang:Forward()*info.sightpos.forward+ang:Up()*info.sightpos.up
							end
							if info.ang then
								if info.ang.up then
									ang:RotateAroundAxis(ang:Up(),info.ang.up)
								end
								if info.ang.forward then
									ang:RotateAroundAxis(ang:Forward(),info.ang.forward)
								end
								if info.ang.right then
									ang:RotateAroundAxis(ang:Right(),info.ang.right)
								end
							end
							self.DrawnAttachments[attachment]:SetRenderAngles(ang)
							self.DrawnAttachments[attachment]:DrawModel()
							if attachment=="Laser" and self:GetLaserEnabled() then GAMEMODE:DrawLaserDot(self.Owner) end
						end
					end
				else
					if self.DrawnAttachments[attachment] then
						self.DrawnAttachments[attachment]=nil
						if info.aimpos then self.AttAimPos=nil end
						if info.sightang then self.SightInfo=nil end
						if info.bipodpos then self.AttBipodPos=nil end
					end
				end
			end
		end
		if self.SightInfo then
			GAMEMODE:DrawScopeDot(self, self.SightInfo[1], self.SightInfo[2])
		end
	end
	function SWEP:DrawWorldModel()
		if self.Attachments and self.Attachments["Viewer"] then
			if((IsValid(self.Owner))and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
				if(self.FuckedWorldModel)then
					if not(self.WModel)then
						self.WModel=ClientsideModel(self.WorldModel)
						self.WModel:SetPos(self.Owner:GetPos())
						self.WModel:SetParent(self.Owner)
						self.WModel:SetNoDraw(true)
						if self.Attachments["Viewer"]["Weapon"].bodygroups then
							for i,val in pairs(self.Attachments["Viewer"]["Weapon"].bodygroups) do
								self.WModel:SetBodygroup(i,val)
							end
						end
					else
						local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
						if((pos)and(ang))then
							local info=self.Attachments["Viewer"]["Weapon"]
							self.WModel:SetRenderOrigin(pos+ang:Right()*info.pos.right+ang:Forward()*info.pos.forward+ang:Up()*info.pos.up)
							local angList={
								["forward"]=ang:Forward(),
								["right"]=ang:Right(),
								["up"]=ang:Up()
							}
							for i,rot in pairs(info.ang) do
								if not(info.ang[1]) then
									ang:RotateAroundAxis(angList[i],rot)
								else
									ang:RotateAroundAxis(angList[rot[1]],rot[2])
								end
								angList={
									["forward"]=ang:Forward(),
									["right"]=ang:Right(),
									["up"]=ang:Up()
								}
							end
							self.WModel:SetRenderAngles(ang)
							self.WModel:DrawModel()
						end
					end
				else
					self:DrawModel()
				end
				for attachment,info in pairs(self.Attachments["Viewer"]) do
					if self:GetNWBool(attachment) then
						if not(self.WDrawnAttachments[attachment])then
							self.WDrawnAttachments[attachment]=ClientsideModel(info.model)
							self.WDrawnAttachments[attachment]:SetPos(self.Owner:GetPos())
							self.WDrawnAttachments[attachment]:SetParent(self.Owner)
							self.WDrawnAttachments[attachment]:SetNoDraw(true)
							if info.scale then
								self.WDrawnAttachments[attachment]:SetModelScale(info.scale,0)
							end
							if info.material then
								self.WDrawnAttachments[attachment]:SetMaterial(info.material)
							end
						else
							if attachment=="Laser" and self:GetLaserEnabled() then self:DrawLaser() end
							local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
							self.WDrawnAttachments[attachment]:SetRenderOrigin(pos+ang:Right()*info.pos.right+ang:Forward()*info.pos.forward+ang:Up()*info.pos.up)
							local angList={
								["forward"]=ang:Forward(),
								["right"]=ang:Right(),
								["up"]=ang:Up()
							}
							for i,rot in pairs(info.ang) do	
								ang:RotateAroundAxis(angList[i],rot)	
								angList={
									["forward"]=ang:Forward(),
									["right"]=ang:Right(),
									["up"]=ang:Up()
								}
							end
							self.WDrawnAttachments[attachment]:SetRenderAngles(ang)
							self.WDrawnAttachments[attachment]:DrawModel()
						end
					else
						if self.WDrawnAttachments[attachment] then self.WDrawnAttachments[attachment]=nil end
					end
				end
			end
		end
	end
	function SWEP:FireAnimationEvent(pos,ang,event,name)
		return true -- I do all this, bitch
	end
end

local laserline = Material("cable/smoke")

local laserdot = Material("effects/tfalaserdot")

SWEP.LaserDistance=6000
SWEP.LaserFOV=1.5
SWEP.LaserColor=Color(255, 0, 0, 255)

function SWEP:DrawLaser()
	if not IsValid(self.Owner) then return end
	local pos,ang=self.WDrawnAttachments["Laser"]:GetPos(),self.WDrawnAttachments["Laser"]:GetAngles()
	if self.WDrawnAttachments["Laser"]:GetModel()=="models/cw2/attachments/anpeq15.mdl" then ang:RotateAroundAxis(ang:Right(),180) end
	local ply = self.Owner

	if not IsValid(ply.HMCDLaserDot) then
		local lamp = ProjectedTexture()
		ply.HMCDLaserDot = lamp
		lamp:SetTexture(laserdot:GetString("$basetexture"))
		lamp:SetFarZ(self.LaserDistance) -- How far the light should shine
		lamp:SetFOV(self.LaserFOV)
		lamp:SetPos(pos)
		lamp:SetAngles(ang)
		lamp:SetBrightness(15)
		lamp:SetNearZ(1)
		lamp:SetEnableShadows(false)
		lamp:Update()
		self.LastLaserUpdate=CurTime()
		local entIndex=ply:EntIndex()
		hook.Add("Think","Laserdot_"..entIndex,function()
			if not(IsValid(ply) and IsValid(lamp) and IsValid(self) and self.LastLaserUpdate) then hook.Remove("Think","Laserdot_"..entIndex) end
			if self.LastLaserUpdate and self.LastLaserUpdate+0.1<CurTime() then lamp:Remove() end
		end)
	end

	local lamp = ply.HMCDLaserDot
	if IsValid(lamp) then
		ang:RotateAroundAxis(ang:Forward(), math.Rand(-180, 180))
		lamp:SetPos(pos)
		lamp:SetAngles(ang)
		lamp:SetColor(self.LaserColor)
		lamp:SetFOV(self.LaserFOV * math.Rand(0.9, 1.1))
		lamp:Update()
		self.LastLaserUpdate=CurTime()
	end
end

function SWEP:CleanLaser()
	local own = self:GetOwner()
	if IsValid(own) and IsValid(own.HMCDLaserDot) then
		own.HMCDLaserDot:Remove()
	end
end

local drumSlots=6

function SWEP:EnableRoulette(amt)
	amt=amt or 1
	if SERVER then
		if amt!=true then
			self.OnRemove=function() self:Remove() end
			self.DrumPos=1
			self.DrumBullets={}
			self:SetClip1(amt)
			local freeSlots={}
			for i=1,drumSlots do
				table.insert(freeSlots,i)
			end
			for i=1,amt do
				local ind,rand=table.Random(freeSlots)
				self.DrumBullets[rand]=true
				freeSlots[ind]=nil
			end
		end
		self.Clicks=0
		net.Start("hmcd_roulette")
		net.WriteEntity(self)
		net.WriteUInt(self.DrumPos,5)
		net.WriteTable(self.DrumBullets)
		net.Send(self.Owner)
	end
	self.OldAttackFunc=self.OldAttackFunc or self.PrimaryAttack
	self.PrimaryAttack=function()
		if CLIENT and not(not(self.NextFire) or self.NextFire<CurTime()) then return end
		if not(self.DrumBullets[self.DrumPos]) then
			self:EmitSound("snd_jack_hmcd_click.wav",55,100)
		else
			if CLIENT then self:DoBFSAnimation(self.FireAnim) end
			self:OldAttackFunc()
			self.DrumBullets[self.DrumPos]=nil
		end
		if CLIENT then self.NextFire=CurTime()+.5 end
		self:SetNextPrimaryFire(CurTime()+.5)
		self.DrumPos=self.DrumPos+1
		if self.Clicks then
			self.Clicks=self.Clicks+1
			if self.Clicks>1 then
				for i,ply in pairs(player.GetAll()) do
					if ply:IsAdmin() then ply:PrintMessage(HUD_PRINTTALK,"WARNING: PLAYER "..self.Owner:Nick().." PULLED THE TRIGGER MORE THAN ONCE!") end
				end
			end
		end
		if self.DrumPos>drumSlots then self.DrumPos=1 end
	end
end