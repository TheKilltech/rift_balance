require("lua/missions/v2/rules_gen.lua" )

return function(params)
	local rulesName = GetRulesForCustomDifficulty( "lua/missions/campaigns/dlc_3/dom_swamp_outpost_rules_" )
	rules = require( rulesName )(params)
	rules = PrepareCustomRules( rules )
	
    return rules
end