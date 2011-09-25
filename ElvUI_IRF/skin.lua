local E, C, L, DB = unpack(ElvUI)

if not IsAddOnLoaded("InvenRaidFrames3") then print("IRF3 does not exist") return end

print("IRF3 Completely Loaded")

local _G = _G
local IRF3 = InvenRaidFrames3
local SM = LibStub("LibSharedMedia-3.0")
print(IRF3)

--

function IRF3:SetupAll(update)
	for _, header in pairs(IRF3.headers) do
		for _, member in pairs(header.members) do
			IRF3:CreateElvUI(member)
			member:Setup()
		end
	end
	for _, member in pairs(IRF3.petHeader.members) do
		IRF3:CreateElvUI(member)
		member:Setup()
	end
	self.db.units.texture = "ElvUI Norm"
	self.db.font.file = "ElvUI Font"
	self.db.border = false
	self.db.partyTag = false
	self.db.colors.MANA = { 0.31, 0.45, 0.63 }
	self.db.colors.RAGE = { 0.78, 0.25, 0.25 }
end

function IRF3:CreateElvUI(self)
	if not self.bdrtop then
		self.bdrtop = CreateFrame('Frame', nil, self.healthBar)
		self.bdrtop:SetTemplate("Default")
		self.bdrtop:Point("TOPRIGHT", self.healthBar, "TOPRIGHT", 2*E.ResScale, 2*E.ResScale)
		self.bdrtop:Point("BOTTOMLEFT", self.healthBar, "BOTTOMLEFT", -2*E.ResScale, -2*E.ResScale)
		self.bdrtop:CreateShadow("Default")
		self.bdrtop:SetFrameLevel(self:GetParent():GetFrameLevel())
		
		self.bdrbot = CreateFrame('Frame', nil, self.powerBar)
		self.bdrbot:SetTemplate("Default")
		self.bdrbot:Point("TOPRIGHT", self.powerBar, "TOPRIGHT", 2*E.ResScale, 2*E.ResScale)
		self.bdrbot:Point("BOTTOMLEFT", self.powerBar, "BOTTOMLEFT", -2*E.ResScale, -2*E.ResScale)
		self.bdrbot:CreateShadow("Default")
		self.bdrbot:SetFrameLevel(self:GetParent():GetFrameLevel())
	end
	self.healthBar:SetPoint("TOPLEFT", 0, 0)
	self.healthBar:SetPoint("BOTTOMRIGHT", self.powerBar, "TOPRIGHT", 0, 5)
	self.powerBar:SetPoint("BOTTOMLEFT", 0, 0)
	self.powerBar:SetPoint("BOTTOMRIGHT", 0, 0)
end