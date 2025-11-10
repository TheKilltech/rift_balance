return function()
	-- the following sets up to default values for the given mission and difficulty type:
	-- prepareAttackDefinitions, wavesEntryDefinitions, prepareSpawnTime, timeToNextDifficultyLevel, cooldownAfterAttacks
	-- param missionType: { "outpost", "survival", "scout", "temp" }
	-- param difficulty:  { "easy", "default", "hard", "brutal" }
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	local rules  = helper:PrepareDefaultRules( {}, "outpost", "default")

	rules.maxObjectivesAtOnce = 1
	rules.eventsPerIdleState = 2
	rules.eventsPerPrepareState = 0 -- [0,1]
	rules.eventsPerPrepareStateChance = 25        -- chance to spawn events with objectives
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 1800
	rules.idleTimeRelativeVariation = 0.6         -- X factor of idle time that may randomly vary: +/- X * idle_time
	rules.idleTimeCancelChance = 5                -- chance in percent, reduces idle time down to 120
	rules.preparationTimeRelativeVariation = 0.55 -- X factor of idle time that may randomly vary: +/- X * prep_time
	rules.preparationTimeCancelChance = 25        -- chance in percent

	rules.gameEvents = 
	{
		{ action = "new_objective",                  type = "POSITIVE", gameStates="IDLE|STREAMING",        minEventLevel = 3 }, -- new_objective is only an option in the streaming mode; do not try to pass it as NO_STREAMING
		{ action = "change_time_of_day",             type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 3 },
		{ action = "add_resource",                   type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, basePercentage = 30 },
		{ action = "remove_resource",                type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1, basePercentage = 20 },
		{ action = "cancel_the_attack",              type = "POSITIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 1 },
		{ action = "unlock_research",                type = "POSITIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 1 },
		{ action = "full_ammo",                      type = "POSITIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 2 },
		{ action = "remove_ammo",                    type = "NEGATIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 2 },
		{ action = "stronger_attack",                type = "NEGATIVE", gameStates="ATTACK",                minEventLevel = 1, amount = 2 },
		{ action = "shegret_attack",                 type = "NEGATIVE", gameStates="IDLE|ATTACK",           minEventLevel = 5, logicFile="logic/event/shegret_attack.logic",                                      weight = 0.5 },
		{ action = "shegret_attack_hard",            type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 5, logicFile="logic/event/shegret_attack_hard.logic",                                 weight = 0.25 },
		{ action = "shegret_attack_very_hard",       type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 6, logicFile="logic/event/shegret_attack_very_hard.logic",                            weight = 0.15 },
		{ action = "kermon_attack",                  type = "NEGATIVE", gameStates="IDLE|ATTACK",           minEventLevel = 8, logicFile="logic/event/kermon_attack.logic",                                       weight = 1 },
		{ action = "kermon_attack_hard",             type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 6, logicFile="logic/event/kermon_attack_hard.logic",                                  weight = 0.75 },
		{ action = "kermon_attack_very_hard",        type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 8, logicFile="logic/event/kermon_attack_very_hard.logic",                             weight = 0.5 },
		{ action = "phirian_attack",                 type = "NEGATIVE", gameStates="IDLE|ATTACK",           minEventLevel = 3, logicFile="logic/event/phirian_attack.logic",                                      weight = 0.3 },		
		{ action = "spawn_earthquake",               type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2, logicFile="logic/weather/earthquake.logic",          minTime = 60, maxTime = 60,   weight = 0.75 },
		{ action = "spawn_blood_moon",               type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4, logicFile="logic/weather/blood_moon.logic",          minTime = 60, maxTime = 120,  weight = 0.5,  weather = "SUN" },
		{ action = "spawn_blue_moon",                type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 4, logicFile="logic/weather/blue_moon.logic",           minTime = 60, maxTime = 120,  weight = 0.5,  weather = "SUN" },
		{ action = "spawn_solar_eclipse",            type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3, logicFile="logic/weather/solar_eclipse.logic",       minTime = 60, maxTime = 120,  weight = 0.25, weather = "SUN" },
		{ action = "spawn_super_moon",               type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3, logicFile="logic/weather/super_moon.logic",          minTime = 60, maxTime = 120,  weight = 0.25, weather = "SUN"  },
		{ action = "spawn_ion_storm",                type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3, logicFile="logic/weather/ion_storm.logic",           minTime = 30, maxTime = 60,   weight = 1,    weather = "SUN|WIND" },
		{ action = "spawn_meteor_shower",            type = "NEGATIVE", gameStates="ATTACK|IDLE|STREAMING", minEventLevel = 8, logicFile="logic/weather/meteor_shower.logic",       minTime = 30, maxTime = 60,   weight = 0.5  },
		{ action = "spawn_meteor_shower",            type = "NEGATIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 8, logicFile="logic/weather/meteor_shower.logic",       minTime = 30, maxTime = 60,   weight = 0.2  },	
		{ action = "spawn_comet_silent",             type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 2, logicFile="logic/weather/comet_silent.logic",                                      weight = 2 },
		{ action = "spawn_resource_earthquake",      type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 4, logicFile="logic/weather/resource_earthquake.logic",                               weight = 1 },
		{ action = "spawn_resource_comet",           type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 4, logicFile="logic/weather/resource_comet.logic",                                    weight = 1 },
		{ action = "spawn_volcanic_rock_rain",       type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1, logicFile="logic/weather/volcanic_rock_rain.logic",  minTime = 30, maxTime = 60,   weight = 0.5 },
		{ action = "spawn_volcanic_ash_clouds",      type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1, logicFile="logic/weather/volcanic_ash_clouds.logic", minTime = 60, maxTime = 120,  weight = 1.0 },	
		{ action = "spawn_tornado_fire_near_player", type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3, maxEventLevel = 4, logicFile="logic/weather/tornado_fire_near_player.logic",       weight = 0.5 },
		{ action = "spawn_tornado_fire_near_base",   type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4, logicFile="logic/weather/tornado_fire_near_base.logic",                            weight = 0.5 },
		{ action = "spawn_firestorm",                type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2, logicFile="logic/weather/firestorm.logic",           minTime = 60, maxTime = 120,  weight = 1 },
		{ action = "spawn_comet_silent",             type = "POSITIVE", gameStates="IDLE|NO_STREAMING",     minEventLevel = 1, logicFile="logic/weather/comet_silent.logic",                                      weight = 2 },
	}

	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 25, 50, 20 }

	rules.addResourcesOnRunOut = 
	{
		{ name = "titanium_vein",     runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn =  2000, maxToSpawn =  4000, chance = 75 },
		{ name = "titanium_deepvein", runOutPercentageOnMap = 30, minEventLevel = 7, minToSpawn = 30000, maxToSpawn = 80000,                                                events = { "spawn_resource_earthquake" }, },
		{ name = "cobalt_vein",       runOutPercentageOnMap = 10, minEventLevel = 5, minToSpawn =  3000, maxToSpawn =  5000, chance =  5 },
		{ name = "iron_vein",         runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn =  3000, maxToSpawn =  5000, chance = 15 },
		{ name = "iron_deepvein",     runOutPercentageOnMap = 20, minEventLevel = 5, minToSpawn = 30000, maxToSpawn = 90000, chance = 15,                                   events = { "spawn_resource_earthquake" }, },
		{ name = "morphium_deepvein", runOutPercentageOnMap = 10, minEventLevel = 8, isInfinite = 1,                         chance = 25, eventGroup = "morphium_unlocked", events = { "spawn_resource_comet" },   blueprint = "weather/alien_comet_flying"  },
	}

	rules.majorAttackLogic =
	{			
		{ level = 2, minLevel = 5, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },
	}

	rules.buildingsUpgradeStartsLogic = {	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite_dynamic.logic",            minDifficultyLevel = 3 },
		{ name = "logic/objectives/destroy_nest_morirot_single.logic",   minDifficultyLevel = 3, maxDifficultyLevel = 6 }, 
		{ name = "logic/objectives/destroy_nest_morirot_multiple.logic", minDifficultyLevel = 6 }
	}

	rules.attackCountPerDifficulty = 
	{			
		{ minCount = 1, maxCount = 1 },  -- difficulty level 1
		{ minCount = 1, maxCount = 1 },  -- difficulty level 2
		{ minCount = 1, maxCount = 2 },  -- difficulty level 3
		{ minCount = 1, maxCount = 2 },  -- difficulty level 4
		{ minCount = 1, maxCount = 2 },  -- difficulty level 5
		{ minCount = 1, maxCount = 3 },  -- difficulty level 6
		{ minCount = 2, maxCount = 3 },  -- difficulty level 7
		{ minCount = 2, maxCount = 3 },  -- difficulty level 8
		{ minCount = 2, maxCount = 4 },  -- difficulty level 9
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
	
	rules.waveChanceRerollSpawnGroup = 10
	rules.waveChanceRerollSpawn      = 15
	rules.waveChanceReroll           = 40
	
	rules.waves            = helper:Default_Waves(     "magma", "outpost", "default", nil)
	rules.extraWaves       = helper:Default_ExtraWaves("magma", "outpost", "default", nil)
	rules.multiplayerWaves = helper:Default_MpWaves(   "magma", "outpost", "default", nil)
	rules.bosses           = {} -- bosses via mp waves
		
	rules.waves = helper:Generate({ groups = { "metallic" },   difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 2 },   suffixes = { "ultra" },      repeatInterval = 1,   weightDyn = 1.0, },   rules.waves)
	rules.waves = helper:Generate({ groups = { "metallic" },   difficulty = {          4, 5, 6, 7, 8, 9}, biomes = { "group" }, levels = { 3 },   suffixes = { "", "" },       repeatInterval = 1,   weightDyn = 1.0, },   rules.waves)
	rules.waves = helper:Generate({ groups = { "metallic" },   difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 3 },   suffixes = { "alpha" },      repeatInterval = 1,   weightDyn = 1.0, },   rules.waves)
	rules.waves = helper:Generate({ groups = { "metallic" },   difficulty = {                6, 7, 8, 9}, biomes = { "group" }, levels = { 4 },   suffixes = { "" },           repeatInterval = 1.5, weightDyn = 1.0, },   rules.waves)
	rules.waves = helper:Generate({ groups = { "metallic" },   difficulty = {                   7, 8, 9}, biomes = { "group" }, levels = { 4 },   suffixes = { "", "alpha" },  repeatInterval = 1.5, weightDyn = 1.0, },   rules.waves)
		
    return rules;
end