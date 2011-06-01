--Warlock Rotations
local function cj_petspell(name)
   for i = 1, MAX_SKILLLINE_TABS do
      local n, _, o, num = GetSpellTabInfo(i);
      if not n then break; end
      for s = o + 1, o + num do
         if (name == GetSpellBookItemName(s,BOOKTYPE_PET)) then
            return s;
         end
      end
   end
   return 0;
end

local lastuacast = 0
local lastpetcast = 0;
local lastimmolatecast = 0;
local lasthauntcast = 0;
local soulswap = false;

-----------------------------
---------Affliction----------
-----------------------------
local function CJ_AffBuffs()
	if not CJ_HB("Fel Armor") then
		if CJ_Cast("Fel Armor") then return true end
	end
	
	if (not UnitExists("pet") or UnitCreatureFamily("pet") ~= "Felhunter") and (GetTime() - lastpetcast) > 15 then
		lastpetcast = GetTime();
		if CJ_Cast("Summon Felhunter") then return true end
	end
	return false
end

function CJAffLockRot()
	local hasFocus = false
	CJ_Interrupt("Spell Lock");
	
	if UnitExists("focus") and UnitCanAttack("player","focus") then
		hasFocus = true
	end
	
	if AmIFacing == "false" then return end;
	
	if not CJ_GCD() then return end;
	if CJ_Casting() then return end
	if CJ_AffBuffs() then return end;
	
	if IsSpellInRange("Fel Flame") == 0 then return end;
	
	if CJ_HB("Soul Swap") then
		if CJ_CastTarget("Soul Swap Exhale","focus") then return end;
	end
	
	if GetUnitSpeed("player") > 0 then
		if not CJ_HD("Curse of the Elements") and not CJ_HD("Jinx: Curse of the Elements") then
			if CJ_Cast("Curse of the Elements") then return end;
		end
		
		if CJ_DTR("Corruption") < 2 then
			if CJ_Cast("Corruption") then return end;
		end
		
		if hasFocus then
			if CJ_DTR("Bane of Agony") < 3 then
				if CJ_Cast("Bane of Agony") then return end;
			end
		else
			if not CJ_HD("Bane of Doom") then
				if CJ_Cast("Bane of Doom") then return end
			end
		end
		
		if CJ_Cast("Fel Flame") then return end
	end
	
	if not CJ_HD("Curse of the Elements") and not CJ_HD("Jinx: Curse of the Elements") then
		if CJ_Cast("Curse of the Elements") then return end;
	end
	
	if (CJ_DTR("Corruption") > 0 and CJ_DTR("Unstable Affliction") > 0 and CJ_DTR("Haunt") > 0 and 
	(CJ_DTR("Bane of Agony") > 0 or CJ_DTR("Bane of Doom") > 0)) and cj_cooldowns then
		CJ_Cast("Demon Soul");
	end
	
	if CJ_DTR("Corruption") < 2 then
		if CJ_Cast("Corruption") then return end
	end
	
	if (CJ_DTR("Unstable Affliction") < 3) and (GetTime() - lastuacast > 4) then
		if CJ_Cast("Unstable Affliction") then lastuacast = GetTime() return end
	end
	
	if hasFocus then
		if CJ_DTR("Bane of Agony") <  3 then
			if CJ_Cast("Bane of Agony") then return end;
		end
	else
		if not CJ_HD("Bane of Doom") then 
			if CJ_Cast("Bane of Doom") then return end;
		end
	end
	
	if CJ_DTR("Haunt") < 3 and (GetTime() - lasthauntcast > 4) then
		if CJ_Cast("Haunt") then lasthauntcast = GetTime() return end;
	end
	
	if hasFocus then
		if CJ_CastTarget("Soul Swap","target") then soulswap = true return end
	end
	
	if CJ_HB("Fel Spark") and CJ_DTR("Unstable Affliction") < 8 and CJ_HB("Unstable Affliction") then
		if CJ_Cast("Fel Flame") then return end;
	end
	
	if CJ_HP("target") < 25 then
		if CJ_Cast("Drain Soul") then return end
	end
	
	if PlayerToTarget < 10 then
		if CJ_Cast("Shadowflame") then return end;
	end
	
	if CJ_HB("Shadow Trance") then
		if CJ_Cast("Shadow Bolt") then return end
	end
	
	if not CJ_HB("Demon Soul: Felhunter") and cj_cooldowns then
		if CJ_Cast("Soulburn") then return end
	end
	
	if CJ_HB("Soulburn") then
		if CJ_Cast("Soul Fire") then return end
	end
	
	if CJ_Cast("Shadow Bolt") then return end
end