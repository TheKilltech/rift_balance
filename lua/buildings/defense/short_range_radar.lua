require("lua/utils/reflection.lua")
require("lua/utils/numeric_utils.lua")

local building = require("lua/buildings/building.lua")

class 'short_range_radar' ( building )

function short_range_radar:__init()
	building.__init(self,self)
end

function short_range_radar:Log( logLevel, message )
	local curLevel = 0 -- enable logging here ( 0 - errors, 2 - main entry points, 3 - details, 5 - loops )
	if logLevel <= curLevel then
		local context = "short_range_radar ".. self.buildingName .. " " .. tostring(self.entity)..": "
		LogService:Log( context .. tostring(message) )
	end
end

function short_range_radar:InitRadar()
	if not self.radar_fsm then
		self.radar_fsm = self:CreateStateMachine();
		self.radar_fsm:AddState("update_range", { execute = "OnUpdateRangeExecute", exit = "OnUpdateRangeExit", interval = 0.2 })
		self.radar_fsm:AddState("reset_range", { enter = "OnResetRangeEnter" })
	end

	self.radar_range_max = self.data:GetFloat("range")
	
	if not self.jammers     then self.jammers = {} end
	if not self.radar_range then self.radar_range = self.radar_range_max end
end

function short_range_radar:OnInit()
	self:Log( 2, "OnInit" )
	self:InitRadar();
	
	self:RegisterHandler( event_sink, "LuaGlobalEvent", "OnLuaGlobalEvent" )
end

function short_range_radar:OnLoad()
	self:Log( 2, "OnLoad" )
	building.OnLoad(self)
	
	self:InitRadar();
end

function short_range_radar:OnBuildingEnd()
	self:Log( 2, "OnBuildingEnd" )
	self:FindAndUpdateJammers()
end

function short_range_radar:OnLuaGlobalEvent( event )
	if event:GetEvent() == "JammingEndEvent" then	self:OnJammingEndEvent( event ) 
	elseif event:GetEvent() == "JammingEvent" then	self:OnJammingEvent( event ) 
	end
end

function short_range_radar:OnActivate()
	self.radar_fsm:ChangeState("reset_range")
end

function short_range_radar:OnDeactivate()
	self.radar_fsm:ChangeState("reset_range")

	EffectService:DestroyEffectsByGroup(self.entity, "working")	
end


local RADAR_EXPAND_DURATION = 2.5

function short_range_radar:OnUpdateRangeExecute(state, dt)
	local radar_component = EntityService:GetComponent(self.entity, "RadarComponent")
	if not radar_component then
		radar_component = EntityService:CreateComponent(self.entity, "RadarComponent")
	end

	radar_component = reflection_helper(radar_component)

	local progress = state:GetDuration() / RADAR_EXPAND_DURATION
	if progress > 1.0 then
		progress = 1.0
	elseif progress < 0.0 then
		progress = 0.0
	end

	if not self.working then
		progress = 1.0 - progress
	end

	radar_component.radius = Lerp( radar_component.radius, self.radar_range, progress)
	radar_component.marked_position.y = 100

	if self.working and progress >= 1.0 then
		self.radar_fsm:Deactivate()
	elseif not self.working and progress <= 0.0 then
		self.radar_fsm:Deactivate()
	end
end

function short_range_radar:OnUpdateRangeExit(state)
	if EnvironmentService:GetRadarCoveragePercentage() >= 0.75 then
		CampaignService:UnlockAchievement( ACHIEVEMENT_ALL_SEEING_EYE )
	end

	if not self.working then
		EntityService:RemoveComponent(self.entity, "RadarComponent")
	end
end

function short_range_radar:OnResetRangeEnter()
	self:UpdateRange()
	self.radar_fsm:ChangeState("update_range")
	self:Log( 2, "OnResetRangeEnter - ".. tostring(self.radar_range) .. " / ".. tostring(self.radar_range_max) .. " with ".. tostring(self.jammersCount) .. " jammers registered")
	
	if self.jammersCount > 0 then
		if (self.jamming_effect or INVALID_ID) == INVALID_ID then
			self.jamming_effect = EntityService:SpawnAndAttachEntity( "buildings/defense/jamming_icon", self.entity, "att_jamming_info", "")
		end
	else 
		if (self.jamming_effect or INVALID_ID) ~= INVALID_ID then
			EntityService:RemoveEntity( self.jamming_effect )
			self.jamming_effect = nil
		end
	end
end

function short_range_radar:OnJammingEvent( event ) 
	self:Log( 2, "OnJammingEvent - ".. tostring(event))
	local eventDb = event:GetDatabase()	
	self:UpdateJammers( eventDb, ent )
end

function short_range_radar:OnJammingEndEvent( event ) 
	self:Log( 2, "OnJammingEndEvent - ".. tostring(event))
	local eventDb = event:GetDatabase()
	local ent = eventDb:GetIntOrDefault("jamming_entity", 0)
	if ent == 0 then
		self:ResetJammers()
		self.radar_fsm:ChangeState("reset_range")
	elseif self.jammers[ent] ~= nil then
		self.jammers[ent] = nil
		self.radar_fsm:ChangeState("reset_range")
	end
end

function short_range_radar:UpdateRange()
	local n = 0
	local r = self.radar_range_max
	local mult = 1
	
	for ent, jammer in pairs(self.jammers) do
		mult = Lerp( jammer.strength, 0, jammer.dist / jammer.radius )
		mult = 1 - Clamp( mult, 0, 1)
		r    = r * mult
		n    = n + 1 
		self:Log( 6, "calc jammer - ".. tostring(n) .. " entity ".. tostring(jammer.entity) ..  " dist ".. tostring(jammer.dist) .. " mult ".. tostring(mult) .. " ")
	end
	self.radar_range = r
	self.jammersCount = n
end

function short_range_radar:UpdateJammers( jammerDb, ent )
	local jammer = {}
	jammer.entity   = jammerDb:GetIntOrDefault("jamming_entity", ent or 0)
	jammer.radius   = jammerDb:GetFloatOrDefault("jamming_range",   100.0)
	jammer.strength = jammerDb:GetFloatOrDefault("jamming_strength", 1.0)
	jammer.pos      = EntityService:GetPosition( jammer.entity )
	local pos       = EntityService:GetPosition( self.entity )
	jammer.dist     = Distance( pos, jammer.pos )
	
	if jammer.dist < jammer.radius then
		self.jammers[jammer.entity] = jammer
		self.radar_fsm:ChangeState("reset_range")
		return true
	end
	return false
end

function short_range_radar:FindAndUpdateJammers( ) 
	self:Log( 2, "FindAndUpdateJammers" )
	
	local entities = FindService:FindEntitiesByType( "jammer" )
	self:Log( 5, "jammers (by type) found ".. tostring(#entities) )
	
	for ent in Iter(entities ) do
		local data = EntityService:GetDatabase( ent )
		self:UpdateJammers( data, ent )
	end
end

function short_range_radar:ResetJammers()
	self.jammers = {}
	self:FindAndUpdateJammers();
end

return short_range_radar
