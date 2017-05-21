﻿local _, ns = ...
local E, C, M, L, P = ns.E, ns.C, ns.M, ns.L, ns.P
local AURAS = P:AddModule("Auras")

-- Lua
local _G = getfenv(0)
local unpack = _G.unpack

-- Mine
local isInit = false

-----------------
-- INITIALISER --
-----------------

function AURAS:IsInit()
	return isInit
end

function AURAS:Init()
	if not isInit and C.db.char.auras.enabled then
		-- Buffs
		local buffHeader = _G.CreateFrame("Frame", "LSBuffHeader", _G.UIParent)
		buffHeader:SetSize(C.db.profile.auras[C.db.char.layout].aura_size + C.db.profile.auras[C.db.char.layout].aura_gap, C.db.profile.auras[C.db.char.layout].aura_size + C.db.profile.auras[C.db.char.layout].aura_gap)
		buffHeader:SetPoint(unpack(C.db.profile.auras[C.db.char.layout].buff.point))
		E:CreateMover(buffHeader)

		_G.BuffFrame:SetParent(buffHeader)
		_G.BuffFrame:SetAllPoints()

		_G.hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", function()
			local above

			for i = 1, _G.BUFF_ACTUAL_DISPLAY do
				local button = _G["BuffButton"..i]

				if button then
					button:ClearAllPoints()
					button:SetSize(C.db.profile.auras[C.db.char.layout].aura_size, C.db.profile.auras[C.db.char.layout].aura_size)

					if i == 1 then
						button:SetPoint("TOPRIGHT", buffHeader, "TOPRIGHT", -C.db.profile.auras[C.db.char.layout].aura_gap / 2, -C.db.profile.auras[C.db.char.layout].aura_gap / 2)

						above = button
					elseif i % 16 == 1 then
						button:SetPoint("TOP", above, "BOTTOM", 0, -C.db.profile.auras[C.db.char.layout].aura_gap)

						above = button
					else
						button:SetPoint("TOPRIGHT", _G["BuffButton"..(i - 1)], "TOPLEFT", -C.db.profile.auras[C.db.char.layout].aura_gap, 0)
					end

					E:SkinAuraButton(button)
				end
			end
		end)

		-- Debuffs
		local debuffHeader = _G.CreateFrame("Frame", "LSDebuffHeader", _G.UIParent)
		debuffHeader:SetSize(C.db.profile.auras[C.db.char.layout].aura_size + C.db.profile.auras[C.db.char.layout].aura_gap, C.db.profile.auras[C.db.char.layout].aura_size + C.db.profile.auras[C.db.char.layout].aura_gap)
		debuffHeader:SetPoint(unpack(C.db.profile.auras[C.db.char.layout].debuff.point))
		E:CreateMover(debuffHeader)

		_G.hooksecurefunc("DebuffButton_UpdateAnchors", function(name, i)
			local button = _G[name..i]

			if button then
				button:ClearAllPoints()
				button:SetSize(C.db.profile.auras[C.db.char.layout].aura_size, C.db.profile.auras[C.db.char.layout].aura_size)

				if i == 1 then
					button:SetPoint("TOPRIGHT", debuffHeader, "TOPRIGHT", -C.db.profile.auras[C.db.char.layout].aura_gap / 2, -C.db.profile.auras[C.db.char.layout].aura_gap / 2)
				else
					button:SetPoint("TOPRIGHT", _G[name..(i - 1)], "TOPLEFT", -C.db.profile.auras[C.db.char.layout].aura_gap, 0)
				end

				E:SkinAuraButton(button)
			end
		end)

		-- Temp enchants
		local enchHeader = _G.CreateFrame("Frame", "LSTempEnchantHeader", _G.UIParent)
		enchHeader:SetSize(C.db.profile.auras[C.db.char.layout].aura_size + C.db.profile.auras[C.db.char.layout].aura_gap, C.db.profile.auras[C.db.char.layout].aura_size + C.db.profile.auras[C.db.char.layout].aura_gap)
		enchHeader:SetPoint(unpack(C.db.profile.auras[C.db.char.layout].tempench.point))
		E:CreateMover(enchHeader)

		_G.TemporaryEnchantFrame:SetParent(enchHeader)
		_G.TemporaryEnchantFrame:SetAllPoints()

		for i = 1, _G.NUM_TEMP_ENCHANT_FRAMES do
			local button = _G["TempEnchant"..i]

			if button then
				button:ClearAllPoints()
				button:SetSize(C.db.profile.auras[C.db.char.layout].aura_size, C.db.profile.auras[C.db.char.layout].aura_size)

				if i == 1 then
					button:SetPoint("TOPRIGHT", enchHeader, "TOPRIGHT", -C.db.profile.auras[C.db.char.layout].aura_gap / 2, -C.db.profile.auras[C.db.char.layout].aura_gap / 2)
				else
					button:SetPoint("TOPRIGHT", _G["TempEnchant"..(i - 1)], "TOPLEFT", -C.db.profile.auras[C.db.char.layout].aura_gap, 0)
				end

				E:SkinAuraButton(button)
			end
		end

		_G.BuffFrame_UpdateAllBuffAnchors()
		_G.TemporaryEnchantFrame_Update(_G.GetWeaponEnchantInfo())

		-- Finalise
		isInit = true

		return true
	end
end
