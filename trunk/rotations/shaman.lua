--Shaman Rotations

----------------------------------
-------- Enhance -----------------
----------------------------------

local function CJ_CheckEnhanceBuffs()
	local arg1,_,_,arg2 = GetWeaponEnchantInfo();
	
	if not arg1 then
		CastSpell("Windfury Weapon");
		return true;
	end
	
	if not arg2 then
		CastSpell("Flametongue Weapon");
		return true;
	end
	
	if not CJ_HasBuff("player","Lightning Shield") then
		CastSpell("Lightning Shield");
		return true;
	end
	
	return false;
end

function CJEnhShamRot()
	if cj_interruptmode and CJCooldown("Wind Shear") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Wind Shear",thing) then
				CastSpellByName("Wind Shear",thing);
			end
		end
	end

	StartAttack();
	
	if not CJ_GCD() then return end; -- Check for GCD
	if CJ_CheckEnhanceBuffs() then return end; -- Check our buffs
	if AmIFacing == "false" then return end;
	
	if cj_purgemode == true then
		if CJ_OffensiveDispel() then
			CastSpell("Purge");
			return;
		end
	end
	
	if IsSpellInRange("Lava Lash") == 0 and IsSpellInRange("Earth Shock") == 1 then
		if CJCooldown("Unleash Elements") == 0 then
			CastSpell("Unleash Elements");
			return;
		end
		
		if CJCooldown("Flame Shock") == 0 then
			if cj_aoemode and not CJ_HasDebuff("target","Flame Shock") then
				CastSpell("Flame Shock");
				return;
			elseif not cj_aoemode and CJ_HasBuff("player","Unleash Flame") then
				CastSpell("Flame Shock");
				return;
			end
		end
		
		if cj_aoemode and CJ_HasDebuff("target","Flame Shock") and CJCooldown("Fire Nova") == 0 then
			CastSpell("Fire Nova");
			return;
		end
		
		if CJ_BuffInfo("player","Maelstrom Weapon") == 5 then
			if CJHealthPercent("player") < 30 then
				CastSpell("Greater Healing Wave");
				return;
			end
			
			if cj_aoemode and CJCooldown("Chain Lightning") == 0 then
				CastSpell("Chain Lightning");
				return;
			elseif not cj_aoemode then
				CastSpell("Lightning Bolt");
				return;
			end
		end
		
		if CJCooldown("Earth Shock") == 0 then
			CastSpell("Earth Shock");
			return;
		end
		return;
	elseif IsSpellInRange("Lava Lash") == 1 then
		if CJ_UpdateTotems() then return end;
		
		if cj_aoemode and CJCooldown("Fire Nova") == 0 and CJ_HasDebuff("target","Flame Shock") then
			CastSpell("Fire Nova");
			return;
		end
		
		if CJCooldown("Lava Lash") == 0 then
			if cj_aoemode then
				CastSpell("Lava Lash");
				return;
			else
				if CJ_DebuffInfo("target","Searing Flames") >= 2 or select(2,GetTotemInfo(1)) == "Fire Elemental Totem"  then
					CastSpell("Lava Lash");
					return;
				end
			end
		end
		
		if CJCooldown("Flame Shock") == 0 then
			if cj_aoemode and not CJ_HasDebuff("target","Flame Shock") then
				CastSpell("Flame Shock");
				return;
			elseif not cj_aoemode and CJ_HasBuff("player","Unleash Flame") then
				CastSpell("Flame Shock");
				return;
			end
		end
		
		if CJ_BuffInfo("player","Maelstrom Weapon") == 5 then
			if CJHealthPercent("player") < 30 then
				CastSpell("Greater Healing Wave")
				return;
			end
		
			if cj_aoemode and CJCooldown("Chain Lightning") == 0 then
				CastSpell("Chain Lightning");
				return;
			elseif not cj_aoemode then
				CastSpell("Lightning Bolt");
				return;
			end
		end
		
		if CJCooldown("Unleash Elements") == 0 then
			CastSpell("Unleash Elements");
			return;
		end
		
		if CJCooldown("Stormstrike") == 0 then
			CastSpell("Stormstrike");
			return;
		end
		
		if CJCooldown("Earth Shock") == 0 and not CJ_HasBuff("player","Unleash Flame") then
			CastSpell("Earth Shock");
			return;
		end
	end			
end

------------------------------------------
-------------- Elemental -----------------
------------------------------------------

local function CJ_CheckEleBuffs()
	local arg1 = GetWeaponEnchantInfo();
	
	if not arg1 then
		CastSpell("Flametongue Weapon");
		return true;
	end
	
	if not CJ_HasBuff("player","Lightning Shield") then
		CastSpell("Lightning Shield");
		return true;
	end
	
	return false;
end

function CJEleShamRot()
	if cj_interruptmode and CJCooldown("Wind Shear") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Wind Shear",thing) then
				CastSpellByName("Wind Shear",thing);
			end
		end
	end

	if not CJ_GCD() then return end; -- Check for GCD
	if CJ_CheckEleBuffs() then return end; -- Check our buffs
	if AmIFacing == "false" then return end;
	
	if cj_purgemode == true then
		if CJ_OffensiveDispel() then
			CastSpell("Purge");
			return;
		end
	end
	
	if CJManaPercent("player") < 50 and CJCooldown("Thunderstorm") == 0 then
		CastSpell("Thunderstorm");
		return;
	end
	
	if GetUnitSpeed("player") > 0 and not CJ_HasBuff("player","Spiritwalker's Grace") then
		if CJ_CheckMyCast() then
			if CJ_UpdateTotems() then return end;
			if CJCooldown("Thunderstorm") == 0 then CastSpell("Thunderstorm"); return; end;
			if not IsSpellInRange("Unleash Elements") then return end;
			if CJCooldown("Unleash Elements") == 0 then CastSpell("Unleash Elements"); return; end;
			if CJCooldown("Flame Shock") == 0 then CastSpell("Flame Shock"); return; end;
				
			if cj_aoemode and CJCooldown("Fire Nova") == 0 and CJ_HasDebuff("target","Flame Shock") then
				CastSpell("Fire Nova");
				return;
			end
			
			if cj_aoemode and not CJ_HasDebuff("target","Flame Shock") then
				CastSpell("Flame Shock");
				return;
			elseif not cj_aoemode then
				CastSpell("Flame Shock");
				return;
			end
			
			
			if CJCooldown("Earth Shock") == 0 and CJ_BuffInfo("player","Lightning Shield") >= 7 then
				CastSpell("Earth Shock");
				return;
			end
		end
	else
		if CJ_CheckMyCast() then
			if CJ_UpdateTotems() then return end;
			
			if cj_aoemode and CJCooldown("Fire Nova") == 0 and CJ_HasDebuff("target","Flame Shock") then
				CastSpell("Fire Nova");
				return;
			end
			
			if CJCooldown("Earth Shock") == 0 and CJ_BuffInfo("player","Lightning Shield") >= 7 then
				CastSpell("Earth Shock");
				return;
			end
			
			if cj_aoemode and CJCooldown("Chain Lightning") == 0 then
				CastSpell("Chain Lightning");
				return;
			end
			
			if cj_aoemode and not CJ_HasDebuff("target","Flame Shock") then
				CastSpell("Flame Shock");
				return;
			elseif not cj_aoemode then
				CastSpell("Flame Shock");
				return;
			end
			
			if CJCooldown("Lava Burst") == 0 then
				CastSpell("Lava Burst");
				return;
			end
			
			CastSpell("Lightning Bolt");
		end
	end
end