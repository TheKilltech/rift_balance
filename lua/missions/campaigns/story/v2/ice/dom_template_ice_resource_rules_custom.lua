require("lua/missions/v2/rules_gen.lua" )

return function(params)
	local rulesName = GetRulesForCustomDifficulty( "lua/missions/campaigns/story/v2/ice/dom_template_ice_resource_rules_")
	rules = require( rulesName )(params)
	rules = PrepareCustomRules( rules )
	
    return rules
end