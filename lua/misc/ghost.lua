class 'ghost' ( LuaEntityObject )
require("lua/utils/reflection.lua")


function ghost:__init()
	LuaEntityObject.__init(self,self)
end

function ghost:init()
    
	self.stateMachine = self:CreateStateMachine()
	self.stateMachine:AddState( "working", {enter="OnWorkEnter", execute="OnWorkExecute", exit="OnWorkExit" } )
    self.stateMachine:ChangeState("working")

    self:InitializeValues()

    if ( self.OnInit ) then
        self:OnInit()
    end
end

function ghost:InitializeValues()
    self.selector = EntityService:GetParent( self.entity )
    
	self:RegisterHandler( self.selector, "ActivateSelectorRequest",     "OnActivateSelectorRequest" )
	self:RegisterHandler( self.selector, "DeactivateSelectorRequest",   "OnDeactivateSelectorRequest" )
	self:RegisterHandler( self.selector,  "RotateSelectorRequest",      "OnRotateSelectorRequest" )

    local playerReferenceComponent = reflection_helper( EntityService:GetComponent(self.selector, "PlayerReferenceComponent") )
    self.playerId = playerReferenceComponent.player_id

    local buildingComponent = reflection_helper(EntityService:GetComponent( self.entity, "BuildingComponent"))
    self.blueprint = buildingComponent.bp 

    self.desc = reflection_helper(BuildingService:GetBuildingDesc( self.blueprint ))

    Assert(self.desc ~= nil, "ERROR: " .. self.blueprint .. " doesn't have BuildingDesc! It will crash now!")

    self.overrides = self.desc.overrides
    self.erases = self.desc.erase_type
    self.name = self.desc.name
    self.toCloseAnnoucement = self.desc.min_radius_effect
    self.ghostBlueprint = self.desc.ghost_bp 

    local boundsSize = EntityService:GetBoundsSize( self.selector)
    self.activated = false
    
    self.annoucements = { ["ai"] = "voice_over/announcement/not_enough_ai_cores",
    ["carbonium"] = "voice_over/announcement/not_enough_carbonium",
    ["steel"] = "voice_over/announcement/not_enough_steel",
    ["cobalt"] = "voice_over/announcement/not_enough_cobalt",
    ["palladium"] = "voice_over/announcement/not_enough_palladium",
    ["titanium"] = "voice_over/announcement/not_enough_titanium" }

    --showed_change_info
    if ( self.desc.rotate_info == true and ConsoleService:GetConfig( "showed_rotate_info" ) == "0" ) then
        self.rotateInfoChild = EntityService:SpawnAndAttachEntity("misc/rotate_info", self.entity )
    end
end

function ghost:GetChildren()
    if ( self.childrenToUpdate == nil ) then
        self.childrenToUpdate = {}
        local children = EntityService:GetChildren( self.selector, true )
        for child in Iter( children ) do
            local hasMesh = EntityService:HasComponent( child, "MeshComponent")
            local isEffect = EntityService:HasComponent( child, "EffectReferenceComponent")
            if ( hasMesh and not isEffect ) then
                Insert( self.childrenToUpdate, child )
            end
        end
    end
    return self.childrenToUpdate
    
end

function ghost:GetBuildInfo( entity  )
    local buildInfoComponent = EntityService:GetComponent( entity, "BuildInfoComponent")
    if ( not Assert( buildInfoComponent ~= nil ,"ERROR: missing build info component!") ) then return nil end
    if (buildInfoComponent == nil ) then
        return
    end
    local helper = reflection_helper(buildInfoComponent)
    return helper.build_info
end

function  ghost:BuildBuilding( transform )
    QueueEvent("BuildBuildingRequest", INVALID_ID, self.playerId, self.blueprint, transform, true , {})
end

