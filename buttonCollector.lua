local addonName, ns = ...

local libGridView = ObeliskFrameworkManager:GetLibrary("ObeliskGridView", 1)
if not libGridView then
	print("Unable to load ObeliskGridView")
end

local libVersionUnification = ObeliskFrameworkManager:GetLibrary("ObeliskVersionUnification", 0)
if not libVersionUnification then
	print("Unable to load ObeliskVersionUnification")
end

local cellSize = 32

ns.ButtonCollectorDropdown = CreateFrame("FRAME", addonName .. "ButtonCollector", MinimapCluster)
ns.ButtonCollectorDropdown:SetPoint("CENTER")
ns.ButtonCollectorDropdown:SetBackdrop({
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4}
	})
ns.ButtonCollectorDropdown:SetBackdropColor(0, 0, 0, 1)
ns.ButtonCollectorDropdown:SetClampedToScreen(true)
ns.ButtonCollectorDropdown:Hide()

-- Instance difficulty
if libVersionUnification.IsRetail then
	MiniMapInstanceDifficulty:SetParent(ns.ButtonCollectorDropdown)
	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:SetPoint("TOPLEFT", -40, 37)
	MiniMapChallengeMode:SetParent(ns.ButtonCollectorDropdown)
	MiniMapChallengeMode:ClearAllPoints()
	MiniMapChallengeMode:SetPoint("TOPLEFT", -40, 37)
end

-- Coordinates
local coordnateOffset = 10

ns.ButtonCollectorDropdown.coordinates = ns.ButtonCollectorDropdown:CreateFontString(nil, "ARTWORK", "GameFontNormal")
local fontName, fontHeight = ns.ButtonCollectorDropdown.coordinates:GetFont()
ns.ButtonCollectorDropdown.coordinates:SetFont(fontName, fontHeight, "THINOUTLINE")
ns.ButtonCollectorDropdown.coordinates:SetPoint("TOP", 0, -coordnateOffset)

-- Used to avoid LUA error on login
local onFirstUpdate = true
local function OnUpdate(self, ... )
	local x,y
	if not onFirstUpdate then
		local mapID = C_Map.GetBestMapForUnit("player")
		if mapID then
			local playerMapPosition = C_Map.GetPlayerMapPosition(mapID, "player")
			if playerMapPosition then
				x,y = playerMapPosition:GetXY()
			end
		end
	end

	if x ~= nil and y ~= nil then
		self.coordinates:SetText(string.format("(%.1f, %.1f)", x * 100, y * 100))
	else
		self.coordinates:SetText("Coords Unavailable")
	end

	onFirstUpdate = false
end

ns.ButtonCollectorDropdown:SetScript("OnUpdate", OnUpdate)
OnUpdate(ns.ButtonCollectorDropdown)


-- gridview
local spacing = 7
local padding = 7

ns.ButtonCollectorDropdown.gridView = libGridView(0, 0, nil, ns.ButtonCollectorDropdown);
ns.ButtonCollectorDropdown.gridView:SetScript("OnEvent", function ( self, event, ... ) self[event](self, ...) end)
ns.ButtonCollectorDropdown.gridView:RegisterEvent("PLAYER_LOGIN")
ns.ButtonCollectorDropdown.gridView:SetPoint("TOPLEFT", padding, -math.ceil(ns.ButtonCollectorDropdown.coordinates:GetHeight()) - spacing - coordnateOffset)
ns.ButtonCollectorDropdown.gridView:SetPoint("BOTTOMRIGHT", -padding, padding)

ns.ButtonCollectorDropdown.gridView.CollectedButtons = {}

local Includes = {
	--GarrisonLandingPageMinimapButton = true, 
	MiniMapTracking = true,

	---------
	-- Third party addons doing things weirdly
	---------
	PerlButton = true,
}

local Excludes = {
	ObeliskMinimapButtonCollector = true,
	MinimapBackdrop = true,
	MiniMapMailFrame = true,
	MiniMapVoiceChatFrame = true,
	--GameTimeFrame = true,
	TimeManagerClockButton = true,

	---------
	-- Third party addons doing things weirdly
	---------
	Perl_Config_ButtonFrame = true,
	EnxMiniMapIcon = true,
	TrinketMenu_IconFrame = true,
	QuestieFrameGroup = true,
}

local SpecialCase = {
	EnxMiniMapIcon = function()
		ns.ButtonCollectorDropdown.gridView:HandleButton(EnxMiniMapIcon)
		EnxMiniMapIcon.icon:ClearAllPoints()
		EnxMiniMapIcon.icon:SetPoint("CENTER")
		EnxMiniMapIcon.mask:ClearAllPoints()
		EnxMiniMapIcon.mask:SetPoint("CENTER")
		EnxMiniMapIcon.mask:SetSize(cellSize, cellSize)
	end,
	TrinketMenu_IconFrame = function()
		ns.ButtonCollectorDropdown.gridView:HandleButton(TrinketMenu_IconFrame)
		
		local old = TrinketMenu.MoveMinimapButton
		TrinketMenu.MoveMinimapButton = function()
			old()
			ns.ButtonCollectorDropdown.gridView:Update()
		end
	end
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

local function HandleSpecialCase(val)
	local t = type(val)
	local func = nil

	if t == "string" then
		func = SpecialCase[val]
	elseif t == "table" and val.GetName ~= nil then
		func = SpecialCase[val:GetName()]
	end

	if func ~= nil then
		func()
	end
end

function ns.ButtonCollectorDropdown.gridView:PLAYER_LOGIN( ... )
	ns.Options:RegisterForOkay(self.Initialize, self)
	self:SetCellSize(cellSize, cellSize)
	self:CollectButtons()
	self:Initialize()
end

function ns.ButtonCollectorDropdown.gridView:Initialize()
	self:AdjustSize()
	self:Update()
end

function ns.ButtonCollectorDropdown.gridView:CollectButtons( ... )
	for k,_ in pairs(Includes) do
		local item = _G[k]
		if item ~= nil then
			-- item:SetSize(cellSize, cellSize)
			-- self:AddItem(item)
			self:HandleButton(item)
		end
	end

	for k,v in pairs({Minimap:GetChildren()}) do
		if not IsExcluded(v) and v:IsVisible() then
			-- v:SetSize(cellSize, cellSize)
			-- self:AddItem(v)
			self:HandleButton(v)
		end

		HandleSpecialCase(v)
	end
end

function ns.ButtonCollectorDropdown.gridView:HandleButton(btn)
	btn:SetSize(cellSize, cellSize)
	self:AddItem(btn)
end

function ns.ButtonCollectorDropdown.gridView:AdjustSize()
	local numRows = math.ceil(self:ItemCount() / OMM.ButtonCollector.NumColumns)

	self:SetNumColumns(OMM.ButtonCollector.NumColumns)
	ns.ButtonCollectorDropdown:SetSize(
		math.ceil(cellSize * OMM.ButtonCollector.NumColumns + padding * 2),
		math.ceil(cellSize * numRows + spacing + ns.ButtonCollectorDropdown.coordinates:GetHeight() + padding + coordnateOffset))
end

