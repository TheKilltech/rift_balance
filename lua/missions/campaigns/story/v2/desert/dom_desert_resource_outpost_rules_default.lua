require("lua/missions/v2/rules_gen.lua" )

-- rules_gen is used to preset all requires rules fields with parametric default values based on the current biome, difficulty, mission type, threat level
-- all fields from the original rules files can be still overwritten here if needed for a specific map.
return function(params)
	-- param missionType: { "hq", "resource", "outpost", "survival", "scout", "exploration" }
	-- param difficulty:  { "easy", "normal", "hard", "brutal", "extreme" }
	local rules  = PrepareDefaultRules( {}, params, "exploration")

	rules.extraWaves       = Default_ExtraWaves( rules.params )
	rules.multiplayerWaves = Default_MpWaves(    rules.params )
	rules.bosses           = Default_Bosses(     rules.params )
	
	rules.waves = {
		["default"]		= Default_UnboxedWaves( rules.params ),
		["caverns"]		= ApplyDifficultyOffsetToWaves( Default_UnboxedWaves("caverns", "outpost", rules.params.difficulty, nil), 4)
	}
	
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
	
	return rules
end