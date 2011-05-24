-- Warlock Rotations

-----------------------------
---------Affliction----------
-----------------------------

local lastuacast = 0;
local lastpetcast = 0;

local function CJCheckAffBuffs()
	--Cast Dark Intent yourself!
	if not CJ_HasBuff("player","Fel Armor") then
		CastSpell("Fel Armor");
		return true;
	end
	
	if not UnitExists("pet") or UnitCreatureFamily("pet") ~= "Felhunter" and GetTime() - lastpetcast > 15 then
		CastSpell("Summon Felhunter");
		lastpetcast = GetTime();
		return true;
	end
	
	return false;
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
	
	if not IsPetAttackActive() == nil then PetAttack() return end
	
	if not CJ_GCD() then return end; -- Check for GCD
	if not CJ_CheckMyCast() then return end;
	if CJCheckAffBuffs() then return end; -- Check our buffs
	if AmIFacing == "false" then return end;
	
	if IsSpellInRange("Fel Flame") == 0 then return end;
	
	if GetUnitSpeed("player") > 0 then
		if select(2,CJ_DebuffInfo("target","Corruption")) < 2 then
			CastSpell("Corruption");
			return;
		end
	
		if not CJ_HasDebuff("target","Bane of Doom") then
			CastSpell("Bane of Doom");
			return;
		end
	
		CastSpell("Fel Flame");
		return
	end
	
	if not CJ_HasDebuff("target","Curse of the Elements") then
		CastSpell("Curse of the Elements");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Corruption")) > 0 and select(2,CJ_DebuffInfo("target","Unstable Affliction")) > 0 
		and select(2,CJ_DebuffInfo("target","Bane of Doom")) > 0 and select(2,CJ_DebuffInfo("target","Haunt")) > 0 then
		CastSpell("Demon Soul");
	end
	
	if select(2,CJ_DebuffInfo("target","Corruption")) < 2 then
		CastSpell("Corruption");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Unstable Affliction")) < 2.5 and GetTime() - lastuacast > 2.5 then
		CastSpell("Unstable Affliction");
		lastuacast = GetTime();
		return;
	end
	
	if not CJ_HasDebuff("target","Bane of Doom") then
		CastSpell("Bane of Doom");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Haunt")) < 2.5 and lastspell ~= "Haunt" then
		CastSpell("Haunt");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Unstable Affliction")) < 8 and CJ_HasBuff("player","Fel Spark") then
		CastSpell("Fel Flame")
		return;
	end
	
	if CJHealthPercent("target") <= 25 then
		CastSpell("Drain Soul");
		return;
	end
	
	if CJCooldown("Shadowflame") == 0 then
		CastSpell("Shadowflame");
		return;
	end
	
	if CJManaPercent("player") <= 35 then
		CastSpell("Life Tap");
		return;
	end
	
	if CJCooldown("Soulburn") == 0 and not CJ_HasBuff("player","Demon Soul") then
		CastSpell("Soulburn");
		return;
	end
	
	if CJ_HasBuff("player","Soulburn") and CJCooldown("Soul Fire") == 0 then
		CastSpell("Soul Fire");
		return;
	end
	
	CastSpell("Shadow Bolt");
	return;
end

-----------------------------
---------Destruction----------
-----------------------------

local function CJCheckDestroBuffs()
	if not CJ_HasBuff("player","Fel Armor") then
		CastSpell("Fel Armor");
		return true;
	end
	
	if not UnitExists("pet") or UnitCreatureFamily("pet") ~= "Imp" and GetTime() - lastpetcast > 15 then
		CastSpell("Summon Felhunter");
		lastpetcast = GetTime();
		return true;
	end
	
	return false;
end

function CJDestLockRot()
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
	if CJCheckDestroBuffs() then return end; -- Check our buffs
	if AmIFacing == "false" then return end;
	
	if IsSpellInRange("Fel Flame") == 0 then return end;
	
	if GetUnitSpeed("player") > 0 then
		if select(2,CJ_DebuffInfo("target","Corruption")) < 2 then
			CastSpell("Corruption");
			return;
		end
		
		if not CJ_HasDebuff("target","Bane of Doom") then
			CastSpell("Bane of Doom");
			return;
		end
	
		CastSpell("Fel Flame");
		return
	end
	
	if CJCooldown("Demon Soul") == 0 then
		CastSpell("Demon Soul");
	end
	
	if CJCooldown("Soulburn") == 0 then
		CastSpell("SoulBurn");
	end
	
	if CJCooldown("Soul Fire") == 0 and CJ_HasBuff("player","Soulburn") then
		CastSpell("Soul Fire");
		return;
	end
	
	if CJ_HasBuff("player","Fel Spark") and select(2,CJ_DebuffInfo("target","Immolate")) < 8 and CJ_HasDebuff("target","Immolate") then
		CastSpell("Fel Flame");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Immolate")) < 3.5 then
		CastSpell("Immolate");
		return;
	end
	
	if CJCooldown("Conflagrate") == 0 then
		CastSpell("Conflagrate");
		return;
	end
	
	if not CJ_HasDebuff("target","Bane of Doom") then
		CastSpell("Bane of Doom");
		return;
	end 
	
	if select(2,CJ_DebuffInfo("target","Corruption")) < 2 then
		CastSpell("Corruption");
		return;
	end
	
	if CJCooldown("Shadowflame") == 0 then
		CastSpell("Shadowflame");
		return;
	end
	
	if CJ_HasBuff("player","Empowered Imp") then
		if not CJ_HasBuff("player","Improved Soul Fire") then
			CastSpell("Soul Fire");
			return;
		else
			if select(2,CJ_BuffInfo("player","Empowered Imp")) < (select(2,CJ_BuffInfo("player","Improved Soul Fire")) + .75) then
				CastSpell("Soul Fire");
				return;
			end
		end
	end
	
	if CJCooldown("Chaos Bolt") == 0 then
		CastSpell("Chaos Bolt");
		return;
	end
	
	if CJCooldown("Soul Fire") == 0 then
		if select(2,CJ_BuffInfo("player","Improved Soul Fire")) < (select(7,GetSpellInfo("Soul Fire")) + .75 
		+ select(7,GetSpellInfo("Incinerate")) + 1.3) then
			CastSpell("Soul Fire");
			return;
		end
	end
	
	if CJHealthPercent("target") < 20 and CJCooldown("Shadowburn") == 0 then
		CastSpell("Shadowburn");
		return;
	end
	
	CastSpell("Incinerate");
	return;
end