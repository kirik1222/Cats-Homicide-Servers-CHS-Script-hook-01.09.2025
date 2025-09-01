HMCD_LANGUAGE_english={
	["Classic"]={
		["Normal"]={
			["name"]="Homicide: Standard Mode",
		
			["bystander"]="Bystander",
			["killer"]="Murderer",
			["gunman"]="Bystander", 

			["weapon_posession"]="with a lawful concealed firearm",
			["killer_help"]="Kill everyone. Dont get caught.",
			["gunman_help"]="Find and kill the murderer.",
			["bystander_help"]="Find and kill the murderer."
		},
		["Pussy"]={
			["name"]="Homicide: Gun-Free-Zone Mode",
			["killer_help"]="Kill everyone.",
			["bystander_help"]="Hide from murderer and wait for police to arrive."
		},
		["Epic"]={
			["name"]="Homicide: Wild-West Mode",			
			["weapon_posession"]="You are in possesion of a revolver"
		},
		["Jihad"]={
			["name"]="Homicide: Jihad Mode",	
			["killer"]="Suicidal Lunatic",
			["killer_help"]="Kill everyone."
		},		
		["Strange"]={
			["name"]="Homicide: Standard Mode",	
			["bystander"]="Bystander",
			["bystander_help"]="Find and kill the murderer."
		},
		["Walkthrough"]={
			["player"]=""
		}
	},
	["SOE"]={
		["Normal"]={
			["name"]="Homicide: State-of-Emergency Mode",
			["bystander"]="Innocent",
			["gunman"]="Innocent",
			["killer"]="Traitor",
			["weapon_posession"]="with a large weapon",
			["killer_help"]="Kill everyone and take their stuff.",
			["gunman_help"]="Find and kill the traitor.",
			["bystander_help"]="Find and kill the traitor."
		},
		["Zombie"]={
			["name"]="Homicide: Zombie Outbreak Mode",
			["bystander"]="Survivor",
			["gunman"]="Survivor",
			["killer"]="Alpha Zombie",
			["weapon_posession"]="with a large weapon",
			["killer_help"]="Destroy the humans.",
			["gunman_help"]="Survive until the national guard arrives.",
			["bystander_help"]="Survive until the national guard arrives."
		},
		["Deathmatch"]={
			["name"]="Classic free-for-all deathmatch. Skill rewards are increased.",
			["fighter"]="Fighter",
			["fighter_help"]="Kill everyone you see."
		},
		["Hl2"]={
			["name"]="Homicide: Resistance Versus Combine",
			["rebel"]="Rebel",
			["rebel_help"]="Eliminate the other team to win.",
			["combine"]="Combine",
			["combine_help"]="Eliminate the other team to win."
		},
		["Hl2_WT"]={
			["name"]="Homicide: Half-Life 2",
			["rebel"]=function()
				if LocalPlayer():GetNWString("Class")=="" then return "Rebel" else return "Refugee" end
			end,
			["rebel_help"]="Reach the end of the level to win.",
			["combine"]=function()
				if LocalPlayer():GetNWString("Class")=="cp" then return "Metropolice" else return "Combine" end
			end,
			["freeman"]="Freeman",
			["freeman_help"]="Lead the resistance to victory."
		},
		["Riot"]={
			["name"]="Homicide: Riot Mode",
			["rioter"]="Rioter",
			["rioter_help"]="Rob, destroy and kill.",
			["riotpolice"]="Police Officer",
			["riotpolice_help"]="Disperse the crowd of rioters.",
			["george"]="George Floyd",
			["george_help"]="Accompany the peaceful protesters."
		},
		["Strange"]={
			["name"]="Homicide: State-of-Emergency Mode",
			["bystander"]="Innocent",
			["bystander_help"]="Find and kill the traitor."
		},
		["CS"]={
			["name"]=function() 
				if HMCD_CSInfo["HostagePositions"][game.GetMap()] then 
					return "Homicide: Hostage Rescue Scenario" 
				elseif HMCD_CSInfo["BlowSpots"][game.GetMap()] then
					return "Homicide: Bomb Scenario"
				else
					return "Homicide: Terrorist Attack"
				end 
			end,
			["ct"]="Counter Terrorist",
			["ct_help"]=function()
				if HMCD_CSInfo["HostagePositions"][game.GetMap()] then 
					return "Kill all terrorists. Make sure not to hurt the hostage!" 
				elseif HMCD_CSInfo["BlowSpots"][game.GetMap()] then
					return "Kill all terrorists before they can detonate the charges." 
				else
					return "Kill all terrorists."
				end
			end,
			["t"]="Terrorist",
			["t_help"]=function()
				if HMCD_CSInfo["HostagePositions"][game.GetMap()] then
					return "Kill all counter-terrorists. Don't let them rescue the hostage!"
				elseif HMCD_CSInfo["BlowSpots"][game.GetMap()] then
					return "Plant the bomb or kill all counter-terrorists."
				else
					return "Kill all counter-terrorists."
				end 
			end
		},
		["Ukraine"]={
			["name"]="Homicide: War in Ukraine",
			["russian"]="Wagner Soldier",
			["russian_help"]=function()
				if HMCD_CacheSpots[game.GetMap()] then
					return "Destroy ukrainian weapon cache and clear out the territory."
				else
					return "Eliminate all ukrainian soldiers."
				end
			end,
			["ukrainian"]="AZOV Soldier",
			["ukrainian_help"]=function()
				if HMCD_CacheSpots[game.GetMap()] then
					return "Destroy russian weapon cache and clear out the territory."
				else
					return "Eliminate all russian soldiers."
				end
			end
		},
		["Easter"]={
			["name"]="Homicide: Пе́сах",
			["jesus"]="Jesus",
			["jesus_help"]="Wait for your followers to rescue you.",
			["follower"]="Follower of Jesus",
			["follower_help"]="Rescue Jesus and destroy his captors.",
			["jew"]="Jew",
			["jew_help"]="Don't let the followers of Jesus rescue him."
		},
		["Terminator"]={
			["name"]="Homicide: Terminator",
			["terminator"]="Terminator",
			["terminator_help"]="Kill everyone.",
			["survivor"]="Survivor",
			["survivor_help"]="Destroy the terminator."
		},
		["Walkthrough"]={
			["player"]=""
		}
	},
	["gunman_SOE"]="Innocent",
	["killer_SOE"]="Traitor",
	["bystander_SOE"]="Innocent",
	["weapon_posession_SOE"]="You have a large weapon",
	["you_are"]="You are",
	["the_murderer_was"]="The murderer was",
	["the_traitor_was"]="The traitor was",
	["traitor_win"]="The traitor wins!",
	["murderer_win"]="The murderer wins!",
	["rebels_win"]="Rebels win!",
	["combine_win"]="Combine win!",
	["innocent_win"]="Innocents win!",
	["everyone_died"]="Everyone died. The end",
	["murderer_arrested"]="The murderer was arrested!",
	["rioters_win"]="Rioters win!",
	["police_win"]="Police win!",
	["alpha_giveup"]="Survivors win! The alpha zombie gave up",
	["traitor_giveup"]="Innocents win! The traitor gave up",
	["murderer_giveup"]="Bystanders win! The murderer gave up",
	["t_win"]="Terrorists win!",
	["ct_win"]="Counter-terrorists win!",
	["rus_win"]="Russians win!",
	["ukr_win"]="Ukrainians win!",
	["jews_win"]="Jews win!",
	["jesus_win"]="Jesus and his followers win!",
	["terminator_win"]="Terminator wins!",
	["survivors_win"]="Survivors win!",
	["taking_cross_down"]="Taking cross down...",
	["wins"]="wins!",
	["sb_jointeam"]="Join",
	["sb_mute"]="Mute",
	["sb_unmute"]="Unmute",
	["sb_stats"]="Statistics",
	["changeTeam"]="changed team to",
	["bystander"]="Bystander",
	["murderer"]="Murderer",
	["killer"]="Murderer",
	["traitor"]="Traitor",
	["alpha"]="Alpha Zombie",
	["survivor"]="Survivor",
	["innocent"]="Innocent",
	["fighter"]="Fighter",
	["combine"]="Combine",
	["rebel"]="Rebel",
	["police"]="Police",
	["riotpolice"]="Police",
	["natguard"]="National guard",
	["swat"]="SWAT",
	["rioter"]="Rioter",
	["t"]="Terrorist",
	["ct"]="Counter-Terrorist",
	["voiceHelp"]="Help",
	["voiceHelpDescription"]="Yell for help",
	["voiceRandom"]="Random",
	["voiceRandomDescription"]="I don't even know",
	["voiceHappy"]="Happy",
	["voiceHappyDescription"]="Perform a happy gesture",
	["voiceMorose"]="Morose",
	["voiceMoroseDescription"]="Feel the sadness",
	["voiceResponse"]="Response",
	["voiceResponseDescription"]="You tell em",
	["voiceVillain"] = "Villain",
	["voiceVillainDescription"] = "Kill them all",
	["voiceDrop Item"]="Drop Item",
	["voiceDrop ItemDescription"]="drop your currently held item",
	["voiceUnload Weapon"]="Unload Weapon",
	["voiceUnload WeaponDescription"]="unload your currently held weapon",
	["voiceHero"]="Hero",
	["voiceHeroDescription"]="Save the day",
	["voiceAttach"]="Modify Weapon",
	["voiceAttachDescription"]="modify currently held weapon",
	["voiceTarget"]="Target spotted",
	["voiceTargetDescription"]="",
	["voiceKill"]="Enemy down",
	["voiceKillDescription"]="",
	["voiceClear"]="Sector clear",
	["voiceClearDescription"]="",
	["voiceYes"]="Affirmative",
	["voiceYesDescription"]="",
	["voiceYes_CP"]="Affirmative",
	["voiceYes_CPDescription"]="",
	["voiceBackup"]="Need Backup!",
	["voiceBackupDescription"]="",
	["voiceInposition"]="In Position",
	["voiceInpositionDescription"]="",
	["voiceKill_CP"]="Enemy down",
	["voiceKill_CPDescription"]="",
	["voiceHoldposition"]="Hold this Position",
	["voiceHoldpositionDescription"]="",
	["voiceInbound"]="Moving in",
	["voiceInboundDescription"]="",
	["voiceKillrebel"]="Enemy down",
	["voiceKillrebelDescription"]="",
	["voiceDrop Equipment"]="Drop Equipment",
	["voiceDrop EquipmentDescription"]="drop worn items",
	["voiceRequest An Airstrike"]="Airstrike",
	["voiceRequest An AirstrikeDescription"]="(Chlorine)",
	["voiceRequest An Airstrike2"]="Airstrike",
	["voiceRequest An Airstrike2Description"]="(Headcrabs)",
	["voiceDrop Ammo"]="Drop Ammo",
	["voiceDrop AmmoDescription"]="choose ammo to drop",
	["killed"]="killed the",
	["mysterious_death"]="The {ROLE} died in mysterious circumstances.",
	["spectating"]="Spectating"
}