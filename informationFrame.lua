local addonName, ns = ...

local frame = CreateFrame("FRAME", addonName .. "InformationFrame", MinimapCluster)
frame:SetScript("OnEvent", function(self, event, ... ) self[event](self, ...) end)
frame:RegisterEvent("PLAYER_LOGIN")

local function MoveLateFrames( ... )
	VehicleSeatIndicator:SetParent(frame)
	VehicleSeatIndicator:SetFrameStrata("BACKGROUND")

	DurabilityFrame:SetParent(frame)
	DurabilityFrame:SetFrameStrata("BACKGROUND")

	frame:Place()
end

function frame:PLAYER_LOGIN( ... )
	self:SetSize(200, 90)
	ns.Options:RegisterForOkay(self.Place)

	GarrisonLandingPageMinimapButton:SetParent(self)
	GarrisonLandingPageMinimapButton:ClearAllPoints()
	GarrisonLandingPageMinimapButton:SetPoint("TOPLEFT", 15, -15)
	GarrisonLandingPageMinimapButton:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", 43, -43)

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

frame.tex = frame:CreateTexture(nil, "BACKGROUND")
frame.tex:SetTexture("Interface\\QUESTFRAME\\ObjectiveTracker")
local insets = {
	0,
	0.57813,
	0,
	0.16602
}
frame.tex:SetTexCoord(unpack(insets))
frame.tex:SetAllPoints()

frame.time = CreateFrame("BUTTON", nil, frame)
frame.time:SetSize(100,100)
frame.time:SetPoint("TOP", 0, -23)
frame.time:SetScript("OnClick", function(self, btn, down)
	if TimeManagerFrame:IsVisible() then
		TimeManagerFrame:Hide()
	else
		if OMM.InformationFrame.Placement == "Bottom" then
			TimeManagerFrame:ClearAllPoints()
			TimeManagerFrame:SetPoint("TOP", frame, "TOP", 0, -60)
		elseif OMM.InformationFrame.Placement == "Top" then
			TimeManagerFrame:ClearAllPoints()
			TimeManagerFrame:SetPoint("BOTTOM", frame, "BOTTOM", 0, 82)
		end

		TimeManagerFrame:Show()
	end
end)

frame.time.timeText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
local fontName, fontHeight = frame.time.timeText:GetFont()
frame.time.timeText:SetFont(fontName, fontHeight, "THINOUTLINE")
frame.time.timeText:SetPoint("TOP", 0, -23)

frame.time:SetScript("OnUpdate", function(self, ...)
	self.timeText:SetText(GameTime_GetTime(false))
	self:SetSize(self.timeText:GetStringWidth(), self.timeText:GetStringHeight())
end)

local function FlipCollectorToggleTexture()
	if OMM.InformationFrame.Placement == "Bottom" then
		if frame.buttonCollectorToggle:GetChecked() then
			frame.buttonCollectorToggle:SetNormalTexture("Interface\\VEHICLES\\UI-Vehicles-Button-Pitch-Down")
		else
			frame.buttonCollectorToggle:SetNormalTexture("Interface\\VEHICLES\\UI-VEHICLES-BUTTON-PITCHDOWN-UP")
		end
	elseif OMM.InformationFrame.Placement == "Top" then
		if frame.buttonCollectorToggle:GetChecked() then
			frame.buttonCollectorToggle:SetNormalTexture("Interface\\VEHICLES\\UI-VEHICLES-BUTTON-PITCHDOWN-DOWN")
		else
			frame.buttonCollectorToggle:SetNormalTexture("Interface\\VEHICLES\\UI-Vehicles-Button-Pitch-Up")
		end
	end
end

frame.buttonCollectorToggle = CreateFrame("CheckButton", addonName .. "ButtonCollectorToggle", frame)
frame.buttonCollectorToggle:SetSize(38, 38)
frame.buttonCollectorToggle:SetPoint("TOPRIGHT", -10, -8)
frame.buttonCollectorToggle:SetScript("OnClick", function (self, btn, down)
	FlipCollectorToggleTexture()

	if ns.ButtonCollectorDropdown:IsVisible() then
		ns.ButtonCollectorDropdown:Hide()
	else
		if OMM.InformationFrame.Placement == "Bottom" then
			ns.ButtonCollectorDropdown:ClearAllPoints()
			ns.ButtonCollectorDropdown:SetPoint("TOP", frame, "TOP", 0, -47)
		elseif OMM.InformationFrame.Placement == "Top" then
			ns.ButtonCollectorDropdown:ClearAllPoints()
			ns.ButtonCollectorDropdown:SetPoint("BOTTOM", frame, "TOP", 0, -10)
		end
		ns.ButtonCollectorDropdown:Show()
	end
end)

function frame:Place()
	if OMM.InformationFrame.Placement == "Bottom" then
		frame:ClearAllPoints()
		frame:SetPoint("TOP", Minimap, "BOTTOM", 0, 5)

		VehicleSeatIndicator:ClearAllPoints()
		VehicleSeatIndicator:SetPoint("TOPRIGHT", 0, -50)

		DurabilityFrame:ClearAllPoints()
		DurabilityFrame:SetPoint("TOPRIGHT", -35, -50)
	elseif OMM.InformationFrame.Placement == "Top" then
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOM", Minimap, "TOP", 0, -30)

		VehicleSeatIndicator:ClearAllPoints()
		VehicleSeatIndicator:SetPoint("BOTTOMRIGHT", 0, 80)

		DurabilityFrame:ClearAllPoints()
		DurabilityFrame:SetPoint("BOTTOMRIGHT", -35, 80)
	end

	FlipCollectorToggleTexture()
end