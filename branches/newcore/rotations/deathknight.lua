--Death Knight Rotations

local function CJ_RCD(rune)
	return select(3,GetRuneCooldown(rune));
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
---------Frost-------------------
---------------------------------

local function CJ_FrostBuffs()		
	if not (CJ_HB("Horn of Winter") or CJ_HB("Battle Shout") or CJ_HB("Strength of Earth Totem")) then
		if CJ_Cast("Horn of Winter") then return true end;
	end
	
	if GetShapeshiftForm() ~= 3 then
		CastShapeshiftForm(3);
		return;
	end
	return false
end

function CJFrostDKRot()
	if UnitAffectingCombat("player") == 1 and cj_cooldowns then
		if CJ_HP("player") < 50 then
			CJ_Cast("Icebound Fortitude")
		end
	end
	
	if AmIFacing == "false" then return end;
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
local function CJ_BloodBuffs()		
	if not (CJ_HB("Horn of Winter") or CJ_HB("Battle Shout") or CJ_HB("Strength of Earth Totem")) then
		if CJ_Cast("Horn of Winter") then return true end;
	end
	
	if GetShapeshiftForm() ~= 1 then
		CastShapeshiftForm(1);
		return;
	end
	return false
end

function CJBloodDKRot()
	if UnitAffectingCombat("player") == 1 and cj_defensivecooldowns then
		if CJ_HP("player") < 50 then
			CJ_Cast("Icebound Fortitude")
		end
	end
	
	if AmIFacing == "false" then return end;
	CJ_Interrupt("Mind Freeze");
	
	StartAttack("target")
	
	if not CJ_GCD() then return end
	if CJ_FrostBuffs() then return end
end