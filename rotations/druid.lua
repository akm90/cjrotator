--Druid Rotations

local balancefourset = false;
local feralfourset = false;
local lastform = nil

local function CJ_Energy()
	return UnitPower("player",3);
end

local function CJ_Rage()
	return UnitPower("player",1);
end

local function CJ_Combo()
	return GetComboPoints("player","target");
end

-------------------------------
---------Bear Tank-------------
-------------------------------

local function swapBack()
	if lastform ~= nil then
		CastShapeshiftForm(lastForm);
		lastForm = nil;
	end
end

local function CJ_BearBuffs()
--[[	if not UnitAffectingCombat("player")==1 and (not CJ_HB("Mark of the Wild") and not CJ_HB("Blessing of Kings")) then
		if GetShapeshiftForm() ~= 0 then
			lastForm = GetShapeshiftForm();
			RunMacroText("/cancelform");
			return true;
		end
		if CJ_Cast("Mark of the Wild") then return true end;
	end --]]
	
	return false;
end

local function CJBearRotation()	
	StartAttack("target");
	
	if UnitAffectingCombat("player") == 1 and cj_defensivecooldowns then
		if CJ_HP("player") < 10 then
			CJ_Cast("Frenzied Regeneration");
		end
		
		if CJ_HP("player") < 30 then
			CJ_Cast("Survival Instincts");
		end
		
		if CJ_HP("player") < 70 then
			CJ_Cast("Barkskin");
		end
	end
	
	if AmIFacing == "false" then return end;
	
	CJ_Interrupt("Skull Bash(Bear Form)");
	
	if IsSpellInRange("Mangle") == 0 and IsSpellInRange("Faerie Fire (Feral)") == 1 then
		if cj_cooldowns then
			CJ_Cast("Enrage")
		end
		CJ_Cast("Feral Charge(Bear Form)");
		
		if not CJ_HD("Faerie Fire") or CJ_DS("Faerie Fire") < 3 and CJ_GCD() then
			if CJ_Cast("Faerie Fire (Feral)") then return end;
		end
		return;
	elseif IsSpellInRange("Faerie Fire (Feral)") == 0 then return
	end
	
	if cj_cooldowns then
		CJ_Cast("Berserk");
		CJ_Cast("Enrage");
	end
	
	if CJ_Rage() > 50 then
		if CJ_Cast("Maul(Bear Form)") then return end;
	end
	
	if not CJ_GCD() then return end;
	
	if CJ_BearBuffs() then return end;
	
	if cj_aoemode and not CJ_HB("Berserk") then
		if not CJ_HD("Demoralizing Roar") then
			if CJ_Cast("Demoralizing Roar(Bear Form)") then return end;
		end
		
		if CJ_Cast("Swipe(Bear Form") then return end;
		if CJ_Cast("Thrash(Bear Form") then return end;
	end
	
	if CJ_Cast("Mangle(Bear Form)") then return end;
	
	if not CJ_HD("Demoralizing Roar") then
		if CJ_Cast("Demoralizing Roar(Bear Form)") then return end;
	end
	
	if not CJ_HD("Lacerate") then
		if CJ_Cast("Lacerate(Bear Form)") then return end;
	end
	
	if CJ_Cast("Thrash(Bear Form)") then return end;
	
	if CJ_HD("Lacerate") and CJ_DTR("Lacerate") < 3 then
		if CJ_Cast("Lacerate(Bear Form)") then return end;
	end
	
	if (not CJ_HB("Pulverize") or CJ_BTR("Pulverize") < 3) and CJ_DS("Lacerate") == 3 then
		if CJ_Cast("Pulverize(Bear Form)") then return end;
	end
	
	if not (CJ_OD("Faerie Fire") or CJ_OD("Sunder Armor") or CJ_OD("Expose Armor")) or (CJ_DS("Faerie Fire") < 3 or CJ_DTR("Faerie Fire") < 4) then
		if CJ_Cast("Faerie Fire (Feral)") then return end;
	end
	
	if CJ_Cast("Lacerate(Bear Form") then return end;
end

------------------------
--------Cat Form--------
------------------------
local function CJ_KittyBuffs()
--[[	if not CJ_HB("Mark of the Wild") then
		if GetShapeshiftForm() ~= 0 then
			lastForm = GetShapeshiftForm();
			RunMacroText("/cancelform");
			return true;
		end
		if CJ_Cast("Mark of the Wild") then return true end;
	end--]]
	
	return false;
end

