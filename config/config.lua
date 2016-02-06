local _, ns = ...
local D = ns.D

D["units"] = {
	enabled =  true,
	player = {
		enabled = true,
		point = {"BOTTOM", "UIParent", "BOTTOM", -314 , 80},
		combo_bar_type = "VERTICAL", -- "HORIZONTAL" is a second option
		castbar = true,
	},
	pet = {
		enabled = true,
		point = {"RIGHT", "LSPlayerFrame" , "LEFT", -2, 0},
		castbar = true,
	},
	target = {
		enabled = true,
		castbar = true,
		point = {"BOTTOMLEFT", "UIParent", "BOTTOM", 166, 336},
		auras = {
			enabled = 0x0000000f,
			HELPFUL = {
				include_all_enemy_buffs = 0x00000000,
				include_stealable = 0x0000000f,
				include_all_friendly_buffs = 0x00000000,
				include_castable = 0x0000000f,
				include_relevant = 0x0000000f,
				auralist = {},
			},
			HARMFUL = {
				show_all_enemy_debuffs = 0x00000000,
				show_all_friendly_debuffs = 0x00000000,
				include_dispellable = 0x0000000f,
				include_relevant = 0x0000000f,
				auralist = {},
			},
		},
	},
	targettarget = {
		enabled = true,
		point = { "LEFT", "LSTargetFrame", "RIGHT", 6, 0 },
	},
	focus = {
		enabled = true,
		point = { "BOTTOMRIGHT", "UIParent", "BOTTOM", -166, 336},
		castbar = true,
	},
	focustarget = {
		enabled = true,
		point = { "RIGHT", "LSFocusFrame", "LEFT", -6, 0 },
	},
	party = {
		enabled = true,
		point1 = {"TOPLEFT", "CompactRaidFrameManager", "TOPRIGHT", 6, 0},
		point2 = {"TOPLEFT", "UIParent", "TOPLEFT", 14, -140},
	},
	boss = {
		enabled = true,
		point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -72, -240},
		castbar = true,
	},
	arena = {
		enabled = true,
		point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -72, -240},
		castbar = true,
	},
}

D["auratracker"] = {
	enabled = true,
	locked = false,
	point = {"CENTER", "UIParent", "CENTER", 0, 0},
	direction = "RIGHT",
	HELPFUL = {},
	HARMFUL = {},
	["0"] = { -- for level < 10 and buffer
		HELPFUL = {},
		HARMFUL = {},
	},
	["1"] = {
		HELPFUL = {},
		HARMFUL = {},
	},
	["2"] = {
		HELPFUL = {},
		HARMFUL = {},
	},
	["3"] = {
		HELPFUL = {},
		HARMFUL = {},
	},
	["4"] = {
		HELPFUL = {},
		HARMFUL = {},
	},
}

D["minimap"] = {
	enabled = true,
	point = {"BOTTOM", "UIParent", "BOTTOM", 314 , 80},
}

D["nameplates"] = {
	enabled = true,
	show_text = false,
	show_combo = false,
}

D["bars"] = {
	enabled = true,
	restricted = true,
	show_hotkey = true,
	show_name = true,
	bar1 = { -- MainMenuBar
		point = {"BOTTOM", 0, 4},
		button_size = 28,
		button_gap = 4,
		direction = "RIGHT",
	},
	bar2 = { -- MultiBarBottomLeft
		point = {"BOTTOM", 0, 46},
		button_size = 28,
		button_gap = 4,
		direction = "RIGHT",
	},
	bar3 = { -- MultiBarBottomRight
		point = {"BOTTOM", 0, 78},
		button_size = 28,
		button_gap = 4,
		direction = "RIGHT",
	},
	bar4 = { -- MultiBarLeft
		point = {"BOTTOMRIGHT", -36, 300},
		button_size = 28,
		button_gap = 4,
		direction = "DOWN",
	},
	bar5 = { -- MultiBarRight
		point = {"BOTTOMRIGHT", -4, 300},
		button_size = 28,
		button_gap = 4,
		direction = "DOWN",
	},
	bar6 = { --PetAction
		button_size = 24,
		button_gap = 4,
		direction = "RIGHT",
	},
	bar7 = { -- Stance
		button_size = 24,
		button_gap = 4,
		direction = "RIGHT",
	},
	extra = { -- ExtraAction
		point = {"BOTTOM", -170, 138},
		button_size = 40,
	},
	vehicle = { -- LeaveVehicle
		point = {"BOTTOM", 170, 138},
		button_size = 40,
	},
	micromenu = {
		holder1 = {
			point = {"BOTTOM", -256, 4},
		},
		holder2 = {
			point = {"BOTTOM", 256, 4},
		},
	},
	bags = {
		enabled = true,
		point = {"BOTTOM", 400, 4},
		button_size = 28,
		button_gap = 4,
		direction = "RIGHT",
	},
}

D["mail"] = {
	enabled = true,
}

D["auras"] = {
	enabled = true,
	buff = {
		point = {"TOPRIGHT", -4, -4},
	},
	debuff = {
		point = {"TOPRIGHT", -4, -88},
	},
	tempench = {
		point = {"TOPRIGHT", -4, -128},
	},
	aura_size = 28,
	aura_gap = 4,
}

D["tooltips"] = {
	enabled = true,
}

D["movers"] = {}

D["width"] = 0

D["height"] = 0

D["playerclass"] = ""
