
concommand.Add("hmcd_spectateenickname",function(ply,cmd,args)
	if GAMEMODE.Spectatee and ply:IsAdmin() then print(GAMEMODE.Spectatee) end
end)

net.Receive("spectating_status", function (length)
	GAMEMODE.SpectateMode = net.ReadInt(8)
	GAMEMODE.Spectating = false
	GAMEMODE.Spectatee = nil
	GAMEMODE.SpectateTime = 0
	if GAMEMODE.SpectateMode >= 0 then
		GAMEMODE.Spectating = true
		GAMEMODE.Spectatee = net.ReadEntity()
		--[[local wep
		if GAMEMODE.Spectatee.GetActiveWeapon then wep=GAMEMODE.Spectatee:GetActiveWeapon() end
		if IsValid(wep) and wep.Attachments and wep.Attachments["Owner"] then
			for attachment,info in pairs(wep.Attachments["Owner"]) do
				if wep.DrawnAttachments[attachment] then
					if info.scale then
						wep.DrawnAttachments[attachment]:SetModelScale(info.scale,0)
					end
					if info.material then
						wep.DrawnAttachments[attachment]:SetMaterial(info.material)
					end
					if info.sightang then
						if not(wep.SightInfo) then wep.SightInfo={14-info.num,wep.DrawnAttachments[attachment]} end
					end
					if info.aimpos then wep.AttAimPos=info.aimpos end
					if info.bipodpos then wep.AttBipodPos=info.bipodpos end
				end
			end
		end]]
	end
end)

--[[function GM:IsCSpectating() -- wow, inefficient much?
	return self.Spectating -- a whole function call, scope, application stack, etc, all to return a single value
end -- a value that's already visible from the scope of the caller

function GM:GetCSpectatee() -- good job, MechanicalMind
	return self.Spectatee
end -- dumbass

imagine writing this much text instead of fixing the problem
fuck you, jackarunda
]]

function GM:GetCSpectateMode() 
	return self.SpectateMode
end


local function drawTextShadow(t,f,x,y,c,px,py)
	draw.SimpleText(t,f,x + 1,y + 1,Color(0,0,0,c.a),px,py)
	draw.SimpleText(t,f,x - 1,y - 1,Color(255,255,255,math.Clamp(c.a*.25,0,255)),px,py)
	draw.SimpleText(t,f,x,y,c,px,py)
end

local nextTipSwitch,tip=0,""
function GM:RenderSpectate()
	if self.Spectating then

		if IsValid(self.Spectatee) && self.Spectatee:IsPlayer() then
			drawTextShadow(Translate("spectating"), "MersRadial", ScrW() / 2, 50, Color(20,120,255), 1)
		
			local h = draw.GetFontHeight("MersRadial")

			--drawTextShadow(self.Spectatee:Nick(), "MersRadialSmall", ScrW() / 2, ScrH() - 100 + h, Color(190, 190, 190), 1)

			local Time=CurTime()
			if(nextTipSwitch<Time)then
				nextTipSwitch=Time+10
				tip="a."
			end
			draw.SimpleText(tip,"MersRadialSmall_QM",ScrW()/2,ScrH()-75,Color(128,128,128,255),1)
			draw.SimpleText(tip,"MersRadialSmall_QM",ScrW()/2+1,ScrH()-76,Color(0,0,0,255),1)
		end
	end
end