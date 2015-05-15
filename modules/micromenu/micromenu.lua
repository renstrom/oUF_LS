local _, ns = ...
local E, M = ns.E, ns.M

E.MM = {}

local MM = E.MM

local HIGH_LATENCY = PERFORMANCEBAR_MEDIUM_LATENCY
local GRADIENT_GYR = {0.15, 0.65, 0.15, 0.9, 0.65, 0.15, 0.9, 0.15, 0.15}
local GRADIENT_RYG = {0.9, 0.15, 0.15, 0.9, 0.65, 0.15, 0.15, 0.65, 0.15}
local DURABILITY_SLOTS = {1, 3, 5, 6, 7, 8, 9, 10, 16, 17}

local wipe, find = wipe, strfind

local MICRO_BUTTON_LAYOUT = {
	["CharacterMicroButton"] = {
		point = {"LEFT", "LSMBHolderLeft", "LEFT", 3, 0},
		parent = "LSMBHolderLeft",
		icon = "character",
	},
	["SpellbookMicroButton"] = {
		point = {"LEFT", "CharacterMicroButton", "RIGHT", 6, 0},
		parent = "LSMBHolderLeft",
		icon = "spellbook",
	},
	["TalentMicroButton"] = {
		point = {"LEFT", "SpellbookMicroButton", "RIGHT", 6, 0},
		parent = "LSMBHolderLeft",
		icon = "talents",
	},
	["AchievementMicroButton"] = {
		point = {"LEFT", "TalentMicroButton", "RIGHT", 6, 0},
		parent = "LSMBHolderLeft",
		icon = "achievement",
	},
	["QuestLogMicroButton"] = {
		point = {"LEFT", "AchievementMicroButton", "RIGHT", 6, 0},
		parent = "LSMBHolderLeft",
		icon = "quest",
	},
	["GuildMicroButton"] = {
		point = {"LEFT", "LSMBHolderRight", "LEFT", 3, 0},
		parent = "LSMBHolderRight",
		icon = "guild",
	},
	["LFDMicroButton"] = {
		point = {"LEFT", "GuildMicroButton", "RIGHT", 6, 0},
		parent = "LSMBHolderRight",
		icon = "lfg",
	},
	["CollectionsMicroButton"] = {
		point = {"LEFT", "LFDMicroButton", "RIGHT", 6, 0},
		parent = "LSMBHolderRight",
		icon = "pet",
	},
	["EJMicroButton"] = {
		point = {"LEFT", "CollectionsMicroButton", "RIGHT", 6, 0},
		parent = "LSMBHolderRight",
		icon = "ej",
	},
	["MainMenuMicroButton"] = {
		point = {"LEFT", "EJMicroButton", "RIGHT", 6, 0},
		parent = "LSMBHolderRight",
		icon = "mainmenu",
	},
}

local function ShowTooltipStatusBar(self, min, max, value, ...)
	self:AddLine(" ")

	local index = self.shownStatusBars + 1
	local statusBar = _G["GameTooltipStatusBar"..index]

	statusBar.Text:SetText(value.." / "..max)
	statusBar:SetMinMaxValues(min, max)
	statusBar:SetValue(value)
	statusBar:SetStatusBarColor(...)
	statusBar:SetPoint("LEFT", self:GetName().."TextLeft"..self:NumLines(), "LEFT", 0, -2)
	statusBar:SetPoint("RIGHT", self, "RIGHT", -9, 0)
	statusBar:Show()

	self.shownStatusBars = index
	self:SetMinimumWidth(140)
end

local function SimpleSort(a, b)
	if a and b then
		return a[2] > b[2]
	end
end

local function UpdatePerformanceBar(self)
	local _, _, latencyHome, latencyWorld = GetNetStats()
	local latency = latencyHome > latencyWorld and latencyHome or latencyWorld

	self.performance:SetVertexColor(E:ColorGradient(latency / HIGH_LATENCY, unpack(GRADIENT_GYR)))
end

