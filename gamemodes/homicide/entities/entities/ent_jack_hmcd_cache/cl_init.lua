include("shared.lua")

net.Receive("hmcd_usecache",function()
	local cache=net.ReadEntity()
	if cache==NULL then return end
	local categoryAmt=net.ReadUInt(5)
	local equipment={}
	for i=1,categoryAmt do
		local category=net.ReadString()
		local categoryEquipment={}
		local equipmentAmt=net.ReadUInt(5)
		for i=1,equipmentAmt do
			table.insert(categoryEquipment,{net.ReadString(),net.ReadUInt(5),net.ReadBool(),net.ReadUInt(5)})
		end
		equipment[category]=categoryEquipment
	end
	cache:OpenInterface(equipment)
end)

net.Receive("hmcd_stopusingcache",function()
	local cache=net.ReadEntity()
	if cache==NULL then return end
	cache.UI:Close()
end)

net.Receive("hmcd_cache_take",function(len)
	local cache=net.ReadEntity()
	if cache==NULL then return end
	local ui=cache.UI
	if ui then
		local class=net.ReadString()
		local amt
		if len!=13+8*(#class+1) then
			amt=net.ReadUInt(1)
		else
			amt=-1
		end
		for category,equipment in pairs(ui.Equipment) do
			for i,eqInfo in pairs(equipment) do
				if eqInfo[1]==class then
					eqInfo[2]=eqInfo[2]+amt
					
					local btn=ui.Buttons[class]
					if btn then
						btn.Amt=btn.Amt+amt
					end
					return
				end
			end
		end
	end
end)

local function inheritFuncs(gui,funcs)
	for i,func in pairs(funcs) do
		gui[i]=func
	end
end

local rusUI_bg=Material("vgui/russianCache_ui.jpg")
local rusBgMat_width,rusBgMat_height=rusUI_bg:Width(),rusUI_bg:Height()

local ukrUI_bg=Material("vgui/ukrainianCache_ui.png")
local ukrBgMat_width,ukrBgMat_height=ukrUI_bg:Width(),ukrUI_bg:Height()

local outline_color=Color(170,170,170,170)
local textColor_yellow=Color(255,170,0)

local buttonOutline_col,buttonOutlineHovered_col,buttonOutlinePressed_col=Color(150,150,150),Color(125,125,125),Color(100,100,100)
local button_col,buttonHovered_col,buttonPressed_col=Color(0,100,0),Color(0,75,0),Color(0,60,0)

local weaponCase_mat=Material("vgui/weaponCase_foam.png")
local foamMat_width,foamMat_height=weaponCase_mat:Width(),weaponCase_mat:Height()

surface.CreateFont( "MersRadial_Cache", {
	font = "coolvetica",
	size = math.ceil(ScrW() / 120),
	weight = 100,
	antialias = true,
	italic = false
})

local wep_outlineCol,wep_hoverCol=Color(70,70,70),Color(200,200,200)
local ammoReplenish_mat=Material("vgui/ammoReplenish.png")

local WeaponPanelFuncs={
	OnRemove=function(Weapon)
		if Weapon.PartHovered then hook.Remove("PostRenderVGUI","CacheItemName"..Weapon.Index) end
	end,
	DoClick=function(Weapon)
		local takeable,errorMSG=Weapon:CanTakeItem()
		if not(takeable) then
			surface.PlaySound("weapon_cant_buy.wav")
			LocalPlayer():PrintMessage(HUD_PRINTTALK,errorMSG or "Can't take any more of this item!")
			return
		end
		surface.PlaySound("buttonclick.wav")
		net.Start("hmcd_cache_take")
		if Weapon.IsEquipment then
			net.WriteString(Weapon.WepInfo.AttachmentID)
		else
			net.WriteString(Weapon.WepInfo.ClassName)
		end
		net.SendToServer()
	end,
	CanTakeItem=function(Weapon)
		local lPly=LocalPlayer()
		local wepInfo=Weapon.WepInfo
		if Weapon.IsEquipment then
			local name=HMCD_EquipmentNames[wepInfo.AttachmentID]
			for armorType,names in pairs(HMCD_ArmorNames) do
				if HMCD_ArmorNames[armorType][name] then
					if lPly:GetNWString(armorType)!="" then return false,"You already have armor for this bodypart!" end
				end
			end
			if lPly.Equipment[name] then
				return false,"You already have this equipment!"
			end
			return true
		end
		local wep=lPly:GetWeapon(wepInfo.ClassName)
		local canGiveAmmo=wep!=NULL and wepInfo.AmmoType and wepInfo.AmmoType!=""
		if Weapon.Amt==0 and (not(canGiveAmmo) or Weapon.Equipment[3]) then return false,"There's no more such items!" end 
		if wep==NULL then return true end
		if wep.Stackable then
			return wep:GetAmount()!=10
		end
		if canGiveAmmo then
			local ammoAmt=wep.Primary.ClipSize
			if not(wep.NoBulletInChamber) then
				ammoAmt=ammoAmt-1
			end
			return lPly:GetAmmoCount(wep.AmmoType)<ammoAmt*(Weapon.Equipment[4] or 5)
		end
		return false
	end,
	DisplayName=function(Weapon)
		local wepName=Weapon.WepInfo.PrintName
		hook.Add("PostRenderVGUI","CacheItemName"..Weapon.Index,function()
			local x,y=input.GetCursorPos()
			surface.SetFont("MersRadial_Cache")
			local textWidth,textHeight=surface.GetTextSize(wepName)
			draw.SimpleText(wepName,"MersRadial_Cache",x+textWidth,y-textHeight,color_white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)
		end)
	end,
	Paint=function(Weapon,w,h)
		surface.SetDrawColor(wep_outlineCol)
		surface.DrawRect(0,0,w,h)
		
		local isHovered=Weapon:IsHovered()
		if isHovered!=Weapon.ButtonHovered then
			Weapon.ButtonHovered=isHovered
			if isHovered then
				surface.PlaySound("buttonrollover.wav")
				Weapon:DisplayName()
				Weapon.PartHovered=true
				for i,part in pairs(Weapon.Fragments) do
					part.PartHovered=true
				end
			else
				local stillCovered
				for i,part in pairs(Weapon.Fragments) do
					if part:IsHovered() then stillCovered=true break end
				end
				Weapon.PartHovered=stillCovered
				if not(stillCovered) then
					for i,part in pairs(Weapon.Fragments) do
						part.PartHovered=nil
					end
					hook.Remove("PostRenderVGUI","CacheItemName"..Weapon.Index)
				end
			end
		end
		local matColor=color_white
		local replenishAmmo
		if Weapon.PartHovered then
			surface.SetDrawColor(wep_hoverCol)
			replenishAmmo=Weapon.WepInfo.ClassName and LocalPlayer():HasWeapon(Weapon.WepInfo.ClassName)
			if replenishAmmo then
				matColor=wep_outlineCol
			end
		else
			surface.SetDrawColor(color_white)
		end
		
		local outline=Weapon.outline
		--surface.DrawRect(outline,outline,w-outline*2,h-outline*2)
		surface.SetMaterial(weaponCase_mat)
		surface.DrawTexturedRectUV(outline,outline,w-outline*2,h-outline*2,0,0,(w-outline*2)/foamMat_width,(h-outline*2)/foamMat_height)
		
		if replenishAmmo or Weapon.Amt==0 then
			surface.SetDrawColor(color_black)
		else
			surface.SetDrawColor(color_white)
		end
		
		surface.SetMaterial(Weapon.Mat)
		if Weapon.IsEquipment then
			local iconSize=h-outline*2
			surface.DrawTexturedRect((w-iconSize)/2,(h-iconSize)/2,iconSize,iconSize)
		else
			surface.DrawTexturedRect(outline,outline,w-outline*2,h-outline*2)
		end
		
		if replenishAmmo and (Weapon.WepInfo.AmmoType and Weapon.WepInfo.AmmoType!="" or Weapon.WepInfo.Stackable) then
			surface.SetMaterial(Weapon.Mat)
			surface.DrawTexturedRect(outline,outline,w-outline*2,h-outline*2)
			
			local iconSize=h/3-outline*2
			surface.SetDrawColor(color_white)
			surface.SetMaterial(ammoReplenish_mat)
			surface.DrawTexturedRect((w-iconSize)/2,(h-iconSize)/2,iconSize,iconSize)
		end
		draw.SimpleText(Weapon.Amt,"MersRadial_Cache",w-outline*2,outline,color_white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)
		return true
	end
}

local AttachmentPanelFuncs={
	Paint=function(Attachment,w,h)
		local outline=Attachment.outline
		surface.SetDrawColor(wep_outlineCol)
		surface.DrawRect(0,0,w,h)
		local isHovered=Attachment:IsHovered()
		if isHovered then
			surface.SetDrawColor(wep_hoverCol)
		else
			surface.SetDrawColor(color_white)
		end
		if Attachment.ButtonHovered!=isHovered then
			Attachment.ButtonHovered=isHovered
			if isHovered then
				surface.PlaySound("buttonrollover.wav")
				Attachment:DisplayName()
			else
				hook.Remove("PostRenderVGUI","CacheItemName"..Attachment.ID)
			end
		end
		--surface.DrawRect(outline,outline,w-outline*2,h-outline*2)
		surface.SetMaterial(weaponCase_mat)
		surface.DrawTexturedRectUV(outline,outline,w-outline*2,h-outline*2,0,0,(w-outline*2)/foamMat_width,(h-outline*2)/foamMat_height)
		
		surface.SetDrawColor(color_white)
		surface.SetMaterial(Attachment.Mat)
		surface.DrawTexturedRect(outline*2,outline*2,w-outline*4,h-outline*4)
		return true
	end,
	OnRemove=function(Attachment)
		if Attachment.ButtonHovered then hook.Remove("PostRenderVGUI","CacheItemName"..Attachment.ID) end
	end,
	DisplayName=function(Attachment)
		local attName=HMCD_EquipmentNames[Attachment.Num]
		hook.Add("PostRenderVGUI","CacheItemName"..Attachment.ID,function()
			local x,y=input.GetCursorPos()
			surface.SetFont("MersRadial_Cache")
			local textWidth,textHeight=surface.GetTextSize(attName)
			draw.SimpleText(attName,"MersRadial_Cache",x+textWidth,y-textHeight,color_white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)
		end)
	end,
	CanAddAttachment=function(Attachment)
		local lPly=LocalPlayer()
		local wepClass=Attachment.WepClassName
		local wep=lPly:GetWeapon(wepClass)
		if wep==NULL then return false,"You don't have the corresponding weapon!" end
		
		local att=Attachment.Num
		if att==HMCD_LASERBIG and (wep:GetNWBool("Sight") or wep:GetNWBool("Sight2") or wep:GetNWBool("Sight3")) and not(wep.MultipleRIS) then
			return false,"You can't apply this attachment! There isn't enough space!"
		elseif (att==HMCD_EOTECH or att==HMCD_KOBRA or att==HMCD_AIMPOINT) and wep:GetNWBool("Laser") and not(wep.MultipleRIS) then
			return false,"You can't apply this attachment! There isn't enough space!"
		elseif (att==HMCD_KOBRA or att==HMCD_AIMPOINT or att==HMCD_EOTECH) and (wep:GetNWBool("Sight") or wep:GetNWBool("Sight2") or wep:GetNWBool("Sight3")) then
			return false,"You already have a sight attached!"
		end
		
		for attType,attInfo in pairs(wep.Attachments["Owner"]) do
			if attInfo.num==att then
				if wep:GetNWBool(attType)==false then
					return true
				else
					return false,"You already have this attachment!"
				end
			end
		end
		
		return false,""
	end,
	DoClick=function(Attachment)
		local canAttach,errorMSG=Attachment:CanAddAttachment()
		if not(canAttach) then
			surface.PlaySound("weapon_cant_buy.wav")
			LocalPlayer():PrintMessage(HUD_PRINTTALK,errorMSG)
			return
		end
		surface.PlaySound("buttonclick.wav")
		net.Start("hmcd_cache_take")
		net.WriteString(Attachment.WepClassName)
		net.WriteUInt(Attachment.Num,6)
		net.SendToServer()
	end
}

local function paint_universal(Side,w,h)
	local outline=Side.outline
	surface.SetDrawColor(wep_outlineCol)
	surface.DrawRect(0,0,w,h)
	local isHovered=Side:IsHovered()
	if Side.ButtonHovered!=isHovered then
		Side.ButtonHovered=isHovered
		if isHovered then
			surface.PlaySound("buttonrollover.wav")
			Side.PartHovered=true
			for i,part in pairs(Side.Fragments) do
				part.PartHovered=true
			end
			Side.Fragments[1]:DisplayName()
		else
			local stillCovered
			for i,part in pairs(Side.Fragments) do
				if part:IsHovered() then stillCovered=true break end
			end
			Side.PartHovered=stillCovered
			if not(stillCovered) then
				hook.Remove("PostRenderVGUI","CacheItemName"..Side.Fragments[1].Index)
				for i,part in pairs(Side.Fragments) do
					part.PartHovered=nil
				end
			end
		end
	end
	if Side.PartHovered then
		surface.SetDrawColor(wep_hoverCol)
	else
		surface.SetDrawColor(color_white)
	end
	surface.SetMaterial(weaponCase_mat)
	surface.DrawTexturedRectUV(outline,outline,w-outline*2,h-outline*2,0,0,(w-outline*2)/foamMat_width,(h-outline*2)/foamMat_height)
	--surface.DrawRect(outline,outline,w-outline*2,h-outline*2)
	return true
end

local CategoryFuncs={
	DoClick=function(Button)
		local Frame=Button.Frame
		Frame.Title=Button:GetText()
		Frame.ClosePanel:SetText("Back")
		surface.PlaySound("buttonclick.wav")
		for i,b in pairs(Frame.Buttons) do
			Frame.Buttons[i]=nil
			b:Remove()
		end
		
		local outline,gap=Frame.outline,Frame.gap
		local startPos=outline+draw.GetFontHeight("MersRadialBig")+gap
		
		local ScrollPanel=vgui.Create("DScrollPanel",Frame)
		ScrollPanel:SetPos(gap*2,startPos)
		ScrollPanel:SetSize(Frame:GetWide()-gap*4,Frame:GetTall()-startPos-gap)
		--ScrollPanel.Paint=function(p,w,h) surface.SetDrawColor(color_white) surface.DrawRect(0,0,w,h) end
		Frame.ScrollPanel=ScrollPanel
		
		local itemsPerRow=2
		local buttonWidth=(ScrollPanel:GetWide()-gap*(itemsPerRow))/itemsPerRow
		local buttonHeight=buttonWidth/2
		local attButtonSize=math.ceil(buttonHeight/4)
		
		local VBar=ScrollPanel:GetVBar()
		VBar:SetWide(gap)
		VBar.Paint=nil
		VBar:SetHideButtons(true)
		
		local curX,curY=0,0
		
		for i,info in pairs(Button.Equipment) do
			local class,amt=info[1],info[2]
		
			local wepInfo,mat
			local eqNum=tonumber(class)
			if eqNum then
				wepInfo={
					PrintName=HMCD_EquipmentNames[eqNum],
					AttachmentID=eqNum
				}
				mat=Material(HMCD_EquipmentInfo[eqNum][4])
			else
				wepInfo=weapons.Get(class)
				mat=Material(surface.GetTextureNameByID(wepInfo.WepSelectIcon))
			end
			local Weapon=vgui.Create("DButton",ScrollPanel)
			Weapon:SetPos(curX,curY)
			Weapon:SetSize(buttonWidth,buttonHeight)
			Weapon.IconHeight=buttonHeight
			Weapon.Mat=mat
			if amt!=2^5-1 then
				Weapon.Amt=amt
			else
				Weapon.Amt="∞"
			end
			Weapon.outline=outline
			Weapon.WepInfo=wepInfo
			Weapon.Equipment=info
			Weapon.IsEquipment=wepInfo.AttachmentID!=nil
			Weapon.Index=i
			Weapon.ButtonHovered=false
			inheritFuncs(Weapon,WeaponPanelFuncs)
			
			Frame.Buttons[class]=Weapon
			Frame.Buttons[i]=Weapon
			
			local nextHeight
			local atts,attCount={},0
			if wepInfo.Attachments then
				if wepInfo.Attachments["Owner"] then
					for j,attInfo in pairs(wepInfo.Attachments["Owner"]) do
						if attInfo.num then
							table.insert(atts,attInfo.num)
							attCount=attCount+1
						end
					end
				end
				
				local curAttX=curX+(buttonWidth-attButtonSize*attCount-outline*(attCount-1))/2
				local attY=curY+buttonHeight+outline
				local LeftSide=vgui.Create("DButton",ScrollPanel)
				LeftSide:SetPos(curX,attY)
				LeftSide:SetSize(curAttX-outline-curX,attButtonSize)
				LeftSide.Paint=paint_universal
				LeftSide.ButtonHovered=false
				LeftSide.outline=outline
				
				for j,att in pairs(atts) do
					local Attachment=vgui.Create("DButton",ScrollPanel)
					Attachment:SetPos(curAttX,attY)
					Attachment:SetSize(attButtonSize,attButtonSize)
					Attachment.Num=att
					Attachment.ID=Weapon.Index.."_"..Attachment.Num
					Attachment.Mat=Material(HMCD_EquipmentInfo[att][4])
					Attachment.outline=outline
					Attachment.Weapon=Weapon
					Attachment.WepClassName=class
					inheritFuncs(Attachment,AttachmentPanelFuncs)
					curAttX=curAttX+attButtonSize+outline
				end
				
				local RightSide=vgui.Create("DButton",ScrollPanel)
				RightSide:SetPos(curAttX,attY)
				RightSide:SetSize(buttonWidth-curAttX+curX,attButtonSize)
				RightSide.Paint=paint_universal
				RightSide.ButtonHovered=false
				RightSide.outline=outline
				
				LeftSide.Fragments={Weapon,RightSide}
				RightSide.Fragments={Weapon,LeftSide}
				Weapon.Fragments={RightSide,LeftSide}
				
				nextHeight=attY+attButtonSize+gap
			else
				Weapon.Fragments={}
				nextHeight=curY+buttonHeight+gap
			end
			curX=curX+buttonWidth+gap
			
			if i%itemsPerRow==0 then
				curX=0
				curY=nextHeight
			end
		end
		
		local oldHeight=Frame:GetTall()
		Frame:SetTall(ScrollPanel:GetY()+ScrollPanel:GetTall()+Frame.ClosePanel:GetTall()+gap*11)
		Frame:SetY(Frame:GetY()-(Frame:GetTall()-oldHeight))
		Frame.ClosePanel:CenterHorizontal()
		Frame.ClosePanel:SetY(Frame:GetTall()-Frame.ClosePanel:GetTall()-gap*6)
		
		--[[local Back=vgui.Create("DButton",Frame)
		Back:SetPos((Frame:GetWide()-buttonWidth)/2,curY)
		Back:SetSize(buttonWidth,buttonHeight)
		Back:SetText("Back")
		Back.Frame=Frame
		Back.outline=outline
		Back.DoClick=function(Back)
			surface.PlaySound("buttonclick.wav")
		end
		Back.Paint=function(Back,w,h)
			local outline=Back.outline
			surface.SetDrawColor(buttonOutline_col)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(button_col)
			surface.DrawRect(outline,outline,w-outline*2,h-outline*2)
			
			draw.SimpleText(Back:GetText(),"MersRadialSmall_QM",w/2,h/2,textColor_yellow,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			return true
		end]]
	end,
	Paint=function(Button,w,h)
		local outline=Button.outline
		local bCol,bOutCol
		local isHovered=Button:IsHovered()
		if isHovered then
			if input.IsMouseDown(MOUSE_LEFT) then
				bCol=buttonPressed_col
				bOutCol=buttonOutlinePressed_col
			else
				bCol=buttonHovered_col
				bOutCol=buttonOutlineHovered_col
			end
		else
			bCol=button_col
			bOutCol=buttonOutline_col
		end
		if Button.ButtonHovered!=isHovered then
			Button.ButtonHovered=isHovered
			if isHovered then
				surface.PlaySound("buttonrollover.wav")
			end
		end
		surface.SetDrawColor(bOutCol)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(bCol)
		surface.DrawRect(outline,outline,w-outline*2,h-outline*2)
		
		draw.SimpleText(Button:GetText(),"MersRadialSmall_QM",w/2,h/2,Button.TextColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		return true
	end
}

local FrameFunctions={
	OnRemove=function(Frame)
		Frame.Cache.UI=nil
		net.Start("hmcd_stopusingcache")
		net.SendToServer()
	end,
	OnKeyCodePressed=function(Frame,key)
		if Frame:HasFocus() then
			if key>=KEY_0 and key<=KEY_9 then
				local button=Frame.Buttons[key-1]
				if button then button:DoClick() end
				return
			end
			local bind=input.LookupBinding("+reload")
			local code=input.GetKeyCode(bind)
			if code==key then
				Frame.ClosePanel:DoClick()
			end
		end
	end,
	Paint=function(Frame,w,h)
		local gap=Frame.gap
		
		surface.SetDrawColor(color_white)
		surface.DrawRect(0,0,w,h)
		surface.SetMaterial(Frame.UIMat)
		surface.DrawTexturedRectUV(gap,gap,w-gap*2,h-gap*2,0,0,(w-gap*2)/Frame.UIWidth,(h-gap*2)/Frame.UIHeight)
		
		draw.SimpleText(Frame.Title,"MersRadialBig",w/2,gap,Frame.TextColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
	end,
	OpenMainPage=function(Frame)
		local gap,outline,w=Frame.gap,Frame.outline,Frame:GetWide()
	
		Frame.Title="Weapon Cache"
		Frame.Buttons={}
		local curY,curX=gap+draw.GetFontHeight("MersRadialBig"),gap*6
		local buttonWidth=math.ceil((w-gap*3-curX*2)/2)
		local buttonHeight=math.ceil(buttonWidth/4)
		Frame.ButtonHeight=buttonHeight
		local i=1
		for title,equipment in pairs(Frame.Equipment) do
			local b=vgui.Create("DButton",Frame)
			b:SetPos(curX,curY)
			b:SetSize(buttonWidth,buttonHeight)
			b:SetText(title)
			b.ButtonHovered=false
			b.outline=outline
			b.Equipment=equipment
			b.Frame=Frame
			b.TextColor=Frame.TextColor
			inheritFuncs(b,CategoryFuncs)
			if i%2==1 then
				curX=curX+buttonWidth+gap
			else
				curX=gap*6
				curY=curY+b:GetTall()+gap
			end
			i=i+1
			table.insert(Frame.Buttons,b)
		end
		
		curY=curY+buttonHeight+gap
		
		local Close=Frame.ClosePanel
		if not(Frame.ClosePanel) then
			Close=vgui.Create("DButton",Frame)
			Close:SetPos((w-buttonWidth)/2,curY)
			Close:SetSize(buttonWidth,buttonHeight)
			Close.Paint=CategoryFuncs["Paint"]
			Close.Frame=Frame
			Close.ButtonHovered=false
			Close.outline=outline
			Close.DoClick=function(Close)
				surface.PlaySound("buttonclick.wav")
				local Frame=Close.Frame
				if Close:GetText()=="Exit" then
					Frame:Close()
				else
					Frame.ScrollPanel:Remove()
					table.Empty(Frame.Buttons)
					Frame:OpenMainPage()
				end
			end
			Frame.ClosePanel=Close
		end
		Close:SetText("Exit")
		Close:SetPos((w-buttonWidth)/2,curY)
		curY=curY+Close:GetTall()+gap
		
		Frame:SetTall(curY+gap*5)
		Frame:Center()
	end
}

function ENT:OpenInterface(equipment)
	local size=ScrW()/2
	local gap=math.ceil(size/256)
	local outline=math.ceil(size/1000)
	local w=math.ceil(size*0.6)
	local Frame=vgui.Create("DFrame")
	Frame:SetSize(w,h)
	Frame:SetVisible(true)
	Frame:ShowCloseButton(false)
	Frame.outline=outline
	Frame.gap=gap
	Frame:SetTitle("")
	Frame.Cache=self
	Frame.Equipment=equipment
	if self:GetModel()=="models/ins/caches/wcache_sec_01.mdl" then
		Frame.UIMat=ukrUI_bg
		Frame.UIWidth=ukrBgMat_width
		Frame.UIHeight=ukrBgMat_height
		Frame.TextColor=color_white
	else
		Frame.UIMat=rusUI_bg
		Frame.UIWidth=rusBgMat_width
		Frame.UIHeight=rusBgMat_height
		Frame.TextColor=textColor_yellow
	end
	inheritFuncs(Frame,FrameFunctions)
	Frame:MakePopup()
	self.UI=Frame
	
	Frame:OpenMainPage()
end

function ENT:OnRemove(fullupdate)
	if not(fullupdate) or self:IsDormant() then
		if IsValid(self.UI) then self.UI:Close() end
	end
end