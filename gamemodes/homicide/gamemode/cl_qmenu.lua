
surface.CreateFont( "MersRadial_QM" , {
	font = "coolvetica",
	size = math.ceil(ScrW() / 38),
	weight = 500,
	antialias = true,
	italic = false
})

surface.CreateFont( "MersRadialSmall_QM" , {
	font = "coolvetica",
	size = math.ceil(ScrW() / 80),
	weight = 100,
	antialias = true,
	italic = false
})

local ments

local radialOpen = false
local prevSelected, prevSelectedVertex

--[[net.Receive("hmcd_ghost_qmenu",function()
	local Remove,Victim,Name=tobool(net.ReadBit()),net.ReadEntity(),net.ReadString()
	if Remove then
		LocalPlayer().GhostMarked=false
		LocalPlayer().VictimName=nil
		LocalPlayer().GhostPanelPos=nil
	else
		LocalPlayer().GhostMarked=true
		LocalPlayer().VictimName=Name
		local RoundNum=GAMEMODE.RoundNum
		local nexttrace=0
		hook.Add("Think","Hunting",function()
			if GAMEMODE.RoundNum!=RoundNum then 
				hook.Remove("Think","Hunting")
				LocalPlayer().GhostMarked=false
				LocalPlayer().VictimName=nil
				LocalPlayer().GhostPanelPos=nil
				return
			end
			if nexttrace<CurTime() then
				nexttrace=CurTime()+1
				if IsValid(Victim) and IsValid(Victim:GetRagdollEntity()) then
					local body=Victim:GetRagdollEntity()
					local tr=util.QuickTrace(LocalPlayer():EyePos(),LocalPlayer():WorldToLocal(body:GetPos()),{LocalPlayer(),body})
					if not(tr.Hit or Victim:Alive()) then
						hook.Remove("Think","Hunting")
						LocalPlayer().GhostMarked=false
						LocalPlayer().VictimName=nil
						LocalPlayer().GhostPanelPos=nil
					end
				end
			end
		end)
	end
end)]]

function GM:OpenRadialMenu(elements)
	if not(LocalPlayer():Alive())then return end
	if LocalPlayer().Unconscious then return end
	radialOpen = true
	gui.EnableScreenClicker(true)
	ments = elements or {}
	prevSelected = nil
end

function GM:CloseRadialMenu()
	radialOpen = false
	gui.EnableScreenClicker(false)
end

local function getSelected()
	local mx, my = gui.MousePos()
	local sw,sh = ScrW(), ScrH()
	local total = #ments
	local w = math.min(sw * 0.45, sh * 0.45)
	local h = w
	local sx, sy = sw / 2, sh / 2
	local x2,y2 = mx - sx, my - sy
	local ang = 0
	local dis = math.sqrt(x2 ^ 2 + y2 ^ 2)
	if dis / w <= 1 then
		if y2 <= 0 && x2 <= 0 then
			ang = math.acos(x2 / dis)
		elseif x2 > 0 && y2 <= 0 then
			ang = -math.asin(y2 / dis)
		elseif x2 <= 0 && y2 > 0 then
			ang = math.asin(y2 / dis) + math.pi
		else
			ang = math.pi * 2 - math.acos(x2 / dis)
		end
		return math.floor((1 - (ang - math.pi / 2 - math.pi / total) / (math.pi * 2) % 1) * total) + 1
	end
end

function GM:RadialMousePressed(code, vec)
	if radialOpen then
		local selected = getSelected()
		if selected && selected > 0 && code == MOUSE_LEFT then
			if selected && ments[selected] then
				if(ments[selected].Code=="drop_item") and not(LocalPlayer():GetNWBool("GhostSuiciding"))then
					RunConsoleCommand("hmcd_dropwep")
				elseif(ments[selected].Code=="drop_equipment")then
					self:OpenEquipmentDropMenu()
				elseif(ments[selected].Code=="unload_weapon") and not(LocalPlayer():GetNWBool("GhostSuiciding"))then
					RunConsoleCommand("hmcd_unloadweapon")
				elseif(ments[selected].Code=="request_airstrike")then
					RunConsoleCommand("hmcd_airstrike")
				elseif(ments[selected].Code=="request_airstrike2")then
					RunConsoleCommand("hmcd_headcrabairstrike")
				elseif(ments[selected].Code=="drop_ammo")then
					GAMEMODE:OpenAmmoDropMenu()
				elseif(ments[selected].Code=="attach")then
					GAMEMODE:OpenAttachmentMenu()
				else
					RunConsoleCommand("hmcd_taunt", ments[selected].Code)
				end
			end
		end
		self:CloseRadialMenu()
	end
end

