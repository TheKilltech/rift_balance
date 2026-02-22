require("lua/utils/rules_utils.lua")

return function(params)
    local rules  = require( "lua/missions/campaigns/open/headquarters/dom_headquarters_ice_rules_default.lua")(params)
	local helper = require( "lua/missions/v2/waves_gen.lua" )
	
	return rules
end