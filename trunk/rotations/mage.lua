--Mage Rotations

-------------------------------------------
-----------Arcane--------------------------
-------------------------------------------

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

local function CJArcMageRot()
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
	
	if CJCooldown("Arcane Power") == 0 and CJCooldown("Evocation") < 40 
	and CJ_GetBuffInfo("player","Arcane Blast") == 4 and CJHealthPercent("target") < 10 then
		CastSpell("Arcane Power");
	end
	
	if (GetItemCount("Mana Gem",false,false) == 0 and CJCooldown("Evocation") < 44 
	and CJHealthPercent("target") > 10) then
		CastSpell("Conjure Mana Gem");
		return;
		
end