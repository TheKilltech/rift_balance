return function(params)
	-- the following sets up to default values for the given mission and difficulty type:
	-- prepareAttackDefinitions, wavesEntryDefinitions, prepareSpawnTime, timeToNextDifficultyLevel, cooldownAfterAttacks
	-- param missionType: { "outpost", "survival", "scout", "temp" }
	-- param difficulty:  { "easy", "default", "hard", "brutal" }
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	local rules  = helper:PrepareDefaultRules( {}, "outpost", nil, params)

	rules.maxObjectivesAtOnce = 0
	rules.eventsPerIdleState = 1
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.eventsPerPrepareStateChance = 20        -- chance to spawn events with objectives
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 1800
	rules.idleTimeRelativeVariation = 0.6         -- X factor of idle time that may randomly vary: +/- X * idle_time
	rules.idleTimeCancelChance = 5                -- chance in percent, reduces idle time down to 120
	rules.preparationTimeRelativeVariation = 0.55 -- X factor of idle time that may randomly vary: +/- X * prep_time
	rules.preparationTimeCancelChance = 25        -- chance in percent

	rules.gameEvents = 
	{
		{ action = "new_objective",                    type = "POSITIVE", gameStates="IDLE|STREAMING",        minEventLevel = 3 }, -- new_objective is only an option in the streaming mode; do not try to pass it as NO_STREAMING
		{ action = "change_time_of_day",               type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3 },
		{ action = "add_resource",                     type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, basePercentage = 30 },
		{ action = "remove_resource",                  type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, basePercentage = 20 },
		{ action = "cancel_the_attack",                type = "POSITIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 1 },
		{ action = "unlock_research",                  type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1 },
		{ action = "full_ammo",                        type = "POSITIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 2 },
		{ action = "remove_ammo",                      type = "NEGATIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 2 },
		{ action = "boss_attack",                      type = "NEGATIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 4 },
		{ action = "stronger_attack",                  type = "NEGATIVE", gameStates="ATTACK",                minEventLevel = 1, amount = 1 },
		{ action = "spawn_blue_hail",                  type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 4, logicFile="logic/weather/blue_hail.logic",     minTime = 30,  maxTime = 60,  weight = 0.25 },
		{ action = "spawn_thunderstorm",               type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2, logicFile="logic/weather/thunderstorm.logic",  minTime = 60,  maxTime = 120 },
		{ action = "spawn_blood_moon",                 type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 2, logicFile="logic/weather/blood_moon.logic",    minTime = 60,  maxTime = 120, weight = 2 },
		{ action = "spawn_blue_moon",                  type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 3, logicFile="logic/weather/blue_moon.logic",     minTime = 60,  maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse",              type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2, logicFile="logic/weather/solar_eclipse.logic", minTime = 60,  maxTime = 120, weight = 0.25 },
		{ action = "spawn_super_moon",                 type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2, logicFile="logic/weather/super_moon.logic",    minTime = 60,  maxTime = 120, weight = 0.5 },
		{ action = "spawn_fog",                        type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 1, logicFile="logic/weather/fog.logic",           minTime = 60,  maxTime = 120, weight = 0.5  },		
		{ action = "phirian_attack",                   type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 3, logicFile="logic/event/phirian_attack.logic",                                weight = 1 },
		{ action = "phirian_attack_hard",              type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 5, logicFile="logic/event/phirian_attack_hard.logic",                           weight = 3 },
		{ action = "phirian_attack_very_hard",         type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 8, logicFile="logic/event/phirian_attack_very_hard.logic", weight = 3 },
		{ action = "spawn_rain",                       type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1, logicFile="logic/weather/rain.logic",          minTime = 120, maxTime = 120, weight = 0.5 },
		{ action = "spawn_wind_weak",                  type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 2, logicFile="logic/weather/wind_weak.logic",     minTime = 120, maxTime = 180, weight = 1 },
		{ action = "spawn_wind_strong",                type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1, logicFile="logic/weather/wind_strong.logic",   minTime = 60,  maxTime = 120 },
		{ action = "spawn_wind_none",                  type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3, logicFile="logic/weather/wind_none.logic",     minTime = 90,  maxTime = 150, weight = 1 },
		{ action = "spawn_ion_storm",                  type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3, logicFile="logic/weather/ion_storm.logic",     minTime = 30,  maxTime = 60,  weight = 1 },
		{ action = "spawn_resource_comet",             type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 4, logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_meteor_shower",              type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2, logicFile="logic/weather/meteor_shower.logic", minTime = 30,  maxTime = 60,  weight = 0.5 },
		{ action = "spawn_fireflies",                  type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 1, logicFile="logic/weather/fireflies.logic",     minTime = 60,  maxTime = 120, weight = 4 },
		{ action = "spawn_blooming_air",               type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 5, logicFile="logic/weather/blooming_air.logic",  minTime = 120, maxTime = 180, weight = 4 },
		{ action = "spawn_monsoon",                    type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1, logicFile="logic/weather/monsoon.logic",       minTime = 60,  maxTime = 120, weight = 2 },
		{ action = "spawn_tornado_acid_near_player",   type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3, maxEventLevel = 4, logicFile="logic/weather/tornado_acid_near_player.logic", weight = 0.5 },
		{ action = "spawn_tornado_acid_near_base",     type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4, logicFile="logic/weather/tornado_acid_near_base.logic",                      weight = 0.5 },				
		{ action = "spawn_comet_boss_mudroner_acid",   type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 5, logicFile="logic/event/comet_boss_mudroner_acid.logic"  },
		{ action = "spawn_comet_boss_mudroner_cryo",   type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 5, logicFile="logic/event/comet_boss_mudroner_cryo.logic"  },
		{ action = "spawn_comet_boss_mudroner_energy", type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 5, logicFile="logic/event/comet_boss_mudroner_energy.logic"  },
		{ action = "spawn_comet_boss_mudroner_fire",   type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 5, logicFile="logic/event/comet_boss_mudroner_fire.logic"  },
		{ action = "spawn_comet_silent",               type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 3, logicFile="logic/weather/comet_silent.logic",                                weight = 1 },
	}

	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 25, 5 }
	
	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite_baxmoth.logic",              minDifficultyLevel = 3 },
		{ name = "logic/objectives/kill_elite_dynamic.logic",              minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_nest_stickrid_single.logic",    minDifficultyLevel = 3 }, 
		{ name = "logic/objectives/destroy_nest_stickrid_multiple.logic",  minDifficultyLevel = 5 },
		{ name = "logic/objectives/destroy_nest_plutrodon_single.logic",   minDifficultyLevel = 4 }, 
		{ name = "logic/objectives/destroy_nest_plutrodon_multiple.logic", minDifficultyLevel = 6 },
		{ name = "logic/objectives/destroy_nest_fungor_single.logic",      minDifficultyLevel = 5 }, 
		{ name = "logic/objectives/destroy_nest_fungor_multiple.logic",    minDifficultyLevel = 7 }		
	}

	rules.addResourcesOnRunOut = 
	{
		{ name = "cobalt_vein",    runOutPercentageOnMap = 30, minToSpawn = 10000, maxToSpawn = 20000, chance = 30 },
		{ name = "palladium_vein", runOutPercentageOnMap = 30, minToSpawn =  1000, maxToSpawn =  5000, chance = 15, eventGroup = "palladium_completed" },
		{ name = "titanium_vein",  runOutPercentageOnMap = 30, minToSpawn =  1000, maxToSpawn =  5000, chance = 15, eventGroup = "titanium_completed" }
	}
	
	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 6, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },
	}

	rules.buildingsUpgradeStartsLogic = {}

	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 1, maxCount = 2 },  -- difficulty level 1
		{ minCount = 1, maxCount = 2 },  -- difficulty level 2
		{ minCount = 1, maxCount = 3 },  -- difficulty level 3
		{ minCount = 2, maxCount = 3 },  -- difficulty level 4
		{ minCount = 2, maxCount = 3 },  -- difficulty level 5
		{ minCount = 2, maxCount = 4 },  -- difficulty level 6
		{ minCount = 2, maxCount = 4 },  -- difficulty level 7
		{ minCount = 2, maxCount = 4 },  -- difficulty level 8
		{ minCount = 3, maxCount = 4 },  -- difficulty level 9
	}
	
	rules.waveRepeatChances = 
	{
		{},                    -- consecutive chances of wave repeating at level 1
		{},                    -- consecutive chances of wave repeating at level 2
		{15},                  -- consecutive chances of wave repeating at level 3
		{50},                  -- consecutive chances of wave repeating at level 4
		{50, 20},              -- consecutive chances of wave repeating at level 5
		{60, 40, 10},          -- consecutive chances of wave repeating at level 6
		{60, 40, 20},          -- consecutive chances of wave repeating at level 7
		{70, 50, 40, 10},      -- consecutive chances of wave repeating at level 8
		{80, 60, 50, 30, 30},  -- consecutive chances of wave repeating at level 9
	}
	
	rules.waveChanceRerollSpawnGroup = 60
	rules.waveChanceRerollSpawn      = 25
	rules.waveChanceReroll           = 80

	rules.waves            = helper:Default_Waves(     "swamp", "outpost", rules.params.difficulty, nil)
	rules.extraWaves       = helper:Default_ExtraWaves("swamp", "outpost", rules.params.difficulty, nil)
	rules.multiplayerWaves = helper:Default_MpWaves(   "swamp", "outpost", rules.params.difficulty, nil)
	rules.bosses           = helper:Default_Bosses(    "swamp", "outpost", rules.params.difficulty, nil)
	
    return rules;
end