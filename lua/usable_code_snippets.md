##code to investigate

#1. get resources (global) 
from event_manager.lua, line 666

```lua
	local leadingPlayer = PlayerService:GetLeadingPlayer()
	local resourceList = PlayerService:GetGlobalResourcesList(leadingPlayer)

	local availableResurces = {}

	for i = 1, #resourceList, 1 do 
		local resourcePercentage = ( PlayerService:GetResourceAmount(leadingPlayer, resourceList[i] ) / PlayerService:GetResourceLimit(leadingPlayer, resourceList[i] ) ) * 100

		LogService:Log( "Checking resource " .. resourceList[i] .. " - current percentage : " .. tostring( resourcePercentage ) )
```

#2. change resource storage?
from nanobot_center.lua

```lua
function nanobot_center:OnActivate()
	if ( self.megastructureWorking ) then
		return
	end
	self.megastructureWorking = true
	local data = CampaignService:GetCampaignData()
	data:SetFloat( self.name, data:GetFloatOrDefault(self.name, 0 ) + 1 )
	local teamEntity = PlayerService:GetGlobalTeamEntity(self.team )
	BuildingService:CreateResourceStorageComponent( teamEntity, "ai", self.numberOfAiCores,"")
end

function nanobot_center:RemoveComponent()
	if ( not self.megastructureWorking ) then
		return
	end
	self.megastructureWorking = false

	local data = CampaignService:GetCampaignData()
	data:SetFloat( self.name, data:GetFloatOrDefault(self.name, 0) - 1 )
	local teamEntity = PlayerService:GetGlobalTeamEntity(self.team )
	BuildingService:DecreaseResourceStorage( teamEntity, "ai", self.numberOfAiCores,"")
end
```

#3. resource production
from logic_if_resource_is_compressed (i think used by objective on swap map to check resin production)

```lua
    local resourceCount = 0
    for ent in Iter( entities ) do
        if ( BuildingService:IsWorking( ent ) ) then
            local resourceConverterComponent = EntityService:GetComponent( ent, "ResourceConverterComponent")
            if ( resourceConverterComponent ~= nil ) then
                local lastOreProduced = resourceConverterComponent:GetField("last_ore_produced"):GetValue()
                local resource = lastOreProduced:gsub( "_compressed", "" )
                if ( resource == self.resourceName ) then
                    resourceCount = resourceCount + BuildingService:GetResourceProduction( ent, lastOreProduced)
                end
            end
        end
    end
```

#4. check resource inputs
from rift_station.lua

```lua
	if ( BuildingService:IsResourceSupplied( self.entity ) == false ) then
		isWorking = false;
		local missingResources = BuildingService:GetMissingResources( self.entity )
		if ( IndexOf( missingResources, "water" ) ~= nil ) then
			QueueEvent( "LuaGlobalEvent", event_sink, "PortalMissingCoolantEvent", {} )
		elseif ( IndexOf( missingResources,"supercoolant" ) ~= nil ) then
			QueueEvent( "LuaGlobalEvent", event_sink, "PortalMissingCoolantEvent", {} )
		end
		if ( IndexOf( missingResources, "plasma_charged" ) ~= nil ) then
			QueueEvent( "LuaGlobalEvent", event_sink, "PortalMissingPlasmaEvent", {} )
		end
	end
	
	if (BuildingService:IsBuildingPowered( self.entity ) == false ) then
		isWorking = false
		QueueEvent( "LuaGlobalEvent", event_sink, "PortalMissingPowerEvent", {} )
	end
```

#4. check pipe connection
from check_if_connected_by_same_pipe.lua  (objective for caves outpost mission)

```lua
haveAllEnts = BuildingService:IsSameConnection( laboratories, resourceName )
```