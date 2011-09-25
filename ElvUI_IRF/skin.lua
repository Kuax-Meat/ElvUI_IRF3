local E, C, L, DB = unpack(ElvUI)

if not IsAddOnLoaded("InvenRaidFrames3") then print("IRF3 does not exist") return end

print("IRF3 Completely Loaded")

local _G = _G
local IRF3 = InvenRaidFrames3
local SM = LibStub("LibSharedMedia-3.0")
print(InvenRaidFrames3)

--

function IRF3:SetupAll(update)
	for _, header in pairs(IRF3.headers) do
		for _, member in pairs(header.members) do
			IRF3:CreateElvUI()
			member:Setup()
		end
	end
	for _, member in pairs(IRF3.petHeader.members) do
		IRF3:CreateElvUI()
		member:Setup()
	end
end

function IRF3:CreateElvUI(self)
	for i = 1, 8 do
		for j = 1, 5 do
			IRF3.headers[i].members[j].bdrtop = CreateFrame('Frame', nil, IRF3.headers[i].members[j].healthBar)
			IRF3.headers[i].members[j].bdrtop:SetTemplate("Default")
			IRF3.headers[i].members[j].bdrtop:Point("TOPRIGHT", IRF3.headers[i].members[j].healthBar, "TOPRIGHT", 2*E.ResScale, 2*E.ResScale)
			IRF3.headers[i].members[j].bdrtop:Point("BOTTOMLEFT", IRF3.headers[i].members[j].healthBar, "BOTTOMLEFT", -2*E.ResScale, -2*E.ResScale)
			--IRF3.headers[i].members[j].bdrtop:CreateShadow("Default")
			IRF3.headers[i].members[j].bdrtop:SetFrameLevel(2)
		end
	end
end

IRF3.db.units.texture = "ElvUI Norm"