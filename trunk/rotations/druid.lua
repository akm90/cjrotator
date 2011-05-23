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

local function CJ_Energy()
	return UnitPower("player",3);
end

local function CJ_Combo()
	return GetComboPoints("player","target");
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

function CJFeralDruidRot()
	if cj_interruptmode and CJCooldown("Skull Bash(Cat Form)") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Skull Bash(Cat Form)",thing) then
				CastSpellByName("Skull Bash(Cat Form)",thing);
			end
		end
	end
	
	StartAttack("target");
	
	if IsSpellInRange("Mangle(Cat Form)") == 0 then
		if IsSpellInRange("Feral Charge(Cat Form)") and CJCooldown("Feral Charge(Cat Form)") == 0 then
			CastSpell("Feral Charge(Cat Form)");
			return;
		end
		return;
	end
			
	if CJ_Energy() <= 26 and CJCooldown("Tiger's Fury") == 0 then
		CastSpell("Tiger's Fury");
	end
	
	if not CJ_GCD() then return end; -- Check for GCD
	if CJCheckFeralBuffs() then return end; -- Check our buffs
		
	if T114Set and CJ_BuffInfo("Strength of the Panther") < 3 and CJCooldown("Mangle(Cat Form)") == 0 and facing() >= 1  then
		CastSpell("Mangle(Cat Form)");
		return
	end
	
	if CJCooldown("Faerie Fire") == 0 and CJ_DebuffInfo("target","Faerie Fire") < 3 
	and not (CJ_HasOtherDebuff("target","Sunder Armor") or CJ_HasOtherDebuff("target","Expose Armor")) and facing() >= 1 then
		CastSpell("Faerie Fire (Feral)");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Mangle")) <= 2 and CJCooldown("Mangle") == 0 then
		CastSpell("Mangle(Cat Form)");
		return;
	end
	
	if select(2,CJ_BuffInfo("player","Stampede")) <  2 and CJ_HasBuff("player","Stampede") then
		CastSpell("Ravage!");
		return;
	end
	
	if CJHealthPercent("target") <= 25 and CJ_Combo() >= 1 and CJ_HasDebuff("target","Rip") and
	select(2,CJ_DebuffInfo("target","Rip")) < 2 then
		CastSpell("Ferocious Bite(Cat Form)")
		return;
	end
	
	if CJHealthPercent("target") <= 25 and CJ_HasDebuff("target","Rip") and CJ_Combo() == 5 then
		CastSpell("Ferocious Bite(Cat Form)");
		return;
	end
	
	if CJ_Combo() == 5 and select(2,CJ_DebuffInfo("target","Rip")) < 2 and select(2,CJ_BuffInfo("player","Tiger's Fury")) < 2 then
		CastSpell("Rip(Cat Form)");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Rake")) < 9 and CJ_HasBuff("player","Tiger's Fury")  and CJ_HasDebuff("target","Rake") then
		CastSpell("Rake(Cat Form)");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Rake")) < 3 then
		CastSpell("Rake(Cat Form)");
		return;
	end
	
	if CJ_HasBuff("player","Omen of Clarity") and AmIBehind == "true" then
		CastSpell("Shred");
		return;
	end
	
	if CJ_Combo() >= 1 and select(2,CJ_BuffInfo("player","Savage Roar")) < 1.5 then
		CastSpell("Savage Roar(Cat Form)");
		return;
	end
	
	if CJ_Combo() == 5 and CJ_HasDebuff("target","Rip") and select(2,CJ_DebuffInfo("target","Rip")) < 12 and 
		(select(2,CJ_DebuffInfo("target","Rip")) - select(2,CJ_BuffInfo("player","Savage Roar")) <= 3) then
		CastSpell("Savage Roar(Cat Form)");
		return;
	end
	
	if CJHealthPercent("target") < 5 and CJ_Combo() == 5 then
		CastSpell("Ferocious Bite(Cat Form)");
		return;
	end
	
	if CJ_Combo() == 5 and select(2,CJ_DebuffInfo("target","Rip")) >= 14 and select(2,CJ_BuffInfo("player","Savage Roar")) >= 10 then
		CastSpell("Ferocious Bite(Cat Form)")
		return;
	end
	
	if AmIBehind == "true" and CJ_HasDebuff("target","Rip") and CJHealthPercent("target") > 25 and select(2,CJ_DebuffInfo("target","Rip")) >= 4 then
		CastSpell("Shred(Cat Form)");
		return;
	end
	
	if AmIBehind == "true" then
		CastSpell("Shred(Cat Form)");
		return;
	end
end