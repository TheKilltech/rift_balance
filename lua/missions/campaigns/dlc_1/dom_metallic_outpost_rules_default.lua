require("lua/missions/v2/rules_gen.lua" )

-- rules_gen is used to preset all requires rules fields with parametric default values based on the current biome, difficulty, mission type, threat level
-- all fields from the original rules files can be still overwritten here if needed for a specific map.
return function(params)
	-- param missionType: { "hq", "resource", "outpost", "survival", "scout", "exploration" }
	-- param difficulty:  { "easy", "normal", "hard", "brutal", "extreme" }
	local rules  = PrepareDefaultRules( {}, params, "outpost")

	rules.extraWaves       = Default_ExtraWaves( rules.params )
	rules.multiplayerWaves = Default_MpWaves(    rules.params )
	rules.bosses           = Default_Bosses(     rules.params )
	
	rules.waves = {
		["default"]		= Default_UnboxedWaves( rules.params ),
		["ice"]			= ApplyDifficultyOffsetToWaves( Default_UnboxedWaves("ice", "outpost", rules.params.difficulty, nil), 4)
	}
	
	rules.addResourcesOnRunOut = 
	{
		{ name = "cobalt_vein",        runOutPercentageOnMap = 10, minEventLevel = 5, minToSpawn =  3000, maxToSpawn =  5000, chance =  5 },
		{ name = "cobalt_vein",        runOutPercentageOnMap = 10, minEventLevel = 4, minToSpawn =  2000, maxToSpawn =  4000, chance = 75, events = { "spawn_resource_comet" }, },
		{ name = "cobalt_deepvein",    runOutPercentageOnMap = 10, minEventLevel = 7, minToSpawn = 30000, maxToSpawn = 80000,              events = { "spawn_resource_earthquake" }, },
		{ name = "iron_vein",          runOutPercentageOnMap = 30, minEventLevel = 4, minToSpawn =  3000, maxToSpawn =  5000, chance = 15 },
		{ name = "iron_deepvein",      runOutPercentageOnMap = 20, minEventLevel = 5, minToSpawn = 30000, maxToSpawn = 90000, chance = 15, events = { "spawn_resource_earthquake" }, },
		{ name = "titanium_deepvein",  runOutPercentageOnMap = 20, minEventLevel = 6, minToSpawn = 30000, maxToSpawn = 90000, chance = 25, events = { "spawn_resource_earthquake" }, eventGroup = "titanium_unlocked", },
		{ name = "titanium_deepvein",  runOutPercentageOnMap = 20, minEventLevel = 6, isInfinite = 1,                         chance =  5, events = { "spawn_resource_earthquake" }, eventGroup = "titanium_unlocked", },
	}
	
	return rules
end