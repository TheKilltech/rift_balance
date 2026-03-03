require("lua/missions/v2/rules_gen.lua" )

-- rules_gen is used to preset all requires rules fields with parametric default values based on the current biome, difficulty, mission type, threat level
-- all fields from the original rules files can be still overwritten here if needed for a specific map.
return function(params)
	-- param missionType: { "hq", "resource", "outpost", "survival", "scout", "exploration" }
	-- param difficulty:  { "easy", "normal", "hard", "brutal", "extreme" }
	local rules  = PrepareDefaultRules( {}, params, "hq")

	-- events spawn chance during/after attack (cooldown state). event timing is random ranging from the start of attack to max cooldown time.
	-- chances are consecutive, i.e. dice roll for event n+1 may only happen if roll for event n was also succefful
	rules.spawnCooldownEventChance = { 25, 50, 20 }
	
	rules.addResourcesOnRunOut = {
		{ name = "carbon_vein",       runOutPercentageOnMap = 25, minToSpawn = 50000, maxToSpawn = 80000 },
		{ name = "iron_vein",         runOutPercentageOnMap = 25, minToSpawn = 50000, maxToSpawn = 80000 },
		{ name = "ammonium_vein",     runOutPercentageOnMap = 30, minToSpawn = 20000, maxToSpawn = 30000, chance = 45,    events = { "spawn_resource_earthquake" }},
		{ name = "ammonium_deepvein", runOutPercentageOnMap = 30, minToSpawn = 20000, maxToSpawn = 90000, chance = 15,    events = { "spawn_resource_earthquake" }},
		{ name = "cobalt_vein",       runOutPercentageOnMap = 15, minToSpawn = 10000, maxToSpawn = 20000 },
	}
	
	rules.extraWaves       = Default_ExtraWaves( rules.params )
	rules.multiplayerWaves = Default_MpWaves(    rules.params )
	rules.bosses           = Default_Bosses(     rules.params )
	
	rules.waves = {
		["default"]		= Default_UnboxedWaves( rules.params ),
		["acid"]		= Default_UnboxedWaves( "acid",      "outpost", rules.params.difficulty),
		["caverns"]		= Default_UnboxedWaves( "caverns",   "outpost", rules.params.difficulty),
		--["desert"]		= Default_UnboxedWaves( "desert",    "outpost", rules.params.difficulty),
		["ice"]			= Default_UnboxedWaves( "ice",       "outpost", rules.params.difficulty),
		["jungle"]		= Default_UnboxedWaves( "jungle",    "outpost", rules.params.difficulty),
		["magma"]		= Default_UnboxedWaves( "magma",     "outpost", rules.params.difficulty),
		["metallic"]	= Default_UnboxedWaves( "metallic",  "outpost", rules.params.difficulty),
		["swamp"]		= Default_UnboxedWaves( "swamp",     "outpost", rules.params.difficulty),
	}

	--LogService:Log( PrintTable(rules))
	
	return rules
end
