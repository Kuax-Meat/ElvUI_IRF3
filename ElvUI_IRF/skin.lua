-------------------------------------
-- InvenRaidFrames3 SKIN for ElvUI --
--     Author : Meat (Elune-KR)    --
-------------------------------------

local E, C, L, DB = unpack(ElvUI)

if not IsAddOnLoaded("InvenRaidFrames3") then print("IRF3 does not exist") return end

print("IRF3 Completely Loaded")

local _G = _G
local IRF3 = InvenRaidFrames3
local widthvalue, heightvalue = 0, 0

IRF3:RegisterEvent("PLAYER_LOGIN")

---------------
-- Main Skin --
---------------

function IRF3:SetupAll(update)
	for _, header in pairs(IRF3.headers) do
		for _, member in pairs(header.members) do
			member:Setup()
			IRF3:CreateElvUI(member)
		end
	end
	for _, member in pairs(IRF3.petHeader.members) do
		member:Setup()
		IRF3:CreateElvUI(member)
	end
	self.db.units.texture = "ElvUI Norm"
	self.db.font.file = "ElvUI Font"
	self.db.font.size = 10
	self.db.font.attribute = "THINOUTLINE"
	self.db.font.shadow = false
	self.db.units.powerBarHeight = 0.1
	self.db.border = false
	self.db.partyTag = false
	self.db.colors.MANA = { 0.31, 0.45, 0.63 }
	self.db.colors.RAGE = { 0.78, 0.25, 0.25 }
	self.db.usePet = false
	self.db.offset = 6
	self.db.units.className = true
	if (E.screenwidth / E.screenheight) == 1.6 then
		if IsAddOnLoaded("Elvui_RaidDPS") then
			widthvalue = ((ChatLBGDummy:GetWidth() - (27)) / 5)
		elseif IsAddOnLoaded("Elvui_RaidHeal") then
			widthvalue = ((ElvuiActionBarBackground:GetWidth() - (27)) / 5)
		end
	else
		if IsAddOnLoaded("Elvui_RaidDPS") then
			widthvalue = ((ChatLBGDummy:GetWidth() - (28)) / 5)
		elseif IsAddOnLoaded("Elvui_RaidHeal") then
			widthvalue = ((ElvuiActionBarBackground:GetWidth() - (28)) / 5)
		end
	end
	print(widthvalue)
	self.db.width = widthvalue
	self.db.height = E.Scale(39)
end

function IRF3:CreateElvUI(self)
	if not self.bdrtop then
		self.bdrtop = CreateFrame('Frame', nil, self.healthBar)
		self.bdrtop:SetTemplate("Default")
		self.bdrtop:Point("TOPRIGHT", self.healthBar, "TOPRIGHT", 2*E.ResScale, 2*E.ResScale)
		self.bdrtop:Point("BOTTOMLEFT", self.healthBar, "BOTTOMLEFT", -2*E.ResScale, -2*E.ResScale)
		self.bdrtop:CreateShadow("Default")
		
		self.bdrbot = CreateFrame('Frame', nil, self.powerBar)
		self.bdrbot:SetTemplate("Default")
		self.bdrbot:Point("TOPRIGHT", self.powerBar, "TOPRIGHT", 2*E.ResScale, 2*E.ResScale)
		self.bdrbot:Point("BOTTOMLEFT", self.powerBar, "BOTTOMLEFT", -2*E.ResScale, -2*E.ResScale)
		self.bdrbot:CreateShadow("Default")
	end
	
	self.healthBar:SetFrameStrata("LOW")
	self.powerBar:SetFrameStrata("LOW")
	self.bdrtop:SetFrameLevel(self:GetParent():GetFrameLevel())
	self.bdrbot:SetFrameLevel(self:GetParent():GetFrameLevel())
	
	self.healthBar:SetPoint("TOPLEFT", 0, 0)
	self.healthBar:SetPoint("BOTTOMRIGHT", self.powerBar, "TOPRIGHT", 0, E.Scale(5))
	self.powerBar:SetPoint("BOTTOMLEFT", 0, 0)
	self.powerBar:SetPoint("BOTTOMRIGHT", 0, 0)
	
	self.name:SetPoint("TOP", self.healthBar, 0, -3)		-- Name Text
	self.name:SetJustifyV("TOP")
	self.name:SetJustifyH("CENTER")
	self.name:SetSpacing(4)
