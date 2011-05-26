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
		return
	end
	
	if not hasOffHandEnchant then
		RunMacroText("/cast Deadly Poison;/use 17");
		return;
	end
	
	if not hasThrownEnchant then
		RunMacroText("/cast Deadly Poison;/use 18");
		return;
	end
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
	
	if AmIFacing == "false" then return end;
	
	if AmIBehind == "true" and CJ_HasBuff("player","Stealth") then
		CastSpell("Garrote");
		opener = true;
		return;
	end
	
	if opener then
		CastSpell("Mutilate");
		opener = false;
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