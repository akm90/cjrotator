--Mage Rotations

-------------------------------------------
-----------Arcane--------------------------
-------------------------------------------
local function CJ_ArcaneBuffs()
	if not CJ_HB("Arcane Brilliance") then
		if CJ_Cast("Arcane Brilliance") then return true end;
	end
	
	if not CJ_HB("Mage Armor") then
		if CJ_Cast("Mage Armor") then return true end;
	end
	
	if GetItemCount(36799,false,true) == 0 then
		if UnitAffectingCombat("player") == nil then
			if CJ_Cast("Conjure Mana Gem") then return end;
		else
			if CJ_IsBoss() then
				if CJ_Cast("Conjure Mana Gem") then return end;
			end
		end
	end
	return false;
end

function CJArcMageRot()
	if cj_decurseself then
		if CJ_DecurseSelf() then return end
	end
	
	if cj_decurseparty then
		if CJ_DecurseAll() then return end
	end
	
	if CJ_OC() then StopAttack() return end
	if AmIFacing == false then return end
	CJ_Interrupt("Counterspell")
	
	if not CJ_GCD() then return end
	if CJ_ArcaneBuffs() then return end
	
	if IsSpellInRange("Arcane Blast") == 0 then return end
	
	if GetUnitSpeed("player") > 0 then
		if CJ_Cast("Arcane Barrage") then return end;
		if CJ_Cast("Fire Blast") then return end;
		if CJ_Cast("Ice Lance") then return end;
		return
	end
	
	if CJ_Casting() then return end;
	
	CJ_OffensiveDispel("Spellsteal");
	
	if UnitPowerMax("player") - UnitPower("player") > 12500 and GetItemCount(36799,false,true) > 0 and GetItemCooldown(36799) == 0 then
		UseItemByName(36799);
	end
	
	if CJ_IsRaidBoss() then
		if cj_cooldowns then		
			if (CJ_CD("Evocation") > 0 and CJ_CD("Evocaton") < 40 and CJ_SDS("Arcane Blast") == 4) or CJ_HP("target") < 15 then
				CJ_Cast("Arcane Power");
			end
	
			if CJ_HB("Arcane Power") or (CJ_CD("Arcane Power") > 20 and CJ_HP("target") > 10) then
				CJ_Cast("Mirror Image");
			end
		end
		
		if CJ_Cast("Presence of Mind") then CJ_Cast("Arcane Blast") return end;
		
		if cj_orbspells then
			if CJ_Cast("Flame Orb") then return end
		end
		
		if CJ_HP("target") < 15 and CJ_MP("player") > 4 then
			if CJ_Cast("Arcane Blast") then return end;
		end
		
		if CJ_CD("Evocation") < 40 and CJ_MP("player") > 26 then
			if CJ_Cast("Arcane Blast") then return end;
		end
		
		if CJ_MP("player") <= 38 then
			if CJ_Cast("Evocation") then return end;
		end
		
		if CJ_SDS("Arcane Blast") < 4 then
			if CJ_Cast("Arcane Blast") then return end
		end
		
		if CJ_Cast("Arcane Missiles") then return end;
		if CJ_Cast("Arcane Barrage") then return end;
	else
		if cj_cooldowns then
			CJ_Cast("Arcane Power")
			CJ_Cast("Mirror Image")
		end
		
		if cj_orbspells then
			if CJ_Cast("Flame Orb") then return end
		end
		
		if CJ_HP("target") < 15 and CJ_MP("player") > 4 then
			if CJ_Cast("Arcane Blast") then return end;
		end
		
		if CJ_MP("player") <= 38 then
			if CJ_Cast("Evocation") then return end;
		end
		
		if CJ_SDS("Arcane Blast") < 4 or (CJ_MP("player") > 40 and CJ_CD("Evocation") == 0) then
			if CJ_Cast("Arcane Blast") then return end
		end
		
		if CJ_CD("Evocation") < 40 and CJ_MP("player") > 26 then
			if CJ_Cast("Arcane Blast") then return end
		end
		
		if CJ_Cast("Arcane Missiles") then return end;
		if CJ_Cast("Arcane Barrage") then return end;
	end
end

