-------------------------------------
-- InvenRaidFrames3 SKIN for ElvUI --
--     Author : Meat (Elune-KR)    --
-------------------------------------

local E, C, L, DB = unpack(ElvUI)

if not IsAddOnLoaded("InvenRaidFrames3") then print("IRF3 does not exist") return end

print("IRF3 Completely Loaded")

local _G = _G
local IRF3 = InvenRaidFrames3
local LBDB = LibStub("LibBlueDB-1.0")
IRF3:RegisterEvent("PLAYER_LOGIN")

------------------
-- Movable Code --
------------------
local MovableRaid = CreateFrame("Frame",nil,UIParent)
MovableRaid:CreatePanel("Default",64,39,"CENTER", UIParent, "CENTER", 0, 0)
MovableRaid:Hide()
E.CreateMover(MovableRaid, "MovableRaid", "Move IRF")

-------------------
-- Profile SETUP --
-------------------
local widthvalue, heightvalue = 0, 0

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

---------------
-- Main Skin --
---------------

function IRF3:LoadPosition()
	self:SetUserPlaced(nil)
	self:SetScale(self.db.scale)
	self:ClearAllPoints()
	self:SetPoint(self.db.anchor, MovableRaid, "TOPLEFT", 0, 0)
	self.petHeader:SetUserPlaced(nil)
	self.petHeader:SetScale(self.db.petscale)
	self.petHeader:ClearAllPoints()
	if self.db.petpx then
		self.petHeader:SetPoint(self.db.petanchor, UIParent, self.db.petanchor, self.db.petpx / (self.db.petscale * self.db.scale), self.db.petpy / (self.db.petscale * self.db.scale))
	else
		self.petHeader:SetPoint(self.db.petanchor, UIParent, "CENTER", 0, 0)
	end
	local widthvalue, heightvalue = 0, 0

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

	self.db.width = widthvalue
	self.db.height = E.Scale(39)
	self.db.lock = true
	
	--self.db.dir = 2
	self.db.border = false
	self.db.partyTag = false
	self.db.usePet = false
	self.db.offset = 6
	--self.db.groupshown = { true, true, true, true, true, false, false, false }
	self.db.column = 1

	self.db.units.powerBarHeight = 0.1
	self.db.units.healIcon = false
	self.db.units.healIconOther = false
	self.db.units.raidIconPos = "TOP"
	self.db.units.raidIconSize = 15
	self.db.units.className = true
	self.db.units.bossDebuffSize = 23
	self.db.units.bossDebuffPos = "BOTTOMRIGHT"
	self.db.units.bossDebuffAlpha = 1
	self.db.units.bossDebuffTimer = false
	self.db.units.fadeOutOfRangePower = true
	self.db.units.fadeOutAlpha = 0.3
	self.db.units.texture = "ElvUI Norm"
	--self.db.units.tooltip = 1
	--self.db.units.healthType = 0
	self.db.units.useCastingBar = false
	self.db.units.usePowerBarAlt = false
	
	self.db.font.file = "ElvUI Font"
	self.db.font.size = 10
	self.db.font.attribute = "THINOUTLINE"
	self.db.font.shadow = false
	
	self.db.colors.offline = E.colors.disconnected
	self.db.colors.MANA = { 0.31, 0.45, 0.63 }
	self.db.colors.RAGE = { 0.78, 0.25, 0.25 }

end

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
end

function IRF3:CreateElvUI(self)
	if self.bdrtop == nil then
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
	
	self.bdrtop:SetScript("OnUpdate", function()
		InvenRaidFrames3Member_UpdateOutline(self)
	end)
end

---------------
-- ICON SKIN --
---------------

local _G = _G
local GetTime = _G.GetTime
local UnitDebuff = _G.UnitDebuff
local PlaySoundFile = _G.PlaySoundFile
local SM = LibStub("LibSharedMedia-3.0")
local LRD = LibStub("LibRealDispel-1.0")
local E, C, L, DB = unpack(ElvUI) -- Using debuff icontexture border

