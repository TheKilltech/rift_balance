require("lua/utils/table_utils.lua")
require("lua/utils/rules_utils.lua")

local mission_generator = require("lua/missions/mission_generator.lua")
class 'template_universal' ( mission_generator )

function template_universal:__init()
    mission_generator.__init(self,self)
	self:Prepare()
end

function template_universal:Prepare()
	
	self.missionAdvancedResource = 
	{
		acid = "palladium_vein",
		caverns = "cobalt_vein",
		desert = "uranium_ore_vein",
		jungle = "cobalt_vein",
		magma = "titanium_vein",
		metallic = "titanium_vein",
		swamp = "palladium_vein"
	}
	self.missionRareResource = 
	{
		acid = "rhodonite",
		caverns = "ferdonite",
		desert = "tanzanite",
		jungle = "hazenite",
		magma = "ferdonite",
		metallic = "rhodonite",
		swamp = "tanzanite"
	}
	self.missionLiquidResource = 
	{
		acid = "sludge_vein",
		caverns = "",
		desert = "",
		jungle = "sludge_vein",
		magma = "magma_vein",
		metallic = "morphium_vein",
		swamp = "resin"
	}
	
	self.missionBiocacheName =
	{
		acid = "spawners/loot_container_small_acid",
		caverns = "spawners/loot_container_small_caverns",
		desert = "spawners/loot_container_small_desert",
		jungle = "spawners/loot_container_small_bulb",
		magma = "spawners/loot_container_small_pile",
		metallic = "spawners/loot_container_small_metallic",
		swamp = "spawners/loot_container_small_swamp"
	}
	
	self.possibleTerrainTypes =
	{
		acid = { "open", "dense", "lakes" },
		caverns = { "open", "dense" },
		desert = { "open", "dense" },
		jungle = { "open", "dense", "lakes" },
		magma = { "open", "dense", "lakes" },
		metallic = { "open", "dense", "lakes" },
		swamp = { "open", "dense", "lakes" },
	}
end