local addons = {}
local function MainMenuMicroButton_OnEnter(self)
	GameTooltip_AddNewbieTip(self, self.tooltipText, 1, 1, 1, self.newbieText)
	GameTooltip:AddLine(" ")

	GameTooltip:AddLine("Latency:")

	local _, _, latencyHome, latencyWorld = GetNetStats()
	local colorHome = E:RGBToHEX(E:ColorGradient(latencyHome / HIGH_LATENCY, unpack(GRADIENT_GYR)))
	local colorWorld = E:RGBToHEX(E:ColorGradient(latencyWorld / HIGH_LATENCY, unpack(GRADIENT_GYR)))

	GameTooltip:AddDoubleLine("Home", "|cff"..colorHome..latencyHome.."|r "..MILLISECONDS_ABBR, 1, 1, 1)
	GameTooltip:AddDoubleLine("World", "|cff"..colorWorld..latencyWorld.."|r "..MILLISECONDS_ABBR, 1, 1, 1)
	GameTooltip:AddLine(" ")

	local memory = 0

	UpdateAddOnMemoryUsage()

	for i = 1, GetNumAddOns() do
		addons[i] = {
			[1] = select(2, GetAddOnInfo(i)),
			[2] = GetAddOnMemoryUsage(i),
			[3] = IsAddOnLoaded(i),
		}

		memory = memory + addons[i][2]
	end

	sort(addons, SimpleSort)

	GameTooltip:AddLine("Memory:")

	for i = 1, #addons do
		if addons[i][3] then
			local m = addons[i][2]

			GameTooltip:AddDoubleLine(addons[i][1], format("%.3f MB", m / 1024), 1, 1, 1, E:ColorGradient(m / (memory - m), unpack(GRADIENT_GYR)))
		end
	end

	GameTooltip:AddDoubleLine(TOTAL..":", format("%.3f MB", memory / 1024), 1, 1, 0.6, 1, 1, 0.6)

	UpdatePerformanceBar(self)

	GameTooltip:Show()
end

local function MainMenuMicroButton_OnUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed

	if self.elapsed > 30 then
		UpdatePerformanceBar(self)

		self.elapsed = 0
	end
end

local function CharacterMicroButton_OnEnter(self)
	if C_PetBattles.IsInBattle() then
		for i = 1, 3 do
			local petID, _, _, _, locked = C_PetJournal.GetPetLoadOutInfo(i)

			if petID and not locked then
				local _, customName, level, xp, maxXp, _, _, name = C_PetJournal.GetPetInfoByPetID(petID)
				local _, _, _, _, rarity = C_PetJournal.GetPetStats(petID)
				local color = ITEM_QUALITY_COLORS[rarity - 1]

				if level < 25 then
					if i == 1 then
						GameTooltip:AddLine(EXPERIENCE_COLON)
					else
						GameTooltip:AddLine(" ")
					end

					GameTooltip:AddLine(customName or name, color.r, color.g, color.b)
					ShowTooltipStatusBar(GameTooltip, 0, maxXp, xp, 0.11, 0.75, 0.95)
				end
			end
		end
	else
		local total, cur, max = 100

		for _, v in next, DURABILITY_SLOTS do
			cur, max = GetInventoryItemDurability(v)

			if cur then
				cur = cur / max * 100

				if cur < total then
					total = cur
				end
			end
		end

		GameTooltip:AddDoubleLine(DURABILITY..":", E:Round(total).."%", 1, 0.82, 0, E:ColorGradient(total / 100, unpack(GRADIENT_RYG)))

		if UnitLevel('player') < MAX_PLAYER_LEVEL and not IsXPUserDisabled() then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(EXPERIENCE_COLON)
			GameTooltip:AddDoubleLine("Bonus XP", GetXPExhaustion() or 0, 1, 1, 1, 0.11, 0.75, 0.95)
			ShowTooltipStatusBar(GameTooltip, 0, UnitXPMax("player"), UnitXP("player"), 0.11, 0.75, 0.95)
		end

		local name, standing, repMin, repMax, repValue, factionID = GetWatchedFactionInfo()

		if name then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(REPUTATION..":")

			local min, max, value = 0, 1, 1
			local text = GetText("FACTION_STANDING_LABEL"..standing, UnitSex("player"))
			local _, friendRep, _, _, _, _, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)

			if friendRep then
				if nextFriendThreshold then
					min, max, value = friendThreshold, nextFriendThreshold, friendRep
				else
					max, value = 1, 1
				end

				standing = 5
				text = friendTextLevel
			else
				max, value = repMax - repMin, repValue - repMin
			end

			local color = FACTION_BAR_COLORS[standing]

			GameTooltip:AddDoubleLine(name, text, 1, 1, 1, color.r, color.g, color.b)
			ShowTooltipStatusBar(GameTooltip, 0, max, value, color.r, color.g, color.b)
		end
	end

	GameTooltip:Show()
