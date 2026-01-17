require("lua/utils/numeric_utils.lua")
require("lua/utils/throttler_utils.lua")

local base_drone = require("lua/units/air/base_drone.lua")
class 'repair_drone' ( base_drone )

local LOCK_TYPE_REPAIR = "repair";
SetTargetFinderThrottler(LOCK_TYPE_REPAIR, 3)

function FindMostDestroyedEntity( source, entities )
    local find = {
        entity = INVALID_ID,
        healthPct = nil
    };

    for entity in Iter( entities ) do
        local healthPct = HealthService:GetHealthInPercentage( entity );
        if healthPct < 1.0 and (find.entity == INVALID_ID or healthPct < find.healthPct) then
            find.entity = entity;
            find.healthPct = healthPct;
        end
    end

    return find.entity;
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
    if not EntityService:IsAlive( owner ) then
        return INVALID_ID
    end

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

    local entities = FindService:FindEntitiesByPredicateInRadius( owner, self.search_radius, self.predicate );
    
    local target = FindMostDestroyedEntity( owner, entities );
    if target ~= INVALID_ID then
        self:LockTarget( target, LOCK_TYPE_REPAIR);
        self.target_last_position = EntityService:GetPosition(target)
    end

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

	if self.heal_amount_player > 0 and target == owner then
		health = health + self.heal_amount_player
	else
		health = health + self.heal_amount
	end

    HealthService:SetHealth(target, math.min( health, maxHealth ));
	if state:GetDuration() < self.heal_interval then return end
    if health >= maxHealth then
        return self:FinishTargetAction(state)
    end
end

function repair_drone:OnRepairExit()
    self:FinishTargetAction()
end

return repair_drone;