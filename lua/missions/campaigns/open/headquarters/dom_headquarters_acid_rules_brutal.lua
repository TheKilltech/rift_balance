require("lua/utils/rules_utils.lua")

return function(params)
    local rules  = require( "lua/missions/campaigns/open/headquarters/dom_headquarters_acid_rules_default.lua")(params)
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	
	Concat( rules.gameEvents, {
		--{ action = "shegret_attack_very_hard",       type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 3,                    logicFile="logic/event/shegret_attack_very_hard.logic",                     weight = 3 },		
		{ action = "kermon_attack_very_hard",        type = "NEGATIVE", gameStates="IDLE",                  minEventLevel = 7,                    logicFile="logic/event/kermon_attack_very_hard.logic",                      weight = 0.5 },
	})
	
    return rules;
end