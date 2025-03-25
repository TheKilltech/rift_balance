require("lua/utils/rules_utils.lua")

return function()
	
	local helper    = require( "lua/missions/v2/waves_gen.lua" )
	local rulesName = GetRulesForCustomDifficulty( "lua/missions/campaigns/story/v2/acid/dom_acid_find_rare_resource_rules_" )
	rules = require( rulesName )()
	
	rules = helper:PrepareCustomRules( rules, "scout")
	
    return rules;
end

