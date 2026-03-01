require("lua/missions/v2/waves_gen.lua" )
require("lua/utils/rules_utils.lua")
	
return function(params)
	-- the following sets up to default values for the given mission and difficulty type:
	-- prepareAttackDefinitions, wavesEntryDefinitions, prepareSpawnTime, timeToNextDifficultyLevel, cooldownAfterAttacks
	-- param missionType: { "outpost", "survival", "scout", "temp" }
	-- param difficulty:  { "easy", "default", "hard", "brutal" }
	local rules  = PrepareDefaultRules( {}, nil, nil, params)

	
	rules.addResourcesOnRunOut = 
	{
		{ name = "uranium_ore_vein",     runOutPercentageOnMap =  5, minToSpawn =  2000, maxToSpawn =  5000, chance = 35 },
		{ name = "uranium_ore_deepvein", runOutPercentageOnMap = 30, minToSpawn = 20000, maxToSpawn = 90000,                                                events = { "spawn_resource_earthquake" }},
		{ name = "carbon_vein",          runOutPercentageOnMap =  5, minToSpawn =  2000, maxToSpawn =  5000, chance = 45 },
		{ name = "carbon_deepvein",      runOutPercentageOnMap = 30, minToSpawn = 20000, maxToSpawn = 90000, chance = 15,                                   events = { "spawn_resource_earthquake" }},
		{ name = "ammonium_vein",        runOutPercentageOnMap = 30, minToSpawn = 10000, maxToSpawn = 20000, chance = 45,                                   events = { "spawn_resource_earthquake" }},
		{ name = "ammonium_deepvein",    runOutPercentageOnMap = 30, minToSpawn = 20000, maxToSpawn = 90000, chance = 15,                                   events = { "spawn_resource_earthquake" }},
		{ name = "morphium_deepvein",    runOutPercentageOnMap = 10, isInfinite = 1,                         chance = 65, eventGroup = "morphium_unlocked", events = { "spawn_resource_comet" }, blueprint = "weather/alien_comet_flying"  },
	}

	rules.objectivesLogic = 
	{		
		{ name = "logic/objectives/kill_elite_dynamic.logic",            minDifficultyLevel = 3 },
		{ name = "logic/objectives/destroy_nest_mushbit_single.logic",   minDifficultyLevel = 3, maxDifficultyLevel = 8 },
		{ name = "logic/objectives/destroy_nest_mushbit_multiple.logic", minDifficultyLevel = 6 } 
	}
	
	rules.waveChanceRerollSpawnGroup = 10  -- chance for rerolled attack wave to change its map border spawn direction (N/W/S/E)
	rules.waveChanceRerollSpawn      = 20  -- chance for rerolled attack wave to change its spawning point
	rules.waveChanceReroll           = 30  -- chance to reroll and replace an attack wave from its original wave pool
	
	rules.extraWaves       = Default_ExtraWaves( params )
	rules.multiplayerWaves = Default_MpWaves(    params )
	rules.bosses           = Default_Bosses(     params )
	rules.waves            = Default_Waves(      params )

    return rules
end