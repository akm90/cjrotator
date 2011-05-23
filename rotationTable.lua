--[[local rotationTable = {
[12] = CJFrostDKRot(),
[13] = CJUnholyDKRot(),
[21] = CJBalanceDruidRot(),
[22] = CJFeralDruidRot(),
[31] = CJBMHunterRot(),
[32] = CJMMHunterRot(),
[33] = CJSVHunterRot(),
[42] = CJFireMageRot(),
[43] = CJFrostMageRot(),
[71] = CJAssRogueRot(),
[72] = CJCombRogueRot(),
[73] = CJSubRogueRot(),
[92] = CJDemoLockRot(),
[93] = CJDestLockRot(),
};--]]

cj_rotationTable = {
[22] = "CJFeralDruidRot",
[41] = "CJArcMageRot",
[42] = "CJFireMageRot",
[43] = "CJFrostMageRot",
[53] = "CJRetPallyRot",
[61] = "CJDiscPriestRot",
[63] = "CJSpriestRot",
[81] = "CJEleShamRot",
[82] = "CJEnhShamRot",
[91] = "CJAffLockRot",
[101] = "CJArmsWarRot",
[102]= "CJFuryWarRot"
};

cj_interruptBlacklist = {
	["High Priestess Kilnara"] = {[1] = "Shadow Bolt"},
	["Venomancer Mauri"] = {[1] = "Poison Bolt"},
	["Hex Lord Malacrass"] = {[1] = "Chain Lightning",[2] = "Mind Blast"},
	["Maloriak"] = {[1] = "Release Aberrations"},
	["Naz'jar Spiritmender"] = {[1] = "Wrath"},
	["Stonecore Earthshaper"] = {[1] = "Lava Burst",[2] = "Ground Shock"}
};