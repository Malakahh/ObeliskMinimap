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
		Width = 190,
		Height = 190,
	},
	ButtonCollector = {
		NumColumns = 4,
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

	self.minimapWidthEditBox:SetNumber(OMM.Minimap.Width)
	self.minimapWidthEditBox:SetCursorPosition(0)
	self.minimapHeightEditBox:SetNumber(OMM.Minimap.Height)
	self.minimapHeightEditBox:SetCursorPosition(0)

	-- Button Collector
	self.buttonCollectorNumColumnsEditBox:SetNumber(OMM.ButtonCollector.NumColumns)
	self.buttonCollectorNumColumnsEditBox:SetCursorPosition(0)
end

local function onOkay(self, ...)
	-- Minimap
	OMM.Minimap.Mask = UIDropDownMenu_GetText(self.minimapMaskDropdown)

	OMM.Minimap.Width = self.minimapWidthEditBox:GetNumber()
	OMM.Minimap.Height = self.minimapHeightEditBox:GetNumber()

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

local function dropdownOnClick(self, selectedMask, arg2, checked)
	UIDropDownMenu_SetText(panel.minimapMaskDropdown, selectedMask)
	panel.minimapMaskPreview.tex:SetTexture(ns.masks[selectedMask])
	CloseDropDownMenus()
end

local function dropdownInitialization(self, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	for k,v in pairs(ns.masks) do	
		info.text = k
		info.arg1 = k
		info.func = dropdownOnClick
		UIDropDownMenu_AddButton(info)
	end
end

UIDropDownMenu_Initialize(panel.minimapMaskDropdown, dropdownInitialization)

-- Minimap size
panel.minimapWidthText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
panel.minimapWidthText:SetPoint("TOPLEFT", panel.minimapMaskDropdown, "BOTTOMLEFT", margin, -itemSpacing - panel.minimapMaskPreview:GetHeight())
panel.minimapWidthText:SetText("Width:")

panel.minimapWidthEditBox = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
panel.minimapWidthEditBox:SetPoint("TOPLEFT", panel.minimapWidthText, "BOTTOMLEFT", editBoxIndent, -belowTextSpacing)
panel.minimapWidthEditBox:SetSize(80, 22)
panel.minimapWidthEditBox:SetAutoFocus(false)
panel.minimapWidthEditBox:SetTextInsets(2, 2, 2, 0)
panel.minimapWidthEditBox:SetNumeric(true)
panel.minimapWidthEditBox:ClearFocus()

panel.minimapHeightText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
panel.minimapHeightText:SetPoint("LEFT", panel.minimapWidthText, "RIGHT", panel.minimapWidthEditBox:GetWidth() + itemSpacing, 0)
panel.minimapHeightText:SetText("Height:")

panel.minimapHeightEditBox = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
panel.minimapHeightEditBox:SetPoint("TOPLEFT", panel.minimapHeightText, "BOTTOMLEFT", editBoxIndent, -belowTextSpacing)
panel.minimapHeightEditBox:SetSize(80, 22)
panel.minimapHeightEditBox:SetAutoFocus(false)
panel.minimapHeightEditBox:SetTextInsets(2, 2, 2, 0)
panel.minimapHeightEditBox:SetNumeric(true)
panel.minimapHeightEditBox:ClearFocus()

-- Button collector num columns
panel.buttonCollectorTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
panel.buttonCollectorTitle:SetPoint("TOPLEFT", panel.minimapWidthEditBox, "BOTTOMLEFT", -margin - editBoxIndent, -endOfSectionSpacing)
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



