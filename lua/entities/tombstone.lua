AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderColor=Color(150,150,150,0)
ENT.MatRenderColor=Color(255,255,255,0)
if CLIENT then
	function ENT:Initialize()
		self:SetRenderBounds(Vector(-1,-12,-21),Vector(1,12,21))
	end
	function ENT:Draw()
		local info=TOMBSTONES[self:GetNWInt("Num")]
		if info then
			local dist=LocalPlayer():GetShootPos():Distance(self:GetPos())
			if dist<300 then
				local pos=256*(info[4] or 1)-64
				local a=math.min(300-dist,255)
				self.RenderColor.a=a
				self.MatRenderColor.a=a
				cam.Start3D2D(self:GetPos()+Vector(-0.01,0,15),Angle(0,-90,90),0.05)
					surface.SetMaterial(info[1])
					surface.SetDrawColor(self.MatRenderColor)
					surface.DrawTexturedRect(-128,-64,256*(info[3] or 1),256*(info[4] or 1))
					for i,text in pairs(info[2]) do
						surface.SetFont( "TombstoneText" )
						local tW, tH = surface.GetTextSize( text )
						draw.SimpleText( text, "TombstoneText", -tW / 2, pos, self.RenderColor )
						pos=pos+tH
					end
				cam.End3D2D()
			end
		end
	end
else
	function ENT:UpdateTransmitState()	
		return TRANSMIT_PVS
	end
	function ENT:Initialize()
		if self:GetPos()!=Vector(-194,832,147) then
			local rand,ind=table.Random(FREE_TOMBSTONES)
			self:SetNWInt("Num",rand)
			FREE_TOMBSTONES[ind]=nil
		else
			self:SetNWInt("Num",-1)
		end
	end
end