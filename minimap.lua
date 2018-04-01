local _, ns = ...

MinimapCluster:SetScale(1)

local frame = CreateFrame("FRAME")
frame:SetScript("OnEvent", function(self, event, ... ) self[event](self, ...) end)
frame:RegisterEvent("PLAYER_LOGIN")

function frame:PLAYER_LOGIN( ... )
	ns.Options:RegisterForOkay(self.Initialize)
	self:Initialize()	

	MinimapBorder:Hide()
	MinimapZoomOut:Hide()
	MinimapZoomIn:Hide()
end

function frame:Initialize()
	Minimap:SetMaskTexture(ns.masks[OMM.Minimap.Mask])
	Minimap:ClearAllPoints()
	Minimap:SetPoint("CENTER")
	Minimap:SetSize(OMM.Minimap.Width, OMM.Minimap.Height)
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