local addonName, ns = ...

local libOptions = ObeliskFrameworkManager:GetLibrary("ObeliskOptions", 0)
if not libOptions then
	print("libOptions not gotten")
end

------
-- Settings
------

local AssetsPath = "Interface\\AddOns\\" .. addonName .. "\\Assets\\"

ns.masks = {
	square = AssetsPath .. "square",
	circle = AssetsPath .. "circle",
	torn1 = AssetsPath .. "torn1",
}

local defaultSettings = {
	Minimap = {
		Mask = "torn1",
		Size = 190,
	},
	InformationFrame = {
		Placement = "Bottom",
	},
	ButtonCollector = {
		NumColumns = 5,
	},
}

OMM = {}
ns.Util.CopyTable(defaultSettings, OMM)

------
-- Menu
------

local name = addonName .. "Options"

local function onRefresh(self, ...)
	-- Minimap
	UIDropDownMenu_SetText(self.minimapMaskDropdown, OMM.Minimap.Mask)
	self.minimapMaskPreview.tex:SetTexture(ns.masks[OMM.Minimap.Mask])
	self.minimapSizeEditBox:SetNumber(OMM.Minimap.Size)
	self.minimapSizeEditBox:SetCursorPosition(0)

	-- Information Frame
	UIDropDownMenu_SetText(self.informationFramePlacementDropdown, OMM.InformationFrame.Placement)

	-- Button Collector
	self.buttonCollectorNumColumnsEditBox:SetNumber(OMM.ButtonCollector.NumColumns)
	self.buttonCollectorNumColumnsEditBox:SetCursorPosition(0)
end

local function onOkay(self, ...)
	-- Minimap
	OMM.Minimap.Mask = UIDropDownMenu_GetText(self.minimapMaskDropdown)
	OMM.Minimap.Size = self.minimapSizeEditBox:GetNumber()

	-- Information Frame
	OMM.InformationFrame.Placement = UIDropDownMenu_GetText(self.informationFramePlacementDropdown)

	-- Button Collector
	OMM.ButtonCollector.NumColumns = self.buttonCollectorNumColumnsEditBox:GetNumber()
end

local function onCancel(self, ...)
	
end

local function onDefault(self, ...)
	wipe(OMM)
	ns.Util.CopyTable(defaultSettings, OMM)
end

local panel = libOptions(addonName, nil, onRefresh, onOkay, onCancel, onDefault)
ns.Options = panel

-- Page setup
local margin = 16
local itemSpacing = 16
local endOfSectionSpacing = 32
local belowTextSpacing = 5
local editBoxIndent = 8

-- Title
panel.title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
panel.title:SetPoint("TOPLEFT", margin, -margin)
panel.title:SetText(addonName)

-- Move text
panel.moveText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
panel.moveText:SetPoint("TOPLEFT", panel.title, "BOTTOMLEFT", 0, -endOfSectionSpacing)
panel.moveText:SetText("To move panels, hold the shift key and drag them around.")

-- Minimap title
panel.minimapTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
panel.minimapTitle:SetPoint("TOPLEFT", panel.moveText, "BOTTOMLEFT", 0, -endOfSectionSpacing)
panel.minimapTitle:SetText("Minimap")

-- Mask Dropdown
panel.minimapMaskDropdown = CreateFrame("FRAME", addonName .. "OptionsMaskDropdown", panel, "UIDropDownMenuTemplate")
panel.minimapMaskDropdown:SetPoint("TOPLEFT", panel.minimapTitle, "BOTTOMLEFT", 0, -itemSpacing)

-- Mask Preview
panel.minimapMaskPreview = CreateFrame("FRAME", nil, panel)
panel.minimapMaskPreview:SetPoint("TOP", panel.minimapMaskDropdown:GetName() .. "Middle", "BOTTOM", 0, itemSpacing)
panel.minimapMaskPreview:SetSize(128, 128)
panel.minimapMaskPreview.tex = panel.minimapMaskPreview:CreateTexture(nil, "BACKGROUND")
panel.minimapMaskPreview.tex:SetAllPoints()
panel.minimapMaskPreview.tex:SetColorTexture(0, 1, 0, 0.5)

