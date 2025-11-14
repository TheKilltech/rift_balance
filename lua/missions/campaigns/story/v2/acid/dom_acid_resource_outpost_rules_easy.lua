return function(params)
    local rules  = require("lua/missions/campaigns/story/v2/acid/dom_acid_resource_outpost_rules_default.lua")(params)
	local helper = require("lua/missions/v2/waves_gen.lua" )
	
	rules.majorAttackLogic =
	{			
		{ level = 1, minLevel = 4, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}

    return rules;
end