local SL = IRF3.GetSpellName
local ignoreDebuffs = {
	[SL( 6788)] = true, [SL( 8326)] = true, [SL(11196)] = true, [SL(15822)] = true, [SL(21163)] = true,
	[SL(24360)] = true, [SL(24755)] = true, [SL(25771)] = true, [SL(26004)] = true, [SL(26013)] = true,
	[SL(26680)] = true, [SL(28169)] = true, [SL(28504)] = true, [SL(29232)] = true, [SL(30108)] = true,
	[SL(30451)] = true, [SL(30529)] = true, [SL(36893)] = true, [SL(36900)] = true, [SL(36901)] = true,
	[SL(40880)] = true, [SL(40882)] = true, [SL(40883)] = true, [SL(40891)] = true, [SL(40896)] = true,
	[SL(40897)] = true, [SL(41292)] = true, [SL(41337)] = true, [SL(41350)] = true, [SL(41425)] = true,
	[SL(42164)] = true, [SL(43681)] = true, [SL(55711)] = true, [SL(57723)] = true, [SL(57724)] = true,
	[SL(64805)] = true, [SL(64808)] = true, [SL(64809)] = true, [SL(64810)] = true, [SL(64811)] = true,
	[SL(64812)] = true, [SL(64813)] = true, [SL(64814)] = true, [SL(64815)] = true, [SL(64816)] = true,
	[SL(66233)] = true, [SL(69127)] = true, [SL(69438)] = true, [SL(70402)] = true, [SL(71328)] = true,
	[SL(72144)] = true, [SL(72145)] = true, [SL(72369)] = true, [SL(80354)] = true, [SL(95223)] = true,
	[SL(89798)] = true, [SL(96328)] = true, [SL(96325)] = true, [SL(96326)] = true,
}
ignoreDebuffs[""] = nil
IRF3.ignoreDebuffs = ignoreDebuffs
local bossDebuffs = {
	[SL(   605)] = true, [SL(  8399)] = true, [SL( 11433)] = true, [SL( 12294)] = true, [SL( 17140)] = true,
	[SL( 29879)] = true, [SL( 30115)] = true, [SL( 30756)] = true, [SL( 31306)] = true, [SL( 31344)] = true,
	[SL( 31347)] = true, [SL( 31943)] = true, [SL( 31972)] = true, [SL( 32779)] = true, [SL( 37006)] = true,
	[SL( 37027)] = true, [SL( 37676)] = true, [SL( 38049)] = true, [SL( 38246)] = true, [SL( 39837)] = true,
	[SL( 40239)] = true, [SL( 40251)] = true, [SL( 40327)] = true, [SL( 40481)] = true, [SL( 40508)] = true,
	[SL( 40585)] = true, [SL( 40594)] = true, [SL( 40869)] = true, [SL( 40932)] = true, [SL( 41032)] = true,
	[SL( 41472)] = true, [SL( 41917)] = true, [SL( 42005)] = true, [SL( 42783)] = true, [SL( 43095)] = true,
	[SL( 43149)] = true, [SL( 43657)] = true, [SL( 44811)] = true, [SL( 44867)] = true, [SL( 45141)] = true,
	[SL( 45150)] = true, [SL( 45230)] = true, [SL( 45256)] = true, [SL( 45324)] = true, [SL( 45348)] = true,
	[SL( 45641)] = true, [SL( 45661)] = true, [SL( 45737)] = true, [SL( 45996)] = true, [SL( 46469)] = true,
	[SL( 46771)] = true, [SL( 51121)] = true, [SL( 55249)] = true, [SL( 55550)] = true, [SL( 56112)] = true,
	[SL( 57975)] = true, [SL( 58517)] = true, [SL( 59265)] = true, [SL( 59847)] = true, [SL( 61888)] = true,
	[SL( 61903)] = true, [SL( 61968)] = true, [SL( 61969)] = true, [SL( 62130)] = true, [SL( 62331)] = true,
	[SL( 62526)] = true, [SL( 62532)] = true, [SL( 62589)] = true, [SL( 62661)] = true, [SL( 62717)] = true,
	[SL( 63018)] = true, [SL( 63276)] = true, [SL( 63355)] = true, [SL( 63498)] = true, [SL( 63666)] = true,
	[SL( 63830)] = true, [SL( 64234)] = true, [SL( 64292)] = true, [SL( 64396)] = true, [SL( 64705)] = true,
	[SL( 64771)] = true, [SL( 65121)] = true, [SL( 65292)] = true, [SL( 65598)] = true, [SL( 66013)] = true,
	[SL( 66869)] = true, [SL( 67049)] = true, [SL( 67283)] = true, [SL( 67298)] = true, [SL( 67472)] = true,
	[SL( 67478)] = true, [SL( 67574)] = true, [SL( 67618)] = true, [SL( 68125)] = true, [SL( 69065)] = true,
	[SL( 69200)] = true, [SL( 69240)] = true, [SL( 69278)] = true, [SL( 69409)] = true, [SL( 69483)] = true,
	[SL( 69674)] = true, [SL( 70126)] = true, [SL( 70337)] = true, [SL( 70447)] = true, [SL( 70541)] = true,
	[SL( 70672)] = true, [SL( 70867)] = true, [SL( 71204)] = true, [SL( 71289)] = true, [SL( 71330)] = true,
	[SL( 71340)] = true, [SL( 72004)] = true, [SL( 72219)] = true, [SL( 72293)] = true, [SL( 72385)] = true,
	[SL( 72408)] = true, [SL( 72451)] = true, [SL( 72650)] = true, [SL( 90098)] = true, [SL( 79888)] = true,
	[SL( 80094)] = true, [SL( 92023)] = true, [SL( 79501)] = true, [SL( 92978)] = true, [SL( 77760)] = true,
	[SL( 77786)] = true, [SL( 78075)] = true, [SL( 78092)] = true, [SL( 89666)] = true, [SL( 86788)] = true,
	[SL( 86013)] = true, [SL( 82762)] = true,
	-- 불의 땅 ; not necessary
	[SL( 49026)] = true, [SL(100094)] = true, [SL(101729)] = true, [SL(101208)] = true, [SL( 99837)] = true,
	[SL( 99936)] = true, [SL( 99262)] = true, [SL( 99263)] = true, [SL( 99516)] = true, [SL( 99403)] = true,
	[SL( 98450)] = true, [SL( 99399)] = true, [SL(100293)] = true, [SL(100238)] = true, [SL(100460)] = true,
}

