local building_base = require("lua/buildings/building_base.lua")

class 'wall_gate_energy' ( wall_gate )

--Hard-coded here because otherwise there will be 12 copies. Static because they will never change.
--Search diameter
local diameter = 2.9 --Slighty smaller than the actual display diameter due to finicky detection near the edge
--Search interval in seconds
local period = 3 --Long interval to reduce the number of computations since there will be massive numbers of walls
--How many times faster the shield should decay than regenerate
local decay_multiplier = -1.5


function wall_gate_energy:__init()
	building_base.__init(self,self)
end

function wall_gate_energy:OnInit()
	building_base.OnInit()
		
	--Assign this Entity to a group for Map search purposes.
	EntityService:SetGroup(self.entity, "energy_walls")
	self.active = true	--Whether or not the building is turned on
	
	--Declare these to store data for later
	self.damageVal = 0 --Damage Reflection Amount
	self.regen_rate = 0 --Shield Recharge Rate when powered
	self.decay_rate = 0 --Shield Drain rate when unpowered
	self.regen_cooldown = 0 --Shield recharge delay after damage
	
	--Records which entities are currently affected by the shield. DO NOT TOUCH.
	--Syntax is different for efficiency reasons, and to store relational data.
	self.selected = {}
	
	--Import from bluprint database:
	--Blueprint of entity representing the shield
	self.shieldBp = self.data:GetStringOrDefault("shield_bp", "buildings/defense/wall_gate_energy/shield")
	
	--Create the state machine to periodically search for objects that need added to or removed from the shield.
	self.fsm = self:CreateStateMachine()
	self.fsm:AddState("working", {execute="OnWorkInProgress", exit="OnWorkExit", interval=period, object = "somedata"})
end


--Runs when the building turns on, including initial power on.
function wall_gate_energy:OnActivate()
	--Verify the shield component exists. Create it if missing.
	if self.healthChild == nil then
		--Create and attatch the Shield as a child object.
		self.healthChild = EntityService:SpawnAndAttachEntity(self.shieldBp, self.entity)
		--Add self to the shield.
		--This makes the shield feel snappy when placing the building, despite the long interval between scans.
		ItemService:AddHealthLink(self.entity, self.healthChild)
	end
	
	self:EnableDamage()
	self:ChargeShield()
	
	--Start up shield scan loop
	self.fsm:ChangeState("working")
end

--Runs when the building turns off, loses power, or is removed.
function wall_gate_energy:OnDeactivate()
	--Shut down Shield
	local state = self.fsm:GetState("working")
	if (state ~= nil) then
		state:Exit()
	end
	
	self:DisableDamage()
	self:DrainShield()
end

--Runs when the Building hits 0 HP
function wall_gate_energy:OnDestroy()
end

--STATE MACHINE--
--State Machine Loop function
function wall_gate_energy:OnWorkInProgress(state)
	--Check for the shield entity, and re-create it if it is missing.
	if (self.healthChild == INVALID_ID or HealthService:GetHealth(self.healthChild)== -1) then
		self.healthChild = EntityService:SpawnAndAttachEntity(self.shieldBp, self.entity)
	end
	
	--Search Map for targets
	local objects = FindService:FindEntitiesByGroupInRadius(self.entity, "energy_walls", diameter)
	
	--Check which found targets haven't been shielded, add the shield, and record them.
	for index, obj in ipairs(objects) do
		if (self.selected[obj] == nil and BuildingService:IsBuildingFinished(obj) and obj ~= self.entity) then
			ItemService:AddHealthLink(obj, self.healthChild)	--Add Shield
			self.selected[obj] = true	--Add Record 
		end
	end
	
	--Check for any recorded targets that no longer exist, and remove them.
	for obj, val in pairs(self.selected) do
		if (IndexOf(objects, obj) == nil) then
			ItemService:RemoveHealthLink(obj, self.healthChild)	--Remove shield
			self.selected[obj] = nil	--Delete Record
		end
	end
end

--State Machine Exit function (runs on power off, removal, or destruction of self)
function wall_gate_energy:OnWorkExit(state)
	--Remove shield from all targets, including the emitter, and delete all records.
	for obj, val in pairs(self.selected) do
		ItemService:RemoveHealthLink(obj, self.healthChild)
		self.selected[obj] = nil
	end
end

-----------------------------------------------------------------------------------------------------------
--SUBFUNCTIONS     SUBFUNCTIONS     SUBFUNCTIONS     SUBFUNCTIONS     SUBFUNCTIONS     SUBFUNCTIONS
-----------------------------------------------------------------------------------------------------------
--Enables Damage Reflection
function wall_gate_energy:EnableDamage()
	--Check that Damage Reflection amount is stored, then enable it
	local DRcomponent = reflection_helper(EntityService:GetComponent(self.entity, "ReflectDamageComponent"))
	if self.damageVal ~= 0 then
		--Restore Damage Reflection
		DRcomponent.damage_value = self.damageVal
	else
		--Store value if not set
		--Doing this here because onInit() is too early
		self.damageVal = DRcomponent.damage_value
	end
end

--Disables Damage Reflection
function wall_gate_energy:DisableDamage()	
	local DRcomponent = reflection_helper(EntityService:GetComponent(self.entity, "ReflectDamageComponent"))
	DRcomponent.damage_value = 0
end

--Sets Shield to charge
function wall_gate_energy:ChargeShield()
	--Check that Shield Regen amount is stored, then enable it
	local Rcomponent = reflection_helper(EntityService:GetComponent(self.healthChild, "RegenerationComponent"))
	if self.regen_rate ~= 0 then
		--Restore Damage Reflection
		Rcomponent.regeneration = self.regen_rate
		Rcomponent.regeneration_cooldown = self.regen_cooldown
	else
		--Store value if not set
		--Doing this here because onInit() is too early
		self.regen_rate = Rcomponent.regeneration
		self.decay_rate = decay_multiplier * self.regen_rate
		self.regen_cooldown = Rcomponent.regeneration_cooldown
	end
end

--Sets Shield to Drain
function wall_gate_energy:DrainShield()
	--Set Shield to decay
	local Rcomponent = reflection_helper(EntityService:GetComponent(self.healthChild, "RegenerationComponent"))
	Rcomponent.regeneration = self.decay_rate
	Rcomponent.regeneration_cooldown = 0
	
	--Subtract 1 HP to kickstart the drain, as otherwise it won't work if fully charged
	local Hcomponent = reflection_helper(EntityService:GetComponent(self.healthChild, "HealthComponent"))
	Hcomponent.health = Hcomponent.health - 1
end


return wall_gate_energy
