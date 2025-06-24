class 'resource_earthquake' ( LuaGraphNode )

function resource_earthquake:__init()
	LuaGraphNode.__init(self,self)
end

function resource_earthquake:init()
end

function resource_earthquake:Activated()

	local earthquakeEffect = self.data:GetString( "earthquake_effect" )
	local timeOfDayPreset = self.data:GetString( "time_of_day_preset" )
	local markerBp = self.data:GetString( "marker_bp" )
	local damagePerSecond = self.data:GetFloat( "damage_per_second" )
	local healthPercentage = self.data:GetFloat( "health_percentage" )
	local localEffectsRandomOffset = self.data:GetFloat( "local_effects_random_offset" )
	local minimumDistancePerLocalEffect = self.data:GetFloat( "minimum_distance_per_local_effect" )
	local lifeTime = self.data:GetInt( "life_time" )
	local cameraShakePower = self.data:GetFloat( "camera_shake_power" )
	local radius = self.data:GetFloat( "radius" )
	local cameraShakeFreq = self.data:GetInt( "camera_shake_freq" )

	local resource				= self:PickRandomResource( self.data:GetString( "resource" ) )
	local minAmount				= self.data:GetInt( "min_amount" )
	local maxAmount				= self.data:GetInt( "max_amount" )
	local minDistanceFromPlayer	= self.data:GetInt( "min_distance_from_player" )
	local maxDistanceFromPlayer	= self.data:GetInt( "max_distance_from_player" )

	local marker_color_r = self.data:GetInt( "marker_color_r" ) / 255
	local marker_color_g = self.data:GetInt( "marker_color_g" ) / 255
	local marker_color_b = self.data:GetInt( "marker_color_b" ) / 255
	local marker_color_a = self.data:GetInt( "marker_color_a" ) / 255

	local ent = ResourceService:FindEmptySpace( minDistanceFromPlayer, maxDistanceFromPlayer )

	if ( ent ~= INVALID_ID ) then
		local spaces = ResourceService:FindEmptySpacesFromEntity( ent, 15, radius, 3 )

		local X, Y, Z = 0, 0, 0
		local numSpaces = #spaces

		for i = 1, numSpaces do
			local space = spaces[i]

			local spaceOrigin = EntityService:GetPosition( space )

			X = X + spaceOrigin.x
			Y = Y + spaceOrigin.y
			Z = Z + spaceOrigin.z

			ResourceService:SpawnResources( space, "resources/volume_template_resource", resource, minAmount / numSpaces, maxAmount / numSpaces )
		end
		
		local centerEnt = INVALID_ID

		if ( #spaces == 0 ) then
			ResourceService:SpawnResources( ent, "resources/volume_template_resource", resource, minAmount, maxAmount )
			centerEnt = ent
		else
			local centerOrigin = { x = X / numSpaces, y = Y / numSpaces, z = Z / numSpaces }
			centerEnt = EntityService:SpawnEntity( "logic/position_marker", centerOrigin.x, centerOrigin.y, centerOrigin.z, "" )			
		end

		local eartquake = EarthquakeService:SpawnEarthquake( centerEnt, earthquakeEffect, timeOfDayPreset, markerBp, damagePerSecond, lifeTime, healthPercentage, radius, localEffectsRandomOffset, minimumDistancePerLocalEffect, cameraShakePower, cameraShakeFreq )
		
		EntityService:RemoveEntity( ent )

		if ( centerEnt ~= INVALID_ID ) then
			EntityService:RemoveEntity( centerEnt )
		end

		local position = EntityService:GetPosition( eartquake )
		GuiService:AddMinimapCircleMarker( position, tostring( eartquake ), radius, marker_color_r, marker_color_g, marker_color_b, 90 / 255 )
	end

	self:SetFinished()
end

function resource_earthquake:PickRandomResource( resources )
	local list = Split( resources, "|" )

	if ( #list > 0 ) then
		local random = RandInt( 1, #list )
		return list[random]
	end

	return "carbon_vein"
end

return resource_earthquake