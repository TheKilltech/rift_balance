require("lua/utils/reflection.lua")

local building = require("lua/buildings/building.lua")

class 'short_range_radar' ( building )

function short_range_radar:__init()
	building.__init(self,self)
end

function short_range_radar:InitRadar()
	if not self.radar_fsm then
		self.radar_fsm = self:CreateStateMachine();
		self.radar_fsm:AddState("update_range", { execute = "OnUpdateRangeExecute", exit = "OnUpdateRangeExit", interval = 0.2 })
	end

	self.radar_range = self.data:GetFloat("range")	
end

function short_range_radar:OnInit()
	self:InitRadar();
end

function short_range_radar:OnLoad()
	building.OnLoad(self)
	
	self:InitRadar();
end

function short_range_radar:OnActivate()
	self.radar_fsm:ChangeState("update_range")
end

function short_range_radar:OnDeactivate()
	self.radar_fsm:ChangeState("update_range")

	EffectService:DestroyEffectsByGroup(self.entity, "working")	
end

local RADAR_EXPAND_DURATION = 1.5

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

	radar_component.radius = self.radar_range * progress
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

return short_range_radar
