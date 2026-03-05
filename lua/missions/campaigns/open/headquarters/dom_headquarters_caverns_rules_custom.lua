require("lua/missions/v2/rules_gen.lua" )

return function(params)
	local rulesName = GetRulesForCustomDifficulty( "lua/missions/campaigns/open/headquarters/dom_headquarters_caverns_rules_")
	rules = require( rulesName )(params)
	rules = PrepareCustomRules( rules )
	
    return rules
end
