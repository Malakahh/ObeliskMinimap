local addonName, ns = ...

Minimap:SetScale(1)

local frame = CreateFrame("FRAME")
frame:SetScript("OnEvent", function(self, event, ... ) self[event](self, ...) end)
frame:RegisterEvent("PLAYER_LOGIN")

function frame:PLAYER_LOGIN( ... )
	ns.Options:RegisterForOkay(self.Initialize)
	self:Initialize()	

	MinimapBorder:Hide()
	MinimapZoomOut:Hide()
	MinimapZoomIn:Hide()
	MinimapBorderTop:Hide()
	TimeManagerClockButton:Hide()
	MiniMapWorldMapButton:Hide()
	Minimap:SetMovable(true)
	Minimap:SetClampedToScreen(true)
end

local function MoveLateFrames( ... )
	if not ObjectiveTrackerFrame:IsUserPlaced() then
		ObjectiveTrackerFrame:SetPoint("TOPRIGHT", MinimapCluster, "BOTTOMLEFT", 0, 0)
	end
end

function frame:Initialize()
	Minimap:SetMaskTexture(ns.masks[OMM.Minimap.Mask])
	Minimap:SetSize(OMM.Minimap.Size, OMM.Minimap.Size)
	MinimapNorthTag:SetPoint("TOP", Minimap, "TOP", 0, -20)

	if OMM.Minimap.Pos then
		Minimap:ClearAllPoints()
		Minimap:SetPoint(unpack(OMM.Minimap.Pos))
	end

	hooksecurefunc("UIParent_ManageFramePositions", MoveLateFrames)
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
		Minimap:ClearAllPoints()
		Minimap:StartMoving()
	end
end)

ns.Util.AppendScript(Minimap, "OnMouseUp", function ()
	Minimap:StopMovingOrSizing()
	OMM.Minimap.Pos = { Minimap:GetPoint() }
end)