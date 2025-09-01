AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "ent_jack_hmcd_loot_base"
ENT.PrintName		= "Sheet of paper"
ENT.SWEP="wep_hmcd_mansion_pencils"
--ENT.ImpactSound="physics/wood/wood_plank_impact_soft1.wav"
	function ENT:Initialize()
	
	if(SERVER)then
		util.AddNetworkString("mansion_sheet"..self:EntIndex())
		--util.AddNetworkString("mansion_sheet_pc"..self:EntIndex()) --One day...
	end
	self.NextUpdate=CurTime()+1
	--DrawData={}
	--ColorData={} --@useless for now
	--ScaleData={}
	self.DrawData={} 
	self.ColorData={} 
	self.ScaleData={}
	self.X=nil
	self.Y=nil
	self.Colour=nil
	self.Scale=nil
	SHEET_PREVENT_DOUBLE=0
	if(SERVER)then
		self.Entity:SetModel("models/mu_hmcd_mansion/sheet.mdl")
		--models/props_junk/garbage_carboard002a.mdl
		--models/mu_hmcd_mansion/sheet.mdl
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(1)
			phys:Wake()
			phys:EnableMotion(true)
		end
		end
		
	if(CLIENT)then
		local Con=GetConVar( "mansion_sheetdots" )
		MANSION_DotCount=Con:GetInt()--About time
	cvars.AddChangeCallback( "mansion_sheetdots", function(newValue)
		if(self.DrawData==nil)then return end 
		local Con=GetConVar( "mansion_sheetdots" )
		local OLDDotCount=MANSION_DotCount
		MANSION_DotCount=Con:GetInt()--Care about your pc, nya~
						
		local compare =	MANSION_DotCount-table.maxn(self.DrawData)
		if(compare<0)then
		maxn = table.maxn(self.DrawData)
		comp=math.abs(compare)
			for key=1, comp do
					table.remove( self.DrawData , 1 )
					table.remove( self.ColorData , 1 )--So many purple words...
					table.remove( self.ScaleData , 1 )					
				
			end 
		end
		end) --This is end of it, se ya in the next line~
	end 	 --this line ends this part, not this line and not the next~
	
	end
	
gameevent.Listen( "player_connect" )
hook.Add( "player_connect", "mansion_sheet_render_issues", function( data )
SHEET_RESETID=data.index
end)
function ENT:Think()
	if(CLIENT)then 
		if(SHEET_RESETID~=nil and SHEET_RESETID==LocalPlayer():EntIndex())then
			for ky,obj in pairs(ents.FindByClass('ent_hmcd_mansion_sheet'))do
				print(obj)
				--[[
				obj.DrawData={}
				obj.ColorData={}
				obj.ScaleData={}
				obj.X=nil
				obj.Y=nil
				obj.Colour=nil
				obj.Scale=nil 
				]]
			end			
		end
					SHEET_RESETID=nil
	end