bossDebuffs[""] = nil
IRF3.bossDebuffs = bossDebuffs

local dispelTypes = { Magic = "Magic", Curse = "Curse", Disease = "Disease", Poison = "Poison" }
local name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, spellId, canApplyAura, isBossDebuff
local lastTime, debuffIcon = 0

local LRD = LibStub("LibRealDispel-1.0")

local function hideIcon(icon)
	icon:SetSize(0.001, 0.001)
	icon:Hide()
end

local function updateDispel(self, debuffType)
	self.dispelType = debuffType
	if self.optionTable.dispelSound ~= "None" then
		if GetTime() > lastTime then
			lastTime = GetTime() + self.optionTable.dispelSoundDelay
			PlaySoundFile(SM:Fetch("sound", self.optionTable.dispelSound))
		end
	end
end

local function isUsableDebuff(debuff)
	if IRF3.db.ignoreDebuffs[debuff] then
		return nil
	elseif ignoreDebuffs[debuff] and IRF3.db.ignoreDebuffs[debuff] ~= false then
		return nil
	end
	return true
end

local function checkBossDebuff(debuff, blizz)	-- why disable this option? i dont wanna add blizzdebuff automatically
	if IRF3.db.userDebuffs[debuff] then
		return true
	elseif IRF3.db.userDebuffs[debuff] ~= false then
		if bossDebuffs[debuff] then
			return true
		elseif blizz then
			--bossDebuffs[debuff] = true
			--IRF3.db.userDebuffs[debuff] = true
			--IRF3:Message(("새로운 중요 디버프 \"%s\"|1이;가; 발견되어 목록에 추가했습니다."):format(debuff))
			return true
		end
	end
	return nil
end

local function bossDebuffOnUpdate1(self)
	-- 남은 시간
	-- set decimal under 5sec value
	self.timerParent.text:SetFont(C["media"].font, C["unitframes"].auratextscale*0.85, "THINOUTLINE")
	if (self.endTime - GetTime() + 0.5) > 5 then
		self.timerParent.text:SetFormattedText("%d", self.endTime - GetTime() + 0.5)
	else
		self.timerParent.text:SetFormattedText("|cffff4444%.1f|r", self.endTime - GetTime() + 0.5)
	end
end

local function bossDebuffOnUpdate2(self)
	-- 경과 시간
	self.timerParent.text:SetFormattedText("%d", GetTime() - self.startTime + 0.5)
end

