require("lua/utils/rules_utils.lua")

return function()
	local helper    = require( "lua/missions/v2/waves_gen.lua" )
	local rulesName = GetRulesForCustomDifficulty( "lua/missions/campaigns/story/v2/desert/dom_desert_resource_outpost_rules_" )
	rules = require( rulesName )()
	
	rules = helper:PrepareCustomRules( rules, "outpost")
	
    return rules;
end