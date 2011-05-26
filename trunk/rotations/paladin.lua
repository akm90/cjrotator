--Paladin Rotations

local function CJHolyPower()
	return UnitPower("player",9);
end

local function CJGetNextThreat()
	local highestThreat = 0;
	if GetNumPartyMembers() == 0 then
		return 100;
	end
	
	if UnitDetailedThreatSituation("player","target") == nil then
		return 100;
	end
	
	if GetNumRaidMembers() == 0 then
		for i = 1,GetNumPartyMembers() do
			isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("party"..i, "target");
			if scaledPercent ~= nil then
				if scaledPercent > highestThreat then
					highestThreat = scaledPercent;
				end
			end
		end
	else
		for i = 1, GetNumRaidMembers() do
			isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("raid"..i, "target");
			if scaledPercent ~= nil then
				if scaledPercent > highestThreat then
					highestThreat = scaledPercent;
				end
			end
		end
	end
	
	
	return highestThreat;
end

-------------------------------------------
--------------Protection-------------------
-------------------------------------------

local function CJCheckProtBuffs()
	if not CJ_HasBuff("player","Righteous Fury") then
		CastSpell("Righteous Fury");
		return;
	end

	if CJHealthPercent("target") > 80 and not CJ_HasBuff("player","Seal of Truth") then
		CastSpell("Seal of Truth");
		return;
	end
	
	if cj_aoemode and not CJ_HasBuff("player","Seal of Truth") then
		CastSpell("Seal of Truth");
		return;
	end
	
	if CJGetNextThreat() < 70 and not cj_aoemode and not CJ_HasBuff("player","Seal of Insight") and CJHealthPercent("target") < 80 then
		CastSpell("Seal of Insight");
		return;
	end
	
	if CJGetNextThreat() >= 80 and not CJ_HasBuff("player","Seal of Truth") then
		CastSpell("Seal of Truth");
		return;
	end
	
	if not (CJ_HasBuff("player","Devotion Aura") or CJ_HasBuff("player","Retribution Aura") 
	or CJ_HasBuff("player","Concentration Aura") or CJ_HasBuff("player","Resistance Aura") 
	or CJ_HasBuff("player","Crusader Aura")) then
		CastSpell("Devotion Aura");
		return true;
	end
	
	return false;
end

function CJProtPallyRot()
	if cj_interruptmode and CJCooldown("Rebuke") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Rebuke",thing) then
				CastSpellByName("Rebuke",thing);
			end
		end
	end
	
	StartAttack("target");
	
	if not CJ_GCD() then return end; -- Check for GCD
	if CJCheckProtBuffs() then return end; -- Check our buffs
	
	if IsSpellInRange("Crusader Strike") == 0 and IsSpellInRange("Avenger's Shield") == 1 then
		if CJCooldown("Avenger's Shield") == 0 then
			CastSpell("Avenger's Shield");
			return;
		end
		
		if CJCooldown("Judgement") == 0 then
			CastSpell("Judgement");
			return;
		end
		return;
	end
	
	if CJCooldown("Crusader Strike") > 0 and CJCooldown("Crusader Strike") < .45 then
		return
	end
	
	if CJManaPercent("player") < 50 and CJCooldown("Judgement") == 0 then
		CastSpell("Judgement")
		return;
	end
	
	if CJHealthPercent("player") < 40 and CJCooldown("Word of Glory") == 0 and CJHolyPower() == 3 then
		CastSpell("Word of Glory");
		return;
	end
	
	if CJHolyPower() == 3 and (CJ_HasBuff("player","Sacred Duty") or CJ_HasBuff("player","Inquisition")) then
		CastSpell("Shield of the Righteous");
		return;
	end
	
	if CJHolyPower() == 3 and not CJ_HasBuff("player","Inquisition") then
		CastSpell("Inquisition");
		return;
	end
	
	if CJHolyPower() == 3 and not CJ_HasBuff("player","Sacred Duty") then
		CastSpell("Inquisition");
		return;
	end
	
	if CJCooldown("Crusader Strike") == 0 then
		if cj_aoemode then
			CastSpell("Hammer of the Righteous");
			return;
		else
			CastSpell("Crusader Strike");
			return
		end
	end
	
	if IsUsableSpell("Hammer of Wrath") and CJCooldown("Hammer of Wrath") == 0 then
		CastSpell("Hammer of Wrath");
		return
	end
	
	if cj_aoemode and CJCooldown("Consecration") == 0 then
		CastSpell("Consecration");
		return;
	end
	
	if cj_aoemode and CJCooldown("Holy Wrath") == 0 then
		CastSpell("Holy Wrath");
		return;
	end
	
	if CJCooldown("Avenger's Shield") == 0 then
		CastSpell("Avenger's Shield");
		return;
	end
	
	if CJCooldown("Judgement") == 0 then
		CastSpell("Judgement");
		return;
	end
	
end
-------------------------------------------
-----------Retribution---------------------
-------------------------------------------

local ud = false;
local function CJCheckRetBuffs()
	--Only doing Seal...letting players handle Blessing
	if not CJ_HasBuff("player","Seal of Truth") then
		CastSpell("Seal of Truth");
		return true;
	end
	
	if not (CJ_HasBuff("player","Devotion Aura") or CJ_HasBuff("player","Retribution Aura") 
	or CJ_HasBuff("player","Concentration Aura") or CJ_HasBuff("player","Resistance Aura") 
	or CJ_HasBuff("player","Crusader Aura")) then
		CastSpell("Retribution Aura");
		return true;
	end
	
	return false;
