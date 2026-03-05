require("lua/missions/v2/rules_gen.lua" )

-- rules_gen is used to preset all requires rules fields with parametric default values based on the current biome, difficulty, mission type, threat level
-- all fields from the original rules files can be still overwritten here if needed for a specific map.
return function(params)
	-- param missionType: { "hq", "resource", "outpost", "survival", "scout", "exploration" }
	-- param difficulty:  { "easy", "normal", "hard", "brutal", "extreme" }
	local rules  = PrepareDefaultRules( {}, params, "hq")

	rules.extraWaves       = Default_ExtraWaves( rules.params )
	rules.multiplayerWaves = Default_MpWaves(    rules.params )
	rules.bosses           = Default_Bosses(     rules.params )
	
	rules.waves = {
		["default"]		= Default_UnboxedWaves( rules.params ),
		["acid"]		= Default_UnboxedWaves( "acid",      "outpost", rules.params.difficulty),
		["caverns"]		= Default_UnboxedWaves( "caverns",   "outpost", rules.params.difficulty),
		["desert"]		= Default_UnboxedWaves( "desert",    "outpost", rules.params.difficulty),
		["ice"]			= Default_UnboxedWaves( "ice",       "outpost", rules.params.difficulty),
		["jungle"]		= Default_UnboxedWaves( "jungle",    "outpost", rules.params.difficulty),
		["magma"]		= Default_UnboxedWaves( "magma",     "outpost", rules.params.difficulty),
		["metallic"]	= Default_UnboxedWaves( "metallic",  "outpost", rules.params.difficulty),
		--["swamp"]		= Default_UnboxedWaves( "swamp",     "outpost", rules.params.difficulty),
	}

	--LogService:Log( PrintTable(rules))
	
	return rules
end