require("lua/units/units_utils.lua")

class 'spawner' ( LuaEntityObject )

function spawner:__init()
	LuaEntityObject.__init(self, self)
end

function spawner:init()
	SetupUnitScale( self.entity, self.data )
	
	self:RegisterHandler( self.entity, "DestroyRequest",	  "OnDestroyRequest" )
	self:RegisterHandler( self.entity, "SpawnerInfoRequest",  "OnSpawnerInfoRequest" )

	local currentDifficulty = DifficultyService:GetCurrentDifficultyName()

	local bpName = UnitSpawnerService:GetSpawnBlueprintName( self.entity )
	local bpNameAlpha = bpName .. "_alpha"
	local bpNameUltra = bpName .. "_ultra"

	if ( ( currentDifficulty == "hard" ) and ( EntityService:IsBlueprintExist( bpNameAlpha ) == true ) ) then
		UnitSpawnerService:ReplaceSpawnBlueprint( self.entity, bpNameAlpha )
	elseif ( (  currentDifficulty == "brutal" ) and ( EntityService:IsBlueprintExist( bpNameUltra ) == true ) ) then
		UnitSpawnerService:ReplaceSpawnBlueprint( self.entity, bpNameUltra )
	end

	if self.OnInit then
        self:OnInit( evt )
    end

    SetupComponentFieldOverrides( self.entity, self.data )

	self.fsm = self:CreateStateMachine()
    self.fsm:AddState( "check_skills", { enter="OnCheckSkills" } )
	self.fsm:ChangeState( "check_skills" )
	
	if ( self.data:HasString("ambient_spawner") == true ) then
		--LogService:Log("AMBIENT SPAWNER DISABLED:")
		UnitSpawnerService:DisableUnitSpawner( self.entity )
		self.checkSpawnerState = self:CreateStateMachine()
		self.checkSpawnerState:AddState( "check_state", { execute="OnExecuteCheckSpawnerState", interval=1 } )
		self.checkSpawnerState:ChangeState( "check_state" )
	end
	
end

function spawner:OnCheckSkills( state )
	if EntityService:HasComponent( self.entity, "SkillUnitComponent" ) then
		local children = EntityService:GetChildren( self.entity, false )
		EntityService:SetTeam( self.entity, "wave_enemy" )
		
		for child in Iter( children ) do
			EntityService:SetTeam( child, "wave_enemy" )
			QueueEvent( "UnitAggressiveStateEvent", child )
		end
	end
end

function spawner:OnExecuteCheckSpawnerState( state )
	local players = FindEntitiesInDinstance( "Type", "player", self.entity, 0, 100 )
	--LogService:Log( "Players Found:" .. tostring(#players) )
    if #players > 0 then
		--LogService:Log("AMBIENT SPAWNER ENABLED:")
		UnitSpawnerService:EnableUnitSpawner( self.entity )
		state:Exit()
	end
end

function spawner:OnDestroyRequest( evt )
	AnimationService:StopAnim( self.entity , "working" )	
	EntityService:ChangeToWreck( self.entity, evt:GetDamageType(), evt:GetDamagePercentage(), "wreck_big", 0 )
	EntityService:RemoveComponent( self.entity, "UnitsSpawnerComponent" )

	if EntityService:HasComponent( self.entity, "SkillUnitComponent" ) then
		local children = EntityService:GetChildren( self.entity, false )
		for child in Iter( children ) do			
			QueueEvent( "UnitDeadStateEvent", child )
		end
	end
end

function spawner:OnSpawnerInfoRequest( evt )
	--SoundService:PlayAnnouncement( "voice_over/announcement/warning_nest_wave_spawn", 20 )
end

return spawner