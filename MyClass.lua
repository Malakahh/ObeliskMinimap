----------
-- Meta --
----------

local _, ns = ...
local libraryName = "Obelisktest"
local major, minor = 0, 1

---------------
-- Libraries --
---------------

local test.lua = ObeliskFrameworkManager:NewLibrary(libraryName, major, minor)
if not test.lua then 
	error(ns.Debug:sprint(libraryName, "Failed to create library"))
end

local FrameworkClass = ObeliskFrameworkManager:GetLibrary("ObeliskFrameworkClass", 0)
if not FrameworkClass then
	error(ns.Debug:sprint(libraryName, "Failed to load ObeliskFrameworkClass"))
end

if ns.OBELISK_DEBUG then
	ns.Debug:print(libraryName, "LOADED")
end

test.lua.libraryName = libraryName

setmetatable(test.lua, {
	__call = function (self, ...)
		return self:New(...)
	end,
	__index = test.lua
})

---------------
-- Functions --
---------------

function test.lua:New()
	local instance = FrameworkClass(self)

	return instance
end


