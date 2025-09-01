
--TODO
-- Create StartNewRound clientside wtih several args
-- Translation functions

surface.CreateFont( "MersRadialSmall" , {
	font = "coolvetica",
	size = math.ceil(ScrW() / 60),
	weight = 100,
	antialias = true,
	italic = false
})

surface.CreateFont( "MersRadial" , {
	font = "coolvetica",
	size = math.ceil(ScrW() / 34),
	weight = 500,
	antialias = true,
	italic = false
})

local startSounds={
	["Classic"]={"snd_jack_hmcd_psycho.mp3","snd_jack_hmcd_halloween.mp3","snd_jack_hmcd_shining.mp3"},
	["Epic"]="snd_jack_hmcd_wildwest.mp3",
	["Pussy"]="snd_jack_hmcd_panic.mp3",
	["Jihad"]="snd_jack_hmcd_islam.mp3",
	["SOE"]="snd_jack_hmcd_disaster.mp3",
	["Deathmatch"]="snd_jack_hmcd_deathmatch.mp3",
	["Zombie"]="snd_jack_hmcd_zombies.mp3",
	["Hl2"]="hl2mode1.wav",
	["Hl2_WT"]="hl2mode1.wav",
	["Riot"]="snd_jack_hmcd_disaster.mp3",
	["CS"]="csgo_round.wav",
	["Ukraine"]={["russian"]="ukraineround.wav",["ukrainian"]="hohols.mp3"},
	["Easter"]={["jew"]="easterround_jew.mp3",["follower"]="easterround_jesus.mp3",["jesus"]="easterround_jesus.mp3"},
	["Terminator"]="terminator.wav",
	["Strange"]="strangeround.wav",
	["Walkthrough"]=""
}

local warmupTimes={
	["CS"]=25,
	["Deathmatch"]=20
}

local roleColors={
	["killer"]=Color(255,0,0),
	["terminator"]=Color(30,0,255),
	["survivor"]=Color(0,155,0),
	["jesus"]=Color(255,255,0),
	[""]=Color(0,161,255)
}

local function GetRoleColor(Role,Mode)
	return roleColors[Role] or roleColors[""]
end

local function textCenter_start(Text,Panel)
	local textWidth,textHeight=surface.GetTextSize(Text)
	local RoundLabel=Label(Text,Panel)
	RoundLabel:SetFont("MersRadial")
	RoundLabel:SetColor(color_white)
	RoundLabel:SizeToContents()
	RoundLabel:Center()
end

local customStartInterfaces={
	["Strange"]=textCenter_start,
	["Walkthrough"]=textCenter_start
}

local disappearTimes={
	["Walkthrough"]=3
}

