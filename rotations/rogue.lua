local function CJ_Combo()
	return GetComboPoints("player","target");
end

-------------------------------------------
-----------Assassination-------------------
-------------------------------------------
local function CJ_AssassinBuffs()
	local hasMainHandEnchant,_,_, hasOffHandEnchant,_,_,hasThrownEnchant,_,_ = GetWeaponEnchantInfo()
	
	if not hasMainHandEnchant then
		RunMacroText("/use Instant Poison;/use 16");
		return true;
	end
	
	if not hasOffHandEnchant then
		RunMacroText("/use Deadly Poison;/use 17");
		return true;
	end
	
	if not hasThrownEnchant then
		RunMacroText("/use Deadly Poison;/use 18");
		return true;
	end
	
	return false
end

function CJAssRogueRot()
	CJ_Interrupt("Kick");
	
	if CJ_HB("Stealth") then StopAttack() return else StartAttack() return end
	if not CJ_GCD() then return end
	
	--if CJ_AssassinBuffs() then return end
	
	if AmIFacing == false then return end
	
	if IsSpellInRange("Eviscerate") == 0 then return end
	
	if AmIBehind == true and CJ_HB("Stealth") then
		if CJ_Cast("Garrote") then return end
	end
	
	if CJ_Combo() >= 1 and not CJ_HB("Slice and Dice") then
		if CJ_Cast("Slice and Dice") then return end
	end
	
	if CJ_Combo() == 5 and not CJ_HD("Rupture") then
		if CJ_Cast("Rupture") then return end
	end
	
	if CJ_Combo() >= 4 and not CJ_HB("Envenom") then
		if CJ_Cast("Envenom") then return end
	end
	
	if CJ_Combo() >= 4 and UnitPower("player") > 90 then
		if CJ_Cast("Envenom") then return end
	end
	
	if CJ_Combo() >= 2 and CJ_BTR("Slice and Dice") < 3 then
		if CJ_Cast("Envenom") then return end
	end
	
	if CJ_HP("target") < 35 and CJ_Combo() < 5 and AmIBehind == true then
		if CJ_Cast("Backstab") then return end
	end
	
	if CJ_Combo() < 4 and CJ_HP("target") >= 35 then
		if CJ_Cast("Mutilate") then return end
	end
	
	if cj_cooldowns then
		if CJ_IsBoss() and UnitPower("player") > 50 then
			if CJ_Cast("Vanish") then return end
		end
	end
end

-------------------------------------
-----------Combat--------------------
-------------------------------------
local function CJ_CombatBuffs()
	local hasMainHandEnchant,_,_, hasOffHandEnchant,_,_,hasThrownEnchant,_,_ = GetWeaponEnchantInfo()
	
	if not hasMainHandEnchant then
		RunMacroText("/use Instant Poison;/use 16");
		return true;
	end
	
	if not hasOffHandEnchant then
		RunMacroText("/use Deadly Poison;/use 17");
		return true;
	end
	
	if not hasThrownEnchant then
		RunMacroText("/use Wound Poison;/use 18");
		return true;
	end
	
	return false
end

function CJCombatRogueRot()
	CJ_Interrupt("Kick")
	
	if CJ_HB("Stealth") then StopAttack() return else StartAttack() return end
	if AmIFacing == false then return end
	if not CJ_GCD() then return end
	
	if IsSpellInRange("Eviscerate") == 0 then return end
	
	if CJ_Combo() >= 1 and not CJ_HB("Slice and Dice") then
		if CJ_Cast("Slice and Dice") then return end
	end
	
	if CJ_HB("Slice and Dice") and CJ_BTR("Slice and Dice") < 2 and CJ_Combo() >= 1 then
		if CJ_Cast("Slice and Dice") then return end
	end
	
	if cj_cooldowns then
		if UnitPower("player") < 35 and CJ_BTR("Slice and Dice") > 4 and not CJ_HB("Adrenaline Rush") then
			if CJ_Cast("Killing Spree") then return end
		end
		
		if UnitPower("player") < 35 then
			if CJ_Cast("Adrenaline Rush") then return end
		end
	end
	
	if CJ_Combo() == 5 and CJ_BS("Bandit's Guile") >= 12 then
		if CJ_Cast("Eviscerate") then return end
	end
	
	if CJ_Combo() == 5 and not CJ_HD("Rupture") and CJ_HP("target") > 5 then
		if CJ_Cast("Rupture") then return end
	end
	
	if CJ_Combo() == 5 then
		if CJ_Cast("Eviscerate") then return end
	end
	
	if CJ_Combo() == 4 and not CJ_HD("Revealing Strike") then
		if CJ_Cast("Revealing Strike") then return end
	end
	
	if CJ_Combo() < 5 then
		if CJ_Cast("Sinister Strike") then return end
	end
