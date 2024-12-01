return function()
    local rules = {}

	rules.maxObjectivesAtOnce = 2
	rules.eventsPerIdleState = 1
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.eventsPerPrepareStateChance = 25        -- chance for an event (includes objectives) to happen during prep time
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 1800
	rules.idleTimeRelativeVariation = 0.5         -- X factor of idle time that may randomly vary: +/- X * idle_time. E.g. 100 idle time and 0.4 may vary between 60 and 140.
	rules.idleTimeCancelChance = 10               -- chance in percent. if cancelled, idle time is reduced to 30 seconds
	rules.preparationTimeRelativeVariation = 0.6  -- X factor of idle time that may randomly vary: +/- X * prep_time. E.g. 100 prep time and 0.4 may vary between 60 and 140.
	rules.preparationTimeCancelChance = 10        -- chance in percent. if cancelled, prep time is reduced to 10 seconds

	-- the following sets up to default values for the given mission and difficulty type:
	-- prepareAttackDefinitions, wavesEntryDefinitions, prepareSpawnTime, timeToNextDifficultyLevel, cooldownAfterAttacks
	-- param missionType: { "outpost", "survival", "scout", "temp" }
	-- param difficulty:  { "easy", "default", "hard", "brutal" }
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	rules = helper:PrepareDefaultRules( rules, "outpost", "default")
	
	rules.gameEvents = 
	{
		{ action = "new_objective",                    type = "POSITIVE", gameStates="IDLE|STREAMING",        minEventLevel = 3 }, -- new_objective is only an option in the streaming mode; do not try to pass it as NO_STREAMING
		{ action = "change_time_of_day",               type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3 },
		{ action = "add_resource",                     type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, basePercentage = 30 },
		{ action = "remove_resource",                  type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, basePercentage = 20 },
		{ action = "stronger_attack",                  type = "NEGATIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 1, amount = 2 },
		{ action = "cancel_the_attack",                type = "POSITIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 1 },
		{ action = "unlock_research",                  type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1 },
		{ action = "full_ammo",                        type = "POSITIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 2 },
		{ action = "remove_ammo",                      type = "NEGATIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 2 },
		{ action = "boss_attack",                      type = "NEGATIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 4 },
		{ action = "spawn_earthquake",                 type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/earthquake.logic",             minTime = 60, maxTime = 60,  weight = 0.3 },
		{ action = "spawn_blue_hail",                  type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 4,                    logicFile="logic/weather/blue_hail.logic",              minTime = 30, maxTime = 60,  weight = 0.2 },
		{ action = "spawn_thunderstorm",               type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2,                    logicFile="logic/weather/thunderstorm.logic",           minTime = 60, maxTime = 120 },
		{ action = "spawn_blood_moon",                 type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 5,                    logicFile="logic/weather/blood_moon.logic",             minTime = 60, maxTime = 120, weight = 0.5},
		{ action = "spawn_blue_moon",                  type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/weather/blue_moon.logic",              minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse",              type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 5,                    logicFile="logic/weather/solar_eclipse.logic",          minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_super_moon",                 type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/super_moon.logic",             minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_fog",                        type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/fog.logic",                    minTime = 60, maxTime = 120 },
		{ action = "shegret_attack",                   type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/event/shegret_attack.logic",                                        weight = 5 },
		{ action = "shegret_attack_hard",              type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/event/shegret_attack_hard.logic",                                   weight = 5 },
		{ action = "shegret_attack_very_hard",         type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 5,                    logicFile="logic/event/shegret_attack_very_hard.logic",                              weight = 3 },
		{ action = "kermon_attack",                    type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/event/kermon_attack.logic",                                         weight = 0.5 },
		{ action = "kermon_attack_hard",               type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 6,                    logicFile="logic/event/kermon_attack_hard.logic",                                    weight = 0.5 },
		{ action = "kermon_attack_very_hard",          type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 8,                    logicFile="logic/event/kermon_attack_very_hard.logic",                               weight = 0.5 },
		{ action = "phirian_attack",                   type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/event/phirian_attack.logic",                                        weight = 0.5 },
		{ action = "spawn_rain",                       type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/rain.logic",                   minTime = 120, maxTime = 120 },
		{ action = "spawn_wind_weak",                  type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/wind_weak.logic",              minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_strong",                type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/wind_strong.logic",            minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_none",                  type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2,                    logicFile="logic/weather/wind_none.logic",              minTime = 60, maxTime = 120 },
		{ action = "spawn_ion_storm",                  type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 4,                    logicFile="logic/weather/ion_storm.logic",              minTime = 30, maxTime = 60,  weight = 0.5 },
		{ action = "spawn_tornado_near_player",        type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_near_player.logic",                                 weight = 0.35 },
		{ action = "spawn_tornado_near_base",          type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/tornado_near_base.logic",                                   weight = 0.35 },
		{ action = "spawn_resource_comet",             type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_earthquake",        type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 5,                    logicFile="logic/weather/resource_earthquake.logic" },
		{ action = "spawn_meteor_shower",              type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2,                    logicFile="logic/weather/meteor_shower.logic",          minTime = 30, maxTime = 60,  weight = 0.3 },
		{ action = "spawn_firestorm",                  type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2,                    logicFile="logic/weather/firestorm.logic",              minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_fireflies",                  type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 1,                    logicFile="logic/weather/fireflies.logic",              minTime = 60, maxTime = 120, weight = 1 },
		{ action = "spawn_tornado_fire_near_base",     type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 8,                    logicFile="logic/weather/tornado_fire_near_base.logic",                              weight = 0.5 },
		{ action = "spawn_tornado_acid_near_base",     type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 8,                    logicFile="logic/weather/tornado_acid_near_base.logic",                              weight = 0.5 },
		{ action = "spawn_comet_boss_mudroner_acid",   type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/event/comet_boss_mudroner_acid.logic"  },
		{ action = "spawn_comet_boss_mudroner_cryo",   type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/event/comet_boss_mudroner_cryo.logic"  },
		{ action = "spawn_comet_boss_mudroner_energy", type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/event/comet_boss_mudroner_energy.logic" },
		{ action = "spawn_comet_boss_mudroner_fire",   type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/event/comet_boss_mudroner_fire.logic"  },
	}
	
	rules.addResourcesOnRunOut = 
	{
		{ name = "carbon_vein", runOutPercentageOnMap = 45, minToSpawn = 10000, maxToSpawn = 20000 },
		{ name = "iron_vein",   runOutPercentageOnMap = 45, minToSpawn = 10000, maxToSpawn = 20000 },
	}

	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 25, 50, 15, 50, 25 }
	
	
	rules.buildingsUpgradeStartsLogic = 
	{			
		{ name = "headquarters_lvl_2", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_1_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_1_exit.logic" },   
		{ name = "headquarters_lvl_3", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_2_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_2_exit.logic" },   
		{ name = "headquarters_lvl_4", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		{ name = "headquarters_lvl_5", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		{ name = "headquarters_lvl_6", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		{ name = "headquarters_lvl_7", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite.logic",                      minDifficultyLevel = 3 },
		{ name = "logic/objectives/destroy_nest_canoptrix_single.logic",   minDifficultyLevel = 3, maxDifficultyLevel = 8 },
		{ name = "logic/objectives/destroy_nest_canoptrix_multiple.logic", minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_creeper.logic",                 minDifficultyLevel = 6 }, 
		{ name = "logic/objectives/destroy_fire_gnerot.logic",             minDifficultyLevel = 5 },
	}

	rules.attackCountPerDifficulty = -- number of attacks, for the first attack interation of a wave is a random number between the numbers below.
	{			
		{ minCount = 1, maxCount = 1 },  -- difficulty level 1
		{ minCount = 1, maxCount = 2 },  -- difficulty level 2
		{ minCount = 1, maxCount = 2 },  -- difficulty level 3
		{ minCount = 1, maxCount = 3 },  -- difficulty level 4
		{ minCount = 2, maxCount = 3 },  -- difficulty level 5
		{ minCount = 2, maxCount = 3 },  -- difficulty level 6
		{ minCount = 2, maxCount = 3 },  -- difficulty level 7
		{ minCount = 2, maxCount = 3 },  -- difficulty level 8
		{ minCount = 3, maxCount = 4 },  -- difficulty level 9
	}

	-- chances each attack from a wave to be repeated, the chance for an attack to be repeted for the n-th time is taken from this table and a dice roll is done to determine if it repeats.
	-- an attack can only be repeated for as many times as there are repeat chances.
	-- an attack once stopped will not continue, ignoring later chance in the table.
	rules.waveRepeatChances = 
	{
		{20},                  -- consecutive chances of wave repeating at level 1
		{90},                  -- consecutive chances of wave repeating at level 2
		{80, 50},              -- consecutive chances of wave repeating at level 3
		{80, 50},              -- consecutive chances of wave repeating at level 4
		{50, 50},              -- consecutive chances of wave repeating at level 5
		{60, 60, 20},          -- consecutive chances of wave repeating at level 6
		{60, 60, 50},          -- consecutive chances of wave repeating at level 7
		{70, 70, 60, 20},      -- consecutive chances of wave repeating at level 8
		{80, 70, 70, 30, 30},  -- consecutive chances of wave repeating at level 9
	}
		
	rules.waveChanceRerollSpawnGroup = 15  -- chance for rerolled attack wave to change its map border spawn direction (N/W/S/E)
	rules.waveChanceRerollSpawn      = 30  -- chance for rerolled attack wave to change its spawning point
	rules.waveChanceReroll           = 40  -- chance to reroll and replace an attack wave from its original wave pool
	
	rules.waves = {}
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = { 1, 2, 3 },                  biomes = { "" }, levels = { 1 },   ids = { 1, 2 },       suffixes = { "", "", "alpha" }, weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {    2, 3, 4, 5},             biomes = { "" }, levels = { 1 },   ids = { 1, 2 },       suffixes = { "ultra" },         weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {       3, 4, 5, 6},          biomes = { "" }, levels = { 2 },   ids = { 1, 2 },       suffixes = { "", "", "alpha" }, weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {          4, 5, 6, 7},       biomes = { "" }, levels = { 2 },   ids = { 1, 2 },       suffixes = { "ultra" },         weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {          4, 5, 6, 7},       biomes = { "" }, levels = { 3 },   ids = { 1, 2, 3 },    suffixes = { "" },              weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {             5, 6, 7, 8},    biomes = { "" }, levels = { 3 },   ids = { 1, 2, 3 },    suffixes = { "", "alpha" },     weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {                6, 7, 8, 9}, biomes = { "" }, levels = { 3 },   ids = { 1, 2, 3 },    suffixes = { "ultra" },         weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {                6, 7, 8,  }, biomes = { "" }, levels = { 4 },   ids = { 1, 2, 3, 4 }, suffixes = { "" },              weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {                   7, 8, 9}, biomes = { "" }, levels = { 4 },   ids = { 1, 2, 3, 4 }, suffixes = { "", "alpha" },     weight = 1 },   rules.waves)
	rules.waves = helper:Generate({ groups = { "default" }, difficulty = {                      8, 9}, biomes = { "" }, levels = { 4 },   ids = { 1, 2, 3, 4 }, suffixes = { "ultra" },         weight = 1 },   rules.waves)

	rules.multiplayerWaves = 
	{
		 -- difficulty level 1		
		{ 
			additionalWaves = 0, -- Additional Waves count = NumberOfPlayers + (additionalWaves -1(const)). E.g. 2 players + 0 -1 = 1 additional multiplayer wave for 2 players. Multiplayer Additional waves are disabled in single player mode. Check dom_mananger:GetMultiplayerAttackCount for actual code
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},
	
		 -- difficulty level 2
		{ 
			additionalWaves = 0,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},
		 -- difficulty level 3
		{ 
			additionalWaves = 0,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},

		 -- difficulty level 4
		{ 
			additionalWaves = 0,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},

		 -- difficulty level 5
		{ 
			additionalWaves = 0,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},

		 -- difficulty level 6
		{ 
			additionalWaves = 0,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},

		 -- difficulty level 7
		{ 
			additionalWaves = 1,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},

		 -- difficulty level 8
		{ 
			additionalWaves = 2,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},

		 -- difficulty level 9
		{ 
			additionalWaves = 2,
			waves = 
			{
				"logic/missions/survival/attack_boss_arachnoid.logic",
				"logic/missions/survival/attack_boss_gnerot.logic",
				"logic/missions/survival/attack_boss_baxmoth.logic",
				"logic/missions/survival/attack_boss_krocoon.logic",
			}
		},
	}

	rules.extraWaves = 
	{
		 -- difficulty level 1		
		{ 
			"logic/missions/survival/attack_level_1_id_1.logic",
			"logic/missions/survival/attack_level_1_id_2.logic",
		},
	
		 -- difficulty level 2
		{ 			
			"logic/missions/survival/attack_level_2_id_1.logic",
			"logic/missions/survival/attack_level_2_id_2.logic",
		},

		 -- difficulty level 3
		{ 
			"logic/missions/survival/attack_level_3_id_1.logic",
			"logic/missions/survival/attack_level_3_id_2.logic",
		},

		 -- difficulty level 4
		{ 			
			"logic/missions/survival/attack_level_4_id_1.logic",
			"logic/missions/survival/attack_level_4_id_2.logic",
			"logic/missions/survival/attack_level_4_id_3.logic",
		},

		 -- difficulty level 5
		{ 
			"logic/missions/survival/attack_level_5_id_1.logic",
			"logic/missions/survival/attack_level_5_id_2.logic",			
			"logic/missions/survival/attack_level_5_id_3.logic",			
			"logic/missions/survival/attack_level_5_id_4.logic",			
		},

		 -- difficulty level 6
		{ 
			"logic/missions/survival/attack_level_6_id_1.logic",
			"logic/missions/survival/attack_level_6_id_2.logic",			
			"logic/missions/survival/attack_level_6_id_3.logic",			
			"logic/missions/survival/attack_level_6_id_4.logic",			
			"logic/missions/survival/attack_level_6_id_5.logic",			
		},

		 -- difficulty level 7
		{ 
			"logic/missions/survival/attack_level_7_id_1.logic",
			"logic/missions/survival/attack_level_7_id_2.logic",
			"logic/missions/survival/attack_level_7_id_3.logic",
			"logic/missions/survival/attack_level_7_id_4.logic",
			"logic/missions/survival/attack_level_7_id_5.logic",
		},

		 -- difficulty level 8
		{ 
			"logic/missions/survival/attack_level_8_id_1.logic",
			"logic/missions/survival/attack_level_8_id_2.logic",
			"logic/missions/survival/attack_level_8_id_3.logic",
			"logic/missions/survival/attack_level_8_id_4.logic",
			"logic/missions/survival/attack_level_8_id_5.logic",
		},

		 -- difficulty level 9
		{ 
			"logic/missions/survival/attack_level_8_id_1.logic",
			"logic/missions/survival/attack_level_8_id_2.logic",
			"logic/missions/survival/attack_level_8_id_3.logic",
			"logic/missions/survival/attack_level_8_id_4.logic",
			"logic/missions/survival/attack_level_8_id_5.logic",
		},
	}

	rules.bosses = 
	{
		 -- difficulty level 1		
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},
	
		 -- difficulty level 2
		{ 			
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 3
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 4
		{ 			
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 5
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",			
		},

		 -- difficulty level 6
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",	
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 7
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 8
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},

		 -- difficulty level 9
		{ 
			"logic/missions/survival/attack_boss_arachnoid.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_baxmoth.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},
	}

    return rules;
end