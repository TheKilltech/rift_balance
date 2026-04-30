local ghost = require("lua/misc/ghost.lua")
require("lua/utils/reflection.lua")
require("lua/utils/table_utils.lua")
require("lua/utils/string_utils.lua")
require("lua/utils/building_utils.lua")

class 'ghost_building' ( ghost )

function ghost_building:__init()
    ghost.__init(self,self)
end

function ghost_building:OnInit()
    local boundsSize = EntityService:GetBoundsSize( self.selector)
    self.boundsSize = VectorMulByNumber( boundsSize, 0.5 )

    EntityService:ChangeMaterial( self.entity, "hologram/blue")
    for child in Iter( self:GetChildren() ) do
        EntityService:ChangeMaterial( child, "hologram/blue")
    end

    local transform = EntityService:GetWorldTransform( self.entity )
    self:CheckEntityBuildable( self.entity , transform )
	self:RegisterHandler( INVALID_ID, "StartBuildingEvent", "OnBuildingStartEvent" )

    self.ghostBlueprint = self.data:GetStringOrDefault("building_blueprint", "");
    ShowBuildingDisplayRadiusAround( self.entity, self.ghostBlueprint )
end

function ghost_building:OnBuildingStartEvent( evt )
    local playerReferenceComponent = EntityService:GetComponent( evt:GetEntity(), "PlayerReferenceComponent")
    local owner = -1
    if (playerReferenceComponent) then
        local helper = reflection_helper(playerReferenceComponent)
        owner = helper.player_id
    end
    if ( owner ~= self.playerId or not self.activated) then
        return
    end

    ShowBuildingDisplayRadiusAround( self.entity, self.ghostBlueprint )

    local transform = EntityService:GetWorldTransform( evt:GetEntity() )
    self:SetLastBuildSpot(transform)
end

function ghost_building:SetLastBuildSpot(transform)
    local selectorComponent = EntityService:GetComponent( self.selector, "BuildingSelectorComponent")
    local container = selectorComponent:GetField("last_build_pos"):ToContainer()
    local item = container:GetItem(0)
    if ( item == nil ) then item = container:CreateItem() end

    local itemHelper = reflection_helper(item)
    itemHelper.x = transform.position.x
    itemHelper.y = transform.position.y
    itemHelper.z = transform.position.z
end

function ghost_building:OnUpdate()
    local transform = EntityService:GetWorldTransform( self.entity )
    local testBuildable = self:CheckEntityBuildable( self.entity , transform, false )

    if ( self.activated  ) then
        if ( testBuildable.flag == CBF_CAN_BUILD ) then
            self:BuildBuilding(transform)
        elseif( testBuildable.flag == CBF_OVERRIDES ) then
            for entityToSell in Iter(testBuildable.entities_to_sell) do
                QueueEvent("SellBuildingRequest", entityToSell, self.playerId, false )
            end
            self:BuildBuilding(transform)       
        elseif( testBuildable.flag == CBF_REPAIR  ) then
            QueueEvent("ScheduleRepairBuildingRequest", testBuildable.entity_to_repair, self.playerId)
        end

    end
    
end

function ghost_building:OnActivate()
end

function ghost_building:ClearLastBuildPos()
    local selectorComponent = EntityService:GetComponent( self.selector, "BuildingSelectorComponent")
    local container = selectorComponent:GetField("last_build_pos"):ToContainer()
    local item = container:GetItem(0)
    if ( item ~= nil ) then
         container:EraseItem(0)
    end
end

function ghost_building:OnDeactivate()
    self:ClearLastBuildPos()
end

function ghost_building:OnRelease()
    self:ClearLastBuildPos()

    HideBuildingDisplayRadiusAround( self.entity, self.ghostBlueprint )
end

return ghost_building
 
