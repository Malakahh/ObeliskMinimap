local _, ns = ...

local libGridView = ObeliskFrameworkManager:GetLibrary("ObeliskGridView", 1)
if not libGridView then
	print("libGridView not gotten")
end

local cellSize = 32

local frame = libGridView(0, 0, "ObeliskMinimapButtonCollector", Minimap);
frame:SetScript("OnEvent", function ( self, event, ... ) self[event](self, ...) end)
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 25, -25)
frame:Show()

frame.CollectedButtons = {}

local Includes = {
	--GarrisonLandingPageMinimapButton = true, 
	MiniMapTracking = true,
}

local Excludes = {
	ObeliskMinimapButtonCollector = true,
	MinimapBackdrop = true,
	MiniMapMailFrame = true,
	MiniMapVoiceChatFrame = true,
	GameTimeFrame = true,
	--DBMMinimapButton = true,
	TimeManagerClockButton = true,
}

local function IsExcluded(val)
	local t = type(val)
	if t == "string" then
		return Excludes[val] or false
	elseif t == "table" and val.GetName ~= nil then
		return Excludes[val:GetName()] or false
	else
		return false
	end
end

function frame:PLAYER_LOGIN( ... )
	ns.Options:RegisterForOkay(self.Initialize, self)
	self:SetCellSize(cellSize, cellSize)
	self:CollectButtons()
	self:Initialize()
end

function frame:Initialize()
	self:AdjustSize()
	self:Update()
end

function frame:CollectButtons( ... )
	for k, _ in pairs(Includes) do
		self:AddItem(_G[k])
	end

	for k,v in pairs({Minimap:GetChildren()}) do
		if not IsExcluded(v) then
			v:SetSize(cellSize, cellSize)
			self:AddItem(v)
			v:Show()
		end
	end
end

function frame:AdjustSize()
	local numRows = math.ceil(self:ItemCount() / OMM.ButtonCollector.NumColumns)

	self:SetNumColumns(OMM.ButtonCollector.NumColumns)
	self:SetSize(cellSize * OMM.ButtonCollector.NumColumns, cellSize * numRows)
end

