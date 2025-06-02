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

	local ent = ResourceService:FindEmptySpace( minDistanceFromPlayer, maxDistanceFromPlayer );
	ResourceService:SpawnResources( ent, "resources/volume_template_resource", resource, minAmount, maxAmount )
	local eartquake = EarthquakeService:SpawnEarthquake( ent, earthquakeEffect, timeOfDayPreset, markerBp, damagePerSecond, lifeTime, healthPercentage, radius, localEffectsRandomOffset, minimumDistancePerLocalEffect, cameraShakePower, cameraShakeFreq )
	EntityService:RemoveEntity( ent )

	local position = EntityService:GetPosition( eartquake )
	GuiService:AddMinimapCircleMarker( position, tostring( eartquake ), radius, marker_color_r, marker_color_g, marker_color_b, 90 / 255 )


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