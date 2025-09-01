include("shared.lua")

function SWEP:SpawnGrenade()
	
end

function SWEP:ThrowGrenade()
	
end

function SWEP:DropGrenade()
	
end

function SWEP:RigGrenade()
	
end

function SWEP:EjectSpoon()
	self.SpawnedSpoon=true
end

local DownAmt=0
function SWEP:GetViewModelPosition(pos,ang)
	if not(self.DownAmt)then self.DownAmt=0 end
	if self.Owner:KeyDown(IN_SPEED) and not(self.KeepUpOnRun and self.Owner:KeyDown(IN_ATTACK)) then
		self.DownAmt=math.Clamp(self.DownAmt+.2,0,20)
	else
		self.DownAmt=math.Clamp(self.DownAmt-.2,0,20)
	end
	pos=pos-ang:Up()*(self.DownAmt+self.VMPos[1])+ang:Forward()*self.VMPos[2]+ang:Right()*self.VMPos[3]
	return pos,ang
end

function SWEP:DrawWorldModel()
	if GAMEMODE:ShouldDrawWeaponWorldModel(self) then
		self:DrawModel()
	end
end