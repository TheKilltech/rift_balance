return function()
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	local rules  = helper:PrepareDefaultRules( {}, "scout", "default")

	rules.maxObjectivesAtOnce = 1
	rules.eventsPerIdleState = 2
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.eventsPerPrepareStateChance = 15        -- chance to spawn events with objectives
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 1200
	rules.idleTimeRelativeVariation = 0.4         -- X factor of idle time that may randomly vary: +/- X * idle_time
	rules.idleTimeCancelChance = 20               -- chance in percent
	rules.preparationTimeRelativeVariation = 0.35 -- X factor of idle time that may randomly vary: +/- X * prep_time
	rules.preparationTimeCancelChance = 15        -- chance in percent

	rules.gameEvents = 
	{
		{ action = "spawn_earthquake",          type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3,                    logicFile="logic/weather/earthquake.logic",          minTime = 60, maxTime = 60,  weight = 0.5 },
		{ action = "spawn_earthquake",          type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 3,                    logicFile="logic/weather/earthquake.logic",          minTime = 60, maxTime = 60,  weight = 0.25 },
		{ action = "spawn_blue_hail",           type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4,                    logicFile="logic/weather/blue_hail.logic",           minTime = 30, maxTime = 60,  weight = 0.25 },
		{ action = "spawn_blue_hail",           type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 4,                    logicFile="logic/weather/blue_hail.logic",           minTime = 30, maxTime = 60,  weight = 0.1 },
		{ action = "spawn_thunderstorm",        type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2,                    logicFile="logic/weather/thunderstorm.logic",        minTime = 60, maxTime = 120 },
		{ action = "spawn_blood_moon",          type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/weather/blood_moon.logic",          minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_blue_moon",           type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/weather/blue_moon.logic",           minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse",       type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/solar_eclipse.logic",       minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_super_moon",          type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/super_moon.logic",          minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_fog",                 type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/fog.logic",                 minTime = 60, maxTime = 120 },
		{ action = "shegret_attack",            type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/event/shegret_attack.logic",                                     weight = 1 },
		{ action = "spawn_rain",                type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/rain.logic",                minTime = 120, maxTime = 120 },
		{ action = "spawn_wind_weak",           type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/wind_weak.logic",           minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_strong",         type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/wind_strong.logic",         minTime = 60, maxTime = 120 },
		{ action = "spawn_wind_none",           type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2,                    logicFile="logic/weather/wind_none.logic",           minTime = 60, maxTime = 120 },
		{ action = "spawn_ion_storm",           type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/ion_storm.logic",           minTime = 30, maxTime = 60,   weight = 0.5 },
		{ action = "spawn_tornado_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1, maxEventLevel = 2, logicFile="logic/weather/tornado_near_player.logic",                               weight = 0.5 },
		{ action = "spawn_tornado_near_base",   type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/tornado_near_base.logic",                                 weight = 0.5 },	
		{ action = "spawn_tornado_fire_near_player",   type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 6,                    logicFile="logic/weather/tornado_fire_near_player.logic",                          weight = 0.5 },	
		{ action = "spawn_tornado_acid_near_player",   type = "NEGATIVE", gameStates="ATTACK|IDLE",    minEventLevel = 6,                    logicFile="logic/weather/tornado_acid_near_player.logic",                          weight = 0.5 },		
		{ action = "spawn_firestorm",           type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2,                    logicFile="logic/weather/firestorm.logic",           minTime = 60, maxTime = 120,  weight = 0.5 },
		{ action = "spawn_fireflies",           type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 1,                    logicFile="logic/weather/fireflies.logic",           minTime = 60, maxTime = 120,  weight = 1   },
		{ action = "spawn_resource_comet",      type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/weather/resource_comet.logic"  },                                 
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 5,                    logicFile="logic/weather/resource_earthquake.logic",                               weight = 1 },
		{ action = "spawn_resource_earthquake", type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 5,                    logicFile="logic/weather/resource_earthquake.logic",                               weight = 0.5 },
		{ action = "spawn_meteor_shower",       type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 4,                    logicFile="logic/weather/meteor_shower.logic",       minTime = 30, maxTime = 60,   weight = 0.5 },
		{ action = "spawn_meteor_shower",       type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 4,                    logicFile="logic/weather/meteor_shower.logic",       minTime = 30, maxTime = 60,   weight = 0.25 },	
		{ action = "spawn_comet_silent",        type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 1,                    logicFile="logic/weather/comet_silent.logic",                                      weight = 2 }
	}
	
	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 20, 10, 5 }

	rules.addResourcesOnRunOut = 
	{
		{ name = "cobalt_vein",        runOutPercentageOnMap =  5, minToSpawn = 2000, maxToSpawn = 3000, chance = 5,                                      events = { "spawn_resource_comet" } },
		{ name = "palladium_vein",     runOutPercentageOnMap =  5, minToSpawn = 2000, maxToSpawn = 3000, chance = 5,  eventGroup = "palladium_completed", events = { "spawn_resource_comet" } },
		{ name = "morphium_deepvein",  runOutPercentageOnMap = 10, isInfinite = 1,                       chance = 20, eventGroup = "morphium_unlocked",   events = { "spawn_resource_comet" }, blueprint = "weather/alien_comet_flying"  },
		--{ name = "petroleum_deepvein",   runOutPercentageOnMap = 10,  isInfinite = 1,                                                           events = { "spawn_resource_earthquake" } },
		--{ name = "uranium_ore_deepvein", runOutPercentageOnMap = 10, minToSpawn = 40000, maxToSpawn = 50000, eventGroup = "uranium_completed",  events = { "spawn_resource_earthquake" } },
	}

	rules.buildingsUpgradeStartsLogic = {	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite.logic",                      minDifficultyLevel = 4 },
		{ name = "logic/objectives/destroy_nest_canoptrix_single.logic",   minDifficultyLevel = 3 },
	}

	rules.maxAttackCountPerDifficulty = 
	{			
		0,  -- difficulty level 1
		0,  -- difficulty level 2
		0,  -- difficulty level 3		
		0,  -- difficulty level 4
		0,  -- difficulty level 5
		1,  -- difficulty level 6
		1,  -- difficulty level 7
		2,  -- difficulty level 8
		2,  -- difficulty level 9
	}
	
	rules.waveRepeatChances = 
	{
		{},  -- concecutive chances of wave repeating at level 1
		{},  -- concecutive chances of wave repeating at level 2
		{},  -- concecutive chances of wave repeating at level 3
		{},  -- concecutive chances of wave repeating at level 4
		{},  -- concecutive chances of wave repeating at level 5
		{10},  -- concecutive chances of wave repeating at level 6
		{30},  -- concecutive chances of wave repeating at level 7
		{40, 50},  -- concecutive chances of wave repeating at level 8
		{60, 40, 20, 35},  -- concecutive chances of wave repeating at level 9
	}
	
	local waves_gen = require( "lua/missions/v2/waves_gen.lua" )
	rules.waves = {}
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = { 6, 7, 8, 9 },  biomes = { "" }, levels = { 1 },    ids = { 1, 2 }, suffixes = { "", },         },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = {    7, 8, 9 },  biomes = { "" }, levels = { 1 },    ids = { 1, 2 }, suffixes = { "", "alpha" }, },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = {    7, 8, 9 },  biomes = { "" }, levels = { 2 },    ids = { 1, 2 }, suffixes = { "" },          },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = {       8, 9 },  biomes = { "" }, levels = { 2 },    ids = { 1, 2 }, suffixes = { "alpha" },     },   rules.waves)
	rules.waves = wave_gen:Generate({ groups = { "default" }, difficulty = {          9 },  biomes = { "" }, levels = { 3, 4 }, ids = { 1, 3 }, suffixes = { "" },          },   rules.waves)
	
	rules.waves = wave_gen:Generate({ groups = { "acid" },    difficulty = {       8, 9 },  biomes = { "" }, levels = { 1, 2 }, ids = { 2 },    suffixes = { "" },          },   rules.waves)
	
	rules.extraWaves = 	{	}
	rules.bosses = 	{	}

    return rules;
end