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
	rules.eventsPerPrepareStateChance = 10        -- chance to spawn events with objectives
	rules.pauseAttacks = false
	rules.prepareAttacks = false
	rules.baseTimeBetweenObjectives = 2400
	rules.idleTimeRelativeVariation = 0.6         -- X factor of idle time that may randomly vary: +/- X * idle_time
	rules.idleTimeCancelChance = 15               -- chance in percent, reduces idle time down to 120
	rules.preparationTimeRelativeVariation = 0.35 -- X factor of idle time that may randomly vary: +/- X * prep_time
	rules.preparationTimeCancelChance = 5         -- chance in percent

	rules.gameEvents = 
	{
		{ action = "spawn_earthquake",               type = "NEGATIVE", gameStates="ATTACK|IDLE",       minEventLevel = 1, logicFile="logic/weather/earthquake.logic",          minTime = 60, maxTime = 60 },
		{ action = "spawn_blood_moon",               type = "NEGATIVE", gameStates="IDLE",              minEventLevel = 3, logicFile="logic/weather/blood_moon.logic",          minTime = 60, maxTime = 120, weight = 0.5,  weather = "SUN" },
		{ action = "spawn_blue_moon",                type = "POSITIVE", gameStates="IDLE",              minEventLevel = 3, logicFile="logic/weather/blue_moon.logic",           minTime = 60, maxTime = 120, weight = 0.5,  weather = "SUN" },
		{ action = "spawn_solar_eclipse",            type = "NEGATIVE", gameStates="ATTACK|IDLE",       minEventLevel = 4, logicFile="logic/weather/solar_eclipse.logic",       minTime = 60, maxTime = 120, weight = 0.25, weather = "SUN" },
		{ action = "spawn_super_moon",               type = "POSITIVE", gameStates="ATTACK|IDLE",       minEventLevel = 4, logicFile="logic/weather/super_moon.logic",          minTime = 60, maxTime = 120, weight = 0.25, weather = "SUN" },
		{ action = "spawn_ion_storm",                type = "POSITIVE", gameStates="ATTACK|IDLE",       minEventLevel = 3, logicFile="logic/weather/ion_storm.logic",           minTime = 60, maxTime = 120, weight = 1.5,  weather = "WIND" },
		{ action = "spawn_volcanic_rock_rain",       type = "NEGATIVE", gameStates="ATTACK|IDLE",       minEventLevel = 1, logicFile="logic/weather/volcanic_rock_rain.logic",  minTime = 40, maxTime = 90,  weight = 0.75, weather = "SUN|WIND" },
		{ action = "spawn_volcanic_ash_clouds",      type = "NEGATIVE", gameStates="ATTACK|IDLE",       minEventLevel = 1, logicFile="logic/weather/volcanic_ash_clouds.logic", minTime = 60, maxTime = 120, weight = 1,    weather = "WIND" },
		{ action = "spawn_dust_storm",               type = "NEGATIVE", gameStates="ATTACK|IDLE",       minEventLevel = 2, logicFile="logic/weather/dust_storm.logic",          minTime = 60, maxTime = 120, weight = 2,    weather = "WIND" },
		{ action = "spawn_comet_silent",             type = "POSITIVE", gameStates="IDLE|NO_STREAMING", minEventLevel = 1, logicFile="logic/weather/comet_silent.logic",                                     weight = 2 },
		{ action = "spawn_wind_none",                type = "NEGATIVE", gameStates="ATTACK|IDLE",       minEventLevel = 2, logicFile="logic/weather/wind_none.logic",           minTime = 60, maxTime = 120, weight = 0.8,  weather = "WIND" },
		{ action = "spawn_firestorm",                type = "NEGATIVE", gameStates="ATTACK|IDLE",       minEventLevel = 2, logicFile="logic/weather/firestorm.logic",           minTime = 60, maxTime = 120,                weather = "WIND" },
		{ action = "spawn_tornado_fire_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE",       minEventLevel = 5, logicFile="logic/weather/tornado_fire_near_player.logic",  weight = 0.5  },
		{ action = "spawn_resource_earthquake",      type = "POSITIVE", gameStates="IDLE",              minEventLevel = 4, logicFile="logic/weather/resource_earthquake.logic",                                    weight = 0.5 },
		{ action = "spawn_resource_comet",           type = "POSITIVE", gameStates="IDLE",              minEventLevel = 4, logicFile="logic/weather/resource_comet.logic",                                         weight = 0.25 }
		--{ action = "spawn_comet_silent", type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, logicFile="logic/weather/comet_silent.logic", weight = 3 },
	}
	
	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 30, 10 }
	

	rules.addResourcesOnRunOut = 
	{
		{ name = "cobalt_vein",            runOutPercentageOnMap =  5,  minToSpawn =  2000, maxToSpawn =  4000,  chance =  5, },
		{ name = "iron_vein",              runOutPercentageOnMap = 35,  minToSpawn =  2000, maxToSpawn =  4000,  chance = 20  },
		{ name = "iron_deepvein",          runOutPercentageOnMap = 35,  minToSpawn = 20000, maxToSpawn = 70000,  chance = 10,                                    events = { "spawn_resource_earthquake" } },
		{ name = "titanium_vein",          runOutPercentageOnMap =  5,  minToSpawn =  2000, maxToSpawn =  4000,  chance = 15, eventGroup = "titanium_completed"  },
		{ name = "titanium_deepveinvein",  runOutPercentageOnMap =  5,  minToSpawn = 20000, maxToSpawn = 60000,  chance =  2, eventGroup = "titanium_completed", events = { "spawn_resource_earthquake" } },
		{ name = "morphium_deepvein",      runOutPercentageOnMap = 10,  isInfinite = 1,                          chance = 65, eventGroup = "morphium_unlocked",  events = { "spawn_resource_comet" }, blueprint = "weather/alien_comet_flying" },
	}

	rules.buildingsUpgradeStartsLogic = {	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/destroy_nest_morirot_single.logic",   minDifficultyLevel = 3 }, 
		{ name = "logic/objectives/destroy_nest_morirot_multiple.logic", minDifficultyLevel = 6 }
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
	
	rules.waveRepeatChances = 
	{
		{},  -- concecutive chances of wave repeating at level 1
		{},  -- concecutive chances of wave repeating at level 2
		{},  -- concecutive chances of wave repeating at level 3
		{20},  -- concecutive chances of wave repeating at level 4
		{40},  -- concecutive chances of wave repeating at level 5
		{50},  -- concecutive chances of wave repeating at level 6
		{60},  -- concecutive chances of wave repeating at level 7
		{70, 50, 10},  -- concecutive chances of wave repeating at level 8
		{80, 50, 20, 80, 70},  -- concecutive chances of wave repeating at level 9
	}
	
	rules.waves = {}
	rules.waves = helper:Default_Waves("magma", "scout", "default", rules.waves)
	
	rules.bosses = 
	{
		{}, -- difficulty level 1
		{}, -- difficulty level 2
		{}, -- difficulty level 3
		{}, -- difficulty level 4
		{}, -- difficulty level 5	
		{}, -- difficulty level 6
		{}, -- difficulty level 7	
		{}, -- difficulty level 8
		
		{  -- difficulty level 9
			"logic/missions/survival/attack_boss_magmoth.logic",
			"logic/missions/survival/attack_boss_gnerot.logic",
			"logic/missions/survival/attack_boss_krocoon.logic",
		},
	}

    return rules;
end