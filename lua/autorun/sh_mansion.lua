--AddCSLuaFile("gamemodes/homicide/gamemode/init.lua")
AddCSLuaFile()
if(SERVER)then
util.AddNetworkString("mansion_client_tea")
util.AddNetworkString("mansion_client_pencil")
util.AddNetworkString("mansion_server_requestdots")--
util.AddNetworkString("mansion_server_book")
util.AddNetworkString("mansion_client_book")

	util.AddNetworkString("mansion_dcolour")
	util.AddNetworkString("mansion_dscale")
	util.AddNetworkString("mansion_pencil_clear")
end 
CreateConVar( "MANSION_allowraining", 1, bit.bor(FCVAR_SERVER_CAN_EXECUTE), "Then set to 0 disables rain, can improve server lag (Archives its state)",0,1)
CreateConVar( "MANSION_allowdrawing", 1, bit.bor(FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE), "Then set to 0 restricts drawing on sheets, can improve server lag (Archives its state)",0,1)
local MANSION_tex_ru = Material( "flags16/ru.png" )
local MANSION_tex_en = Material( "flags16/england.png" )
 
MANSION_TEA_ALLOWEDCLASS={ 					--HasValue()??? ofc no. OPTIMIZE
["ent_jack_hmcd_fooddrinkbig"]=true,
["ent_jack_hmcd_fooddrink"]=true,
["ent_jack_hmcd_painpills"]=true,
["ent_zac_hmcd_whiskas"]=true,
} 
MANSION_TEA_TRANSLATE={														--The heck is this...?
	--Little asses
	["models/foodnhouseholditems/mcdburgerbox.mdl"]={["pa"]=8,["bo"]=5,["ha"]=0,["bl"]=0,["ne"]=2},
	["models/foodnhouseholditems/chipsfritos.mdl"]={["pa"]=0,["bo"]=2,["ha"]=3,["bl"]=1,["ne"]=0},
	["models/foodnhouseholditems/chipslays5.mdl"]={["pa"]=0,["bo"]=2,["ha"]=1,["bl"]=0,["ne"]=3},
	["models/foodnhouseholditems/chipslays3.mdl"]={["pa"]=7,["bo"]=5,["ha"]=0,["bl"]=0,["ne"]=1},
	["models/foodnhouseholditems/mcdfrenchfries.mdl"]={["pa"]=0,["bo"]=5,["ha"]=0,["bl"]=1,["ne"]=5},
	["models/jordfood/prongleclosedfilledgreen.mdl"]={["pa"]=0,["bo"]=5,["ha"]=0,["bl"]=0,["ne"]=2},
	["models/foodnhouseholditems/mcddrink.mdl"]={["pa"]=2,["bo"]=5,["ha"]=1,["bl"]=5,["ne"]=3},
	["models/foodnhouseholditems/juicesmall.mdl"]={["pa"]=10,["bo"]=6,["ha"]=0,["bl"]=0,["ne"]=0}, --Healthy one
	["models/jorddrink/7upcan01a.mdl"]={["pa"]=0,["bo"]=5,["ha"]=0,["bl"]=6,["ne"]=1},	--Anti-bleeding 
	["models/jorddrink/barqcan1a.mdl"]={["pa"]=3,["bo"]=7,["ha"]=2,["bl"]=1,["ne"]=2},
	["models/jorddrink/cozcan01a.mdl"]={["pa"]=9,["bo"]=0,["ha"]=1,["bl"]=0,["ne"]=1},
	["models/jorddrink/crucan01a.mdl"]={["pa"]=0,["bo"]=0,["ha"]=0,["bl"]=2,["ne"]=8},	--Strong neutralizer
	["models/jorddrink/dewcan01a.mdl"]={["pa"]=0,["bo"]=10,["ha"]=0,["bl"]=0,["ne"]=4},	--Nice calories
	["models/jorddrink/foscan01a.mdl"]={["pa"]=5,["bo"]=0,["ha"]=0,["bl"]=0,["ne"]=3},
	["models/jorddrink/heican01a.mdl"]={["pa"]=0,["bo"]=0,["ha"]=4,["bl"]=0,["ne"]=4},	--For harm tea
	["models/jorddrink/mongcan1a.mdl"]={["pa"]=5,["bo"]=0,["ha"]=0,["bl"]=0,["ne"]=6},
	["models/jorddrink/pepcan01a.mdl"]={["pa"]=0,["bo"]=5,["ha"]=0,["bl"]=0,["ne"]=0},
	["models/jorddrink/redcan01a.mdl"]={["pa"]=0,["bo"]=3,["ha"]=0,["bl"]=0,["ne"]=2},	 
	["models/jorddrink/sprcan01a.mdl"]={["pa"]=0,["bo"]=3,["ha"]=3,["bl"]=0,["ne"]=1},
	--Big deals
	["models/foodnhouseholditems/applejacks.mdl"]={["pa"]=1,["bo"]=5,["ha"]=1,["bl"]=0,["ne"]=3},
	["models/foodnhouseholditems/cheerios.mdl"]={["pa"]=0,["bo"]=5,["ha"]=5,["bl"]=0,["ne"]=3},
	["models/foodnhouseholditems/kellogscornflakes.mdl"]={["pa"]=7,["bo"]=4,["ha"]=6,["bl"]=0,["ne"]=2},
	["models/foodnhouseholditems/miniwheats.mdl"]={["pa"]=2,["bo"]=5,["ha"]=0,["bl"]=0,["ne"]=0},
	["models/foodnhouseholditems/bagette.mdl"]={["pa"]=0,["bo"]=7,["ha"]=0,["bl"]=6,["ne"]=1},
	["models/jordfood/atun.mdl"]={["pa"]=0,["bo"]=6,["ha"]=0,["bl"]=4,["ne"]=3},
	["models/jordfood/cakes.mdl"]={["pa"]=3,["bo"]=0,["ha"]=5,["bl"]=0,["ne"]=1},
	["models/jordfood/can.mdl"]={["pa"]=0,["bo"]=7,["ha"]=0,["bl"]=0,["ne"]=2},
	["models/jordfood/canned_burger.mdl"]={["pa"]=0,["bo"]=0,["ha"]=3,["bl"]=0,["ne"]=4},		--Neut
	["models/jordfood/capncrunch.mdl"]={["pa"]=2,["bo"]=1,["ha"]=0,["bl"]=0,["ne"]=5},
	["models/jordfood/chili.mdl"]={["pa"]=0,["bo"]=5,["ha"]=6,["bl"]=0,["ne"]=5},
	["models/jordfood/girlscout_cookies.mdl"]={["pa"]=0,["bo"]=2,["ha"]=1,["bl"]=4,["ne"]=4},
	["models/foodnhouseholditems/cola.mdl"]={["pa"]=1,["bo"]=0,["ha"]=3,["bl"]=0,["ne"]=3},
	["models/foodnhouseholditems/juice.mdl"]={["pa"]=1,["bo"]=6,["ha"]=1,["bl"]=0,["ne"]=3},
	["models/foodnhouseholditems/milk.mdl"]={["pa"]=0,["bo"]=0,["ha"]=0,["bl"]=9,["ne"]=5},
	["models/jorddrink/the_bottle_of_water.mdl"]={["pa"]=18,["bo"]=0,["ha"]=0,["bl"]=0,["ne"]=6},	--Neutralizer+pain
	--Other
	["models/w_models/weapons/w_eq_painpills.mdl"]={["pa"]=25,["bo"]=0,["ha"]=-10,["bl"]=0,["ne"]=10}

}

		local Con=GetConVar( "MANSION_allowdrawing" )
		MANSION_ALLOWEDDRAWING=Con:GetBool()
	cvars.AddChangeCallback( "MANSION_allowdrawing", function(newValue)
		local Con=GetConVar( "MANSION_allowdrawing" )
		MANSION_ALLOWEDDRAWING=Con:GetBool()
	end)