local function CJKittyRotation()
	if UnitAffectingCombat("player") == 1 and cj_druiddcd then
		if CJ_HP("player") < 70 then
			CJ_Cast("Barkskin");
		end
		
		if CJ_HP("player") < 30 then
			CJ_Cast("Survival Instincts");
		end
	end
	
	if not CJ_HB("Prowl") then StartAttack() else StopAttack() end;
	
	if AmIFacing == "false" then return end;
	
	CJ_Interrupt("Skull Bash(Cat Form)");
	
	if IsSpellInRange("Mangle(Cat Form)") == 0 and IsSpellInRange("Feral Charge(Cat Form)") == 1 then
		if CJ_Cast("Feral Charge(Cat Form)") then return end;
		if not CJ_HB("Prowl") and not CJ_HD("Faerie Fire") then
			if CJ_Cast("Faerie Fire (Feral)") then return end;
		end
	elseif IsSpellInRange("Faerie Fire (Feral)") == 0 then return
	end
	
	if CJ_Energy() < 26 then
		CJ_Cast("Tiger's Fury");
	end
	
	if not CJ_GCD() then return end;
	
	if CJ_KittyBuffs() then return end;
	
	if cj_aoemode and CJ_Energy() < 50 then return end;
	
	if cj_aoemode then
		if CJ_Cast("Swipe(Cat Form)") then return end;
	end
	
	if AmIBehind == "true" and CJ_HB("Prowl") and not CJ_HB("Stampede") then
		if CJ_Cast("Ravage") then return end
		if CJ_Cast("Ravage!") then return end
	end
	
	if feralfourset and CJ_BS("Strength of the Panther") < 3 then 
		if CJ_Cast("Mangle(Cat Form)") then return end;
	end
	
	if not (CJ_OD("Faerie Fire") or CJ_OD("Sunder Armor") or CJ_OD("Expose Armor")) or (CJ_DS("Faerie Fire") < 3 or CJ_DTR("Faerie Fire") < 4) then
		if CJ_Cast("Faerie Fire (Feral)") then return end;
	end
	
	if CJ_DTR("Mangle") <= 2 and (not CJ_OD("Trauma") and not CJ_OD("Hemorrhage")) then
		if CJ_Cast("Mangle(Cat Form)") then return end;
	end
	
	if CJ_HB("Stampede") and CJ_BTR("Stampede") < 4 then
		if CJ_Cast("Ravage") then return end
		if CJ_Cast("Ravage!") then return end
	end
	
	if cj_cooldowns and CJ_Energy() < 50 and not CJ_HB("Tiger's Fury") and CJ_CD("Tiger's Fury")  > 15 then
		CJ_Cast("Berserk")
	end
	
	if CJ_HP("target") < 25 and CJ_Combo() >= 1 and CJ_HD("Rip") and CJ_DTR("Rip") < 4 then
		if CJ_Cast("Ferocious Bite(Cat Form)") then return end;
	end
	
	if CJ_Combo() == 5 and CJ_HD("Rip") and CJ_HP("target") < 25 then
		if CJ_Cast("Ferocious Bite(Cat Form)") then return end;
	end
	
	if CJ_Combo() == 5 and CJ_DTR("Rip") < 3.5 then
		if CJ_Cast("Rip(Cat Form)") then return end;
	end
	
	if CJ_HB("Tiger's Fury") and not CJ_HD("Rake") then
		if CJ_Cast("Rake(Cat Form)") then return end;
	end
	
	if CJ_DTR("Rake") < 3 and (CJ_HB("Berserk") or CJ_Energy() >= 71 or (CJ_DTR("Rake") <= CJ_CD("Tiger's Fury") + .8)) then
		if CJ_Cast("Rake(Cat Form)") then return end;
	end
	
	
	if not CJ_HD("Rake") or CJ_DTR("Rake") < 3 then
		if CJ_Cast("Rake(Cat Form)") then return end;
	end;
	
	if CJ_HB("Omen of Clarity") and AmIBehind == "true" then
		if CJ_Cast("Shred(Cat Form)") then return end;
	end
	
	if CJ_Combo() >= 1 and CJ_HD("Rip") and CJ_DTR("Rip") > 8 and CJ_BTR("Savage Roar") < 3 then
		if CJ_Cast("Savage Roar(Cat Form)") then return end;
	end
	
	if (CJ_Combo() == 5 and CJ_HP("target") < 5) or CJ_HP("target") < 2 then
		if CJ_Cast("Ferocious Bite(Cat Form)") then return end;
	end
	
	if CJ_Combo() == 5 and CJ_DTR("Rip") >= 14 and CJ_BTR("Savage Roar") >= 10 then
		if CJ_Cast("Ferocious Bite(Cat Form)") then return end;
	end
	
	if CJ_HD("Rip") and CJ_DTR("Rip") <= 4 and CJ_HP("target") > 25 and AmIBehind == "true" then
		if CJ_Cast("Shred(Cat Form)") then return end;
	end
	
	if CJ_DTR("Rip") > 7 and CJ_Combo() >= 4 then
		if CJ_Cast("Ferocious Bite(Cat Form)") then return end;
	end
	
	if CJ_HB("Stampede") and not CJ_HB("Omen of Clarity") and CJ_HB("Tiger's Fury") then
		if CJ_Cast("Ravage") then return end
		if CJ_Cast("Ravage!") then return end
	end
	
	if CJ_Energy() < 45 then return end;
	
	if AmIBehind == "true" then
		if CJ_Cast("Shred(Cat Form)") then return end;
	else
		if CJ_Cast("Mangle(Cat Form)") then return end;
	end
