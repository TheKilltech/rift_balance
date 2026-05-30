class 'ion_storm' ( LuaEntityObject )

function ion_storm:__init()
	LuaEntityObject.__init(self, self)
end

function ion_storm:init()
	GuiService:EnableMinimapInterference()
end


function ion_storm:OnRelease()
	GuiService:DisableMinimapInterference()
end

return ion_storm