local building = require("lua/buildings/building.lua")

class 'planet_scanner' ( building )

function planet_scanner:__init()
	building.__init(self,self)
end

function planet_scanner:OnInit()
    self.planetScannerVersion = 1
    self:RegisterHandler( self.entity, "InteractWithEntityRequest", "OnInteractWithEntityRequest" )
end

function planet_scanner:OnInteractWithEntityRequest( event )
    local player = PlayerService:GetPlayerByMech( event:GetOwner() )
    QueueEvent("OpenPlanetaryScannerRequest",event:GetOwner(), player )
end

function planet_scanner:OnLoad()
    building.OnLoad(self)
    if ( self.planetScannerVersion == nil or self.planetScannerVersion < 1 ) then
        LogService:Log("OnLoad RegisterHandler")
        self:RegisterHandler( self.entity, "InteractWithEntityRequest", "OnInteractWithEntityRequest" )
        self.planetScannerVersion = 1
    end
end

return planet_scanner
