cj_rotationTable = {
[11] = "CJBloodDKRot",
[12] = "CJFrostDKRot",
[13] = "CJUnholyDKRot",
[21] = "CJBalanceDruidRot",
[22] = "CJFeralDruidRot",
[31] = "CJBMHunterRot",
[32] = "CJMarksHunterRot",
[33] = "CJSurvHunterRot",
[41] = "CJArcMageRot",
[42] = "CJFireMageRot",
[43] = "CJFrostMageRot",
[52] = "CJProtPallyRot",
[53] = "CJRetPallyRot",
[61] = "CJDiscPriestRot",
[63] = "CJSpriestRot",
[71] = "CJAssRogueRot",
[72] = "CJCombatRogueRot",
[73] = "CJSubRogueRot",
[81] = "CJEleShamRot",
[82] = "CJEnhShamRot",
[91] = "CJAffLockRot",
[92] = "CJDemoLockRot",
[93] = "CJDestLockRot",
[101] = "CJArmsWarRot",
[102] = "CJFuryWarRot",
[103] = "CJProtWarRot"
};

cj_buffTable = {
[11] = "CJ_BloodBuffs",
[12] = "CJ_FrostBuffs",
[13] = "CJ_UnholyBuffs",
[21] = "CJ_BalanceBuffs",
[22] = "CJ_FeralBuffs",
[31] = "CJ_BMBuffs",
[32] = "CJ_MarksBuffs",
[33] = "CJ_SurvBuffs",
[41] = "CJ_ArcaneBuffs",
[42] = "CJ_FireMBuffs",
[43] = "CJ_FrostMBuffs",
[52] = "CJ_ProtBuffs",
[53] = "CJ_RetBuffs",
[61] = "CJ_DiscBuffs",
[63] = "CJ_ShadowBuffs",
[71] = "CJ_AssassinBuffs",
[72] = "CJ_CombatBuffs",
[73] = "CJ_SubtletyBuffs",
[81] = "CJ_EleBuffs",
[82] = "CJ_EnhanceBuffs",
[83] = "CJ_RestoBuffs",
[91] = "CJ_AffBuffs",
[92] = "CJ_DemoBuffs",
[93] = "CJ_DestroBuffs",
[101] = "CJ_ArmsBuffs",
[102] = "CJ_FuryBuffs",
[103] = "CJ_ProtBuffs"
};


cj_interruptBlacklist = {
	["High Priestess Kilnara"] = {[1] = "Shadow Bolt"},
	["Venomancer Mauri"] = {[1] = "Poison Bolt"},
	["Hex Lord Malacrass"] = {[1] = "Chain Lightning",[2] = "Mind Blast"},
	["Maloriak"] = {[1] = "Release Aberrations"},
	["Naz'jar Spiritmender"] = {[1] = "Wrath"},
	["Stonecore Rift Conjurer"] = {[1] = "Shadow Bolt"},
	["Temple Adept"] = {[1] = "Holy Smite"},
	["Twilight Portal Shaper"] = {[1] = "Shadow Bolt"},
	["Lesser Priest of Bethekk"] = {[1] = "Shadow Bolt"},
	["Stonecore Earthshaper"] = {[1] = "Lava Burst",[2] = "Ground Shock"}
};

cj_dispelBlacklist = {
	[1] = "Toxic Torment",
	[2] = "Burning Blood",
	[3] = "Frostburn Formula",
	[4] = "Blackout"
};

