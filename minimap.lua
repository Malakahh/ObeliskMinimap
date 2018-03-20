local addonName, ns = ...

local AssetsPath = "Interface\\AddOns\\" .. addonName .. "\\Assets"

MinimapCluster:SetScale(1)

Minimap:SetMaskTexture(AssetsPath .. "\\mask1")
Minimap:ClearAllPoints()
Minimap:SetPoint("CENTER")
Minimap:SetSize(190,190)

MinimapBorder:Hide()