SWEP.Base="weapon_base"
SWEP.HomicideSWEP=true
SWEP.PinOut=false
SWEP.SpawnedSpoon=false

function SWEP:Initialize()
	self:SetHoldType("grenade")
	self.Thrown=false
	if self.GetAmount and self:GetAmount()==0 then self:SetAmount(1) end
end

function SWEP:SetupDataTables()
	--
end

function SWEP:Holster(newWep)
	self.PinOut=false
	return true
end

function SWEP:PrimaryAttack()
	if not(IsFirstTimePredicted())then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	if self.OnStartPrimary then self:OnStartPrimary() end
	if not(self.Dildo) or self.FirstPull then
		self.ReadyToThrow=false
		self:DoBFSAnimation(self.PullPinAnim)
		self.Owner:GetViewModel():SetPlaybackRate(self.PullPinRate or 1)
		timer.Simple(self.PinOutTime,function()
			if IsValid(self) and self.Owner!=NULL and self.Owner:GetActiveWeapon()==self then
				self:EmitSound(self.PinOutSound)
				self.PinOut=true
			end
		end)
		timer.Simple(self.ThrowReadyDelay,function()
			if IsValid(self) and self.Owner!=NULL and self.Owner:GetActiveWeapon()==self then
				self.ReadyToThrow=true
				if not(self.Owner:KeyDown(IN_ATTACK)) then
					self:EmitSound(self.ThrowSound)
					self.Owner:SetAnimation(PLAYER_ATTACK1)
				end
			end
		end)
		if self.FirstPull then
			self.FirstPull=nil
		else
			self:SetNextPrimaryFire(CurTime()+4)
			self:SetNextSecondaryFire(CurTime()+4)
		end
	else
		self.ReadyToThrow=true
		self.PinOut=true
	end
end

function SWEP:Deploy()
	if not(IsFirstTimePredicted())then return end
	if self.Dildo then self.FirstPull=true end
	self.DownAmt=10
	self:DoBFSAnimation(self.DrawAnim)
	self.Owner:GetViewModel():SetPlaybackRate(self.DrawRate or 1)
	self:SetNextPrimaryFire(CurTime()+1)
	self:SetNextSecondaryFire(CurTime()+1)
	return true
end

function SWEP:SecondaryAttack()
	if not(self.Riggable) then return end
	if not(IsFirstTimePredicted())then return end
	if(self.Owner:KeyDown(IN_SPEED))then return end
	if(self.PinOut) then return end
	if IsValid(self.Owner:GetNWBool("Fake")) then return end
	if self.OnStartSecondary then self:OnStartSecondary() end
	if not(self.Dildo) or self.FirstPull then
		self:DoBFSAnimation(self.RigAnim or self.PullPinAnim)
		self.Owner:GetViewModel():SetPlaybackRate(self.RigRate or 1)
		timer.Simple(self.RigPinTime,function()
			if IsValid(self) then
				self:EmitSound(self.PinOutSound)
			end
		end)
		timer.Simple(self.RigTime,function()
			self:RigGrenade()
		end)
		if self.FirstPull then
			self.FirstPull=nil
		else
			self:SetNextPrimaryFire(CurTime()+self.RigNextFire)
			self:SetNextSecondaryFire(CurTime()+self.RigNextFire)
			timer.Simple(self.RigReturnTime,function()
				if IsValid(self) then
					self:DoBFSAnimation(self.DrawAnim)
					self.Owner:GetViewModel():SetPlaybackRate(self.DrawRate or 1)
				end
			end)
		end
	else
		self:RigGrenade()
	end
end

function SWEP:GetSpoonReleaseKey()
	if IsValid(self.Owner:GetNWBool("Fake")) then return IN_RELOAD else return IN_ATTACK2 end
end

function SWEP:Think()

	if self.PinOut and self.ReadyToThrow then
		if self.Owner:KeyDown(IN_ATTACK) and self.Owner:KeyDown(self:GetSpoonReleaseKey()) and not(self.SpawnedSpoon) then
			self:EjectSpoon()
		end
		if not(self.Owner:KeyDown(IN_ATTACK)) then
			self.PinOut=false
			self:DoBFSAnimation(self.ThrowAnim)
			self:EmitSound(self.ThrowSound)
			self.Owner:GetViewModel():SetPlaybackRate(self.ThrowRate or 1)
			self.Owner:SetAnimation(PLAYER_ATTACK1)
			self.Owner:ViewPunch(self.ThrowInitialPunch)
			timer.Simple(self.SecondaryPunchDelay,function()
				if IsValid(self) then
					self.Owner:ViewPunch(self.ThrowSecondaryPunch)
				end
			end)
			timer.Simple(self.ThrowDelay,function()
				if(IsValid(self))then
					self:ThrowGrenade()
				end
			end)
			if not(self.Dildo) then
				local delay=(self.NextThrowDelay or 4)
				self:SetNextPrimaryFire(CurTime()+delay)
				self:SetNextSecondaryFire(CurTime()+delay)
				timer.Simple(delay-1,function()
					if IsValid(self) then
						self:DoBFSAnimation(self.DrawAnim)
					end
				end)
			end
		end
	end
	
	if SERVER then
		self:DetermineHoldType()
	end

end

function SWEP:DoBFSAnimation(anim)
	if((self.Owner)and(self.Owner.GetViewModel))then
		local vm=self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
	end
end

function SWEP:FireAnimationEvent(pos,ang,event,name)
	return true
end