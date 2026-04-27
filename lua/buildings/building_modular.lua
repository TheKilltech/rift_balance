local building = require("lua/buildings/building.lua")

class 'ammo_importer' ( building )

function ammo_importer:__init()
	building.__init(self,self)
end


function ammo_importer:OnInit()
	self:InitParams();
end

function ammo_importer:OnLoad()
	self:InitParams();
	self:SpawnModules();

	building.OnLoad(self)
end


function ammo_importer:OnBuildingEnd()
	self:SpawnModules()
end

function ammo_importer:InitParams()
	local database = EntityService:GetBlueprintDatabase( self.entity ) or self.data;
	self.moduleAttachment = database:GetStringOrDefault( "module_attachment", "att_level" )
	self.moduleBps        = database:GetStringOrDefault( "module_blueprints", "buildings/ammo/ammo_importer_low_calib_1_module" )
end

function ammo_importer:SpawnModules()
	if ( self.modules == nil or #self.modules == 0 ) then
		self.modules = {}

		local blueprints = Split( self.moduleBps, "," )
		for bp in Iter( blueprints ) do
			local moduleEntity = EntityService:SpawnAndAttachEntity(bp, self.entity, self.moduleAttachment );
			Insert(self.modules, moduleEntity);
		end
	end
end


return ammo_importer
