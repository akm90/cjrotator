---- Druid Rotations

-----------------------------------
--------Feral Kitty----------------
-----------------------------------

local T114Set = false;

local function CJCheckFeralBuffs()
	if not CJ_HasBuff("player","Mark of the Wild") then
		CastSpell("Mark of the Wild");
		return true;
	end
	
	if GetShapeshiftForm() ~= 3 then
		CastShapeshiftForm(3);
		return true;
	end
	return false;
end

local function CJ_Energy(
	return UnitPower("player",3);
end

local function facing()
	if AmIBehind == "true" then
		return 2;
	elseif AmIFacing == "true" then
		return 1;
	else
		return 0;
	end
end

function CJ_FeralDruidRot()
	if cj_interruptmode and CJCooldown("Skull Bash(Cat Form)") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Skull Bash(Cat Form)",thing) then
				CastSpellByName("Skull Bash(Cat Form)",thing);
			end
		end
	end
	
	StartAttack("target");
	
	if not IsSpellInRange("Mangle(Cat Form)") then
		if IsSpellInRange("Feral Charge(Cat Form)") and CJCooldown("Feral Charge(Cat Form)") == 0 then
			CastSpell("Feral Charge(Cat Form)");
	
	if CJ_Energy() <= 26 then
		CastSpell("Tiger's Fury");
	end
	
	if not CJ_GCD() then return end; -- Check for GCD
	if CJCheckFeralBuffs() then return end; -- Check our buffs
		
	if T114Set and CJ_BuffInfo("Strength of the Panther") < 3 and CJCooldown("Mangle(Cat Form)") == 0 and facing() >= 1  then
		CastSpell("Mangle(Cat Form)");
		return
	end
	
	if CJCooldown("Faerie Fire") == 0 and CJ_DebuffInfo("target","Fearie Fire") < 3 
	and not (CJ_HasOtherDebuff("target","Sunder Armor") or CJ_HasOtherDebuff("target","Expose Armor")) and facing() >= 1 then
		CastSpell("Faerie Fire (Feral)");
		return;
	end
	
	if select(2,CJ_BuffInfo("target","Mangle")) <= 2 and CJCooldown("Mangle") == 0 then
		CastSpell("Mangle(Cat Form)");
		return;
	end
	
	if CJ_HasBuff(
end