if(CLIENT)then
	CreateClientConVar( "mansion_sheetdots", 150, true, false, "(IT IS NOT RECOMMENDED TO SET THIS HIGHER THAN 2000.) This sets your dot count to the given value, uses in drawable sheet of paper")--This cares about people"s hardware, so its not gonna explode while drawing something
	CreateClientConVar( "mansion_newbie", 1, true, false, "Set this to 1 again",0,1)
end
 
net.Receive("mansion_client_pencil",function()
		if(CLIENT)then
		 timer.Simple(0.1, function()
		 	local col = string.ToColor(LocalPlayer():GetActiveWeapon():GetDColour())
			if(LocalPlayer():GetViewModel()~=nil)then
			LocalPlayer():GetViewModel():SetColor(col or Color(0,0,0))
			end
		 end)
		 
			timer.Simple(1, function()
				 if(MANSION_ALLOWEDDRAWING==false)then 
					
						LocalPlayer():ChatPrint("Must inform you.")
				
					  timer.Simple(3, function()
						
							LocalPlayer():ChatPrint("You can not draw with it because of the server lag.")
						
					  end)
				  end
			end)
		end
end)
--=================================================--
net.Receive("mansion_pencil_clear",function()
if(CLIENT)then
Entity(net.ReadInt(11)):GetViewModel():SetColor(Color(255,255,255))
	end 
end)

