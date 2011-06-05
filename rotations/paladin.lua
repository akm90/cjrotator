--Paladin Crap
local is = "Rebuke"
--------------------
--Paladin Helpers---
--------------------

local function CJ_HolyPower()
	return UnitPower("player",9);
end

local function CJ_NextThreat()
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

local function CJ_ProtBuffs()
	if not CJ_HB("Righteous Fury") then
		if CJ_Cast("Righteous Fury") then return true end
	end
	
	if (not CJ_HB("Mark of the Wild") and not CJ_HB("Blessing of Kings")) then
		if CJ_Cast("Blessing of Kings") then return end;
	elseif not CJ_HB("Blessing of Might") and (CJ_HB("Mark of the Wild") or (CJ_HB("Blessing of Kings") and select(8,UnitBuff("player","Blessing of Kings") ~= "player"))) then
		if CJ_Cast("Blessing of Might") then return end;
	end

	if CJ_HP("target") > 80 and not CJ_HB("Seal of Truth") then
		if CJ_Cast("Seal of Truth") then return true end;
	end
	
	if cj_aoemode and not CJ_HB("Seal of Truth") then
		if CJ_Cast("Seal of Truth") then return true end
	end
	
	if CJ_NextThreat() < 70 and not cj_aoemode and not CJ_HB("Seal of Insight") and CJ_HP("target") < 80 and CJ_IsBoss() then
		if CJ_Cast("Seal of Insight") then return true end
	end
	
	if CJ_NextThreat() >= 80 and not CJ_HB("Seal of Truth") then
		if CJ_Cast("Seal of Truth") then return true end;
	end
	
	if GetShapeshiftForm() == 0 then
		if not CJ_HB("Devotion Aura") then
			if CJ_Cast("Devotion Aura") then return true end;
		elseif not CJ_HB("Resistance Aura") then
			if CJ_Cast("Resistance Aura") then return true end;
		elseif not CJ_HB("Retribution Aura") then
			if CJ_Cast("Retribution Aura") then return true end;
		end
	end
	return false;
end

function CJProtPallyRot()
	if CJ_CD("Avenger's Shield") > 0 then
		CJ_Interrupt(is)
	else
		CJ_Interrupt("Avenger's Shield");
	end
	
	
	StartAttack("target");
	
	if UnitAffectingCombat("player") == 1 and cj_defensivecooldowns then
		if CJ_HP("player") < 15 and not CJ_HB("Guardian of Ancient Kings") then
			CJ_Cast("Ardent Defender");
		end
		
		if not CJ_HD("player","Forbearance") and CJ_HP("player") < 10 and CJ_CD("Ardent Defender") > 0 and not CJ_HB("Ardent Defender") then
			CJ_Cast("Lay on Hands");
		end
		
		if CJ_HP("player") < 30 and not CJ_HB("Ardent Defender") then
			CJ_Cast("Guardian of Ancient Kings");
		end
		
		if CJ_HP("player") < 70 and not (CJ_HB("Ardent Defender") or CJ_HB("Guardian of Ancient Kings")) then
			CJ_Cast("Divine Protection");
		end
	end		
	
	if AmIFacing == false then return end
	if not CJ_GCD() then return end;
	
	if CJ_ProtBuffs() then return end;
	
	if IsSpellInRange("Crusader Strike") == 0 and IsSpellInRange("Avenger's Shield") == 1 then
		if cj_cooldowns then
			if UnitAffectingCombat("player") == nil and UnitClassification("target") == "worldboss" then
				CJ_Cast("Avenging Wrath");
				if CJ_Cast("Divine Plea") then return end;
			end
		end
		
		if CJ_Cast("Avenger's Shield") then return end;
		if CJ_Cast("Judgement") then return end;
		return;
	elseif IsSpellInRange("Avenger's Shield") == 0 then return
	end
	
	if CJ_MP("player") < 20 and cj_cooldowns then
		if CJ_Cast("Divine Plea") then return end;
	end
	
	if cj_cooldowns then
		CJ_Cast("Avenging Wrath")
	end
	
	if CJ_CD("Crusader Strike") > 0 and CJ_CD("Crusader Strike") < .3 then return end
	
	if CJ_MP("player") < 50 then
		if CJ_Cast("Judgement") then return end;
	end
	
	if CJ_HP("player") < 40 and CJ_HolyPower() == 3 then
		if CJ_Cast("Word of Glory") then return end;
	end
	
	if CJ_HolyPower() == 3 and (CJ_HB("Sacred Duty") or CJ_HB("Inquisition")) then
		if CJ_Cast("Shield of the Righteous") then return end;
	end
	
	if CJ_HolyPower() == 3 and not (CJ_HB("Inquisition") or CJ_HB("Sacred Duty")) then
		if CJ_Cast("Inquisition") then return end;
	end
	
	if cj_aoemode then
		if CJ_Cast("Hammer of the Righteous") then return end;
	else
		if CJ_Cast("Crusader Strike") then return end;
	end
	
	if CJ_Cast("Hammer of Wrath") then return end;
	
	if cj_aoemode then
		if CJ_Cast("Consecration") then return end;
		if CJ_Cast("Holy Wrath") then return end;
	end
	
	if CJ_Cast("Avenger's Shield") then return end;
	
	if CJ_Cast("Judgement") then return end;
end

-------------------------------------------
--------------Retribution------------------
-------------------------------------------

local ud = false