function GM:StartNewRound(Mode,Role,MainMode)
	hook.Remove("Think","Disconnecting")
	local lPly=LocalPlayer()
	if lPly.ZoneSound then
		hook.Remove("PostDrawTranslucentRenderables","RenderDMZone")
		if lPly.ZoneSound.Stop then lPly.ZoneSound:Stop() end
		lPly.ZoneSound=nil
	end
	
	local sound=startSounds[Mode] or startSounds[MainMode]
	if istable(sound) then
		if sound[1] then
			sound=table.Random(sound)
		else
			sound=sound[Role]
		end
	end
	if sound!="" then
		lPly:EmitSound(sound)
	end
	
	local disappearTime=disappearTimes[Mode] or 9
	local Panel=vgui.Create("DPanel")
	Panel:SetPos(0, 0)
	Panel:SetSize(ScrW(), ScrH())
	Panel.Paint = function( sel, w, h ) 
		surface.SetDrawColor(0,0,0,255)
		surface.DrawRect(0, 0, w, h)
	end
	Panel:ParentToHUD()
	Panel:AlphaTo(0,3,disappearTime,function() Panel:Remove() end)
	local startTime=CurTime()
	hook.Add("RenderScreenspaceEffects","HMCD_StartRound",function()
		local a=math.Clamp(255+(startTime+disappearTime-CurTime())*85,0,255)
		surface.SetDrawColor(Color(0,0,0,a))
		surface.DrawRect( -5,-5,ScrW()+5,ScrH()+5 )
		if a<=0 then
			hook.Remove("RenderScreenspaceEffects","HMCD_StartRound")
		end
	end)
	
	if lPly:Team()==2 then
		if not(customStartInterfaces[Mode]) then
			surface.SetFont("MersRadialSmall")
			local Text=Translate(Role,nil,MainMode,Mode)
			local textWidth,textHeight=surface.GetTextSize(Text)
			Text=Translate("you_are")--Translate other modes too...
			local You = Label(Text,Panel)
			You:SetFont("MersRadialSmall")
			You:SetColor(GetRoleColor(Role))
			You:SetPos(0,ScrH()/2-textHeight*1.5)
			You:SizeToContents()
			You:CenterHorizontal()
			Text=Translate(Role,nil,MainMode,Mode)
			local RoundLabel = Label(Text,Panel)
			RoundLabel:SetFont("MersRadial")
			RoundLabel:SizeToContents()
			RoundLabel:Center()
			RoundLabel:SetColor(GetRoleColor(Role))
			if(Role=="gunman")then
				Text=Translate("weapon_posession",nil,MainMode,Mode)--Translate other modes too...
				local Instructions = Label(Text,Panel)
				Instructions:SetFont("MersRadialSmall")
				Instructions:SizeToContents()
				Instructions:Center()
				Instructions:SetPos(Instructions:GetX(),Instructions:GetY()+textHeight*1.5)	
				Instructions:SetColor(Color(121,61,244))	
			end
			Text=Translate(Role.."_help",nil,MainMode,Mode)
			local RoundLabel = Label(Text,Panel)
			RoundLabel:SetFont("MersRadialSmall")
			RoundLabel:SizeToContents()
			RoundLabel:Center()
			local fontHeight=draw.GetFontHeight("MersRadialSmall")
			RoundLabel:SetPos(RoundLabel:GetX(),ScrH()-fontHeight*2)
			RoundLabel:SetColor(GetRoleColor(Role))
			
			Text=Translate("name",nil,MainMode,Mode)
			local RoundLabel = Label(Text,Panel)
			RoundLabel:SetFont("MersRadialSmall")
			RoundLabel:SizeToContents()
			RoundLabel:CenterHorizontal()
			RoundLabel:SetPos(RoundLabel:GetX(),50)
		else
			customStartInterfaces[Mode](Mode,Panel)
		end
	end
	lPly.Role=Role
	self.RoundStartTime=startTime
	for i,ply in ipairs(player.GetAll()) do
		ply.ModelSex=nil
		ply.HeartShotTime=nil
		ply.RenderOverride=function()
			ply:DrawModel()
			self:RenderAccessories(ply)
		end
		ply.Hidden=nil
		ply.HMCD_Flashlight=nil
	end
	self.Mode=Mode
	self.MainMode=MainMode
	self.WeaponEquipTime=warmupTimes[self.Mode]
	self.RadioHolders={}
	self.ZombieMutations={}
	lPly.QName=nil
	lPly.ZM_ChosenPanel=nil
	lPly.ZPoints=0
	lPly.MutationPoints=3
	lPly.ZombiesMarked={}
	lPly.ChosenZombie=nil
	lPly.ChosenPower=nil
	lPly.FirstDotChosen=nil
	lPly.SecondDotChosen=nil
	lPly.ForgiveTime=nil
	lPly.ZombieVisionDir=nil
	lPly.ZombieVision=0
	lPly.ZombieMaster=Role=="killer" and Mode=="Zombie"
	GAMEMODE.Roles={}
	if lPly.ZombieMaster then
		GAMEMODE.Roles[lPly:SteamID()]="killer"
	end
	if lPly.ClickerEnabled then
		gui.EnableScreenClicker(false)
		lPly.ClickerEnabled=false
	end
	lPly.GuideOpened=GetConVar("hmcd_showguidehint"):GetInt()==0
	if IsValid(lPly.BuyMenu) then
		lPly.BuyMenu:Close()
	end
	if IsValid(lPly.GuideMenu) then
		lPly.GuideMenu:Close()
	end
	if lPly.HeldBreath then
		lPly.HeldBreath=nil
		hook.Remove("Think","HoldingBreath")
	end
	lPly.Lost=nil
	self.PoliceArrived=nil
	self.EvacZone=nil
	if lPly:GetHull()!=Vector(-10,-10,0) then
		lPly:SetHull(Vector(-10,-10,0),Vector(10,10,72))
		lPly:SetHullDuck(Vector(-10,-10,0),Vector(10,10,39))
	end
	if self.CSRags then
		for i,rag in pairs(self.CSRags) do rag:Remove() end
	end
	self.CSRags={}
	lPly.ZVUnlocked=lPly.ZombieMaster
	lPly.RadioToggled=nil
	lPly.staticPlaying=nil
	lPly.NextPossess=nil
	if self.Mode=="CS" then
		local switchTeams=self.CSVictories and self.CSVictories["T"]+self.CSVictories["CT"]==5
		if not(lPly.Money) or switchTeams then
			lPly.Money=800
			self.CSRewards={
				["Lose"]=2000,
				["Win"]=3000
			}
		end
		if not(self.CSVictories) then
			self.CSVictories={} 
			self.CSVictories["T"]=0 
			self.CSVictories["CT"]=0
			self.CSVictories["Round"]=0 
		elseif switchTeams then
			local temp=self.CSVictories["CT"]
			self.CSVictories["CT"]=self.CSVictories["T"]
			self.CSVictories["T"]=temp
		end
		self.CSVictories["Round"]=self.CSVictories["Round"]+1
	else
		self.CSVictories=nil
		self.CSRewards=nil
		lPly.Money=nil
	end
	hook.Remove("Think","Respawning")
