require("lua/missions/v2/rules_gen.lua" )
	
-- rules_gen is used to preset all requires rules fields with parametric default values based on the current biome, difficulty, mission type, threat level
-- all fields from the original rules files can be still overwritten here if needed for a specific map.
return function(params)
	-- param missionType: { "hq", "resource", "outpost", "survival", "scout", "exploration" }
	-- param difficulty:  { "easy", "normal", "hard", "brutal", "extreme" }
	local rules  = PrepareDefaultRules( {}, params, "survival")

	rules.extraWaves       = Default_ExtraWaves( rules.params )
	rules.multiplayerWaves = Default_MpWaves(    rules.params )
	rules.bosses           = Default_Bosses(     rules.params )
	rules.waves            = Default_Waves(      rules.params )

	rules.gameEvents = Concat( rules.gameEvents,  {
		{ action = "spawn_tornado_fire_near_base",     type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 8,       logicFile="logic/weather/tornado_fire_near_base.logic",          weight = 0.5 },
		{ action = "spawn_tornado_acid_near_base",     type = "NEGATIVE", gameStates="ATTACK|IDLE",           minEventLevel = 8,       logicFile="logic/weather/tornado_acid_near_base.logic",          weight = 0.5 },
		{ action = "spawn_comet_boss_mudroner_acid",   type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,       logicFile="logic/event/comet_boss_mudroner_acid.logic"  },
		{ action = "spawn_comet_boss_mudroner_cryo",   type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,       logicFile="logic/event/comet_boss_mudroner_cryo.logic"  },
		{ action = "spawn_comet_boss_mudroner_energy", type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,       logicFile="logic/event/comet_boss_mudroner_energy.logic" },
		{ action = "spawn_comet_boss_mudroner_fire",   type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 4,       logicFile="logic/event/comet_boss_mudroner_fire.logic"  },
	})

	--LogService:Log( PrintTable ( rules ))
	
    return rules
end