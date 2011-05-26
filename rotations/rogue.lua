--MagRogue Rotations

-------------------------------------------
-----------Assassination-------------------
-------------------------------------------

local opener = false;

local function CJ_Combo()
	return GetComboPoints("player","target");
end

local function CJ_CheckAssasinationBuffs()
	local hasMainHandEnchant,_,_, hasOffHandEnchant,_,_,hasThrownEnchant,_,_ = GetWeaponEnchantInfo()
	
	if not hasMainHandEnchant then
		RunMacroText("/cast Instant Poison;/use 16");
		return true;
	end
	
	if not hasOffHandEnchant then
		RunMacroText("/cast Deadly Poison;/use 17");
		return true;
	end
	
	if not hasThrownEnchant then
		RunMacroText("/cast Deadly Poison;/use 18");
		return true;
	end
	
	return false
end

function CJAssRogueRot()
	if cj_interruptmode and CJCooldown("Kick") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Kick",thing) then
				CastSpellByName("Kick",thing);
			end
		end
	end
	
	if CJ_HasBuff("player","Stealth") then StopAttack() else StartAttack() end;
	
	if not CJ_GCD then return end;
	
	if CJ_CheckAssasinationBuffs() then return end;
	if AmIFacing == "false" then return end;
	
	if AmIBehind == "true" and CJ_HasBuff("player","Stealth") then
		CastSpell("Garrote");
		opener = true;
		return;
	end
	
	if opener and CJ_Combo() == 3 then
		opener = false;
	end
	
	if opener then
		CastSpell("Mutilate");
		return;
	end
	
	
	
	if CJ_Combo() >= 1 and not CJ_HasBuff("player","Slice and Dice") then
		CastSpell("Slice and Dice");
		return;
	end
	
	if CJ_Combo() == 5 and not CJ_HasDebuff("target","Rupture") then
		CastSpell("Rupture");
		return;
	end
	
	if CJ_Combo() >= 4 and not CJ_HasDebuff("target","Envenom") then
		CastSpell("Envenom");
		return;
	end
	
	if CJ_Combo() >= 4 and UnitPower("player") > 90 then
		CastSpell("Envenom");
		return;
	end
	
	if CJ_Combo() >= 2 and select(2,CJ_BuffInfo("player","Slice and Dice")) < 3 then
		CastSpell("Envenom");
		return;
	end
	
	if CJHealthPercent("target") < 35 and CJ_Combo() < 5 and AmIBehind == "true" then
		CastSpell("Backstab");
		return;
	end
	
	if CJ_Combo() < 4 and CJHealthPercent("target") >= 35 then
		CastSpell("Mutilate");
		return;
	end
end

---------------------------------
---------Combat------------------
---------------------------------

local function CJ_CheckCombatBuffs()
	local hasMainHandEnchant,_,_, hasOffHandEnchant,_,_,hasThrownEnchant,_,_ = GetWeaponEnchantInfo()
	
	if not hasMainHandEnchant then
		RunMacroText("/cast Instant Poison;/use 16");
		return true;
	end
	
	if not hasOffHandEnchant then
		RunMacroText("/cast Deadly Poison;/use 17");
		return true;
	end
	
	if not hasThrownEnchant then
		RunMacroText("/cast Wound Poison;/use 18");
		return true;
	end
	
	return false
end

function CJCombatRogueRot()
	if cj_interruptmode and CJCooldown("Kick") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Kick",thing) then
				CastSpellByName("Kick",thing);
			end
		end
	end
	
	if CJ_HasBuff("player","Stealth") then StopAttack() else StartAttack() end;
	
	if not CJ_GCD then return end;
	
	if CJ_CheckCombatBuffs() then return end;
	if AmIFacing == "false" then return end;
	
	if not CJ_HasBuff("player","Slice and Dice") and CJ_Combo() >= 1 then
		CastSpell("Slice and Dice");
		return;
	end
	
	if CJ_HasBuff("player","Slice and Dice") and CJ_Combo() >= 1 and select(2,CJ_BuffInfo("player","Slice and Dice")) < 2 then
		CastSpell("Slice and Dice");
		return;
	end
	
	if CJ_Combo() == 5 and CJ_DebuffInfo("target","Bandit's Guile") >= 12 then
		CastSpell("Eviscerate");
		return;
	end
	
	if not CJ_HasDebuff("target","Rupture") and CJ_Combo() == 5 then
		CastSpell("Rupture");
		return;
	end
	
	if not CJ_HasDebuff("target","Revealing Strike") and CJ_Combo() == 4 then
		CastSpell("Revealing Strike");
		return;
	end
	
	if CJ_Combo() < 5 then CastSpell("Sinister Strike") return end;
end

-------------------------------------
------------Subtlety-----------------
-------------------------------------

local function CJ_CheckSubtletyBuffs()
	local hasMainHandEnchant,_,_, hasOffHandEnchant,_,_,hasThrownEnchant,_,_ = GetWeaponEnchantInfo()
	
	if not hasMainHandEnchant then
		RunMacroText("/cast Instant Poison;/use 16");
		return true;
	end
	
	if not hasOffHandEnchant then
		RunMacroText("/cast Deadly Poison;/use 17");
		return true;
	end
	
	if not hasThrownEnchant then
		RunMacroText("/cast Wound Poison;/use 18");
		return true;
	end
	
	return false
end

function CJSubRogueRot()
	
end