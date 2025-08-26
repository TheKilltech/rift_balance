local tower = require("lua/buildings/defense/tower.lua")

class 'fire_control_station' ( tower )

function fire_control_station:__init()
	tower.__init(self,self)
end

function fire_control_station:OnInit()
	-- LogService:Log( "FCS: OnInit" )
	self.restriction = "defense"
	self.radius = 40
	self.alert = 1
	self.alertCooldown = 10
	self.alertLight = "off"
	
	self.radius = self.data:GetFloatOrDefault("radius", 40)
	self.restriction = self.data:GetStringOrDefault("restriction", "defense" )
	
	self:RegisterHandler(self.entity, "TurretEvent", "OnTurretEvent")
	
	self.fsm = self:CreateStateMachine()
	self.fsm:AddState("alert",          { enter = "OnEnterAlert",         execute = "OnExecuteAlert",         exit = "OnExitAlert",                  interval = 30 })
	self.fsm:AddState("alert_cooldown", { enter = "OnEnterAlertCooldown", execute = "OnExecuteAlertCooldown", exit = "OnExitCooldownAlertCooldown" , interval = 2 })
	self.fsm:AddState("noalert",        { enter = "OnEnterNoAlert",       execute = "OnExecuteNoAlert",       exit = "OnExitNoAlert",                interval = 30 })
end


function fire_control_station:OnActivate()
	-- LogService:Log( "FCS: OnActivate" )
	self.powered = true
	self.fsm:ChangeState("alert_cooldown")
	if ( AnimationService:HasAnim( self.entity, "working") ) then
		AnimationService:StartAnim( self.entity, "working", true )
	end
end

function fire_control_station:OnDeactivate()
	-- LogService:Log( "FCS: OnDeactivate" )
	self.powered = false
	self.fsm:ChangeState("alert_cooldown")
	if ( AnimationService:IsAnimActive( self.entity, "working") ) then
		AnimationService:StopAnim( self.entity, "working")
	end
end

local TS_ON_WEAPON_AIM = 4 -- constant enum value of GetTurretStatus return type
local noTargetId = "4294967295" -- max uint: 2^32 - 1 or (uint)(-1)

function fire_control_station:OnTurretEvent(evt)
	-- LogService:Log( "FCS: OnTurretEvent" )
	local target  = evt:GetTargetEntity()
	local tstatus = evt:GetTurretStatus()
	-- LogService:Log( "FCS: event target ".. tostring(target) .. " status ".. tostring(tstatus) .. " alert " ..tostring(self.alert))
	if tostring(target) ~= noTargetId then 
		-- LogService:Log( "FCS: turret has target")
		self.fsm:ChangeState("alert")
	elseif tstatus == 0 and self.alert > 0 then
		-- LogService:Log( "FCS: no target")
		self.fsm:ChangeState("alert_cooldown")
	end
end

--------- state = alert

function fire_control_station:OnEnterAlert(state)	
	-- LogService:Log( "FCS: OnEnterAlert alert ".. tostring(self.alert))
	if self.alert ~= 2 then self:Update(2) end
	self:OperateAlertLight("red")
end

function fire_control_station:OnExecuteAlert(state, dt )
	-- LogService:Log( "FCS: OnExecuteAlert alert ".. tostring(self.alert) ..", cooldown ".. tostring(self.updateCooldown))
	if self.updateCooldown == nil or self.updateCooldown < 0 then
		self:Update(2)
	end
	self.updateCooldown = self.updateCooldown - dt
end

function fire_control_station:OnExitAlert(state)	
	-- LogService:Log( "FCS: OnExitAlert alert ".. tostring(self.alert))
end

--------- state = alert_cooldown

function fire_control_station:OnEnterAlertCooldown(state)	
	-- LogService:Log( "FCS: OnEnterAlertCooldown alert ".. tostring(self.alert))
	self:OperateAlertLight("yellow")
	self.alertCooldown = 10
	self.alert = 1
end

function fire_control_station:OnExecuteAlertCooldown(state, dt)
	-- LogService:Log( "FCS: OnExecuteAlertCooldown alert ".. tostring(self.alert) ..", cooldown ".. tostring(self.alertCooldown))
	self.alertCooldown = self.alertCooldown - dt
	if self.alertCooldown <= 0 then	
		-- LogService:Log( "FCS: cooldown ended. switching off alert" )
		self.fsm:ChangeState("noalert")
	end
end

function fire_control_station:OnExitCooldownAlertCooldown(state)	
	-- LogService:Log( "FCS: OnExitCooldownAlertCooldown alert ".. tostring(self.alert) ..", cooldown " .. tostring(self.alertCooldown))
end

--------- state = noalert