function InvenRaidFrames3Member_UpdateDebuffs(self)
	self.bossDebuff.index, self.bossDebuff.startTime, self.bossDebuff.endTime, self.bossDebuff.func = nil
	self.numDebuffIcons = 0
	for i = 1, 40 do
		name, _, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, _, spellId, canApplyAura, isBossDebuff = UnitDebuff(self.displayedUnit, i)
		if name then
			if isUsableDebuff(name) then
				debuffType = dispelTypes[debuffType] or "none"
				if self.optionTable.useBossDebuff and not self.bossDebuff.index and checkBossDebuff(name) then
					-- 사용자 디버프
					self.bossDebuff.index = i
					self.bossDebuff:SetSize(self.optionTable.bossDebuffSize, self.optionTable.bossDebuffSize)
					self.bossDebuff:SetTemplate("Default")	-- make elvui border
					self.bossDebuff.icon:SetTexture(icon)
					self.bossDebuff.count:SetPoint('BOTTOMRIGHT', 0, 2)	-- reposition count text
					self.bossDebuff.count:SetFont(C["media"].font, C["unitframes"].auratextscale*0.8, "THINOUTLINE")
					self.bossDebuff.count:SetText(count and count > 1 and count or nil)
					self.bossDebuff.cooldown.noOCC = true	-- hide elvui/OmniCC CDs
					self.bossDebuff.cooldown.noCooldownCount = true
					if duration and duration > 0 and self.optionTable.bossDebuffTimer then
						self.bossDebuff.cooldown:SetCooldown(expirationTime - duration, duration)
						self.bossDebuff.cooldown:Show()
					else
						self.bossDebuff.cooldown:Hide()
					end
					self.bossDebuff:Show()
					if duration and duration > 0 and expirationTime then
						if self.optionTable.bossDebuffOpt == 1 then
							self.bossDebuff.endTime = expirationTime
							self.bossDebuff:SetScript("OnUpdate", bossDebuffOnUpdate1)
							bossDebuffOnUpdate1(self.bossDebuff)
						elseif self.optionTable.bossDebuffOpt == 2 then
							self.bossDebuff.startTime = expirationTime - duration
							self.bossDebuff:SetScript("OnUpdate", bossDebuffOnUpdate2)
							bossDebuffOnUpdate2(self.bossDebuff)
						else
							self.bossDebuff:SetScript("OnUpdate", nil)
							self.bossDebuff.timerParent.text:SetText(nil)
						end
					else
						self.bossDebuff:SetScript("OnUpdate", nil)
						self.bossDebuff.timerParent.text:SetText(nil)
					end
				elseif self.optionTable.debuffIconFilter[debuffType] and self.optionTable.debuffIcon > self.numDebuffIcons then
					-- 디버프 아이콘
					self.numDebuffIcons = self.numDebuffIcons + 1
					debuffIcon = self["debuffIcon"..self.numDebuffIcons]
					debuffIcon:SetSize(self.optionTable.debuffIconSize, self.optionTable.debuffIconSize)
					if IRF3.db.colors[debuffType] then
						debuffIcon.color:SetTexture(IRF3.db.colors[debuffType][1], IRF3.db.colors[debuffType][2], IRF3.db.colors[debuffType][3])
					else
						debuffIcon.color:SetTexture(0, 0, 0)
					end
					debuffIcon.icon:SetTexture(icon)
					debuffIcon.count:SetText(count and count > 1 and count or nil)
					debuffIcon:Show()
					debuffIcon = nil
				end
			end
		else
			break
		end
	end
	if not self.bossDebuff.index then
		hideIcon(self.bossDebuff)
	end
	for i = self.numDebuffIcons + 1, 5 do
		hideIcon(self["debuffIcon"..i])
	end
	InvenRaidFrames3Pet_UpdateDebuffs(self)
end

function InvenRaidFrames3Pet_UpdateDebuffs(self)
	name, _, _, _, debuffType = LRD:DispelHelp(self.displayedUnit, isUsableDebuff)
	if name then
		self.dispelType = dispelTypes[debuffType] or "none"
		if self.optionTable.dispelSound ~= "None" then
			if GetTime() > lastTime then
				lastTime = GetTime() + self.optionTable.dispelSoundDelay
				PlaySoundFile(SM:Fetch("sound", self.optionTable.dispelSound))
			end
		end
	else
		self.dispelType = nil
	end
end

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
			--self.name:SetAlpha(self.optionTable.fadeOutOfRangeHealth and self.optionTable.fadeOutAlpha or 1)	-- update error fix
		end
	else
		self.name:SetTextColor(IRF3.db.colors.name[1], IRF3.db.colors.name[2], IRF3.db.colors.name[3])
	end
end
-------------------
-- TEXT SKIN END --
-------------------

local colorR, colorG, colorB

