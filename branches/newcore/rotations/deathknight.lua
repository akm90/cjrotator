--Death Knight Rotations
local function CJ_RCD(rune)
	if GetRuneCooldown(rune) == 0 then 
		return 0
	else
		return select(2,GetRuneCooldown(rune)) - (GetTime() - GetRuneCooldown(rune))
	end
end

--1 Blood
--2 Unholy
--3 Frost
--4 Death
local function CJ_NR(rune)
	local count = 0;
	for i = 1, 6 do
		if GetRuneType(i) == rune and select(3,GetRuneCooldown(i)) == true then
			count = count + 1;
		end
	end
	
	return count
end

---------------------------------
---------Unholy-------------------
---------------------------------
local function CJ_UnholyBuffs()		
	if not (CJ_HB("Horn of Winter") or CJ_HB("Battle Shout") or CJ_HB("Strength of Earth Totem")) then
		if CJ_Cast("Horn of Winter") then return true end;
	end
	
	--[[if GetShapeshiftForm() ~= 3 then
		CastShapeshiftForm(3);
		return;
	end--]]
	return false
end

function CJUnholyDKRot()
	if UnitAffectingCombat("player") == 1 then
		if CJ_HP("player") < 50 then
			CJ_Cast("Icebound Fortitude")
		end
	end
	if CJ_OC() then StopAttack() return end
	if AmIFacing == false then return end;
	CJ_Interrupt("Mind Freeze");
	
	StartAttack("target")
	
	if not CJ_Hero() and cj_cooldowns and CJ_IsBoss() and CJ_HP("target") < 15 then
		CJ_Cast("Unholy Frenzy")
	end
	
	if not CJ_GCD() then return end
	if CJ_UnholyBuffs() then return end
	
	CJ_Interrupt("Strangulate");
	
	if IsSpellInRange("Outbreak") == 1 and IsSpellInRange("Frost Strike") == 0 then 
		if (CJ_DTR("Frost Fever") <= 2 or CJ_DTR("Blood Plague") <=2) then
			if CJ_Cast("Outbreak") then return end;
		end
	elseif IsSpellInRange("Outbreak") == 0 then return
	end
	
	if cj_deathstrike and CJ_HP("player") < 40 then
		if CJ_Cast("Death Strike") then return end
	end
	
	if (CJ_DTR("Frost Fever") <= 2 or CJ_DTR("Blood Plague") <=2) then
		if CJ_Cast("Outbreak") then return end;
	end
	
	if cj_cooldowns then
		if CJ_HB("Unholy Frenzy") or CJ_Hero() or CJ_IsBoss() and CJ_HP("target") >= 90 then
			if CJ_Cast("Summon Gargoyle") then return end
		end
	end
	
	if CJ_NR(4) == 4 or CJ_NR(2) == 2 then
		if CJ_Cast("Scourge Strike") then return end
	end
	
	if CJ_NR(1) == 2 and CJ_NR(3) == 2 then
		if CJ_Cast("Festering Strike") then return end
	end
	
	if UnitPower("player") >= 90 or CJ_HB("Sudden Doom") then
		if CJ_Cast("Death Coil") then return end
	end
	
	if CJ_Cast("Scourge Strike") then return end
	if CJ_Cast("Festering Strike") then return end
	if CJ_Cast("Death Coil") then return end
	
	if CJ_NR(2) == 0 and CJ_NR(4) == 3 then
		CJ_Cast("Blood Tap")
	end
	
	if cj_cooldowns and CJ_NR(2) == 0 then
		CJ_Cast("Empower Rune Weapon")
	end
	
	if CJ_Cast("Horn of Winter") then return end
end

---------------------------------
---------Frost-------------------
---------------------------------

local function CJ_FrostBuffs()		
	if not (CJ_HB("Horn of Winter") or CJ_HB("Battle Shout") or CJ_HB("Strength of Earth Totem")) then
		if CJ_Cast("Horn of Winter") then return true end;
	end
	
--[[	if GetShapeshiftForm() ~= 3 then
		CastShapeshiftForm(3);
		return;
	end--]]
	return false
end

function CJFrostDKRot()
	if UnitAffectingCombat("player") == 1 then
		if CJ_HP("player") < 50 then
			CJ_Cast("Icebound Fortitude")
		end
	end
	if CJ_OC() then StopAttack() return end
	if AmIFacing == false then return end;
	CJ_Interrupt("Mind Freeze");
	
	StartAttack("target")
	
	if not CJ_GCD() then return end
	if CJ_FrostBuffs() then return end
	
	CJ_Interrupt("Strangulate");
	
	if IsSpellInRange("Outbreak") == 1 and IsSpellInRange("Frost Strike") == 0 then 
		if (CJ_DTR("Frost Fever") <= 2 or CJ_DTR("Blood Plague") <=2) then
			if CJ_Cast("Outbreak") then return end;
		end
	elseif IsSpellInRange("Outbreak") == 0 then return
	end
	
	if cj_deathstrike and CJ_HP("player") < 40 then
		if CJ_Cast("Death Strike") then return end
	end
	
	if cj_cooldowns then
		CJ_Cast("Pillar of Frost");
	end
	
	if CJ_NR(4) ~= 2 then
		CJ_Cast("Blood Tap")
	end
	
	if (CJ_DTR("Frost Fever") <= 2 or CJ_DTR("Blood Plague") <=2) then
		if CJ_Cast("Outbreak") then return end;
	end
	
	if CJ_DTR("Frost Fever") <= 2 then
		if CJ_Cast("Howling Blast") then return end;
	end
	
	if CJ_DTR("Blood Plague") <= 2 then
		if CJ_Cast("Plague Strike") then return end;
	end
	
	if (CJ_NR(2) == 2 and CJ_NR(3) == 2) or CJ_NR(4) == 2 or CJ_HB("Killing Machine") then
		if CJ_Cast("Obliterate") then return end;
	end
	
	if CJ_HB("Killing Machine") and cj_cooldowns and CJ_HP("target") < 30 then
		CJ_Cast("Empower Rune Weapon");
	end
	
	if UnitPower("player") >= 95 then
		if CJ_Cast("Frost Strike") then return end;
	end
	
	if CJ_HB("Rime") or (CJ_NR(4) + CJ_NR(2) == 0) then
		if CJ_Cast("Howling Blast") then return end;
	end
	
	if CJ_Cast("Obliterate") then return end
	if CJ_Cast("Frost Strike") then return end;
	if CJ_Cast("Howling Blast") then return end;
	if CJ_Cast("Horn of Winter") then return end;
