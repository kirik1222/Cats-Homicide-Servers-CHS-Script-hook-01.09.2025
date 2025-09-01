if(SERVER)then
	util.AddNetworkString( "bScreenGrabStop" )
	util.AddNetworkString( "bScreenGrabFailed" )
	util.AddNetworkString( "bScreenGrabStart" )
	util.AddNetworkString( "bScreenGrab_ToServer" )
	util.AddNetworkString( "bScreenGrab_ToClient" )
	util.AddNetworkString( "bScreenGrabCommand" )
	 
	net.Receive( "bScreenGrabFailed", function( len, ply )
		if !IsValid( ply.ScreenGrabber ) then return end
	 
		ply.ScreenGrabber:PrintMessage( HUD_PRINTTALK, "Failed to screengrab " .. ply:Nick() .. ". " .. net.ReadString() )
		ply.ScreenGrabber = nil
	end )
	
	concommand.Add("screengrab_new",function(ply,cmd,args)
		if !ply:IsAdmin() then return end
	 
		if args[1] then
			local target, err = ULib.getUser( args[ 1 ] )
	 
			if !target then
				ply:PrintMessage( err )
				return
			end
	 
			ply.ScreenGrabTime = CurTime() + ( tonumber( args[3] ) or 60 )
			target.ScreenGrabber = ply
	 
			net.Start( "bScreenGrabStart" )
			net.Send( target )
	 
			ply:PrintMessage( HUD_PRINTTALK, "Starting screengrab on: " .. target:Nick() )
		end
	end)
	
	
	local data_assembled={}
	
	net.Receive("bScreenGrab_ToServer",function()
		local length=net.ReadUInt( 32 )
		local data,ply=net.ReadData(length),net.ReadEntity()
		table.insert(data_assembled,data)
		if IsValid(ply) then
			local nick
			if ply.ScreenGrabber.ScreenFileName then
				nick=ply.ScreenGrabber.ScreenFileName
				ply.ScreenGrabber.ScreenFileName=nil
			else
				nick=ply:Nick()
			end
			file.Write(nick..os.time().."_screengrab.jpeg",table.concat(data_assembled))
			local i=1
			local screenGrabber=ply.ScreenGrabber
			ply.ScreenGrabber=nil
			timer.Create( "ScreengrabSendParts_New", 0.1, table.Count(data_assembled), function()
				local l = data_assembled[ i ]:len()
				net.Start("bScreenGrab_ToClient")
				net.WriteUInt( l, 32 )
				net.WriteData(data_assembled[i],l)
				if i==table.Count(data_assembled) then
					net.WriteEntity(ply)
					data_assembled={}
				end
				net.Send(screenGrabber)
				i = i + 1
			end )
		end
	end)

	net.Receive("bScreenGrabCommand",function()
		local ply,arg,arg2=net.ReadEntity(),net.ReadString(),net.ReadString()
		local target, err = ULib.getUser( arg )
	 
		if !target then
			ply:PrintMessage( err )
			return
		end
 
		ply.ScreenGrabTime = CurTime() + 60
		target.ScreenGrabber = ply
 
		net.Start( "bScreenGrabStart" )
		net.Send( target )
 
		ply:PrintMessage( HUD_PRINTTALK, "Starting screengrab on: " .. target:Nick() )
		if arg2!="" then
			print(arg2)
			ply.ScreenFileName=arg2
		end
	end)

