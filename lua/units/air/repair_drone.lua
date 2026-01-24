require("lua/utils/numeric_utils.lua")
require("lua/utils/throttler_utils.lua")

local base_drone = require("lua/units/air/base_drone.lua")
class 'repair_drone' ( base_drone )

local LOCK_TYPE_REPAIR = "repair";
SetTargetFinderThrottler( LOCK_TYPE_REPAIR, 5 )

function FindMostDestroyedEntity( entities )
	local lowest_entity = INVALID_ID
	local lowest_pct = 1.0

	for entity in Iter( entities ) do
		local healthPct = HealthService:GetHealthInPercentage( entity );
		if healthPct < lowest_pct then
			lowest_entity = entity;
			lowest_pct = healthPct;
		end
	end

	return lowest_entity
end

function FindBestDestroyedEntity( source, entities )
    local best = {
        entity = INVALID_ID,
        distance = nil
    };

    for entity in Iter( entities ) do
		local distHp    = HealthService:GetHealthInPercentage( entity );
        local distMeter = EntityService:GetDistanceBetween( source, entity ) * (distHp*distHp);
        local distance  = distMeter * (distHp*distHp);
        if best.entity == INVALID_ID or distance < best.distance then
            best.entity   = entity;
            best.distance = distance;
        end
    end

    return best.entity;
end

function repair_drone:__init()
	base_drone.__init(self,self)
end

function repair_drone:FillInitialParams()
    if self.data:HasFloat("drone_search_radius") then
        self.search_radius = self.data:GetFloat("drone_search_radius")
    else
        self.search_radius = self.data:GetFloat("search_radius")
    end
    self.own_search_radius = self.data:GetFloatOrDefault("drone_own_search_radius", 0)
    self.full_search_interval = self.data:GetFloatOrDefault("drone_full_search_interval", 10)
    self.full_search = 1

    self.heal_amount_player =  self.data:GetFloatOrDefault("heal_amount_player", 0.0);
    self.heal_amount = self.data:GetFloat("heal_amount");
    self.heal_interval = self.data:GetFloat("heal_interval");
end

function repair_drone:OnInit()
    self:FillInitialParams();

    self.fsm = self:CreateStateMachine();
    self.fsm:AddState("repair", { enter="OnRepairEnter", execute="OnRepairExecute", exit="OnRepairExit", interval = self.heal_interval } );
    self.fsm:AddState("follow", { execute="OnFollowExecute", interval = self.heal_interval } );
end

function repair_drone:OnLoad()
    self:FillInitialParams();

    base_drone.OnLoad( self )
end

function repair_drone:FinishTargetAction( state )
    EffectService:DestroyEffectsByGroup(self.entity, "work");

    self:UnlockAllTargets();
    self:SetTargetActionFinished();

    if state then
        state:Exit()
    end
end

function repair_drone:FindActionTarget()
    self.fsm:Deactivate()

    local owner = self:GetDroneOwnerTarget();
    self.temp_predicate_owner = owner;
    -- if not EntityService:IsAlive( owner ) then
    --     return INVALID_ID
    -- end


    self.predicate = self.predicate or {
        signature="HealthComponent,BuildingComponent",
        team = EntityService:GetTeam(self.entity),
        filter = function(entity)
            if self:IsTargetLocked(entity, LOCK_TYPE_REPAIR) then
               return false
            end

            if entity == self.temp_predicate_owner then
                return false
            end 

            if not HealthService:IsAlive(entity) then
                return false
            end

            local health = HealthService:GetHealthInPercentage( entity )
            if health >= 1.0 then
                return false
            end

            local mode = BuildingService:GetBuildingMode(entity)
            if mode ~= BM_COMPLETED then
                return false
            end

            return true;
        end
    };

    if not HealthService:IsAlive( owner ) then
        return INVALID_ID
    end

    if self.heal_amount_player > 0 and HealthService:GetHealthInPercentage( owner ) < 1.0 then
        local component = EntityService:GetComponent(owner, "MechMovementComponent")
        if component ~= nil then

            if Length( reflection_helper( component ).velocity ) <= 0.1 then
                return owner
            end
        end
    end

    if IsRequestThrottled(LOCK_TYPE_REPAIR) then
        return INVALID_ID
    end

	local entities = {}
	if self.own_search_radius > 0 and self.full_search ~= 1 then
		entities  = FindService:FindEntitiesByPredicateInRadius( self.entity, self.own_search_radius, self.predicate )
	else entities = FindService:FindEntitiesByPredicateInRadius( owner,       self.search_radius,     self.predicate )
	end
	self.full_search = (self.full_search % self.full_search_interval) + 1

	if #entities == 0 then
		return INVALID_ID
	end

	local target = FindBestDestroyedEntity( self.entity, entities )

	self:LockTarget( target, LOCK_TYPE_REPAIR );
	self.target_last_position = EntityService:GetPosition( target )

    self.fsm:ChangeState("follow")

    return target;
end

function repair_drone:OnFollowExecute(state)
    local target = self:GetDroneActionTarget();
    if target == INVALID_ID or self:HasTargetMoved( target ) then
        return self:FinishTargetAction(state)
    end
end

function repair_drone:OnDroneTargetAction( target )
    if not EntityService:IsAlive( target ) then
        self:SetTargetActionFinished();
        self.fsm:ChangeState("follow")
    else
        self.fsm:ChangeState("repair")
    end
end

function repair_drone:HasTargetMoved( target )
    if not EntityService:IsAlive(target) then
        return true
    end

    local target_position = EntityService:GetPosition(target)
    if not self.target_last_position then
        self.target_last_position = target_position
    end
    
    local distance = Length(VectorSub(self.target_last_position, target_position))
    return distance >= 1.0
end

function repair_drone:OnRepairEnter(state)
    local target = self:GetDroneActionTarget();
    if EntityService:IsAlive(target) then
        self.target_last_position = EntityService:GetPosition(target)
	end
	self:OnRepairExecute(state)
end

function repair_drone:OnRepairExecute( state )
    local target = self:GetDroneActionTarget();
    if self:HasTargetMoved( target ) then
        return self:FinishTargetAction(state)
    end

    if not HealthService:IsAlive(target) then
        return self:FinishTargetAction(state)
    end

    local owner = self:GetDroneOwnerTarget();
    if EntityService:GetDistance2DBetween( owner, target ) > ( self.search_radius * 1.1 ) then
        return self:FinishTargetAction(state)
    end

    if not EffectService:HasEffectByGroup(self.entity, "work") then
        EffectService:AttachEffects(self.entity, "work");
    end
    
    EffectService:SpawnEffects(target, "repair");

    local health = HealthService:GetHealth(target);
    local maxHealth = HealthService:GetMaxHealth(target);

	health = health + (target == owner and self.heal_amount_player or self.heal_amount)

    HealthService:SetHealth(target, math.min( health, maxHealth ));
	if state:GetDuration() < self.heal_interval then return end
    if health >= maxHealth then
        return self:FinishTargetAction(state)
    end
end

function repair_drone:OnRepairExit()
	if not self:SetDroneTarget() then
		self:FinishTargetAction()
	end
end

return repair_drone;