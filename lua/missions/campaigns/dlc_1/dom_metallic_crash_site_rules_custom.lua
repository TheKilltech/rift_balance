require("lua/utils/rules_utils.lua")

return function()
	local helper    = require( "lua/missions/v2/waves_gen.lua" )
	local rulesName = GetRulesForCustomDifficulty( "lua/missions/campaigns/dlc_1/dom_metallic_crash_site_rules_" )
	rules = require( rulesName )()
	
	rules = helper:PrepareCustomRules( rules, "scout")
	
    return rules;
end