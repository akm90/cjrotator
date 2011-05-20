--[[local rotationTable = {
[12] = CJFrostDKRot(),
[13] = CJUnholyDKRot(),
[21] = CJBalanceDruidRot(),
[22] = CJFeralDruidRot(),
[31] = CJBMHunterRot(),
[32] = CJMMHunterRot(),
[33] = CJSVHunterRot(),
[41] = CJArcMageRot(),
[42] = CJFireMageRot(),
[43] = CJFrostMageRot(),
[53] = CJRetPallyRot(),
[63] = CJSPriestRot(),
[71] = CJAssRogueRot(),
[72] = CJCombRogueRot(),
[73] = CJSubRogueRot(),
[81] = CJEleShamRot(),
[82] = CJEnhShamRot(),
[91] = CJAffLockRot(),
[92] = CJDemoLockRot(),
[93] = CJDestLockRot(),
[101] = CJArmWarRot(),
[102] = CJFuryWarRot()
};--]]

cj_rotationTable = {
[41] = "CJArcMageRot",
[53] = "CJRetPallyRot",
[81] = "CJEleShamRot",
[82] = "CJEnhShamRot",
[102]= "CJFuryWarRot"
};

cj_interruptBlacklist = {
	["High Priestess Kilnara"] = {[1] = "Shadow Bolt"},
	["Venomancer Mauri"] = {[1] = "Poison Bolt"}
};