function  ghost:CheckEntityBuildable( entity, transform, floor, id, checkActive )
    checkActive = checkActive or ( checkActive == nil and true )
    id = id or 1
    local test = nil
    if floor  then
        test = BuildingService:CheckGhostFloorStatus( self.playerId, entity, transform, self.blueprint )
    else
        test = BuildingService:CheckGhostBuildingStatus( self.playerId, entity, transform, self.blueprint, id)
    end
    if ( test == nil ) then
        return
    end

    local testReflection = reflection_helper(test:ToTypeInstance(), test )
    
    --LogService:Log("Flag: " .. tostring(testReflection.flag ))
    --LogService:Log("Missing resources: " .. tostring(testReflection.missing_resources))
    --LogService:Log("Entity to repair: " .. tostring(testReflection.entity_to_repair )  )
    --LogService:Log("Entity to sell: " .. tostring(testReflection.entities_to_sell ))
    --LogService:Log("Free grids: " .. tostring(testReflection.free_grids ))

    local canBuild = testReflection.flag == CBF_CAN_BUILD or testReflection.flag == CBF_ONE_GRID_FLOOR or testReflection.flag == CBF_OVERRIDES
    
    local buildingSelectorComponent = reflection_helper( EntityService:GetComponent(self.selector, "BuildingSelectorComponent") )
    buildingSelectorComponent.can_build = canBuild
    
    local materialToSet = "hologram/pass"
    if ( testReflection.flag == CBF_REPAIR  ) then
        if ( BuildingService:CanAffordRepair( testReflection.entity_to_repair, self.playerId, -1 )) then
            materialToSet = "hologram/pass"
        else
            materialToSet = "hologram/deny"
        end
    else
        if ( canBuild ) then
            materialToSet = "hologram/blue"
        else
            materialToSet = "hologram/red"
        end
    end

    EntityService:ChangeMaterial( entity, materialToSet)
    for child in Iter( self:GetChildren() ) do
        EntityService:ChangeMaterial( child, materialToSet)
    end


    if ( self.activated and checkActive ) then
        if ( BuildingService:BlinkBuildingSelector(self.selector, entity ) ) then 
            if ( testReflection.flag == CBF_TO_CLOSE ) then
				if ( self.toCloseAnnoucement ~= "" ) then
					QueueEvent("PlayTimeoutSoundRequest", INVALID_ID, 10.0, self.toCloseAnnoucement, entity, false)
				end
            elseif( testReflection.flag == CBF_LIMITS ) then
                QueueEvent("PlayTimeoutSoundRequest", INVALID_ID, 5.0, "voice_over/announcement/building_limit", entity, false )
            end
            local missingResources = testReflection.missing_resources
            if ( missingResources.count  > 0 ) then
                if ( missingResources.count  > 1 ) then
                    QueueEvent("PlayTimeoutSoundRequest", INVALID_ID, 5.0, "voice_over/announcement/not_enough_resources", entity, false )
                elseif ( self.annoucements[missingResources[1]] ~= nil and self.annoucements[missingResources[1]] ~= "" ) then
                    QueueEvent("PlayTimeoutSoundRequest",INVALID_ID, 5.0, self.annoucements[missingResources[1]],entity , false )
                end        
            end
        end
    end
    return testReflection
end

function ghost:OnWorkEnter()
end

function ghost:OnWorkExit()
end

function ghost:OnWorkExecute()
    if ( self.OnUpdate ) then
        self:OnUpdate()
    end
end

function ghost:OnActivateSelectorRequest()
    self.activated = true
    if ( self.OnActivate ) then
        self:OnActivate()
    end
end

function ghost:OnDeactivateSelectorRequest()
    self.activated = false
    if ( self.OnDeactivate ) then
        self:OnDeactivate()
    end
end

function ghost:OnRelease()
end

function ghost:OnRotateSelectorRequest()
    if (self.rotateInfoChild ~= nil and EntityService:IsAlive(self.rotateInfoChild ) ) then
        EntityService:RemoveEntity(self.rotateInfoChild)
        self.rotateInfoChild = nil
	    ConsoleService:ExecuteCommand( "showed_rotate_info 1" )
    end
end

return ghost
 
