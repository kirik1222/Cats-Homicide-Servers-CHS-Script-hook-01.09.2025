if(SERVER)then
	AddCSLuaFile()
elseif(CLIENT)then
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 65
	SWEP.Slot = 4
	SWEP.SlotPos = 3
	killicon.AddFont("wep_jack_hmcd_molotov", "HL2MPTypeDeath", "5", Color(0, 0, 255, 255))
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
SWEP.Base="wep_jack_hmcd_grenade_base"
SWEP.ViewModel = "models/weapons/v_m18.mdl"
SWEP.WorldModel = "models/weapons/w_m18.mdl"
if(CLIENT)then SWEP.WepSelectIcon=surface.GetTextureID("vgui/wep_jack_hmcd_m18");SWEP.BounceWeaponIcon=false end
SWEP.IconTexture="vgui/wep_jack_hmcd_flashbang"
SWEP.PrintName = "M18"
SWEP.Instructions	= "This is a compact, hand-thrown grenade that releases a thick smoke cloud upon activation.\n\nLMB to arm and throw.\nRight click while holding LMB to remove the safety handle.\nRight click to place on a surface and rig as a booby trap."
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.BobScale=3
SWEP.SwayScale=3
SWEP.Weight	= 3
SWEP.UseHands=true
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
SWEP.CarryWeight=800
SWEP.InsHands=true
SWEP.Stackable=true
SWEP.CommandDroppable=true
SWEP.ENT="ent_jack_hmcd_m18"
SWEP.PullPinAnim="pullbackhigh"
SWEP.PinOutTime=.5
SWEP.PinOutSound="weapons/m67/m67_pullpin.wav"
SWEP.ThrowReadyDelay=1
SWEP.DrawAnim="base_draw"
SWEP.Riggable=true
SWEP.RigRate=1
SWEP.RigPinTime=.45
SWEP.RigTime=1.2
SWEP.RigAnim="pullbacklow"
SWEP.RigReturnTime=2
SWEP.RigNextFire=3
SWEP.ThrowAnim="throw"
SWEP.ThrowRate=1.5
SWEP.ThrowSound="weapons/m67/m67_throw_01.wav"
SWEP.ThrowInitialPunch=Angle(-10,-5,0)
SWEP.SecondaryPunchDelay=0.15
SWEP.ThrowSecondaryPunch=Angle(20,10,0)
SWEP.ThrowDelay=0.35
SWEP.MinExplodeTime=2
SWEP.MaxExplodeTime=2
SWEP.SpoonModel="models/weapons/arc9/darsu_eft/skobas/m18_skoba.mdl"
SWEP.VMPos=Vector(0,-1,0)
SWEP.NextThrowDelay=2
SWEP.KeepUpOnRun=true

function SWEP:SetupDataTables()
	self:NetworkVar("Int",0,"Amount")
end

if(CLIENT)then
	
	function SWEP:DrawWorldModel()
		local Pos,Ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		if(self.DatWorldModel)then
			if((Pos)and(Ang)and(GAMEMODE:ShouldDrawWeaponWorldModel(self)))then
				self.DatWorldModel:SetRenderOrigin(Pos+Ang:Forward()*3.5+Ang:Right()*2-Ang:Up()*2)
				Ang:RotateAroundAxis(Ang:Right(),180)
				self.DatWorldModel:SetRenderAngles(Ang)
				self.DatWorldModel:DrawModel()
			end
		else
			self.DatWorldModel=ClientsideModel("models/weapons/w_m18.mdl")
			self.DatWorldModel:SetPos(self:GetPos())
			self.DatWorldModel:SetParent(self)
			self.DatWorldModel:SetNoDraw(true)
		end
	end
	
end