end

-------------------------------------
-----------Subtelty------------------
-------------------------------------
local function CJ_SubtletyBuffs()
	local hasMainHandEnchant,_,_, hasOffHandEnchant,_,_,hasThrownEnchant,_,_ = GetWeaponEnchantInfo()
	
	if not hasMainHandEnchant then
		RunMacroText("/use Instant Poison;/use 16");
		return true;
	end
	
	if not hasOffHandEnchant then
		RunMacroText("/use Deadly Poison;/use 17");
		return true;
	end
	
	if not hasThrownEnchant then
		RunMacroText("/use Wound Poison;/use 18");
		return true;
	end
	
	return false
end

function CJSubRogueRot()
	CJ_Interrupt("Kick")
	
	if CJ_HB("Stealth") then StopAttack() return else StartAttack() return end
	if AmIFacing == false then return end
	if not CJ_GCD() then return end
	
	if CJ_HB("Stealth") or CJ_HB("Shadow Dance") and IsSpellInRange("Shadowstep") == 1 then
		CJ_Cast("Shadowstep")
	end
	
	if IsSpellInRange("Eviscerate") == 0 then return end
	if cj_cooldowns then
		if CJ_CD("Shadow Dance") == 0 and CJ_Combo() < 5 and not CJ_HB("Stealth") then
			if UnitPower("player") < 85 then
				return
			else
				CJ_Cast("Shadow Dance")
			end
		end
		
		if CJ_CD("Vanish") == 0 and CJ_Combo() <= 1 and CJ_CD("Shadowstep") == 0 
			and not CJ_HB("Shadow Dance") and not CJ_HB("Master of Subtlety") and not CJ_HD("Find Weakness") then
			if UnitPower("player") < 60 then
				return
			else
				CJ_Cast("Vanish")
				StopAttack();
			end
		end
		
		if CJ_CD("Vanish") > 60 and not CJ_HB("Stealth") then
			CJ_Cast("Preparation")
		end
	end	
	
	if CJ_Combo() <= 2 or (CJ_Combo() <= 3 and GetTime() - cj_hatproc > 1.75) then
		CJ_Cast("Premeditation")
	end
	
	if CJ_Combo() <= 4 then
		if CJ_Cast("Ambush") then return end
	end
	
	if CJ_BTR("Slice and Dice") < 3 and CJ_Combo() == 5 then
		if CJ_Cast("Slice and Dice") then return end
	end
	
	if not CJ_HD("Rupture") and CJ_Combo() == 5 then
		if CJ_Cast("Rupture") then return end
	end
	
	if CJ_Combo() == 5 and CJ_BTR("Recuperate") < 3 then
		if CJ_Cast("Recuperate") then return end
	end
	
	if CJ_Combo() == 5 and CJ_DTR("Rupture") > 1  then
		if CJ_Cast("Eviscerate") then return end
	end
	
	if AmIBehind == true and CJ_Combo() < 3 and UnitPower("player") > 60 then
		if CJ_Cast("Backstab") then return end
	end
	
	if GetTime() - cj_hatproc > 1.75 and AmIBehind == true then
		if CJ_Cast("Backstab") then return end
	end
	
	if AmIBehind == true and CJ_Combo() < 5 and UnitPower("player") > 80 and GetTime() - cj_hatproc <= 0 then
		if CJ_Cast("Backstab") then return end
	end
	
	if AmIBehind == false and not CJ_HD("Hemorrhage") then
		if CJ_Cast("Hemorrhage") then return end
	end
	
	if AmIBehind == false then
		if CJ_Cast("Sinister Strike") then return end
	end
end