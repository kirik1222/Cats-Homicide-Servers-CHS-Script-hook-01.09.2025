if ( SERVER ) then
	AddCSLuaFile()
else
	killicon.AddFont( "wep_jack_hmcd_rifle", "HL2MPTypeDeath", "1", Color( 255, 0, 0 ) )
	SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_binocular")
end
SWEP.ViewModelFOV = 50
SWEP.IconTexture="vgui/wep_jack_hmcd_binocular"
SWEP.Base = "wep_jack_hmcd_firearm_base"
SWEP.PrintName		= "BPOs 10x42 “Baigish”"
SWEP.Instructions	= "These are two telescopes mounted side-by-side and aligned to point in the same direction, allowing the viewer to observe distant objects.\n\nRMB to look through lenses."
SWEP.Primary.ClipSize			= -1
SWEP.ViewModel		= "models/weapons/c_binoculars.mdl"
SWEP.WorldModel		= "models/weapons/w_binocularsbp.mdl"
SWEP.SprintPos=Vector(-7,0,-10)
SWEP.SprintAng=Angle(-20,-30,-40)
SWEP.AimPos=Vector(-4.95,-4,-17)
SWEP.AimAng=Angle(90,0,0)
SWEP.ReloadTime=6
SWEP.ReloadRate=.75
SWEP.ReloadSound="snd_jack_hmcd_boltreload.wav"
SWEP.CycleSound="snd_jack_hmcd_boltcycle.wav"
SWEP.AmmoType=""
SWEP.CanAmmoShow=false
SWEP.TriggerDelay=.2
SWEP.Recoil=1
SWEP.Supersonic=true
SWEP.SuppressedRifle=false
SWEP.ENT="ent_jack_hmcd_binocular"
SWEP.UseHands=true
SWEP.CommandDroppable=true
SWEP.DrawAnim="awm_draw"
SWEP.ShellType=""
SWEP.Scoped=true
SWEP.ScopeFoV=3.7
SWEP.ScopedSensitivity=.05
SWEP.BarrelLength=1
SWEP.AimTime=6.25
SWEP.BearTime=9
SWEP.DrawRate=1
SWEP.ViewModelFlip=false
SWEP.SilentDeploy=true
SWEP.FuckedWorldModel=true
SWEP.HipHoldType="slam"
SWEP.AimHoldType="camera"
SWEP.DownHoldType="normal"
SWEP.CarryWeight=500
SWEP.Binocular=true

function SWEP:PrimaryAttack()
	--
end

function SWEP:Reload()
	--
end

function SWEP:Deploy()
	if((IsValid(self))and(IsValid(self.Owner)))then
		if not(IsFirstTimePredicted())then
			self:DoBFSAnimation(self.DrawAnim)
			self.Owner:GetViewModel():SetPlaybackRate(.1)
			return
		end
		self:DoBFSAnimation(self.DrawAnim)
		self:SetReady(true)
		return true
	end
end

function SWEP:DrawWorldModel()
	if((IsValid(self.Owner))and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
		if(self.FuckedWorldModel)then
			if not(self.WModel)then
				self.WModel=ClientsideModel(self.WorldModel)
				self.WModel:SetPos(self.Owner:GetPos())
				self.WModel:SetParent(self.Owner)
				self.WModel:SetNoDraw(true)
				self.WModel:SetModelScale(.85,0)
			else
				local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
				if((pos)and(ang))then
					self.WModel:SetRenderOrigin(pos+ang:Right()*8+ang:Up()*-2.5+ang:Forward()*4)
					ang:RotateAroundAxis(ang:Forward(),190)
					ang:RotateAroundAxis(ang:Right(),45)
					ang:RotateAroundAxis(ang:Up(),0)
					self.WModel:SetRenderAngles(ang)
					self.WModel:DrawModel()
				end
			end
		else
			self:DrawModel()
		end
	end
end