---------------------------------
-----------Fire------------------
---------------------------------
function CJFireMageRot()
	if cj_decurseself then
		if CJ_DecurseSelf() then return end
	end
	
	if cj_decurseparty then
		if CJ_DecurseAll() then return end
	end
	if CJ_OC() then StopAttack() return end
	if AmIFacing == false then return end
	CJ_Interrupt("Counterspell")
	
	if not CJ_GCD() then return end
	
	CJ_OffensiveDispel("Spellsteal")
	
	if not CJ_HB("Arcane Brilliance") then
		if CJ_Cast("Arcane Brilliance") then return true end;
	end
	
	if not (CJ_HB("Molten Armor") or CJ_HB("Mage Armor")) then
		if CJ_Cast("Molten Armor") then return end;
	end
	
	if CJ_HB("Mage Armor") and CJ_MP("player") > 60 then
		if CJ_Cast("Molten Armor") then return end;
	end
	
	if CJ_Casting() then return end;
	if GetItemCount(36799,false,true) == 0 then
		if UnitAffectingCombat("player") == nil then
			if CJ_Cast("Conjure Mana Gem") then return end;
		else
			if CJ_IsBoss() then
				if CJ_Cast("Conjure Mana Gem") then return end;
			end
		end
	end
	
	if UnitPowerMax("player") - UnitPower("player") > 12500 and GetItemCount(36799,false,true) > 0 and GetItemCooldown(36799) == 0  then
		UseItemByName(36799);
	end
	
	if IsSpellInRange("Fireball") == 0 then return end
	if GetUnitSpeed("player") > 0 then
		if not CJ_HB("Living Bomb") then
			if CJ_Cast("Living Bomb") then return end;
		end
		
		if CJ_Cast("Fire Blast") then return end;
		
		if CJ_Cast("Scorch") then return end;
		return
	end
	
	if cj_cooldowns then
		CJ_Cast("Mirror Image");
	end
	
	if CJ_HD("Living Bomb") and CJ_HD("Pyroblast") and CJ_HD("Ignite") and cj_cooldowns then
		CJ_Cast("Combustion");
	end
	
	if not CJ_OD("Shadow and Flames") and CJ_DTR("Critical Mass") < 6 then
		if CJ_Cast("Scorch") then return end;
	end
	
	if CJ_HB("Hot Streak") then
		if CJ_Cast("Pyroblast!") then return end
	end
	
	if cj_orbspells then
		if CJ_Cast("Flame Orb") then return end
	end
	
	if CJ_MP("player") <= 38 then
		if CJ_Cast("Evocation") then return end;
	end
	
	if CJ_MP("player") < 5 and not CJ_HB("Mage Armor") then
		if CJ_Cast("Mage Armor") then return end
	end
	
	if CJ_Cast("Fireball") then return end;
end

---------------------------------
-----------Frost-----------------
---------------------------------

function CJFrostMageRot()
	if cj_decurseself then
		if CJ_DecurseSelf() then return end
	end
	
	if cj_decurseparty then
		if CJ_DecurseAll() then return end
	end
	if CJ_OC() then StopAttack() return end
	if AmIFacing == false then return end
	CJ_Interrupt("Counterspell")
	
	if not CJ_GCD() then return end
	
	
	if not CJ_HB("Arcane Brilliance") then
		if CJ_Cast("Arcane Brilliance") then return true end;
	end
	
	if not (CJ_HB("Molten Armor") or CJ_HB("Mage Armor")) then
		if CJ_Cast("Molten Armor") then return end;
	end
	
	if CJ_HB("Mage Armor") and CJ_MP("player") > 60 then
		if CJ_Cast("Molten Armor") then return end;
	end
	
	if CJ_Casting() then return end;
	
	CJ_OffensiveDispel("Spellsteal");
	if GetItemCount(36799,false,true) == 0 then
		if UnitAffectingCombat("player") == nil then
			if CJ_Cast("Conjure Mana Gem") then return end;
		else
			if CJ_IsBoss() then
				if CJ_Cast("Conjure Mana Gem") then return end;
			end
		end
	end
	
	if UnitPowerMax("player") - UnitPower("player") > 12500 and GetItemCount(36799,false,true) > 0 and GetItemCooldown(36799) == 0  then
		UseItemByName(36799);
	end
	
	if IsSpellInRange("Frostbolt") == 0 then return end
	if GetUnitSpeed("player") > 0 then		
		if CJ_Cast("Fire Blast") then return end;
		
		if CJ_Cast("Ice Lance") then return end;
		return
	end
	
	if cj_orbspells then
		if CJ_Cast("Flame Orb") then return end
	end
	
	if CJ_CD("Deep Freeze") > 15 and CJ_CD("Icy Veins") > 30 and cj_cooldowns then
		CJ_Cast("Cold Snap")
	end
	
	if cj_cooldowns then
		CJ_Cast("Mirror Image")
		if not CJ_Hero() and not CJ_HB("Icy Veins") then
			CJ_Cast("Icy Veins");
		end
	end
	
	if CJ_Cast("Deep Freeze") then return end;
	
	if CJ_HB("Brain Freeze") and CJ_HB("Fingers of Frost") then
		if CJ_Cast("Frostfire Bolt") then return end;
	end
	
	if CJ_HB("Fingers of Frost") then
		if CJ_Cast("Ice Lance") then return end;
	end
	
	if CJ_MP("player") < 5 and not CJ_HB("Mage Armor") then
		if CJ_Cast("Mage Armor") then return end
	end
	
	if CJ_Cast("Frostbolt") then return end;
end