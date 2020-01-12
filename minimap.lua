local addonName, ns = ...

local libVersionUnification = ObeliskFrameworkManager:GetLibrary("ObeliskVersionUnification", 0)
if not libVersionUnification then
	print("Unable to load ObeliskVersionUnification")
end

Minimap:SetScale(1)

local frame = CreateFrame("FRAME")
frame:SetScript("OnEvent", function(self, event, ... ) self[event](self, ...) end)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

function frame:PLAYER_ENTERING_WORLD( ... )
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

local function MoveLateFrames()
	if libVersionUnification.IsRetail then
		if not ObjectiveTrackerFrame:IsUserPlaced() then
			ObjectiveTrackerFrame:SetPoint("TOPRIGHT", MinimapCluster, "BOTTOMLEFT", 0, 0)
		end
	elseif libVersionUnification.IsClassic then
		if not QuestWatchFrame:IsUserPlaced() then
			QuestWatchFrame:SetPoint("TOPRIGHT", MinimapCluster, "BOTTOMLEFT", 0, 0)
		end
	end
end

function frame:Initialize()
	Minimap:SetMaskTexture(ns.masks[OMM.Minimap.Mask])
	Minimap:SetSize(OMM.Minimap.Size, OMM.Minimap.Size)
	MinimapNorthTag:SetPoint("TOP", Minimap, "TOP", 0, -20)

	if OMM.Minimap.Pos then
		Minimap:ClearAllPoints()
		local pos = OMM.Minimap.Pos
		pos[2] = UIParent
		Minimap:SetPoint(unpack(pos))
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