end

net.Receive("StartNewRound",function()

	local Mode = net.ReadString()
	local Role = net.ReadString()
	local MainMode = net.ReadString()
	
	
	GAMEMODE:StartNewRound(Mode,Role,MainMode)

end)

local customEndSounds={
	[18]="terminator_defeated.wav"
}

net.Receive("EndRound",function()
	
	local data={}
	data.reason=net.ReadInt(8)
	data.murderer = net.ReadEntity()
	data.murdererColor = net.ReadVector()
	data.murdererName = net.ReadString()
	while true do
		local cont = net.ReadUInt(8)
		if cont == 0 then break end

		local t = {}
		t.player = net.ReadEntity()
		if IsValid(t.player) then
			t.playerName = t.player:Nick()
		end
		t.playerColor = net.ReadVector()
		t.player.BystanderName = net.ReadString()
		t.player.HMCD_Merit=net.ReadFloat()
		t.player.HMCD_Demerit=net.ReadFloat()
		t.player.HMCD_Experience=net.ReadFloat()
	end
	if GAMEMODE.Mode=="CS" then
		if data.reason==11 then GAMEMODE.CSVictories["T"]=GAMEMODE.CSVictories["T"]+1 elseif data.reason==12 then GAMEMODE.CSVictories["CT"]=GAMEMODE.CSVictories["CT"]+1 end
		if (data.reason==11 and LocalPlayer().Role=="t") or (data.reason==12 and LocalPlayer().Role=="ct") then
			LocalPlayer().Money=LocalPlayer().Money+GAMEMODE.CSRewards["Win"]
			GAMEMODE.CSRewards["Win"]=math.max(GAMEMODE.CSRewards["Win"]-500,1500)
			GAMEMODE.CSRewards["Lose"]=math.max(GAMEMODE.CSRewards["Lose"]-500,1500)
		else
			LocalPlayer().Money=LocalPlayer().Money+GAMEMODE.CSRewards["Lose"]
			GAMEMODE.CSRewards["Lose"]=math.min(GAMEMODE.CSRewards["Lose"]+500,2500)
			GAMEMODE.CSRewards["Win"]=math.max(GAMEMODE.CSRewards["Win"]+500,4000)
		end
	end
	GAMEMODE.MVP=net.ReadEntity()
	GAMEMODE:DisplayEndRoundBoard(data)

	local pitch = math.random(80, 120)
	if IsValid(LocalPlayer()) then
		LocalPlayer():EmitSound("ambient/alarms/warningbell1.wav", 100, pitch)
		if customEndSounds[data.reason] then
			LocalPlayer():EmitSound(customEndSounds[data.reason], 100)
		end
	end
end) 