end

local function MicroButton_OnLeave(self)
	for i = 1, GameTooltip.shownStatusBars do
		_G[GameTooltip:GetName().."StatusBar"..i]:SetStatusBarColor(0.15, 0.65, 0.15)
		_G[GameTooltip:GetName().."StatusBar"..i]:Hide()
	end

	GameTooltip.shownStatusBars = 0
	GameTooltip:Hide()
end

local function SetCustomNormalTexture(button)
	local normal = button:GetNormalTexture()

	if normal then normal:SetTexture(nil) end
end

local function SetCustomPushedTexture(button)
	local pushed = button:GetPushedTexture()

	if pushed then
		pushed:SetTexture("Interface\\AddOns\\oUF_LS\\media\\microbutton")
		pushed:SetTexCoord(0.7734375, 0.9140625, 0.3125, 0.6875)
		pushed:SetSize(18, 24)
		pushed:ClearAllPoints()
		pushed:SetPoint("CENTER")
	end
end

local function SetCustomDisabledTexture(button)
	local disabled = button:GetDisabledTexture()

	if disabled then disabled:SetTexture(nil) end
end

local function HandleMicroButton(name)
	local button = _G[name]
	local highlight = button:GetHighlightTexture()
	local flash = button.Flash

	button:SetSize(18, 24)
	button:SetFrameStrata("LOW")
	button:SetFrameLevel(2)
	button:SetHitRectInsets(0, 0, 0, 0)

	SetCustomNormalTexture(button)
	SetCustomPushedTexture(button)
	SetCustomDisabledTexture(button)

	if highlight then
		highlight:SetTexture("Interface\\AddOns\\oUF_LS\\media\\microbutton")
		highlight:SetTexCoord(0.40625, 0.59375, 0.265625, 0.734375)
		highlight:SetSize(24, 30)
		highlight:ClearAllPoints()
		highlight:SetPoint("CENTER")
	end

	if flash then
		flash:SetSize(58, 58)
		flash:ClearAllPoints()
		flash:SetPoint("CENTER", 14, -10)
	end

	local bg = button:CreateTexture(nil, "BACKGROUND", nil, 0)
	bg:SetTexture(M.textures.statusbar)
	bg:SetVertexColor(0.15, 0.15, 0.15)
	bg:SetAllPoints()

	local icon = button:CreateTexture(nil, "BACKGROUND", nil, 1)
	icon:SetTexture("Interface\\AddOns\\oUF_LS\\media\\microicon\\"..MICRO_BUTTON_LAYOUT[name].icon)
	icon:SetVertexColor(0.52, 0.46, 0.36)
	icon:SetSize(24, 24)
	icon:SetPoint("CENTER")

	local border = button:CreateTexture(nil, "BORDER", nil, 0)
	border:SetTexture("Interface\\AddOns\\oUF_LS\\media\\microbutton")
	border:SetTexCoord(0.0625, 0.28125, 0.234375, 0.765625)
	border:SetSize(28, 34)
	border:SetPoint("CENTER")

	button:SetScript("OnLeave", MicroButton_OnLeave)
	button:SetScript("OnUpdate", nil)
