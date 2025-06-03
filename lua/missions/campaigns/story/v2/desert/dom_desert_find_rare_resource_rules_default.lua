return function()
	-- the following sets up to default values for the given mission and difficulty type:
	-- prepareAttackDefinitions, wavesEntryDefinitions, prepareSpawnTime, timeToNextDifficultyLevel, cooldownAfterAttacks
	-- param missionType: { "outpost", "survival", "scout", "temp" }
	-- param difficulty:  { "easy", "default", "hard", "brutal" }
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	local rules  = helper:PrepareDefaultRules( {}, "scout", "default")

	rules.maxObjectivesAtOnce = 2
	rules.eventsPerIdleState = 2
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.eventsPerPrepareStateChance = 15        -- chance to spawn events with objectives
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 2400
	rules.idleTimeRelativeVariation = 0.6         -- X factor of idle time that may randomly vary: +/- X * idle_time
	rules.idleTimeCancelChance = 15               -- chance in percent, reduces idle time down to 120
	rules.preparationTimeRelativeVariation = 0.35 -- X factor of idle time that may randomly vary: +/- X * prep_time
	rules.preparationTimeCancelChance = 15        -- chance in percent

	rules.gameEvents = 
	{
		{ action = "spawn_earthquake",          type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2,                    logicFile="logic/weather/earthquake.logic",          minTime = 60, maxTime = 60  },
		{ action = "spawn_solar_burn",          type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/solar_burn.logic",          minTime = 20, maxTime = 45,   weight = 4,    weather = "SUN" },
		{ action = "spawn_dust_storm",          type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2,                    logicFile="logic/weather/dust_storm.logic",          minTime = 60, maxTime = 120,  weight = 2,    weather = "WIND" },
		{ action = "spawn_blood_moon",          type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/weather/blood_moon.logic",          minTime = 60, maxTime = 120,  weight = 0.2,  weather = "SUN" },
		{ action = "spawn_blue_moon",           type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/weather/blue_moon.logic",           minTime = 60, maxTime = 120,  weight = 0.2,  weather = "SUN" },
		{ action = "spawn_solar_eclipse",       type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/solar_eclipse.logic",       minTime = 60, maxTime = 120,  weight = 0.25, weather = "SUN" },
		{ action = "spawn_super_moon",          type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/super_moon.logic",          minTime = 60, maxTime = 120,  weight = 1   },
		{ action = "spawn_wind_weak",           type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2,                    logicFile="logic/weather/wind_weak.logic",           minTime = 60, maxTime = 120,  weight = 0.5,   weather = "WIND" },
		{ action = "spawn_wind_none",           type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2,                    logicFile="logic/weather/wind_none.logic",           minTime = 60, maxTime = 120,  weight = 0.8,   weather = "WIND" },
		{ action = "spawn_ion_storm",           type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/ion_storm.logic",           minTime = 30, maxTime = 60,   weight = 0.15,  weather = "WIND" },
		{ action = "spawn_meteor_shower",       type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 8,                    logicFile="logic/weather/meteor_shower.logic",       minTime = 30, maxTime = 60,   weight = 0.2  },
		{ action = "spawn_meteor_shower",       type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 8,                    logicFile="logic/weather/meteor_shower.logic",       minTime = 30, maxTime = 60,   weight = 0.05 },
		{ action = "spawn_comet_silent",        type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 2,                    logicFile="logic/weather/comet_silent.logic",                                      weight = 2 }
	}
	
	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 50, 25, 10 }

	rules.addResourcesOnRunOut = 
	{
		{ name = "cobalt_vein",        runOutPercentageOnMap =  5, minToSpawn = 1000, maxToSpawn = 2000, ignoreChance = 85,                                     events = { "spawn_resource_comet" } },
		{ name = "uranium_ore_vein",   runOutPercentageOnMap =  5, minToSpawn = 1000, maxToSpawn = 2000, ignoreChance = 85, eventGroup = "uranium_completed"  },
		{ name = "morphium_deepvein",  runOutPercentageOnMap = 10, isInfinite = 1,                       ignoreChance = 65, eventGroup = "morphium_unlocked",   events = { "spawn_resource_comet" }, blueprint = "weather/alien_comet_flying"  },
		--{ name = "petroleum_deepvein",   runOutPercentageOnMap = 10,  isInfinite = 1,                                                           events = { "spawn_resource_earthquake" } },
		--{ name = "uranium_ore_deepvein", runOutPercentageOnMap = 10, minToSpawn = 40000, maxToSpawn = 50000, eventGroup = "uranium_completed",  events = { "spawn_resource_earthquake" } },
	}

	rules.buildingsUpgradeStartsLogic = 
	{			
  
	}

	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 1, maxCount = 1 },  -- difficulty level 1
		{ minCount = 1, maxCount = 1 },  -- difficulty level 2
		{ minCount = 1, maxCount = 1 },  -- difficulty level 3
		{ minCount = 1, maxCount = 1 },  -- difficulty level 4
		{ minCount = 1, maxCount = 1 },  -- difficulty level 5
		{ minCount = 1, maxCount = 2 },  -- difficulty level 6
		{ minCount = 1, maxCount = 2 },  -- difficulty level 7
		{ minCount = 1, maxCount = 3 },  -- difficulty level 8
		{ minCount = 2, maxCount = 3 },  -- difficulty level 9
	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/destroy_nest_mushbit_single.logic",   minDifficultyLevel = 3 },
		{ name = "logic/objectives/destroy_nest_mushbit_multiple.logic", minDifficultyLevel = 6 }
	}
	
	rules.waveRepeatChances = 
	{
		{},  -- concecutive chances of wave repeating at level 1
		{},  -- concecutive chances of wave repeating at level 2
		{},  -- concecutive chances of wave repeating at level 3
		{30},  -- concecutive chances of wave repeating at level 4
		{50},  -- concecutive chances of wave repeating at level 5
		{50, 20},  -- concecutive chances of wave repeating at level 6
		{70, 20},  -- concecutive chances of wave repeating at level 7
		{70, 30},  -- concecutive chances of wave repeating at level 8
		{80, 30, 50, 70, 70},  -- concecutive chances of wave repeating at level 9
	}
	
	rules.waves = {}
	rules.waves = helper:Default_Waves("desert", "scout", "default", rules.waves)
	
	rules.waves = helper:Generate({ groups = { "caverns" },   difficulty = {                9}, biomes = { "group" },   levels = { 1 },   ids = { 1, 2 },   suffixes = { "", "", "alpha" }, },   rules.waves)
	rules.waves = helper:Generate({ groups = { "caverns" },   difficulty = {                9}, biomes = { "group" },   levels = { 2 },   ids = { 1, 2 },   suffixes = { "", "" },          },   rules.waves)
	
    return rules;
end