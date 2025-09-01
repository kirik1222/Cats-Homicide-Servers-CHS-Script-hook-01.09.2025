GM.Name = "Homicided"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"
GM.Version = 1

local EntityMeta=FindMetaTable("Entity")

player_manager.AddValidModel( "Jesus", "models/jesus/jesus.mdl");
player_manager.AddValidHands( "Jesus", "models/weapons/jesus_arms.mdl" ,0 ,"00000000" )

game.AddParticles("particles/pcfs_jack_muzzleflashes.pcf")
game.AddParticles("particles/pcfs_jack_explosions_small3.pcf")
game.AddParticles("particles/pcfs_jack_explosions_incendiary2.pcf")
game.AddParticles("particles/cw_kk_ins2/explosion_fx_ins.pcf")
game.AddParticles("particles/cw_kk_ins2/explosion_fx_ins_b.pcf")
game.AddParticles("particles/cw_kk_ins2/weapon_fx_ins.pcf")
game.AddParticles("particles/alien_isolation.pcf")
game.AddParticles("particles/ar2_muzzle.pcf")
game.AddParticles("particles/huy.pcf")
game.AddParticles("particles/combineexplosion.pcf")
game.AddParticles("particles/combine_fx.pcf")
game.AddParticles("particles/matches.pcf")
game.AddParticles("particles/lighter.pcf")
game.AddDecal("hmcd_jackanail","decals/mat_jack_hmcd_nailhead")
game.AddDecal("hmcd_jackatape","decals/mat_jack_hmcd_ducttape")
game.AddDecal("PepperSpray_1","effects/pepperspray1")
game.AddDecal("PepperSpray_2","effects/pepperspray2")
game.AddDecal("PepperSpray_3","effects/pepperspray3")
game.AddDecal("FireExt_1","effects/extinguish1")
game.AddDecal("FireExt_2","effects/extinguish2")
PrecacheParticleSystem("match_flame")
PrecacheParticleSystem("lighter_flame")
PrecacheParticleSystem("pcf_jack_mf_mrifle2")
PrecacheParticleSystem("pcf_jack_mf_suppressed")
PrecacheParticleSystem("pcf_jack_mf_barrelsmoke")
PrecacheParticleSystem("pcf_jack_mf_spistol")
PrecacheParticleSystem("fire_jet_01_flame")
local explosionParticles={
	"ins_molotov_smoke",
	"ins_molotov_flame_b",
	"ins_molotov_flamewave",
	"ins_molotov_burst_b",
	"ins_molotov_burst_glass",
	"ins_molotov_trailers",
	"ins_molotov_burst_flame",
	"ins_molotov_burst",
	"ins_molotov_trails",
	"ins_molotov_flash"
}
for i=1,table.Count(explosionParticles),1 do
	PrecacheParticleSystem(explosionParticles[i])
end

team.SetUp(1,"Spectators",Color(150,150,150))
team.SetUp(2,"Players",Color(26,120,245))

HMCD_EvacuationZones={
	["zs_adrift_v2"]=Vector(5235, -7961, 801),
	["gm_school"]=Vector(303, 908, 60),
	["ttt_abandonedsubway"]=Vector(-636, -6420, -151),
	["gm_hetveer_huy"]=Vector(-927, 2973, 168),
	["gm_stage_6"]=Vector(3257, 598, 40),
	["gm_stage_old"]=Vector(1766, 615, 40),
	["ttt_bbicotka_huy"]=Vector(-1804, 1526, -215),
	["ttt_bank_b13"]=Vector(5488, 4973, 4776),
	["gm_eliden"]=Vector(396, -1161, 40),
	["mu_hmcd_workplace_v3"]=Vector(40, -1260, 40),
	["mu_hmcd_mansion"]=Vector(31, -1889, 40),
	["ttt_terrortrain_2020_b2"]=Vector(-322, 5522, 27),
	["gm_zabroshka"]=Vector(-2840,765,389),
	["zs_storm_hmcd"]=Vector(2083,-262,-10),
	["gm_gleb"]=Vector(-343,-548,360)
}

HMCD_SurfaceHardness={
	[MAT_METAL]=.95,[MAT_COMPUTER]=.95,[MAT_VENT]=.95,[MAT_GRATE]=.05,[MAT_FLESH]=.5,[MAT_ALIENFLESH]=.3,
	[MAT_SAND]=.1,[MAT_DIRT]=.3,[74]=.1,[85]=.2,[MAT_WOOD]=.5,[MAT_FOLIAGE]=.5,
	[MAT_CONCRETE]=.9,[MAT_TILE]=.8,[MAT_SLOSH]=.05,[MAT_PLASTIC]=.3,[MAT_GLASS]=.6
}

HMCD_SurfaceRicochet={
	[MAT_METAL]=.2,[MAT_COMPUTER]=.2,[MAT_VENT]=.2,[MAT_GRATE]=.1,[MAT_FLESH]=0,[MAT_ALIENFLESH]=0,
	[MAT_SAND]=0,[MAT_DIRT]=.1,[MAT_SNOW]=0,[MAT_GRASS]=.1,[MAT_WOOD]=.1,[MAT_FOLIAGE]=0,
	[MAT_CONCRETE]=.2,[MAT_TILE]=.2,[MAT_SLOSH]=0,[MAT_PLASTIC]=0,[MAT_GLASS]=.1
}

HMCD_ValidClothes={
	"normal","casual","formal","young","cold","striped","plaid"
}

HMCD_ValidModels={
	"male01","male02","male03",
	"male04","male05","male06",
	"male07","male08","male09",
	"female01","female02","female03",
	"female04","female05","female06"
}

