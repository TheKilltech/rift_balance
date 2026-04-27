local building = require("lua/buildings/building.lua")

class 'building_modular' ( building )

function building_modular:__init()
	building.__init(self,self)
end


function building_modular:Log( logLevel, message )
	local curLevel = 5 -- enable logging here ( 0 - errors, 2 - main entry points, 3 - details, 5 - loops )
	if logLevel <= curLevel then
		local context = "building_modular ".. self.buildingName .. " " .. tostring(self.entity)..": "
		LogService:Log( context .. tostring(message) )
	end
end

function building_modular:OnInit()
	self:InitParams();
end

function building_modular:OnLoad()
	self:Log(1,"OnLoad")
	self:InitParams()
	building.OnLoad(self)
end

function building_modular:OnDestroy()
	self:DespawnModules()
end

function building_modular:OnActivate()
	self:Log(1,"OnActivate")
	if self.moduleSpawnOnState > 0     then self:SpawnModules()
	elseif self.moduleSpawnOnState < 0 then self:DespawnModules()
	end
end

function building_modular:OnDeactivate()
	self:Log(1,"OnDeactivate")
	if self.moduleSpawnOnState > 0     then self:DespawnModules()
	elseif self.moduleSpawnOnState < 0 then self:SpawnModules()
	end
end

function building_modular:OnBuildingEnd()
	if self.moduleSpawnOnState >= 0 then
		self:SpawnModules()
	end
end

function building_modular:InitParams()
	local database = EntityService:GetBlueprintDatabase( self.entity ) or self.data;
	self.moduleAttachment   = database:GetStringOrDefault( "module_attachment", "" )
	self.moduleBps          = database:GetStringOrDefault( "module_blueprints", "" )
	self.moduleSpawnOnState = database:GetIntOrDefault( "module_spawn_state", 0 )
end

function building_modular:SpawnModules()
	self:Log(1, "SpawnModules ".. tostring(self.modules) .. " " .. tostring(#(self.modules or {})))
	if ( self.modules == nil or #self.modules == 0 ) then
		self.modules = {}

		local blueprints = Split( self.moduleBps, "," )
		for bp in Iter( blueprints ) do
			local moduleEntity = EntityService:SpawnAndAttachEntity(bp, self.entity, self.moduleAttachment );
			self:Log(2, "created ".. tostring(moduleEntity))
			Insert(self.modules, moduleEntity);
		end
	end
end

function building_modular:DespawnModules()
	self:Log(1, "DespawnModules ".. tostring(self.modules) .. " " .. tostring(#(self.modules or {})))
	if self.modules then
		for mod in Iter( self.modules ) do
			self:Log(2, "kill ".. tostring(mod))
			EntityService:DetachEntity( mod )
			EntityService:DissolveEntity( mod, 0.5 )
			--QueueEvent( "DissolveEntityRequest", mod, 0.5, 0.0 )
		end
		self.modules = {}
	end
end

return building_modular
