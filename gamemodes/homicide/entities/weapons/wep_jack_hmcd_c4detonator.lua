if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 50
	SWEP.Slot = 4
	SWEP.SlotPos = 2
	killicon.AddFont("wep_jack_hmcd_oldgrenade", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))
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
		
	end
end
SWEP.Base="weapon_base"
SWEP.ViewModel = "models/weapons/v_c4_sec.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_c4_detonator");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_c4_detonator"
SWEP.PrintName = "M57 Detonator"
SWEP.Instructions	= "This is a rugged, military-grade detonator designed to trigger explosives remotely.\n\nLMB to press the firing handle."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=3
SWEP.SwayScale=3
SWEP.Weight	= 3
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false
SWEP.ViewModelFlip=false
SWEP.Spawnable			= true
SWEP.AdminOnly			= true
SWEP.UseHands=true
SWEP.InsHands=true
SWEP.Primary.Delay			= 0.5
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 120
SWEP.Primary.NumShots		= 1	
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Force			= 900
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic   	= false
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
SWEP.HomicideSWEP=true
SWEP.CarryWeight=250

function SWEP:Initialize()
	self:SetHoldType("slam")
	self.Thrown=false
end

function SWEP:PrimaryAttack()
	if not(IsFirstTimePredicted())then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	if not(HMCD_CSInfo["Hints"][game.GetMap()]) then return end
	local plantedBombs={}
	for i,info in pairs(HMCD_CSInfo["Hints"][game.GetMap()]) do
		for j,c4 in pairs(ents.FindByClass("ent_jack_hmcd_c4")) do
			if c4:GetPos():DistToSqr(info[1])<1 then
				plantedBombs[i]=c4
				break
			end
		end
	end
	local sitesReady={
		[1]=true,
		[2]=true
	}
	for i=1,5 do
		if not(plantedBombs[i]) then sitesReady[1]=false break end
	end
	for i=6,10 do
		if not(plantedBombs[i]) then sitesReady[2]=false break end
	end
	if not(sitesReady[1] or sitesReady[2]) then
		if SERVER then
			if table.Count(plantedBombs)>0 then
				self.Owner:PrintMessage(HUD_PRINTTALK,"There aren't enough charges planted. The blast won't be powerful enough!")
			else
				self.Owner:PrintMessage(HUD_PRINTTALK,"There are no charges planted currently!")
			end
		end 
		return
	end
	self:DoBFSAnimation("det_detonate")
	timer.Simple(.25,function()
		if IsValid(self) then
			self:EmitSound("c4_click.wav",75)
			timer.Simple(.75,function()
				if IsValid(self) and SERVER then
					for i,canBlow in pairs(sitesReady) do
						if canBlow then
							ParticleEffect("pcf_jack_incendiary_ground_sm2",HMCD_CSInfo["BlowSpots"][game.GetMap()][i],vector_up:Angle())
							sound.Play( "iedins/ied_detonate_01.wav", HMCD_CSInfo["BlowSpots"][game.GetMap()][i],500 )
							net.Start("hmcd_sound_tocl")
							net.WriteString("iedins/ied_detonate_far_dist_01.wav")
							net.Send(player.GetAll())
							for j,t in ipairs(player.GetAll()) do
								if t.Role=="t" then
									t:AddMerit(1)
								end
							end
							GAMEMODE.CSVictories["T"]=GAMEMODE.CSVictories["T"]+1
							if GAMEMODE.CSVictories["T"]==6 then
								for j,t in ipairs(player.GetAll()) do
									if t.Role=="t" then
										t:AddMerit(5)
									end
								end
								GAMEMODE.CSVictories=nil
							else
								GAMEMODE.ForcedMode="CS"
							end
							GAMEMODE:EndTheRound(11,self.Owner)
							for j,ent in pairs(ents.GetAll()) do
								local dist=ent:GetPos():Distance(HMCD_CSInfo["BlowSpots"][game.GetMap()][i])
								local dmg=math.Round(25000/dist)
								if dmg>0 then
									local force=(ent:GetPos()-HMCD_CSInfo["BlowSpots"][game.GetMap()][i]):GetNormalized()*dmg*5
									if dmg>20 then
										if ent:IsPlayer() and not(IsValid(ent.fakeragdoll)) then
											ent.lastRagdollEndTime=nil
											ent:CreateFake()
											ent=ent.fakeragdoll
										elseif HMCD_IsDoor(ent) then
											HMCD_BlastThatDoor(ent,force)
										end
									end
									local dmgInfo=DamageInfo()
									dmgInfo:SetAttacker(plantedBombs[1] or plantedBombs[6])
									dmgInfo:SetDamage(dmg)
									dmgInfo:SetDamageType(DMG_BLAST)
									dmgInfo:SetDamageForce(force)
									ent:TakeDamageInfo(dmgInfo)
								end
							end
							for j=5*(i-1)+1,5*i do
								plantedBombs[j]:Remove()
							end
						end
					end
					self:Remove() 
				end
			end)
		end
	end)
	self:SetNextPrimaryFire(CurTime()+2)
end
function SWEP:Deploy()
	if not(IsFirstTimePredicted())then return end
	--for i=0,10 do PrintTable(self.Owner:GetViewModel():GetAnimInfo(i)) end
	self:DoBFSAnimation("det_draw")
	self:SetNextPrimaryFire(CurTime()+1)
	return true
end

function SWEP:SecondaryAttack()
	--
end

function SWEP:Think()
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
function SWEP:DoBFSAnimation(anim)
	if((self.Owner)and(self.Owner.GetViewModel))then
		local vm=self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
	end
end
function SWEP:FireAnimationEvent(pos,ang,event,name)
	return true -- I do all this, bitch
end
if(CLIENT)then
	local DownAmt=0
	function SWEP:GetViewModelPosition(pos,ang)
		if not(self.DownAmt)then self.DownAmt=0 end
		if(self.Owner:KeyDown(IN_SPEED))then
			self.DownAmt=math.Clamp(self.DownAmt+.2,0,20)
		else
			self.DownAmt=math.Clamp(self.DownAmt-.2,0,20)
		end
		pos=pos-ang:Up()*(self.DownAmt)+ang:Forward()*-1+ang:Right()
		return pos,ang
	end
	function SWEP:DrawWorldModel()
		if(GAMEMODE:ShouldDrawWeaponWorldModel(self))then
			local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
			if not(self.WModel)then
				self.WModel=ClientsideModel("models/weapons/w_c4.mdl")
				self.WModel:SetPos(self.Owner:GetPos())
				self.WModel:SetParent(self.Owner)
				self.WModel:SetBodygroup(1,1)
				self.WModel:SetSubMaterial(0,"models/hands/hands_color")
				self.WModel:SetNoDraw(true)
			else
				if((pos)and(ang))then
					self.WModel:SetRenderOrigin(pos+ang:Right()*-0.5+ang:Up()*-1.5+ang:Forward()*3)
					ang:RotateAroundAxis(ang:Forward(),-220)
					ang:RotateAroundAxis(ang:Right(),150)
					ang:RotateAroundAxis(ang:Up(),-190)
					self.WModel:SetRenderAngles(ang)
					self.WModel:DrawModel()
				end
			end
		end
	end
end