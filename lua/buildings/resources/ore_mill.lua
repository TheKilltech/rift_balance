local building = require("lua/buildings/building.lua")
require("lua/utils/table_utils.lua")

class 'ore_mill' ( building )

function ore_mill:__init()
	building.__init(self,self)
end

function ore_mill:OnInit()
	self.range   = self.data:GetFloatOrDefault("range", 40)
	self.buffMod = self.data:GetFloatOrDefault("buff_modificator", 1.5)
	
    self.fsm = self:CreateStateMachine()
    self.fsm:AddState( "buff", { enter="OnEnterBuff", execute="OnExecuteBuff", exit="OnExitBuff",  interval = 30 } )
    self.fsm:AddState( "idle", { enter="OnEnterIdle" } )
end


function ore_mill:OnActivate()
	LogService:Log( "ore_mill: OnActivate" )
	self.powered = true
	self.fsm:ChangeState("buff")
	if ( AnimationService:HasAnim( self.entity, "working") ) then
		AnimationService:StartAnim( self.entity, "working", true )
	end
end

function ore_mill:OnDeactivate()
	LogService:Log( "ore_mill: OnDeactivate" )
	self.powered = false
	self.fsm:ChangeState("idle")
	if ( AnimationService:IsAnimActive( self.entity, "working") ) then
		AnimationService:StopAnim( self.entity, "working")
	end
end

function ore_mill:OnBuildingEnd()
	--self.fsm:ChangeState("buff")
end


function ore_mill:OnEnterIdle()
end

function ore_mill:OnEnterBuff()
	self:UpdateMines( self.buffMod )
end

function ore_mill:OnExitBuff()
	self:UpdateMines( )
end

function ore_mill:OnExecuteBuff()
	self:UpdateMines( self.buffMod )
end


function ore_mill:GetMinesInVicinity()
	LogService:Log( "ore_mill: GetMinesInVicinity" )
    local entities = FindService:FindEntitiesByNameInRadius( self.entity, "carbonium_factory", self.range )    
	LogService:Log( "ore_mill: by name ".. tostring(#entities) .. " in range ".. tostring(self.range))
	entities = FindService:FindEntitiesByTypeInRadius( self.entity, "mine", self.range )
	LogService:Log( "ore_mill: by type ".. tostring(#entities) .. " in range ".. tostring(self.range))         
    entities = FindService:FindEntitiesByBlueprintInRadius( self.entity, "buildings/resources/carbonium_factory", self.range )   
	LogService:Log( "ore_mill: by bp ".. tostring(#entities) .. " in range ".. tostring(self.range))
	
	local mines = {}
    for ent in Iter(entities ) do
        if EntityService:GetComponent(ent, "ResourceConverterComponent") == nil	then goto continue end
		if ( not BuildingService:IsBuildingFinished( ent ))						then goto continue end
		
		--local bpname = EntityService:GetBlueprintName(ent)
		Insert(mines, ent)
		::continue::
    end
	
	LogService:Log( "ore_mill: ".. tostring(#mines).. "/".. tostring(#entities) .." vicinity list")
    for ent in Iter(mines ) do
		LogService:Log( "ore_mill: entity ".. tostring(ent).. " name ".. tostring(EntityService:GetBlueprintName(ent)))
	end

    return mines
end


function ore_mill:UpdateMines( modificator )
	LogService:Log( "ore_mill: UpdateMines( modificator ".. tostring(modificator) .. " )" )
	local entities = self:GetMinesInVicinity()
	for entity in Iter( entities ) do
		QueueEvent("LuaGlobalEvent", entity, "BuffEvent", { mod = modificator, source =  self.entitiy } )
		BuildingService:RemoveResourceConverterEfficientyModificator( entity, "biome" )
		if ( modificator ~= nil ) then
			BuildingService:SetResourceConverterEfficientyModificator( entity, modificator, "biome" )
		end
	end
end

return ore_mill
