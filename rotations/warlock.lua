-- Warlock Rotations

-----------------------------
---------Affliction----------
-----------------------------

local function CJCheckAffBuffs()
	--Cast Dark Intent yourself!
	if not CJ_HasBuff("player","Fel Armor") then
		CastSpell("Fel Armor");
		return true;
	end
	
	if not UnitExists("pet") or UnitCreatureFamily("pet") ~= "Felhunter" then
		CastSpell("Summon Felhunter");
		return true;
	end
	
	return false;
end


local lastspell;
local function CJAC(spell)
	lastspell = spell;
	CastSpell(spell);
end

function CJAffLockRot()
	if cj_interruptmode and GetSpellCooldown("Spell Lock","BOOKTYPE_PET") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Spell Lock",thing) and AmIFacing == "true" then
				CastSpellByName("Spell Lock",thing);
			end
		end
	end
	
	PetAttack();
	
	if not CJ_GCD() then return end; -- Check for GCD
	if not CJ_CheckMyCast() then return end;
	if CJCheckAffBuffs() then return end; -- Check our buffs
	if AmIFacing == "false" then return end;
	
	if IsSpellInRange("Fel Flame") == 0 then return end;
	
	if GetUnitSpeed("player") > 0 then
		CJAC("Fel Flame");
		return
	end
	
	if not CJ_HasDebuff("target","Curse of the Elements") then
		CastSpell("Curse of the Elements");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Corruption")) > 0 and select(2,CJ_DebuffInfo("target","Unstable Affliction")) > 0 
		and select(2,CJ_DebuffInfo("target","Bane of Doom")) > 0 and select(2,CJ_DebuffInfo("target","Haunt")) > 0 then
		CJAC("Demon Soul");
	end
	
	if select(2,CJ_DebuffInfo("target","Corruption")) < 2 then
		CJAC("Corruption");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Unstable Affliction")) < 2.5 and lastspell ~= "Unstable Affliction" then
		CJAC("Unstable Affliction");
		return;
	end
	
	if not CJ_HasDebuff("target","Bane of Doom") then
		CJAC("Bane of Doom");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Haunt")) < 2.5 and lastspell ~= "Haunt" then
		CJAC("Haunt");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Unstable Affliction")) < 8 and CJ_HasBuff("player","Fel Spark") then
		CJAC("Fel Flame")
		return;
	end
	
	if CJHealthPercent("target") <= 25 then
		CJAC("Drain Soul");
		return;
	end
	
	if CJCooldown("Shadowflame") == 0 then
		CJAC("Shadowflame");
		return;
	end
	
	if CJManaPercent("player") <= 35 then
		CJAC("Life Tap");
		return;
	end
	
	if CJCooldown("Soulburn") == 0 and not CJ_HasBuff("player","Demon Soul") then
		CJAC("Soulburn");
		return;
	end
	
	if CJ_HasBuff("player","Soulburn") and CJCooldown("Soulfire") == 0 then
		CJAC("Soul Fire");
		return;
	end
	
	CJAC("Shadow Bolt");
	return;
end