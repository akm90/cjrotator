-- Priest Rotations

-----------------------------
--------Disc-----------------
-----------------------------

local function CJCheckDiscBuffs()
	if not CJ_HasBuff("player","Power Word: Fortitude") then
		CastSpell("Power Word: Fortitude");
		return true;
	end
	
	if not CJ_HasBuff("player","Inner Fire") then
		CastSpell("Inner Fire");
		return true;
	end
	
	if not CJ_HasBuff("player","Shadow Protection") then
		CastSpell("Shadow Protection");
		return true;
	end

	return false;
end

function CJDiscPriestRot()
	if not CJ_GCD() then return end; -- Check for GCD
	if CJCheckDiscBuffs() then return end; -- Check our buff
	if AmIFacing == "false" then return end;
	
	if not CJ_CheckMyCast() then return end;
	if CJCooldown("Holy Fire") == 0 then
		CastSpell("Holy Fire");
		return;
	end
	
	if (not CJ_HasDebuff("target","Shadow Word: Pain")) and not CJ_HasDebuff("player","Weakened Soul") then
		CastSpell("Power Word: Shield");
		return
	end
	
	if CJ_HasBuff("player","Borrowed Time") then
		if not CJ_HasDebuff("target","Shadow Word: Pain") then
			CastSpell("Shadow Word: Pain");
			return;
		end
	end
	
	if CJCooldown("Penance")  == 0 then
		CastSpell("Penance");
		return;
	end
	
	CastSpell("Smite");
	return;
end

----------------------------------
---------Shadow-------------------
----------------------------------
local lastspell;
local function CJSPCast(spell)
	lastspell = spell;
	CastSpell(spell);
end

local function CJCheckShadowBuffs()
	if not CJ_HasBuff("player","Power Word: Fortitude") then
		CastSpell("Prayer of Fortitude");
		return true;
	end

	if not CJ_HasBuff("player","Inner Fire") then
		CastSpell("Inner Fire");
		return true;
	end
	
	if not CJ_HasBuff("player","Shadow Protection") then
		CastSpell("Shadow Protection");
		return true;
	end
	
	if not CJ_HasBuff("player","Vampiric Embrace") then
		CastSpell("Vampiric Embrace");
		return true;
	end
	
	if not CJ_HasBuff("player","Shadowform") then
		CastSpell("Shadowform");
		return true
	end

	return false;
end

function CJSpriestRot()
	if select(5,GetTalentInfo(3,11,false,false,nil))==1 then
		if cj_interruptmode and CJCooldown("Silence") == 0 then
			local thing = CJ_Interrupt();
			if (thing ~= false) then
				if IsSpellInRange("Silence",thing) and AmIFacing == "true" then
					CastSpellByName("Silence",thing);
				end
			end
		end
	end

	if not CJ_GCD() then return end; -- Check for GCD
	if CJCheckDiscBuffs() then return end; -- Check our buffs
	if AmIFacing == "false" then return end;
	
	if not CJ_CheckMyCast() then return end;
	
	if GetUnitSpeed("player") > 0 then
		if not IsSpellInRange("Devouring Plague") then return end;
		
		if select(2,CJ_DebuffInfo("target","Shadow Word: Pain")) < 2 then
			CJSPCast("Shadow Word: Pain");
			return;
		end
			
		if select(2,CJ_DebuffInfo("target","Devouring Plague")) < 2 then
			CJSPCast("Devouring Plague");
			return;
		end
		
		if CJHealthPercent("player") > 15 and UnitName("target") ~= "Halfus Wyrmbreaker" and CJCooldown("Shadow Word: Death") == 0 then
			CJSPCast("Shadow Word: Death");
			return;
		end
		
		if CJManaPercent("player") > 50 then
			CJSPCast("Devouring Plague");
			return;
		end
		return;
	end
	
	if not IsSpellInRange("Mind Blast") then return end;
	
	if CJCooldown("Mind Blast") == 0 and CJ_BuffInfo("player","Shadow Orb") > 0 then
		CJSPCast("Mind Blast");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Shadow Word: Pain")) < 2 then
		CJSPCast("Shadow Word: Pain");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Devouring Plague")) < 2 then
		CJSPCast("Devouring Plague");
		return;
	end
	
	if select(2,CJ_DebuffInfo("target","Vampiric Touch")) < 2 and lastspell ~= "Vampiric Touch" then
		CJSPCast("Vampiric Touch");
		return;
	end
	
	if CJ_BuffInfo("player","Dark Evangelism") == 5 and select(2,CJ_DebuffInfo("target","Vampiric Touch")) > 5 
		and select(2,CJ_DebuffInfo("target","Devouring Plague")) > 5 and CJManaPercent("player") < 75 then
		CJSPCast("Dark Archangel");
	end
	
	if CJHealthPercent("target") < 25 and CJCooldown("Shadow Word: Death") == 0 then
		CJSPCast("Shadow Word: Death");
		return;
	end
	
	if CJCooldown("Mind Blast") == 0 then
		CJSPCast("Mind Blast");
		return;
	end
	
	CastSpell("Mind Flay");
	return;
end