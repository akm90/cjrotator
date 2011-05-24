---- Druid Rotations

-----------------------------------
--------Feral Kitty----------------
-----------------------------------

local fourset = false;

local function CJCheckFeralBuffs()
	if not CJ_HasBuff("player","Mark of the Wild") or not CJ_HasBuff("player","Blessing of Kings") then
		if GetShapeshiftForm() ~= 0 then
			RunMacroText("/cancelform");
			return true;
		end
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
			if IsSpellInRange("Skull Bash(Cat Form)",thing) == 1 then
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
		
		if IsSpellInRange("Faerie Fire(Feral)") and CJ_DebuffInfo("target","Faerie Fire") == 0 and not CJ_HasBuff("player","Prowl") then
			CastSpell("Faerie Fire(Feral)");
			return;
		end
		return;
	end
			
	if CJ_Energy() <= 26 and CJCooldown("Tiger's Fury") == 0 then
		CastSpell("Tiger's Fury");
	end
	
	if not CJ_GCD() then return end; -- Check for GCD
	if CJCheckFeralBuffs() then return end; -- Check our buffs
	
	if cj_aoemode and CJCooldown("Swipe") == 0 and IsUsableSpell(2,"Swipe(Cat Form)") == nil then
		CastSpell("Swipe(Cat Form)")
		return;
	end
	
	if AmIBehind == "true" and CJCooldown("Ravage") == 0 and CJ_HasBuff("player","Prowl") and not CJ_HasBuff("player","Stampede") then
		CastSpell("Ravage");
		CastSpell("Ravage!");
		return;
	end
	
	if fourset and CJ_BuffInfo("Strength of the Panther") < 3 and CJCooldown("Mangle(Cat Form)") == 0 and facing() >= 1  then
		CastSpell("Mangle(Cat Form)");
		return
	end
	
	if CJCooldown("Faerie Fire") == 0 and (CJ_DebuffInfo("target","Faerie Fire") < 3 or select(2,CJ_DebuffInfo("target","Faerie Fire")) < 4)
	and not (CJ_HasOtherDebuff("target","Sunder Armor") or CJ_HasOtherDebuff("target","Expose Armor")) and facing() >= 1 then
		CastSpell("Faerie Fire (Feral)");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Mangle")) <= 2 and CJCooldown("Mangle") == 0 
	and not CJ_HasOtherDebuff("target","Trauma") and not CJ_HasOtherDebuff("target","Hemorrhage") then
		CastSpell("Mangle(Cat Form)");
		return;
	end
	
	if select(2,CJ_BuffInfo("player","Stampede")) <  2 and CJ_HasBuff("player","Stampede") and IsUsableSpell("Ravage") then
		CastSpell("Ravage");
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
	
	if CJ_Combo() <= 2 and CJ_Combo() >= 1 and select(2,CJ_BuffInfo("player","Savage Roar")) < 1.5 then
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
	
	if AmIBehind == "false" then
		CastSpell("Mangle(Cat Form)");
		return;
	end
end

-----------------------------------
--------Boomkin -------------------
-----------------------------------
local lastSwap = "";

local function CJ_Eclipse()
	return UnitPower("player",8);
end

local function CJCheckBalanceBuffs()
	if not CJ_HasBuff("player","Mark of the Wild") or not CJ_HasBuff("player","Blessing of Kings") then
		if GetShapeshiftForm() ~= 0 then
			RunMacroText("/cancelform");
			return;
		end
		CastSpell("Mark of the Wild");
		return true;
	end
	
	if GetShapeshiftForm() ~= 5 then
		CastShapeshiftForm(5);
		return true;
	end
	return false;
end

