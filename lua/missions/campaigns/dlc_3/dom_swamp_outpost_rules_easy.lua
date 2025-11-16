return function(params)
    local rules  = require("lua/missions/campaigns/dlc_3/dom_swamp_outpost_rules_default.lua")(params)
	local helper = require("lua/missions/v2/waves_gen.lua" )

    return rules;
end