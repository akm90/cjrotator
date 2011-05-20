--Mage Rotations

-------------------------------------------
-----------Arcane--------------------------
-------------------------------------------
local function CJ_IsBossMob()
	return ((UnitLevel("target") >= 87 or UnitLevel("target") < 0) and UnitIsPlusMob("target"));	
end

local function CJ_CheckArcaneBuffs()
	if not CJ_HasBuff("player","Arcane Brilliance") then
		CastSpell("Arcane Brilliance");
		return true;
	end
	
	if not CJ_HasBuff("player","Mage Armor") then
		CastSpell("Mage Armor");
		return true;
	end
	
	return false;
end

function CJArcMageRot()
	if cj_interruptmode and CJCooldown("Counterspell") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Counterspell",thing) and AmIFacing == "true" then
				CastSpellByName("Counterspell",thing);
			end
		end
	end
	
	if not CJ_GCD() then return end; -- Check for GCD
	if CJ_CheckArcaneBuffs() then return end; -- Check our buffs
	if AmIFacing == "false" then return end;
	
	if GetUnitSpeed("player") > 0 then
		if not IsSpellInRange("Arcane Barrage") then return end;
		if CJCooldown("Arcane Barrage") == 0 then
			CastSpell("Arcane Barrage");
			return;
		end
		
		if CJCooldown("Fire Blast") == 0 then
			CastSpell("Fire Blast");
			return;
		end
		
		if CJCooldown("Ice Lance") == 0 then
			CastSpell("Ice Lance");
			return;
		end
		return;
	end
	
	if not CJ_CheckMyCast() then return end;
	if not IsSpellInRange("Arcane Blast") then return end;
	if (GetItemCount("Mana Gem",false,false) == 0 and CJCooldown("Evocation") < 44 
		and (CJ_IsBossMob() and CJHealthPercent("target") > 10)) then
		CastSpell("Conjure Mana Gem");
		return;
	end
	
	if CJCooldown("Arcane Power") == 0 and CJ_IsBossMob() then
		if CJHealthPercent("target") <= 12 then
			CastSpell("Arcane Power");
		end
	end
	
	if CJManaPercent("player") < 70 and GetItemCount("Mana Gem",false,false) ~= 0 then
		if GetItemCooldown("Mana Gem") == 0 then
			UseItemByName("Mana Gem");
		end
	end
	
	if CJCooldown("Mirror Image") == 0 then
		if CJ_HasBuff("player","Arcane Power") or (CJCooldown("Arcane Power") > 20 and CJ_IsBossMob() and CJHealthPercent("target") > 5) then
			CastSpell("Mirror Image");
		end
	end
	
	if CJCooldown("Flame Orb") == 0 then
		CastSpell("Flame Orb");
		return;
	end
	
	if CJCooldown("Presence of Mind") == 0 then
		CastSpell("Presence of Mind");
		CastSpell("Arcane Blast");
		return;
	end
	
	if (CJ_IsBossMob() and CJHealthPercent("target") < 20 and CJManaPercent("player") > 4) or 
		(not CJ_IsBossMob("target") and CJHealthPercent("target") < 40) then
		CastSpell("Arcane Blast");
		return;
	end
	
	if CJCooldown("Evocation") < 40 and CJManaPercent("player") > 26 then
		CastSpell("Arcane Blast");
		return;
	end
	
	if CJManaPercent("player") <= 40 and (CJ_IsBossMob() and CJHealthPercent("target") > 10) and CJCooldown("Evocation") == 0 then
		CastSpell("Evocation");
		return
	end
	
	if CJ_BuffInfo("player","Arcane Blast") < 4 then
		CastSpell("Arcane Blast");
		return;
	end
	
	if IsUsableSpell("Arcane Missiles") then
		CastSpell("Arcane Missiles");
		return;
	end
	
	if CJCooldown("Arcane Barrage") == 0 then
		CastSpell("Arcane Barrage");
		return;
	end
end