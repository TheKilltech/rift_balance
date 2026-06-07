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
		["caverns"]		= ApplyDifficultyOffsetToWaves( Default_UnboxedWaves("caverns", "outpost", rules.params.difficulty, nil), 6)
	}

	rules.addResourcesOnRunOut = 
	{
		{ name = "cobalt_vein",        runOutPercentageOnMap =  5, minToSpawn = 1000, maxToSpawn = 2000, chance = 10,                                   events = { "spawn_resource_comet" } },
		{ name = "uranium_ore_vein",   runOutPercentageOnMap =  5, minToSpawn = 1000, maxToSpawn = 2000, chance =  5, eventGroup = "uranium_completed"  },
		{ name = "morphium_deepvein",  runOutPercentageOnMap = 10, isInfinite = 1,                       chance = 25, eventGroup = "morphium_unlocked", events = { "spawn_resource_comet" }, blueprint = "weather/alien_comet_flying"  },
		--{ name = "petroleum_deepvein",   runOutPercentageOnMap = 10,  isInfinite = 1,                                                           events = { "spawn_resource_earthquake" } },
		--{ name = "uranium_ore_deepvein", runOutPercentageOnMap = 10, minToSpawn = 40000, maxToSpawn = 50000, eventGroup = "uranium_completed",  events = { "spawn_resource_earthquake" } },
	}
	
    return rules
end