net.Receive("mansion_client_book",function()
	--chat.AddText( Color( 0, 127, 31 ),MANSION_idiotBOOKS[math.random(#MANSION_idiotBOOKS)])
	
	local text =MANSION_idiotBOOKS[math.random(#MANSION_idiotBOOKS)]
	local words = string.ToTable(MANSION_idiotBOOKS[math.random(#MANSION_idiotBOOKS)])
		local richtext = vgui.Create("RichText")
		richtext:SetSize(#words*22,32)
		richtext:SetPos(math.random(300,ScrW()-300),math.random(300,ScrH()-300))

		-- Red text
		richtext:InsertColorChange(0, 127, 31, 255)
		richtext:SetVerticalScrollbarEnabled(false)
			
		
		local delay = 0

		-- Display each word in half second interval
		for w, txt in pairs(words) do
				if(w == #words)then
				timer.Simple(w*0.1*4, function()
					richtext:Remove()
				end)
				end
			if(w == 1) then delay = 0.1
			else delay = (w-1)*0.1 end

			timer.Simple(delay, function()
			
				richtext:AppendText(txt.." ")
				richtext:InsertFade(2, 1)	-- Sustain for 2 seconds while fading out after 1 second
				
				--richtext:SetBGColor(Color(0, 0, 0))
				richtext:SetFontInternal("DermaLarge")
			
			end)

		end	
end)
net.Receive("mansion_server_book",function()
	local ply = Entity(net.ReadInt(11))
	local rec = GAMEMODE.SHITLIST[ply:SteamID()] or 0
		if(rec>100)then
			ply:SetDSP(math.random(0,130))
			net.Start("mansion_client_book")
			net.Send(ply)
		end

end)

net.Receive("mansion_server_requestdots",function()
if not(MANSION_ALLOWEDDRAWING)then return end
local PLY = net.ReadInt(11)
local DTC = net.ReadInt(12)
local OBJ = net.ReadInt(13)

local e_obj=Entity(OBJ)

	local	DD	=	e_obj.DrawData
	local	CD	=	e_obj.ColorData
	local	SD	=	e_obj.ScaleData 
	local 	dif	=	#DD-DTC
	for i=1, DTC do 
		if(DD[0]~=nil and CD[0]~=nil and SD[0]~=nil)then
		local leg = i+dif
		print("+")
		
						net.Start("mansion_sheet"..OBJ) --expensive??? pfffttt what are you barking about?
						net.WriteString( DD[leg] )
						net.WriteString( CD[leg] )
						net.WriteInt( SD[leg], 4 )
						net.WriteInt( 0, 3 ) 
						net.Send(Entity(PLY))
					
		end
	end
--[[

]]

end)
--==============================================--


if(CLIENT)then
	if( engine.ActiveGamemode() ~= "homicide" or game.GetMap() ~= "mu_hmcd_mansion")then return end
	MANSION_NEXTREAD = CurTime()
	MANSION_BOOKS={
	"..If you look away from doors, they will close..",
	"..Delicious food is the key to a good mood!..", 
	"..One day, the penguin fell ill and could not continue working at the station..",	
	"..Books are a great source of true information..",		
	"..The feeling of guilt is one of the most terrible feelings..",	
	"..She said she wouldn't be late..",	
	"..Generals always prepare for the last war..",	
	"..Recipe for a great sandwich: between two bread slices put tomato ring and a few slices of fried chiken on top of it, then cover it with ketchup..",		
	"..When I tried to dispel this darkness, it came to such suffering that my heart will never heal as long as I remember this terrible time..",
	"..There is no lightswitches..",
	"..But now the playing rays burst out again — and the mighty luminary rises merrily and majestically, as if taking flight..",
	"..Try to avoid letting Harm in your tea..",
	"..Despite the fact that Bleed sounds very dangerous, it is very useful in your tea because it can cure bleeding..",
	"..If you drink tea with Pain, you won't receive any pain or suffer..",
	"..Use of strong neutralizers will affect the tea stats..",
	"..Harm usually associates with suffer, bleeding, pain and death..",
	"..In some cases Harm can actually be beneficial as it can provide drinker with mid-air jump..",
	}
	MANSION_idiotBOOKS={
	"You must go through",
	"Thanks for your damage",
	"You killed me",
	""
	}

	hook.Add( "KeyPress", "mansion_books", function(PLY,KEY)
	if not(IsValid(PLY:GetEyeTrace().Entity))then return end
	local MODEL = PLY:GetEyeTrace().Entity:GetClass() 
	local DIST = PLY:GetEyeTrace().HitPos:DistToSqr(PLY:GetPos())

		if(KEY==IN_USE and MODEL=="func_brush" and DIST<10000 and MANSION_NEXTREAD<CurTime() and PLY:Alive())then		--Anyways
		if( engine.ActiveGamemode() ~= "homicide" or game.GetMap() ~= "mu_hmcd_mansion")then return end	---DONT FOR-GET
		chat.AddText( Color( 0, 127, 31 ), "You took the book from shelf and begin to read.") 
		MANSION_NEXTREAD = CurTime()+3
			timer.Simple(1,function()
			if(math.random(0,5)>0)then 
			local Line = math.random(#MANSION_BOOKS)
			if(Line==PrevLine)then  
				if(Line<#MANSION_BOOKS)then 
					Line=Line+1 
				else
					Line=Line-1
				end
			end
			PrevLine=Line
			
						
				chat.AddText( Color( 0, 127, 31 ), MANSION_BOOKS[Line])
						net.Start("mansion_server_book")
						net.WriteInt(LocalPlayer():EntIndex(),11)
						net.SendToServer()
				elseif(PLY:Health()>30)then 
					chat.AddText( Color( 0, 127, 31 ),".."..HMCD_Tips[math.random(#HMCD_Tips)]..".")
				else
					chat.AddText( Color( 0, 127, 31 ),"..You really shouldn't read books when you're dying..")
				end
			
			end) 
		end
		
	end)
	
	
		
end 

hook.Add( "ClientSignOnStateChanged", "mansion_newbie_unique", function(id,old,new)
	if( engine.ActiveGamemode() ~= "homicide" or game.GetMap() ~= "mu_hmcd_mansion")then return end ---DONT FORGET DONT FORGET DONT FORGET DONT FORGET DONT FORGET DONT FORGET DONT FORGET DONT FORGET
if(CLIENT)then

	local Con=GetConVar( "mansion_sheetdots" )
	MANSION_DotCount=Con:GetInt()--About time
	cvars.AddChangeCallback( "mansion_sheetdots", function(newValue)
		local Con=GetConVar( "mansion_sheetdots" ) 
		MANSION_DotCount=Con:GetInt()--Care about your pc, nya~
	end)
	
	
	MANSION_CHECK_SHEETLIST={}----
	 
	MANSION_nextsheet=0
	local Con=GetConVar( "mansion_newbie" )
	MANSION_NEWBIE=Con:GetBool()
		if(new == SIGNONSTATE_FULL)then
			function PencilViewModel( viewmod, old, new ) 
				if(old=="models/mu_hmcd_mansion/weapon_pencils/v_pencil.mdl" or old=="models/mu_hmcd_mansion/cup.mdl")then
						viewmod:SetColor(Color(255,255,255))
				end
			end		 

	function TryDoRain()
		if(!MANSION_raining)then return nil end
		
	end
--[[
	hook.Add("CalcView", "mansion_view_calc", function(ply,pos,angles,fov,znear,zfar)
		if(MANSION_VIEW_POS==nil)then
			MANSION_VIEW_POS=Vector(26, -1693 ,64)
		else		
		if(LocalPlayer():KeyDown(IN_FORWARD))then
			
			local nextpos=MANSION_VIEW_POS+Vector((LocalPlayer():GetAimVector()*1)[1],(LocalPlayer():GetAimVector()*1)[2],0) 
			local ppos = nextpos-Vector(0,0,70)
			local tr = {
				start = ppos,
				endpos = ppos,
				mins = Vector( -16, -16, 20 ),
				maxs = Vector( 16, 16, 71 )
			}

			local hullTrace = util.TraceHull( tr )
			if not( hullTrace.Hit ) then
				MANSION_VIEW_POS=nextpos
			else
				local hpos = hullTrace.HitPos
				print(hpos)
				local qtr =  util.QuickTrace(Vector(MANSION_VIEW_POS[1],MANSION_VIEW_POS[2],hpos[3]),hpos,nil)
				local norm = qtr.HitNormal
				MANSION_VIEW_POS=MANSION_VIEW_POS+norm*1
			end
		end
		local tr = util.QuickTrace(MANSION_VIEW_POS-Vector(0,0,50),Vector(0,0,-21),nil)
			if(tr.Hit)then
				MANSION_VIEW_POS[3]=(tr.HitPos+Vector(0,0,70))[3]
			else 
				MANSION_VIEW_POS=MANSION_VIEW_POS-Vector(0,0,1)
			end
		local view = {
			origin = MANSION_VIEW_POS,
			angles = angles,
			fov = fov,
			drawviewer = false
		}

			return view							
			end 


	end)
	]]
	hook.Add( "OnViewModelChanged", "hmcd_mansion_pencils_viewmodel", PencilViewModel ) --That way your hand dont get dirty during drawing process		
	 
		local function WorldToScreen(vWorldPos,vPos,vScale,aRot)
		local vWorldPos=vWorldPos-vPos
		vWorldPos:Rotate(Angle(0,-aRot.y,0))
		vWorldPos:Rotate(Angle(-aRot.p,0,0))
		vWorldPos:Rotate(Angle(0,0,-aRot.r))
		return vWorldPos.x/vScale,(-vWorldPos.y)/vScale
	end
	------------------------------------------------------------
		hook.Add("PostDrawOpaqueRenderables", "mansion_pencil_point", function()			--Draw aimpoint dot
		local ENT=LocalPlayer():GetEyeTrace().Entity
		if(IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass()=="wep_hmcd_mansion_pencils")then
			 Mode = LocalPlayer():GetActiveWeapon():GetMode()
		end
		if(IsValid(ENT) and IsValid(LocalPlayer():GetActiveWeapon()) and ENT:GetClass()=="ent_hmcd_mansion_sheet" and LocalPlayer():GetActiveWeapon():GetClass()=="wep_hmcd_mansion_pencils" and Mode==true)then
			
			local lookAtX,lookAtY = WorldToScreen(LocalPlayer():GetEyeTrace().HitPos or Vector(0,0,0),ENT:GetPos()+ENT:GetAngles():Up()*1, 0.1, ENT:GetAngles())
				local Dscale = LocalPlayer():GetActiveWeapon().DScale or 4
				cam.Start3D2D(ENT.Pos + ENT.Angle:Up() *0.1 , ENT.Angle , 0.1)
				surface.SetDrawColor(0, 0, 0, 150)
				surface.DrawRect(math.Round(-lookAtX),math.Round(-lookAtY),Dscale,Dscale) 
				cam.End3D2D()  
			end
		end)
		------------------------------------------------------------
		hook.Add("PreDrawHalos", "mansion_tea_halo", function()	
			local PLY = LocalPlayer()
			local trace =	PLY:GetEyeTrace()
			if(IsValid(trace.Entity) and IsValid(PLY:GetActiveWeapon()) and PLY:GetActiveWeapon():GetClass()=="wep_hmcd_mansion_cup")then
				local class = 	trace.Entity:GetClass() 
				if(MANSION_TEA_ALLOWEDCLASS[class] and trace.HitPos:DistToSqr(PLY:EyePos())<10000)then
					halo.Add({trace.Entity},Color( 0, 127, 31 ),5,5,2)
				 
				end		
			end					
		end)		
		----------------------------------------
		hook.Add("Think", "mansion_think", function()	
		
		TryDoRain()
		
		if not(MANSION_ALLOWEDDRAWING)then return end
		
			for i,ent in pairs(MANSION_CHECK_SHEETLIST) do
				if not(IsValid(Entity(ent)) or Entity(ent)==nil)then table.remove(MANSION_CHECK_SHEETLIST,i) print("delete") end
				--print("delete")
			end
			
		if(MANSION_nextsheet<CurTime())then 
		
			for i,ent in pairs(ents.FindByClass("ent_hmcd_mansion_sheet")) do 
			if not(table.HasValue(MANSION_CHECK_SHEETLIST,ent:EntIndex())) then 
				--ent.Checked=true
						table.insert(MANSION_CHECK_SHEETLIST,ent:EntIndex())
						print("add")
				
				MANSION_nextsheet=CurTime()+1
					net.Start("mansion_server_requestdots")
					net.WriteInt(LocalPlayer():EntIndex(),11)--Who will set player count higher than 127? ? ..??????????
					net.WriteInt(MANSION_DotCount,12)
					net.WriteInt(ent:EntIndex(),13)
					net.SendToServer() 
			end 
			end
	
			end
		end)	
				----------------------------------------------------
		if(MANSION_NEWBIE)then 
			print("help gui") 
			Frame = vgui.Create("DFrame")
			Frame:SetSize(590, 140)
			Frame:Center()
			Frame:MakePopup()
			Frame:ShowCloseButton( false )
			Frame:SetTitle( "" )	
			Frame:SetParent(GetHUDPanel())
			Frame.Paint = function( sel, w, h )			--So fancy!!
				local fancyayy ={
					{ x = 100, y = 0 },
					{ x = w-40, y = 0 },
					{ x = w-140, y = h },				
					{ x = 0, y = h }
				}
				surface.SetDrawColor( 0, 141, 150, 255 )
				surface.DrawPoly(fancyayy)
				local fancyayy1 ={
					{ x = 105, y = 5 },
					{ x = w-55, y = 5 },
					{ x = w-155, y = h },				
					{ x = 5, y = h }
				}
					surface.SetDrawColor( 0, 151, 160, 255 )
					surface.DrawPoly(fancyayy1)				
				local fancyay ={
					{ x = w-30, y = 0 },
					{ x = w, y = 0 },
					{ x = w-100, y = h },				
					{ x = w-130, y = h }
				} 
				if(sel.CLOSEBUT)then
					surface.SetDrawColor( 255, 0, 0, 255 )	
				else
					surface.SetDrawColor( 200, 0, 0, 255 )
				end
				surface.DrawPoly(fancyay)

			end
			
			Button = vgui.Create( "DButton", Frame ) 		
			Button:SetText( "" )					
			Button:SetPos( 460, 0 )					
			Button:SetSize( 130, 140 )	
			Button.Paint = function( sel, w, h )
			end		 
			
			Button.DoClick = function()	
				surface.PlaySound( "buttons/lightswitch2.wav" )			
				Frame:MoveTo(Frame:GetX()+10,Frame:GetY(),0.1,0,-1,function()
					Frame:MoveTo(-590,Frame:GetY(),0.7,0,-1,function()
						Frame:Close()
					end)				
				end)
			end					
			
			
			
			Frame.Think = function( sel )
				if(vgui.GetHoveredPanel()==Button)then
					sel.CLOSEBUT=true
				else
					sel.CLOSEBUT=false
				end
			end
			
			
			local IMG = vgui.Create( "DImage", Frame )
			IMG:SetPos( 453, 0 )
			IMG:SetSize( 130, 140 )	
			IMG:SetImage("mu_hmcd_mansion/close")

			local RichText = vgui.Create( "DLabel", Frame )			
			RichText:SetPos( 260, 0 )
			RichText:SetText( "Dot selection!" )
			RichText:SetFont( "HudHintTextLarge" )
			RichText:SizeToContents() 
			 
			local Label = vgui.Create( "DLabel", Frame )			
			Label:SetPos( 84, 25 )
			Label:SetText( "Looks like it is your first visit to mansion!" )
			Label:SizeToContents() 
			
			local Label2 = vgui.Create( "DLabel", Frame )
			Label2:SetPos( 77, 35 )
			Label2:SetText( "Please, SELECT your max DOT COUNT for drawings." ) 
			Label2:SizeToContents()
			
			local Label3 = vgui.Create( "DLabel", Frame )
			Label3:SetPos( 70, 45 )
			Label3:SetText( "It is recommended to choose the number taking into account your hardware capabilities." )
			Label3:SetTextColor(Color(255,255,0))
			Label3:SizeToContents()
			
			local Label4 = vgui.Create( "DLabel", Frame )
			Label4:SetPos( 63, 55 )
			Label4:SetText( "Medium PC - 1000 and higher." )
			Label4:SetTextColor(Color(255,191,0))
			Label4:SizeToContents()
			
			local Label5 = vgui.Create( "DLabel", Frame )
			Label5:SetPos( 56, 65 )
			Label5:SetText( "Slow PC - 100-500." )	
			Label5:SetTextColor(Color(255,191,0))
			Label5:SizeToContents()	
			
			local Label6 = vgui.Create( "DLabel", Frame )
			Label6:SetPos( 18, 115 )
			Label6:SetText( "After you done with it, just close this window and enjoy your time!" )
			Label6:SizeToContents()
			
			local Label7 = vgui.Create( "DLabel", Frame )
			Label7:SetPos( 11, 125 )
			Label7:SetText( "You can always change this value using 'mansion_sheetdots' convar via console." )
			Label7:SetTextColor(Color(255,255,0))
			Label7:SizeToContents()
			
			local Slider = vgui.Create("DNumSlider", Frame)
			Slider:SetPos(39, 90)
			Slider:SetSize(250, 16)
			Slider:SetMin(0)
			Slider:SetMax(2000)
			Slider:SetDecimals(0)
			Slider:SetText("Dot count")
			Slider:SetValue(150)

			local Lang = vgui.Create("DButton", Frame) 
			Lang:SetSize(16, 12)
			Lang:SetPos(100,2) 
			Lang:SetText( "" )
			Lang.Target = self 
			Lang.LANG=false 
				Lang.Paint = function( sel, w, h ) 
					surface.SetDrawColor( 255, 255, 255, 255 )
					if(sel.LANG)then
						surface.SetMaterial( MANSION_tex_en )
					else
						surface.SetMaterial( MANSION_tex_ru )
					end
					surface.DrawTexturedRect( 0, 0, w, h )
				end
				Lang.DoClick = function(sel)
					
					if(sel.LANG==false)then	
					sel.LANG=true
					Label:SetText("Похоже, это Ваш первый визит в особняк!")	
					Label2:SetText("Пожалуйста, ВЫБЕРИТЕ максисмальное ЧИСЛО ТОЧЕК для картинок.")
					Label3:SetText("Рекомендуется выбрать число с учетом ваших аппаратных возможностей.")
					Label4:SetText("Средний ПК - 1000 и больше.")
					Label5:SetText("Слабый ПК - 100 - 500 точек.")
					Label6:SetText("Когда Вы закончите с этим, просто закройте это окно и наслаждайтесь игрой!")
					Label7:SetText("Вы всегда можете изменить это значение, 'mansion_sheetdots' через консоль.")
					Slider:SetText("Кол-во точек")
					Label:SizeToContents()
					Label2:SizeToContents()
					Label3:SizeToContents()
					Label4:SizeToContents()
					Label5:SizeToContents()
					Label6:SizeToContents()
					Label7:SizeToContents()
					else
					sel.LANG=false
					Label:SetText( "Looks like it is your first visit to mansion!" )
					Label2:SetText( "Please, SELECT your max DOT COUNT for drawings." ) 
					Label3:SetText( "It is recommended to choose the number taking into account your hardware capabilities." )
					Label4:SetText( "Medium PC - 1000 and higher." )
					Label5:SetText( "Slow PC - 100-500." )	
					Label6:SetText( "After you done with it, just close this window and enjoy your time!" )
					Label7:SetText( "You can always change this value using 'mansion_sheetdots' convar via console." )
					Slider:SetText("Dot count")
					Label:SizeToContents()
					Label2:SizeToContents()
					Label3:SizeToContents()
					Label4:SizeToContents()
					Label5:SizeToContents()
					Label6:SizeToContents()
					Label7:SizeToContents()					
					end		--looks like shit, ultratrash shit gay lemon party
				end
			
			function Frame:OnClose()
				local Con=GetConVar( "mansion_sheetdots" )
				Con:SetInt(math.Round(Slider:GetValue()))
				local Con=GetConVar( "mansion_newbie" )
				Con:SetBool(false)				
			end				
		end
	end
	end
end)