function CJBalanceDruidRot()
	if not CJ_GCD() then return end; -- Check for GCD
	if not CJ_CheckMyCast() then return end;
	--if CJCheckBalanceBuffs() then return end; -- Check our buffs
	if AmIFacing == "false" then return end;
	
	
	if IsSpellInRange("Wrath") == 0 then return end;
	
	if GetUnitSpeed("player") > 0 then
		if select(2,CJ_DebuffInfo("target","Insect Swarm")) < 4 or (select(2,CJ_DebuffInfo("target","Insect Swarm")) < 4 and
		CJ_HasBuff("Eclipse (Solar)") and CJ_Eclipse() < 15) then
			CastSpell("Insect Swarm");
			return;
		end
		
		if CJ_HasBuff("player","Eclipse (Solar)") then
			CastSpell("Sunfire");
			return;
		end
		
		CastSpell("Moonfire");
		return;
	end
	
	if CJCooldown("Faerie Fire") == 0 and (CJ_DebuffInfo("target","Faerie Fire") < 3 or select(2,CJ_DebuffInfo("target","Faerie Fire")) < 4)
	and not (CJ_HasOtherDebuff("target","Sunder Armor") or CJ_HasOtherDebuff("target","Expose Armor")) then
		CastSpell("Faerie Fire");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Insect Swarm")) < 4 or (select(2,CJ_DebuffInfo("target","Insect Swarm")) < 4 and
	CJ_HasBuff("Eclipse (Solar)") and CJ_Eclipse() < 15) then
		CastSpell("Insect Swarm");
		return;
	end
	
	if CJ_HasBuff("player","Astral Alignment") and CJCooldown("Starsurge") == 0 then
		CastSpell("Starsurge");
		return;
	end
	
	if CJ_HasBuff("player","Astral Alignment") and CJ_HasBuff("player","Eclipse (Lunar") then
		CastSpell("Starfire");
		return;
	end
	
	if CJ_HasBuff("player","Astral Alignment") then
		CastSpell("Wrath");
		return;
	end
	
	if CJ_HasBuff("player","Eclipse (Lunar)") and CJCooldown("Starfall") == 0 and  foruset and not CJ_HasBuff("player","Astral Alignment") then
		CastSpell("Starfall");
		return;
	end
	
	if CJ_HasBuff("player","Eclipse (Solar)") then
		if (fourset and not CJ_HasBuff("player","Astral Alignment")) or (not fourset) then
			if ((select(2,CJ_DebuffInfo("target","Sunfire")) < 3) or (select(2,CJ_DebuffInfo("target","Sunfire")) < 4 and 
			CJ_HasBuff("player","Eclipse (Solar)") and CJ_Eclipse() < 15)) and not CJ_HasDebuff("target","Moonfire") then
				CastSpell("Sunfire");
				return
			end
		end
	end
	
	if not CJ_HasBuff("player","Eclipse (Solar)") then
		if (fourset and not CJ_HasBuff("player","Astral Alignment")) or (not fourset) and not CJ_HasDebuff("target","Sunfire") then
			if not CJ_HasBuff("player","Eclipse (Lunar)") then
				if select(2,CJ_DebuffInfo("target","Moonfire")) < 3 then
					CastSpell("Moonfire");
					return;
				end
			else
				if select(2,CJ_DebuffInfo("target","Moonfire")) < 4 and CJ_Eclipse() > -20 then
					CastSpell("Moonfire");
					return;
				end
			end
		end
	end
	
	if CJCooldown("Starsurge") == 0 and 
	not ((GetEclipseDirection() == "moon" and CJ_Eclipse() <= -87) or (GetEclipseDirection() == "sun" and CJ_Eclipse() >= 80)) then
		CastSpell("Starsurge");
		return;
	end
	
	if GetEclipseDirection() == "sun" and CJ_Eclipse() < 80 then
		CastSpell("Starfire");
		lastSwap = "Starfire";
		return;
	end
	
	if GetEclipseDirection() == "moon" and CJ_Eclipse() < -87 and lastSwap == "Wrath" then
		CastSpell("Starfire");
		lastSwap = "";
		return;
	end
	
	if GetEclipseDirection() == "moon" and CJ_Eclipse() >= -87 then
		CastSpell("Wrath")
		lastSwap = "Wrath";
		return;
	end
	
	if GetEclipseDirection() == "sun" and CJ_Eclipse() >= 80 and lastSwap == "Starfire" then
		CastSpell("Wrath");
		lastSwap = "";
		return;
	end	
	
	if GetEclipseDirection() == "sun" then
		CastSpell("Starfire");
		return
	end
	
	if GetEclipseDirection() == "moon" then
		CastSpell("Wrath");
		return;
	end
	
	CastSpell("Starfire");
	return;
end