end


function CJRetPallyRot()
	if cj_interruptmode and CJCooldown("Rebuke") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Rebuke",thing) then
				CastSpellByName("Rebuke",thing);
			end
		end
	end
	
	StartAttack("target");
	
	if CJ_HasDebuff("player","Caustic Slime") then return end;
	
	if not CJ_GCD() then return end; -- Check for GCD
	if CJCheckRetBuffs() then return end; -- Check our buffs
	if UnitCreatureType("target") == "Demon" or UnitCreatureType("target") == "Undead" then ud = true end;
	--Range Checks
	if IsSpellInRange("Crusader Strike") == 0 and IsSpellInRange("Judgement") == 1 then
		--Not in melee range, ranged stuff
		if CJCooldown("Judgement") == 0 then
			CastSpell("Judgement");
			return;
		end
		
		if CJ_HasBuff("player","The Art of War") and AmIFacing == "true" then
			CastSpell("Exorcism");
			return;
		end
		
		if GetUnitSpeed("player") == 0 and CJManaPercent("player") > 40 and AmIFacing == "true" and not UnitCastingInfo("player") then
			CastSpell("Exorcism");
			return;
		end
		return;
	else
		if AmIFacing == "false" then return end;
		
		--We're in melee range, lets blow crap up!
		--Check for the Undead/Demon rotation first
		if not ud then
			if (CJHolyPower() == 3 or CJ_HasBuff("player","Divine Purpose")) then
				if not CJ_HasBuff("player","Inquisition") then
					CastSpell("Inquisition");
					return
				else
					if select(2,CJ_BuffInfo("player","Inquisition")) < 7 then
						CastSpell("Inquisition");
					end
				end
			end
			
			if not cj_aoemode and CJCooldown("Crusader Strike") == 0 and CJHolyPower() < 3 then
				CastSpell("Crusader Strike");
				return;
			end
			
			if cj_aoemode and CJCooldown("Divine Storm") == 0 and CJHolyPower() < 3 then
				CastSpell("Divine Storm");
				return;
			end
			
			if IsUsableSpell("Hammer of Wrath") and CJCooldown("Hammer of Wrath") == 0 then
				CastSpell("Hammer of Wrath");
				return;
			end
			
			if CJ_HasBuff("player","The Art of War") then
				CastSpell("Exorcism");
				return;
			end
			
			if (CJHolyPower() == 3) then
				CastSpell("Templar's Verdict");
				return;
			end
			
			if (CJHolyPower() <= 2 and CJ_HasBuff("player","Divine Purpose")) then
				if not cj_aoemode then
					if CJCooldown("Crusader Strike") == 0 then
						CastSpell("Crusader Strike");
						return;
					elseif CJCooldown("Crusader Strike") <= .3 then
						return;
					end
				else
					if CJCooldown("Divine Storm") == 0 then
						CastSpell("Divine Storm");
						return;
					elseif CJCooldown("Divine Storm") <= .3 then
						return;
					end
				end
			end
			
			if CJ_HasBuff("player","Divine Purpose") then
				CastSpell("Templar's Verdict");
				return;
			end
			
			if CJCooldown("Judgement") == 0 then
				CastSpell("Judgement");
				return;
			end
			
			if CJCooldown("Holy Wrath") == 0 then
				CastSpell("Holy Wrath");
				return;
			end
			
			if cj_aoemode and CJManaPercent("player") > 80 then
				CastSpell("Consecration");
				return;
			end
		else			
			if (CJHolyPower() == 3 or CJ_HasBuff("player","Divine Purpose")) then
				if not CJ_HasBuff("player","Inquisition") then
					CastSpell("Inquisition");
					return
				else
					if select(2,CJ_BuffInfo("player","Inquisition")) < 7 then
						CastSpell("Inquisition");
					end
				end
			end
			
			if not cj_aoemode and CJCooldown("Crusader Strike") == 0 and CJHolyPower() < 3 then
				CastSpell("Crusader Strike");
				return;
			end
			
			if cj_aoemode and CJCooldown("Divine Storm") == 0 and CJHolyPower() < 3 then
				CastSpell("Divine Storm");
				return;
			end
			
			if CJ_HasBuff("player","The Art of War") then
				CastSpell("Exorcism");
				return;
			end
			
			if IsUsableSpell("Hammer of Wrath") and CJCooldown("Hammer of Wrath") == 0 then
				CastSpell("Hammer of Wrath");
				return;
			end
			
			if (CJHolyPower() == 3) then
				CastSpell("Templar's Verdict");
				return;
			end
			
			if (CJHolyPower() <= 2 and CJ_HasBuff("Divine Purpose")) then
				if not AoE then
					if CJCooldown("Crusader Strike") == 0 then
						CastSpell("Crusader Strike");
						return;
					elseif CJCooldown("Crusader Strike") <= .3 then
						return;
					end
				else
					if CJCooldown("Divine Storm") == 0 then
						CastSpell("Divine Storm");
						return;
					elseif CJCooldown("Divine Storm") <= .3 then
						return;
					end
				end
			end
			
			if CJ_HasBuff("player","Divine Purpose") then
				CastSpell("Templar's Verdict");
				return;
			end
			
			if CJCooldown("Judgement") == 0 then
				CastSpell("Judgement");
				return;
			end
			
			if CJCooldown("Holy Wrath") == 0 then
				CastSpell("Holy Wrath");
				return;
			end
			
			if cj_aoemode and CJManaPercent("player") > 80 then
				CastSpell("Consecration");
				return;
			end
		end
	end
end