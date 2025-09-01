/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local PublicAddonName = "Black Mesa SNPCs"
local AddonName = "Black Mesa"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_bms_autorun.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

	local vCat = "Black Mesa"
	
	VJ.AddNPC("Alien Grunt","npc_vj_bmsn_aliengrunt",vCat)
	VJ.AddNPC("BullSquid","npc_vj_bmsn_bullsquid",vCat)
	VJ.AddNPC("Houndeye","npc_vj_bmsn_houndeye",vCat)
	VJ.AddNPC("Snark","npc_vj_bmsno_snark",vCat)
	VJ.AddNPC("Snark Nest","sent_bms_snarknest",vCat)
	
	-- Zombies
	VJ.AddNPC("Zombie Marine","npc_vj_bmsz_zecu",vCat)
	VJ.AddNPC("Zombie Marine Torso","npc_vj_bmsz_zecuto",vCat)
	VJ.AddNPC("Crabless Zombie Marine","npc_vj_bmsz_zecu_nheadc",vCat)
	VJ.AddNPC("Crabless Zombie Marine Torso","npc_vj_bmsz_zecuto_nheadc",vCat)
	
	VJ.AddNPC("Zombie Guard","npc_vj_bmsz_zombiecop",vCat)
	VJ.AddNPC("Zombie Guard Torso","npc_vj_bmsz_zombiecopto",vCat)
	VJ.AddNPC("Crabless Zombie Guard","npc_vj_bmsz_zombiecop_nheadc",vCat)
	VJ.AddNPC("Crabless Zombie Guard Torso","npc_vj_bmsz_zombiecopto_nheadc",vCat)
	
	VJ.AddNPC("Zombie Scientist","npc_vj_bmsz_zombiesci",vCat)
	VJ.AddNPC("Zombie Scientist Torso","npc_vj_bmsz_zombiescito",vCat)
	VJ.AddNPC("Crabless Zombie Scientist","npc_vj_bmsz_zombiesci_nheadc",vCat)
	VJ.AddNPC("Crabless Zombie Scientist Torso","npc_vj_bmsz_zombiescito_nheadc",vCat)
	
	-- Humans
	VJ.AddNPC_HUMAN("HECU Marine","npc_vj_bmssold_marines",{"weapon_vj_bms_mp5","weapon_vj_bms_mp5","weapon_vj_bms_mp5","weapon_vj_bms_spas12"},vCat)
	VJ.AddNPC("HECU Ground Turret","npc_vj_bmssold_turret",vCat)
	VJ.AddNPC_HUMAN("Black Ops Assassin","npc_vj_bmssec_assassin",{"weapon_vj_glock17"},vCat)
	VJ.AddNPC_HUMAN("Security Guard","npc_vj_bmsfri_secruity",{"weapon_vj_glock17"},vCat)
	VJ.AddNPC("Male Scientist","npc_vj_bmsfri_scientist",vCat)
	VJ.AddNPC("Female Scientist","npc_vj_bmsfri_scientistfm",vCat)
	
	-- Spawners
	VJ.AddNPC("Random Zombie","sent_vj_bms_randz",vCat)
	VJ.AddNPC("Random Crabless Zombie","sent_vj_bms_randz_nheadc",vCat)
	VJ.AddNPC("Random Scientist","sent_vj_bms_randsci",vCat)

	-- Weapons
	VJ.AddNPCWeapon("VJ_BMS_MP5", "weapon_vj_bms_mp5")
	VJ.AddNPCWeapon("VJ_BMS_SPAS-12", "weapon_vj_bms_spas12")

	-- Particles --
	//
	
	-- Precache Models --
	util.PrecacheModel("models/gibs/agrunt/gib_back_armor.mdl")
	util.PrecacheModel("models/gibs/agrunt/gib_helmet.mdl")
	util.PrecacheModel("models/gibs/agrunt/gib_shoulder_armor.mdl")
	util.PrecacheModel("models/gibs/agrunt/left_arm_lower.mdl")
	util.PrecacheModel("models/gibs/agrunt/right_leg.mdl")
	util.PrecacheModel("models/gibs/agrunt/torso.mdl")
	util.PrecacheModel("models/gibs/bullsquid/head.mdl")
	util.PrecacheModel("models/gibs/bullsquid/left_leg.mdl")
	util.PrecacheModel("models/gibs/bullsquid/right_leg.mdl")
	util.PrecacheModel("models/gibs/bullsquid/tail.mdl")
	util.PrecacheModel("models/gibs/bullsquid/torso.mdl")
	util.PrecacheModel("models/gibs/houndeye/back_leg.mdl")
	util.PrecacheModel("models/gibs/houndeye/left_leg.mdl")
	util.PrecacheModel("models/gibs/houndeye/right_leg_lower.mdl")
	util.PrecacheModel("models/gibs/houndeye/right_leg_upper.mdl")
	util.PrecacheModel("models/gibs/houndeye/torso.mdl")
	util.PrecacheModel("models/gibs/humans/fem_sci/torso.mdl")
	util.PrecacheModel("models/gibs/humans/guard/left_arm.mdl")
	util.PrecacheModel("models/gibs/humans/guard/right_arm.mdl")
	util.PrecacheModel("models/gibs/humans/guard/right_leg.mdl")
	util.PrecacheModel("models/gibs/humans/guard/torso.mdl")
	util.PrecacheModel("models/gibs/humans/marines/left_arm.mdl")
	util.PrecacheModel("models/gibs/humans/marines/left_leg.mdl")
	util.PrecacheModel("models/gibs/humans/marines/legs.mdl")
	util.PrecacheModel("models/gibs/humans/marines/right_arm.mdl")
	util.PrecacheModel("models/gibs/humans/marines/right_leg.mdl")
	util.PrecacheModel("models/gibs/humans/marines/torso.mdl")
	util.PrecacheModel("models/gibs/humans/marines/right_leg.mdl")
	util.PrecacheModel("models/gibs/humans/scientists/left_arm.mdl")
	util.PrecacheModel("models/gibs/humans/scientists/left_leg.mdl")
	util.PrecacheModel("models/gibs/humans/scientists/right_arm.mdl")
	util.PrecacheModel("models/gibs/humans/scientists/torso.mdl")
	util.PrecacheModel("models/gibs/humans/scientists/right_leg.mdl")
	util.PrecacheModel("models/gibs/zombies/zombie_guard/legs.mdl")
	util.PrecacheModel("models/gibs/zombies/zombie_sci/left_arm.mdl")
	util.PrecacheModel("models/gibs/zombies/zombie_sci/legs.mdl")
	util.PrecacheModel("models/gibs/zombies/zombie_sci/right_arm.mdl")
	util.PrecacheModel("models/gibs/zombies/zombie_sci/torso.mdl")

	-- ConVars --
	VJ.AddConVar("vj_bms_scientist_h",60)
	//VJ.AddConVar("vj_bms_scientist_d",10)

	VJ.AddConVar("vj_bms_scientistfm_h",60)
	//VJ.AddConVar("vj_bms_scientistfm_d",10)

	VJ.AddConVar("vj_bms_security_h",60)
	VJ.AddConVar("vj_bms_security_d",10)

	VJ.AddConVar("vj_bms_marines_h",60)
	VJ.AddConVar("vj_bms_marines_d",10)
	
	VJ.AddConVar("vj_bms_turret_h",100)
	VJ.AddConVar("vj_bms_turret_d",3)
	
	VJ.AddConVar("vj_bms_assassin_h",50)
	VJ.AddConVar("vj_bms_assassin_d",10)

	VJ.AddConVar("vj_bms_aliengrunt_h",200)
	VJ.AddConVar("vj_bms_aliengrunt_d_reg",40)
	VJ.AddConVar("vj_bms_aliengrunt_d_charge",60)

	VJ.AddConVar("vj_bms_bullsquid_h",120)
	VJ.AddConVar("vj_bms_bullsquid_d_reg",40)
	VJ.AddConVar("vj_bms_bullsquid_d_spin",50)

	VJ.AddConVar("vj_bms_houndeye_h",80)
	VJ.AddConVar("vj_bms_houndeye_d",25) -- Echo = Blast

	VJ.AddConVar("vj_bms_snark_h",10)
	VJ.AddConVar("vj_bms_snark_bite_d",1)
	VJ.AddConVar("vj_bms_snark_jumpbite_d",1)
	
	VJ.AddConVar("vj_bms_zecu_h",200)
	VJ.AddConVar("vj_bms_zecu_d",25)
	
	VJ.AddConVar("vj_bms_zecu_torso_h",100)
	VJ.AddConVar("vj_bms_zecu_torso_d",25)
	
	VJ.AddConVar("vj_bms_zcop_h",100)
	VJ.AddConVar("vj_bms_zcop_d",20)
	
	VJ.AddConVar("vj_bms_zcop_torso_h",50)
	VJ.AddConVar("vj_bms_zcop_torso_d",20)
	
	VJ.AddConVar("vj_bms_zscientist_h",50)
	VJ.AddConVar("vj_bms_zscientist_d",20)

	VJ.AddConVar("vj_bms_zscientist_torso_h",25)
	VJ.AddConVar("vj_bms_zscientist_torso_d",20)

	-- Menu --
	local AddConvars = {}
	AddConvars["vj_bms_snarkexplode"] = 1 -- Snark explodes?
	AddConvars["vj_bms_snarkexplodetime"] = 15 -- Snark explode time
	AddConvars["vj_bms_bullsquid_gib"] = 1 -- Enable Bullsquid gibs?
	AddConvars["vj_bms_blackopsassassin_cloak"] = 1 -- Enable Bullsquid gibs?
	for k, v in pairs(AddConvars) do
		if !ConVarExists( k ) then CreateConVar( k, v, {FCVAR_ARCHIVE} ) end
	end

	if CLIENT then
	local function VJ_BMSMENU_MAIN(Panel)
		if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
			Panel:AddControl("Label", {Text = "#vjbase.menu.general.admin.not"})
			Panel:ControlHelp("#vjbase.menu.general.admin.only")
			return
		end
		Panel:AddControl( "Label", {Text = "Notice: Only admins can change this settings."})
		Panel:AddControl("Button",{Text = "Reset Everything", Command = "vj_bms_snarkexplode 1\n vj_bms_snarkexplodetime 15\n vj_bms_bullsquid_gib 1\n vj_bms_blackopsassassin_cloak 1"})
		Panel:AddControl("Checkbox", {Label = "Snark Explodes?", Command = "vj_bms_snarkexplode"})
		Panel:ControlHelp("Should Snark explode after its time is passed?")
		Panel:AddControl("Slider",{Label = "Time Until Snark Explodes",min = 0,max = 300,Command = "vj_bms_snarkexplodetime"})
		Panel:ControlHelp("Total of 300 seconds (5 Minutes)")
		Panel:AddControl("Checkbox", {Label = "Enable Bullsquid Gibs?", Command = "vj_bms_bullsquid_gib"})
		Panel:ControlHelp("If you are experiencing crashes when Bullsquid gibs, then disable this")
		Panel:AddControl("Checkbox", {Label = "Should Black Ops Assassin Cloak?", Command = "vj_bms_blackopsassassin_cloak"})
	end
	function VJ_ADDTOMENU_BMS()
		spawnmenu.AddToolMenuOption( "DrVrej", "SNPC Configures", "Black Mesa", "Black Mesa", "", "", VJ_BMSMENU_MAIN, {} )
	end
		hook.Add( "PopulateToolMenu", "VJ_ADDTOMENU_BMS", VJ_ADDTOMENU_BMS )
	end

-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if (CLIENT) then
		chat.AddText(Color(0,200,200),PublicAddonName,
		Color(0,255,0)," was unable to install, you are missing ",
		Color(255,100,0),"VJ Base!")
	end
	timer.Simple(1,function()
		if not VJF then
			if (CLIENT) then
				VJF = vgui.Create("DFrame")
				VJF:SetTitle("ERROR!")
				VJF:SetSize(790,560)
				VJF:SetPos((ScrW()-VJF:GetWide())/2,(ScrH()-VJF:GetTall())/2)
				VJF:MakePopup()
				VJF.Paint = function()
					draw.RoundedBox(8,0,0,VJF:GetWide(),VJF:GetTall(),Color(200,0,0,150))
				end
				
				local VJURL = vgui.Create("DHTML",VJF)
				VJURL:SetPos(VJF:GetWide()*0.005, VJF:GetTall()*0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbasemissing")
			elseif (SERVER) then
				timer.Create("VJBASEMissing",5,0,function() print("VJ Base is Missing! Download it from the workshop!") end)
			end
		end
	end)
end