function InvenRaidFrames3Member_UpdateState(self)
	self.class = select(2, UnitClass(self.displayedUnit))
	if UnitIsConnected(self.unit) then
		if UnitIsGhost(self.displayedUnit) then
			self.isGhost, self.isOffline, self.isDead, self.isAFK = true
		elseif UnitIsDead(self.displayedUnit) then
			self.isDead, self.isOffline, self.isGhost, self.isAFK = true
		elseif UnitIsAFK(self.unit) then
			self.isAFK, self.isOffline, self.isGhost, self.isDead = true
		else
			self.isGhost, self.isOffline, self.isDead, self.isAFK = nil
		end
		if self.isGhost or self.isDead then
			colorR, colorG, colorB = IRF3.db.colors[self.class][1], IRF3.db.colors[self.class][2], IRF3.db.colors[self.class][3]
		elseif self.optionTable.useHarm and UnitCanAttack(self.displayedUnit, "player") then
			colorR, colorG, colorB = IRF3.db.colors.harm[1], IRF3.db.colors.harm[2], IRF3.db.colors.harm[3]
		elseif self.dispelType and IRF3.db.colors[self.dispelType] and self.optionTable.useDispelColor then
			colorR, colorG, colorB = IRF3.db.colors[self.dispelType][1], IRF3.db.colors[self.dispelType][2], IRF3.db.colors[self.dispelType][3]
		elseif self.displayedUnit:find("pet") then
			if self.petButton then
				colorR, colorG, colorB = IRF3.db.colors.vehicle[1], IRF3.db.colors.vehicle[2], IRF3.db.colors.vehicle[3]
			else
				colorR, colorG, colorB = IRF3.db.colors.pet[1], IRF3.db.colors.pet[2], IRF3.db.colors.pet[3]
			end
		elseif self.optionTable.useClassColors and IRF3.db.colors[self.class] then
			colorR, colorG, colorB = IRF3.db.colors[self.class][1], IRF3.db.colors[self.class][2], IRF3.db.colors[self.class][3]
		else
			colorR, colorG, colorB = IRF3.db.colors.help[1], IRF3.db.colors.help[2], IRF3.db.colors.help[3]
		end
	else
		self.isOffline, self.isGhost, self.isDead, self.isAFK = true
		colorR, colorG, colorB = IRF3.db.colors.offline[1], IRF3.db.colors.offline[2], IRF3.db.colors.offline[3]
	end
	self.healthBar:SetStatusBarColor(colorR, colorG, colorB)
	self.bdrtop:SetBackdropColor(colorR*0.25, colorG*0.25, colorB*0.25, 1) -- Classbar backdrop color ; multiply
	colorR, colorG, colorB = nil
end

function InvenRaidFrames3Member_UpdatePowerColor(self)
	if self.isOffline then
		colorR, colorG, colorB = IRF3.db.colors.offline[1], IRF3.db.colors.offline[2], IRF3.db.colors.offline[3]
	elseif select(7, UnitAlternatePowerInfo(self.displayedUnit)) then
		colorR, colorG, colorB = 0.7, 0.7, 0.6
	else
		colorR, colorG, altR, altG, altB = UnitPowerType(self.displayedUnit)
		if IRF3.db.colors[colorG] then
			colorR, colorG, colorB = IRF3.db.colors[colorG][1], IRF3.db.colors[colorG][2], IRF3.db.colors[colorG][3]
		elseif PowerBarColor[colorR] then
			colorR, colorG, colorB = PowerBarColor[colorR].r, PowerBarColor[colorR].g, PowerBarColor[colorR].b
		elseif altR then
			colorR, colorG, colorB = altR, altG, altB
		else
			colorR, colorG, colorB = PowerBarColor[0].r, PowerBarColor[0].g, PowerBarColor[0].b
		end
	end
	self.powerBar:SetStatusBarColor(colorR, colorG, colorB)
	self.bdrbot:SetBackdropColor(colorR*0.25, colorG*0.25, colorB*0.25)	-- powerbartype backdrop color ; multiply
	colorR, colorG, colorB, altR, altG, altB = nil
end