end

---------------------------------
---------Blood-------------------
---------------------------------
local outbreakcast = false;
local function CJ_BloodBuffs()		
	if not (CJ_HB("Horn of Winter") or CJ_HB("Battle Shout") or CJ_HB("Strength of Earth Totem")) then
		if CJ_Cast("Horn of Winter") then return true end;
	end
	
--[[	if GetShapeshiftForm() ~= 1 then
		CastShapeshiftForm(1);
		return;
	end--]]
	return false
end

function CJBloodDKRot()
	if UnitAffectingCombat("player") == 1 and cj_defensivecooldowns then
		if CJ_HP("player") < 70 then
			CJ_Cast("Vampiric Blood")
		end
		
		if CJ_HP("player") < 50 then
			CJ_Cast("Icebound Fortitude")
		end
		
		if CJ_HP("player") < 40 and not CJ_HB("Icebound Fortitude") and UnitPower("player") >= 80 then
			CJ_Cast("Lichborne")
		end
	end
	if CJ_OC() then StopAttack() return end
	if AmIFacing == false then return end;
	CJ_Interrupt("Mind Freeze");
	
	StartAttack("target")
	
	if not CJ_GCD() then return end
	if CJ_BloodBuffs() then return end
	
	if CJ_HB("Crimson Scourge") then
		if CJ_Cast("Blood Boil") then return end
	end
	
	if CJ_HB("Lichborne") then
		if CJ_CastTarget("Death Coil","player") then return end;
	end
	
	if cj_aoemode then
		if IsSpellInRange("Heart Strike") == 0 and IsSpellInRange("Outbreak") == 1 then
			if CJ_Cast("Outbreak") then outbreakcast = true return end
		elseif IsSpellInRange("Outbreak") == 0 then return
		end
		
		if cj_cooldowns then
			CJ_Cast("Dancing Rune Weapon")
		end
		
		if CJ_Cast("Outbreak") then outbreakcast = true return end;
		if CJ_HD("Blood Plague") and CJ_HD("Frost Fever") and outbreakcast then
			if CJ_Cast("Pestilence") then outbreakcast = false return end;
		end
		
		if CJ_Cast("Death Strike") then return end;
		
		if ((CJ_RCD(3) > 0 and CJ_RCD(4) > 0) or (CJ_RCD(5) > 0 and CJ_RCD(6) > 0)) then
			if CJ_Cast("Rune Strike") then return end;
		end
		
		if (CJ_RCD(1) == 0 and CJ_RCD(2) == 0) or (CJ_RCD(1) < 3 and CJ_RCD(2) == 0) or (CJ_RCD(1) == 0 and CJ_RCD(2) < 3) then
			if CJ_CD("Blood Tap") == 0 then
				CJ_Cast("Blood Tap")
				if CJ_Cast("Bone Shield") then return else if CJ_Cast("Icy Touch") then return end end
			elseif CJ_HP("player") < 90 and CJ_CD("Rune Tap") == 0 then
				if CJ_Cast("Rune Tap") then return end;
			else
				if CJ_Cast("Blood Boil") then return end;
			end
		end
		
		if CJ_Cast("Horn of Winter") then return end;
	else
		if IsSpellInRange("Heart Strike") == 0 and IsSpellInRange("Outbreak") == 1 then
			if CJ_Cast("Outbreak") then outbreakcast = true return end
		elseif IsSpellInRange("Outbreak") == 0 then return
		end
		
		if cj_cooldowns then
			CJ_Cast("Dancing Rune Weapon")
		end
		
		if CJ_Cast("Outbreak") then return end;
		
		if CJ_Cast("Death Strike") then return end;
		if CJ_Cast("Rune Strike") then return end
		
		if CJ_Cast("Horn of Winter") then return end;
		
		if (CJ_RCD(1) == 0 and CJ_RCD(2) == 0) or (CJ_RCD(1) < 3 and CJ_RCD(2) == 0) or (CJ_RCD(1) == 0 and CJ_RCD(2) < 3) then
			if CJ_Cast("Blood Tap") then
				if CJ_Cast("Bone Shield") then return else if CJ_Cast("Icy Touch") then return end end
			elseif CJ_HP("player") < 90 and CJ_CD("Rune Tap") == 0 then
				if CJ_Cast("Blood Tap") then return end;
			else
				if CJ_Cast("Heart Strike") then return end;
			end
		end
	end
end