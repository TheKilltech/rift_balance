class 'compress_resource' ( LuaObjectiveScript )

function compress_resource:__init()
	LuaObjectiveScript.__init(self,self)
end

function compress_resource:init()
	self.fsm = self:CreateStateMachine()
	self.fsm:AddState( "update", { from="*", execute="onUpdate" } )
	self.fsm:AddState( "idle", {} )
	self.fsm:ChangeState( "update" )
	self:FindMaxResource()
    
    self.resourceName = self.data:GetStringOrDefault("resource_name", "")
    self.compressTime = self.data:GetIntOrDefault("compress_time", 3)
    self.currentCompressTime = 0.0
    self.lastProgress = 0.0
    self.version = 3
end

function compress_resource:onUpdate( state, dt)
	self:FindMaxResource()
    local blueprints =
    {
        "buildings/resources/liquid_compressor",
        "buildings/resources/liquid_compressor_lvl_2",
        "buildings/resources/liquid_compressor_lvl_3",
    }
    local entities = {}
    for  blueprint in Iter(blueprints) do
        ConcatUnique( entities, FindService:FindEntitiesByBlueprint( blueprint ) )
    end
    
    local progressCurrent = 0
    for ent in Iter( entities ) do
        if ( BuildingService:IsWorking( ent ) ) then
            local resourceConverterComponent = EntityService:GetComponent( ent, "ResourceConverterComponent")
            if ( resourceConverterComponent ~= nil ) then
                local lastOreProduced = resourceConverterComponent:GetField("last_ore_produced"):GetValue()
                local resource = lastOreProduced:gsub( "_compressed", "" )
                if ( resource == self.resourceName ) then
                    progressCurrent = progressCurrent + BuildingService:GetResourceProduction( ent, lastOreProduced)
                end
            end
        end
    end


    --LogService:Log(tostring(self.compressTime) .. ":" ..tostring(self.currentCompressTime) .. ":" ..tostring(progressCurrent) .. ":" ..tostring(self.lastProgress) )
    if (self.compressTime > 0 and self.currentCompressTime < self.compressTime ) then
        if ( progressCurrent == self.lastProgress and self.lastProgress ~= 0.0 ) then
            self.currentCompressTime = self.currentCompressTime + dt
            ObjectiveService:SetObjectiveStatusByObjectiveId( self.objective_id, OBJECTIVE_IN_PROGRESS )
        else
            self.data:SetInt( "progress_current", progressCurrent )
            self.currentCompressTime = 0
        end
    else
        if ( progressCurrent >= self.maxProgress ) then
	       if ( self.data:GetIntOrDefault( "finish_objective", 1) == 1) then
	    	   ObjectiveService:FinishObjectiveByObjectiveId( self.objective_id, OBJECTIVE_SUCCESS )
	       	   self.fsm:ChangeState( "idle" )
	    	else
	           ObjectiveService:SetObjectiveStatusByObjectiveId( self.objective_id, OBJECTIVE_SUCCESS )
	       end
	       progressCurrent = self.maxProgress
	    else
               self.currentCompressTime = 0
               ObjectiveService:SetObjectiveStatusByObjectiveId( self.objective_id, OBJECTIVE_IN_PROGRESS )
        end

        self.data:SetInt( "progress_current", progressCurrent )
    end
    self.lastProgress = progressCurrent
end

function compress_resource:OnLoad()
    if ( LuaObjectiveScript.OnLoad ) then
        LuaObjectiveScript.OnLoad(self)
    end

    if (self.version == nil or self.version < 2 )  then
        self.compressTime = self.data:GetIntOrDefault("compress_time", 3)
        self.currentCompressTime = 0.0
        self.lastProgress = 0
        self.version = 3
    end
end

function compress_resource:FindMaxResource() 
	if ( self.maxProgress ~= nil ) then
		return self.maxProgress
	end

	if ( self.data:GetIntOrDefault("is_additional", 0) == 1 ) then
		local resourceName = self.data:GetString( "resource_name" )
		self.data:SetInt("progress_max", self.data:GetInt( "progress_max" ) + PlayerService:GetResourceAmount(leadingPlayer, resourceName ))
	end
	self.maxProgress = self.data:GetInt( "progress_max" )

end

return compress_resource
