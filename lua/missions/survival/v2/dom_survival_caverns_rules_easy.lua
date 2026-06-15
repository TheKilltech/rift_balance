return function()
    local rules = require("lua/missions/survival/v2/dom_survival_caverns_rules_default.lua")()

	rules.maxObjectivesAtOnce = 1

	rules.timeToNextDifficultyLevel = 
	{			
		300, -- difficulty level 1
		720, -- difficulty level 2
		720, -- difficulty level 3	
		720, -- difficulty level 4
		720, -- difficulty level 5
		720, -- difficulty level 6
		720, -- difficulty level 7
		720, -- difficulty level 8
		720, -- difficulty level 9
	}
	
	rules.prepareSpawnTime = 
	{			
		480,  -- difficulty level 1
		480,  -- difficulty level 2
		480,  -- difficulty level 3
		480,  -- difficulty level 4	
		480,  -- difficulty level 5	
		480,  -- difficulty level 6	
		480,  -- difficulty level 7
		480,  -- difficulty level 8	
		480,  -- difficulty level 9	
	}

	rules.maxAttackCountPerDifficulty = 
	{			
		1,  -- difficulty level 1
		1,  -- difficulty level 2
		1,  -- difficulty level 3		
		1,  -- difficulty level 4
		1,  -- difficulty level 5
		2,  -- difficulty level 6
		2,  -- difficulty level 7
		2,  -- difficulty level 8
		2,  -- difficulty level 9
	}
	
	rules.buildingsUpgradeStartsLogic = 
	{			
		--{ name = "headquarters_lvl_2", level = 1, prepareTime = 180, entryLogic = "logic/dom/hq_upgrade_level_1_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_1_exit.logic" },   
		--{ name = "headquarters_lvl_3", level = 1, prepareTime = 180, entryLogic = "logic/dom/hq_upgrade_level_2_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_2_exit.logic" },   
		--{ name = "headquarters_lvl_4", level = 1, prepareTime = 180, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		--{ name = "headquarters_lvl_5", level = 1, prepareTime = 180, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		--{ name = "headquarters_lvl_6", level = 1, prepareTime = 180, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
		--{ name = "headquarters_lvl_7", level = 1, prepareTime = 180, entryLogic = "logic/dom/hq_upgrade_level_3_entry.logic", exitLogic = "logic/dom/hq_upgrade_level_3_exit.logic" },   
	}	

    return rules;
end