local elements
local function addElement(transCode, code)
	local t = {}
	t.TransCode = transCode
	t.Code = code
	table.insert(elements, t)
end

local Ribbon,Medal=nil,nil

concommand.Add("+menu", function (client, com, args, full)
	if client:Alive() && client:Team() == 2 then
		if not(client.HMCD_Merit)then client.HMCD_Merit=0 end
		if not(client.HMCD_Demerit)then client.HMCD_Demerit=1 end
		if not(client.HMCD_Experience)then client.HMCD_Experience=0 end
		
		local rib,med=client:GetAward()
		if((rib)and(med))then
			Ribbon=Material(rib)
			Medal=Material(med)
		end
	
		elements = {}
		if not(LocalPlayer().JawBroken)then
			if GAMEMODE.Roles[LocalPlayer():SteamID()]!="combine" then
				addElement("Help", "help")
				if not(LocalPlayer().Role=="rebel") then
					addElement("Random", "random")
				else
					addElement("Killrebel", "killrebel")
				end
				addElement("Happy", "happy")
				addElement("Morose", "morose")
				addElement("Response", "response")
			else
				if LocalPlayer():GetNWString("Class")!="cp" then
					addElement("Target", "target")
					addElement("Kill", "kill")
					addElement("Clear", "clear")
					addElement("Yes", "yes")
					addElement("Inbound", "inbound")
				else
					addElement("Yes_CP","yes_cp")
					addElement("Backup","backup")
					addElement("Inposition","inposition")
					addElement("Kill_CP","kill_cp")
					addElement("Holdposition","holdposition")
				end
			end
		end
		if(table.Count(client.Equipment)>0)then
			addElement("Drop Equipment","drop_equipment")
		end
		if client:GetNWBool("Leader") and client:GetNWBool("AirstrikesLeft") then
			addElement("Request An Airstrike","request_airstrike")
			addElement("Request An Airstrike2","request_airstrike2")
		end
		local Wep=client:GetActiveWeapon()
		if(IsValid(Wep))then
			if not(client:GetNWBool("GhostSuiciding")) then
				if((Wep.CommandDroppable)and not((GAMEMODE.SHTF)and(Wep.SHTF_NoDrop)))then
					addElement("Drop Item","drop_item")
				end
				if Wep:Clip1()>0 and Wep:GetClass()!="wep_jack_hmcd_fakepistol" then
					addElement("Unload Weapon","unload_weapon")
				end
			end
			local Num=0
			for amm,fuck in pairs(HMCD_AmmoWeights)do
				local Amt=client:GetAmmoCount(amm) or 0
				Num=Num+Amt
			end
			if(Num>0)then
				addElement("Drop Ammo","drop_ammo")
			end
			if(client.Murderer) and (Wep.ClassName=="wep_jack_hmcd_fakepistol")then
				addElement("Hero","hero")
			end
			if not(client.JawBroken)then
				if(client.Role=="killer")then
					addElement("Villain","villain")
				elseif(Wep.ClassName=="wep_jack_hmcd_smallpistol")then
					addElement("Hero","hero")
				elseif(client.Role=="Police") then
					addElement("Police","police")
				end
			end
			local attFound=false
			local atts={}
			if Wep.Attachments and Wep.Attachments["Owner"] then
				for attachment,info in pairs(Wep.Attachments["Owner"]) do
					if info.num then
						if Wep:GetNWBool(attachment) and not(attFound) then
							attFound=true
							addElement("Attach","attach")
						end
						table.insert(atts,info.num)
					end
				end
			end
			if not(attFound) then
				if client.Equipment then
					for i,attachment in pairs(atts) do
						if(client.Equipment[HMCD_EquipmentNames[attachment]])then
							addElement("Attach","attach")
							break
						end
					end
				end
			end
		end
		if(LocalPlayer().GhostMarked) then
			if not(LocalPlayer().GhostPanelPos) then LocalPlayer().GhostPanelPos=math.random(1,#elements) end
			local t = {}
			t.TransCode = "Ghost_Victim"
			t.Code = "Ghost_Victim"
			table.insert(elements,LocalPlayer().GhostPanelPos,t)
		end
		GAMEMODE:OpenRadialMenu(elements)
	end
end)

concommand.Add("-menu", function (client, com, args, full)
	GAMEMODE:RadialMousePressed(MOUSE_LEFT)
end)

local tex = surface.GetTextureID("VGUI/white.vmt")

local function drawShadow(n,f,x,y,color,pos)
	draw.DrawText(n,f,x + 1,y + 1,color_black,pos)
	draw.DrawText(n,f,x,y,color,pos)
end
local function drawTextShadow(t,f,x,y,c,px,py)
	draw.SimpleText(t,f,x + 1,y + 1,Color(0,0,0,c.a),px,py)
	draw.SimpleText(t,f,x - 1,y - 1,Color(255,255,255,math.Clamp(c.a*.25,0,255)),px,py)
	draw.SimpleText(t,f,x,y,c,px,py)
end
local circleVertex

local fontHeight = draw.GetFontHeight("MersRadial")
local randomsymbols={'̠','̡','̢','̣','̤','̥','̦','̧','̨','̩','̪','̫','̬','̭','̮','̯','̰','̱','̲','̳','̴','̵','̶','̷','̸','̹','̺','̻','̼','̽','̾','̿','̀','́','͂','̓','̈́','ͅ','͆','͇','͈','͉','͊','͋','͌','͍','͎','͏','͐','͑','͒','͓','͔','͕','͖','͗','͘','͙','͚','͛','͜','͝','͞','͟','͠','͡','͢','ͣ','ͤ','ͥ','ͦ','ͧ','ͨ','ͩ','ͪ','ͫ','ͬ','ͭ','ͮ','ͯ','Ͱ','ͱ','Ͳ','ͳ','ʹ','͵','Ͷ','ͷ','͸','͹','ͺ','ͻ','ͼ','ͽ',';','Ϳ','΀','΁','΂','΃','΄','΅','Ά','·','Έ','Ή','Ί','΋','Ό','΍','Ύ','Ώ','ΐ','Α','Β','Γ','Δ','Ε','Ζ','Η','Θ','Ι','Κ','Λ','Μ','Ν','Ξ','Ο','Π','Ρ','΢','Σ','Τ','Υ','Φ','Χ','Ψ','Ω','Ϊ','Ϋ','ά','έ','ή','ί','ΰ','α','β','γ','δ','ε','ζ','η','θ','ι','κ','λ','μ','ν','ξ','ο','π','ρ','ς','σ','τ','υ','φ','χ','ψ','ω','ϊ','ϋ','ό','ύ','ώ','Ϗ','ϐ','ϑ','ϒ','ϓ','ϔ','ϕ','ϖ','ϗ','Ϙ','ϙ','Ϛ','ϛ','Ϝ','ϝ','Ϟ','ϟ','Ϡ','ϡ','Ϣ','ϣ','Ϥ','ϥ','Ϧ','ϧ','Ϩ','ϩ','Ϫ','ϫ','Ϭ'}

function GM:DrawRadialMenu()
	if radialOpen then
		local sw,sh = ScrW(), ScrH()
		local total = #ments
		local w = math.min(sw * 0.45, sh * 0.45)
		local h = w
		local sx, sy = sw / 2, sh / 2

		local selected = getSelected() or -1


		if !circleVertex then
			circleVertex = {}
			local max = 50
			for i = 0, max do
				local vx, vy = math.cos((math.pi * 2) * i / max), math.sin((math.pi * 2) * i / max)

				table.insert(circleVertex, {x = sx + w* 1 * vx, y= sy + h* 1 * vy})
			end
		end

		surface.SetTexture(tex)
		local defaultTextCol = color_white
		if selected <= 0 || selected ~= selected then
			surface.SetDrawColor(20,20,20,180)
		else
			surface.SetDrawColor(20,20,20,120)
			defaultTextCol = Color(150,150,150)
		end
		surface.DrawPoly(circleVertex)

		local add = math.pi * 1.5 + math.pi / total
		local add2 = math.pi * 1.5 - math.pi / total

		for k,ment in pairs(ments) do
			local x,y = math.cos((k - 1) / total * math.pi * 2 + math.pi * 1.5), math.sin((k - 1) / total * math.pi * 2 + math.pi * 1.5)

			local lx, ly = math.cos((k - 1) / total * math.pi * 2 + add), math.sin((k - 1) / total * math.pi * 2 + add)

			local textCol = defaultTextCol
			if(ment.Code=="villain")then
				textCol=Color(200,10,10,150)
			elseif(ment.Code=="hero") or (ment.Code=="police")then
				textCol=Color(20,200,255,150)
			end
			if selected == k then
				local vertexes = prevSelectedVertex -- uhh, you mean VERTICES? Dumbass.

				if prevSelected != selected then
					prevSelected = selected
					vertexes = {}
					prevSelectedVertex = vertexes
					local lx2, ly2 = math.cos((k - 1) / total * math.pi * 2 + add2), math.sin((k - 1) / total * math.pi * 2 + add2)

					table.insert(vertexes, {x = sx, y = sy})

					table.insert(vertexes, {x = sx + w* 1 * lx2, y= sy + h* 1 * ly2})

					local max = math.floor(50 / total)
					for i = 0, max do
						local addv = (add - add2) * i / max + add2
						local vx, vy = math.cos((k - 1) / total * math.pi * 2 + addv), math.sin((k - 1) / total * math.pi * 2 + addv)

						table.insert(vertexes, {x = sx + w* 1 * vx, y= sy + h* 1 * vy})
					end

					table.insert(vertexes, {x = sx + w* 1 * lx, y= sy + h* 1 * ly})

				end

				surface.SetTexture(tex)
				surface.SetDrawColor(20,120,255,120)
				if(ment.Code=="happy")then
					surface.SetDrawColor(255,20,20,120)
				elseif((ment.Code=="drop_item")or(ment.Code=="drop_armor")or(ment.Code=="drop_ammo") or (ment.Code=="hmcd_attach"))then
					surface.SetDrawColor(50,50,50,120)
				end
				surface.DrawPoly(vertexes)

				textCol = color_white
				if(ment.Code=="villain")then
					textCol=Color(255,50,50,255)
				elseif(ment.Code=="hero")then
					textCol=Color(100,225,255,255)
				end
			end
			local Main,Sub=Translate("voice" .. ment.TransCode),Translate("voice" .. ment.TransCode .. "Description")
			if(ment.TransCode=="Ghost_Victim")then
				local maintext
				if LocalPlayer().VictimName==nil then
					maintext="WELL DONE" 
				else
					maintext="Kill "..LocalPlayer().VictimName
				end
				local chars=string.Explode("",maintext)
				for i,ch in pairs(chars) do
					if math.random(1,10)==1 then
						chars[i]=table.Random(randomsymbols)
					end
				end
				maintext=string.Implode("",chars)
				local amt,strangestring=math.random(1,50),""
				for i=1,amt do
					strangestring=strangestring..table.Random(randomsymbols)
				end
				Main=maintext;Sub=strangestring
			end
			drawShadow(Main, "MersRadial_QM", sx + w * 0.6 * x, sy + h * 0.6 * y - fontHeight / 3,textCol, 1)
			if LocalPlayer().Role=="freeman" and (ment.Code=="happy" or ment.Code=="morose" or ment.Code=="response" or ment.Code=="random" or ment.Code=="help") then Sub="..." end
			drawShadow(Sub, "MersRadialSmall_QM", sx + w * 0.6 * x, sy + h * 0.6 * y + fontHeight / 2, textCol, 1)
		end
		local W,H=ScrW(),ScrH()
		local Vary=math.sin(CurTime()*10)/2+.5
		local BarSize,BarLow=W*.75,H*.01-10
		local col,Name=LocalPlayer():GetPlayerColor(),LocalPlayer():GetNWString("bystanderName")
		if((Name=="Murderer")or(Name=="Traitor"))then
			col=Color(255*Vary,0,0)
		else
			col=Color(col.x*255,col.y*255,col.z*255)
		end
		surface.SetDrawColor(col)
		surface.SetFont("MersRadial_QM")
		local Size=surface.GetTextSize(Name)
		drawTextShadow(Name,"MersRadial_QM",W/100,BarLow+10,col,0,TEXT_ALIGN_TOP)
		
		local shouldDraw=hook.Run("HUDShouldDraw","MurderPlayerType")
		if shouldDraw!=false then
			if not(LocalPlayer().QName) then
				local Role=LocalPlayer().Role
				if Name=="" and self.Mode=="Zombie" and Role=="killer" then
					LocalPlayer().QName=""
				else
					local modeTrans,trans=Translate(Role,nil,self.MainMode,self.Mode),Translate(Role)
					if modeTrans then
						LocalPlayer().QName=modeTrans
					else
						LocalPlayer().QName=trans
					end
				end
			end
			drawTextShadow(LocalPlayer().QName,"MersRadial_QM",W/100,BarLow+60,col,0,TEXT_ALIGN_TOP)
		end
		if((Ribbon)and(Medal))then
			local txt="XP: "..tostring(LocalPlayer().HMCD_Experience).."  SK: "..tostring(math.Round(LocalPlayer().HMCD_Merit/LocalPlayer().HMCD_Demerit,2)*100)
			draw.SimpleText(txt,"DermaDefault",ScrW()*.9-61,ScrH()*.3-136,Color(255,255,255,150),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
			surface.SetDrawColor(255,255,255,150)
			surface.SetMaterial(Ribbon)
			surface.DrawTexturedRect(ScrW()*.9-128,ScrH()*.3-128,256,256)
			surface.SetMaterial(Medal)
			surface.DrawTexturedRect(ScrW()*.9-128,ScrH()*.3-128,256,256)
		end
	end
end

