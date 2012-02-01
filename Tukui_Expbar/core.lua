if not IsAddOnLoaded("Tukui") then return end
local T, C, L = unpack(Tukui)

local reaction = {
	[1] = {{ 170/255, 70/255,  70/255 }, "Hated", "FFaa4646"},
	[2] = {{ 170/255, 70/255,  70/255 }, "Hostile", "FFaa4646"},
	[3] = {{ 170/255, 70/255,  70/255 }, "Unfriendly", "FFaa4646"},
	[4] = {{ 200/255, 180/255, 100/255 }, "Neutral", "FFc8b464"},
	[5] = {{ 75/255,  175/255, 75/255 }, "Friendly", "FF4baf4b"},
	[6] = {{ 75/255,  175/255, 75/255 }, "Honored", "FF4baf4b"},
	[7] = {{ 75/255,  175/255, 75/255 }, "Revered", "FF4baf4b"},
	[8] = {{ 155/255,  255/255, 155/255 }, "Exalted","FF9bff9b"},
}

local xp = CreateFrame("Frame", "LilXPBar", UIParent)
xp:CreatePanel("Default", 175, 22, "CENTER", UIParent, "CENTER", 0, 0)

xp.bar = CreateFrame("StatusBar", "xpb", xp)
xp.bar:SetStatusBarTexture(C.media.normTex)
xp.bar:SetFrameLevel(3)
xp.bar:SetPoint("TOPLEFT", xp, 2, -2)
xp.bar:SetPoint("BOTTOMRIGHT", xp, -2, 2)
xp.bar:CreateShadow()

xp.text = xp.bar:CreateFontString(nil, "OVERLAY")
xp.text:SetFont(C.media.font, 12)
xp.text:Point("LEFT", 2, 0)

xp.rest = CreateFrame("StatusBar", "restb", xp)
xp.rest:SetStatusBarTexture(C.media.normTex)
xp.rest:SetFrameLevel(2)
xp.rest:SetPoint("TOPLEFT", xp, 2, -2)
xp.rest:SetPoint("BOTTOMRIGHT", xp, -2, 2)
xp.rest:SetStatusBarColor(.4, 0, .4)
xp.rest:Hide()

local function UpdateXp(self)
	if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
		local XP, maxXP = UnitXP("player"), UnitXPMax("player")
		local restXP = GetXPExhaustion()
		if restXP then
			xp.text:SetText(XP.." / "..maxXP.."  ".."|cff7fcaff+"..math.floor(restXP/maxXP*100).."%|r")
			if not xp.rest:IsShown() then xp.rest:Show() end
			xp.rest:SetMinMaxValues(0, maxXP)
			xp.rest:SetValue(XP+restXP)
		else
			xp.text:SetText(XP.." / "..maxXP)
		end
		xp.bar:SetStatusBarColor(0, .4, .8)
		xp.bar:SetMinMaxValues(0, maxXP)
		xp.bar:SetValue(XP)
	elseif GetWatchedFactionInfo() then
		if xp.rest:IsShown() then xp.rest:Hide() end
		local name, rank, minRep, maxRep, value = GetWatchedFactionInfo()
		xp.text:SetText(value-minRep.."/"..maxRep-minRep)
		xp.bar:SetStatusBarColor(unpack(reaction[rank][1]))
		xp.bar:SetMinMaxValues(min(0, value-minRep), maxRep-minRep)
		xp.bar:SetValue(value-minRep)
	else
		xp.bar:SetValue(0)
		xp.text:SetText("-")
		xp.text:SetTextColor(1,1,1)
	end
end

xp:RegisterEvent("PLAYER_XP_UPDATE")
xp:RegisterEvent("PLAYER_ENTERING_WORLD")
xp:RegisterEvent("UPDATE_EXHAUSTION")
xp:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
xp:RegisterEvent("UPDATE_FACTION")
xp:SetScript("OnEvent", UpdateXp)