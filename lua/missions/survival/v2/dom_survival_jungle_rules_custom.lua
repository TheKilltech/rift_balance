require("lua/missions/v2/rules_gen.lua" )

return function(params)
	local rulesName = GetRulesForCustomDifficulty( "lua/missions/survival/v2/dom_survival_jungle_rules_")
	rules = require( rulesName )(params)
	rules = PrepareCustomRules( rules )
	
    return rules
end