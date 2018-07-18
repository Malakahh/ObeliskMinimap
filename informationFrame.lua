local addonName, ns = ...

local frame = CreateFrame("FRAME", addonName .. "InformationFrame", MinimapCluster)
frame:SetScript("OnEvent", function(self, event, ... ) self[event](self, ...) end)
frame:RegisterEvent("PLAYER_LOGIN")

function frame:PLAYER_LOGIN( ... )
	--self:SetSize(OMM.Minimap.Width + 10, 45)
	self:SetSize(OMM.Minimap.Width + 10, 90)

	GarrisonLandingPageMinimapButton:SetParent(self)
	GarrisonLandingPageMinimapButton:SetSize(28, 28)
	GarrisonLandingPageMinimapButton:ClearAllPoints()
	--GarrisonLandingPageMinimapButton:SetPoint("BOTTOMLEFT", 7, 5)
	GarrisonLandingPageMinimapButton:SetPoint("TOPLEFT", 15, -15)

	QueueStatusMinimapButton:SetParent(self)
	QueueStatusMinimapButton:SetSize(33, 33)
	QueueStatusMinimapButton:ClearAllPoints()
	--QueueStatusMinimapButton:SetPoint("BOTTOMLEFT", 33, 3)
	QueueStatusMinimapButton:SetPoint("TOPLEFT", 41, -12)
	QueueStatusMinimapButtonBorder:Hide()
	QueueStatusMinimapButtonIcon:SetSize(QueueStatusMinimapButton:GetSize())

	MiniMapMailFrame:SetParent(self)
	MiniMapMailFrame:SetSize(20, 20)
	MiniMapMailFrame:ClearAllPoints()
--	MiniMapMailFrame:SetPoint("BOTTOMRIGHT", -48, 15)
	MiniMapMailFrame:SetPoint("TOPRIGHT", -52, -12)
	MiniMapMailBorder:Hide()
	MiniMapMailIcon:SetSize(MiniMapMailFrame:GetSize())
	MiniMapMailIcon:SetTexture("Interface\\MINIMAP\\TRACKING\\Mailbox")
end

frame:SetPoint("TOP", MinimapCluster, "BOTTOM", 0, 5)
frame.tex = frame:CreateTexture(nil, "BACKGROUND")
frame.tex:SetAllPoints()
-- frame.tex:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-Achievement-Borders")
-- frame.tex:SetVertexColor(1, 1, 1, 0.6)
-- local insets = {
-- 	0.15039, -- ULx
-- 	0.19, -- ULy
-- 	0.15039, -- LLx
-- 	0, -- LLy
-- 	0.86719, -- URx,
-- 	0.19, -- URy
-- 	0.86719, -- LRx
-- 	0, -- LRy
-- }

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
--frame.buttonCollectorToggle:SetPoint("BOTTOMRIGHT", -5, 0)
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