end

---------------
-- ICON SKIN --
---------------



---------------
-- TEXT SKIN --
---------------
local select = _G.select
local tonumber = _G.tonumber
local twipe = _G.table.wipe
local tinsert = _G.table.insert
local UnitName = _G.UnitName
local UnitClass = _G.UnitClass
local UnitGUID = _G.UnitGUID
local UnitIsUnit = _G.UnitIsUnit
local GetRaidRosterInfo = _G.GetRaidRosterInfo

local fontString = IRF3:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall")

local function getTextWidth(text)
	fontString:SetText(text)
	return ceil(fontString:GetWidth())
end

function IRF3:UpdateFont()
	fontString:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", IRF3.db.font.file), IRF3.db.font.size, IRF3.db.font.attribute)
	fontString:SetShadowColor(0, 0, 0)
	if IRF3.db.font.shadow then
		fontString:SetShadowOffset(1, -1)
	else
		fontString:SetShadowOffset(0, 0)
	end
	fontString.putWidth = getTextWidth("")
	fontString.arrowWidth = getTextWidth("")
	fontString.offlineWidth = getTextWidth("")
	fontString.ghostWidth = getTextWidth("")
	fontString.deathWidth = getTextWidth("")
	fontString.afkWidth = getTextWidth("")
end

local function getCuttingName(names, width)
	for i = 1, #names do
		if width >= getTextWidth(names[i]) then
			return names[i]
		end
	end
	return names[#names] or ""
end

local healthText
-- COLOR MODIFIED
local function getHealthText(self)
	if self.optionTable.healthRed then
		if IRF3.db.units.healthType == 1 then
			if IRF3.db.units.shortLostHealth then
				return ("|cffAF5050-%.1f|r"):format(self.lostHealth / 1000)
			else
				return "|cffAF5050-"..self.lostHealth.."|r"
			end
		elseif IRF3.db.units.healthType == 2 then
			if IRF3.db.units.shortLostHealth then
				return ("|cffAF5050-%d|r"):format(self.lostHealth / self.maxHealth * 100)
			else
				return ("|cffAF5050-%d%%|r"):format(self.lostHealth / self.maxHealth * 100)
			end
		elseif IRF3.db.units.healthType == 3 then
			if IRF3.db.units.shortLostHealth then
				return ("|cff559655%.1f|r"):format(self.health / 1000)
			else
				return "|cff559655"..self.health.."|r"
			end
		elseif IRF3.db.units.healthType == 4 then
			if IRF3.db.units.shortLostHealth then
				return ("|cff559655%d|r"):format(self.health / self.maxHealth * 100)
			else
				return ("|cff559655%d%%|r"):format(self.health / self.maxHealth * 100)
			end
		end
	elseif IRF3.db.units.healthType == 1 then
		if IRF3.db.units.shortLostHealth then
			return ("|cffAF5050-%.1f|r"):format(self.lostHealth / 1000)
		else
			return "|cffAF5050-"..self.lostHealth.."|r"
		end
	elseif IRF3.db.units.healthType == 2 then
		if IRF3.db.units.shortLostHealth then
			return ("|cffAF5050-%d|r"):format(self.lostHealth / self.maxHealth * 100)
		else
			return ("|cffAF5050-%d%%|r"):format(self.lostHealth / self.maxHealth * 100)
		end
	elseif IRF3.db.units.healthType == 3 then
		if IRF3.db.units.shortLostHealth then
			return ("|cff559655%.1f|r"):format(self.health / 1000)
		else
			return "|cff559655"..self.health.."|r"
		end
	elseif IRF3.db.units.healthType == 4 then
		if IRF3.db.units.shortLostHealth then
			return ("|cff559655%d|r"):format(self.health / self.maxHealth * 100)
		else
			return ("|cff559655%d%%|r"):format(self.health / self.maxHealth * 100)
		end
	end
	return ""
end

local function checkRange(self)
	if IRF3.db.units.healthRange == 1 then
		return true
	elseif self.outRange then
		return IRF3.db.units.healthRange == 3
	else
		return IRF3.db.units.healthRange == 2
	end
end

InvenRaidFrames3Member_UpdateDisplayText_ = InvenRaidFrames3Member_UpdateDisplayText
InvenRaidFrames3Member_UpdateDisplayText = function(self)
	if self.isOffline then
		if IRF3.db.units.nameEndl then
			self.name:SetFormattedText("%s\n|cffD7BEA5오프라인|r", getCuttingName(self.nameTable, IRF3.nameWidth))
		else
			self.name:SetFormattedText("%s\n|cffD7BEA5오프라인|r", getCuttingName(self.nameTable, IRF3.nameWidth))
		end
	elseif self.isGhost then
		if IRF3.db.units.nameEndl then
			self.name:SetFormattedText("%s\n|cffD7BEA5유령|r", getCuttingName(self.nameTable, IRF3.nameWidth))
		else
			self.name:SetFormattedText("%s\n|cffD7BEA5유령|r", getCuttingName(self.nameTable, IRF3.nameWidth))
		end
	elseif self.isDead then
		if IRF3.db.units.nameEndl then
			self.name:SetFormattedText("%s\n|cffD7BEA5죽음|r", getCuttingName(self.nameTable, IRF3.nameWidth))
		else
			self.name:SetFormattedText("%s\n|cffD7BEA5죽음|r", getCuttingName(self.nameTable, IRF3.nameWidth))
		end
	else
		if self.lostHealth > 0 and IRF3.db.units.healthType ~= 0 and checkRange(self) then
			healthText = getHealthText(self)
			if self.survivalSkill then
				self.name:SetFormattedText("%s\n|cffD7BEA5%s%s|r", getCuttingName(self.nameTable, IRF3.nameWidth), self.survivalSkill, self.survivalSkillTimeLeft)
			elseif IRF3.db.units.nameEndl then
				self.name:SetFormattedText("%s\n%s", getCuttingName(self.nameTable, IRF3.nameWidth), healthText)
			else
				self.name:SetFormattedText("%s\n%s", getCuttingName(self.nameTable, IRF3.nameWidth), healthText)
			end
		elseif self.isAFK then
			if self.survivalSkill then
				self.name:SetFormattedText("%s\n%s%s", getCuttingName(self.nameTable, IRF3.nameWidth), self.survivalSkill, self.survivalSkillTimeLeft)
			elseif IRF3.db.units.nameEndl then
				self.name:SetFormattedText("%s\n|cffD7BEA5AFK|r", getCuttingName(self.nameTable, IRF3.nameWidth))
			else
				self.name:SetFormattedText("%s\n|cffD7BEA5AFK|r", getCuttingName(self.nameTable, IRF3.nameWidth))
			end
		elseif self.survivalSkill then
			self.name:SetFormattedText("%s\n|cffD7BEA5%s%s|r", getCuttingName(self.nameTable, IRF3.nameWidth), self.survivalSkill, self.survivalSkillTimeLeft)
		else
			self.name:SetFormattedText("%s\n", getCuttingName(self.nameTable, IRF3.nameWidth))
		end
	end
end

function InvenRaidFrames3Member_UpdateNameColor(self)
	if IRF3.db.colors[self.class] and (self.optionTable.className or (self.isOffline and self.optionTable.offlineName) or (self.outRange and self.optionTable.outRangeName) or ((self.isGhost or self.isDead) and self.optionTable.deathName)) then
		self.name:SetTextColor(IRF3.db.colors[self.class][1], IRF3.db.colors[self.class][2], IRF3.db.colors[self.class][3])
		if self.outRange then
			self.name:SetAlpha(self.optionTable.fadeOutOfRangeHealth and self.optionTable.fadeOutAlpha or 1)	-- update error fix
		end
	else
		self.name:SetTextColor(IRF3.db.colors.name[1], IRF3.db.colors.name[2], IRF3.db.colors.name[3])
	end
end
-------------------
-- TEXT SKIN END --
-------------------