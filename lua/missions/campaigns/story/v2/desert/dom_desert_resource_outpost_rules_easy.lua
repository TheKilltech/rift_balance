return function(params)
    local rules = require("lua/missions/campaigns/story/v2/desert/dom_desert_resource_outpost_rules_default.lua")(params)
	
	rules.majorAttackLogic =
	{			
		{ level = 1, minLevel = 4, prepareTime = 300, entryLogic = "logic/dom/major_attack_1_entry.logic", exitLogic = "logic/dom/major_attack_1_exit.logic" },     
	}

    return rules;
end