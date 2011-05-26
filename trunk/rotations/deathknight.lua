-- Death Knight Rotations

---------------------------------
---------Frost-------------------
---------------------------------

local function CJCheckFrostBuffs()
	--Only doing Seal...letting players handle Blessing
	if CJCooldown("Horn of Winter") == 0 and (not CJ_HasBuff("player","Horn of Winter") and not (CJ_HasBuff("player","Battle Shout") and not CJ_HasBuff("player","Strength of Earth Totem"))) then
		CastSpell("Horn of Winter");
		return
	end
	
	if GetShapeshiftForm() ~= 3 then
		CastShapeshiftForm(3);
		return;
	end
	return false;
end

local function CJRune(rune)
	return select(3,GetRuneCooldown(rune));
end

--1 Blood
--2 Unholy
--3 Frost
--4 Death
local function CJNumRune(rune)
	local count = 0;
	for i = 1, 6 do
		if GetRuneType(i) == rune then
			count = count + 1;
		end
	end
	
	return count
end

function CJFrostDKRot()
	if cj_interruptmode and CJCooldown("Mind Freeze") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Mind Freeze",thing) == 1 then
				CastSpellByName("Mind Freeze",thing);
			end
		end
	end
	
	StartAttack("target");
	
	if not CJ_GCD() then return end; -- Check for GCD
	if CJCheckFrostBuffs() then return end; -- Check our buffs
	
	if AmIFacing == "false" then return end;
	
	if CJCooldown("Pillar of Frost") == 0 then
		CastSpell("Pillar of Frost")
	end
	
	if cj_interruptmode and CJCooldown("Strangulate") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Strangulate",thing) == 1 then
				CastSpellByName("Strangulate",thing);
				return;
			end
		end
	end
	
	if CJ_Cooldown("
	
	if select(2,CJ_DebuffInfo("target","Frost Fever")) <= 2 or select(2,CJ_DebuffInfo("target","Blood Plague")) <= 2 and
		CJCooldown("Outbreak") == 0 then
		CastSpell("Outbreak");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Frost Fever")) < 2 and CJCooldown(49184) == 0  then
		CastSpell("Howling Blast");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Blood Plague")) < 2 and CJCooldown("Plague Strike") == 0 then
		CastSpell("Plague Strike");
		return;
	end
	
	if CJNumRune(3) == 2 and CJNumRune(2) == 2 and CJCooldown("Obliterate") == 0 then
		CastSpell("Obliterate");
		return;
	end
	
	if CJNumRune(4) == 2 and CJCooldown("Obliterate") == 0  then
		CastSpell("Obliterate");
		return;
	end
	
	if CJ_HasBuff("player","Killing Machine") and CJCooldown("Obliterate") == 0  then
		CastSpell("Obliterate");
		return;
	end
	
	if UnitPower("player") >= 95 and CJCooldown("Frost Strike") == 0 then
		CastSpell("Frost Strike");
		return;
	end
	
	if CJCooldown(49184) == 0 and CJ_HasBuff("player","Rime") then
		CastSpell("Howling Blast");
		return;
	end
	
	if CJCooldown(49184) == 0 and (CJNumRune(4) + CJNumRune(2) == 0) then
		CastSpell("Howling Blast");
		return;
	end
	
	if CJCooldown("Obliterate") == 0 then
		CastSpell("Obliterate");
		return;
	end
	
	if CJCooldown("Frost Strike") == 0 then
		CastSpell("Frost Strike");
		return;
	end
	
	if CJCooldown(49184) == 0 then
		CastSpell("Howling Blast");
		return;
	end
	
	if CJCooldown("Horn of Winter") == 0 then
		CastSpell("Horn of Winter");
		return;
	end
end