function template_universal:PrepareMissionGeneratorParams( params )	
	--local mission_params = 
	--{
	--	--biome_name = self.missionBiome,
	--	biome_name = "desert",
	--	mission_type = self.missionType,
	--	terrain_type = nil,
	--	mission_size = nil,
	--	threat_level = nil,
	--	bioanomalies = nil,
	--	underground_deposits = nil,
	--}

	local missionTerrainTypeEnum =  self.possibleTerrainTypes[params.biome_name]
	params.terrain_type = missionTerrainTypeEnum[RandInt( 1, #missionTerrainTypeEnum )]	
	--params.terrain_type = "lakes"
	params.mission_size = RandInt( 1, 10 )

	local mapSizeXMin = 4
	local mapSizeXMax = 16
	local mapSizeYMin = 4
	local mapSizeYMax = 16
	local mapSizeCondition = false		
	
	local mission_dimentions = 
	{		
		[1] 	= { 25, 30},
		[2] 	= { 30, 35},
		[3] 	= { 35, 40},
		[4] 	= { 40, 44},
		[5] 	= { 44, 48},
		[6] 	= { 48, 52},
		[7] 	= { 52, 56},
		[8] 	= { 56, 60},
		[9] 	= { 60, 62},
		[10] 	= { 62, 64}
	}	
	
	local mapSizeMin = mission_dimentions[params.mission_size][1] or 25
	local mapSizeMax = mission_dimentions[params.mission_size][2] or 64			
	
	local mapSizeX = mapSizeXMin
	local mapSizeY = mapSizeYMin

	while  mapSizeCondition == false do
		mapSizeX = RandInt( mapSizeXMin, mapSizeXMax )
		mapSizeY = RandInt( mapSizeYMin, mapSizeYMax )
		if ( mapSizeX * mapSizeY ) <= mapSizeMax then 
			if ( mapSizeX * mapSizeY ) >= mapSizeMin then
				mapSizeCondition = true
			else
				mapSizeCondition = false
			end
		end		
	end	
	params:SetMissionDimension( mapSizeX, mapSizeY)

	local advanceResource =self.missionAdvancedResource[params.biome_name];
	local rareResource =  self.missionRareResource[params.biome_name];
	local liquidResource = self.missionLiquidResource[params.biome_name];

	if params.mission_type == "exploration" then
		params.threat_level = RandInt( 5, 10 )
		params.bioanomalies = RandInt( 5, 10 )
		params.underground_deposits = RandInt( 5, 10 )
		
		params:SetResourceAmount("carbon_vein",  RandInt( 0, 3 ))
		params:SetResourceAmount("iron_vein", RandInt( 0, 3 ) )
		params:SetResourceAmount(advanceResource, RandInt( 0, 3 ) )
		--params:SetResourceAmount(self.missionRareResource[params.biome_name], RandInt( 5, 10 ) )
		params:SetResourceAmount(rareResource, 10 )
		params:SetResourceAmount("geothermal_vent", RandInt( 0, 10 ) )
		params:SetResourceAmount("flammable_gas_vent", RandInt( 0, 10 ) )
		if ( liquidResource ~= "" ) then
			params:SetResourceAmount(liquidResource, RandInt( 0, 10 ) )
		end
		params.resources_wind_tunnel = RandInt( 0, 10 )
	else
		params.threat_level = RandInt( 1, 7 )
		params.bioanomalies = RandInt( 0, 5 )
		params.underground_deposits = RandInt( 0, 7 )
		
		params:SetResourceAmount("carbon_vein", RandInt( 3, 10 ) )
		params:SetResourceAmount("iron_vein",  RandInt( 3, 10 ) )
		params:SetResourceAmount(advanceResource, RandInt( 3, 10 ) )

		--params:SetResourceAmount(self.missionRareResource[params.biome_name], RandInt( 0, 5 ) )
		params:SetResourceAmount(rareResource, 10 )
		params:SetResourceAmount("geothermal_vent", RandInt( 3, 10 ) )
		params:SetResourceAmount("flammable_gas_vent", RandInt( 3, 10 ) )
		if ( liquidResource ~= "" ) then
			params:SetResourceAmount( liquidResource, RandInt( 3, 10 ) )
		end
		params.resources_wind_tunnel =  RandInt( 3, 10 )
	end	 
	
end

function template_universal:PrepareMapGenerator(params)
    --MapGenerator:SetGeneratorSeed( 9001 )
	self.mission_params = params

	if self.mission_params.biome_name == "" then
		self.mission_params.biome_name = "jungle"

		self.mission_params.mission_type = self.data:GetStringOrDefault("mission_type", "exploration")
		self:PrepareMissionGeneratorParams(self.mission_params)
	end

	local resource_multipliers = 
	{
		[0] 	= 0.01,
		[1] 	= 0.15,
		[2] 	= 0.25,
		[3] 	= 0.5,
		[4] 	= 0.75,
		[5] 	= 1.00,
		[6] 	= 1.25,
		[7] 	= 1.50,
		[8] 	= 1.75,
		[9] 	= 2.00,
		[10] 	= 2.50
	}

	self.missionAdvancedResourceMultiplier = resource_multipliers[self.mission_params:GetResourceAmount(self.missionAdvancedResource[self.mission_params.biome_name])] or 1	
	self.missionRareResourceMultiplier = resource_multipliers[self.mission_params:GetResourceAmount(self.missionRareResource[self.mission_params.biome_name])] or 1
	self.missionWindTunnelMultiplier = resource_multipliers[self.mission_params.resources_wind_tunnel] or 1


	MapGenerator:SetMapSize( params.mission_dimmension.x, params.mission_dimmension.y )
	--MapGenerator:SetMapSize( 8, 8 )
	MapGenerator:SetBiome( self.mission_params.biome_name )	
	if self.mission_params.biome_name == "metallic" and self.mission_params.terrain_type == "liquid" then
		MapGenerator:SetNavigationCullingEnabled( false )
	elseif self.mission_params.biome_name == "caverns" then
		MapGenerator:SetPlayerDetectorEnabled( false )
	elseif self.mission_params.biome_name == "swamp" and self.mission_params.terrain_type == "liquid" then
		MapGenerator:SetNavigationCullingEnabled( false )
	end
end

function template_universal:PrepareMissionTilesPool()
	LogService:Log("MapSizeX = ".. tostring(self.mapSizeX) .. " MapSizeY = " .. tostring(self.mapSizeY))
	LogService:Log("MapSizeCondition = ".. tostring(self.mapSizeCondition))
	LogService:Log("MissionArea = ".. tostring(self.mission_params.mission_size) )
	LogService:Log("MissionTerrainType = ".. self.mission_params.terrain_type )
	LogService:Log("MissionType = ".. self.mission_params.mission_type )	
	LogService:Log("MissionThreatLevel = ".. tostring(self.mission_params.threat_level) )	
	LogService:Log("MissionBioanomalies = ".. tostring(self.mission_params.bioanomalies) )	
	LogService:Log("MissionUndergroundDeposits = ".. tostring(self.mission_params.underground_deposits ))	
	LogService:Log("MissionResources carbon_vein = ".. tostring(self.mission_params:GetResourceAmount("carbon_vein")) )	
	LogService:Log("MissionResources iron_vein = ".. tostring(self.mission_params:GetResourceAmount("iron_vein")) )	
	LogService:Log("MissionResources advanced_resource : " .. self.missionAdvancedResource[self.mission_params.biome_name]  .. " = "  .. tostring(self.mission_params:GetResourceAmount(self.missionAdvancedResource[self.mission_params.biome_name])) .. " Multiplier = " .. tostring(self.missionAdvancedResourceMultiplier))	
	LogService:Log("MissionResources rare_resource : ".. self.missionRareResource[self.mission_params.biome_name] .. " = " .. tostring(self.mission_params:GetResourceAmount(self.missionRareResource[self.mission_params.biome_name])) .. " Multiplier = " .. tostring(self.missionRareResourceMultiplier))	
	LogService:Log("MissionResources geothermal_vent = ".. tostring(self.mission_params:GetResourceAmount("geothermal_vent") ) )
	LogService:Log("MissionResources flammable_gas_vent = ".. tostring(self.mission_params:GetResourceAmount("flammable_gas_vent") ) )		
    --===============RANDOM ENCOUNTER TILE RULES
	
	campaignData = CampaignService:GetCampaignData()	
	local encounterTilePool = 
	{
		acid = {},
		caverns = {},
		desert = {},
		jungle = {},
		magma = {},
		metallic = {},
		swamp = {}
	}
	
	--JUNGLE	
	table.insert( encounterTilePool.jungle, 1, "biomes/jungle/tiles/jungle_encounter_hostile_hive/jungle_encounter_hostile_hive.tile" )	
	table.insert( encounterTilePool.jungle, 1, "biomes/jungle/tiles/jungle_encounter_volcano/jungle_encounter_volcano.tile" )
	
	--table.insert( encounterTilePool.jungle, 1, "biomes/jungle/tiles/jungle_encounter_jurvins/jungle_encounter_jurvins.tile" )
	--if campaignData:GetStringOrDefault( "global.uranium_outpost_complete", "" ) == "true" then -- REQUIREMENT: Finished Uranium Outpost	
	--	table.insert( encounterTilePool.jungle, 1, "biomes/jungle/tiles/jungle_encounter_electric/jungle_encounter_electric.tile" )
	--end			
	--if campaignData:GetStringOrDefault( "global.metallic_outpost_stage_3_complete", "" ) == "true" then -- REQUIREMENT: Finished Metallic Outpost
	--	table.insert( encounterTilePool.jungle, 1, "biomes/jungle/tiles/jungle_encounter_meteor/jungle_encounter_meteor.tile" )
	--end		
	--if campaignData:GetStringOrDefault( "global.caverns_end", "" ) == "true" then -- REQUIREMENT: Finished Into The Dark DLC
	--	table.insert( encounterTilePool.jungle, 1, "biomes/jungle/tiles/jungle_encounter_cave/jungle_encounter_cave.tile" )
	--end
	
	--ACID	
	table.insert( encounterTilePool.acid, 1, "biomes/acid/tiles/acid_encounter_arachnoid_pit/acid_encounter_arachnoid_pit.tile" ) -- REQUIREMENT: None
	table.insert( encounterTilePool.acid, 1, "biomes/acid/tiles/acid_encounter_hostile_nest/acid_encounter_hostile_nest.tile" )
	
	--if campaignData:GetStringOrDefault( "global.uranium_outpost_complete", "" ) == "true" then -- REQUIREMENT: Finished Uranium Outpost
	--	table.insert( encounterTilePool.acid, 1, "biomes/acid/tiles/acid_encounter_radiation/acid_encounter_radiation.tile" )
	--end		
	--if campaignData:GetStringOrDefault( "global.metallic_outpost_stage_3_complete", "" ) == "true" then -- REQUIREMENT: Finished Metallic Outpost
	--	table.insert( encounterTilePool.acid, 1, "biomes/acid/tiles/acid_encounter_xmorph/acid_encounter_xmorph.tile" )	
	--end
	
	--CAVERNS	
	--if campaignData:GetStringOrDefault( "global.uranium_outpost_complete", "" ) == "true" then -- REQUIREMENT: Finished Uranium Outpost
	--	table.insert( encounterTilePool.caverns, 1, "biomes/caverns/tiles/caverns_encounter_green_energy/caverns_encounter_green_energy.tile" )
	--end	
	if campaignData:GetStringOrDefault( "global.titanium_outpost_complete", "" ) == "true" then -- REQUIREMENT: Finished Titanium Outpost
		table.insert( encounterTilePool.caverns, 1, "biomes/caverns/tiles/caverns_encounter_magnet/caverns_encounter_magnet.tile" )
	end
	
	--table.insert( encounterTilePool.caverns, 1, "biomes/caverns/tiles/caverns_encounter_skull/caverns_encounter_skull.tile" )	
	--if campaignData:GetStringOrDefault( "global.metallic_outpost_stage_3_complete", "" ) == "true" then -- REQUIREMENT: Finished Metallic Outpost
	--	table.insert( encounterTilePool.caverns, 1, "biomes/caverns/tiles/caverns_encounter_lava/caverns_encounter_lava.tile" )
	--end	
	
		
	--DESERT	
	table.insert( encounterTilePool.desert, 1, "biomes/desert/tiles/desert_encounter_hands/desert_encounter_hands.tile" )		
	if campaignData:GetStringOrDefault( "global.titanium_outpost_complete", "" ) == "true" then -- REQUIREMENT: Finished Titanium Outpost
		table.insert( encounterTilePool.desert, 1, "biomes/desert/tiles/desert_encounter_iceberg/desert_encounter_iceberg.tile" )		
	end
	
	--table.insert( encounterTilePool.desert, 1, "biomes/desert/tiles/desert_encounter_fire/desert_encounter_fire.tile" ) -- REQUIREMENT: None			
	--if campaignData:GetStringOrDefault( "global.titanium_outpost_complete", "" ) == "true" then -- REQUIREMENT: Finished Titanium Outpost
	--	table.insert( encounterTilePool.desert, 1, "biomes/desert/tiles/desert_encounter_magnetic_rock/desert_encounter_magnetic_rock.tile" )		
	--end
	--if campaignData:GetStringOrDefault( "global.palladium_outpost_complete", "" ) == "true" then -- REQUIREMENT: Finished Palladium Outpost
	--	table.insert( encounterTilePool.desert, 1, "biomes/desert/tiles/desert_encounter_red_crystals/desert_encounter_red_crystals.tile" )		
	--end
		
	--MAGMA	
	if campaignData:GetStringOrDefault( "global.palladium_outpost_complete", "" ) == "true" then -- REQUIREMENT: Finished Palladium Outpost
		table.insert( encounterTilePool.magma, 1, "biomes/magma/tiles/magma_encounter_acid/magma_encounter_acid.tile" )				
	end
	if campaignData:GetStringOrDefault( "global.metallic_outpost_stage_3_complete", "" ) == "true" then -- REQUIREMENT: Finished Metallic Outpost
		table.insert( encounterTilePool.magma, 1, "biomes/magma/tiles/magma_encounter_morphium/magma_encounter_morphium.tile" )			
	end
	
	--if campaignData:GetStringOrDefault( "global.caverns_end", "" ) == "true" then -- REQUIREMENT: Finished Into The Dark DLC
	--	table.insert( encounterTilePool.magma, 1, "biomes/magma/tiles/magma_encounter_mushroom/magma_encounter_mushroom.tile" )
	--end	
	--table.insert( encounterTilePool.magma, 1, "biomes/magma/tiles/magma_encounter_water/magma_encounter_water.tile" ) -- REQUIREMENT: None	
	
	--METALLIC	
	table.insert( encounterTilePool.metallic, 1, "biomes/metallic/tiles/metallic_encounter_factory/metallic_encounter_factory.tile" ) -- REQUIREMENT: None		
	table.insert( encounterTilePool.metallic, 1, "biomes/metallic/tiles/metallic_encounter_mud/metallic_encounter_mud.tile" ) -- REQUIREMENT: None		
	table.insert( encounterTilePool.metallic, 1, "biomes/metallic/tiles/metallic_encounter_trap/metallic_encounter_trap.tile" ) -- REQUIREMENT: None			
	
	--SWAMP	
	table.insert( encounterTilePool.swamp, 1, "biomes/swamp/tiles/swamp_encounter_octopus/swamp_encounter_octopus.tile" )
	table.insert( encounterTilePool.swamp, 1, "biomes/swamp/tiles/swamp_encounter_stump/swamp_encounter_stump.tile" )

	--SWAMP LAKES
	--table.insert( encounterTilePool.swamp, 1, "biomes/swamp/tiles/swamp_encounter_tentacles/swamp_encounter_tentacles.tile" ) -- SWAMP LAKES ONLY
	
	--PICK RANDOM ENCOUNTER TILE
	self.random_encounter_tile_spawn_rules = {}	
	
	local encounterTileForCurrentBiome = encounterTilePool[self.mission_params.biome_name]
	local validEncounterTilesForCurrentBiome = {}
	for tile in Iter(encounterTileForCurrentBiome) do
		local counter = campaignData:GetIntOrDefault( tile, 0 )
		if ( counter == 0) then
			Insert( validEncounterTilesForCurrentBiome, tile )
		end 
	end

	encounterTileForCurrentBiome = validEncounterTilesForCurrentBiome
	if #encounterTileForCurrentBiome > 0 then
		function GetMinDistanceFromEdge()
			if tile_name == "biomes/jungle/tiles/jungle_encounter_hostile_hive/jungle_encounter_hostile_hive.tile" then
				return 0
			else
				return 1
			end
		end
		self.random_encounter_tile_spawn_rules =
		{			
			{ 
				tile_name = encounterTileForCurrentBiome[RandInt( 1, #encounterTileForCurrentBiome )],                        
				min_instances = 1,
				max_instances = 1,				
				min_distance_from_edge = GetMinDistanceFromEdge()				
			}
		}
	end

	for encounter in Iter( self.random_encounter_tile_spawn_rules )do
		self.mission_params:AddEncounterTile( encounter.tile_name )
	end
	--===============RANDOM ENCOUNTER TILE RULES	
	
	--===============MISSION TILE THEME RULES
	--open, dense, lakes, limestone caves	
	local missionGeneratorTilePool = 
	{
		["acid"] = 
		{
			["openTilePool"] = 
			{
				{
					tile_name = "biomes/acid/tiles/acid_canyons_01/acid_canyons_01.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_canyons_02/acid_canyons_02.tile",		
					max_instances =	2,
					random_weight =	1
				},	
				{
					tile_name = "biomes/acid/tiles/acid_canyons_03/acid_canyons_03.tile",		
					max_instances =	2,
					random_weight =	1
				},	
				{
					tile_name = "biomes/acid/tiles/acid_canyons_04/acid_canyons_04.tile",		
					max_instances =	2,
					random_weight =	1
				},	
				{
					tile_name = "biomes/acid/tiles/acid_canyons_05/acid_canyons_05.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_01/acid_lakes_01.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_02/acid_lakes_02.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_03/acid_lakes_03.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_04/acid_lakes_04.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_05/acid_lakes_05.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_06/acid_lakes_06.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_nest_01/acid_nest_01.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_plains_01/acid_plains_01.tile",		
					min_instances =	2,
					random_weight =	3
				},
				{
					tile_name = "biomes/acid/tiles/acid_plains_02/acid_plains_02.tile",		
					min_instances =	2,
					random_weight =	3
				},
				{
					tile_name = "biomes/acid/tiles/acid_plains_03/acid_plains_03.tile",		
					min_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/acid/tiles/acid_plains_04/acid_plains_04.tile",		
					min_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/acid/tiles/acid_plains_05/acid_plains_05.tile",		
					min_instances =	2,
					random_weight =	2
				},
			},
			
			["denseTilePool"] = 
			{
				{
					tile_name = "biomes/acid/tiles/acid_canyons_01/acid_canyons_01.tile",		
					min_instances =	1,
					random_weight =	2
				},
				{
					tile_name = "biomes/acid/tiles/acid_canyons_02/acid_canyons_02.tile",		
					min_instances =	1,
					random_weight =	2
				},	
				{
					tile_name = "biomes/acid/tiles/acid_canyons_03/acid_canyons_03.tile",		
					min_instances =	1,
					random_weight =	2
				},	
				{
					tile_name = "biomes/acid/tiles/acid_canyons_04/acid_canyons_04.tile",		
					min_instances =	1,
					random_weight =	2
				},	
				{
					tile_name = "biomes/acid/tiles/acid_canyons_05/acid_canyons_05.tile",		
					min_instances =	1,
					random_weight =	2
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_01/acid_lakes_01.tile",							
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_02/acid_lakes_02.tile",							
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_03/acid_lakes_03.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_04/acid_lakes_04.tile",							
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_05/acid_lakes_05.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_06/acid_lakes_06.tile",							
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_nest_01/acid_nest_01.tile",							
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_plains_01/acid_plains_01.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_plains_02/acid_plains_02.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_plains_03/acid_plains_03.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_plains_04/acid_plains_04.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_plains_05/acid_plains_05.tile",		
					max_instances =	2,
					random_weight =	1
				},
			},
			
			["lakesTilePool"] = 
			{
				{
					tile_name = "biomes/acid/tiles/acid_canyons_01/acid_canyons_01.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_canyons_02/acid_canyons_02.tile",		
					max_instances =	2,
					random_weight =	1
				},	
				{
					tile_name = "biomes/acid/tiles/acid_canyons_03/acid_canyons_03.tile",		
					max_instances =	2,
					random_weight =	1
				},	
				{
					tile_name = "biomes/acid/tiles/acid_canyons_04/acid_canyons_04.tile",		
					max_instances =	2,
					random_weight =	1
				},	
				{
					tile_name = "biomes/acid/tiles/acid_canyons_05/acid_canyons_05.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_01/acid_lakes_01.tile",		
					min_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_02/acid_lakes_02.tile",		
					min_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_03/acid_lakes_03.tile",		
					min_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_04/acid_lakes_04.tile",		
					min_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_05/acid_lakes_05.tile",		
					min_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/acid/tiles/acid_lakes_06/acid_lakes_06.tile",		
					min_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/acid/tiles/acid_nest_01/acid_nest_01.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_plains_01/acid_plains_01.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_plains_02/acid_plains_02.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_plains_03/acid_plains_03.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_plains_04/acid_plains_04.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/acid/tiles/acid_plains_05/acid_plains_05.tile",		
					max_instances =	2,
					random_weight =	1
				},
			},
		},
		
		["caverns"] = 
		{
			["openTilePool"] = 
			{
				{
					tile_name = "biomes/caverns/tiles/caverns_canyons_01/caverns_canyons_01.tile",
					max_instances = 3,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_canyons_02/caverns_canyons_02.tile",
					max_instances = 3,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_canyons_03/caverns_canyons_03.tile",
					max_instances = 3,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_canyons_04/caverns_canyons_04.tile",
					max_instances = 3,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_canyons_05/caverns_canyons_05.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_canyons_06/caverns_canyons_06.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_canyons_07/caverns_canyons_07.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_01/caverns_plains_01.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_02/caverns_plains_02.tile",
					min_instances = 2,
					random_weight =	2
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_03/caverns_plains_03.tile",
					min_instances = 2,
					random_weight =	2
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_04/caverns_plains_04.tile",
					min_instances = 2,
					random_weight =	2
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_05/caverns_plains_05.tile",
					max_instances = 3,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_06/caverns_plains_06.tile",
					min_instances = 2,
					random_weight =	2
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_07/caverns_plains_07.tile",
					min_instances = 2,
					random_weight =	2
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_08/caverns_plains_08.tile",
					min_instances = 2,
					random_weight =	2
				},
			},
			
			["denseTilePool"] = 
			{
				{
					tile_name = "biomes/caverns/tiles/caverns_canyons_01/caverns_canyons_01.tile",
					min_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_canyons_02/caverns_canyons_02.tile",
					min_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_canyons_03/caverns_canyons_03.tile",
					min_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_canyons_04/caverns_canyons_04.tile",
					min_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_canyons_05/caverns_canyons_05.tile",
					min_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_canyons_06/caverns_canyons_06.tile",
					min_instances = 1,
					max_instances = 3,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_canyons_07/caverns_canyons_07.tile",
					min_instances = 1,
					max_instances = 3,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_01/caverns_plains_01.tile",
					min_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_02/caverns_plains_02.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_03/caverns_plains_03.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_04/caverns_plains_04.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_05/caverns_plains_05.tile",
					min_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_06/caverns_plains_06.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_07/caverns_plains_07.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/caverns/tiles/caverns_plains_08/caverns_plains_08.tile",
					max_instances = 2,
					random_weight =	1
				},
			},
			
			["lakesTilePool"] = 
			{
			},
		},
		
		["desert"] = 
		{
			["openTilePool"] = 
			{
				{
					tile_name = "biomes/desert/tiles/desert_canyons_01/desert_canyons_01.tile",
					max_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_canyons_02/desert_canyons_02.tile",
					max_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_canyons_03/desert_canyons_03.tile",
					max_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_canyons_04/desert_canyons_04.tile",
					max_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_canyons_05/desert_canyons_05.tile",
					max_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_canyons_06/desert_canyons_06.tile",
					max_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_canyons_07/desert_canyons_07.tile",
					max_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_canyons_08/desert_canyons_08.tile",
					max_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_nest_01/desert_nest_01.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_plains_01/desert_plains_01.tile",
					min_instances = 2,
					random_weight =	2
				},
				{
					tile_name = "biomes/desert/tiles/desert_plains_02/desert_plains_02.tile",
					min_instances = 2,
					random_weight =	2
				},
				{
					tile_name = "biomes/desert/tiles/desert_plains_03/desert_plains_03.tile",
					min_instances = 2,
					random_weight =	2
				},
				{
					tile_name = "biomes/desert/tiles/desert_plains_04/desert_plains_04.tile",
					min_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_plains_05/desert_plains_05.tile",
					min_instances = 2,
					random_weight =	2
				},
				{
					tile_name = "biomes/desert/tiles/desert_starting_01/desert_starting_01.tile",
					min_instances = 1,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_starting_02/desert_starting_02.tile",
					min_instances = 1,
					random_weight =	1
				},
			},
			
			["denseTilePool"] = 
			{
				{
					tile_name = "biomes/desert/tiles/desert_canyons_01/desert_canyons_01.tile",
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/desert/tiles/desert_canyons_02/desert_canyons_02.tile",
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/desert/tiles/desert_canyons_03/desert_canyons_03.tile",
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/desert/tiles/desert_canyons_04/desert_canyons_04.tile",
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/desert/tiles/desert_canyons_05/desert_canyons_05.tile",
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/desert/tiles/desert_canyons_06/desert_canyons_06.tile",
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/desert/tiles/desert_canyons_07/desert_canyons_07.tile",
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/desert/tiles/desert_canyons_08/desert_canyons_08.tile",
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/desert/tiles/desert_nest_01/desert_nest_01.tile",					
					random_weight =	2
				},
				{
					tile_name = "biomes/desert/tiles/desert_plains_01/desert_plains_01.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_plains_02/desert_plains_02.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_plains_03/desert_plains_03.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_plains_04/desert_plains_04.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_plains_05/desert_plains_05.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_starting_01/desert_starting_01.tile",
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/desert/tiles/desert_starting_02/desert_starting_02.tile",
					max_instances = 2,
					random_weight =	1
				},
			},
			
			["lakesTilePool"] = 
			{
			},
		},
		
		["jungle"] = 
		{
			["openTilePool"] = 
			{	
				{
					tile_name = "biomes/jungle/tiles/jungle_canyons_01/jungle_canyons_01.tile",
					max_instances = 4			
				},		
				{
					tile_name = "biomes/jungle/tiles/jungle_canyons_02/jungle_canyons_02.tile",
					max_instances = 1			
				},		
				{
					tile_name = "biomes/jungle/tiles/jungle_canyons_03/jungle_canyons_03.tile",
					max_instances = 2		
				},	
				{
					tile_name = "biomes/jungle/tiles/jungle_lakes_01/jungle_lakes_01.tile",
					max_instances = 2			
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_lakes_02/jungle_lakes_02.tile",
					max_instances = 1			
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_lakes_03/jungle_lakes_03.tile",
					max_instances = 1			
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_lakes_04/jungle_lakes_04.tile",
					max_instances = 2			
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_nest_01/jungle_nest_01.tile",
					max_instances = 3			
				},	
				{
					tile_name = "biomes/jungle/tiles/jungle_nest_02/jungle_nest_02.tile",
					max_instances = 3			
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_nest_03/jungle_nest_03.tile",
					max_instances = 3			
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_plains_01/jungle_plains_01.tile",					
					random_weight =	2
				},	
				{
					tile_name = "biomes/jungle/tiles/jungle_plains_02/jungle_plains_02.tile",		
					min_instances =	2,
					random_weight =	2
				},		
				{
					tile_name = "biomes/jungle/tiles/jungle_plains_03/jungle_plains_03.tile",
					min_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_plains_04/jungle_plains_04.tile",			
					random_weight =	2
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_starting_01/jungle_starting_01.tile",			
					random_weight =	2
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_trees_01/jungle_trees_01.tile",			
					random_weight =	3
				},
			},
			
			["denseTilePool"] = 
			{	
				{
					tile_name = "biomes/jungle/tiles/jungle_canyons_01/jungle_canyons_01.tile",
					random_weight =	2		
				},		
				{
					tile_name = "biomes/jungle/tiles/jungle_canyons_02/jungle_canyons_02.tile",
					max_instances = 2			
				},		
				{
					tile_name = "biomes/jungle/tiles/jungle_canyons_03/jungle_canyons_03.tile",
					max_instances = 4		
				},	
				{
					tile_name = "biomes/jungle/tiles/jungle_lakes_01/jungle_lakes_01.tile",
					max_instances = 2			
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_lakes_02/jungle_lakes_02.tile",
					max_instances = 1			
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_lakes_03/jungle_lakes_03.tile",
					max_instances = 1			
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_lakes_04/jungle_lakes_04.tile",
					max_instances = 2			
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_nest_01/jungle_nest_01.tile",
					random_weight =	2
				},	
				{
					tile_name = "biomes/jungle/tiles/jungle_nest_02/jungle_nest_02.tile",
					random_weight =	2						
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_nest_03/jungle_nest_03.tile",
					random_weight =	2					
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_plains_01/jungle_plains_01.tile",					
					random_weight =	1
				},	
				{
					tile_name = "biomes/jungle/tiles/jungle_plains_02/jungle_plains_02.tile",					
					random_weight =	1
				},		
				{
					tile_name = "biomes/jungle/tiles/jungle_plains_03/jungle_plains_03.tile",			
					random_weight =	1
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_plains_04/jungle_plains_04.tile",			
					random_weight =	1
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_starting_01/jungle_starting_01.tile",			
					random_weight =	1
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_trees_01/jungle_trees_01.tile",			
					random_weight =	1
				},
			},
			
			["lakesTilePool"] = 
			{	
				{
					tile_name = "biomes/jungle/tiles/jungle_canyons_01/jungle_canyons_01.tile",
					max_instances = 4			
				},		
				{
					tile_name = "biomes/jungle/tiles/jungle_canyons_02/jungle_canyons_02.tile",
					max_instances = 1			
				},		
				{
					tile_name = "biomes/jungle/tiles/jungle_canyons_03/jungle_canyons_03.tile",
					max_instances = 2		
				},	
				{
					tile_name = "biomes/jungle/tiles/jungle_lakes_01/jungle_lakes_01.tile",
					min_instances = 2,
					max_instances = 4,
					random_weight =	2			
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_lakes_02/jungle_lakes_02.tile",
					max_instances = 2,			
					min_instances = 1,			
					random_weight =	2
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_lakes_03/jungle_lakes_03.tile",
					max_instances = 2,	
					min_instances = 1,	
					random_weight =	2
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_lakes_04/jungle_lakes_04.tile",
					max_instances = 6,	
					min_instances = 3,	
					random_weight =	2
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_nest_01/jungle_nest_01.tile",
					random_weight =	1
				},	
				{
					tile_name = "biomes/jungle/tiles/jungle_nest_02/jungle_nest_02.tile",
					random_weight =	1						
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_nest_03/jungle_nest_03.tile",
					random_weight =	1					
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_plains_01/jungle_plains_01.tile",					
					random_weight =	1
				},	
				{
					tile_name = "biomes/jungle/tiles/jungle_plains_02/jungle_plains_02.tile",					
					min_instances = 4,
					random_weight =	3
				},		
				{
					tile_name = "biomes/jungle/tiles/jungle_plains_03/jungle_plains_03.tile",			
					min_instances = 4,
					random_weight =	3
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_plains_04/jungle_plains_04.tile",			
					random_weight =	1
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_starting_01/jungle_starting_01.tile",			
					random_weight =	1
				},
				{
					tile_name = "biomes/jungle/tiles/jungle_trees_01/jungle_trees_01.tile",			
					random_weight =	1
				},
			}
		},
		
		["magma"] = 
		{
			["openTilePool"] = 
			{
				{
					tile_name = "biomes/magma/tiles/magma_canyons_01/magma_canyons_01.tile",
					max_instances =	2,
					random_weight =	1					
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_02/magma_canyons_02.tile",
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_03/magma_canyons_03.tile",
					max_instances =	3,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_04/magma_canyons_04.tile",
					max_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_05/magma_canyons_05.tile",
					max_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_06/magma_canyons_06.tile",
					max_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_07/magma_canyons_07.tile",
					max_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_01/magma_lakes_01.tile",					
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_02/magma_lakes_02.tile",					
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_03/magma_lakes_03.tile",
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_04/magma_lakes_04.tile",					
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_05/magma_lakes_05.tile",					
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_06/magma_lakes_06.tile",					
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_07/magma_lakes_07.tile",					
					max_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_08/magma_lakes_08.tile",
					max_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_plains_01/magma_plains_01.tile",							
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_plains_02/magma_plains_02.tile",		
					min_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/magma/tiles/magma_plains_03/magma_plains_03.tile",		
					min_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/magma/tiles/magma_plains_04/magma_plains_04.tile",		
					min_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/magma/tiles/magma_plains_05/magma_plains_05.tile",		
					min_instances =	2,
					random_weight =	2
				},
			},
			
			["denseTilePool"] = 
			{
				{
					tile_name = "biomes/magma/tiles/magma_canyons_01/magma_canyons_01.tile",					
					random_weight =	2					
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_02/magma_canyons_02.tile",					
					random_weight =	2
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_03/magma_canyons_03.tile",					
					random_weight =	2
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_04/magma_canyons_04.tile",
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_05/magma_canyons_05.tile",
					max_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_06/magma_canyons_06.tile",
					max_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_07/magma_canyons_07.tile",
					max_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_01/magma_lakes_01.tile",					
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_02/magma_lakes_02.tile",										
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_03/magma_lakes_03.tile",
					max_instances =	5,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_04/magma_lakes_04.tile",					
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_05/magma_lakes_05.tile",					
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_06/magma_lakes_06.tile",					
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_07/magma_lakes_07.tile",					
					max_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_08/magma_lakes_08.tile",
					max_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_plains_01/magma_plains_01.tile",							
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_plains_02/magma_plains_02.tile",		
					max_instances =	1,
					random_weight =	2
				},
				{
					tile_name = "biomes/magma/tiles/magma_plains_03/magma_plains_03.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_plains_04/magma_plains_04.tile",		
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_plains_05/magma_plains_05.tile",		
					max_instances =	2,
					random_weight =	1
				},				
			},
			
			["lakesTilePool"] = 
			{
				{
					tile_name = "biomes/magma/tiles/magma_canyons_01/magma_canyons_01.tile",					
					max_instances =	3,
					random_weight =	1					
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_02/magma_canyons_02.tile",					
					max_instances =	3,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_03/magma_canyons_03.tile",					
					max_instances =	3,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_04/magma_canyons_04.tile",
					max_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_05/magma_canyons_05.tile",
					max_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_06/magma_canyons_06.tile",
					max_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_canyons_07/magma_canyons_07.tile",
					max_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_01/magma_lakes_01.tile",					
					random_weight =	1.5
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_02/magma_lakes_02.tile",										
					random_weight =	1.5
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_03/magma_lakes_03.tile",
					max_instances =	5,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_04/magma_lakes_04.tile",					
					min_instances =	4,
					random_weight =	2
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_05/magma_lakes_05.tile",					
					min_instances =	4,
					random_weight =	2
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_06/magma_lakes_06.tile",					
					max_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_07/magma_lakes_07.tile",					
					max_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/magma/tiles/magma_lakes_08/magma_lakes_08.tile",
					max_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/magma/tiles/magma_plains_01/magma_plains_01.tile",							
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_plains_02/magma_plains_02.tile",							
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_plains_03/magma_plains_03.tile",		
					min_instances =	2,
					random_weight =	2
				},	
				{
					tile_name = "biomes/magma/tiles/magma_plains_04/magma_plains_04.tile",		
					min_instances =	1,
					random_weight =	1
				},
				{
					tile_name = "biomes/magma/tiles/magma_plains_05/magma_plains_05.tile",		
					min_instances =	1,
					random_weight =	1
				},
			}
		},
		
		["metallic"] = 
		{
			["openTilePool"] = 
			{
				{
					tile_name = "biomes/metallic/tiles/metallic_canyons_01/metallic_canyons_01.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_canyons_02/metallic_canyons_02.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_canyons_03/metallic_canyons_03.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_canyons_04/metallic_canyons_04.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_lakes_01/metallic_lakes_01.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_lakes_02/metallic_lakes_02.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_lakes_03/metallic_lakes_03.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_lakes_04/metallic_lakes_04.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_plains_01/metallic_plains_01.tile",							
					min_instances =	1,
					random_weight =	2
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_plains_02/metallic_plains_02.tile",							
					min_instances =	1,
					random_weight =	2
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_plains_03/metallic_plains_03.tile",							
					min_instances =	1,
					random_weight =	2
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_plains_04/metallic_plains_04.tile",							
					min_instances =	1,
					random_weight =	2
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_plains_05/metallic_plains_05.tile",							
					min_instances =	1,
					random_weight =	2
				},
			},
			
			["denseTilePool"] = 
			{
				{
					tile_name = "biomes/metallic/tiles/metallic_canyons_01/metallic_canyons_01.tile",							
					min_instances =	1,
					random_weight =	2
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_canyons_02/metallic_canyons_02.tile",							
					min_instances =	1,
					random_weight =	2
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_canyons_03/metallic_canyons_03.tile",							
					min_instances =	1,
					random_weight =	2
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_canyons_04/metallic_canyons_04.tile",							
					min_instances =	1,
					random_weight =	2
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_lakes_01/metallic_lakes_01.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_lakes_02/metallic_lakes_02.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_lakes_03/metallic_lakes_03.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_lakes_04/metallic_lakes_04.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_plains_01/metallic_plains_01.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_plains_02/metallic_plains_02.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_plains_03/metallic_plains_03.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_plains_04/metallic_plains_04.tile",							
					max_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_plains_05/metallic_plains_05.tile",							
					max_instances =	2,
					random_weight =	1
				},
			},
			
			["lakesTilePool"] = 
			{
				{
					tile_name = "biomes/metallic/tiles/metallic_canyons_01/metallic_canyons_01.tile",												
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_canyons_02/metallic_canyons_02.tile",												
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_canyons_03/metallic_canyons_03.tile",												
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_canyons_04/metallic_canyons_04.tile",												
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_lakes_01/metallic_lakes_01.tile",							
					min_instances = 2,
					random_weight =	2
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_lakes_02/metallic_lakes_02.tile",							
					min_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_lakes_03/metallic_lakes_03.tile",							
					min_instances =	2,
					random_weight =	2
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_lakes_04/metallic_lakes_04.tile",							
					min_instances =	2,
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_plains_01/metallic_plains_01.tile",												
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_plains_02/metallic_plains_02.tile",												
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_plains_03/metallic_plains_03.tile",												
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_plains_04/metallic_plains_04.tile",												
					random_weight =	1
				},
				{
					tile_name = "biomes/metallic/tiles/metallic_plains_05/metallic_plains_05.tile",												
					random_weight =	1
				},
			},
		},
		
		["swamp"] = 
		{
			["openTilePool"] = 
			{				
				{			
					tile_name = "biomes/swamp/tiles/swamp_custom_resin_01/swamp_custom_resin_01.tile",
					min_instances = 1,
					max_instances = 2,
					min_distance_from_edge = 1
				},	
				{			
					tile_name = "biomes/swamp/tiles/swamp_custom_resin_02/swamp_custom_resin_02.tile",
					min_instances = 1,
					max_instances = 2,
					min_distance_from_edge = 1
				},	
				{
					tile_name = "biomes/swamp/tiles/swamp_canyons_01/swamp_canyons_01.tile",												
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_canyons_02/swamp_canyons_02.tile",												
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_canyons_03/swamp_canyons_03.tile",												
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_canyons_04/swamp_canyons_04.tile",												
					max_instances = 2,
					random_weight =	1
				},
				--{
				--	tile_name = "biomes/swamp/tiles/swamp_canyons_05/swamp_canyons_05.tile",												
				--	max_instances = 2,
				--	random_weight =	1
				--},
				{
					tile_name = "biomes/swamp/tiles/swamp_lakes_01/swamp_lakes_01.tile",												
					max_instances = 3,
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_lakes_02/swamp_lakes_02.tile",												
					max_instances = 3,
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_01/swamp_plains_01.tile",												
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_02/swamp_plains_02.tile",												
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_03/swamp_plains_03.tile",												
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_04/swamp_plains_04.tile",												
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_05/swamp_plains_05.tile",												
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_06/swamp_plains_06.tile",												
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_07/swamp_plains_07.tile",												
					min_instances = 1,
					random_weight =	2
				},
			},
			
			["denseTilePool"] = 
			{
				{			
					tile_name = "biomes/swamp/tiles/swamp_custom_resin_01/swamp_custom_resin_01.tile",
					min_instances = 1,
					max_instances = 2,
					min_distance_from_edge = 1
				},	
				{			
					tile_name = "biomes/swamp/tiles/swamp_custom_resin_02/swamp_custom_resin_02.tile",
					min_instances = 1,
					max_instances = 2,
					min_distance_from_edge = 1
				},	
				{
					tile_name = "biomes/swamp/tiles/swamp_canyons_01/swamp_canyons_01.tile",												
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_canyons_02/swamp_canyons_02.tile",												
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_canyons_03/swamp_canyons_03.tile",												
					min_instances = 1,
					random_weight =	2
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_canyons_04/swamp_canyons_04.tile",												
					min_instances = 1,
					random_weight =	2
				},
				--{
				--	tile_name = "biomes/swamp/tiles/swamp_canyons_05/swamp_canyons_05.tile",												
				--	min_instances = 1,
				--	random_weight =	2
				--},
				{
					tile_name = "biomes/swamp/tiles/swamp_lakes_01/swamp_lakes_01.tile",												
					max_instances = 3,
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_lakes_02/swamp_lakes_02.tile",												
					max_instances = 3,
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_01/swamp_plains_01.tile",												
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_02/swamp_plains_02.tile",												
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_03/swamp_plains_03.tile",												
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_04/swamp_plains_04.tile",												
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_05/swamp_plains_05.tile",												
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_06/swamp_plains_06.tile",												
					max_instances = 2,
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_07/swamp_plains_07.tile",												
					max_instances = 2,
					random_weight =	1
				},
			},
			
			["lakesTilePool"] = 
			{
				{			
					tile_name = "biomes/swamp/tiles/swamp_custom_resin_01/swamp_custom_resin_01.tile",
					min_instances = 1,
					max_instances = 2,
					min_distance_from_edge = 1
				},	
				{			
					tile_name = "biomes/swamp/tiles/swamp_custom_resin_02/swamp_custom_resin_02.tile",
					min_instances = 1,
					max_instances = 2,
					min_distance_from_edge = 1
				},	
				{
					tile_name = "biomes/swamp/tiles/swamp_canyons_01/swamp_canyons_01.tile",																	
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_canyons_02/swamp_canyons_02.tile",																	
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_canyons_03/swamp_canyons_03.tile",																	
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_canyons_04/swamp_canyons_04.tile",																	
					random_weight =	1
				},
				--{
				--	tile_name = "biomes/swamp/tiles/swamp_canyons_05/swamp_canyons_05.tile",																	
				--	random_weight =	1
				--},
				{
					tile_name = "biomes/swamp/tiles/swamp_lakes_01/swamp_lakes_01.tile",												
					min_instances = 3,
					random_weight =	3
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_lakes_02/swamp_lakes_02.tile",												
					min_instances = 3,
					random_weight =	3
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_01/swamp_plains_01.tile",																	
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_02/swamp_plains_02.tile",												
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_03/swamp_plains_03.tile",												
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_04/swamp_plains_04.tile",												
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_05/swamp_plains_05.tile",												
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_06/swamp_plains_06.tile",												
					random_weight =	1
				},
				{
					tile_name = "biomes/swamp/tiles/swamp_plains_07/swamp_plains_07.tile",												
					random_weight =	1
				},
			},
		}
	}
	--===============GUEST TILES
	if self.mission_params.biome_name == "jungle" then
		--if campaignData:GetStringOrDefault( "global.caverns_end", "" ) == "true" then -- REQUIREMENT: Finished Into The Dark DLC
			table.insert( missionGeneratorTilePool[self.mission_params.biome_name]["openTilePool"], 1, { tile_name = "biomes/jungle/tiles/jungle_custom_caverns_01/jungle_custom_caverns_01.tile", random_weight = 10 } )
			table.insert( missionGeneratorTilePool[self.mission_params.biome_name]["openTilePool"], 1, { tile_name = "biomes/jungle/tiles/jungle_custom_caverns_02/jungle_custom_caverns_02.tile", random_weight = 10 } )
			table.insert( missionGeneratorTilePool[self.mission_params.biome_name]["denseTilePool"], 1, { tile_name = "biomes/jungle/tiles/jungle_custom_caverns_01/jungle_custom_caverns_01.tile", random_weight = 20 } )
			table.insert( missionGeneratorTilePool[self.mission_params.biome_name]["denseTilePool"], 1, { tile_name = "biomes/jungle/tiles/jungle_custom_caverns_02/jungle_custom_caverns_02.tile", random_weight =	20 } )
			table.insert( missionGeneratorTilePool[self.mission_params.biome_name]["lakesTilePool"], 1, { tile_name = "biomes/jungle/tiles/jungle_custom_caverns_01/jungle_custom_caverns_01.tile", random_weight =	10 } )
			table.insert( missionGeneratorTilePool[self.mission_params.biome_name]["lakesTilePool"], 1, { tile_name = "biomes/jungle/tiles/jungle_custom_caverns_02/jungle_custom_caverns_02.tile", random_weight =	10 } )
		--end
	end

    self:CreateTileSpawnRules( self.random_encounter_tile_spawn_rules )
	if self.mission_params.terrain_type == "open" then
		self:CreateTileSpawnRules( missionGeneratorTilePool[self.mission_params.biome_name]["openTilePool"] )
	elseif self.mission_params.terrain_type == "dense" then
		self:CreateTileSpawnRules( missionGeneratorTilePool[self.mission_params.biome_name]["denseTilePool"] )
	elseif self.mission_params.terrain_type == "lakes" then
		self:CreateTileSpawnRules( missionGeneratorTilePool[self.mission_params.biome_name]["lakesTilePool"] )
	end

	-- LIGHT MASKS
	local missionGeneratorLightMaskPool = 
	{
		["caverns"] = 
		{
			{
				tile_name = "logic/caverns_light_mask_holes_medium",		
			}
		}
	}

	if ( self.mission_params.biome_name == "caverns" ) then
		self:CreateLightMaskMaterialsRules(missionGeneratorLightMaskPool[self.mission_params.biome_name])
	end

	-- LIGHT MASK AFFECTS SOLAR POWER 
	-- not implemented

	-- DESTRUCTIBLE VOLUME PATERNS
	local missionGeneratorDestructibleVolumePatternPool = 
	{
		["caverns"] = 
		{
			{
				tile_name = "materials/textures/logic/caverns_destructible_rocks_mask_edge_1_full.png",		
			},
			{
				tile_name = "materials/textures/logic/caverns_destructible_rocks_mask_edge_1_large_hole_1.png",												
				min_instances = 2,			
				max_instances =	3,
			},
			{
				tile_name = "materials/textures/logic/caverns_destructible_rocks_mask_edge_1_large_hole_2.png",												
				min_instances = 2,			
				max_instances =	3,
			},
			{
				tile_name = "materials/textures/logic/caverns_destructible_rocks_mask_edge_1_large_hole_3.png",												
				min_instances = 2,			
				max_instances =	3,
			},
			{
				tile_name = "materials/textures/logic/caverns_destructible_rocks_mask_edge_1_medium_hole_1.png",												
				min_instances = 1,			
				max_instances =	3,
			},
			{
				tile_name = "materials/textures/logic/caverns_destructible_rocks_mask_edge_1_medium_hole_2.png",												
				min_instances = 1,			
				max_instances =	3,
			},
			{
				tile_name = "materials/textures/logic/caverns_destructible_rocks_mask_edge_1_medium_hole_3.png",												
				min_instances = 1,			
				max_instances =	3,
			},
		}
	}

	if ( self.mission_params.biome_name == "caverns" ) then
		self:CreateDestructibleVolumePatternRules(missionGeneratorDestructibleVolumePatternPool[self.mission_params.biome_name])
	end

end

function template_universal:PrepareMissionObjects()

-- CREATURES
	local biome_ambient_creatures = {
		["acid"] = 
		{
			ground =
			{     
				max_count  = 150,
				spawn_rate = 5,
				species =
				{
					{
						creature_species = "crader"
					}
				}
			},
	
			air =
			{
				max_count = 10,
				spawn_rate = 2,
				search_to_spawn_radius = 1,
				species =
				{
					{
						creature_species = "vathamite"
					}
				}
			}
		},

		["caverns"] =
		{
			ground =
			{     
				max_count = 50,
				spawn_rate = 6,
				search_to_spawn_radius = 2,
				species =
				{
					{
						creature_species = "crysder"
					}
				}
			},
	
			air =
			{
				--species =
				--{
				--	{
				--		creature_species = "vesaurus"
				--	}
				--}
			}
		},

		["desert"] =
		{
			ground =
			{     
				species =
				{
					{
						creature_species = "rugwig"
					}
				}
			},
	
			air =
			{
				species =
				{
					{
						creature_species = "mothray"
					}
				}
			}
		},

		["jungle"] =
		{
			ground =
			{     
				species =
				{
					{
						creature_species = "quelver"
					}
				}
			},
	
			air =
			{
				species =
				{
					{
						creature_species = "vesaurus"
					}
				}
			}
		},

		["magma"] =
		{
			ground =
			{     
				species =
				{
					{
						creature_species = "venomine"
					}
				}
			},
	
			air =
			{
				species =
				{
					max_count = 15,
					spawn_rate = 2,
					search_to_spawn_radius = 1,
					{
						creature_species = "bitrid"
					}
				}
			}
		},

		["metallic"] =
		{
			ground =
			{   
				species =
				{
					{
						creature_species = "stonger"
					}
				}
			},
	
			air =
			{
				max_count	= 5,
				species =
				{
					{
						creature_species = "idapian"
					},
					{
						creature_species = "idapian_metallic"
					}
				}
			}
		},

		["swamp"] =
		{
			ground =
			{     
				species =
				{
					{
						creature_species = "lurkid"
					}
				}
			},
	
			air =
			{
				species =
				{
					max_count = 10,
					spawn_rate = 2,
					search_to_spawn_radius = 1,
					{
						creature_species = "darnot"
					}
				}
			}
		}
	};

	local biome_creatures =
	{
		["acid"] =
		{        
			neutral_units = 
			{
				{
					creature_species = "sulphorit",					
				},
				
			},
			regular_units = 
			{
				{
					creature_species = "granan",
					volume_spawn_ratio = 2
				},
				{
					creature_species = "arachnoid_sentinel",
					volume_spawn_ratio = 1.25
				},
				{
					creature_species = "nerilian",
					volume_spawn_ratio = 1
				},
				{
					creature_species = "bomogan_acid",
					volume_spawn_ratio = 1
				},
				{
					creature_species = "nurglax",
					volume_spawn_ratio = 0.5
				},
				{
					creature_species = "phirian_acid",
					volume_spawn_ratio = 0.5
				},
				{
					creature_species = "baxmoth_acid",
					volume_spawn_ratio = 0.5
				},				
			},
			liquid_units = 
			{
				{
					creature_species = "hedroner_acid",
					volume_spawn_ratio = 0.5
				}            
			},
			resource_units = 
			{				
				{
					creature_species = "krocoon_acid",
					volume_spawn_ratio = 0.5
				}
			}        
		},
		
		["caverns"] =
		{        
			neutral_units = 
			{
				{
					creature_species = "moltug_crystal",					
				},
				
			},
			regular_units = 
			{
				{
					creature_species = "crawlog",
					volume_spawn_ratio = 2
				},
				{
					creature_species = "gulgor",
					volume_spawn_ratio = 1.5
				},
				{
					creature_species = "stregaros_crystal",
					volume_spawn_ratio = 2
				},
				{
					creature_species = "necrodon",
					volume_spawn_ratio = 0.75
				},
			},
			liquid_units = 
			{			       
			},
			resource_units = 
			{
				{
					creature_species = "gnerot_caverns",
					volume_spawn_ratio = 0.25
				},
			}        
		},
		
		["desert"] =
		{        
			neutral_units = 
			{
				{
					creature_species = "geotrupex",					
				},
				
			},
			regular_units = 
			{
				{
					creature_species = "mushbit",
					volume_spawn_ratio = 3
				},
				{
					creature_species = "zorant",
					volume_spawn_ratio = 2
				},
				{
					creature_species = "stregaros",
					volume_spawn_ratio = 2
				},
				{
					creature_species = "lesigian",
					volume_spawn_ratio = 0.75
				},
				{
					creature_species = "kermon",
					volume_spawn_ratio = 0.5
				},
			},
			liquid_units = 
			{			       
			},
			resource_units = 
			{
				{
					creature_species = "gnerot_desert",
					volume_spawn_ratio = 0.35
				},
			},
			guardian_standard = 
			{
				{
					creature_species = "gnerot_desert",
					volume_spawn_ratio = 1
				}				
			},
			guardian_advanced = 
			{
				{
					creature_species = "gnerot_desert",
					volume_spawn_ratio = 1
				}				
			},        
			guardian_superior = 
			{
				{
					creature_species = "gnerot_desert",
					volume_spawn_ratio = 1
				}				
			},        
			guardian_extreme = 
			{
				{
					creature_species = "gnerot_desert",
					volume_spawn_ratio = 1
				}				
			},        
		},
		
		["jungle"] =
		{        
			neutral_units = 
			{
				{
					creature_species = "jurvine",					
				},
				
			},
			regular_units = 
			{
				{
					creature_species = "canoptrix",
					volume_spawn_ratio = 2
				},
				{
					creature_species = "arachnoid_sentinel",
					volume_spawn_ratio = 1.25
				},
				{
					creature_species = "kafferroceros",
					volume_spawn_ratio = 1
				},
				{
					creature_species = "phirian_jungle",
					volume_spawn_ratio = 0.5
				},
				{
					creature_species = "baxmoth_jungle",
					volume_spawn_ratio = 0.5
				},
				{
					creature_species = "bomogan_jungle",
					volume_spawn_ratio = 0.5
				},
				{
					creature_species = "kermon",
					volume_spawn_ratio = 0.5
				}
			},
			liquid_units = 
			{
				{
					creature_species = "hedroner_jungle",
					volume_spawn_ratio = 0.5
				}            
			},
			resource_units = 
			{
				{
					creature_species = "gnerot_jungle",
					volume_spawn_ratio = 0.25
				},
				{
					creature_species = "krocoon_jungle",
					volume_spawn_ratio = 0.25
				}
			}        
		},
		["magma"] =
		{        
			neutral_units = 
			{
				{
					creature_species = "moltug",
				},				
			},
			regular_units = 
			{
				{
					creature_species = "morirot",
					volume_spawn_ratio = 3
				},
				{
					creature_species = "bomogan",
					volume_spawn_ratio = 0.5
				},
				{
					creature_species = "magmoth",
					volume_spawn_ratio = 2
				},
				{
					creature_species = "nerilian",
					volume_spawn_ratio = 2
				},
				{
					creature_species = "phirian_magma",
					volume_spawn_ratio = 0.35
				},
				{
					creature_species = "hedroner_magma",
					volume_spawn_ratio = 1
				}				
			},
			liquid_units = 
			{
				{
					creature_species = "hedroner_magma",
					volume_spawn_ratio = 0.5
				},
				{
					creature_species = "magmoth",
					volume_spawn_ratio = 0.5
				}								
			},
			resource_units = 
			{
				{
					creature_species = "gnerot_magma",
					volume_spawn_ratio = 0.25
				},
				{
					creature_species = "krocoon_magma",
					volume_spawn_ratio = 0.25
				}
			},
			guardian_standard = 
			{
				{
					creature_species = "nerilian",
					volume_spawn_ratio = 1
				}				
			},
			guardian_advanced = 
			{
				{
					creature_species = "nerilian",
					volume_spawn_ratio = 1
				}				
			},        
			guardian_superior = 
			{
				{
					creature_species = "gnerot_magma",
					volume_spawn_ratio = 1
				}				
			},        
			guardian_extreme = 
			{
				{
					creature_species = "gnerot_magma",
					volume_spawn_ratio = 1
				}				
			},        
		},
		
		["metallic"] =
		{        
			neutral_units = 
			{
				{
					creature_species = "brabit",
				},				
			},
			regular_units = 
			{
				{
					creature_species = "wingmite",
					volume_spawn_ratio = 2
				},	
				{
					creature_species = "bradron",
					volume_spawn_ratio = 2
				},	
				{
					creature_species = "octabit",
					volume_spawn_ratio = 1
				},
				{
					creature_species = "flurian",
					volume_spawn_ratio = 0.75
				},	
				{
					creature_species = "lesigian",
					volume_spawn_ratio = 0.75
				},	
				{
					creature_species = "kermon_metallic",
					volume_spawn_ratio = 0.5
				},	
			},
			liquid_units = 
			{	
				{
					creature_species = "hedroner_morphium",
					volume_spawn_ratio = 0.5
				},	
			},
			resource_units = 
			{
				{
					creature_species = "krocoon_jungle",
					volume_spawn_ratio = 0.25
				},	
			}        
		},
		
		["swamp"] =
		{        
			neutral_units = 
			{
				{
					creature_species = "poogret",
					volume_spawn_ratio = 1
				},
				{
					creature_species = "stickrid",
					volume_spawn_ratio = 3
				},
			},
			regular_units = 
			{
				{
					creature_species = "stickrid",
					volume_spawn_ratio = 1
				},
				{
					creature_species = "plutrodon",
					volume_spawn_ratio = 1.25
				},
				{
					creature_species = "fungor",
					volume_spawn_ratio = 1
				},
				{
					creature_species = "phirian_jungle",
					volume_spawn_ratio = 0.2
				},
				{
					creature_species = "baxmoth",
					volume_spawn_ratio = 0.3
				},
				{
					creature_species = "nurglax",
					volume_spawn_ratio = 0.2
				},
				{
					creature_species = "canceroth",
					volume_spawn_ratio = 0.2
				},
			},
			liquid_units = 
			{	
				{
					creature_species = "mudroner",
					volume_spawn_ratio = 1
				},
				{
					creature_species = "stickrid",
					volume_spawn_ratio = 2
				},
				{
					creature_species = "plutrodon",
					volume_spawn_ratio = 1.25
				},
				{
					creature_species = "fungor",
					volume_spawn_ratio = 1
				},
				{
					creature_species = "phirian_jungle",
					volume_spawn_ratio = 0.2
				},
				{
					creature_species = "baxmoth",
					volume_spawn_ratio = 0.2
				},
				{
					creature_species = "nurglax",
					volume_spawn_ratio = 0.2
				},
				{
					creature_species = "canceroth",
					volume_spawn_ratio = 0.2
				},
			},
			resource_units = 
			{
				{
					creature_species = "phirian_jungle",
					volume_spawn_ratio = 1
				},
			}        
		},
	}
	
	--GUEST UNITS
	-- Add Drexolians after completing Heart of the Swamp DLC
	if self.mission_params.biome_name == "magma" then
		if campaignData:GetStringOrDefault( "global.swamp_end", "" ) == "true" then -- REQUIREMENT: Finished Heart of the Swamp DLC
			table.insert( biome_creatures[self.mission_params.biome_name].liquid_units, 1, { creature_species = "drexolian_magma", volume_spawn_ratio = 1 } )
		end	
	end
	
	-- LUCKY CREATURE SPECIES MECHANIC - Pick a random regular creature species and multiply it's spawn ratio by a random number to make it more dominant
	local luckyCreature = RandInt( 1, #biome_creatures[self.mission_params.biome_name].regular_units )	
	LogService:Log("Lucky Creature Name = "..  biome_creatures[self.mission_params.biome_name].regular_units[luckyCreature].creature_species )
	LogService:Log("Lucky Creature Natural Spawn Ratio = ".. tostring( biome_creatures[self.mission_params.biome_name].regular_units[luckyCreature].volume_spawn_ratio ))
	
	if luckyCreature ~= "canceroth" then
		local luckyCreatureSpawnRatio = biome_creatures[self.mission_params.biome_name].regular_units[luckyCreature].volume_spawn_ratio * RandInt( 2, 10 )
	else  -- Canceroth spawn ratio multiplier has to be hard capped or it will kill performance
		luckyCreatureSpawnRatio = biome_creatures[self.mission_params.biome_name].regular_units[luckyCreature].volume_spawn_ratio * 2
	end
	LogService:Log("Lucky Creature Improved Spawn Ratio = ".. tostring( luckyCreatureSpawnRatio ))
	biome_creatures[self.mission_params.biome_name].regular_units[luckyCreature].volume_spawn_ratio = luckyCreatureSpawnRatio
	
	-- THREAT LEVEL CREATURE PARAMETERS	
	local threat_multipliers = 
	{
		[1]		= {0.25, 128},
		[2]		= {0.30, 120},
		[3]		= {0.35, 110},
		[4]		= {0.40, 100},
		[5]		= {0.50, 90},
		[6]		= {0.60, 80},
		[7]		= {0.70, 70},
		[8]		= {0.80, 60},
		[9]		= {0.90, 50},
		[10]	= {1.00, 40}
	}
	
	MapGenerator:SetCreatureVolumesDensity( threat_multipliers[self.mission_params.threat_level][1] or 5 )
	MapGenerator:SetCreatureVolumesDistanceFromPlayerSpawn( threat_multipliers[self.mission_params.threat_level][2] or 90 )	

    self:CreateAmbientCreatureSpawnRules( biome_ambient_creatures[self.mission_params.biome_name] )
    self:CreateCreatureSpawnRules( biome_creatures[self.mission_params.biome_name] )

-- MISSION OBJECT SPAWNERS
	local mission_object_spawners = {}
	
	-- MISSION SAFE ZONE MARKERS
	local mission_objective_marker = 
    {
        spawner_type                    = "MarkerBlueprintSpawner",

        spawn_pool                      = { "mission_objective" },
        spawn_at_marker                 = "logic/mission_objective_marker",
		silent_remove_after_spawn		= true,

        spawn_blueprints =
        {
            {
                spawn_blueprint         = "logic/position_marker",				
            }            
        }
    }
	
	-- BIOANOMALY AND BIOCACHE MISSION SPAWN MODIFIERS
	local bioanomaly_multipliers = 
	{
		[0]		= { 0.00, 250, 500 },
		[1]		= { 0.20, 250, 200 },
		[2]		= { 0.40, 225, 180 },
		[3]		= { 0.60, 200, 160 },
		[4]		= { 0.80, 175, 140 },
		[5]		= { 1.00, 150, 120 },
		[6]		= { 1.25, 140, 110 },
		[7]		= { 1.50, 130, 100 },
		[8]		= { 1.75, 120, 90 },
		[9]		= { 1.85, 100, 85 },
		[10]	= { 2.00, 80, 80 }		
	}
	
	self.missionBioanomaliesMultiplier = bioanomaly_multipliers[self.mission_params.bioanomalies][1] or 1
	self.missionBioanomaliesSpawnDistance = bioanomaly_multipliers[self.mission_params.bioanomalies][2] or 150
	self.missionBiocacheSpawnDistance = bioanomaly_multipliers[self.mission_params.bioanomalies][3] or 120
	
	if self.mission_params.mission_size >= 1 and self.mission_params.mission_size <= 3 then
		self.bioanomaly_spawn_instances_minmax = { min = 2 * self.missionBioanomaliesMultiplier, max = 4 * self.missionBioanomaliesMultiplier }
	elseif self.mission_params.mission_size >= 4 and self.mission_params.mission_size <= 6 then
		self.bioanomaly_spawn_instances_minmax = { min = 8 * self.missionBioanomaliesMultiplier, max = 12 * self.missionBioanomaliesMultiplier }
	elseif self.mission_params.mission_size >= 7 and self.mission_params.mission_size <= 10 then
		self.bioanomaly_spawn_instances_minmax = { min = 15 * self.missionBioanomaliesMultiplier, max = 20 * self.missionBioanomaliesMultiplier }
	end
	
	-- UNDERGROUND TREASURE MISSION SPAWN MODIFIERS	
	local underground_deposits_multipliers = 
	{
		[0] 	= 500,
		[1] 	= 250,
		[2] 	= 200,
		[3] 	= 170,
		[4] 	= 150,
		[5] 	= 125,
		[6] 	= 100,
		[7] 	= 90,
		[8] 	= 80,
		[9] 	= 70,
		[10] 	= 60
	}
	self.missionUndergroundTreasureDistance = underground_deposits_multipliers[self.mission_params.underground_deposits] or 125	    
    self.advancedOreItem = ResourceService:GetOreBlueprintFromVein( self.missionAdvancedResource[self.mission_params.biome_name] )
	-- BIOANOMALY
	local bioanomaly = 
    {
        spawner_type                    = "MarkerBlueprintSpawner",

        spawn_pool                      = { "loot_containers" },
        spawn_at_marker                 = "logic/spawn_objective",

        spawn_min_distance_from_pools = 
        {
            mission_objective   	    = 100,
			player_spawn_point          = 150.0,
            loot_containers             = self.missionBioanomaliesMultiplier,
            loot_containers_small       = 50.0,
			underground_treasures       = 50,
			resource_volumes            = 10
        },
		
		spawn_instances_minmax = self.bioanomaly_spawn_instances_minmax,

        spawn_blueprints =
        {
            {
                spawn_blueprint         = "spawners/" .. self.mission_params.biome_name .. "_spawner_standard",
                spawn_chance            = 0.5
            },
            {
                spawn_blueprint         = "spawners/" .. self.mission_params.biome_name .. "_spawner_advanced",
                --spawn_instances_minmax  = { min = 3, max = 5 },
                spawn_chance            = 0.2
            },
            {
                spawn_blueprint         = "spawners/" .. self.mission_params.biome_name .. "_spawner_superior",
                --spawn_instances_minmax  = { min = 2, max = 3 },
                spawn_chance            = 0.2
            },
            {
                spawn_blueprint         = "spawners/" .. self.mission_params.biome_name .. "_spawner_extreme",
                --spawn_instances_minmax  = { min = 1, max = 2 },
                spawn_chance            = 0.1,
            }
        }
    }
    -- BIOCACHE
	local biocache = 
    {
        spawner_type                    = "GridSpawner",
        spawn_pool                      = { "loot_containers_small" },
		spawn_min_free_cell_margin	    = 3,       
	
        spawn_min_distance_from_pools =
        {
            mission_objective   	    = 100,
			player_spawn_point          = 200,
            loot_containers             = 50,
            loot_containers_small       = self.missionBiocacheSpawnDistance,
            underground_treasures       = 10,
			resource_volumes		    = 10,
			enemy					    = 5,
			cryo_plants				    = 25,
			magnetic_rocks			    = 25
        },
	
        spawn_blueprints = 
        {
            {                    
                spawn_blueprint          = self.missionBiocacheName[self.mission_params.biome_name] .. "_standard",
                spawn_chance             = 0.25					
            },
            {                
                spawn_blueprint         = self.missionBiocacheName[self.mission_params.biome_name] .. "_advanced",
                spawn_chance            = 0.1
            },			
            {                 
                spawn_blueprint         = self.missionBiocacheName[self.mission_params.biome_name] .. "_superior",
                spawn_chance            = 0.1
            },				
            {                 
                spawn_blueprint         = self.missionBiocacheName[self.mission_params.biome_name] .. "_extreme",
                spawn_chance            = 0.05
            }				
        }
	}
	--POWERWELL
	local power_well = 
    {
        spawner_type                    = "GridSpawner",
        spawn_pool                      = { "power_well" },
		spawn_min_free_cell_margin	    = 5,
	
        spawn_min_distance_from_pools = 
        {
            player_spawn_point          = 50,
			mission_objective   	    = 100,
            loot_containers             = 50,
            loot_containers_small       = 50,
            underground_treasures       = 10,
			resource_volumes		    = 10,
			enemy					    = 5,
			power_well				    = 450,
			cryo_plants				    = 25,
			magnetic_rocks			    = 25,
        },
	
        spawn_blueprints =
        {
            {                    
                spawn_blueprint         = "props/special/power_wells/power_well_source_health",
                spawn_chance            = 0.1	
            },
            {                    
                spawn_blueprint         = "props/special/power_wells/power_well_source_forcefield",
                spawn_chance            = 0.1
            },                
            {
                spawn_blueprint         = "props/special/power_wells/power_well_source_cooldowns",
                spawn_chance            = 0.1
            },                
            {                 
                spawn_blueprint         = "props/special/power_wells/power_well_source_radar",
                spawn_chance            = 0.1
            },
            {                 
                spawn_blueprint         = "props/special/power_wells/power_well_source_building",
                spawn_chance            = 0.1
            },
            {                 
                spawn_blueprint         = "props/special/power_wells/power_well_source_loot",
                spawn_chance            = 0.1
            },
            {                 
                spawn_blueprint         = "props/special/power_wells/power_well_source_reflect_damage",
                spawn_chance            = 0.1
            },
            {                 
                spawn_blueprint         = "props/special/power_wells/power_well_source_drones",
                spawn_chance            = 0.1
            },
            {                 
                spawn_blueprint         = "props/special/power_wells/power_well_source_ammo",
                spawn_chance            = 0.1
            },
            {                 
                spawn_blueprint         = "props/special/power_wells/power_well_source_firerate",
                spawn_chance            = 0.1
            },
            {                 
                spawn_blueprint         = "props/special/power_wells/power_well_source_damage",
                spawn_chance            = 0.1
            }					
        }
	}
	--UNDERGROUND TREASURE
	local underground_treasure = 
    {
        spawner_type                    = "GridSpawner",
        spawn_pool                      = { "underground_treasures" },
	
        spawn_min_free_cell_margin	    = 3,
	
        spawn_min_distance_from_pools = 
        {
            player_spawn_point          = 150,
            mission_objective   	    = 100,
            loot_containers             = 50,
            loot_containers_small       = 50,
            underground_treasures       = self.missionUndergroundTreasureDistance,
            resource_volumes		    = 10,
            enemy					    = 5,
            power_well				    = 15,
            cryo_plants				    = 15,
            magnetic_rocks			    = 15
        },
	
        spawn_blueprints = 
        {
            {
                spawn_blueprint             = "spawners/loot_spawner",                    
				spawn_chance            	= 0.1,
                spawn_discoverable_level    = 1,
	
                database =
                {	
                    blueprint 	     = "items/loot/resources/shard_carbonium_item",
                    min   	 	     = 200,
                    max   	 	     = 500,
                    package_size     = 5
                }
            },
            {
                spawn_blueprint             = "spawners/loot_spawner",                    
				spawn_chance            	= 0.1,
                spawn_discoverable_level    = 1,
	
                database =
                {	
                    blueprint 	            = "items/loot/resources/shard_steel_item",
                    min   	 	            = 200,
                    max   	 	            = 500,
                    package_size            = 5
                }
            },
            {
                spawn_blueprint              = "spawners/loot_spawner",                    
				spawn_chance            	= 0.3,
                spawn_discoverable_level    = 1,
	
                database =
                {	
                    blueprint 	    = "items/loot/resources/shard_".. self.missionRareResource[self.mission_params.biome_name] .. "_item",
                    min   	 	= 50 * self.missionRareResourceMultiplier,
                    max   	 	= 100 * self.missionRareResourceMultiplier
                }
            },  
            {
                spawn_blueprint             = "spawners/loot_spawner",                    
				spawn_chance            	= 0.5,
                spawn_discoverable_level    = 1,
	
                database =
                {	
                    blueprint 	    = self.advancedOreItem ,
                    min   	 	    = 200 * self.missionAdvancedResourceMultiplier,
                    max   	 	    = 500 * self.missionAdvancedResourceMultiplier,
                    package_size    = 5
                }
            }    
        }
    }
    
	--================ BIOANOMALY CLUSTER ENCOUNTER
	-- Primary Bioanomaly that others spawn around
	local bioanomalyClusterPrimary = 
	{
        spawner_type                    = "MarkerBlueprintSpawner",

        spawn_pool                      = { "loot_containers", "bioanomaly_cluster" },
        spawn_at_marker                 = "logic/spawn_objective",

        spawn_min_distance_from_pools = 
        {
            player_spawn_point          = 250.0,
            loot_containers             = 150.0,
			underground_treasures       = 50,
			resource_volumes            = 20
        },

        spawn_instances_minmax = { min = 1, max = 1 },

        spawn_blueprints =
        {                
            {
                spawn_blueprint         = "spawners/" .. self.mission_params.biome_name .. "_spawner_extreme"                    
            }
        }        
	}
	-- Secondary smaller bioanomalies
	local bioanomalyClusterSecondary = 
	{
		spawner_type                    = "GridSpawner",

		spawn_pool                      = { "loot_containers" },
		spawn_min_free_cell_margin	    = 3,
       

		spawn_min_distance_from_pools = 
		{
			bioanomaly_cluster          = 20,
			loot_containers             = 15,
			underground_treasures       = 50,
			resource_volumes            = 5
		},
		
		spawn_max_distance_from_pools = 
		{                
			bioanomaly_cluster            = 30
		},

		spawn_instances_minmax = { min = 3, max = 3 },

		spawn_blueprints =
		{
			{
				spawn_blueprint         = "spawners/" .. self.mission_params.biome_name .. "_spawner_standard",
				spawn_chance            = 0.5
			},
			{
				spawn_blueprint         = "spawners/" .. self.mission_params.biome_name .. "_spawner_advanced",                    
				spawn_chance            = 0.2
			},
			{
				spawn_blueprint         = "spawners/" .. self.mission_params.biome_name .. "_spawner_superior",                    
				spawn_chance            = 0.2
			},
			--{
			--	spawn_blueprint         = "spawners/" .. self.mission_params.biome_name .. "_spawner_extreme",                    
			--	spawn_chance            = 0.1,
			--}
		}       
	}
	-- Additional Biocaches
	local biocacheCluster = 
	{
		spawner_type                    = "GridSpawner",

		spawn_pool                      = { "loot_containers_small" },
		spawn_min_free_cell_margin	    = 3,
       

		spawn_min_distance_from_pools = 
		{
			bioanomaly_cluster          = 20,
			loot_containers             = 10,
			loot_containers_small       = 20,
			underground_treasures       = 50,
			resource_volumes            = 5
		},
		
		spawn_max_distance_from_pools = 
		{                
			bioanomaly_cluster            = 50
		},

		spawn_instances_minmax = { min = 10, max = 10 },

		spawn_blueprints = 
        {
            {                    
                spawn_blueprint          = self.missionBiocacheName[self.mission_params.biome_name] .. "_standard",
                spawn_chance             = 0.25					
            },
            {                
                spawn_blueprint         = self.missionBiocacheName[self.mission_params.biome_name] .. "_advanced",
                spawn_chance            = 0.1
            },			
            {                 
                spawn_blueprint         = self.missionBiocacheName[self.mission_params.biome_name] .. "_superior",
                spawn_chance            = 0.1
            },				
            {                 
                spawn_blueprint         = self.missionBiocacheName[self.mission_params.biome_name] .. "_extreme",
                spawn_chance            = 0.05
            }				
        } 
	}
	
	--if self.mission_params.bioanomalies == "extreme" then
	--	--LogService:Log("Lucky Object Name = ".. mission_object_spawners[1].spawn_blueprints[4].spawn_blueprint )
	--	--LogService:Log("Lucky Object Value = ".. tostring( mission_object_spawners[1].spawn_blueprints[4].spawn_chance ))
	--	--mission_object_spawners[1].spawn_blueprints[4].spawn_chance = 10
	--	
	--	table.insert(mission_object_spawners, 1, bioanomalyClusterPrimary )
	--	table.insert(mission_object_spawners, 2, bioanomalyClusterSecondary )
	--	table.insert(mission_object_spawners, 3, biocacheCluster )
	--	--LogService:Log("Lucky Object Improved Value = ".. tostring( mission_object_spawners[1].spawn_blueprints[4].spawn_chance ))
	--end
	--================ BIOANOMALY CLUSTER ENCOUNTER	
	
	--================ BIOCACHE CLUSTER ENCOUNTER
	-- Primary Biocache that others spawn around
	local biocacheClusterPrimary = 
	{
        spawner_type                    = "MarkerBlueprintSpawner",

        spawn_pool                      = { "loot_containers_small", "biocache_cluster" },
        spawn_at_marker                 = "logic/spawn_objective",

        spawn_min_distance_from_pools = 
        {
            biocache_cluster	        = 250.0,
            player_spawn_point          = 250.0,
            loot_containers             = 150.0,
			underground_treasures       = 50,
			resource_volumes            = 20
        },

        spawn_instances_minmax = { min = 3, max = 3 },

        spawn_blueprints =
        {                
            {
                spawn_blueprint         = self.missionBiocacheName[self.mission_params.biome_name] .. "_extreme"                    
            }
        }        
	}
	
	-- Additional Biocaches
	local biocacheCluster = 
	{
		spawner_type                    = "GridSpawner",

		spawn_pool                      = { "loot_containers_small" },
		spawn_min_free_cell_margin	    = 3,
       

		spawn_min_distance_from_pools = 
		{
			biocache_cluster       		= 15,
			loot_containers             = 10,
			loot_containers_small       = 10,
			underground_treasures       = 50,
			resource_volumes            = 5			
		},
		
		spawn_max_distance_from_pools = 
		{                
			biocache_cluster            = 23
		},

		--spawn_instances_minmax = { min = 10, max = 10 },

		spawn_blueprints = 
        {
            {                    
                spawn_blueprint          = self.missionBiocacheName[self.mission_params.biome_name] .. "_standard",
                spawn_chance             = 0.25					
            },
            {                
                spawn_blueprint         = self.missionBiocacheName[self.mission_params.biome_name] .. "_advanced",
                spawn_chance            = 0.1
            },			
            {                 
                spawn_blueprint         = self.missionBiocacheName[self.mission_params.biome_name] .. "_superior",
                spawn_chance            = 0.1
            },				
            --{                 
            --    spawn_blueprint         = self.missionBiocacheName[self.mission_params.biome_name] .. "_extreme",
            --    spawn_chance            = 0.05
            --}				
        } 
	}
	
	--if luckySpawn == bioanomaly then
		--LogService:Log("Lucky Object Name = ".. mission_object_spawners[1].spawn_blueprints[4].spawn_blueprint )
		--LogService:Log("Lucky Object Value = ".. tostring( mission_object_spawners[1].spawn_blueprints[4].spawn_chance ))		
		
		--table.insert(mission_object_spawners, 1, biocacheClusterPrimary )		
		--table.insert(mission_object_spawners, 2, biocacheCluster )
		--LogService:Log("Lucky Object Improved Value = ".. tostring( mission_object_spawners[1].spawn_blueprints[4].spawn_chance ))
	--end
	
	--================ BIOCACHE CLUSTER ENCOUNTER
	
	--================ UNDERGROUND TREASURE CLUSTER ENCOUNTER
	-- A few clusters of underground treasures instead of many singular treasure caches
	-- Underground Treasure Cluster Center
	local undergroundTreasureClusterPrimary = 
	{
        spawner_type                    = "GridSpawner",
        spawn_pool                      = { "underground_treasures", "underground_treasure_cluster_primary" },
		
        spawn_min_free_cell_margin	    = 5,
		
        spawn_min_distance_from_pools = 
        {
            player_spawn_point          = 150,
            mission_objective   	    = 100,
            loot_containers             = 50,
            loot_containers_small       = 50,
            underground_treasures       = 100,
            resource_volumes		    = 10,
            enemy					    = 5,
            power_well				    = 15,
            cryo_plants				    = 15,
            magnetic_rocks			    = 15,
			underground_treasure_cluster_primary = 150
        },
		
        spawn_blueprints = 
        {
            {
                spawn_blueprint             = "spawners/loot_spawner",
                spawn_instances_minmax      = { min = 3, max = 5 },
                spawn_discoverable_level    = 1,
		
                database =
                {	
                    blueprint 	    = self.advancedOreItem ,
                    min   	 	     = 500 * self.missionAdvancedResourceMultiplier,
                    max   	 	     = 1000 * self.missionAdvancedResourceMultiplier,
                    package_size     = 15
                }
            }                    
        }
    }
	-- Underground Treasure Cluster Additional Treasures
	local undergroundTreasureCluster = 
	{
        spawner_type                    = "GridSpawner",
        spawn_pool                      = { "underground_treasures" },
        spawn_min_free_cell_margin	    = 3,
        spawn_min_distance_from_pools = 
        {
            player_spawn_point          = 150,
            mission_objective   	    = 100,
            loot_containers             = 50,
            loot_containers_small       = 50,            
            resource_volumes		    = 10,
            enemy					    = 5,
            power_well				    = 15,
            cryo_plants				    = 15,
            magnetic_rocks			    = 15,
			underground_treasure_cluster_primary = 10,
			underground_treasures       = 10
        },
		spawn_max_distance_from_pools = 
		{                
			underground_treasure_cluster_primary = 30
		},
        spawn_blueprints = 
        {
            {
                spawn_blueprint             = "spawners/loot_spawner",                
                spawn_discoverable_level    = 1,
				spawn_chance            	= 0.25,
                database =
                {	
                    blueprint 	     = "items/loot/resources/shard_carbonium_item",
                    min   	 	     = 200,
                    max   	 	     = 500,
                    package_size     = 5
                }
            },
            {
                spawn_blueprint             = "spawners/loot_spawner",                
                spawn_discoverable_level    = 1,
				spawn_chance            	= 0.25,
                database =
                {	
                    blueprint 	            = "items/loot/resources/shard_steel_item",
                    min   	 	            = 200,
                    max   	 	            = 500,
                    package_size            = 5
                }
            },
            {
                spawn_blueprint              = "spawners/loot_spawner",                
                spawn_discoverable_level    = 1,
				spawn_chance            	= 0.25,
                database =
                {	
                    blueprint 	    = "items/loot/resources/shard_".. self.missionRareResource[self.mission_params.biome_name] .. "_item",
                    min   	 	= 50 * self.missionRareResourceMultiplier,
                    max   	 	= 100 * self.missionRareResourceMultiplier
                }
            },  
            {
                spawn_blueprint             = "spawners/loot_spawner",                
                spawn_discoverable_level    = 1,
				spawn_chance            	= 0.25,
                database =
                {	
                    blueprint 	    = self.advancedOreItem ,
                    min   	 	    = 200 * self.missionAdvancedResourceMultiplier,
                    max   	 	    = 500 * self.missionAdvancedResourceMultiplier,
                    package_size    = 5
                }
            }    
        }
    }
	
	--if luckySpawn == undergroundtreasure then
		--LogService:Log("Lucky Object Name = ".. mission_object_spawners[1].spawn_blueprints[4].spawn_blueprint )
		--LogService:Log("Lucky Object Value = ".. tostring( mission_object_spawners[1].spawn_blueprints[4].spawn_chance ))		
		
		--table.insert(mission_object_spawners, 1, undergroundTreasureClusterPrimary )		
		--table.insert(mission_object_spawners, 2, undergroundTreasureCluster )
		--LogService:Log("Lucky Object Improved Value = ".. tostring( mission_object_spawners[1].spawn_blueprints[4].spawn_chance ))
	--end
	
	--================ UNDERGROUND TREASURE CLUSTER ENCOUNTER END
	
	--================ SPECIAL BIOME SPECIFIC OBJECTS
	--== MAGMA
	local cryoPlants =
    {
		spawner_type                    = "MarkerBlueprintSpawner",
        spawn_pool                      = { "cryo_plants" },

        spawn_at_marker                 = "logic/spawn_special_object",

        spawn_min_distance_from_pools =
        {
            player_spawn_point          = 20.0,
            loot_containers             = 15.0,
            magnetic_rocks  	        = 10.0,
            cryo_plants		            = 10.0,
            resource_volumes	        = 5,
        },

        spawn_instances_minmax          = { min = 0, max = 0 },
        spawn_density                   = 0.25,

        spawn_blueprints = 
        {
            {
                spawn_blueprint         = "props/special/cryo_plant/cryo_plant_big_01",
                spawn_chance            = 0.1
            },
            {
                spawn_blueprint         = "props/special/cryo_plant/cryo_plant_big_02",
                spawn_chance            = 0.1
            },
            {
                spawn_blueprint         = "props/special/cryo_plant/cryo_plant_big_03",
                spawn_chance            = 0.1
            },
            {                    
                spawn_blueprint         = "props/special/cryo_plant/cryo_plant_medium_01",
                spawn_chance            = 0.15
            },
            {                    
                spawn_blueprint         = "props/special/cryo_plant/cryo_plant_medium_02",
                spawn_chance            = 0.15
            },
            {                    
                spawn_blueprint         = "props/special/cryo_plant/cryo_plant_medium_03",
                spawn_chance            = 0.15
            },
            {                    
                spawn_blueprint         = "props/special/cryo_plant/cryo_plant_small_01",
                spawn_chance            = 0.15
            },
            {                    
                spawn_blueprint         = "props/special/cryo_plant/cryo_plant_small_01",
                spawn_chance            = 0.15
            },
            {                    
                spawn_blueprint         = "props/special/cryo_plant/cryo_plant_small_01",
                spawn_chance            = 0.15
            } 				
        }	
	}
	
	local magneticRocks =
	{
		spawner_type                    = "MarkerBlueprintSpawner",
		spawn_pool                      = { "magnetic_rocks" },
		spawn_at_marker                 = "logic/spawn_special_object",

		spawn_min_distance_from_pools   = 
		{
			player_spawn_point          = 70.0,
			loot_containers             = 15.0,
			cryo_plants     	        = 10.0,
			magnetic_rocks     	        = 20.0,
			resource_volumes   	        = 10.0
		},

		spawn_instances_minmax          = { min = 0, max = 0 },
		spawn_density                   = 0.175,

		spawn_blueprints =
		{
			{
				spawn_blueprint         = "props/special/magnetic_rocks/magnetic_big_01",
				spawn_chance            = 0.15
			},
			{                    
				spawn_blueprint         = "props/special/magnetic_rocks/magnetic_big_02",
				spawn_chance            = 0.15
			},
			{                    
				spawn_blueprint         = "props/special/magnetic_rocks/magnetic_big_03",
				spawn_chance            = 0.15
			},
			{                    
				spawn_blueprint         = "props/special/magnetic_rocks/magnetic_medium_01",
				spawn_chance            = 0.1
			},
			{                    
				spawn_blueprint         = "props/special/magnetic_rocks/magnetic_medium_02",
				spawn_chance            = 0.1
			},
			{                    
				spawn_blueprint         = "props/special/magnetic_rocks/magnetic_medium_03",
				spawn_chance            = 0.1
			},
			{                    
				spawn_blueprint         = "props/special/magnetic_rocks/magnetic_small_01",
				spawn_chance            = 0.1
			},
			{                    
				spawn_blueprint         = "props/special/magnetic_rocks/magnetic_small_02",
				spawn_chance            = 0.1
			}, 
			{                    
				spawn_blueprint         = "props/special/magnetic_rocks/magnetic_small_03",
				spawn_chance            = 0.1
			}  
		}
    }
	--== ACID
	local yeast_colony_large = 
    {
		spawner_type                    = "MarkerBlueprintSpawner",
		spawn_pool                      = { "yeast_root" },
		spawn_at_marker                 = "logic/spawn_objective",        
		spawn_team               		= "enemy",
    
		spawn_instances_minmax          = { min = 1, max = 1 },
		
		spawn_min_distance_from_pools   = 
		{
			player_spawn_point          = 250,
			loot_containers             = 50,			
			resource_volumes   	        = 10
		},		
		
		spawn_max_distance_from_pools   = 
		{
			player_spawn_point          = 450			
		},	

		spawn_blueprints =
		{
			{
				spawn_blueprint         = "units/ground/creeper_root_origin"				
			},
		}
    }
	
	local yeast_colony_small = 
	{
		spawner_type                    = "GridSpawner",
		spawn_pool                      = { "yeast_singular" },		
		spawn_team               		= "enemy",
		
		spawn_instances_minmax          = { min = 30, max = 50 },
		
		spawn_min_distance_from_pools   = 
		{
			player_spawn_point          = 100,
			mission_objective	        = 70,
			yeast_root			        = 150,
			yeast_singular		        = 50,
			loot_containers             = 70,			
			loot_containers_small       = 30,			
			underground_treasures	    = 70,			
			underground_mushrooms	    = 70,			
			power_well				    = 30,			
			resource_volumes   	        = 5
		},	
		spawn_blueprints =
		{
			{
				spawn_blueprint         = "units/ground/creeper_root_acid_singular"				
			},
		}		
	}
	
	local underground_mushrooms =
	{
		spawner_type                    = "GridSpawner",
		spawn_pool                      = { "underground_mushrooms" },		
		spawn_team               		= "enemy",
		spawn_min_free_cell_margin		= 2,
		
		spawn_min_distance_from_pools   = 
		{
			player_spawn_point          = 100,
			mission_objective	        = 70,
			yeast_root			        = 150,
			yeast_singular		        = 15,
			loot_containers             = 70,			
			loot_containers_small       = 30,			
			underground_treasures	    = 70,			
			underground_mushrooms	    = 180,			
			power_well				    = 30,			
			resource_volumes   	        = 5
		},	
		spawn_blueprints =
		{
			{
				spawn_blueprint         = "props/special/undergound_mushroom/undergound_mushroom_hidden",				
				spawn_group_radius			= 30,
				spawn_group_count			= 15,
				spawn_group_object_distance	= 5	
			},
		}	
	}
	
	--== CAVERNS
	
	local wind_tunnels_starting = 
    {
		spawner_type                    = "MarkerBlueprintSpawner",
		spawn_pool                      = { "resource_volumes" },
		spawn_at_marker                 = "resources/volume_random_resources",        		
    
		spawn_instances_minmax          = { min = 1, max = 1 },
		
		spawn_min_distance_from_pools   = 
		{			
			player_spawn_point          = 10,
			mission_objective	        = 70,
			loot_containers             = 20,			
			loot_containers_small       = 20,			
			underground_treasures       = 10,			
			power_well					= 10,			
			resource_volumes   	        = 10
		},		
		
		spawn_max_distance_from_pools   = 
		{
			player_spawn_point          = 64,
		},	

		spawn_blueprints =
		{
			{
				spawn_blueprint         = "weather/cave_wind_spot_small"
			},
		}
    }
	
	local wind_tunnels = 
    {
		spawner_type                    = "MarkerBlueprintSpawner",
		spawn_pool                      = { "resource_volumes" },
		spawn_at_marker                 = "resources/volume_random_resources",        		
    
		spawn_instances_minmax          = { min = 15 * self.missionWindTunnelMultiplier, max = 20 * self.missionWindTunnelMultiplier },
		
		spawn_min_distance_from_pools   = 
		{
			player_spawn_point          = 10,
			mission_objective	        = 70,
			loot_containers             = 20,			
			loot_containers_small       = 20,			
			underground_treasures       = 10,			
			power_well					= 10,			
			resource_volumes   	        = 10
		},		

		spawn_blueprints =
		{
			{
				spawn_blueprint         = "weather/cave_wind_spot_small"
			},
		}
    }
	
	--== METALLIC
	local tower_plasma = 
	{
		spawner_type                    = "GridSpawner",
		spawn_pool                      = { "tower_alien", "enemy" },		
		spawn_team               		= "enemy",
		spawn_min_free_cell_margin		= 3,
		
		spawn_min_distance_from_pools   = 
		{
			player_spawn_point          = 150,
			mission_objective	        = 70,			
			loot_containers             = 15,			
			loot_containers_small       = 8,			
			underground_treasures	    = 5,						
			power_well				    = 30,			
			tower_alien				    = 10,			
			enemy					    = 5,			
			resource_volumes   	        = 5
		},
		spawn_max_distance_from_pools   = 
		{						
			loot_containers             = 30,						
		},	
		spawn_blueprints =
		{
			{
				spawn_blueprint         = "units/ground/alien_tower_plasma_spawner",					
				spawn_chance			= 0.25,
				spawn_culls_entities_around	= true
			},
			{
				spawn_blueprint         = "logic/position_marker",
				spawn_chance			= 0.75,
				spawn_culls_entities_around	= false
			},
		}		
	}
	
	local tower_artillery = 
	{
		spawner_type                    = "GridSpawner",
		spawn_pool                      = { "tower_alien", "enemy" },		
		spawn_team               		= "enemy",
		spawn_min_free_cell_margin		= 3,
		
		spawn_min_distance_from_pools   = 
		{
			player_spawn_point          = 150,
			mission_objective	        = 70,			
			loot_containers             = 8,			
			loot_containers_small       = 8,			
			underground_treasures	    = 5,						
			power_well				    = 30,			
			tower_alien				    = 10,			
			enemy					    = 5,			
			resource_volumes   	        = 5
		},
		spawn_max_distance_from_pools   = 
		{						
			loot_containers					= 20,						
		},	
		spawn_blueprints =
		{
			{
				spawn_blueprint         = "units/ground/alien_tower_artillery_spawner",	
				spawn_chance			= 0.25,
				spawn_culls_entities_around	= true
			},
			{
				spawn_blueprint         = "logic/position_marker",
				spawn_chance			= 0.75,
				spawn_culls_entities_around	= false
			},
		}		
	}
	
	--==SWAMP
	local poogret_plants = 
	{
		spawner_type                    = "GridSpawner",
		spawn_pool                      = { "poogret_plants" },				
		spawn_min_free_cell_margin		= 5,
		--spawn_within_destructible_volumes	= 0,
		
		spawn_min_distance_from_pools   = 
		{
			poogret_plants				= 200,
			player_spawn_point          = 150,
			mission_objective	        = 70,			
			loot_containers             = 30,			
			loot_containers_small       = 20,			
			underground_treasures	    = 5,						
			power_well				    = 30,						
			resource_volumes   	        = 10
		},		
		spawn_blueprints =
		{
			{
				spawn_blueprint         = "props/special/interactive/poogret_plant_big_01",					
			},			
		}		
	}
	-- invigors around poogret plants
	local invigor = 
	{
		spawner_type                    = "GridSpawner",
		spawn_pool                      = { "tower_plant", "enemy" },		
		spawn_team               		= "enemy",
		spawn_min_free_cell_margin		= 1,
		spawn_within_destructible_volumes = false,
		
		spawn_min_distance_from_pools   = 
		{
			player_spawn_point          = 120,
			mission_objective	        = 70,			
			loot_containers             = 5,			
			loot_containers_small       = 5,			
			underground_treasures	    = 5,						
			power_well				    = 10,			
			tower_plant				    = 15,			
			enemy					    = 5,			
			resource_volumes   	        = 5
		},
		spawn_max_distance_from_pools   = 
		{						
			poogret_plants				= 15,						
		},	
		spawn_blueprints =
		{
			{
				spawn_blueprint         = "units/ground/invigor",	
				spawn_chance			= 0.3,
				spawn_culls_entities_around	= false
			},
			{
				spawn_blueprint         = "logic/position_marker",
				spawn_chance			= 0.7,
				spawn_culls_entities_around	= false
			},
		}		
	}
	
	-- artigians around bioanomalies
	local artigian = 
	{
		spawner_type                    = "GridSpawner",
		spawn_pool                      = { "tower_plant", "enemy" },		
		spawn_team               		= "enemy",
		spawn_min_free_cell_margin		= 3,
		spawn_within_destructible_volumes = false,
		
		spawn_min_distance_from_pools   = 
		{
			player_spawn_point          = 120,
			mission_objective	        = 70,			
			loot_containers             = 8,			
			loot_containers_small       = 8,			
			underground_treasures	    = 5,						
			power_well				    = 10,			
			tower_plant				    = 12,			
			enemy					    = 5,			
			resource_volumes   	        = 5,
			poogret_plants				= 5
		},
		spawn_max_distance_from_pools   = 
		{						
			loot_containers				= 20,						
		},	
		spawn_blueprints =
		{
			{
				spawn_blueprint         = "units/ground/artigian",	
				spawn_chance			= 0.25,
				spawn_culls_entities_around	= false
			},
			{
				spawn_blueprint         = "logic/position_marker",
				spawn_chance			= 0.75,
				spawn_culls_entities_around	= false
			},
		}		
	}
	-- ambient carnicinths
	local carnicinth =
    {
		spawner_type                    = "MarkerBlueprintSpawner",
        spawn_pool                      = { "carnicinth,enemy" },

        spawn_at_marker                 = "logic/spawn_prefab_marker_carnicinth",

        spawn_min_distance_from_pools =
        {
            player_spawn_point          = 120,
			mission_objective	        = 70,			
			loot_containers             = 5,			
			loot_containers_small       = 5,			
			underground_treasures	    = 2,						
			power_well				    = 5,			
			tower_plant				    = 5,			
			enemy					    = 5,			
			resource_volumes   	        = 2,
			poogret_plants				= 5
        },
		
        spawn_blueprints = 
        {
            {
                spawn_blueprint         		= "units/ground/carnicinth",
                spawn_culls_entities_around 	= false,
				spawn_chance            		= 0.4
				
            },
			{
                spawn_blueprint         		= "props/bush/standard_medium_01_skin13",
                spawn_culls_entities_around 	= false,
				spawn_chance            		= 0.6
				
            },
        }	
	}
	local carnicinth_alpha =
    {
		spawner_type                    = "MarkerBlueprintSpawner",
        spawn_pool                      = { "carnicinth,enemy" },

        spawn_at_marker                 = "logic/spawn_prefab_marker_carnicinth_alpha",

        spawn_min_distance_from_pools =
        {
            player_spawn_point          = 120,
			mission_objective	        = 70,			
			loot_containers             = 5,			
			loot_containers_small       = 5,			
			underground_treasures	    = 2,						
			power_well				    = 5,			
			tower_plant				    = 5,									
			resource_volumes   	        = 2,
			poogret_plants				= 5
        },
        spawn_blueprints = 
        {
            {
                spawn_blueprint         		= "units/ground/carnicinth_alpha",
                spawn_culls_entities_around 	= false,
				spawn_chance            		= 0.4
				
            },
			{
                spawn_blueprint         		= "props/bush/standard_medium_01_skin14",
                spawn_culls_entities_around 	= false,
				spawn_chance            		= 0.6
				
            },
        }	
	}
	-- ambient drexolians
	local drexolian =
    {
		spawner_type                    = "MarkerBlueprintSpawner",
        spawn_pool                      = { "drexolian,enemy" },

        spawn_at_marker                 = "logic/spawn_prefab_marker_drexolian",

        spawn_min_distance_from_pools =
        {
            player_spawn_point          = 120,
			mission_objective	        = 70,			
			loot_containers             = 5,			
			loot_containers_small       = 5,			
			underground_treasures	    = 2,						
			power_well				    = 5,			
			tower_plant				    = 5,									
			resource_volumes   	        = 2,
			poogret_plants				= 5
        },
		
        spawn_blueprints = 
        {
            {
                spawn_blueprint         		= "units/ground/drexolian",
                spawn_culls_entities_around 	= false,
				spawn_chance            		= 0.5
				
            },
			{
                spawn_blueprint         		= "props/trees/drexolian_big_03",
                spawn_culls_entities_around 	= false,
				spawn_chance            		= 0.5
				
            },
        }	
	}
	local drexolian_alpha =
    {
		spawner_type                    = "MarkerBlueprintSpawner",
        spawn_pool                      = { "drexolian,enemy" },

        spawn_at_marker                 = "logic/spawn_prefab_marker_drexolian_alpha",

        spawn_min_distance_from_pools =
        {
            player_spawn_point          = 120,
			mission_objective	        = 70,			
			loot_containers             = 5,			
			loot_containers_small       = 5,			
			underground_treasures	    = 2,						
			power_well				    = 5,														
			resource_volumes   	        = 2,
			poogret_plants				= 5
        },
		
        spawn_blueprints = 
        {
            {
                spawn_blueprint         		= "units/ground/drexolian_alpha",
                spawn_culls_entities_around 	= false,
				spawn_chance            		= 0.5
				
            },
			{
                spawn_blueprint         		= "props/trees/drexolian_big_03_skin1",
                spawn_culls_entities_around 	= false,
				spawn_chance            		= 0.5
				
            },
        }	
	}
	
	-- CREATE BASE MISSION OBJECT SPAWNERS TABLE
	table.insert(mission_object_spawners, 1, mission_objective_marker )
	if self.missionBioanomaliesMultiplier ~= 0 then
		table.insert(mission_object_spawners, #mission_object_spawners + 1, bioanomaly )
		table.insert(mission_object_spawners, #mission_object_spawners + 1, biocache )		
	end
	
	table.insert(mission_object_spawners, #mission_object_spawners + 1, underground_treasure )
	
	if self.mission_params.biome_name == "magma" then
		table.insert(mission_object_spawners, #mission_object_spawners + 1, cryoPlants )
		table.insert(mission_object_spawners, #mission_object_spawners + 1, magneticRocks )
	elseif self.mission_params.biome_name == "acid" then
		table.insert(mission_object_spawners, #mission_object_spawners + 1, yeast_colony_large )
		table.insert(mission_object_spawners, #mission_object_spawners + 1, yeast_colony_small )
		table.insert(mission_object_spawners, #mission_object_spawners + 1, underground_mushrooms )
	elseif self.mission_params.biome_name == "caverns" then
		table.insert(mission_object_spawners, #mission_object_spawners + 1, wind_tunnels_starting )
		table.insert(mission_object_spawners, #mission_object_spawners + 1, wind_tunnels )
	elseif self.mission_params.biome_name == "metallic" then
		table.insert(mission_object_spawners, #mission_object_spawners + 1, tower_plasma )		
		table.insert(mission_object_spawners, #mission_object_spawners + 1, tower_artillery )		
	elseif self.mission_params.biome_name == "swamp" then
		table.insert(mission_object_spawners, #mission_object_spawners + 1, poogret_plants )				
		table.insert(mission_object_spawners, #mission_object_spawners + 1, artigian )			
		table.insert(mission_object_spawners, #mission_object_spawners + 1, invigor )			
		table.insert(mission_object_spawners, #mission_object_spawners + 1, carnicinth )			
		table.insert(mission_object_spawners, #mission_object_spawners + 1, carnicinth_alpha )			
		table.insert(mission_object_spawners, #mission_object_spawners + 1, drexolian )			
		table.insert(mission_object_spawners, #mission_object_spawners + 1, drexolian_alpha )		
	end
	if self.missionBioanomaliesMultiplier ~= 0 then		
		table.insert(mission_object_spawners, #mission_object_spawners + 1, power_well )
	end
	
	--======= LUCKY ENCOUNTER RANDOMIZER
	self.luckyEncounterPool =
	{
		"bioanomaly",
		"biocache",
		"underground_treasure"
	}
	
	self.luckyEncounter = self.luckyEncounterPool[RandInt( 1, #self.luckyEncounterPool )]
	LogService:Log("Lucky Encounter Name = ".. self.luckyEncounter )
		
	if self.luckyEncounter == "bioanomaly" and self.missionBioanomaliesMultiplier ~= 0 then
		table.insert(mission_object_spawners, 2, bioanomalyClusterPrimary )
		table.insert(mission_object_spawners, 3, bioanomalyClusterSecondary )
		table.insert(mission_object_spawners, 4, biocacheCluster )
	elseif self.luckyEncounter == "biocache" and self.missionBioanomaliesMultiplier ~= 0 then		
		table.insert(mission_object_spawners, 2, biocacheClusterPrimary )		
		table.insert(mission_object_spawners, 3, biocacheCluster )
	elseif self.luckyEncounter == "underground_treasure" then
		table.insert(mission_object_spawners, 2, undergroundTreasureClusterPrimary )		
		table.insert(mission_object_spawners, 3, undergroundTreasureCluster )		
	end
	
	--======= SPAWN MISSION OBJECTS

    self:CreateMissionObjectSpawnRules( mission_object_spawners )	

--=================== RESOURCE VOLUMES	
	local ResourceVolume = function( resource, min_spawned, max_spawned, min_amount, max_amount, extra_params, mission_mul )
	
		mission_mul = mission_mul or self.mission_params:GetResourceAmount( resource)
		extra_params = extra_params or {}
		extra_params.resource = resource
		extra_params.min_resources = min_amount
		extra_params.max_resources = max_amount

        extra_params.min_spawned_volumes = min_spawned
        extra_params.max_spawned_volumes = max_spawned
		-- Mission based resource multipliers
		if mission_mul ~= nil then
			-- Multiply amount of finite resources			
			if extra_params.is_infinite ~= true then
				if mission_mul == 1 then
					extra_params.min_resources = extra_params.min_resources * 0.15
					extra_params.max_resources = extra_params.max_resources * 0.15					
				elseif mission_mul == 2 then
					extra_params.min_resources = extra_params.min_resources * 0.25
					extra_params.max_resources = extra_params.max_resources * 0.25					
				elseif mission_mul == 3 then
					extra_params.min_resources = extra_params.min_resources * 0.5
					extra_params.max_resources = extra_params.max_resources * 0.5					
				elseif mission_mul == 4 then
					extra_params.min_resources = extra_params.min_resources * 0.75
					extra_params.max_resources = extra_params.max_resources * 0.75					
				elseif mission_mul == 5 then
					extra_params.min_resources = extra_params.min_resources * 1
					extra_params.max_resources = extra_params.max_resources * 1					
				elseif mission_mul == 6 then
					extra_params.min_resources = extra_params.min_resources * 1.25
					extra_params.max_resources = extra_params.max_resources * 1.25					
				elseif mission_mul == 7 then
					extra_params.min_resources = extra_params.min_resources * 1.5
					extra_params.max_resources = extra_params.max_resources * 1.5					
				elseif mission_mul == 8 then
					extra_params.min_resources = extra_params.min_resources * 1.75
					extra_params.max_resources = extra_params.max_resources * 1.75					
				elseif mission_mul == 9 then
					extra_params.min_resources = extra_params.min_resources * 2
					extra_params.max_resources = extra_params.max_resources * 2					
				elseif mission_mul == 10 then
					extra_params.min_resources = extra_params.min_resources * 2.5
					extra_params.max_resources = extra_params.max_resources * 2.5					
				end
			end
			--Multiply number of resource volumes	
			if mission_mul == 0 then
				extra_params.min_spawned_volumes = extra_params.min_spawned_volumes * 0
				extra_params.max_spawned_volumes = extra_params.max_spawned_volumes * 0
			elseif mission_mul == 1 then				
				extra_params.min_spawned_volumes = extra_params.min_spawned_volumes * 0.15
				extra_params.max_spawned_volumes = extra_params.max_spawned_volumes * 0.15
			elseif mission_mul == 2 then				
				extra_params.min_spawned_volumes = extra_params.min_spawned_volumes * 0.25
				extra_params.max_spawned_volumes = extra_params.max_spawned_volumes * 0.25
			elseif mission_mul == 3 then				
				extra_params.min_spawned_volumes = extra_params.min_spawned_volumes * 0.5
				extra_params.max_spawned_volumes = extra_params.max_spawned_volumes * 0.5
			elseif mission_mul == 4 then				
				extra_params.min_spawned_volumes = extra_params.min_spawned_volumes * 0.75
				extra_params.max_spawned_volumes = extra_params.max_spawned_volumes * 0.75
			elseif mission_mul == 5 then				
				extra_params.min_spawned_volumes = extra_params.min_spawned_volumes * 1
				extra_params.max_spawned_volumes = extra_params.max_spawned_volumes * 1
			elseif mission_mul == 6 then				
				extra_params.min_spawned_volumes = extra_params.min_spawned_volumes * 1.25
				extra_params.max_spawned_volumes = extra_params.max_spawned_volumes * 1.25
			elseif mission_mul == 7 then				
				extra_params.min_spawned_volumes = extra_params.min_spawned_volumes * 1.5
				extra_params.max_spawned_volumes = extra_params.max_spawned_volumes * 1.5
			elseif mission_mul == 8 then				
				extra_params.min_spawned_volumes = extra_params.min_spawned_volumes * 1.75
				extra_params.max_spawned_volumes = extra_params.max_spawned_volumes * 1.75
			elseif mission_mul == 9 then				
				extra_params.min_spawned_volumes = extra_params.min_spawned_volumes * 2
				extra_params.max_spawned_volumes = extra_params.max_spawned_volumes * 2
			elseif mission_mul == 10 then				
				extra_params.min_spawned_volumes = extra_params.min_spawned_volumes * 2.5
				extra_params.max_spawned_volumes = extra_params.max_spawned_volumes * 2.5
			end
		end
		
		return extra_params
	end    
	
	local advanceResourceName = self.missionAdvancedResource[self.mission_params.biome_name]
	local rareResourceName = self.missionRareResource[self.mission_params.biome_name]

	local biome_resources =
	{
		["acid"] =
		{
			regular_large_resources =
			{
				ResourceVolume( "carbon_vein", 15, 20, 24000, 50000, nil ),
				ResourceVolume( "iron_vein", 10, 15, 16000, 32000, nil ),
				ResourceVolume( advanceResourceName, 15, 20, 12000, 24000, nil),
				ResourceVolume( "geothermal_vent", 3, 6, nil, nil, { is_infinite = true } ),
				ResourceVolume( "flammable_gas_vent", 2, 4, nil, nil, { is_infinite = true } )		
			},			
			regular_small_resources =
			{
				ResourceVolume( "carbon_vein", 4, 8, 10000, 16000, nil ),
				ResourceVolume( "iron_vein", 3, 6, 8000, 12000, nil )				
			},			
			underground_resources =
			{
				ResourceVolume( "carbon_vein", 2, 4, 14000, 36000, { required_discovery_lvl = 1 }),
				ResourceVolume( "iron_vein", 10, 15, 16000, 32000, { required_discovery_lvl = 1 } ),
				ResourceVolume( advanceResourceName, 3, 5, 12000, 24000, { required_discovery_lvl = 1 }),
				ResourceVolume( "geothermal_vent", 2, 4, nil, nil, { required_discovery_lvl = 1, is_infinite = true }),
				ResourceVolume( "flammable_gas_vent", 1, 2, nil, nil, { required_discovery_lvl = 1, is_infinite = true } )
			},			
			liquid_resources =
			{				
			},
			starting_resources = 
			{
				ResourceVolume( "carbon_vein", 1, 3, 20000, 40000, nil ),
				ResourceVolume( "iron_vein", 1, 2, 8000, 16000, nil ),
				ResourceVolume( advanceResourceName, 1, 2, 12000, 24000, nil ),
				ResourceVolume( "geothermal_vent", 1, 1, nil, nil, { required_discovery_lvl = 1, is_infinite = true } ),				
			}	
		},
		
		["caverns"] =
		{
			regular_large_resources =
			{
				ResourceVolume( "carbon_vein", 10, 15, 16000, 30000, nil, self.mission_params:GetResourceAmount("carbon_vein") ),
				ResourceVolume( "iron_vein", 20, 25, 24000, 50000, nil, self.mission_params:GetResourceAmount("iron_vein") ),
				ResourceVolume( advanceResourceName, 15, 20, 12000, 24000, nil, self.mission_params:GetResourceAmount(advanceResourceName) ),
				ResourceVolume( "geothermal_vent", 12, 15, nil, nil, { is_infinite = true } ),
				
			},			
			regular_small_resources =
			{		
				ResourceVolume( "carbon_vein", 5, 8, 8000, 16000, nil ),
				ResourceVolume( "iron_vein", 4, 6, 16000, 24000, nil )	
			},			
			underground_resources =
			{				
			},			
			liquid_resources =
			{				
			},
			starting_resources = 
			{						
			}	
		},
		
		["desert"] =
		{
			regular_large_resources =
			{
				ResourceVolume( "carbon_vein", 15, 20, 24000, 50000, nil ),
				ResourceVolume( "iron_vein", 10, 15, 16000, 32000, nil),
				ResourceVolume( advanceResourceName, 15, 20, 12000, 24000, nil ),
			},			
			regular_small_resources =
			{	
				ResourceVolume( "carbon_vein", 5, 8, 8000, 16000, nil ),
				ResourceVolume( "iron_vein", 4, 6, 6000, 12000, nil)	
			},			
			underground_resources =
			{	
				ResourceVolume( "carbon_vein", 3, 5, 24000, 50000, { required_discovery_lvl = 1 }),
				ResourceVolume( "iron_vein", 3, 5, 16000, 32000, { required_discovery_lvl = 1 } ),
				ResourceVolume( advanceResourceName, 5, 10, 12000, 24000, { required_discovery_lvl = 1 } ),
			},			
			liquid_resources =
			{				
			},
			starting_resources = 
			{
				ResourceVolume( "carbon_vein", 1, 3, 20000, 40000, nil ),
				ResourceVolume( "iron_vein", 1, 2, 8000, 16000, nil ),
				ResourceVolume( advanceResourceName, 1, 2, 12000, 24000, nil),
			}	
		},
		
		["jungle"] =
		{
			regular_large_resources =
			{
				ResourceVolume( "carbon_vein", 20, 25, 24000, 50000, nil),
				ResourceVolume( "iron_vein", 10, 15, 16000, 32000, nil ),
				ResourceVolume( advanceResourceName, 15, 20, 12000, 24000, nil ),
				ResourceVolume( "geothermal_vent", 10, 12, nil, nil, { is_infinite = true } ),
				ResourceVolume( "flammable_gas_vent", 2, 4, nil, nil, { is_infinite = true }  )		
			},			
			regular_small_resources =
			{
				ResourceVolume( "carbon_vein", 5, 8, 8000, 16000, nil),
				ResourceVolume( "iron_vein", 3, 6, 8000, 16000, nil )				
			},			
			underground_resources =
			{
				ResourceVolume( "carbon_vein", 3, 5, 24000, 30000, { required_discovery_lvl = 1 } ),
				ResourceVolume( "iron_vein", 3, 5, 16000, 32000, { required_discovery_lvl = 1 }),
				ResourceVolume( advanceResourceName, 3, 5, 12000, 24000, { required_discovery_lvl = 1 } ),
				ResourceVolume( "geothermal_vent", 2, 4, nil, nil, { required_discovery_lvl = 1, is_infinite = true } ),
				ResourceVolume( "flammable_gas_vent", 1, 2, nil, nil, { required_discovery_lvl = 1, is_infinite = true })
			},			
			liquid_resources =
			{
				ResourceVolume( "sludge_vein", 4, 8, nil, nil, { is_infinite = true } ),				
			},
			starting_resources = 
			{
				ResourceVolume( "carbon_vein", 2, 2, 60000, 70000, nil ),
				ResourceVolume( "iron_vein", 2, 2, 24000, 40000, nil ),
				ResourceVolume( advanceResourceName, 1, 2, 12000, 24000, nil )        
			}	
		},	
		
		["magma"] =
		{
			regular_large_resources =
			{
				ResourceVolume( "carbon_vein", 15, 20, 24000, 50000, nil ),
				ResourceVolume( "iron_vein", 10, 15, 16000, 32000, nil),
				ResourceVolume( advanceResourceName, 15, 20, 12000, 24000, nil ),				
				ResourceVolume( "geothermal_vent", 20, 30, nil, nil, { is_infinite = true } ),		
				ResourceVolume( "flammable_gas_vent", 3, 6, nil, nil, { is_infinite = true } )		
			},			
			regular_small_resources =
			{
				ResourceVolume( "carbon_vein", 5, 8, 8000, 16000, nil ),
				ResourceVolume( "iron_vein", 4, 6, 6000, 12000, nil ),				
			},			
			underground_resources =
			{
				ResourceVolume( "carbon_vein", 3, 5, 24000, 50000, { required_discovery_lvl = 1 } ),
				ResourceVolume( "iron_vein", 3, 5, 16000, 32000, { required_discovery_lvl = 1 } ),
				ResourceVolume( advanceResourceName, 3, 5, 12000, 24000, { required_discovery_lvl = 1 }),				
				ResourceVolume( "geothermal_vent", 3, 5, nil, nil, { required_discovery_lvl = 1, is_infinite = true } ),
				ResourceVolume( "flammable_gas_vent", 3, 6, nil, nil, { required_discovery_lvl = 1, is_infinite = true } )
			},			
			liquid_resources =
			{
			},
			starting_resources = 
			{
				ResourceVolume( "carbon_vein", 1, 3, 20000, 40000, nil ),
				ResourceVolume( "iron_vein", 1, 2, 8000, 16000, nil ),
				ResourceVolume( advanceResourceName, 1, 2, 12000, 24000, nil )        
			}	
		},	
		
		["metallic"] =
		{
			regular_large_resources =
			{	
				ResourceVolume( "carbon_vein", 10, 15, 16000, 30000, nil ),
				ResourceVolume( "iron_vein", 20, 25, 24000, 50000, nil ),
				ResourceVolume( advanceResourceName, 15, 20, 12000, 24000, nil ),				
				ResourceVolume( "geothermal_vent", 12, 15, nil, nil, { is_infinite = true } ),						
			},			
			regular_small_resources =
			{
				ResourceVolume( "carbon_vein", 5, 8, 8000, 16000, nil),
				ResourceVolume( "iron_vein", 4, 6, 16000, 24000, nil ),	
			},			
			underground_resources =
			{		
				ResourceVolume( "carbon_vein", 3, 5, 24000, 50000, { required_discovery_lvl = 1 } ),
				ResourceVolume( "iron_vein", 3, 5, 24000, 50000, { required_discovery_lvl = 1 }),
				ResourceVolume( advanceResourceName, 3, 5, 12000, 24000, { required_discovery_lvl = 1 }),				
				ResourceVolume( "geothermal_vent", 3, 5, nil, nil, { required_discovery_lvl = 1, is_infinite = true } ),				
			},			
			liquid_resources =
			{				
			},
			starting_resources = 
			{
				ResourceVolume( "carbon_vein", 2, 2, 16000, 30000, nil ),
				ResourceVolume( "iron_vein", 2, 2, 40000, 60000, nil ),
				ResourceVolume( advanceResourceName, 1, 2, 12000, 24000, nil ),
				ResourceVolume( "geothermal_vent", 1, 1, nil, nil, { required_discovery_lvl = 1, is_infinite = true }),				
			}	
		},
		
		["swamp"] =
		{
			regular_large_resources =
			{	
				ResourceVolume( "carbon_vein", 15, 20, 20000, 70000, nil ),
				ResourceVolume( "iron_vein", 10, 15, 16000, 50000, nil ),
				ResourceVolume( advanceResourceName, 15, 20, 12000, 24000, nil ),				
				ResourceVolume( "flammable_gas_vent", 3, 6, nil, nil, { is_infinite = true } ),
			},			
			regular_small_resources =
			{	
				ResourceVolume( "carbon_vein", 5, 8, 8000, 16000, nil ),
				ResourceVolume( "iron_vein", 2, 4, 30000, 50000, nil ),	
			},			
			underground_resources =
			{				
				ResourceVolume( "carbon_vein", 2, 4, 40000, 90000, { required_discovery_lvl = 1 } ),
				ResourceVolume( "iron_vein", 3, 5, 24000, 50000, { required_discovery_lvl = 1 } ),
				ResourceVolume( advanceResourceName, 3, 5, 12000, 24000, { required_discovery_lvl = 1 } ),				
				ResourceVolume( "flammable_gas_vent", 3, 6, nil, nil, { is_infinite = true }),
			},			
			liquid_resources =
			{				
			},
			starting_resources = 
			{	
				ResourceVolume( "carbon_vein", 2, 2, 32000, 44000, nil ),
				ResourceVolume( "iron_vein", 2, 2, 24000, 36000, nil ),								
			}	
		},
	}
	
	MapGenerator:SetStartupResourceSpawnDistance( 16, 96 )
	
	self:CreateRandomResourcesSpawnRules( biome_resources[self.mission_params.biome_name].regular_large_resources )
    self:CreateRandomResourcesSpawnRules( biome_resources[self.mission_params.biome_name].regular_small_resources )
    self:CreateRandomResourcesSpawnRules( biome_resources[self.mission_params.biome_name].underground_resources )
    self:CreateRandomResourcesSpawnRules( biome_resources[self.mission_params.biome_name].liquid_resources )    
	
	--================ STARTING RESOURCE ENHANCEMENT
	--self.lucky_start = true
	--if self.lucky_start == true then
	--	for volume in Iter( biome_resources[self.mission_params.biome_name].starting_resources ) do
	--		volume.min_resources = volume.min_resources * 2
	--		volume.max_resources = volume.max_resources * 2
	--	end
	--end
	--================ STARTING RESOURCE ENHANCEMENT

    self:CreateStartupResourcesSpawnRules( biome_resources[self.mission_params.biome_name].starting_resources )

	
	-- AMBIENT CREATURES
	local ambient_creatures_species =
	{
		["caverns"] =
		{        
			ground =
        	{     
				max_count = 50,
				spawn_rate = 6,
				search_to_spawn_radius = "2",

        	    species =
        	    {
        	        {
        	            creature_species  =  "crysder"
        	        }
        	    }
        	}
		}
	}

end

function template_universal:Activated()
	MissionService:ActivateMissionFlow("", "logic/missions/campaigns/story/template_jungle_resource.logic", "default" )
	
	local rulesPath = nil
	if self.mission_params.biome_name == "metallic" then
		rulesPath = GetRulesForDifficulty( "lua/missions/campaigns/dlc_1/dom_template_metallic_resource_rules_" )
	elseif self.mission_params.biome_name == "caverns" then
		rulesPath = GetRulesForDifficulty( "lua/missions/campaigns/dlc_2/dom_template_caverns_resource_rules_" )		
	elseif self.mission_params.biome_name == "swamp" then
		rulesPath = GetRulesForDifficulty( "lua/missions/campaigns/dlc_3/dom_template_swamp_resource_rules_" )
	else
		rulesPath = GetRulesForDifficulty( "lua/missions/campaigns/story/v2/" .. self.mission_params.biome_name .. "/dom_template_" .. self.mission_params.biome_name .. "_resource_rules_" )
	end
	
    MissionService:AddGameRule( "lua/missions/v2/dom_manager.lua", rulesPath )
	local campaignData = CampaignService:GetCampaignData();
	local tiles =  self.mission_params:GetEncounterTiles()
	for encounterTile in Iter( tiles) do
		campaignData:SetInt(encounterTile, campaignData:GetIntOrDefault(encounterTile, 0) + 1)
	end
end

return template_universal