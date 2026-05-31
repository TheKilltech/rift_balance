local building = require("lua/buildings/building.lua")
require("lua/utils/table_utils.lua")

class 'building_jammer' ( building )

function building_jammer:__init()
	building.__init(self,self)
	--for k, v in pairs( require( "lua/misc/jammer.lua" ) )
	--	self[k] = v
	--end
end


function building_jammer:OnInit()
	building.OnInit( self )
end

function building_jammer:OnLoad()
	building.OnLoad( self )
end


function building_jammer:OnActivate()
	building.OnActivate( self )
	self:SetEnableFollower( true )
end

function building_jammer:OnDeactivate()
	building.OnDeactivate( self )
	self:SetEnableFollower( false )
end

function building_jammer:OnDestroy()
	building.OnDestroy( self )
	self:SetEnableFollower( false )
end

function building_jammer:OnSell()
	building.OnSell( self )
	self:SetEnableFollower( false )
end

function building_jammer:OnRelease()
	building.OnRelease( self )
	self:SetEnableFollower( false )
end

function building_jammer:OnBuildingEnd()
	building.OnBuildingEnd( self )
end

function building_jammer:SetEnableFollower( enable )
	enable = enable or false
	
	if enable then
		local pos = EntityService:GetPosition( self.entity )
		if (self.jammer or INVALID_ID) == INVALID_ID then
			self.jammer = EntityService:SpawnAndAttachEntity( "buildings/main/jammer_source", self.entity)
		end
	else
		if (self.jammer or INVALID_ID) ~= INVALID_ID then
			EntityService:DestroyEntity( self.jammer, "default" )
			self.jammer = nil
		end
	end
end

return building_jammer