function InvenRaidFrames3Member_UpdateOutline(self)	
	borderr, borderg, borderb = unpack(C["media"].bordercolor)	-- import default bordercolor
	self.outline:Hide() -- do not need this option anymore
	
	if self.optionTable.outline.type == 1 then	-- 해제 가능한 디버프; Also check aggro, order 1st. dispel Border otherwise Aggro color
		if self.dispelType and IRF3.db.colors[self.dispelType] then
			self.bdrtop:SetBackdropBorderColor(IRF3.db.colors[self.dispelType][1], IRF3.db.colors[self.dispelType][2], IRF3.db.colors[self.dispelType][3])
			self.bdrbot:SetBackdropBorderColor(IRF3.db.colors[self.dispelType][1], IRF3.db.colors[self.dispelType][2], IRF3.db.colors[self.dispelType][3])
			return
		elseif self.hasAggro then
			self.bdrtop:SetBackdropBorderColor(self.optionTable.outline.aggroColor[1], self.optionTable.outline.aggroColor[2], self.optionTable.outline.aggroColor[3])
			self.bdrbot:SetBackdropBorderColor(self.optionTable.outline.aggroColor[1], self.optionTable.outline.aggroColor[2], self.optionTable.outline.aggroColor[3])
			return
		end
	elseif self.optionTable.outline.type == 2 then	-- 대상
		if UnitIsUnit(self.displayedUnit, "target") then
			self.bdrtop:SetBackdropBorderColor(self.optionTable.outline.targetColor[1], self.optionTable.outline.targetColor[2], self.optionTable.outline.targetColor[3])
			self.bdrbot:SetBackdropBorderColor(self.optionTable.outline.targetColor[1], self.optionTable.outline.targetColor[2], self.optionTable.outline.targetColor[3])
			return
		end
	elseif self.optionTable.outline.type == 3 then	-- 마우스 오버
		if UnitIsUnit(self.displayedUnit, "mouseover") then
			self.bdrtop:SetBackdropBorderColor(self.optionTable.outline.mouseoverColor[1], self.optionTable.outline.mouseoverColor[2], self.optionTable.outline.mouseoverColor[3])
			self.bdrbot:SetBackdropBorderColor(self.optionTable.outline.mouseoverColor[1], self.optionTable.outline.mouseoverColor[2], self.optionTable.outline.mouseoverColor[3])
			return
		end
	elseif self.optionTable.outline.type == 4 then	-- 체력 낮음(퍼센트)
		if not UnitIsDeadOrGhost(self.displayedUnit) and (self.health / self.maxHealth) <= self.optionTable.outline.lowHealth then
			self.bdrtop:SetBackdropBorderColor(self.optionTable.outline.lowHealthColor[1], self.optionTable.outline.lowHealthColor[2], self.optionTable.outline.lowHealthColor[3])
			self.bdrbot:SetBackdropBorderColor(self.optionTable.outline.lowHealthColor[1], self.optionTable.outline.lowHealthColor[2], self.optionTable.outline.lowHealthColor[3])
			return
		end
	elseif self.optionTable.outline.type == 5 then	-- 어그로
		if self.hasAggro then
			self.bdrtop:SetBackdropBorderColor(self.optionTable.outline.aggroColor[1], self.optionTable.outline.aggroColor[2], self.optionTable.outline.aggroColor[3])
			self.bdrbot:SetBackdropBorderColor(self.optionTable.outline.aggroColor[1], self.optionTable.outline.aggroColor[2], self.optionTable.outline.aggroColor[3])
			return
		end
	elseif self.optionTable.outline.type == 6 then	-- 전술목표 아이콘
		if self.optionTable.outline.raidIcon[GetRaidTargetIndex(self.displayedUnit)] then
			self.bdrtop:SetBackdropBorderColor(self.optionTable.outline.raidIconColor[1], self.optionTable.outline.raidIconColor[2], self.optionTable.outline.raidIconColor[3])
			self.bdrbot:SetBackdropBorderColor(self.optionTable.outline.raidIconColor[1], self.optionTable.outline.raidIconColor[2], self.optionTable.outline.raidIconColor[3])
			return
		end
	elseif self.optionTable.outline.type == 7 then	-- 체력 낮음(실수치)
		if not UnitIsDeadOrGhost(self.displayedUnit) and self.maxHealth >= self.optionTable.outline.lowHealth2 and self.health < self.optionTable.outline.lowHealth2 then
			self.bdrtop:SetBackdropBorderColor(self.optionTable.outline.lowHealthColor2[1], self.optionTable.outline.lowHealthColor2[2], self.optionTable.outline.lowHealthColor2[3])
			self.bdrbot:SetBackdropBorderColor(self.optionTable.outline.lowHealthColor2[1], self.optionTable.outline.lowHealthColor2[2], self.optionTable.outline.lowHealthColor2[3])
			return
		end
	end
	-- reset bordercolor
	self.bdrtop:SetBackdropBorderColor(borderr, borderg, borderb)
	self.bdrbot:SetBackdropBorderColor(borderr, borderg, borderb)
end