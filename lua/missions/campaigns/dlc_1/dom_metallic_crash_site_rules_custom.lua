require("lua/missions/v2/rules_gen.lua" )

return function(params)
	local rulesName = GetRulesForCustomDifficulty( "lua/missions/campaigns/dlc_1/dom_metallic_crash_site_rules_" )
	rules = require( rulesName )(params)
	rules = PrepareCustomRules( rules )
	
    return rules
end