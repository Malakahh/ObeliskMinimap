local addonName, ns = ...

MinimapCluster:SetScale(1)
Minimap:SetScale(1)

local frame = CreateFrame("FRAME")
frame:SetScript("OnEvent", function(self, event, ... ) self[event](self, ...) end)
frame:RegisterEvent("PLAYER_LOGIN")

-- Detach objective tracker
ObjectiveTrackerFrame:SetMovable(true)
ObjectiveTrackerFrame:SetUserPlaced(true)
ObjectiveTrackerFrame:ClearAllPoints()
ObjectiveTrackerFrame:SetParent(UIParent)
ObjectiveTrackerFrame:SetPoint("TOPRIGHT", -OBJTRACKER_OFFSET_X, -MinimapCluster:GetHeight() - 80)

function frame:PLAYER_LOGIN( ... )
	ns.Options:RegisterForOkay(self.Initialize)
	self:Initialize()	

	MinimapBorder:Hide()
	MinimapZoomOut:Hide()
	MinimapZoomIn:Hide()
	MinimapBorderTop:Hide()
	TimeManagerClockButton:Hide()
	MiniMapWorldMapButton:Hide()
	MinimapCluster:SetMovable(true)
	MinimapCluster:SetClampedToScreen(true)
end

function frame:Initialize()
	Minimap:SetMaskTexture(ns.masks[OMM.Minimap.Mask])
	Minimap:SetSize(OMM.Minimap.Width, OMM.Minimap.Height)
	MinimapCluster:SetSize(OMM.Minimap.Width, OMM.Minimap.Height)
	Minimap:ClearAllPoints()
	Minimap:SetPoint("CENTER")

	if OMM.Minimap.Pos then
		MinimapCluster:ClearAllPoints()
		MinimapCluster:SetPoint(unpack(OMM.Minimap.Pos))
	end
end

-- Scroll zoom
Minimap:SetScript("OnMouseWheel", function(self, delta)
	if self:IsMouseOver() then
		local currentZoom = self:GetZoom()

		if delta > 0 and currentZoom < self:GetZoomLevels() - 1 then
			self:SetZoom(self:GetZoom() + 1)
		elseif delta < 0 and currentZoom > 0 then
			self:SetZoom(self:GetZoom() - 1)
		end
	end
end)

ns.Util.AppendScript(Minimap, "OnMouseDown", function(self, btn)
	if btn == "LeftButton" and IsShiftKeyDown() then
		MinimapCluster:ClearAllPoints()
		MinimapCluster:StartMoving()
	end
end)

ns.Util.AppendScript(Minimap, "OnMouseUp", function ()
	MinimapCluster:StopMovingOrSizing()
	OMM.Minimap.Pos = { MinimapCluster:GetPoint() }
end)