HMCD_Accessories={
	["none"]={},
	["eyeglasses"]={"models/captainbigbutt/skeyler/accessories/glasses01.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(2.1,3,0),Angle(0,-70,-90),.9},["female"]={Vector(2.75,2,0),Angle(0,-70,-90),.8},0},
	["bugeye sunglasses"]={"models/captainbigbutt/skeyler/accessories/glasses02.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(2.9,2.2,0),Angle(0,-70,-90),.9},["female"]={Vector(3.5,1.25,0),Angle(0,-70,-90),.8},0},
	["large sunglasses"]={"models/captainbigbutt/skeyler/accessories/glasses04.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(3.25,2.4,0),Angle(0,-70,-90),.9},["female"]={Vector(3.5,1.25,0),Angle(0,-70,-90),.8},0},
	["aviators"]={"models/gmod_tower/aviators.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(2.75,2.9,0),Angle(0,-75,-90),.9},["female"]={Vector(2.8,1.9,0),Angle(0,-75,-90),.85},0},
	["transparent aviators"]={"models/arctic_nvgs/aviators.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(1,0.6,0),Angle(0,-75,-90),.9},["female"]={Vector(0.7,0,0),Angle(0,-75,-90),.85},0},
	["nerd glasses"]={"models/gmod_tower/klienerglasses.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(2.6,2.9,0),Angle(0,-75,-90),1},["female"]={Vector(2.6,2.3,0),Angle(0,-80,-90),.9},0},
	["headphones"]={"models/gmod_tower/headphones.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.5,3,0),Angle(0,-90,-90),.9},["female"]={Vector(1,2.3,0),Angle(0,-90,-90),.8},0},
	["baseball cap"]={"models/gmod_tower/jaseballcap.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.05,5.1,0),Angle(0,-75,-90),1.125},["female"]={Vector(0,4.2,0),Angle(0,-75,-90),1.1},isHat=true,0},
	["fedora"]={"models/captainbigbutt/skeyler/hats/fedora.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.25,5.5,0),Angle(0,-75,-90),.7},["female"]={Vector(0,4.8,0),Angle(0,-75,-90),.65},isHat=true,0},
	["stetson"]={"models/captainbigbutt/skeyler/hats/cowboyhat.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.3,6,0),Angle(0,-70,-90),.75},["female"]={Vector(.25,5.6,0),Angle(0,-75,-90),.7},isHat=true,0},
	["straw hat"]={"models/captainbigbutt/skeyler/hats/strawhat.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.75,5,0),Angle(0,-75,-90),.85},["female"]={Vector(.5,4.5,0),Angle(0,-75,-90),.75},isHat=true,0},
	["sun hat"]={"models/captainbigbutt/skeyler/hats/sunhat.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(-1.5,3.5,0),Angle(0,-75,-90),.8},["female"]={Vector(-1.5,3,0),Angle(0,-75,-90),.75},isHat=true,0},
	["bling cap"]={"models/captainbigbutt/skeyler/hats/zhat.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.7,3.75,.3),Angle(0,-75,-90),.75},["female"]={Vector(.3,3,.25),Angle(0,-75,-90),.75},isHat=true,0},
	["top hat"]={"models/player/items/humans/top_hat.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(2,-1,0),Angle(0,-80,-90),1.025},["female"]={Vector(2,-1,0),Angle(0,-80,-90),.95},isHat=true,0},
	["backpack"]={"models/makka12/bag/jag.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(0,-3,0),Angle(0,90,90),.7},["female"]={Vector(.5,-3,0),Angle(0,90,90),.6},0},
	["purse"]={"models/props_c17/BriefCase001a.mdl","ValveBiped.Bip01_Spine1",["male"]={Vector(-3,-10,7),Angle(0,90,90),.6},["female"]={Vector(-3,-10,7),Angle(0,90,90),.6},0},
	-- gen 2
	["gray cap"]={"models/modified/hat07.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.1,4.5,.2),Angle(0,-75,-90),1},["female"]={Vector(0,4.5,0),Angle(0,-75,-90),.95},isHat=true,0},
	["light gray cap"]={"models/modified/hat07.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.1,4.5,.2),Angle(0,-75,-90),1},["female"]={Vector(0,4.5,0),Angle(0,-75,-90),.95},isHat=true,2},
	["white cap"]={"models/modified/hat07.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.1,4.5,.2),Angle(0,-75,-90),1},["female"]={Vector(0,4.5,0),Angle(0,-75,-90),.95},isHat=true,3},
	["green cap"]={"models/modified/hat07.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.1,4.5,.2),Angle(0,-75,-90),1},["female"]={Vector(0,4.5,0),Angle(0,-75,-90),.95},isHat=true,4},
	["dark green cap"]={"models/modified/hat07.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.1,4.5,.2),Angle(0,-75,-90),1},["female"]={Vector(0,4.5,0),Angle(0,-75,-90),.95},isHat=true,5},
	["brown cap"]={"models/modified/hat07.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.1,4.5,.2),Angle(0,-75,-90),1},["female"]={Vector(0,4.5,0),Angle(0,-75,-90),.95},isHat=true,6},
	["blue cap"]={"models/modified/hat07.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.1,4.5,.2),Angle(0,-75,-90),1},["female"]={Vector(0,4.5,0),Angle(0,-75,-90),.95},isHat=true,7},

	["bandana"]={"models/modified/bandana.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(1.1,-1.2,0),Angle(0,-75,-90),1},["female"]={Vector(1,-1.5,0),Angle(0,-80,-90),.9},0},

	["white scarf"]={"models/sal/acc/fix/scarf01.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(-10,-17,0),Angle(0,70,90),1},["female"]={Vector(-9,-19.5,0),Angle(0,70,90),1},0},
	["gray scarf"]={"models/sal/acc/fix/scarf01.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(-10,-17,0),Angle(0,70,90),1},["female"]={Vector(-9,-19.5,0),Angle(0,70,90),1},1},
	["black scarf"]={"models/sal/acc/fix/scarf01.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(-10,-17,0),Angle(0,70,90),1},["female"]={Vector(-9,-19.5,0),Angle(0,70,90),1},2},
	["blue scarf"]={"models/sal/acc/fix/scarf01.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(-10,-17,0),Angle(0,70,90),1},["female"]={Vector(-9,-19.5,0),Angle(0,70,90),1},3},
	["red scarf"]={"models/sal/acc/fix/scarf01.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(-10,-17,0),Angle(0,70,90),1},["female"]={Vector(-9,-19.5,0),Angle(0,70,90),1},4},
	["green scarf"]={"models/sal/acc/fix/scarf01.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(-10,-17,0),Angle(0,70,90),1},["female"]={Vector(-9,-19.5,0),Angle(0,70,90),1},5},
	["pink scarf"]={"models/sal/acc/fix/scarf01.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(-10,-17,0),Angle(0,70,90),1},["female"]={Vector(-9,-19.5,0),Angle(0,70,90),1},6},

	["red earmuffs"]={"models/modified/headphones.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(1,2.5,0),Angle(0,-90,-90),.9},["female"]={Vector(1,2,0),Angle(0,-90,-90),.9},0},
	["pink earmuffs"]={"models/modified/headphones.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(1,2.5,0),Angle(0,-90,-90),.9},["female"]={Vector(1,2,0),Angle(0,-90,-90),.9},1},
	["green earmuffs"]={"models/modified/headphones.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(1,2.5,0),Angle(0,-90,-90),.9},["female"]={Vector(1,2,0),Angle(0,-90,-90),.9},2},
	["yellow earmuffs"]={"models/modified/headphones.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(1,2.5,0),Angle(0,-90,-90),.9},["female"]={Vector(1,2,0),Angle(0,-90,-90),.9},3},

	["gray fedora"]={"models/modified/hat01_fix.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(-.1,4.1,0),Angle(0,-75,-90),.9},["female"]={Vector(-.5,4,0),Angle(0,-75,-90),.9},isHat=true,0},
	["black fedora"]={"models/modified/hat01_fix.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(-.1,4.1,0),Angle(0,-75,-90),.9},["female"]={Vector(-.5,4,0),Angle(0,-75,-90),.9},isHat=true,1},
	["white fedora"]={"models/modified/hat01_fix.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(-.1,4.1,0),Angle(0,-75,-90),.9},["female"]={Vector(-.5,4,0),Angle(0,-75,-90),.9},isHat=true,2},
	["beige fedora"]={"models/modified/hat01_fix.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(-.1,4.1,0),Angle(0,-75,-90),.9},["female"]={Vector(-.5,4,0),Angle(0,-75,-90),.9},isHat=true,3},
	["black/red fedora"]={"models/modified/hat01_fix.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(-.1,4.1,0),Angle(0,-75,-90),.9},["female"]={Vector(-.5,4,0),Angle(0,-75,-90),.9},isHat=true,5},
	["blue fedora"]={"models/modified/hat01_fix.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(-.1,4.1,0),Angle(0,-75,-90),.9},["female"]={Vector(-.5,4,0),Angle(0,-75,-90),.9},isHat=true,7},
	["christmas hat"]={"models/xmas/hat.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(-.1,7.1,0),Angle(0,-75,-90),1.1},["female"]={Vector(0.5,6.1,0),Angle(0,-75,-90),1.15},isHat=true,7},

	["striped beanie"]={"models/modified/hat03.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.1,4,0),Angle(0,-75,-90),1},["female"]={Vector(-.2,3.5,0),Angle(0,-75,-90),1},isHat=true,0},
	["periwinkle beanie"]={"models/modified/hat03.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.1,4,0),Angle(0,-75,-90),1},["female"]={Vector(-.2,3.5,0),Angle(0,-75,-90),1},isHat=true,1},
	["fuschia beanie"]={"models/modified/hat03.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.1,4,0),Angle(0,-75,-90),1},["female"]={Vector(-.2,3.5,0),Angle(0,-75,-90),1},isHat=true,2},
	["white beanie"]={"models/modified/hat03.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.1,4,0),Angle(0,-75,-90),1},["female"]={Vector(-.2,3.5,0),Angle(0,-75,-90),1},isHat=true,3},
	["gray beanie"]={"models/modified/hat03.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.1,4,0),Angle(0,-75,-90),1},["female"]={Vector(-.2,3.5,0),Angle(0,-75,-90),1},isHat=true,4},

	["large red backpack"]={"models/modified/backpack_1.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(-2,-8,0),Angle(0,90,90),1},["female"]={Vector(-2,-8,0),Angle(0,90,90),.9},0},
	["large gray backpack"]={"models/modified/backpack_1.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(-2,-8,0),Angle(0,90,90),1},["female"]={Vector(-2,-8,0),Angle(0,90,90),.9},1},

	["medium backpack"]={"models/modified/backpack_3.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(-3,-6,0),Angle(0,90,90),.9},["female"]={Vector(-3,-6,0),Angle(0,90,90),.8},0},
	["medium gray backpack"]={"models/modified/backpack_3.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(-3,-6,0),Angle(0,90,90),.9},["female"]={Vector(-3,-6,0),Angle(0,90,90),.8},1},
	["grenade"]={"models/weapons/w_jj_fraggrenade.mdl","ValveBiped.Bip01_R_Hand",["male"]={Vector(2,3,-1.5),Angle(0,0,180),.9},["female"]={Vector(2,3,-1.5),Angle(0,0,180),.9},0,notAllowed=true},
	["balaclava_1"]={"models/balaklava/phoenix_balaclava.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.3,0,0),Angle(0,-75,-90),1},["female"]={Vector(.3,0,0),Angle(0,-75,-90),1},4,models={
		["male_01"]={Vector(.9,0,-0.1),Angle(0,-75,-90)},
		["male_02"]={Vector(.6,-.5,0.05),Angle(0,-75,-90)},
		["male_03"]={Vector(.9,-.3,-0.1),Angle(0,-75,-90)},
		["male_06"]={Vector(1,0.15,0.1),Angle(0,-75,-90),scale=1.05},
		["male_07"]={Vector(.45,-.35,0.05),Angle(0,-75,-90)},
		["male_09"]={Vector(.85,0,0.05),Angle(0,-75,-90)}
	},
	notAllowed=true},
	["balaclava_2"]={"models/balaklava/arctic_balaclava.mdl","ValveBiped.Bip01_Head1",["male"]={Vector(.3,-.5,0.05),Angle(0,-75,-90),1},["female"]={Vector(.3,0,0),Angle(0,-75,-90),1},4,models={
			["male_01"]={Vector(.9,0,-0.1),Angle(0,-75,-90)},
			["male_02"]={Vector(.6,-.5,0.05),Angle(0,-75,-90)},
			["male_03"]={Vector(.9,-.3,-0.1),Angle(0,-75,-90)},
			["male_04"]={Vector(.9,-.3,0),Angle(0,-75,-90)},
			["male_06"]={Vector(1,0.15,0.1),Angle(0,-75,-90),scale=1.1},
			["male_07"]={Vector(.45,-.35,0.05),Angle(0,-75,-90)},
			["male_09"]={Vector(.85,-.5,0.05),Angle(0,-75,-90)}
		},
		notAllowed=true,scale=1.06
	},
	["jetpack"]={"models/sa_jetpack.mdl","ValveBiped.Bip01_Spine4",["male"]={Vector(-5,-20,0),Angle(0,90,90),1},["female"]={Vector(-5,-20,2),Angle(0,90,90),1},0,notAllowed=true}
}

function HMCD_InsideVolume(pos,vec1,vec2)
	local max_x,max_y,max_z,min_x,min_y,min_z=vec1.x,vec1.y,vec1.z,vec2.x,vec2.y,vec2.z
	if max_x<min_x then
		local temp=max_x
		max_x=min_x
		min_x=temp
	end
	if max_y<min_y then
		local temp=max_y
		max_y=min_y
		min_y=temp
	end
	if max_z<min_z then
		local temp=max_z
		max_z=min_z
		min_z=temp
	end
	return pos.x>=min_x and pos.x<=max_x and pos.y>=min_y and pos.y<=max_y and pos.z>=min_z and pos.z<=max_z
end

function RegisterLangs()
	local rootFolder = (GM or GAMEMODE).Folder:sub(11).."/gamemode/lang/"
	local files, directories = file.Find( rootFolder.."*", "LUA" )
	for i,obj in pairs(files) do
		AddCSLuaFile(rootFolder..obj)
		include(rootFolder..obj)
	end
end

function Translate(phrase,lang,mainmode,mode)
	if not(lang) and CLIENT then lang=GetConVar("hmcd_language"):GetString() end
	if not(lang and _G["HMCD_LANGUAGE_"..lang]) then lang="english" end
	if(mainmode==nil or mode==nil)then 
		
		return _G["HMCD_LANGUAGE_"..lang][phrase]
	else
		if(_G["HMCD_LANGUAGE_"..lang][mainmode][mode][phrase]~=nil)then
			if isfunction(_G["HMCD_LANGUAGE_"..lang][mainmode][mode][phrase]) then
				return _G["HMCD_LANGUAGE_"..lang][mainmode][mode][phrase]()
			else
				return _G["HMCD_LANGUAGE_"..lang][mainmode][mode][phrase]			
			end
		else
			return _G["HMCD_LANGUAGE_"..lang]["Classic"]["Normal"][phrase]
		end
	end
end

local clothingIndexes={
	["male_01"]=3,
	["male_02"]=2,
	["male_03"]=4,
	["male_04"]=4,
	["male_05"]=4,
	["male_06"]=0,
	["male_07"]=4,
	["male_08"]=0,
	["male_09"]=2,
	["female_01"]=2,
	["female_02"]=3,
	["female_03"]=3,
	["female_04"]=1,
	["female_05"]=2,
	["female_06"]=4
}

function HMCD_FindClothingIndex(model)
	model=string.Replace(model,"models/player/group01/","")
	model=string.Replace(model,".mdl","")
	return clothingIndexes[model] or -1
end

function HMCD_WhomILookinAt(ply,cone,dist)
	local CreatureTr,ObjTr,OtherTr=nil,nil,ni
		local Vec=(ply:GetAimVector()+VectorRand()*cone):GetNormalized()
		local Tr=util.QuickTrace(ply:GetShootPos(),ply:GetAimVector()*dist,{ply})
		if((Tr.Hit)and not(Tr.HitSky)and(Tr.Entity))then
			local Ent,Class=Tr.Entity,Tr.Entity:GetClass()
			if((Ent:IsPlayer())or(Ent:IsNPC()))then
				CreatureTr=Tr
			elseif((Class=="prop_physics")or(Class=="prop_physics_multiplayer")or(Class=="prop_ragdoll")or(Ent.IsLoot))then
				ObjTr=Tr
			else
				OtherTr=Tr
			end
		else
			for i=1,(150*cone) do
				local Vec=(ply:GetAimVector()+VectorRand()*cone):GetNormalized()
				local Tr=util.QuickTrace(ply:GetShootPos(),Vec*dist,{ply})
				if((Tr.Hit)and not(Tr.HitSky)and(Tr.Entity))then
					local Ent,Class=Tr.Entity,Tr.Entity:GetClass()
					if((Ent:IsPlayer())or(Ent:IsNPC()))then
						CreatureTr=Tr
					elseif((Class=="prop_physics")or(Class=="prop_physics_multiplayer")or(Class=="prop_ragdoll")or(Ent.IsLoot))then
						ObjTr=Tr
					else
						OtherTr=Tr
					end
				end
			end
		end
	if(CreatureTr)then return CreatureTr.Entity,CreatureTr.HitPos,CreatureTr.HitNormal,CreatureTr.HitGroup end
	if(ObjTr)then return ObjTr.Entity,ObjTr.HitPos,ObjTr.HitNormal,ObjTr.HitGroup end
	if(OtherTr)then return OtherTr.Entity,OtherTr.HitPos,OtherTr.HitNormal,OtherTr.HitGroup end
	return nil,nil,nil
end

local FragMats={
	["canister"]=true,
	["chain"]=true,
	["combine_metal"]=true,
	["floating_metal_barrel"]=true,
	["grenade"]=true,
	["metal"]=true,
	["metal_barrel"]=true,
	["metal_bouncy"]=true,
	["Metal_Box"]=true,
	["metal_seafloorcar"]=true,
	["metalgrate"]=true,
	["metalpanel"]=true,
	["metalvent"]=true,
	["metalvehicle"]=true,
	["paintcan"]=true,
	["roller"]=true,
	["slipperymetal"]=true,
	["solidmetal"]=true,
	["weapon"]=true,
	["glass"]=true,
	["combine_glass"]=true,
	["computer"]=true
}

HMCD_DamageTypes={
	[DMG_SLASH]="slashed",
	[DMG_CLUB]="beaten",
	[DMG_BURN]="immolated",
	[DMG_DIRECT]="burned",
	[DMG_CRUSH]="thwacked",
	[DMG_GENERIC]="damaged",
	[DMG_SHOCK]="electrocuted",
	[DMG_BULLET]="shot",
	[DMG_BUCKSHOT]="blast-fragment shredded",
	[DMG_POISON]="poisoned",
	[DMG_BLAST]="blasted",
	[DMG_DROWN]="asphyxiated",
	[DMG_DISSOLVE]="moleculary disassembled",
	[DMG_DROWNRECOVER]="backblasted",
	[DMG_SNIPER]="poisoned"
}

HMCD_FlammableModels={
	["models/props_c17/canister01a.mdl"]=true,
	["models/props_c17/canister02a.mdl"]=true,
	["models/props_c17/oildrum001_explosive.mdl"]=true,
	["models/props_junk/gascan001a.mdl"]=true,
	["models/props_junk/metalgascan.mdl"]=true,
	["models/props_junk/propane_tank001a.mdl"]=true,
	["models/props_junk/propanecanister001a.mdl"]=true,
	["models/props_c17/canister_propane01a_fixed.mdl"]=true,
	["models/fire_equipment/w_weldtank2.mdl"]=true,
	["models/fire_equipment/w_weldtank.mdl"]=true
}

local massForFragments={
	["weapon"]=20,
	["computer"]=20
}

function HMCD_ExplosiveType(self)
	-- 1 = inert (default HE), 2 = fragmentary, 3 = incendiary
	if not(IsValid(self))then return 1 end
	if self.ExplosiveType then return self.ExplosiveType end
	local Phys=self:GetPhysicsObject()
	if(IsValid(Phys))then
		if(HMCD_FlammableModels[string.lower(self:GetModel())]) and not(self:GetNWBool("NoPropane")) then return 3 end
		local Mass,Volume,Mat,MassRequirement=Phys:GetMass(),Phys:GetVolume(),Phys:GetMaterial(),massForFragments[Mat] or 5
		local Density=Mass/(self:OBBMaxs():Distance(self:OBBMins()))
		if Mass>=MassRequirement and Mass<=100 and Volume>=300 and Volume<=30000 and Density>=.2 then
			if FragMats[Mat] then return 2 end
		end
	end
	return 1
end

function HMCD_IsSoft(ent)
	return ent:IsPlayer() or ent:IsNPC()
end

local doors={
	["prop_door"]=true,
	["prop_door_rotating"]=true,
	["func_door"]=true,
	["func_door_rotating"]=true,
	["func_breakable"]=true
}

function HMCD_IsDoor(ent)
	return doors[ent:GetClass()]==true
end

function GM:ShouldCollide(ent1,ent2)
	if(ent1.HmcdGas)then
		return ent2:IsWorld() or HMCD_IsDoor(ent2)
	elseif(ent2.HmcdGas)then
		return ent1:IsWorld() or HMCD_IsDoor(ent1)
	--[[elseif(ent1:IsRagdoll() or ent2:IsRagdoll()) then
		local rag,ply=ent1,ent2
		if ent2:IsRagdoll() then rag=ent2 ply=ent1 end
		if ply:IsPlayer() then
			return rag:GetVelocity():LengthSqr()>100000 and not(ply:GetActiveWeapon().CarryEnt==rag)
		end
		return true]]
	end
end

function EntityMeta:GetSex()
	if self:GetModel()=="models/player/smoky/smoky.mdl" then return "female" end
	if string.find(self:GetModel(),"female")!=nil then
		return "female"
	else
		return "male"
	end
end

HITGROUP_NECK=11

local HMCD_PhysBoneToHitgroup={
	["Normal"]={
		[0]=HITGROUP_STOMACH,
		[1]=HITGROUP_CHEST,
		[2]=HITGROUP_RIGHTARM,
		[3]=HITGROUP_LEFTARM,
		[4]=HITGROUP_LEFTARM,
		[5]=HITGROUP_LEFTARM,
		[6]=HITGROUP_RIGHTARM,
		[7]=HITGROUP_RIGHTARM,
		[8]=HITGROUP_RIGHTLEG,
		[9]=HITGROUP_RIGHTLEG,
		[10]=HITGROUP_HEAD,
		[11]=HITGROUP_LEFTLEG,
		[12]=HITGROUP_LEFTLEG,
		[13]=HITGROUP_LEFTLEG,
		[14]=HITGROUP_RIGHTLEG
	},
	["swat_male"]={
		[0]=HITGROUP_STOMACH,
		[1]=HITGROUP_LEFTLEG,
		[2]=HITGROUP_LEFTLEG,
		[3]=HITGROUP_RIGHTLEG,
		[4]=HITGROUP_RIGHTLEG,
		[5]=HITGROUP_RIGHTLEG,
		[6]=HITGROUP_CHEST,
		[7]=HITGROUP_LEFTARM,
		[8]=HITGROUP_LEFTARM,
		[9]=HITGROUP_RIGHTARM,
		[10]=HITGROUP_RIGHTARM,
		[11]=HITGROUP_RIGHTARM,
		[12]=HITGROUP_HEAD,
		[13]=HITGROUP_LEFTARM,
		[14]=HITGROUP_LEFTLEG,
	},
	["gordon_freeman"]={
		[0]=HITGROUP_STOMACH,
		[1]=HITGROUP_STOMACH,
		[2]=HITGROUP_CHEST,
		[3]=HITGROUP_CHEST,
		[4]=HITGROUP_CHEST,
		[5]=HITGROUP_LEFTARM,
		[6]=HITGROUP_LEFTARM,
		[7]=HITGROUP_LEFTARM,
		[8]=HITGROUP_RIGHTARM,
		[9]=HITGROUP_RIGHTARM,
		[10]=HITGROUP_RIGHTARM,
		[11]=HITGROUP_RIGHTLEG,
		[12]=HITGROUP_RIGHTLEG,
		[13]=HITGROUP_RIGHTLEG,
		[14]=HITGROUP_LEFTLEG,
		[15]=HITGROUP_LEFTLEG,
		[16]=HITGROUP_LEFTLEG,
		[17]=HITGROUP_HEAD
	},
	["ortho_jew"]={
		[0]=HITGROUP_STOMACH,
		[1]=HITGROUP_LEFTLEG,
		[2]=HITGROUP_LEFTLEG,
		[3]=HITGROUP_RIGHTLEG,
		[4]=HITGROUP_RIGHTLEG,
		[5]=HITGROUP_RIGHTLEG,
		[6]=HITGROUP_CHEST,
		[7]=HITGROUP_CHEST,
		[8]=HITGROUP_LEFTARM,
		[9]=HITGROUP_LEFTARM,
		[10]=HITGROUP_CHEST,
		[11]=HITGROUP_RIGHTARM,
		[12]=HITGROUP_RIGHTARM,
		[13]=HITGROUP_RIGHTARM,
		[14]=HITGROUP_LEFTARM,
		[15]=HITGROUP_HEAD,
		[16]=HITGROUP_LEFTLEG
	}
}

HMCD_PhysBoneToHitgroup["monolithservers/mpd"]=HMCD_PhysBoneToHitgroup["swat_male"]
HMCD_PhysBoneToHitgroup["military"]=HMCD_PhysBoneToHitgroup["swat_male"]
HMCD_PhysBoneToHitgroup["azov"]=HMCD_PhysBoneToHitgroup["swat_male"]
HMCD_PhysBoneToHitgroup["politepeople"]=HMCD_PhysBoneToHitgroup["swat_male"]
HMCD_PhysBoneToHitgroup["smoky"]=HMCD_PhysBoneToHitgroup["swat_male"]
HMCD_PhysBoneToHitgroup["jesus"]=HMCD_PhysBoneToHitgroup["swat_male"]

function HMCD_GetRagdollHitgroup(rag,physBone)
	local info=HMCD_PhysBoneToHitgroup["Normal"]
	local mod=rag:GetModel()
	for i,tabl in pairs(HMCD_PhysBoneToHitgroup) do
		if string.find(mod,i) then info=tabl break end
	end
	return info[physBone]
end

HMCD_ArmorProtection={
	["Level IIIA"]={
		[HITGROUP_CHEST]={50,"Rubber.ImpactHard",surfaceprop=30},
		[HITGROUP_STOMACH]={50,"Rubber.ImpactHard",surfaceprop=30,
			{bone="ValveBiped.Bip01_Spine1",mins=Vector(-2,-10,-8), maxs=Vector(5,6,8),rotate={[1]={"Up",10}},posAdjust={Forward=-1.25,Right=-3,Up=0}}
		}
	},
	["PoliceVest"]={
		[HITGROUP_CHEST]={50,"Rubber.ImpactHard",surfaceprop=30},
		[HITGROUP_STOMACH]={50,"Rubber.ImpactHard",surfaceprop=30}
	},
	["Level III"]={
		[HITGROUP_CHEST]={90,"SolidMetal.BulletImpact"},
		[HITGROUP_STOMACH]={90,"SolidMetal.BulletImpact",
			{bone="ValveBiped.Bip01_Spine1",mins=Vector(-2,-10,-8), maxs=Vector(5,6,8),rotate={[1]={"Up",10}},posAdjust={Forward=-1.25,Right=-3,Up=0}}
		}
	},
	["ACH"]={
		[HITGROUP_HEAD]={35,"SolidMetal.BulletImpact",{bone="ValveBiped.Bip01_Head1",mins=Vector(1,-11,-5), maxs=Vector(9,4,5),rotate={[1]={"Up",30}}}}
	},
	["Ballistic Mask"]={
		[HITGROUP_HEAD]={35,"SolidMetal.BulletImpact",{bone="ValveBiped.Bip01_Head1",mins=Vector(-2.5,-2,-5), maxs=Vector(7,4,5),rotate={[1]={"Up",10}},posAdjust={Right=5,Forward=0,Up=0}},
			["Holes"]={
				{bone="ValveBiped.Bip01_Head1",mins=Vector(-.6,-.55,-.55), maxs=Vector(.3,1,.75),rotate={[1]={"Up",10}},posAdjust={["female"]={Right=5,Forward=3,Up=1},["male"]={Right=5,Forward=3.75,Up=1}}},
				{bone="ValveBiped.Bip01_Head1",mins=Vector(-.6,-.55,-.55), maxs=Vector(.3,1,.75),rotate={[1]={"Up",10}},posAdjust={["female"]={Right=5,Forward=3,Up=-1.5},["male"]={Right=5,Forward=3.75,Up=-1.5}}}
			},
			surfaceprop=30
		}
	},
	["Combine"]={
		[HITGROUP_HEAD]={40,"SolidMetal.BulletImpact",
			["Holes"]={
				{bone="ValveBiped.Bip01_Head1",mins=Vector(-1,-3,-2), maxs=Vector(.6,3,1.25),rotate={[1]={"Up",10}},posAdjust={["female"]={Right=5,Forward=4.5,Up=-1.75},["male"]={Right=5,Forward=4.5,Up=-1.75}},impactsound="Glass.BulletImpact"},
				{bone="ValveBiped.Bip01_Head1",mins=Vector(-1,-3,-2), maxs=Vector(.6,3,1.25),rotate={[1]={"Up",10}},posAdjust={["female"]={Right=5,Forward=4.5,Up=1.75},["male"]={Right=5,Forward=4.5,Up=1.75}},impactsound="Glass.BulletImpact"}
			}
		},
		[HITGROUP_GENERIC]={90,"SolidMetal.BulletImpact",
			["Holes"]={
				{bone="ValveBiped.Bip01_Spine2",mins=Vector(-5,-2,-1), maxs=Vector(10,7,8),posAdjust={["female"]={Right=0,Forward=-3,Up=4},["male"]={Right=0,Forward=-3,Up=4}}},
				{bone="ValveBiped.Bip01_Spine",mins=Vector(-4,-6,-8), maxs=Vector(7,6,10),posAdjust={["female"]={Right=0,Forward=-7.5,Up=0},["male"]={Right=0,Forward=-7.5,Up=0}}}
			}
		},
		[HITGROUP_LEFTARM]={40,"SolidMetal.BulletImpact",
			{
				{bone="ValveBiped.Bip01_L_Forearm",mins=Vector(-3,-2,-1), maxs=Vector(3,3,5),posAdjust={Right=1,Forward=5.25,Up=0}},
				{bone="ValveBiped.Bip01_L_UpperArm",mins=Vector(-5,-2,-1), maxs=Vector(3,3,5),posAdjust={Right=1,Forward=8.25,Up=0}}
			}
		},
		[HITGROUP_RIGHTARM]={40,"SolidMetal.BulletImpact",
			{
				{bone="ValveBiped.Bip01_R_Forearm",mins=Vector(-3,-2,-1), maxs=Vector(3,3,5),posAdjust={Right=1,Forward=5.25,Up=-2}},
				{bone="ValveBiped.Bip01_R_UpperArm",mins=Vector(-5,-2,-1), maxs=Vector(3,3,5),posAdjust={Right=1,Forward=8.75,Up=-4}}
			}
		},
		[HITGROUP_LEFTLEG]={40,"SolidMetal.BulletImpact",
			{bone="ValveBiped.Bip01_L_Calf",mins=Vector(-2,-8,-4), maxs=Vector(7,5,1.25),rotate={[1]={"Up",70}},posAdjust={Right=-2,Forward=-10,Up=4}}
		},
		[HITGROUP_RIGHTLEG]={40,"SolidMetal.BulletImpact",
			{bone="ValveBiped.Bip01_R_Calf",mins=Vector(-2,-8,-4), maxs=Vector(7,5,1.25),rotate={[1]={"Up",70}},posAdjust={Right=0,Forward=-10,Up=-2}}
		}
	},
	["Zombine"]={
		[HITGROUP_CHEST]={90,"SolidMetal.BulletImpact",
			["Holes"]={
				{bone="ValveBiped.Bip01_Spine2",mins=Vector(-5,-2,-1), maxs=Vector(10,7,8),posAdjust={["female"]={Right=0,Forward=-3,Up=4},["male"]={Right=0,Forward=-3,Up=4}}},
				{bone="ValveBiped.Bip01_Spine",mins=Vector(-4,-6,-8), maxs=Vector(7,6,10),posAdjust={["female"]={Right=0,Forward=-7.5,Up=0},["male"]={Right=0,Forward=-7.5,Up=0}}}
			}
		},
		[HITGROUP_STOMACH]={90,"SolidMetal.BulletImpact",
			["Holes"]={
				{bone="ValveBiped.Bip01_Spine2",mins=Vector(-5,-2,-1), maxs=Vector(10,7,8),posAdjust={["female"]={Right=0,Forward=-3,Up=4},["male"]={Right=0,Forward=-3,Up=4}}},
				{bone="ValveBiped.Bip01_Spine",mins=Vector(-4,-6,-8), maxs=Vector(7,6,10),posAdjust={["female"]={Right=0,Forward=-7.5,Up=0},["male"]={Right=0,Forward=-7.5,Up=0}}}
			}
		},
		[HITGROUP_LEFTARM]={40,"SolidMetal.BulletImpact",
			{
				{bone="ValveBiped.Bip01_L_Forearm",mins=Vector(-5,-2,-1), maxs=Vector(3,4,5),posAdjust={Right=1,Forward=5.25,Up=0}},
				{bone="ValveBiped.Bip01_L_UpperArm",mins=Vector(-6,-2,-1), maxs=Vector(4,3,5),posAdjust={Right=1,Forward=8.25,Up=0}}
			}
		},
		[HITGROUP_RIGHTARM]={40,"SolidMetal.BulletImpact",
			{
				{bone="ValveBiped.Bip01_R_Forearm",mins=Vector(-3,-2,-1), maxs=Vector(5,3,4),posAdjust={Right=1,Forward=5.25,Up=-2}},
				{bone="ValveBiped.Bip01_R_UpperArm",mins=Vector(-5,-2,-1), maxs=Vector(5,3,4),posAdjust={Right=1,Forward=8.75,Up=-4}}
			}
		},
		[HITGROUP_LEFTLEG]={40,"SolidMetal.BulletImpact",
			{bone="ValveBiped.Bip01_L_Calf",mins=Vector(-2,-8,-4), maxs=Vector(7,5,2.25),rotate={[1]={"Up",20}},posAdjust={Right=-8,Forward=-6,Up=4}}
		},
		[HITGROUP_RIGHTLEG]={40,"SolidMetal.BulletImpact",
			{bone="ValveBiped.Bip01_R_Calf",mins=Vector(-2,-8,-5), maxs=Vector(7,5,1.25),rotate={[1]={"Up",40}},posAdjust={Right=-5,Forward=-8,Up=-2}}
		}
	},
	["Rebel"]={
		[HITGROUP_CHEST]={50,"Rubber.ImpactHard",surfaceprop=30},
		[HITGROUP_RIGHTLEG]={40,"SolidMetal.BulletImpact",
			{bone="ValveBiped.Bip01_R_Thigh",mins=Vector(-5,-9,-2), maxs=Vector(1,3,3),rotate={[1]={"Up",90}},posAdjust={Right=-2.5,Forward=7,Up=-4},func=function(ply) return ply:GetSex()=="male" and ply:GetNWString("Class")!="medic" end}
		},
		[HITGROUP_LEFTLEG]={40,"SolidMetal.BulletImpact",
			{bone="ValveBiped.Bip01_L_Thigh",mins=Vector(-5,-9,-2), maxs=Vector(1,3,3),rotate={[1]={"Up",90}},posAdjust={Right=-2,Forward=7,Up=3},func=function(ply) return ply:GetSex()=="male" and ply:GetNWString("Class")!="medic" end}
		},
		[HITGROUP_LEFTARM]={40,"SolidMetal.BulletImpact",
			{bone="ValveBiped.Bip01_L_UpperArm",mins=Vector(-5,-7,-2), maxs=Vector(0,2.5,2),rotate={[1]={"Up",90}},posAdjust={Right=-3,Forward=4,Up=1},func=function(ply) return ply:GetNWString("Class")!="medic" end}
		},
		[HITGROUP_RIGHTARM]={40,"SolidMetal.BulletImpact",
			{bone="ValveBiped.Bip01_R_UpperArm",mins=Vector(-5,-7,-2), maxs=Vector(0,2.5,2),rotate={[1]={"Up",90}},posAdjust={Right=-3,Forward=4,Up=0},func=function(ply) return ply:GetSex()=="female" and ply:GetNWString("Class")!="medic" end}
		}
	},
	["NatHelm"]={
		[HITGROUP_HEAD]={35,"SolidMetal.BulletImpact",{bone="ValveBiped.Bip01_Head1",mins=Vector(1,-11,-5), maxs=Vector(9,4,5),rotate={[1]={"Up",30}}}}
	},
	["RiotHelm"]={
		[HITGROUP_HEAD]={25,"SolidMetal.BulletImpact",{bone="ValveBiped.Bip01_Head1",mins=Vector(1,-11,-5), maxs=Vector(9,4,5),rotate={[1]={"Up",30}}}}
	},
	["Motorcycle"]={
		[HITGROUP_HEAD]={5,"SolidMetal.BulletImpact"}
	},
	["HEV"]={
		[HITGROUP_STOMACH]={100,"SolidMetal.BulletImpact",{bone="ValveBiped.Bip01_Spine",mins=Vector(-5,-6,-8),maxs=Vector(0,5,8)}},
		[HITGROUP_CHEST]={100,"SolidMetal.BulletImpact",["Holes"]={
				{bone="ValveBiped.Bip01_Neck1",mins=Vector(2,-10,-8),maxs=Vector(5,8,8)}
			}
		},
		[HITGROUP_HEAD]={50,"SolidMetal.BulletImpact",
			["Holes"]={
				{bone="ValveBiped.Bip01_Head1",mins=Vector(2.5,-7,-6),maxs=Vector(5,-1,6),impactsound="Glass.BulletImpact",dmgPenetration={
						[DMG_BULLET]=35,
						[DMG_BUCKSHOT]=35
					},surfaceprop=29
				}
			}
		},
		[HITGROUP_LEFTLEG]={100,"SolidMetal.BulletImpact",
			{
				{bone="ValveBiped.Bip01_L_Calf",mins=Vector(2.5,-5,-4),maxs=Vector(15,5,4)},
				{bone="ValveBiped.Bip01_L_Thigh",mins=Vector(1.5,-5,-4),maxs=Vector(17,5,4)}
			}
		},
		[HITGROUP_RIGHTLEG]={100,"SolidMetal.BulletImpact",
			{
				{bone="ValveBiped.Bip01_R_Calf",mins=Vector(2.5,-5,-4),maxs=Vector(15,5,4)},
				{bone="ValveBiped.Bip01_R_Thigh",mins=Vector(1.5,-5,-4),maxs=Vector(17,5,4)}
			}
		},
		[HITGROUP_RIGHTARM]={100,"SolidMetal.BulletImpact",
			{
				{bone="ValveBiped.Bip01_R_UpperArm",mins=Vector(3,-5,-4),maxs=Vector(11,5,4)},
				{bone="ValveBiped.Bip01_R_Forearm",mins=Vector(1,-5,-4),maxs=Vector(12.5,5,4)}
			}
		},
		[HITGROUP_LEFTARM]={100,"SolidMetal.BulletImpact",
			{
				{bone="ValveBiped.Bip01_L_UpperArm",mins=Vector(3,-5,-4),maxs=Vector(11,5,4)},
				{bone="ValveBiped.Bip01_L_Forearm",mins=Vector(1,-5,-4),maxs=Vector(12.5,5,4)}
			}
		}
	},
	["Terminator"]={
		[HITGROUP_GEAR]={150,"SolidMetal.BulletImpact"}
	}
}

for i=0,7 do
	HMCD_ArmorProtection["Terminator"][i]=HMCD_ArmorProtection["Terminator"][HITGROUP_GEAR]
end

HMCD_ArmorProtection["Combine"][HITGROUP_CHEST]=HMCD_ArmorProtection["Combine"][HITGROUP_GENERIC]
HMCD_ArmorProtection["Combine"][HITGROUP_STOMACH]=HMCD_ArmorProtection["Combine"][HITGROUP_GENERIC]

HMCD_ArmorProtection["CombineElite"]={}
for i,info in pairs(HMCD_ArmorProtection["Combine"]) do
	HMCD_ArmorProtection["CombineElite"][i]=info
end
HMCD_ArmorProtection["CombineElite"][HITGROUP_HEAD]={40,"SolidMetal.BulletImpact",
	["Holes"]={
		{bone="ValveBiped.Bip01_Head1",mins=Vector(-1.5,-5,-1.5), maxs=Vector(1.5,5,1.5),rotate={[1]={"Up",10}},posAdjust={["female"]={Right=5,Forward=5,Up=0},["male"]={Right=5,Forward=5,Up=0}},impactsound="Glass.BulletImpact"},
	}
}
HMCD_ArmorProtection["CP"]=HMCD_ArmorProtection["Level IIIA"]


function HMCD_CheckArmor(ply,startpos,hitpos,info)
	if info.func and not(info.func(ply)) then return false end
	local pos,ang=ply:GetBonePosition(ply:LookupBone(info.bone))
	if info.posAdjust then pos=pos+ang:Right()*info.posAdjust.Right+ang:Forward()*info.posAdjust.Forward+ang:Up()*info.posAdjust.Up end
	if info.rotate then
		local angs={
			["Up"]=ang:Up(),
			["Right"]=ang:Right(),
			["Forward"]=ang:Forward()
		}
		for i,angInfo in pairs(info.rotate) do
			ang:RotateAroundAxis(angs[angInfo[1]],angInfo[2])
			angs={
				["Up"]=ang:Up(),
				["Right"]=ang:Right(),
				["Forward"]=ang:Forward()
			}
		end
	end
	local localpos=WorldToLocal(hitpos,angle_zero,startpos,angle_zero)
	local hit=util.IntersectRayWithOBB( startpos, localpos, pos, ang, info.mins, info.maxs )!=nil
	return hit
end

function HMCD_GetArmors(ply,hitgroup)
	local curVest,curHelmet,curMask=ply:GetNWString("Bodyvest"),ply:GetNWString("Helmet"),ply:GetNWString("Mask")
	local infoList={}
	if HMCD_ArmorProtection[curVest] and HMCD_ArmorProtection[curVest][hitgroup] then 
		table.insert(infoList,HMCD_ArmorProtection[curVest][hitgroup])
	end
	if HMCD_ArmorProtection[curHelmet] and HMCD_ArmorProtection[curHelmet][hitgroup] then
		table.insert(infoList,HMCD_ArmorProtection[curHelmet][hitgroup])
	end
	if HMCD_ArmorProtection[curMask] and HMCD_ArmorProtection[curMask][hitgroup] then
		table.insert(infoList,HMCD_ArmorProtection[curMask][hitgroup])
	end
	return infoList
end

function HMCD_IsArmorHit(ply,info,src,hitpos,damage)
	local armorHit=true
	local surfaceprop=5
	if info[3] then
		if istable(info[3][1]) then
			for i,inf in pairs(info[3]) do
				armorHit=HMCD_CheckArmor(ply,src,hitpos,inf)
				if armorHit then break end
			end
		else
			armorHit=HMCD_CheckArmor(ply,src,hitpos,info[3])
		end
	end
	if armorHit and info.surfaceprop then surfaceprop=info.surfaceprop end
	if info["Holes"] and armorHit then
		local sex=ply.ModelSex or ply:GetSex()
		for i,holeInfo in pairs(info["Holes"]) do
			local pos,ang=ply:GetBonePosition(ply:LookupBone(holeInfo.bone))
			if holeInfo.posAdjust then pos=pos+ang:Right()*holeInfo.posAdjust[sex].Right+ang:Forward()*holeInfo.posAdjust[sex].Forward+ang:Up()*holeInfo.posAdjust[sex].Up end
			if holeInfo.rotate then
				local angs={
					["Up"]=ang:Up(),
					["Right"]=ang:Right(),
					["Forward"]=ang:Forward()
				}
				for i,angInfo in pairs(holeInfo.rotate) do
					ang:RotateAroundAxis(angs[angInfo[1]],angInfo[2])
					angs={
						["Up"]=ang:Up(),
						["Right"]=ang:Right(),
						["Forward"]=ang:Forward()
					}
				end
			end
			local localpos=WorldToLocal(hitpos,angle_zero,src,angle_zero)
			local hit=util.IntersectRayWithOBB( src, localpos, pos, ang, holeInfo.mins, holeInfo.maxs )!=nil
			if hit then
				if not(holeInfo.dmgPenetration and ((holeInfo.dmgPenetration[DMG_BULLET] and holeInfo.dmgPenetration[DMG_BULLET]>damage) or not(holeInfo.dmgPenetration[DMG_BULLET]))) then
					armorHit=false
				end
				surfaceprop=holeInfo.surfaceprop or 5
			end
		end
	end
	return armorHit,surfaceprop
end

local ZombTypes={
	["npc_zombie"]=true,
	["npc_zombie_torso"]=true,
	["npc_fastzombie"]=true,
	["npc_fastzombie_torso"]=true,
	["npc_poisonzombie"]=true,
	["npc_zombine"]=true
}

local dmgFixes={
	["npc_combinegunship"]=300,
	["npc_combinedropship"]=300,
	["npc_strider"]=300
}

hook.Add("EntityFireBullets","HMCD_EntityFireBullets",function(ent,data)
	if dmgFixes[ent:GetClass()] and not(ent.FixingDamage) then
		data.Damage=dmgFixes[ent:GetClass()]
		ent.FixingDamage=true
	end
	local tr=util.QuickTrace(data.Src,data.Dir*data.Distance,{ent,data.IgnoreEntity})
	if data.Damage>200 and tr.MatType and not(tr.HitSky) then
		local edata = EffectData()
		edata:SetOrigin(tr.HitPos)
		edata:SetNormal(tr.HitNormal)
		edata:SetRadius(tr.MatType)
		util.Effect("gdcw_universal_impact",edata)
	end
	if SERVER then
		for i,ply in ipairs(player.GetAll()) do
			if not(ply==ent or ply.Spectatee==ent) and not(ply.fakeragdoll and ply.fakeragdoll.Wep==ent) then
				local dot=ply:EyePos()
				if IsValid(ply.fakeragdoll) and ply:Alive() then
					dot=ply.fakeragdoll:EyePos()
				end
				local dist=util.DistanceToLine( data.Src, tr.HitPos, dot )
				if dist<50 then
					if ply:Alive() then
						ply:AddAdrenaline((50-dist)*(1-(ply.DigestedContents["Adrenaline"] or 0)/200)^2)
						local att=ent
						if IsValid(ent.Owner) then att=ent.Owner end
						if att:IsPlayer() and (att.Role==ply.Role or (HMCD_RDMRoles[att.Role] and HMCD_RDMRoles[att.Role][ply.Role])) and not(ply.LostInnocence or ply.Role=="fighter" or GAMEMODE.Mode=="Strange" or att.ZombieMaster) and ply!=att and GAMEMODE.RoundStage!=ROUND_END then
							att.LostInnocence=true
						end
					end
					net.Start("hmcd_bulletwoosh")
					net.Send(ply)
				end
			end
		end
	end
	local removeBullet=false
	if IsValid(tr.Entity) and (tr.Entity:IsPlayer() or tr.Entity:IsRagdoll() or tr.Entity:IsNPC()) then
		local ply=tr.Entity
		local hitgroup=tr.HitGroup
		if ply:IsRagdoll() then
			hitgroup=HMCD_GetRagdollHitgroup(ply,tr.PhysicsBone)
		end
		local infoList=HMCD_GetArmors(ply,hitgroup)
		if #infoList>0 then
			for i,info in pairs(infoList) do
				local armorHit,surfaceprop=HMCD_IsArmorHit(ply,info,data.Src,tr.HitPos,data.Damage)
				if info[1]>=data.Damage and armorHit then
					local edata = EffectData()
					edata:SetOrigin(tr.HitPos)
					edata:SetEntity(ply)
					edata:SetSurfaceProp(surfaceprop)
					util.Effect("Impact",edata)
					if SERVER then
						if tr.PhysicsBone and IsValid(ply:GetPhysicsObjectNum(tr.PhysicsBone)) then ply:GetPhysicsObjectNum(tr.PhysicsBone):ApplyForceCenter(data.Dir*data.Damage*10) end
						if ent.Role==ply.Role and ent:IsPlayer() and not(ply.LostInnocence or ply.Role=="fighter" or GAMEMODE.Mode=="Strange") then
							ent.LostInnocence=true						
						end
						local owner=ply
						if IsValid(ply:GetRagdollOwner()) and ply:GetRagdollOwner():Alive() then owner=ply:GetRagdollOwner() end
						if owner:IsPlayer() then
							if BONE_HITGROUPS[hitgroup] then
								local attacker=ent
								if IsValid(ent.Owner) then attacker=ent.Owner end
								local dmginfo=DamageInfo()
								dmginfo:SetDamage(data.Damage)
								dmginfo:SetAttacker(attacker)
								dmginfo:SetDamagePosition(tr.HitPos)
								local damageType=DMG_BULLET
								if ent.Grenade then damageType=DMG_BUCKSHOT end
								local mul,painMul
								if istable(BONE_HITGROUPS[hitgroup][1]) then
									for i,bone in pairs(BONE_HITGROUPS[hitgroup]) do
										mul,painMul=HMCD_BreakBone(bone,ply,dmginfo,hitgroup,.1,damageType)		
									end
								else
									mul,painMul=HMCD_BreakBone(BONE_HITGROUPS[hitgroup],ply,dmginfo,hitgroup,.1,damageType)
								end
								owner:ApplyPain(data.Damage*painMul*.25)
								owner:AddImpulse(data.Damage*data.Num)
								owner:AddAdrenaline(data.Damage*.25)
								owner:AddImmobilization(data.Damage*.1)
							end
						elseif owner:IsNPC() then
							if not(IsValid(owner:GetEnemy())) then
								owner:SetEnemy(ent)
								owner:UpdateEnemyMemory( ent, ent:GetPos() )
							end
						end
					end
					removeBullet=true
				end
			end
		end
	end
	local firedBullets=false
	if data.Num<=1 and not(tr.HitSky) then
		-- checking what the bullet should do --
		local AVec,IPos,TNorm,SMul=tr.Normal,tr.HitPos,tr.HitNormal,tr.Entity.Hardness or HMCD_SurfaceHardness[tr.MatType] or .5
		local ApproachAngle=-math.deg(math.asin(TNorm:DotProduct(AVec)))
		local MaxRicAngle=60*(HMCD_SurfaceRicochet[tr.MatType] or .2)
		if ApproachAngle>(MaxRicAngle*1.25) and not(removeBullet) then -- all the way through
			local MaxDist,SearchPos,SearchDist,Penetrated=(data.Damage/SMul)*.15,IPos,5,false
			while((not(Penetrated))and(SearchDist<MaxDist))do
				SearchPos=IPos+AVec*SearchDist
				local PeneTrace=util.QuickTrace(SearchPos,-AVec*SearchDist)
				if((not(PeneTrace.StartSolid))and(PeneTrace.Hit))then
					Penetrated=true
				else
					SearchDist=SearchDist+5
				end
			end
			if(Penetrated)then
				local StopMul=SearchDist/MaxDist
				ent:FireBullets({
					Attacker=ent.Owner,
					Damage=1,
					Force=1,
					Num=1,
					Tracer=0,
					TracerName="",
					Dir=-AVec,
					Spread=Vector(0,0,0),
					Src=SearchPos+AVec,
					AmmoType=data.AmmoType
				})
				ent:FireBullets({
					Attacker=ent.Owner,
					Damage=data.Damage*math.Clamp((1-StopMul)*1.2,0.01,1),
					Force=data.Damage/15,
					Num=1,
					Tracer=0,
					TracerName="",
					Dir=AVec,
					Spread=Vector(0,0,0),
					Src=SearchPos+AVec,
					AmmoType=data.AmmoType
				})
				firedBullets=true
				return not(removeBullet)
			end
		elseif(ApproachAngle<(MaxRicAngle*.75)) and data.Damage>1 then -- ping whiiiizzzz
			sound.Play("snd_jack_hmcd_ricochet_"..math.random(1,2)..".wav",IPos,70,math.random(90,100))
			local NewVec=AVec:Angle()
			NewVec:RotateAroundAxis(TNorm,180)
			local AngDiffNormal=math.deg(math.acos(NewVec:Forward():Dot(TNorm)))-90
			NewVec:RotateAroundAxis(NewVec:Right(),AngDiffNormal*.7) -- bullets actually don't ricochet elastically
			NewVec=NewVec:Forward()
			firedBullets=true
			ent:FireBullets({
				Attacker=ent.Owner,
				Damage=data.Damage*.5,
				Force=data.Damage/15,
				Num=1,
				Tracer=0,
				TracerName="",
				Dir=-NewVec,
				Spread=Vector(0,0,0),
				Src=IPos+TNorm,
				AmmoType=data.AmmoType
			})
			return not(removeBullet)
		end
	end
	if ent.FixingDamage then 
		if not(ent.FiredBullets) then ent.FixingDamage=nil end
		return true 
	end
	if removeBullet then return false end
end)

hook.Add("DoAnimationEvent","HMCD_DoAnimationEvent",function(pl,event,data)
	local wep=pl:GetActiveWeapon()
	if((event==PLAYERANIMEVENT_ATTACK_PRIMARY)and(wep.GetClimbing))then
		if pl:GetNWString("Class")=="" then
			pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD,ACT_GMOD_GESTURE_RANGE_ZOMBIE,true)
		else
			pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD,ACT_MELEE_ATTACK1,true)
		end
		if pl:GetNWBool("Raging") then
			pl:SetLayerPlaybackRate(GESTURE_SLOT_ATTACK_AND_RELOAD,2)
		end
		return ACT_INVALID
	end
end)

hook.Add("EntityEmitSound","HMCD_EntityEmitSound",function(t)
	local SoundModded=false
	if((IsValid(t.Entity))and(t.Entity:IsPlayer()))then -- stupid garry shit
		if CLIENT and LocalPlayer().Lost and t.Entity!=LocalPlayer() then return false end
		if(t.OriginalSoundName=="Weapon_Shotgun.Special1") then
			t.Volume=.01
			SoundModded=true
		end
	end
	local p=t.Pitch
	if(game.GetTimeScale()!= 1)then p=p*game.GetTimeScale() end
	if(GetConVarNumber("host_timescale")!=1 && GetConVarNumber("sv_cheats")>= 1)then p=p*GetConVarNumber("host_timescale") end
	if(p!=t.Pitch)then t.Pitch=math.Clamp(p,0,255);SoundModded=true end
	if(CLIENT && engine.GetDemoPlaybackTimeScale()!=1)then t.Pitch=math.Clamp(t.Pitch*engine.GetDemoPlaybackTimeScale(),0,255);SoundModded=true end
	if SERVER then
		local Zombs={}
		for class,bool in pairs(ZombTypes) do
			for i,zomb in pairs(ents.FindByClass(class)) do
				table.insert(Zombs,zomb)
			end
		end
		if GAMEMODE.Mode=="Zombie" and (t.Pos or t.Entity) and not(t.Entity.Role=="killer") then
			for i,zombie in pairs(Zombs) do
				if not(ZombTypes[t.Entity:GetClass()]) then
					local owner=t.Entity
					if IsValid(owner:GetRagdollOwner()) then owner=owner:GetRagdollOwner() end
					local dist=640000
					if not(owner:IsPlayer()) then dist=dist/8 end
					local position=t.Pos
					if not(position) then position=t.Entity:GetPos() end
					if not(zombie:Visible(t.Entity)) then dist=250000 end
					local volume=t.Volume
					if string.find(t.SoundName,"_fire")!=nil then volume=volume*6 end
					dist=dist*volume
					if zombie:GetPos():DistToSqr(position)<dist and zombie:IsCurrentSchedule(SCHED_IDLE_STAND) then
						zombie:SetLastPosition(position)
						zombie:SetSchedule(SCHED_FORCED_GO_RUN)
					end
				end
			end
		end
	end
	if(SoundModded)then return true end
end)

hook.Add( "PlayerFootstep", "CustomFootstepsounds", function( ply, pos, foot, sound, volume, rf )
	if ply.Role=="combine" then
		if not(CLIENT and LocalPlayer()==ply) then
			local role="combine_soldier"
			if ply:GetNWString("Class")=="cp" then role="metropolice" end
			ply:EmitSound( "npc/"..role.."/gear"..math.random(1,6)..".wav" )
		end
		return true
	end
	if(GAMEMODE.Mode=="Zombie" and ply.Role=="killer")then
		if not(CLIENT and LocalPlayer()==ply) then
			if(math.random(1,2)==1) or ply:GetNWString("Class")=="fast" then
				ply:EmitSound("npc/zombie/foot"..math.random(3)..".wav",70,math.random(90,110))
			else
				ply:EmitSound("npc/zombie/foot_slide"..math.random(3)..".wav",70,math.random(90,110))
			end
		end
		return true
	end
end )

HMCD_REMOVEEQUIPMENT=-1
HMCD_ARMOR3A=1
HMCD_ARMOR3=2
HMCD_ACH=3
HMCD_GASMASK=4
HMCD_FLASHLIGHT=5
HMCD_PISTOLSUPP=6
HMCD_RIFLESUPP=7
HMCD_SHOTGUNSUPP=8
HMCD_LASERSMALL=9
HMCD_LASERBIG=10
HMCD_AIMPOINT=11
HMCD_EOTECH=12
HMCD_KOBRA=13
HMCD_PBS=14
HMCD_OSPREY=15
HMCD_BALLISTICMASK=16
HMCD_NVG=17
HMCD_MOTHELMET=18
HMCD_POLHELMET=19
HMCD_POLARMOR=20
HMCD_SCOPE=21


HMCD_EquipmentNames={
	"Level IIIA Armor",
	"Level III Armor",
	"Advanced Combat Helmet",
	"M40 Gas Mask",
	"Maglite ML300LX-S3CC6L Flashlight",
	"Cobra M2 Suppressor",
	"Hybrid 46 Suppressor",
	"Salvo 12 Suppressor",
	"Marcool JG5 Laser Sight",
	"AN/PEQ-15 Laser Sight",
	"Aimpoint CompM2 Sight",
	"EOTech 552.A65 Sight",
	"Kobra Sight",
	"PBS-1 Suppressor",
	"Osprey 45 Suppressor",
	"Ballistic Mask",
	"Ground Panoramic Night Vision Goggles",
	"Bell Bullitt Motorcycle Helmet",
	"Riot Helmet",
	"Police Vest",
	"Zielfernrohr 39"
}

HMCD_EquipmentClasses={
	"ent_jack_hmcd_softarmor",
	"ent_jack_hmcd_hardarmor",
	"ent_jack_hmcd_helmet",
	"ent_jack_hmcd_gasmask",
	"ent_jack_hmcd_flashlight",
	"ent_jack_hmcd_pistolsuppressor",
	"ent_jack_hmcd_riflesuppressor",
	"ent_jack_hmcd_shotgunsuppressor",
	"ent_jack_hmcd_laser",
	"ent_jack_hmcd_laserbig",
	"ent_jack_hmcd_aimpoint",
	"ent_jack_hmcd_eotech",
	"ent_jack_hmcd_kobra",
	"ent_jack_hmcd_aksuppressor",
	"ent_jack_hmcd_uspsuppressor",
	"ent_jack_hmcd_ballisticmask",
	"ent_jack_hmcd_nvg",
	"ent_jack_hmcd_mothelmet",
	"ent_jack_hmcd_policehelmet",
	"ent_jack_hmcd_policearmor",
	"ent_jack_hmcd_scope"
}

HMCD_ArmorNames={
	["Helmet"]={
		["Advanced Combat Helmet"]="ACH",
		["Bell Bullitt Motorcycle Helmet"]="Motorcycle",
		["Riot Helmet"]="RiotHelm"
	},
	["Mask"]={
		["Ground Panoramic Night Vision Goggles"]="NVG",
		["M40 Gas Mask"]="Gas Mask",
		["Ballistic Mask"]="Ballistic Mask"
	},
	["Bodyvest"]={
		["Level III Armor"]="Level III",
		["Level IIIA Armor"]="Level IIIA",
		["Police Vest"]="PoliceVest"
	}
}

HMCD_ConflictingEquipment={
	["Bodyvest"]={
		["Combine"]={
			["Mask"]=true,
			["Helmet"]=true,
			["Maglite ML300LX-S3CC6L Flashlight"]=true
		},
		["HEV"]={
			["Mask"]=true,
			["Helmet"]=true
		}
	}
}

HMCD_ConflictingEquipment["Bodyvest"]["CombineElite"]=HMCD_ConflictingEquipment["Bodyvest"]["Combine"]
HMCD_ConflictingEquipment["Bodyvest"]["Terminator"]=HMCD_ConflictingEquipment["Bodyvest"]["Combine"]

-- 1 = width
-- 2 = height
-- 3 = description
-- 4 = icon path
HMCD_EquipmentInfo={
	[1]={3,3,"This is a type of soft armor providing protection from many small arm weapons.","vgui/icons/armor01"},
	[2]={3,3,"This is a hard armor rated for rifle protection consisting of hard metal plates as opposed to soft plates.","vgui/icons/armor02"},
	[3]={2,2,"This is a model of reinforced combat helmet providing ballistic and impact protection, stability, and comfort.","vgui/icons/helmet"},
	[4]={2,2,"This is a breathing device designed to protect the wearer against harmful substances in the air.","vgui/icons/gasmask"},
	[5]={1,1,"This is a powerful, versatile and durable LED flashlight.","vgui/hud/hmcd_flash"},
	[6]={1,1,"This is a muzzle device that reduces the acoustic intensity of the muzzle report and the recoil. Can be fit on a 9mm firearm.","vgui/icons/silencer_pistol",cost=120},
	[7]={1,1,"This is a muzzle device that reduces the acoustic intensity of the muzzle report and the recoil. Can be fit on a 5.56x45mm or a 7.92x57mm firearm.","vgui/icons/silencer_assaultrifle",cost=200},
	[8]={1,1,"This is a muzzle device that reduces the acoustic intensity of the muzzle report and the recoil. Can be fit on a 12-guage shotgun.","vgui/icons/silencer_shotgun",cost=250},
	[9]={1,1,"This is a small device that can be attached to your firearm that projects a laser beam on to your target.","vgui/icons/laser_short",cost=240},
	[10]={1,1,"This is a device that can be attached to your firearm that projects a laser beam on to your target. Can be fit on firearms with RIS.","vgui/icons/laser_long",cost=350},
	[11]={1,1,"This is a non-magnifying reflector sight for firearms that gives the user a point of aim in the form of an illuminated red dot. Can be fit on firearms with RIS.","vgui/icons/sights_aimpoint",cost=160},
	[12]={1,1,"This is a non-magnifying reflector sight for firearms that gives the user a point of aim in the form of an illuminated red dot. Can be fit on firearms with RIS.","vgui/icons/sights_eotech",cost=160},
	[13]={1,1,"This is a non-magnifying reflector sight for firearms that gives the user a point of aim in the form of an illuminated red cross. Can be fit on firearms with RIS.","vgui/icons/sights_kobra",cost=160},
	[14]={1,1,"This is a two-chambered silencer using baffles and a rubber wipe. It was designed specifically for the AKM variant.","vgui/icons/silencer_akm",cost=200},
	[15]={1,1,"This is a lightweight multi caliber suppressor built for centerfire pistols.","vgui/icons/silencer_usp",cost=120},
	[16]={2,2,"This is a type of personal armor designed to protect the wearer from ballistic threats.","vgui/icons/ballisticmask"},
	[17]={2,2,"This is a helmet-mounted night vision device with a wide 97-degree horizontal field-of-view that allows for observation and/or target identification in low-light conditions.","vgui/icons/nvg"},
	[18]={2,2,"This is a helmet consisting of a polystyrene foam inner shell that absorbs the shock of an impact, and a protective plastic outer layer.","vgui/icons/mothelmet"},
	[19]={2,2,"This is a type of helmet designed for law enforcement to protect its wearer's head from handheld melee weapons, and thrown projectiles.","vgui/icons/riothelm"},
	[20]={3,3,"This is a ballistic-resistant and stab-resistant body armor that provides coverage and protection for it's wearer.","vgui/icons/policevest"},
	[21]={2,1,"This is a an optical device for use especially with a Karabiner 98k that allows a person to see targets from far way.","vgui/icons/scope",cost=400}
}

HMCD_AmmoWeights={
	["AlyxGun"]=4,
	["12mmRound"]=10,
	["Pistol"]=12,
	["HelicopterGun"]=30,
	["357"]=15,
	["AirboatGun"]=3,
	["Buckshot"]=60,
	["AR2"]=50,
	["MP5_Grenade"]=60,
	["SMG1"]=18,
	["Gravity"]=18,
	["SniperRound"]=20,
	["XBowBolt"]=22,
	["Thumper"]=26,
	["StriderMinigun"]=20,
	["RPG_Round"]=450,
	["9mmRound"]=8,
	["Hornet"]=30,
	["SniperPenetratedRound"]=20,
	["CombineCannon"]=200
}

HMCD_AmmoNames={
	["AlyxGun"]="5.7x16mm (.22 long rifle)",
	["12mmRound"]="9x18mm PM",
	["Pistol"]="9x19mm (9mm luger/parabellum)",
	["357"]="9x29mmR (.38 special)",
	["SMG1"]="5.56x45mm (.223 remington)",
	["Buckshot"]="18.5x70mmR (12 gauge shotshell)",
	["AR2"]="7x57mm (7mm mauser)",
	["XBowBolt"]="6x735mm broadhead hunting arrow",
	["AirboatGun"]="2x89mm Carpentry Nail",
	["RPG_Round"]="40mm Rocket",
	["StriderMinigun"]="7.62x51 NATO",
	["HelicopterGun"]="4.6x30mm",
	["SniperRound"]="7.62x39mm",
	["Gravity"]="Pulse Slug",
	["Thumper"]="300mm Rebar",
	["MP5_Grenade"]="Energy Ball",
	["SniperPenetratedRound"]="X26 Taser Cartridge",
	["9mmRound"]="9×22mm P.A.",
	["Hornet"]="Flexible Baton Round",
	["CombineCannon"]="14.5×114mm (.57 calibre)"
}

HMCD_PersonContainers={
	["models/props_junk/wood_crate001a.mdl"]=true,
	["models/props_junk/wood_crate001a_damaged.mdl"]=true,
	["models/props_junk/wood_crate001a_damagedmax.mdl"]=true,
	["models/props_junk/wood_crate002a.mdl"]=true,
	["models/props_borealis/bluebarrel001.mdl"]=true,
	["models/props_c17/oildrum001.mdl"]=true,
	["models/props_junk/trashbin01a.mdl"]=true,
	["models/props_c17/furnituredresser001a.mdl"]=true,
	["models/props_c17/woodbarrel001.mdl"]=true,
	["models/props_lab/dogobject_wood_crate001a_damagedmax.mdl"]=true,
	["models/props_wasteland/controlroom_storagecloset001a.mdl"]=true,
	["models/props_wasteland/controlroom_storagecloset001b.mdl"]=true,
	["models/props/cs_assault/dryer_box.mdl"]=true,
	["models/props/cs_assault/dryer_box2.mdl"]=true,
	["models/props/cs_assault/washer_box.mdl"]=true,
	["models/props/cs_assault/washer_box2.mdl"]=true,
	["models/props/cs_militia/crate_extrasmallmill.mdl"]=true,
	["models/props/de_dust/du_crate_64x64.mdl"]=true,
	["models/props/de_dust/du_crate_64x80.mdl"]=true,
	["models/props/de_inferno/wine_barrel.mdl"]=true,
	["models/props/de_nuke/crate_extrasmall.mdl"]=true,
	["models/props/de_nuke/crate_small.mdl"]=true,
	["models/props/de_prodigy/prodcratesb.mdl"]=true,
	["models/props_trainstation/trashcan_indoor001a.mdl"]=true,
	["models/props_wasteland/kitchen_fridge001a.mdl"]=true,
	["models/props_wasteland/laundry_washer001a.mdl"]=true,
	["models/props_c17/furniturefridge001a.mdl"]=true,
	["models/props/griggs/sotbx3.mdl"]=true,
	["models/props/griggs/sotbx4.mdl"]=true,
	["models/props/griggs/sotbx5.mdl"]=true,
	["models/props/griggs/sotbx6.mdl"]=true,
	["models/props/griggs/sotbx7.mdl"]=true,
	["models/props/griggs/sotbx9.mdl"]=true
}

HMCD_AttachmentInfo = {
	["wep_jack_hmcd_akm"]={
		["Suppressor"]={Vector(-1.7,-31.3,7.75),Angle(-15,170,0),"models/weapons/upgrades/a_suppressor_ak.mdl",.9},
		["Laser"]={Vector(2.6,-8,2.9),Angle(-22,-8.5,0),"models/cw2/attachments/anpeq15.mdl",1},
		["Sight1"]={Vector(2.6,-8,2.9),Angle(-22,-190,0),"models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl",1},
		["Sight2"]={Vector(2.65,-8,3),Angle(-22,-190,0),"models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl",1},
		["Sight3"]={Vector(2.65,-8,3),Angle(-22,-190,0),"models/weapons/tfa_ins2/upgrades/a_optic_eotech.mdl",1},
		["Rail"]={Vector(2.5,-8,1),Angle(-22,-95,0),"models/wystan/attachments/akrailmount.mdl",1},
		["DrawPos"]={Vector(3,-7,-4),Angle(160,10,180),"models/btk/w_nam_akm.mdl"}
	},
	["wep_jack_hmcd_assaultrifle"]={
		["Suppressor"]={Vector(1.1,-13,-1.9),Angle(-10,-100,-10),"models/cw2/attachments/556suppressor.mdl",1},
		["Laser"]={Vector(0.5,-17,3.9),Angle(-20,-8.5,0),"models/cw2/attachments/anpeq15.mdl",1},
		["Sight1"]={Vector(1.3,-11,1.7),Angle(-20,-190,0),"models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl",.9},
		["Sight2"]={Vector(1.3,-10,1.7),Angle(-20,-190,0),"models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl",.9},
		["Sight3"]={Vector(1.3,-11,1.7),Angle(-20,-190,0),"models/weapons/tfa_ins2/upgrades/a_optic_eotech.mdl",.9},
		["DrawPos"]={Vector(2,-9,-4),Angle(160,100,180),"models/drgordon/weapons/ar-15/m4/colt_m4.mdl",bodygroups={[2]=1,[8]=2}}
	},
	["wep_jack_hmcd_mp7"]={
		["Suppressor"]={Vector(-0.05,-20,7.1),Angle(-180,-80,-20),"models/cw2/attachments/9mmsuppressor.mdl",1},
		["Laser"]={Vector(2.1,-13,3.2),Angle(-20,-190,90),"models/weapons/tfa_ins2/upgrades/laser_pistol.mdl",.9},
		["Sight1"]={Vector(2.3,-7,3),Angle(-20,-190,0),"models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl",.9},
		["Sight2"]={Vector(2.3,-7.5,3.5),Angle(-20,-190,0),"models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl",.9},
		["Sight3"]={Vector(2.3,-7.5,3.5),Angle(-20,-190,0),"models/weapons/tfa_ins2/upgrades/a_optic_eotech.mdl",.9},
		["DrawPos"]={Vector(2.3,-8,0),Angle(160,10,180),"models/weapons/tfa_ins2/w_mp7.mdl"}
	},
	["wep_jack_hmcd_mp5"]={
		["Suppressor"]={Vector(-1.02,-25,11.25),Angle(-180,-80,-20),"models/cw2/attachments/9mmsuppressor.mdl",1},
		["DrawPos"]={Vector(2.3,-8,0),Angle(160,10,180),"models/weapons/tfa_ins2/w_mp5a4.mdl"}
	},
	["wep_jack_hmcd_rifle"]={
		["Suppressor"]={Vector(1.3,-22.5,5),Angle(-10,-95,-10),"models/cw2/attachments/556suppressor.mdl",.9},
		["Scope"]={Vector(3,-4.5,2.5),Angle(-10,-95,-10),"models/weapons/gleb/optic_scope_hmcd.mdl",1.1},
		["DrawPos"]={Vector(3.5,2,-4),Angle(160,5,180),"models/weapons/gleb/w_kar98k.mdl"}
	},
	["wep_jack_hmcd_shotgun"]={
		["Suppressor"]={Vector(4.1,-5.2,4.3),Angle(-20,-185,0),"models/weapons/tfa_ins2/upgrades/att_suppressor_12ga.mdl",.7},
		["Laser"]={Vector(2.5,-7.5,4.5),Angle(-20,-8,0),"models/cw2/attachments/anpeq15.mdl",1},
		["Sight1"]={Vector(2.5,-7,4.5),Angle(-20,-185,0),"models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl",1},
		["Sight2"]={Vector(2.5,-6,4.5),Angle(-20,-185,0),"models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl",1},
		["Sight3"]={Vector(2.5,-6,4.5),Angle(-20,-185,0),"models/weapons/tfa_ins2/upgrades/a_optic_eotech.mdl",1},
		["DrawPos"]={Vector(3.5,0,-4),Angle(160,5,180),"models/weapons/w_shot_m3juper90.mdl"}
	},
	["wep_jack_hmcd_spas"]={
		["Suppressor"]={Vector(1,-6.35,-1),Angle(40,-190,180),"models/weapons/tfa_ins2/upgrades/att_suppressor_12ga.mdl",.7},
		["DrawPos"]={Vector(4,-3,5),Angle(40,-190,180),"models/weapons/tfa_ins2/w_spas12_bri.mdl"}
	},
	["wep_jack_hmcd_combinesniper"]={
		["DrawPos"]={Vector(3,-15,-5),Angle(40,-190,180),"models/w_models/combine_sniper_test.mdl"}
	},
	["wep_jack_hmcd_sr25"]={
		["Suppressor"]={Vector(3,-10,-4.2),Angle(-20,-180,0),"models/weapons/upgrades/w_sr25_silencer.mdl",1},
		["Laser"]={Vector(1.5,-23.5,5.5),Angle(165,-175,90),"models/cw2/attachments/anpeq15.mdl",1},
		["Sight1"]={Vector(3.2,-8,1.2),Angle(-20,-185,0),"models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl",1},
		["Sight2"]={Vector(3,-8,1.5),Angle(-20,-185,0),"models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl",1},
		["Sight3"]={Vector(3,-8,1.25),Angle(-20,-185,0),"models/weapons/tfa_ins2/upgrades/a_optic_eotech.mdl",1},
		["DrawPos"]={Vector(3.5,-8,-4),Angle(160,5,180),"models/weapons/w_sr25_ins2_eft.mdl"}
	},
	["wep_jack_hmcd_riotshield"]={
		["DrawPos"]={Vector(0,-10,0),Angle(90,270,180),"models/bshields/rshield.mdl"}
	},
	["wep_jack_hmcd_bow"]={
		["DrawPos"]={Vector(5,-12,-5),Angle(90,5,170),"models/weapons/w_snij_awp.mdl"},
		["BowSight"]={Vector(5,-4.5,11),Angle(90,0,80),"models/bowsight/hunter_sights.mdl",.7}
	},
	["wep_jack_hmcd_ar2"]={
		["DrawPos"]={Vector(3,-12,0),Angle(20,-5,180),"models/weapons/w_irifle.mdl"}
	},
	["wep_jack_hmcd_crossbow"]={
		["DrawPos"]={Vector(1.5,1,-4),Angle(150,5,90),"models/weapons/w_crossbow.mdl"}
	},
	--[["wep_jack_hmcd_dbarrel"]={
		["DrawPos"]={Vector(3.5,0,-4),Angle(160,5,180),"models/weapons/ethereal/w_sawnoff_db.mdl"}
	},]]
	["wep_jack_hmcd_rpg"]={
		["DrawPos"]={Vector(3,-10,0),Angle(160,5,180),"models/weapons/tfa_ins2/w_rpg.mdl",func=function(ply) 
			if ply:IsPlayer() then
				local wep=ply:GetWeapon("wep_jack_hmcd_rpg")
				local rocket=0
				if wep:Clip1()<1 then rocket=1 end
				ply.RenderedWeapons["wep_jack_hmcd_rpg_DrawPos"]:SetBodygroup(1,rocket)
			elseif ply.Inventory then
				local wep
				for i,item in ipairs(ply.Inventory) do
					if item["Class"]=="wep_jack_hmcd_rpg" then
						wep=item
						break
					end
				end
				local rocket=0
				if wep["Ammo"]<1 then rocket=1 end
				ply.RenderedWeapons["wep_jack_hmcd_rpg_DrawPos"]:SetBodygroup(1,rocket)
			end
		end
		}
	},
	["wep_jack_hmcd_remington"]={
		["DrawPos"]={Vector(3.5,0,-4),Angle(160,5,180),"models/weapons/smc/r870/w_remington_m870.mdl"}
	},
	["wep_jack_hmcd_m249"]={
		["DrawPos"]={Vector(4,-9,-4),Angle(160,10,190),"models/weapons/w_m249.mdl"},
		["Suppressor"]={Vector(1.1,-13,-1.9),Angle(-10,-100,-10),"models/cw2/attachments/556suppressor.mdl",1},
		["Laser"]={Vector(2.5,-11,2),Angle(-20,-8.5,-10),"models/cw2/attachments/anpeq15.mdl",1},
		["Sight1"]={Vector(1.3,-11,1.7),Angle(-20,-190,0),"models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl",.9},
		["Sight2"]={Vector(1.3,-10,1.7),Angle(-20,-190,0),"models/weapons/tfa_ins2/upgrades/a_optic_aimpoint.mdl",.9},
		["Sight3"]={Vector(1.3,-11,1.7),Angle(-20,-190,0),"models/weapons/tfa_ins2/upgrades/a_optic_eotech.mdl",.9}
	},
	["wep_jack_hmcd_ptrd"]={
		["DrawPos"]={Vector(6,5,-8),Angle(160,10,190),"models/gleb/w_ptrd.mdl"}
	}
}

HMCD_CSInfo={
	["Hints"]={
		["de_dust2"]={
			{Vector(-1600,2548,40),Angle(0,0,50)},
			{Vector(-1386,2587,60),Angle(0,-90,60)},
			{Vector(-1410,2697,55),Angle(0,180,30)},
			{Vector(-1610,2758,60),Angle(-90,0,0)},
			{Vector(-1460,2621,58),Angle(0,180,-30)},
			{Vector(1134,2456,96),Angle(-90,70,0)},
			{Vector(1200,2512,130),Angle(0,180,50)},
			{Vector(1019.5,2554,140),Angle(0,165,-20)},
			{Vector(1072,2465,135),Angle(0,0,-20)},
			{Vector(1230,2544,145),Angle(0,90,-20)}
		},
		["ttt_bank_b13"]={
			{Vector(4683,5940,4370),Angle(0,0,30)},
			{Vector(4683,5910,4350),Angle(0,0,-60)},
			{Vector(4683,5925,4390),Angle(0,0,10)},
			{Vector(4700,5897,4385),Angle(0,0,-10)},
			{Vector(4694,5865,4385),Angle(0,0,-80)}
		},
		["hmcd_helicopterz"]={
			{Vector(23,415,382),Angle(0,0,0)},
			{Vector(20,484,351),Angle(295,0,0)},
			{Vector(55,404,385),Angle(-30,90,0)},
			{Vector(-43.5,487,348),Angle(-25,180,0)},
			{Vector(131,416.5,359),Angle(0,67.5,90)}
		},
		["hmcd_perdej"]={
			{Vector(23,415,382),Angle(0,0,0)},
			{Vector(20,484,351),Angle(295,0,0)},
			{Vector(55,404,385),Angle(-30,90,0)},
			{Vector(-43.5,487,348),Angle(-25,180,0)},
			{Vector(131,416.5,359),Angle(0,67.5,90)}
		},
		["de_inferno"]={
			{Vector(2084,423,160),Angle(-90,120,-90)},
			{Vector(1911,182,213),Angle(0,90,30)},
			{Vector(1908,402,218),Angle(0,-90,-30)},
			{Vector(1999,528,160),Angle(-90,120,30)},
			{Vector(1936,419.5,216),Angle(0,90,80)},
			{Vector(500,2617,160),Angle(-90,120,-90)},
			{Vector(466,2834,196),Angle(-90,120,0)},
			{Vector(385,2517,219),Angle(0,90,60)},
			{Vector(460,2678,183),Angle(0,-47,30)},
			{Vector(203,2980,189),Angle(0,0,30)}
		}
	},
	["BlowSpots"]={
		["de_dust2"]={
			[1]=Vector(-1543,2647,1),
			[2]=Vector(1128,2466,96)
		},
		["ttt_bank_b13"]={
			[1]=Vector(4700,5897,4385)
		},
		["hmcd_helicopterz"]={
			[1]=Vector(3,400,387)
		},
		["hmcd_perdej"]={
			[1]=Vector(3,400,387)
		},
		["de_inferno"]={
			[1]=Vector(2087,426,160),
			[2]=Vector(502,2615,160)
		}
	},
	["HostagePositions"]={
		["cs_office"]={
			{Vector(1710,669,-159),Angle(90,90,90)},
			{Vector(1420,-582,-159),Angle(90,-90,100)},
			{Vector(2297,-139,-159),Angle(90,0,90)}
		},
		["gm_zabroshka"]={
			{Vector(1746,229,412),Angle(90,0,0)},
			{Vector(1746,-229,412),Angle(90,90,0)},
			{Vector(2092,-281,412),Angle(90,90,0)}
		},
		["tdm_postbellum"]={
			{Vector(-1670,4905,880),Angle(90,0,0)},
			{Vector(-1670,4540,880),Angle(90,0,0)}
		},
		["ttt_67thway_v14"]={
			{Vector(-1642,5700,120),Angle(90,0,0)},
			{Vector(-1054,5739,120),Angle(90,0,0)},
			{Vector(-1294,6073,280),Angle(90,0,0)}
		},
		["zs_shelter"]={
			{Vector(-55,568,190),Angle(90,0,0)},
			{Vector(327,568,240),Angle(90,0,0)},
			{Vector(251,8,240),Angle(90,180,0)},
			{Vector(-124,8,190),Angle(90,180,0)}
		},
		["cs_militia"]={
			{Vector(653,1009,15),Angle(90,0,0)},
			{Vector(353,245,15),Angle(90,0,0)},
			{Vector(517,501,15),Angle(90,90,0)}
		},
		["gm_hram"]={
			{Vector(245,990,112),Angle(90,90,0)},
			{Vector(-449,791,338),Angle(90,90,0)}
		},
		["gm_funkis"]={
			{Vector(-215,-724,192),Angle(90,90,0)},
			{Vector(-597,-413,192),Angle(90,0,0)},
			{Vector(-438,-774,16),Angle(90,0,0)}
		}
	},
	["RescueZones"]={
		["cs_office"]={Vector(-1342,-1255,-175),Vector(-105,-2058,-350)},
		["gm_zabroshka"]={Vector(-2639,215,32),Vector(-2201,-217,296)},
		["tdm_postbellum"]={Vector(-4217,4025,213),Vector(-4096,4381,340)},
		["ttt_67thway_v14"]={Vector(511,1801,370),Vector(1515,1021,112)},
		["zs_shelter"]={Vector(616,1331,-79),Vector(-165,782,127)},
		["cs_militia"]={Vector(574,-2527,-169),Vector(431,-2376,-16)},
		["gm_hram"]={Vector(4124,1534,64),Vector(4576,2006,313)},
		["gm_funkis"]={Vector(4326,-1968,-328),Vector(4708,-2264,-122)}
	}
}

HMCD_CacheSpots={
	["rp_limansk_cs"]={
		["russian"]={Vector(-1400,-12146,0),Angle(0,30,0)},
		["ukrainian"]={Vector(1089,5285,192),Angle(0,-10,0)}
	},
	["ttt_camel_v1"]={
		["russian"]={Vector(-792,1587,-120),Angle(0,30,0)},
		["ukrainian"]={Vector(-159,-3038,128),Angle(0,50,0)}
	},
	["rp_deadcity"]={
		["russian"]={Vector(3291,-3418,32),Angle(0,-20,0)},
		["ukrainian"]={Vector(160,1820,16),Angle(0,30,0)}
	},
	["ttt_67thway_2022"]={
		["russian"]={Vector(-1017,1176,32),Angle(0,20,0)},
		["ukrainian"]={Vector(-1276,5512,0),Angle(0,-20,0)}
	}
}

hook.Add("CalcMainActivity", "Zombie Hands Activity", function(ply, velocity)
	local wep = ply:GetActiveWeapon()
	if wep.GetClimbing then
		if ply:GetNWString("Class")=="torso" then
			if velocity:LengthSqr()<1 then
				return 1, 1
			else
				return ACT_WALK, -1
			end
		elseif wep:GetClimbing() then
			return ACT_ZOMBIE_CLIMB_UP, -1
		elseif ply:Crouching() then
			return ACT_HL2MP_WALK_CROUCH_ZOMBIE_01,-1
		elseif ply:IsOnFire() or wep:GetDashing() then
			if velocity:LengthSqr()<60000 then
				return ACT_HL2MP_WALK_ZOMBIE_05,-1
			else
				return ACT_HL2MP_RUN_ZOMBIE_FAST,-1
			end
		elseif IsValid(wep:GetHolding()) then
			return ACT_HL2MP_IDLE_DUEL,-1
		else
			return ACT_HL2MP_WALK_ZOMBIE_01,-1
		end
	end
	if wep.GetClimbingFast then
		if wep:GetClimbingFast() then
			return ACT_ZOMBIE_CLIMB_UP, -1
		elseif not(ply:IsOnGround()) or ply:WaterLevel()==3 then
			return ACT_ZOMBIE_LEAPING,-1
		elseif wep:GetPouncing() then
			return ACT_ZOMBIE_LEAP_START, -1
		else
			local speed=velocity:LengthSqr()
			if speed<10000 then
				return ACT_HL2MP_WALK_ZOMBIE_06,-1
			else
				return ACT_HL2MP_RUN_ZOMBIE_FAST,-1
			end
		end
	end
end)

function ClearEmptyHooks()
	for hookFunc,hookList in pairs(hook.GetTable()) do
		for hookName,func in pairs(hookList) do
			if hookName==NULL then
				hook.Remove(hookFunc,hookName)
			end
		end
	end
end

game.AddParticles("particles/ammo_cache_ins.pcf")
game.AddParticles("particles/explosion_fx_ins.pcf")
PrecacheParticleSystem("ins_ammo_explosion")
PrecacheParticleSystem("ins_c4_explosion")

HMCD_Sounds={
	["AKM"]={
		{
			dist=100,
			snd="rifle_win1892/win1892_fire_01.wav",
			sndLvl=90
		},
		{
			dist=300,
			snd="ak74/ak74_dist.wav",
			sndLvl=130
		}
	},
	["CacheExplosion"]={
		{
			dist=100,
			snd={
				"iedins/ied_detonate_01.wav",
				"iedins/ied_detonate_02.wav",
				"iedins/ied_detonate_03.wav"
			},
			sndLvl=100
		},
		{
			dist=300,
			snd={
				"iedins/ied_detonate_dist_01.wav",
				"iedins/ied_detonate_dist_02.wav",
				"iedins/ied_detonate_dist_03.wav"
			},
			sndLvl=150
		},
		{
			dist=1000,
			snd={
				"iedins/ied_detonate_far_dist_01.wav",
				"iedins/ied_detonate_far_dist_02.wav",
				"iedins/ied_detonate_far_dist_03.wav"
			},
			sndLvl=150
		}
	},
}

hook.Add("StartCommand","HMCD_StartCommand",function(ply,cmd)
	if GAMEMODE.WeaponEquipTime and GAMEMODE.RoundStartTime+GAMEMODE.WeaponEquipTime>CurTime() then
		local wep=ply:GetActiveWeapon()
		if not(wep.AllowDuringBuytime) then
			if wep.Base!="wep_jack_hmcd_firearm_base" then
				cmd:RemoveKey(IN_ATTACK2)
			end
			cmd:RemoveKey(IN_ATTACK)
		end
	end
end)
