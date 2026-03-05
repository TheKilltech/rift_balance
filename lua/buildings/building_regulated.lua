local building = require("lua/buildings/building.lua")

class 'building_regulated' ( building )

function building_regulated:__init()
	building.__init(self,self)
end


local function GetRemainingCapacity(asRatio, resource1, resource2, resource3)
	local leader      = PlayerService:GetLeadingPlayer()
	local capacity    = PlayerService:GetResourceLimit(leader, resource1 )
	local remCapacity = capacity - PlayerService:GetResourceAmount(leader, resource1 )
	local result      = remCapacity
	if asRatio then result = remCapacity / capacity end
	
	if resource2 then
		capacity    = PlayerService:GetResourceLimit(leader, resource2 )
		remCapacity = capacity - PlayerService:GetResourceAmount(leader, resource2 )
		if asRatio then 
			result = math.max( result, remCapacity / capacity)
		else result = math.max( result, remCapacity)
		end
	end
	if resource3 then
		capacity    = PlayerService:GetResourceLimit(leader, resource3 )
		remCapacity = capacity - PlayerService:GetResourceAmount(leader, resource3 )
		if asRatio then 
			result = math.max( result, remCapacity / capacity)
		else result = math.max( result, remCapacity)
		end
	end
	
	return remCapacity
end

function building_regulated:OnInit()
	self.watchedResource1 = self.data:GetStringOrDefault("watched_resource", "")
	self.watchedResource2 = self.data:GetStringOrDefault("watched_resource2", "")
	self.watchedResource3 = self.data:GetStringOrDefault("watched_resource3", "")
	self.asRatio          = self.data:GetIntOrDefault("watched_as_ratio", 0)
	self.levelHigh        = self.data:GetFloatOrDefault("watched_level_high", 1000)
	self.asRatio = (self.asRatio ~= 0)
	if self.watchedResource2 == "" then self.watchedResource2 = nil end
	if self.watchedResource3 == "" then self.watchedResource3 = nil end
		
	self.fsm = self:CreateStateMachine()
	self.fsm:AddState( "full",    { enter="OnEnterFull", execute="OnExecuteFull", exit="OnExitFull",  interval = 10 } )
	self.fsm:AddState( "high",    { enter="OnEnterHigh", execute="OnExecuteHigh", exit="OnExitHigh",  interval = 10 } )
	self.fsm:AddState( "low",     { enter="OnEnterLow",  execute="OnExecuteLow",  exit="OnExitLow",   interval = 30 } )
	
	local remCapacity = GetRemainingCapacity(self.asRatio, self.watchedResource1, self.watchedResource2, self.watchedResource3)
	if (remCapacity > self.levelHigh) then self.fsm:ChangeState("low")
	elseif (remCapacity > 1)          then self.fsm:ChangeState("high")
	else                                   self.fsm:ChangeState("full")
	end
end


function building_regulated:OnEnterFull()
	--LogService:Log( "building_regulated (".. tostring(self.entity) .."): OnEnterFull " )
	
	BuildingService:SetResourceConverterEfficientyModificator( self.entity, 0 , "full" )
	BuildingService:AddConverterCostModifier( self.entity, 0 , "full" )
end

function building_regulated:OnExitFull()
	--LogService:Log( "building_regulated (".. tostring(self.entity) .."): OnExitFull" )
	
	BuildingService:RemoveResourceConverterEfficientyModificator( self.entity, "full" )
	BuildingService:RemoveConverterCostModifier( self.entity, "full" )
end

function building_regulated:OnExecuteFull(state, dt)
	if not self.working then return end
	local remCapacity = GetRemainingCapacity(self.asRatio, self.watchedResource1, self.watchedResource2, self.watchedResource3)
	--LogService:Log( "building_regulated (".. tostring(self.entity) .."): OnExecuteFull rcap ".. tostring(remCapacity) )
	self.fsm:ChangeState("high")
end



function building_regulated:OnEnterHigh()
	--LogService:Log( "building_regulated (".. tostring(self.entity) .."): OnEnterHigh" )
end

function building_regulated:OnExitHigh()
	--LogService:Log( "building_regulated (".. tostring(self.entity) .."): OnExitHigh" )
end

function building_regulated:OnExecuteHigh(state, dt)
	local remCapacity = GetRemainingCapacity(self.asRatio, self.watchedResource1, self.watchedResource2, self.watchedResource3)
	--LogService:Log( "building_regulated (".. tostring(self.entity) .."): OnExecuteHigh rcap ".. tostring(remCapacity) )
	
	if (remCapacity > self.levelHigh) then self.fsm:ChangeState("low")
	elseif (remCapacity < 1)          then self.fsm:ChangeState("full")
	end
end


function building_regulated:OnEnterLow()
	--LogService:Log( "building_regulated (".. tostring(self.entity) .."): OnEnterLow" )
	
end

function building_regulated:OnExitLow()
	--LogService:Log( "building_regulated (".. tostring(self.entity) .."): OnExitLow" )
end

function building_regulated:OnExecuteLow(state, dt)
	if not self.working then return end
	local remCapacity = GetRemainingCapacity(self.asRatio, self.watchedResource1, self.watchedResource2, self.watchedResource3)
	--LogService:Log( "building_regulated (".. tostring(self.entity) .."): OnExecuteLow rcap ".. tostring(remCapacity) )
	if (remCapacity < self.levelHigh) then self.fsm:ChangeState("high") end
end

return building_regulated
