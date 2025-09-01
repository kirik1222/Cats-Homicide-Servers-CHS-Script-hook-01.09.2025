AddCSLuaFile()
ENT.Type="anim"
ENT.RenderColor=Color(150,150,150,0)
if SERVER then
	function ENT:Initialize()
		self:SetModel("models/woodenplank.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType(SIMPLE_USE)
		self:DrawShadow(true)
	end
else
	function ENT:Draw()
		self:DrawModel()
		local dist=LocalPlayer():GetShootPos():Distance(self:GetPos())
		if dist<300 then
			local a=math.min(300-dist,255)
			local entAlpha=self:GetColor().a
			if a>entAlpha then a=entAlpha end
			self.RenderColor.a=a
			local ang=self:GetAngles()
			cam.Start3D2D(self:GetPos()+ang:Right()*-0.6+ang:Up()*1.5,Angle(-10,-90,90),0.05)
				local tW, tH = surface.GetTextSize( "Yahet" )
				draw.SimpleText( "Yahet", "TombstoneText", -tW / 2, pos, self.RenderColor )
			cam.End3D2D()
		end
	end
end