end

function CJFeralDruidRot()
	swapBack()
	
	if GetShapeshiftForm() == 1 then
		CJBearRotation()
	elseif GetShapeshiftForm() == 3 then
		CJKittyRotation()
	end
end

------------------------
--------Boomy!----------
------------------------
local lastSwap
local function CJ_Eclipse()
	return UnitPower("player",8);
end

local function CJ_Solar()
	return CJ_HB("Eclipse (Solar)");
end

local function CJ_Lunar()
	return CJ_HB("Eclipse (Lunar)");
end

local function CJ_BalanceBuffs()
	if not (CJ_HB("Mark of the Wild") or CJ_HB("Blessing of Kings")) then
		if GetShapeshiftForm() ~= 0 then
			RunMacroText("/cancelform");
			return true;
		end
		if CJ_Cast("Mark of the Wild") then return true end;
	end
	
	if GetShapeshiftForm() ~= 5 then
		CastShapeshiftForm(5);
		return true;
	end
	return false;
end

function CJBalanceDruidRot()
	if AmIFacing == "false" then return end
	if UnitAffectingCombat("player") == 1 and CJ_HP("player") < 50 and cj_cooldowns then
		CJ_Cast("Barkskin")
	end
	
	if not CJ_GCD() then return end;
	if CJ_Casting() then return end;
	if CJ_BalanceBuffs() then return end;
	
	if IsSpellInRange("Wrath") == 0 then return end;
	
	
	if GetUnitSpeed("player") > 0 then
		if CJ_DTR("Insect Swarm") < 4 then
			if CJ_Cast("Insect Swarm") then return end;
		end
		
		if CJ_HB("Eclipse (Solar)") then
			if CJ_Cast("Sunfire") then return end;
		end
		
		if CJ_Cast("Moonfire") then return end;
		return
	end
	
	if CJ_IsBoss() or CJ_IsRaidBoss() and not ((CJ_OD("Faerie Fire") or (CJ_HD("Faerie Fire") and CJ_DS("Faerie Fire") < 3)) or CJ_OD("Sunder Armor") or CJ_OD("Expose Armor")) then
		if CJ_Cast("Faerie Fire") then return end;
	end
	
	if cj_cooldowns then
		CJ_Cast("Force of Nature");
	end
	
	if CJ_DTR("Insect Swarm") < 4 then
		if CJ_Cast("Insect Swarm") then return end;
	end
	
	if CJ_HB("Astral Alignment") then
		if CJ_Cast("Starsurge") then return end;
		if CJ_Lunar() then
			if CJ_Cast("Starfire") then return end;
		else
			if CJ_Cast("Wrath") then return end;
		end
	end
	
	if CJ_Solar() then
		if (balancefourset and not CJ_HB("Astral Alignment")) or not balancefourset then
			if CJ_DTR("Sunfire") < 4 and not CJ_HD("Moonfire") then
				if CJ_Cast("Moonfire") then return end
			end
		end
	else
		if (balancefourset and not CJ_HB("Astral Alignment")) or not balancefourset then
			if not CJ_Lunar() then
				if CJ_DTR("Moonfire") < 3 then
					if CJ_Cast("Moonfire") then return end;
				end
			else
				if CJ_DTR("Moonfire") < 4 and CJ_Eclipse() > -20 then
					if CJ_Cast("Moonfire") then return end;
				end
			end
		end
	end
	
	if not ((GetEclipseDirection() == "moon" and CJ_Eclipse() <= -87) or (GetEclipseDirection() == "sun" and CJ_Eclipse() >= 80)) then
		if CJ_Cast("Starsurge") then return end;
	end
	
	if GetEclipseDirection() == "sun" and CJ_Eclipse() < 80 then
		if CJ_Cast("Starfire") then lastSwap = "Starfire" return end;
	end
	
	if GetEclipseDirection() == "moon" and CJ_Eclipse() < -87 then
		if lastSwap == "Wrath" then
			if CJ_Cast("Starfire") then lastSwap = nil return end;
		end
	end
	
	if GetEclipseDirection() == "moon" and CJ_Eclipse() >= -87 then
		if CJ_Cast("Wrath") then lastSwap = "Wrath" return end;
	end
	
	if GetEclipseDirection() == "sun" and CJ_Eclipse() >= 80 then
		if lastSwap == "Starfire" then
			if CJ_Cast("Wrath") then lastSwap = nil return end;
		end
	end
	
	if GetEclipseDirection() == "sun" then
		if CJ_Cast("Starfire") then return end;
	end
	
	if GetEclipseDirection() == "moon" then
		if CJ_Cast("Wrath") then return end;
	end
	
	if CJ_Cast("Starfire") then return end;
end