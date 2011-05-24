--Mage Rotations

-------------------------------------------
-----------Arcane--------------------------
-------------------------------------------
function CJ_IsBossMob()
	return (UnitClassification("target") == "worldboss");	
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
	
	if GetItemCount(36799,false,true) == 0 then
		CastSpell("Conjure Mana Gem");
		return true;
	end
	
	return false;
end

function CJArcMageRot()
	if cj_interruptmode and CJCooldown("Counterspell") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Counterspell",thing) then
				CastSpellByName("Counterspell",thing);
			end
		end
	end
	
	if not CJ_GCD() then return end; -- Check for GCD
	if CJ_CheckArcaneBuffs() then return end; -- Check our buffs
	if AmIFacing == "false" then return end;
	
	
	if GetUnitSpeed("player") > 0 then
		if IsSpellInRange("Arcane Barrage") == 0 then return end;
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
	if IsSpellInRange("Arcane Blast") == 0 then return end;
	
	if cj_purgemode == true then
		if CJ_OffensiveDispel() then
			CastSpell("Spellsteal");
			return;
		end
	end
	
	if CJCooldown("Arcane Power") == 0 and CJ_IsBossMob() then
		if CJHealthPercent("target") <= 12 then
			CastSpell("Arcane Power");
		end
	end
	
	if CJManaPercent("player") < 70 and GetItemCount(36799,false,true) > 0 then
		if GetItemCooldown(36799) == 0 then
			UseItemByName(36799);
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
		(not CJ_IsBossMob() and CJHealthPercent("target") < 40) then
		CastSpell("Arcane Blast");
		return;
	end
	
	if CJCooldown("Evocation") < 40 and CJManaPercent("player") > 26 and CJ_IsBossMob() then
		CastSpell("Arcane Blast");
		return;
	end
	
	if CJManaPercent("player") <= 40 and CJCooldown("Evocation") == 0 then
		CastSpell("Evocation");
		return
	end
	
	if CJ_DebuffInfo("player","Arcane Blast") < 4 then
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

-------------------------------------------
-----------Fire----------------------------
-------------------------------------------
local function CJ_CheckFireBuffs()
	if not CJ_HasBuff("player","Arcane Brilliance") then
		CastSpell("Arcane Brilliance");
		return true;
	end
	
	if not CJ_HasBuff("player","Mage Armor") and not CJ_HasBuff("player","Molten Armor") then
		CastSpell("Molten Armor");
		return true;
	end
	
	if CJ_HasBuff("player","Mage Armor") and CJManaPercent("player") > 60 then
		CastSpell("Molten Armor");
		return true;
	end
	
	if CJManaPercent("player") < 5 and not CJ_HasBuff("player","Mage Armor") then
		CastSpell("Mage Armor");
		return true;
	end
	
	if GetItemCount(36799,false,true) == 0 then
		CastSpell("Conjure Mana Gem");
		return true;
	end
	
	return false;
end

function CJFireMageRot()
	if cj_interruptmode and CJCooldown("Counterspell") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Counterspell",thing) then
				CastSpellByName("Counterspell",thing);
			end
		end
	end
	
	if not CJ_GCD() then return end; -- Check for GCD
	if CJ_CheckFireBuffs() then return end; -- Check our buffs
	if AmIFacing == "false" then return end;
	
	if not CJ_CheckMyCast() then return end;
	
	if cj_purgemode == true then
		if CJ_OffensiveDispel() then
			CastSpell("Spellsteal");
			return;
		end
	end
	
	if IsSpellInRange("Fireball") == 0 then return end;
	
	if UnitPowerMax("player") - UnitPower("player") > 12500 and GetItemCooldown(36799) == 0  then
		UseItemByName(36799);
	end
	
	if not CJ_HasOtherDebuff("target","Shadow and Flames") and select(2,CJ_DebuffInfo("target","Critical Mass") < 6) then
		CastSpell("Scorch");
		return;
	end
	
	if not CJ_HasDebuff("target","Living Bomb")then
		CastSpell("Living Bomb");
		return;
	end
	
	if CJ_HasBuff("player","Hot Streak") then
		CastSpell("Pyroblast!");
		return;
	end
	
	if CJ_Cooldown("Flame Orb") == 0 then
		CastSpell("Flame Orb");
		return;
	end
	
	if GetUnitSpeed("player") > 0 then
		CastSpell("Scorch");
		return;
	else
		CastSpell("Fireball");
		return;
	end
end

-------------------------------------------
-----------Frost----------------------------
-------------------------------------------
local function CJ_CheckFrostBuffs()
	if not CJ_HasBuff("player","Arcane Brilliance") then
		CastSpell("Arcane Brilliance");
		return true;
	end
	
	if not CJ_HasBuff("player","Mage Armor") and not CJ_HasBuff("Molten Armor") then
		CastSpell("Molten Armor");
		return true;
	end
	
	if CJ_HasBuff("player","Mage Armor") and CJManaPercent("player") > 60 then
		CastSpell("Molten Armor");
		return true;
	end
	
	if CJManaPercent("player") < 5 and not CJ_HasBuff("player","Mage Armor") then
		CastSpell("Mage Armor");
		return true;
	end
	
	if GetItemCount(36799,false,true) == 0 then
		CastSpell("Conjure Mana Gem");
		return true;
	end
	
	return false;
end

function CJFrostMageRot()
	if cj_interruptmode and CJCooldown("Counterspell") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Counterspell",thing) then
				CastSpellByName("Counterspell",thing);
			end
		end
	end
	
	if not CJ_GCD() then return end; -- Check for GCD
	if CJ_CheckFrostBuffs() then return end; -- Check our buffs
	if AmIFacing == "false" then return end;
	
	if not CJ_CheckMyCast() then return end;
	
	
	if cj_purgemode == true then
		if CJ_OffensiveDispel() then
			CastSpell("Spellsteal");
			return;
		end
	end
	if IsSpellInRange("Frostbolt") == 0 then return end;
	
	if GetUnitSpeed("player") > 0 then
		if CJCooldown("Fire Blast") == 0 then
			CastSpell("Fire Blast");
			return;
		end
		
		CastSpell("Ice Lance");
		return;
	end
	
	if UnitPowerMax("player") - UnitPower("player") > 12500 and GetItemCooldown(36799) == 0  then
		UseItemByName(36799);
	end
	
	if CJCooldown("Frostfire Orb") == 0 then
		CastSpell("Frostfire Orb");
		return;
	end
	
	if CJCooldown("Deep Freeze") == 0 and IsUsableSpell("Deep Freeze") then
		CastSpell("Deep Freeze");
		return;
	end
	
	if CJ_HasBuff("player","Brain Freeze") and CJ_HasBuff("Fingers of Frost") then
		CastSpell("Frostfire Bolt");
		return;
	end
	
	if CJ_BuffInfo("player","Fingers of Frost") > 1 then
		CastSpell("Ice Lance");
		return;
	end
	
	CastSpell("Frostbolt");
	return;
end

