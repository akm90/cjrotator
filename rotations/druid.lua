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
	if not UnitAffectingCombat("player")==1 and (not CJ_HB("Mark of the Wild") and not CJ_HB("Blessing of Kings")) then
		if GetShapeshiftForm() ~= 0 then
			lastForm = GetShapeshiftForm();
			RunMacroText("/cancelform");
			return true;
		end
		if CJ_Cast("Mark of the Wild") then return true end;;
	end
	
	return false;
end

function CJFeralTankRot()
	CJ_Interrupt("Skull Bash(Bear Form)");
	
	StartAttack("target");
	
	if UnitAffectingCombat("player") == 1 and UnitDetailedThreatSituation("player","target") == nil then
		CJ_Cast("Growl");
	end
	
	if IsSpellInRange("Mangle") == 0 and IsSpellInRange("Feral Charge(Bear Form)") == 1 then
		CJ_Cast("Feral Charge(Bear Form)");
		
		if not CJ_HD("Faerie Fire") or CJ_DS("Faerie Fire") < 3 and CJ_GCD() then
			if CJ_Cast("Faerie Fire") then return end;
		end
		return;
	end
	
	if CJ_Rage() > 50 then
		if CJ_Cast("Maul(Bear Form)") then return end;
	end
	
	if not CJ_GCD() then return end;
	
	if CJ_BearBuffs() then return end;
	
	if cj_aoemode then
		if not CJ_HD("Demoralizing Roar") then
			if CJ_Cast("Demoralizing Roar(Bear Form)") then return end;
		end
		
		if CJ_Cast("Swipe(Bear Form") then return end;
		if CJ_Cast("Thrash(Bear Form") then return end;
	end
	
	if CJ_Cast("Mangle(Bear Form)") then return end;
	
end

