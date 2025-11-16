require("lua/utils/rules_utils.lua")

return function(params)
	local helper    = require( "lua/missions/v2/waves_gen.lua" )
	local rulesName = GetRulesForCustomDifficulty( "lua/missions/campaigns/dlc_1/dom_metallic_outpost_rules_" )
	rules = require( rulesName )(params)
	
	rules = helper:PrepareCustomRules( rules, "outpost")
	
    return rules;
end