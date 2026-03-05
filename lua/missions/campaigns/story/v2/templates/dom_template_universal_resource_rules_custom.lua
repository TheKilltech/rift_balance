require("lua/missions/v2/rules_gen.lua" )
require("lua/utils/rules_utils.lua")
require("lua/utils/table_utils.lua")

return function(params)
	local rulesName = GetRulesForCustomDifficulty( "lua/missions/campaigns/story/v2/templates/dom_template_universal_resource_rules_" )
	rules = require( rulesName )(params)
	rules = PrepareCustomRules( rules )
	
    return rules
end