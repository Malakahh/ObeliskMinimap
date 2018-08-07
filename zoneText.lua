local addonName, ns = ...

local frame = CreateFrame("FRAME", addonName .. "ZoneText", MinimapCluster)
frame:SetScript("OnEvent", function(self, event, ... ) self[event](self, ...) end)
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetPoint("TOP", Minimap, "TOP", 0, 10)
frame.tex = frame:CreateTexture(nil, "BACKGROUND")
frame.tex:SetAllPoints()
frame.tex:SetTexture("Interface\\Garrison\\GarrisonMissionUI2")
frame.tex:SetTexCoord(
	0.65527, --left
	0.87402, --right
	0.62109, --top
	0.68359 --bottom
	)
frame:SetSize(160, 45)

function frame:PLAYER_LOGIN( ... )
	-- Zone text
	MinimapZoneTextButton:SetParent(self)
	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetPoint("TOP", 0, -9)
	local fontName, fontHeight = MinimapZoneText:GetFont()
	MinimapZoneText:SetFont(fontName, fontHeight, "THINOUTLINE")
	MinimapZoneText:SetWidth(115)
end