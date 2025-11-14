return function(params)
    local rules  = require("lua/missions/campaigns/story/v2/headquarters/dom_headquarters_rules_default.lua")(params)
	local helper = require("lua/missions/v2/waves_gen.lua" )

    return rules;
end