end	


	
	function ENT:SetupDataTables()
	--
	--self:NetworkVar("String",0,"Draw")
	--self:NetworkVar("String",1,"Colour")
	end
	function ENT:PickUp(ply)
		ply:PickupObject(self)
	end
	
	function ENT:DrawDot(X,Y,Colour,Scale)
	if(SERVER)then
		if(MANSION_ALLOWEDDRAWING==false)then return end
		local	D=math.Round(-X).." "..math.Round(-Y).." 0"
		local	C=math.Round(Colour.r).." "..math.Round(Colour.g).." "..math.Round(Colour.b)
		local	S=Scale	
		if(math.Round(Colour.a) == 0)then
		   E=1
		else
		   E=0
		end

			if(self.DrawData[table.maxn(self.DrawData)]==D)then--SUKA NAXUY BLYAT HaRDBAS
			--DO NOTHING
					else
					if(E==0)then
				table.insert(self.DrawData,D)
				table.insert(self.ColorData,C)
				table.insert(self.ScaleData,S)
					elseif(E==1)then 
						local ED=Vector(D)
						for key=1, table.maxn(self.DrawData) do	
							local E_DOT=Vector(self.DrawData[key])
								if(ED:DistToSqr(E_DOT)<S*2)then
									table.remove( self.DrawData , key )
									table.remove( self.ColorData , key )
									table.remove( self.ScaleData , key )
							end
						end
					end
				end
					--if(MANSION_DotCount==nil)then MANSION_DotCount=150 end
				if(table.maxn(self.DrawData)>2000)then
				table.remove( self.DrawData , 1 )
				table.remove( self.ColorData , 1 )
				table.remove( self.ScaleData , 1 )
			end
		
					net.Start("mansion_sheet"..self:EntIndex()) --expensive??? pfffttt what are you barking about?
					net.WriteString( D )
					net.WriteString( C )
					net.WriteInt( S, 4 )
					net.WriteInt( E, 3 ) -- 1|0
					net.Broadcast()
		
	end
	end
	
	
	--function ENT:Think()
	--[[
	if(SERVER)then
			if(self.X!=nil)then
			D=math.Round(-self.X).." "..math.Round(-self.Y).." 0"
			C=math.Round(self.Colour.r).." "..math.Round(self.Colour.g).." "..math.Round(self.Colour.b)
			S=self.Scale
			if(self.DrawData[table.maxn(self.DrawData)]==D)then
			
					else 
				table.insert(self.DrawData,D)
				table.insert(self.ColorData,C)
				table.insert(self.ScaleData,S)
					end
				if(table.maxn(self.DrawData)>150)then
				table.remove( self.DrawData , 1 )
				table.remove( self.ColorData , 1 )
				table.remove( self.ScaleData , 1 )
			end
				if(self.Update)then
				--PrintTable(DrawData)
				--DD=util.TableToJSON(DrawData) --Compressing the data(Doesn't working)
				--CD=util.TableToJSON(ColorData)
				
				--ReadyDD=util.Compress( DD )
				--ReadyCD=util.Compress( CD )
				--print(ReadyDD)
					net.Start("mansion_sheet"..self:EntIndex())
					--net.WriteString( DD )
					--net.WriteString( CD )
					net.WriteString( D )
					net.WriteString( C )
					net.WriteInt( S, 4 )
					--net.WriteInt(self:EntIndex(), 13)--WriteEnt is expensive, so instead we gonna write EntIndex in net name instead
					net.Broadcast()
					--self.NextUpdate=CurTime()+1
					self.Update=false
				end
			end
	end
	--]]
--	end
	function ENT:OnRemove()
		--hook.Remove( 'player_connect', 'mansion_sheet_np' )
		hook.Remove( 'player_connect', 'mansion_sheet_np' )
		-----------RESETING TABLES SO THEY DONT ACCUMULATE ON CLIENT AND SERVER-------------
			if(SERVER)then
				self.DrawData=nil
				self.ColorData=nil
				self.ScaleData=nil
			end
			if(CLIENT)then
				self.DrawData=nil
				self.ColorData=nil
				self.ScaleData=nil
			end
	end
	
	function ENT:Draw()--Hi again! Here, in this function lies ultimate power of drawing, good luck exploring it~
	if(CLIENT)then
			net.Receive("mansion_sheet"..self:EntIndex(),function()
			--print(IsValid(self),self)
			if (IsValid(self) and self~=nil)then 
			--print(123)
				--DD=net.ReadString()
				--CD=net.ReadString()
				local D=net.ReadString()
				local C=net.ReadString()
				local S=net.ReadInt(4)
				local E=net.ReadInt(3)
			if(self.DrawData==nil)then
				self.DrawData={}
				self.ColorData={}
				self.ScaleData={}			
			end
			if(self.DrawData[table.maxn(self.DrawData)]==D)then--DOES THIS EVEN READABLE? BAD FOR YOU, CODERS(ofc you can explore and learn from this)
			--DO NOTHING
					else
					if(E==0)then
				table.insert(self.DrawData,D)
				table.insert(self.ColorData,C)
				table.insert(self.ScaleData,S)
					elseif(E==1)then 
						local ED=Vector(D)
						for key=1, table.maxn(self.DrawData) do	
							local E_DOT=Vector(self.DrawData[key])
								if(ED:DistToSqr(E_DOT)<S*2)then
									table.remove( self.DrawData , key )
									table.remove( self.ColorData , key )
									table.remove( self.ScaleData , key )
							end
						end
					end
				end
					if(MANSION_DotCount==nil)then MANSION_DotCount=150 end
				if(table.maxn(self.DrawData)>MANSION_DotCount)then
				table.remove( self.DrawData , 1 )
				table.remove( self.ColorData , 1 )
				table.remove( self.ScaleData , 1 )
			end
			
			end
				--DDD=util.Decompress( DD )
				--DCD=util.Decompress( CD )
				--print(DDD)
				
				--DrawData = util.JSONToTable( DD )
				--ColorData = util.JSONToTable( CD )
				--PrintTable(DrawData)
			end)
				--[[		
			net.Receive("mansion_sheet_pc"..self:EntIndex(),function(len)
				self.DD=net.ReadString()
				self.CD=net.ReadString()
				self.SD=net.ReadString()
				self.DrawData = util.JSONToTable( self.DD )
				self.ColorData = util.JSONToTable( self.CD )
				self.ScaleData = util.JSONToTable( self.SD )
				--PrintTable(DrawData)
			end)
			]]
	self:DrawModel()
	self.Angle = self:GetAngles()
	self.Pos = self:GetPos()
	
			--	if(self.DrawData~=nil)then
	--Cam3D2D Panel top and display--
	self.Angle:RotateAroundAxis(self.Angle:Up(), 180)
	cam.Start3D2D(self.Pos + self.Angle:Up() *0.1 , self.Angle , 0.1)
	--PrintTable(DrawX)
		if(self.DrawData==nil)then self.DrawData={"0 0 0"} end
		if(self.ColorData==nil)then self.ColorData={"0 0 0"} end
		if(self.ScaleData==nil)then self.ScaleData={0} end
		for key=1, table.maxn(self.DrawData) do
		if not(self.ColorData[key]=="")then
		local D=Vector(self.DrawData[key])
		local C=Vector(self.ColorData[key])
		local S=self.ScaleData[key] or 1
		surface.SetDrawColor(C.x, C.y, C.z)
		 surface.DrawRect(D.x,D.y,S,S) 
		end
		end
	--print(123)
	--end
	--draw.RoundedBox(0,-125,-90,250,170,Color(255,0,0)) 
	
	cam.End3D2D() 
	--end
	end
end
	
if(CLIENT)then
	--
end