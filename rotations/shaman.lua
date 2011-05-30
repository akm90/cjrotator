--Shaman Rotations
local is = "Wind Shear"
----------------------------------
-------- Enhance -----------------
----------------------------------

local function CJ_EnhanceBuffs()
	local arg1,_,_,arg2 = GetWeaponEnchantInfo();
	
	if not arg1 then
		if CJ_Cast("Windfury Weapon") then return true end
	end
	
	if not arg2 then
		if CJ_Cast("Flametongue Weapon") then return true end
	end
	
	if not CJ_HB("Lightning Shield") then
		if CJ_Cast("Lightning Shield") then return true end;
	end
	
	return false;
end

function CJEnhShamRot()
	if AmIFacing == "false" then return end
	CJ_Interrupt(is)
	
	StartAttack()
	
	if cj_cooldowns and UnitAffectingCombat("player") == 1 then
		if CJ_HP("player") < 50 then
			CJ_Cast("Shamanistic Rage");
		end
	end
	
	if not CJ_GCD() then return end;
	if CJ_EnhanceBuffs() then return end;
	
	if IsSpellInRange("Lava Lash") == 0 and IsSpellInRange("Earth Shock") == 1 then
		CJ_OffensiveDispel("Purge");
		if CJ_Cast("Unleash Elements") then return end;
		
		if cj_aoemode and not CJ_HD("Flame Shock") then
			if CJ_Cast("Flame Shock") then return end;
		elseif not cj_aoemode and CJ_HB("Unleash Flame") then
			if CJ_Cast("Flame Shock") then return end;
		end
		
		if cj_aoemode and CJ_HB("Flame Shock") then
			if CJ_Cast("Fire Nova") then return end;
		end
		
		if CJ_BS("Maelstrom Weapon") == 5 then
			if CJ_HP("player") < 30 then
				if CJ_Cast("Greater Healing Wave") then return end;
			end
			
			if cj_aoemode then
				if CJ_Cast("Chain Lightning") then return end;
			else
				if CJ_Cast("Lightning Bolt") then return end;
			end
		end
		
		if CJ_Cast("Earth Shock") then return end;
		return;
	elseif IsSpellInRange("Earth Shock") == 0 then return
	end
	
	if CJ_Totems() then return end;
	
	CJ_OffensiveDispel("Purge");
	
	if cj_cooldowns then
		if CJ_Cast("Spirit Wolves") then return end;
	end
	
	if cj_aoemode then
		if CJ_Cast("Lava Lash") then return end;
	else
		if CJ_DS("Searing Flames") >= 2 or select(2,GetTotemInfo(1)) == "Fire Elemental Totem" then
			if CJ_Cast("Lava Lash") then return end;
		end
	end
	
	if cj_aoemode and not CJ_HD("Flame Shock") then
		if CJ_Cast("Flame Shock") then return end;
	elseif not cj_aoemode and CJ_HB("Unleash Flame") then
		if CJ_Cast("Flame Shock") then return end;
	end
	
	if CJ_BS("Maelstrom Weapon") == 5 then
		if CJ_HP("player") < 30 then
			if CJ_Cast("Greater Healing Wave") then return end;
		end
		
		if cj_aoemode then
			if CJ_Cast("Chain Lightning") then return end;
		else
			if CJ_Cast("Lightning Bolt") then return end;
		end
	end
	
	if CJ_Cast("Unleash Elements") then return end;
	if CJ_Cast("Stormstrike") then return end;
	if not CJ_HB("Unleash Flames") then
		if CJ_Cast("Earth Shock") then return end;
	end
end

------------------------------------------
-------------- Elemental -----------------
------------------------------------------
local function CJ_EleBuffs()
	local arg1 = GetWeaponEnchantInfo();
	
	if not arg1 then
		if CJ_Cast("Flametongue Weapon") then return true end
	end
	
	if not CJ_HB("Lightning Shield") then
		if CJ_Cast("Lightning Shield") then return true end;
	end
	
	return false;
end

function CJEleShamRot()
	CJ_Interrupt(is)
	
	if cj_cooldowns and UnitAffectingCombat("player") == 1 then
		CJ_Cast("Elemental Mastery");
	end
	
	if not CJ_GCD() then return end
	if CJ_EleBuffs() then return end
	if CJ_Casting() then return end;
	if CJ_Totems() then return end;
	
	
	
	if UnitAffectingCombat("player") == 1 and CJ_MP("player") < 50 then
		if CJ_Cast("Thunderstorm") then return end;
	end		
	
	if IsSpellInRange("Lightning Bolt") == 0 then return end;
	
	CJ_OffensiveDispel("Purge");
	
	if GetUnitSpeed("player") > 0 and not CJ_HB("Spiritwalker's Grace") then
		if CJ_Cast("Thunderstorm") then return end;
		if CJ_Cast("Unleash Elements") then return end;
		if CJ_Cast("Flame Shock") then return end;
		
		if cj_aoemode and CJ_HD("Flame Shock") then
			if CJ_Cast("Fire Nova") then return end;
		end
		
		if cj_aoemode and not CJ_HD("Flame Shock") then
			if CJ_Cast("Flame Shock") then return end;
		elseif not cj_aoemode then
			if CJ_Cast("Flame Shock") then return end;
		end
		
		if CJ_BS("Lightning Shield") >= 7 then
			if CJ_Cast("Earth Shock") then return end;
		end
		return 
	end
	
	if CJ_Totems() then return end;
	if cj_aoemode and CJ_HD("Flame Shock") then
		if CJ_Cast("Fire Nova") then return end;
	end
	
	if CJ_BS("Lightning Shield") >= 7 then
		if CJ_Cast("Earth Shock") then return end;
	end
	
	if cj_aoemode then
		if CJ_Cast("Chain Lightning") then return end;
	end
	
	if cj_aoemode and not CJ_HD("Flame Shock") then
		if CJ_Cast("Flame Shock") then return end;
	elseif not cj_aoemode then
		if CJ_Cast("Flame Shock") then return end;
	end
	
	if CJ_Cast("Lava Burst") then return end;
	
	if CJ_Cast("Lightning Bolt") then return end;
		
end