cj_bosslist = {
	[1] = "Admiral Ripsnarl",
	[2] = "Altairus",
	[3] = "Ammunae",
	[4] = "Anraphet",
	[5] = "Argaloth",
	[6] = "Asaad",
	[7] = "Ascendant Lord Obsidius",
	[8] = "Augh",
	[9] = "Beauty",
	[10] = "Chimaeron",
	[11] = "Commander Ulthok",
	[12] = "Corborus",
	[13] = "Corla, Herald of Twilight",
	[14] = "Drahga Shadowburner",
	[15] = "Earthrager Ptah",
	[16] = "Elementium Monstrosity",
	[17] = "Erudax",
	[18] = "Erunak Stonespeaker",
	[19] = "Foe Reaper 5000",
	[20] = "Forgemaster Throngus",
	[21] = "General Husam",
	[22] = "General Umbriss",
	[23] = "Glubtok",
	[24] = "Grand Vizier Ertan",
	[25] = "Halfus Wyrmbreaker",
	[25] = "Helix Gearbreaker",
	[26] = "High Priestess Azil",
	[28] = "High Prophet Barim",
	[29] = "Isiset",
	[30] = "Karsh Steelbender",
	[31] = "Lady Naz'jar",
	[32] = "Lockmaw",
	[33] = "Mindbender Ghur'sha",
	[34] = "Nefarian",
	[35] = "Ozruk",
	[36] = "Ozumat",
	[37] = "Rajh",
	[38] = "Rom'ogg Bonecrusher",
	[39] = "Setesh",
	[40] = "Siamat",
	[41] = "Slabhide",
	[42] = "Temple Guardian Anhuur",
	[43] = "Valiona",
	[44] = "Vanessa VanCleef",
	[45] = "Arcanotron",
	[46] = "Arion",
	[58] = "Atramedes",
	[49] = "Cho'gall",
	[50] = "Electron",
	[51] = "Magmatron",
	[52] = "Toxitron",
	[54] = "Feludius",
	[55] = "Ignacious",
	[56] = "Magmaw",
	[57] = "Maloriak",
	[58] = "Nezir",
	[59] = "Rohash",
	[60] = "Sinestra",
	[61] = "Terrastra",
	[62] = "Anshal",
	[63] = "Al'Akir",
	[64] = "Akil'zon",
	[65] = "Nalorakk",
	[66] = "Jan'alai",
	[67] = "Halazzi",
	[68] = "Hex Lord Malacrass",
	[69] = "Daakara",
	[70] = "High Priest Venoxis",
	[71] = "Bloodlord Mandokir",
	[72] = "Hazza'rah",
	[73] = "Renataki",
	[74] = "Wushoolay",
	[75] = "Gri'lek",
	[76] = "High Priestess Kilnara",
	[77] = "Zan'zil",
	[78] = "Jin'do the Godbreaker",
	[79] = "Raider's Training Dummy"
};

enrageEffectIDs = wipe(enrageEffectIDs or {})

for _, id in ipairs({
	134, 256, 772, 4146, 8599, 12880, 14201, 14202, 14203, 14204, 15061, 15716,
	18501, 19451, 19812, 22428, 23128, 23257, 23342, 24689, 25503, 26041, 26051,
	28371, 29131, 29340, 30485, 31540, 31915, 32714, 33958, 34392, 34670, 37605,
	37648, 37975, 38046, 38166, 38664, 39031, 39575, 40076, 40601, 41254, 41364,
	41447, 42705, 42745, 43139, 43292, 43664, 47399, 48138, 48142, 48193, 48391,
	48702, 49029, 50420, 50636, 51170, 51513, 51662, 52071, 52262, 52309, 52461,
	52470, 52537, 53361, 54356, 54427, 54475, 54508, 54781, 55285, 55462, 56646,
	56729, 56769, 57514, 57516, 57518, 57519, 57520, 57521, 57522, 57733, 58942,
	59465, 59694, 59697, 59707, 59828, 60075, 60177, 60430, 61369, 62071, 63147,
	63227, 63848, 66092, 66759, 67233, 67657, 67658, 67659, 68541, 69052, 70371,
	72143, 72146, 72147, 72148, 72203, 75998, 76100, 76487, 76691, 76816, 76862,
	77238, 78722, 78943, 79420, 80084, 80158, 80467, 81706, 81772, 82033, 82759,
	86736, 90045, 90872, 91668, 92946, 95436, 95459,
}) do enrageEffectIDs[id] = true end