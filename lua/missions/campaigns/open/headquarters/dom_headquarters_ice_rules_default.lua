return function(params)
	-- the following sets up to default values for the given mission and difficulty type:
	-- prepareAttackDefinitions, wavesEntryDefinitions, prepareSpawnTime, timeToNextDifficultyLevel, cooldownAfterAttacks
	-- param missionType: { "outpost", "survival", "scout", "temp" }
	-- param difficulty:  { "easy", "default", "hard", "brutal" }
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	local rules  = helper:PrepareDefaultRules( {}, "hq", nil, params)

	rules.maxObjectivesAtOnce = 1
	rules.eventsPerIdleState = 2
	rules.eventsPerPrepareState = 1 -- [0,1]
	rules.eventsPerPrepareStateChance = 35
	rules.pauseAttacks = false
	rules.prepareAttacks = true
	rules.baseTimeBetweenObjectives = 2400
	rules.idleTimeRelativeVariation = 0.5         -- X factor of idle time that may randomly vary: +/- X * idle_time
	rules.idleTimeCancelChance = 10               -- chance in percent
	rules.preparationTimeRelativeVariation = 0.6  -- X factor of idle time that may randomly vary: +/- X * prep_time
	rules.preparationTimeCancelChance = 10        -- chance in percent
	
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
		{ action = "boss_attack",                    type = "NEGATIVE", gameStates="ATTACK|STREAMING",      minEventLevel = 4 },
		{ action = "shegret_attack",                 type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/event/shegret_attack.logic",                                   weight = 3 },
		{ action = "shegret_attack_hard",            type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/event/shegret_attack_hard.logic",                              weight = 3 },
		{ action = "kermon_attack",                  type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/event/kermon_attack.logic",                                    weight = 0.5 },
		{ action = "kermon_attack_hard",             type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 6,                    logicFile="logic/event/kermon_attack_hard.logic",                               weight = 0.5 },
		{ action = "phirian_attack",                 type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/event/phirian_attack.logic",                                   weight = 0.5 },
		{ action = "spawn_earthquake",               type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 2,                    logicFile="logic/weather/earthquake.logic",        minTime = 30, maxTime = 60,  weight = 0.5 },
		{ action = "spawn_blood_moon",               type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/weather/blood_moon.logic",        minTime = 60, maxTime = 120, weight = 2 },
		{ action = "spawn_blue_moon",                type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 4,                    logicFile="logic/weather/blue_moon.logic",         minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_solar_eclipse",            type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 5,                    logicFile="logic/weather/solar_eclipse.logic",     minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_super_moon",               type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/super_moon.logic",        minTime = 60, maxTime = 120, weight = 0.5 },
		{ action = "spawn_wind_weak",                type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/wind_weak.logic",         minTime = 60, maxTime = 120, weight = 1 },
		{ action = "spawn_wind_none",                type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/wind_none.logic",         minTime = 30, maxTime = 120, weight = 3 },
		{ action = "spawn_ion_storm",                type = "POSITIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/ion_storm.logic",         minTime = 30, maxTime = 60,  weight = 1 },
		{ action = "spawn_heavy_snow",               type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/heavy_snow.logic",        minTime = 60, maxTime = 120, weight = 1 },
		{ action = "spawn_blizzard",                 type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 1,                    logicFile="logic/weather/blizzard.logic",          minTime = 60, maxTime = 120, weight = 1 },
		{ action = "spawn_meteor_shower",            type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 4,                    logicFile="logic/weather/meteor_shower.logic",     minTime = 40, maxTime = 90,  weight = 0.5 },
		{ action = "spawn_ice_meteor_shower",        type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3,                    logicFile="logic/weather/ice_meteor_shower.logic", minTime = 30, maxTime = 60,  weight = 1 },
		{ action = "spawn_ice_rock_rain",            type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 4,                    logicFile="logic/weather/ice_rock_rain.logic",     minTime = 30, maxTime = 60,  weight = 1 },
		{ action = "spawn_ice_falling_rocks",        type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 5,                    logicFile="logic/weather/ice_falling_rocks.logic", minTime = 30, maxTime = 60,  weight = 1 },
		{ action = "spawn_comet_silent",             type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 1,                    logicFile="logic/weather/comet_silent.logic",                                   weight = 2 },
		{ action = "spawn_tornado_ice_near_player",  type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 3, maxEventLevel = 4, logicFile="logic/weather/tornado_ice_near_player.logic",                        weight = 1 },
		{ action = "spawn_tornado_ice_near_base",    type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 4,                    logicFile="logic/weather/tornado_ice_near_base.logic",                          weight = 1 },
		{ action = "spawn_resource_comet",           type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/weather/resource_comet.logic"  },
		{ action = "spawn_resource_earthquake",      type = "POSITIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/weather/resource_earthquake.logic" },
	}

	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 35, 20, 20 }

	rules.addResourcesOnRunOut = 
	{
		{ name = "carbon_vein",   runOutPercentageOnMap = 25, minToSpawn = 50000, maxToSpawn = 80000 },
		{ name = "iron_vein",     runOutPercentageOnMap = 25, minToSpawn = 50000, maxToSpawn = 80000 },
		{ name = "ammonium_vein", runOutPercentageOnMap = 30, minToSpawn = 20000, maxToSpawn = 30000, chance = 45,    events = { "spawn_resource_earthquake" }},
		{ name = "cobalt_vein",   runOutPercentageOnMap = 10, minToSpawn = 10000, maxToSpawn = 20000 },
	}

	rules.buildingsUpgradeStartsLogic = 
	{
		{ name = "headquarters_lvl_2", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_1_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_1_exit.logic" },   
		{ name = "headquarters_lvl_3", level = 1, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_2_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_2_exit.logic" },   
		{ name = "headquarters_lvl_4", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		{ name = "headquarters_lvl_5", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		{ name = "headquarters_lvl_6", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		{ name = "headquarters_lvl_7", level = 2, prepareTime = 120, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite_dynamic.logic",               minDifficultyLevel = 4 },
		{ name = "logic/objectives/destroy_nest_granan_ice_single.logic",   minDifficultyLevel = 3 },
		{ name = "logic/objectives/destroy_nest_granan_ice_multiple.logic", minDifficultyLevel = 6 },
	}

	--rules.waveRepeatChances        = helper:Default_WaveRepeatChances("hq", rules.params.difficulty)
	--rules.attackCountPerDifficulty = helper:Default_AttackCountPerDifficulty("hq", rules.params.difficulty)
	
	rules.waveChanceRerollSpawnGroup = 20
	rules.waveChanceRerollSpawn      = 30
	rules.waveChanceReroll           = 50
	
	rules.extraWaves       = helper:Default_ExtraWaves("ice", "hq", rules.params.difficulty, nil)
	rules.multiplayerWaves = helper:Default_MpWaves(   "ice", "hq", rules.params.difficulty, nil)
	rules.bosses           = helper:Default_Bosses(    "ice", "hq", rules.params.difficulty, nil)
	rules.waves = 
	{
		["default"]		= helper:Default_UnboxedWaves("ice",      "hq",      rules.params.difficulty, nil),
		["acid"]		= helper:Default_UnboxedWaves("acid",     "outpost", rules.params.difficulty, nil),
		["caverns"]		= helper:Default_UnboxedWaves("caverns",  "outpost", rules.params.difficulty, nil),
		["desert"]		= helper:Default_UnboxedWaves("desert",   "outpost", rules.params.difficulty, nil),
		["ice"]			= helper:Default_UnboxedWaves("ice",      "outpost", rules.params.difficulty, nil),
		["jungle"]		= helper:Default_UnboxedWaves("jungle",   "outpost", rules.params.difficulty, nil),
		["magma"]		= helper:Default_UnboxedWaves("magma",    "outpost", rules.params.difficulty, nil),
		["metallic"]	= helper:Default_UnboxedWaves("metallic", "outpost", rules.params.difficulty, nil),
		["swamp"]		= helper:Default_UnboxedWaves("swamp",    "outpost", rules.params.difficulty, nil),
	}
	
	return rules
end