local function CJ_RetBuffs()
	if (not CJ_HB("Mark of the Wild") and not CJ_HB("Blessing of Kings")) then
		if CJ_Cast("Blessing of Kings") then return end;
	elseif not CJ_HB("Blessing of Might") and (CJ_HB("Mark of the Wild") or (CJ_HB("Blessing of Kings") and select(8,UnitBuff("player","Blessing of Kings") ~= "player"))) then
		if CJ_Cast("Blessing of Might") then return end;
	end
	
	if not CJ_HB("Seal of Truth") then
		if CJ_Cast("Seal of Truth") then return end;
	end
	
	if GetShapeshiftForm() == 0 then
		if not CJ_HB("Devotion Aura") then
			if CJ_Cast("Devotion Aura") then return true end;
		elseif not CJ_HB("Resistance Aura") then
			if CJ_Cast("Resistance Aura") then return true end;
		elseif not CJ_HB("Retribution Aura") then
			if CJ_Cast("Retribution Aura") then return true end;
		end
	end
	return false;
end

local function CJRetNormalRotation()
	if CJ_HB("Divine Purpose") or CJ_HolyPower() == 3 then
		if not CJ_HB("Inquisition") then
			if CJ_Cast("Inquisition") then return end;
		elseif CJ_BTR("Inquisition") < 7 then
			if CJ_Cast("Inquisition") then return end;
		end
	end
	
	if CJ_HolyPower() < 3 then
		if cj_aoemode and CJ_T(3,10) > 0 then
			if CJ_Cast("Divine Storm") then return end;
		else
			if CJ_Cast("Crusader Strike") then return end;
		end
	end
	
	if CJ_Cast("Hammer of Wrath") then return end;
	
	if CJ_HB("The Art of War") then
		if CJ_Cast("Exorcism") then return end;
	end
	
	if CJ_HolyPower() == 3 then
		if CJ_Cast("Templar's Verdict") then return end;
	end
	
	if CJ_HolyPower() <= 2 and CJ_HB("Divine Purpose") then
		if CJ_CD("Crusader Strike") > 0 and CJ_CD("Crusader Strike") < .35 then
			return 
		end
		
		if cj_aoemode and CJ_T(3,10) > 0 then
			if CJ_Cast("Divine Storm") then return end;
		else
			if CJ_Cast("Crusader Strike") then return end;
		end
	end
	
	if CJ_HB("Divine Purpose") then
		if CJ_Cast("Templar's Verdict") then return end;
	end
	
	if CJ_Cast("Judgement") then return end;
	if CJ_Cast("Holy Wrath") then return end;
	
	if cj_aoemode and CJ_MP("player") > 80 then
		if CJ_Cast("Consecration") then return end;
	end
end

local function CJRetUndeadRotation()
	if CJ_HB("Divine Purpose") or CJ_HolyPower() == 3 then
		if not CJ_HB("Inquisition") then
			if CJ_Cast("Inquisition") then return end;
		elseif CJ_BTR("Inquisition") < 7 then
			if CJ_Cast("Inquisition") then return end;
		end
	end
	
	if CJ_HolyPower() < 3 then
		if cj_aoemode and CJ_T(3,10) > 0 then
			if CJ_Cast("Divine Storm") then return end;
		else
			if CJ_Cast("Crusader Strike") then return end;
		end
	end
	
	if CJ_HB("The Art of War") then
		if CJ_Cast("Exorcism") then return end;
	end
	
	if CJ_Cast("Hammer of Wrath") then return end;	
	
	if CJ_HolyPower() == 3 then
		if CJ_Cast("Templar's Verdict") then return end;
	end
	
	if CJ_HolyPower() <= 2 and CJ_HB("Divine Purpose") then
		if CJ_CD("Crusader Strike") > 0 and CJ_CD("Crusader Strike") < .35 then
			return 
		end
		
		if cj_aoemode and CJ_T(3,10) > 0 then
			if CJ_Cast("Divine Storm") then return end;
		else
			if CJ_Cast("Crusader Strike") then return end;
		end
	end
	
	if CJ_HB("Divine Purpose") then
		if CJ_Cast("Templar's Verdict") then return end;
	end
	
	if CJ_Cast("Judgement") then return end;
	if CJ_Cast("Holy Wrath") then return end;
	
	if cj_aoemode and CJ_MP("player") > 80 then
		if CJ_Cast("Consecration") then return end;
	end
end

function CJRetPallyRot()
	CJ_Interrupt(is);
	
	StartAttack("target")
	
	if UnitDebuff("player","Caustic Slime") then return end;
	
	if UnitAffectingCombat("player") == 1 and CJ_HP("player") < 70 then
		CJ_Cast("Divine Protection");
	end
	
	if IsSpellInRange("Crusader Strike") == 1 and cj_cooldowns then
		CJ_Cast("Guardian of Ancient Kings");
		if not CJ_HB("Zealotry") then
			CJ_Cast("Avenging Wrath");
		end
		
		if CJ_HolyPower() == 3 and not CJ_HB("Avenging Wrath") then
			CJ_Cast("Zealotry");
		end
	end
	
	if not CJ_GCD() then return end;
	
	if CJ_RetBuffs() then return end;
	
	if UnitCreatureType("target") == "Demon" or UnitCreatureType("target") == "Undead" then ud = true end;
	
	if IsSpellInRange("Crusader Strike") == 0 and IsSpellInRange("Judgement") == 1 then
		if CJ_Cast("Judgement") then return end;
		if CJ_HB("The Art of War") then
			if CJ_Cast("Exorcism") then return end;
		end
		
		if GetUnitSpeed("player") == 0 and CJ_MP("player") > 40 and AmIFacing == "true" and not CJ_Casting() then
			if CJ_Cast("Exorcism") then return end;
		end
		return
	elseif IsSpellInRange("Judgement") == 0 then return
	end
	
	if AmIFacing == false then return end;
	
	if ud then
		CJRetUndeadRotation()
	else
		CJRetNormalRotation()
	end
end