function fire_control_station:OnEnterNoAlert(state)	
	-- LogService:Log( "FCS: OnEnterNoAlert alert ".. tostring(self.alert))
	if self.alert ~= 0 then self:Update(0) end
	self:OperateAlertLight("green")
end

function fire_control_station:OnExecuteNoAlert(state, dt )
	-- LogService:Log( "FCS: OnExecuteNoAlert alert ".. tostring(self.alert) ..", cooldown ".. tostring(self.updateCooldown))
	if self.updateCooldown == nil or self.updateCooldown < 0 then
		self:Update(0)
	end
	self.updateCooldown = self.updateCooldown - dt
end

function fire_control_station:OnExitNoAlert(state)	
	-- LogService:Log( "FCS: OnExitNoAlert alert ".. tostring(self.alert))
end




function fire_control_station:GetControlledEntities()
	-- LogService:Log( "FCS: GetControlledEntities" )
	local entities = FindService:FindEntitiesByTypeInRadius( self.entity, "defense", self.radius )
	-- LogService:Log( "FCS: ".. tostring(#entities) .. " in radius ".. tostring(self.radius))
	
	local controlled = {}
    for ent in Iter(entities ) do
        if EntityService:GetComponent(ent, "ResourceConverterComponent") == nil	then goto continue end
		if ( not BuildingService:IsBuildingFinished( ent ))						then goto continue end
		
		local bpname = EntityService:GetBlueprintName(ent)
		if self.restriction == "defense" then
			if string.find(bpname, "fire_control_station") then goto continue end
			if string.find(bpname, "repair_facility")      then goto continue end
			if string.find(bpname, "short_range_radar")    then goto continue end
			if string.find(bpname, "ai_hub")               then goto continue end
			if string.find(bpname, "wall")                 then goto continue end
			
			Insert(controlled, ent)
		elseif self.restriction == "artillery" then
			if     string.find(bpname, "heavy_artillery") then Insert(controlled, ent)
			elseif string.find(bpname, "tower_hcm")       then Insert(controlled, ent)
			elseif string.find(bpname, "tower_water_big") then Insert(controlled, ent)
			elseif string.find(bpname, "tower_power_rod") then Insert(controlled, ent)
			end
		else self.restriction = "defense" -- for compatibility with older saves where the flag was missing
		end
		::continue::
    end
	
	-- LogService:Log( "FCS ".. self.restriction .." list")
    --for ent in Iter(controlled ) do
		--LogService:Log( "FCS ".. self.restriction ..": entity ".. tostring(ent).. " name ".. tostring(EntityService:GetBlueprintName(ent)))
	--end

    return controlled
end

function fire_control_station:SwitchPowerState( entities, newStatus )  
	-- LogService:Log( "FCS: SwitchPowerState ".. tostring(#entities) .. " entities to power state ".. tostring(newStatus))
	for entity in Iter( entities ) do
		QueueEvent("ChangeBuildingStatusRequest", entity, newStatus )
	end
end

function fire_control_station:Update( newalert )
	-- LogService:Log( "FCS: Update ".. tostring(self.alert) .."-".. tostring(newalert).. " alert, ".. tostring(self.restriction) .. " restr., ".. tostring(self.updateCooldown).. " cooldown" )
	
	if self.working then
		local entities = self:GetControlledEntities()
		if newalert == 0 then
			self:SwitchPowerState( entities, false )
		elseif newalert == 2 then
			self:SwitchPowerState( entities, true )
		end
	end
	self.updateCooldown = 30 * (3 + newalert)
	self.alert = newalert
end

function fire_control_station:OperateAlertLight( targetLightState )
	-- LogService:Log( "FCS: OperateAlertLight from ".. tostring(self.alertLight) .. " to " .. tostring(targetLightState))
	if self.alertLight == targetLightState then return end
	
	if self.alertLight == "red" then
		EffectService:DestroyEffectsByGroup(self.entity, "alert_red")
	elseif self.alertLight == "yellow" then
		EffectService:DestroyEffectsByGroup(self.entity, "alert_yellow")
		EffectService:DestroyEffectsByGroup(self.entity, "target")
	elseif self.alertLight == "green" then
		EffectService:DestroyEffectsByGroup(self.entity, "alert_green")
	end
	
	if self.working == true then		
		if targetLightState == "red" then
			EffectService:AttachEffects(self.entity, "alert_red")
			EffectService:AttachEffects(self.entity, "target")
		elseif targetLightState == "yellow" then
			EffectService:AttachEffects(self.entity, "alert_yellow")
		elseif targetLightState == "green" then
			EffectService:AttachEffects(self.entity, "alert_green")
		end
		self.alertLight = targetLightState
	elseif self.working == false then 
		self.alertLight = "off"
	end
end

return fire_control_station