end

local function HandlePerformanceBar(parent, bar)
	bar:SetDrawLayer("BACKGROUND", 3)
	bar:SetTexture(M.textures.statusbar)
	bar:SetSize(18, 4)
	bar:ClearAllPoints()
	bar:SetPoint("BOTTOM", 0, 0)
	parent.performance = bar
end

local function ResetMicroButtonsParent()
	for _, b in next, MICRO_BUTTONS do
		local button = _G[b]

		if MICRO_BUTTON_LAYOUT[b] then
			button:SetParent(MICRO_BUTTON_LAYOUT[b].parent)
		else
			button:SetParent(M.hiddenParent)
		end
	end
end

local function ResetMicroButtonsPosition()
	for _, b in next, MICRO_BUTTONS do
		local button = _G[b]

		if MICRO_BUTTON_LAYOUT[b] then
			button:ClearAllPoints()
			button:SetPoint(unpack(MICRO_BUTTON_LAYOUT[b].point))
		end
	end
end

function MM:Initialize()
	local MM_CONFIG = ns.C.micromenu

	local holder1 = CreateFrame("Frame", "LSMBHolderLeft", UIParent)
	holder1:SetFrameStrata("LOW")
	holder1:SetFrameLevel(1)
	holder1:SetSize(18 * 5 + 6 * 5, 24 + 6)
	holder1:SetPoint(unpack(MM_CONFIG.holder1.point))
	E:CreateMover(holder1)

	local holder2 = CreateFrame("Frame", "LSMBHolderRight", UIParent)
	holder2:SetFrameStrata("LOW")
	holder2:SetFrameLevel(1)
	holder2:SetSize(18 * 5 + 6 * 5, 24 + 6)
	holder2:SetPoint(unpack(MM_CONFIG.holder2.point))
	E:CreateMover(holder2)

	for _, b in next, MICRO_BUTTONS do
		local button = _G[b]

		if MICRO_BUTTON_LAYOUT[b] then
			HandleMicroButton(b)

			button:SetParent(MICRO_BUTTON_LAYOUT[b].parent)
			button:ClearAllPoints()
			button:SetPoint(unpack(MICRO_BUTTON_LAYOUT[b].point))
		else
			button:UnregisterAllEvents()
			button:SetParent(M.hiddenParent)
		end

		if b == "CharacterMicroButton" then
			E:AlwaysHide(MicroButtonPortrait)
			button:HookScript("OnEnter", CharacterMicroButton_OnEnter)
		elseif b == "GuildMicroButton" then
			E:AlwaysHide(GuildMicroButtonTabard)

			hooksecurefunc(GuildMicroButton, "SetNormalTexture", SetCustomNormalTexture)
			hooksecurefunc(GuildMicroButton, "SetPushedTexture", SetCustomPushedTexture)
			hooksecurefunc(GuildMicroButton, "SetDisabledTexture", SetCustomDisabledTexture)
		elseif b == "MainMenuMicroButton" then
			E:AlwaysHide(MainMenuBarDownload)

			HandlePerformanceBar(MainMenuMicroButton, MainMenuBarPerformanceBar)

			UpdatePerformanceBar(button)

			button:SetScript("OnEnter", MainMenuMicroButton_OnEnter)
			button:SetScript("OnUpdate", MainMenuMicroButton_OnUpdate)
		end
	end

	TalentMicroButtonAlert:SetPoint("BOTTOM", "TalentMicroButton", "TOP", 0, 12)

	CollectionsMicroButtonAlert:SetPoint("BOTTOM", "CollectionsMicroButton", "TOP", 0, 12)

	LFDMicroButtonAlert:SetPoint("BOTTOM", "LFDMicroButton", "TOP", 0, 12)

	hooksecurefunc("UpdateMicroButtonsParent", ResetMicroButtonsParent)
	hooksecurefunc("MoveMicroButtons", ResetMicroButtonsPosition)
end
