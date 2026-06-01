require("lua/utils/table_utils.lua")
local building = require("lua/buildings/building.lua");

class 'headquarters' ( building )

function headquarters:__init()
	building.__init(self)
end

function headquarters:OnInit()
	self.portalEnergy = nil

	self.selected = {}
	self.headquartersVersion = 1
	self.interval = self.data:GetFloatOrDefault("interval" , 1 )
	self.radius = self.data:GetFloatOrDefault("heal_radius", 6 )
	self.healthAmount = self.data:GetFloatOrDefault("heal_amount", 10 )
	self.healCount = self.data:GetIntOrDefault("heal_count", 1 )
	self.energyCost = self.data:GetFloatOrDefault("energy_cost", 0 )
	
	self.fsm = self:CreateStateMachine()
	self.fsm:AddState( "place", { from="*", enter="OnPlaceEnter", execute="OnPlaceExecute", exit="OnPlaceExit" } )
	self.fsm:AddState( "working", { execute="OnWorkInProgress", interval=self.interval } )

end

function headquarters:OnDamage( evt )
	LampService:ReportHeadquaterDamage()
end

function headquarters:OnSellStart()
	self.fsm:ChangeState( "place" )
end

function headquarters:OnPlaceEnter( state )
	state:SetDurationLimit( 0.5 )
end

function headquarters:OnPlaceExecute( state )
	local currentProgress = ( 1 -  state:GetDuration() / 0.5 )
	if (self.portalEnergy ~= nil and EntityService:IsAlive( self.portalEnergy )) then
		EntityService:SetOrientation( self.portalEnergy, 0, 1, 0, currentProgress * 360 )
		EntityService:SetScale( self.portalEnergy, currentProgress , 1.0, currentProgress )
	end
end

function headquarters:OnPlaceExit( state )
	if ( self.portalEnergy ~= nil ) then
		EntityService:RemoveEntity( self.portalEnergy )
		self:UnregisterHandler( self.entity, "EnteredTriggerEvent",  "OnEnteredTriggerEvent" )
	end
end

function headquarters:OnRemove()
	if ( self.portalEnergy ~= nil ) then
		EntityService:RemoveEntity( self.portalEnergy )
	end
end

function headquarters:OnDestroy()
	PlayerService:ResetEnergyLvl( 0 )
	return false
end

function headquarters:OnBuildingEnd()
	self.portalEnergy = EntityService:SpawnAndAttachEntity( "buildings/main/headquarters/portal", self.entity, "att_portal", "" )
	self:RegisterHandler( self.entity, "EnteredTriggerEvent",  "OnEnteredTriggerEvent" )
	PlayerService:SetEnergyLvl( 0, BuildingService:GetBuildingLevel( self.entity ) )
	local range = self.data:GetFloat("range")
	BuildingService:CreateRadarComponent( self.entity, range );	
end

function headquarters:OnEnteredTriggerEvent(evt)
end

function headquarters:OnActivate()
	self.fsm:ChangeState("working")
end


function headquarters:OnWorkInProgress( state )
	local objects = FindService:FindEntitiesByTypeInRadius( self.entity, "player", self.radius )
									
	for i = 1, #self.selected do			
		if( IndexOf( objects, self.selected[i]  ) == nil ) then
			table.remove( self.selected, i )					
		end
	end				
			
	if ( #self.selected < self.healCount ) then
		for entity in Iter(objects) do			
			if( IndexOf( self.selected, entity ) == nil ) then
				table.insert( self.selected, entity )	
				if ( #self.selected == self.healCount ) then
					break
				end						
			end
		end					
	end

	local worked = false
	for i = #self.selected, 1, -1  do
		local ent = self.selected[i]
		if ( EntityService:IsAlive( ent) ) then
			
			local health = HealthService:GetHealthInPercentage( ent)
	
			if ( health < 1 ) then
				local decrease = BuildingService:TryDecreaseResourceByEntity( self.entity, "energy", self.energyCost )

				if decrease == false then
					table.remove( self.selected, i )
					break
				end
				worked = true
				HealthService:AddHealthInUnits( ent, self.healthAmount )
				EffectService:AttachEffect( ent, "effects/items/potion" )
			else
				table.remove( self.selected, i )
			end
	
		else
			table.remove( self.selected, i )
		end
	
	end
	if worked == true then 
		EffectService:AttachEffect( self.entity, "effects/buildings_and_machines/repair_facility_healing_radius" )
	end
end

function headquarters:OnDeactivate()
	self.selected = {}
	local state = self.fsm:GetState("working")
	if ( state ~= nil ) then
		state:Exit()
	end	 
end

return headquarters
