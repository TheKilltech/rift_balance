require("lua/utils/find_utils.lua")

class 'resource_comet' ( LuaEntityObject )

function resource_comet:__init()
	LuaEntityObject.__init(self, self)
end

function resource_comet:init()
	self.cometFlyingBp		= self.data:GetString( "comet_flying_blueprint" )
	self.cometDmgBp			= self.data:GetString( "comet_dmg_blueprint" )
	self.cometImpactPlaceBp	= self.data:GetString( "comet_impact_place_blueprint" )
	self.resource			= self:PickRandomResource( self.data:GetStringOrDefault( "resource", "carbon_vein" ) )
	self.cometSpawnBp 		= self.data:GetStringOrDefault( "comet_impact_spawn", "" )
	self.cometSpawnBpName 	= self.data:GetStringOrDefault( "comet_impact_spawn_name", "" )
	self.findMode 			= self.data:GetStringOrDefault( "find_mode", "resource" )
	self.makeAggresive 		= self.data:GetIntOrDefault( "make_unit_aggressive" , 0 )
	self.targetName 		= self.data:GetStringOrDefault( "target_name" , "" )

	self.minAmount			= self.data:GetIntOrDefault( "min_amount", 10000 )
	self.maxAmount			= self.data:GetIntOrDefault( "max_amount", 20000 )
	
    self.spawner = self:CreateStateMachine()
    self.spawner:AddState( "spawn", { enter="OnEnterSpawn", execute="OnExecuteSpawn", exit= "OnExitSpawn" } )
	self.spawner:AddState( "cleanup", { } )

	self.spawner:ChangeState( "spawn" )

	self.spaceEnt = INVALID_ID
	self.cometEnt = INVALID_ID

	if ( self.findMode == "target") then
		self.removeSpaceEnt = false;
	else
		self.removeSpaceEnt = true;
	end
end

function resource_comet:SelectFlyoverCandidate()
	for entity in Iter( PlayerService:GetPlayersMechs() ) do
		return entity
	end

	return FindService:FindEntityByName("headquarters")
end

function resource_comet:OnEnterSpawn( state )
	if ( self.findMode == "resource") then
		self.spaceEnt = ResourceService:FindEmptySpace( 100, 500 );
	elseif ( self.findMode == "objective") then
		self.spaceEnt = MissionService:SpawnMissionObjective( "logic/position_marker", true )
	elseif ( self.findMode == "target") then
		self.spaceEnt = FindService:FindEntityByName( self.targetName )

		if ( self.spaceEnt == INVALID_ID ) then
			LogService:Log( "resource_comet:OnEnterSpawn - There is no entity with name : " .. self.targetName )
			self.spaceEnt = ResourceService:FindEmptySpace( 100, 500 );
		end
	else
	 	self.spaceEnt = ResourceService:FindEmptySpace( 100, 500 );
	end

	self.cometEnt = MeteorService:SpawnComet( self:SelectFlyoverCandidate(), self.spaceEnt, self.cometFlyingBp, 35, 40, false ) --wersja do spadanie ukosem
end

function resource_comet:OnExecuteSpawn( state )
	if ( EntityService:IsAlive( self.cometEnt ) == false ) then
		self.spawner:ChangeState( "cleanup" )
	end
end

function resource_comet:OnExitSpawn( state )

	if ( self.findMode == "resource") then
		ResourceService:SpawnResources( self.spaceEnt, "resources/volume_template_resource", self.resource, self.minAmount, self.maxAmount )
	end

	--MeteorService:SpawnMeteorInRadius( self.spaceEnt, self.cometDmgBp, 0, 50, 140, 0, 0.0, "" )
	MeteorService:SpawnMeteorInRadius( self.spaceEnt, self.cometDmgBp, 0, 1, 140, 0, 0.0, "" ) --wersja do spadania ukosem 
	EntityService:SpawnEntity( self.cometImpactPlaceBp, self.spaceEnt, "no_team" )

	UnitService:ClearVolumeUnitsSpawnersAround( self.spaceEnt, 30.0 )

	if ( self.cometSpawnBp ~= "") then
		local spawnedEntity = EntityService:SpawnEntity( self.cometSpawnBp, self.spaceEnt, "" )
		if ( self.cometSpawnBpName ~= "") then
			EntityService:SetName(spawnedEntity, self.cometSpawnBpName)
		end
		if ( self.makeAggresive == 1 ) then
			EntityService:SetTeam( spawnedEntity, "wave_enemy")
			UnitService:SetInitialState( spawnedEntity, UNIT_AGGRESSIVE);
		elseif self.findMode == "objective" then
			MissionService:PushEntityToMissionObjectSpawnerPools( spawnedEntity, "objectives" )
		end
	end
	if ( self.removeSpaceEnt == true ) then
		EntityService:RemoveEntity( self.spaceEnt )
	end
	EntityService:RemoveEntity( self.entity )
	QueueEvent("LuaGlobalEvent", event_sink, "CometHitGroundEvent", {})
end

function resource_comet:PickRandomResource( resources )
	local list = Split( resources, "|" )

	if ( #list > 0 ) then
		local random = RandInt( 1, #list )
		return list[random]
	end

	return "carbon_vein"
end

return resource_comet