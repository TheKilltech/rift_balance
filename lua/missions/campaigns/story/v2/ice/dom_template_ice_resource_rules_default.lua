return function(params)
	-- the following sets up to default values for the given mission and difficulty type:
	-- prepareAttackDefinitions, wavesEntryDefinitions, prepareSpawnTime, timeToNextDifficultyLevel, cooldownAfterAttacks
	-- param missionType: { "outpost", "survival", "scout", "temp" }
	-- param difficulty:  { "easy", "default", "hard", "brutal" }
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	local rules  = helper:PrepareDefaultRules( {}, nil, nil, params)

	rules.addResourcesOnRunOut = 
	{
		{ name = "palladium_vein",     runOutPercentageOnMap = 30, minToSpawn = 3000,  maxToSpawn = 5000, chance = 50 },
		{ name = "palladium_deepvein", runOutPercentageOnMap = 30, minToSpawn = 40000, maxToSpawn = 80000,                                               events = { "spawn_resource_earthquake" } },
		{ name = "titanium_vein",      runOutPercentageOnMap =  5, minToSpawn = 1000,  maxToSpawn = 2000, chance = 5,  eventGroup = "titanium_completed"  },
		{ name = "morphium_deepvein",  runOutPercentageOnMap = 10, isInfinite = 1,                        chance = 25, eventGroup = "morphium_unlocked", events = { "spawn_resource_comet" },      blueprint = "weather/alien_comet_flying"  },
	}

	rules.objectivesLogic = 
	{
		{ name = "logic/objectives/kill_elite_dynamic.logic",               minDifficultyLevel = 4 },
		{ name = "logic/objectives/destroy_nest_granan_ice_single.logic",   minDifficultyLevel = 3, maxDifficultyLevel = 8 },
		{ name = "logic/objectives/destroy_nest_granan_ice_multiple.logic", minDifficultyLevel = 6 },
	}
	
	rules.waveChanceRerollSpawnGroup = 10  -- chance for rerolled attack wave to change its map border spawn direction (N/W/S/E)
	rules.waveChanceRerollSpawn      = 20  -- chance for rerolled attack wave to change its spawning point
	rules.waveChanceReroll           = 30  -- chance to reroll and replace an attack wave from its original wave pool
	
	rules.extraWaves       = helper:Default_ExtraWaves( params )
	rules.multiplayerWaves = helper:Default_MpWaves(    params )
	rules.bosses           = helper:Default_Bosses(     params )
	rules.waves            = helper:Default_Waves(      params )

    return rules
end