local function minimapMaskDropdownOnClick(self, selectedMask, arg2, checked)
	UIDropDownMenu_SetText(panel.minimapMaskDropdown, selectedMask)
	panel.minimapMaskPreview.tex:SetTexture(ns.masks[selectedMask])
	CloseDropDownMenus()
end

local function minimapMaskDropdownInitialization(self, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	for k,v in pairs(ns.masks) do	
		info.text = k
		info.arg1 = k
		info.func = minimapMaskDropdownOnClick
		info.checked = UIDropDownMenu_GetText(panel.minimapMaskDropdown) == k
		UIDropDownMenu_AddButton(info)
	end
end

UIDropDownMenu_Initialize(panel.minimapMaskDropdown, minimapMaskDropdownInitialization)

-- Minimap size
panel.minimapScaleText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
panel.minimapScaleText:SetPoint("TOPLEFT", panel.minimapMaskDropdown, "BOTTOMLEFT", margin, -itemSpacing - panel.minimapMaskPreview:GetHeight())
panel.minimapScaleText:SetText("Size:")

panel.minimapSizeEditBox = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
panel.minimapSizeEditBox:SetPoint("TOPLEFT", panel.minimapScaleText, "BOTTOMLEFT", editBoxIndent, -belowTextSpacing)
panel.minimapSizeEditBox:SetSize(80, 22)
panel.minimapSizeEditBox:SetAutoFocus(false)
panel.minimapSizeEditBox:SetTextInsets(2, 2, 2, 0)
panel.minimapSizeEditBox:SetNumeric(true)
panel.minimapSizeEditBox:ClearFocus()

-- Bar Placement
panel.informationFrameTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
panel.informationFrameTitle:SetPoint("TOPLEFT", panel.minimapSizeEditBox, "BOTTOMLEFT", -margin - editBoxIndent, -endOfSectionSpacing)
panel.informationFrameTitle:SetText("Information Frame Placement")

panel.informationFramePlacementDropdown = CreateFrame("FRAME", addonName .. "OptionsInformationFramePlacementDropdown", panel, "UIDropDownMenuTemplate")
panel.informationFramePlacementDropdown:SetPoint("TOPLEFT", panel.informationFrameTitle, "BOTTOMLEFT", 0, -itemSpacing)

local function informationFramePlacementDropdownOnClick(self, selected, arg2, checked)
	UIDropDownMenu_SetText(panel.informationFramePlacementDropdown, selected)
	CloseDropDownMenus()
end

local function informationFramePlacementDropdownInitialization(self, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	local t = {
		"Bottom",
		"Top",
	}

	for k,v in pairs(t) do	
		info.text = v
		info.arg1 = v
		info.func = informationFramePlacementDropdownOnClick
		info.checked = UIDropDownMenu_GetText(panel.informationFramePlacementDropdown) == v
		UIDropDownMenu_AddButton(info)
	end
end

UIDropDownMenu_Initialize(panel.informationFramePlacementDropdown, informationFramePlacementDropdownInitialization)

-- Button collector num columns
panel.buttonCollectorTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
panel.buttonCollectorTitle:SetPoint("TOPLEFT", panel.informationFramePlacementDropdown, "BOTTOMLEFT", 0, -endOfSectionSpacing)
panel.buttonCollectorTitle:SetText("Button Collector")

panel.buttonCollectorNumColumnsText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
panel.buttonCollectorNumColumnsText:SetPoint("TOPLEFT", panel.buttonCollectorTitle, "BOTTOMLEFT", margin, -itemSpacing)
panel.buttonCollectorNumColumnsText:SetText("Number of Columns:")

panel.buttonCollectorNumColumnsEditBox = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
panel.buttonCollectorNumColumnsEditBox:SetPoint("TOPLEFT", panel.buttonCollectorNumColumnsText, "BOTTOMLEFT", editBoxIndent, -belowTextSpacing)
panel.buttonCollectorNumColumnsEditBox:SetSize(80, 22)
panel.buttonCollectorNumColumnsEditBox:SetAutoFocus(false)
panel.buttonCollectorNumColumnsEditBox:SetTextInsets(2, 2, 2, 0)
panel.buttonCollectorNumColumnsEditBox:SetNumeric(true)
panel.buttonCollectorNumColumnsEditBox:ClearFocus()
