--local _, ns = ...
--ns.OBELISK_DEBUG = true

local libGridView = ObeliskFrameworkManager:GetLibrary("ObeliskGridView", 0)
if not libGridView then
	print("libGridView not gotten")
end

local frame = CreateFrame("Frame", "ObeliskMinimapButtonCollector", UIParent);
frame:SetScript("OnEvent", function ( self, event, ... ) self[event](self, ...) end)
frame:RegisterEvent("PLAYER_LOGIN")

-- frame:SetSize(200,100)
-- frame:SetPoint("TOPLEFT", 25, -25)

-- frame.tex = frame:CreateTexture(nil, "BACKGROUND")
-- frame.tex:SetColorTexture(0,1,0,0.15)
-- frame.tex:SetAllPoints()

-- frame:Show()

frame.CollectedButtons = {}

local padding = 10

local Excludes = {
	MinimapBackdrop = true,
	MiniMapMailFrame = true,
	MiniMapVoiceChatFrame = true,
	GameTimeFrame = true,
	DBMMinimapButton = true,
	TimeManagerClockButton = true,
}

local function IsExcluded(val)
	if type(val) == "string" then
		print("Exclude, str: " .. val .. " - " .. tostring(Excludes[val]))
		return Excludes[val] or false
	elseif type(val) == "table" and val.GetName ~= nil then
		print("Exclude, table: " .. val:GetName() .. " - " .. tostring(Excludes[val:GetName()]))
		return Excludes[val:GetName()] or false
	else
		print("Exclude, unexpected")
		return false
	end
end

function frame:PLAYER_LOGIN( ... )
	self:CollectButtons()
	--self:InvalidateCollector()
	self.gridView = libGridView(100,50,"Whee", UIParent)
	self.gridView:SetPoint("TOPLEFT", 25, -25)
	self.gridView:Show()
end

function frame:CollectButtons( ... )
	for k,v in pairs({Minimap:GetChildren()}) do
		if not IsExcluded(v) then
			table.insert(frame.CollectedButtons, v)
		end
	end
end

function frame:InvalidateCollector( ... )
	local W, H = self:GetSize()
	local wCells, hCells = 10,2
	local row = 0
	local col = 0

	print(self.CollectedButtons)

	for i = 1, #self.CollectedButtons, 1 do
		local btn = self.CollectedButtons[i]

		if btn ~= nil then
			if col * btn:GetWidth() + col * padding + btn:GetWidth() > self:GetWidth() then
				col = 0
				row = row + 1
			end

			self:PlaceButton(btn, btn:GetWidth() * col + padding * col, -btn:GetHeight() * row - padding * row)
			col = col + 1
		end
	end
end

function frame:PlaceButton(btn, x, y)
	btn:SetParent(self)
	btn.debugTexShape = btn:CreateTexture(nil, "BACKGROUND")
	btn.debugTexShape:SetColorTexture(0,0,1,0.5)
	btn.debugTexShape:SetAllPoints()
	btn:SetFrameStrata("BACKGROUND")
	btn:ClearAllPoints()
	btn:SetPoint("TOPLEFT", self, "TOPLEFT", x, y)

	local positionFrame = CreateFrame("Frame", nil, self)
	positionFrame:SetSize(5,5)
	positionFrame.positionTex = positionFrame:CreateTexture(nil, "BACKGROUND")
	positionFrame.positionTex:SetColorTexture(1,0,0,0.5)
	positionFrame.positionTex:SetAllPoints()
	positionFrame:SetFrameStrata("TOOLTIP")
	positionFrame:Show()
	positionFrame:SetPoint("TOPLEFT", self, "TOPLEFT", x, y)
end