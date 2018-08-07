local addonName, ns = ...

local frame = CreateFrame("FRAME", addonName .. "InformationFrame", MinimapCluster)
frame:SetScript("OnEvent", function(self, event, ... ) self[event](self, ...) end)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

local function MoveLateFrames( ... )
	VehicleSeatIndicator:SetParent(frame)
	VehicleSeatIndicator:ClearAllPoints()
	VehicleSeatIndicator:SetPoint("TOPRIGHT", 0, -50)
	VehicleSeatIndicator:SetFrameStrata("BACKGROUND")

	DurabilityFrame:SetParent(frame)
	DurabilityFrame:ClearAllPoints()
	DurabilityFrame:SetPoint("TOPRIGHT", -35, -50)
	DurabilityFrame:SetFrameStrata("BACKGROUND")
end

function frame:PLAYER_ENTERING_WORLD( ... )
	self:SetSize(200, 90)

	GarrisonLandingPageMinimapButton:SetParent(self)
	GarrisonLandingPageMinimapButton:SetSize(28, 28)
	GarrisonLandingPageMinimapButton:ClearAllPoints()
	GarrisonLandingPageMinimapButton:SetPoint("TOPLEFT", 15, -15)

	QueueStatusMinimapButton:SetParent(self)
	QueueStatusMinimapButton:SetSize(33, 33)
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:SetPoint("TOPLEFT", 41, -12)
	QueueStatusMinimapButtonBorder:Hide()
	QueueStatusMinimapButtonIcon:SetSize(QueueStatusMinimapButton:GetSize())

	MiniMapMailFrame:SetParent(self)
	MiniMapMailFrame:SetSize(20, 20)
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint("TOPRIGHT", -52, -12)
	MiniMapMailBorder:Hide()
	MiniMapMailIcon:SetSize(MiniMapMailFrame:GetSize())
	MiniMapMailIcon:SetTexture("Interface\\MINIMAP\\TRACKING\\Mailbox")

	hooksecurefunc("UIParent_ManageFramePositions", MoveLateFrames)
end

frame:SetPoint("TOP", Minimap, "BOTTOM", 0, 5)
frame.tex = frame:CreateTexture(nil, "BACKGROUND")
frame.tex:SetAllPoints()

frame.tex:SetTexture("Interface\\QUESTFRAME\\ObjectiveTracker")
local insets = {
	0,
	0.57813,
	0,
	0.16602
}

frame.tex:SetTexCoord(unpack(insets))

frame.time = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
local fontName, fontHeight = frame.time:GetFont()
frame.time:SetFont(fontName, fontHeight, "THINOUTLINE")
--frame.time:SetPoint("BOTTOM", 0, 5)
frame.time:SetPoint("TOP", 0, -23)

frame:SetScript("OnUpdate", function(self, ...)
	self.time:SetText(GameTime_GetTime(false))
end)

frame.buttonCollectorToggle = CreateFrame("CheckButton", addonName .. "ButtonCollectorToggle", frame)
frame.buttonCollectorToggle:SetSize(38, 38)
frame.buttonCollectorToggle:SetPoint("TOPRIGHT", -10, -8)
frame.buttonCollectorToggle:SetNormalTexture("Interface\\VEHICLES\\UI-VEHICLES-BUTTON-PITCHDOWN-UP")
frame.buttonCollectorToggle:SetCheckedTexture("Interface\\VEHICLES\\UI-Vehicles-Button-Pitch-Down")
frame.buttonCollectorToggle:SetScript("OnClick", function (self, btn, down)
	if ns.ButtonCollectorDropdown:IsVisible() then
		ns.ButtonCollectorDropdown:Hide()
	else
		ns.ButtonCollectorDropdown:SetPoint("TOP", frame, "TOP", 0, -47)
		ns.ButtonCollectorDropdown:Show()
	end
end)