else

	local capturing = false
	local screenshotRequested = false
	local screenshotFailed = false
	local stopScreenGrab = false
	local inFrame = false
	local screenshotRequestedLastFrame = false
	 
	hook.Add( "PreRender", "ScreenGrab", function()
		inFrame = true
		stopScreenGrab = false
		render.SetRenderTarget()
	end )
	 
	local screengrabRT = GetRenderTarget( "ScreengrabRT" .. ScrW() .. "_" .. ScrH(), ScrW(), ScrH() )
	 
	hook.Add( "PostRender", "ScreenGrab", function( vOrigin, vAngle, vFOV )
		if stopScreenGrab then return end
		inFrame = false
	 
		if screenshotRequestedLastFrame then
			render.PushRenderTarget( screengrabRT )
		else
			render.CopyRenderTargetToTexture( screengrabRT )
			render.SetRenderTarget( screengrabRT )
		end
	 
		if screenshotRequested or screenshotRequestedLastFrame then
			screenshotRequested = false
	 
			if jit.version == "LuaJIT 2.1.0-beta3" then
				if screenshotRequestedLastFrame then
					screenshotRequestedLastFrame = false
				else
					screenshotRequestedLastFrame = true
				return end
			end
	 
			cam.Start2D()
				surface.SetFont( "Trebuchet24" )
				local text = LocalPlayer():SteamID64()
				local x, y = ScrW() * 0.5, ScrH() * 0.5
				local w, h = surface.GetTextSize( text )
	 
				surface.SetDrawColor( 0, 0, 0, 100 )
				surface.DrawRect( x - w * 0.5 - 5, y - h * 0.5 - 5, w + 10, h + 10 )
	 
				surface.SetTextPos( math.ceil( x - w * 0.5 ), math.ceil( y - h * 0.5 ) )
				surface.SetTextColor( 255, 255, 255 )
				surface.DrawText( text )
	 
				surface.SetDrawColor( 255, 255, 255 )
				surface.DrawRect( 0, 0, 1, 1 )
			cam.End2D()
	 
			render.CapturePixels()
			local r, g, b = render.ReadPixel( 0, 0 )
			if r != 255 or g != 255 or b != 255 then
				net.Start( "bScreenGrabFailed" )
					net.WriteString( "Tampered with screenshot. (1)" )
				net.SendToServer()
	 
				return
			end
	 
			capturing = true
			local frame1 = FrameNumber()
			local data = render.Capture( {
				format = "jpeg",
				quality = 60,
				x = 0,
				y = 0,
				w = ScrW(),
				h = ScrH()
			} )
			local frame2 = FrameNumber()
			capturing = false
	 
			if frame1 != frame2 then
				net.Start( "bScreenGrabFailed" )
					net.WriteString( "Tampered with screenshot. (2)" )
				net.SendToServer()
	 
				return
			end
			local len = string.len( data )
			local parts = math.ceil( len / 20000 )
			local partstab = {}
            for i = 1, parts do
                local min
                local max
                if i == 1 then
                    min = i
                    max = 20000
                elseif i > 1 and i ~= parts then
                    min = ( i - 1 ) * 20000 + 1
                    max = min + 20000 - 1
                elseif i > 1 and i == parts then
                    min = ( i - 1 ) * 20000 + 1
                    max = len
                end
                local str = string.sub( data, min, max )
                partstab[ i ] = str
            end
			local i = 1
            timer.Create( "ScreengrabSendParts_New", 0.1, table.Count(partstab), function()
				local l = partstab[ i ]:len()
				net.Start("bScreenGrab_ToServer")
				net.WriteUInt( l, 32 )
				net.WriteData(partstab[i],l)
				if i==table.Count(partstab) then
					net.WriteEntity(LocalPlayer())
				end
				net.SendToServer()   
				i = i + 1
			end )
		end
	 
		if screenshotRequestedLastFrame then
			render.PopRenderTarget()
			render.CopyRenderTargetToTexture( screengrabRT )
			render.SetRenderTarget( screengrabRT )
		end
	end )
	 
	hook.Add( "PreDrawViewModel", "ScreenGrab", function()
		if capturing then
			net.Start( "bScreenGrabFailed" )
				net.WriteString( "Tampered with screenshot. (3)" )
			net.SendToServer()
	 
			screenshotFailed = true
		end
	end )
	 
	net.Receive( "bScreenGrabStart", function()
		screenshotRequested = true
	end )
	 
	hook.Add( "ShutDown", "bScreenGrabStop", function()
		stopScreenGrab = true
		render.SetRenderTarget()
	end )
	 
	hook.Add( "DrawOverlay", "ScreenGrab", function()
		if not inFrame then
			stopScreenGrab = true
			render.SetRenderTarget()
		end
	end )

	local data_assembled={}
	
	net.Receive("bScreenGrab_ToClient",function()
		local length=net.ReadUInt( 32 )
		local data,ply=net.ReadData(length),net.ReadEntity()
		table.insert(data_assembled,data)
		if IsValid(ply) then
			local nick
			if LocalPlayer().ScreenFileName then
				nick=LocalPlayer().ScreenFileName
				LocalPlayer().ScreenFileName=nil
			else
				nick=ply:Nick()
			end
			file.Write(nick..os.time().."_screengrab.jpeg",table.concat(data_assembled))
			data_assembled={}
		end
	end)
	
	concommand.Add("screengrab_new",function(ply,cmd,args)
		if !ply:IsAdmin() then return end
		if args[1] then
			net.Start("bScreenGrabCommand")
			net.WriteEntity(ply)
			net.WriteString(args[1])
			if args[2] then
				ply.ScreenFileName=args[2]
				net.WriteString(args[2])
			end
			net.SendToServer()
		end
	end,function(cmd,args)
		local possibilities={}
		local str=string.Trim(args)
		for i,playah in pairs(player.GetAll()) do
			if string.find(playah:Nick(),str) then table.insert(possibilities,'screengrab_new "'..playah:Nick()..'"') end
		end
		return possibilities
	end)
end