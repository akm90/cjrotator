local vtcast = 0
---------------------
------Shadow---------
---------------------
local function CJ_ShadowBuffs()
	if not CJ_HB("Power Word: Fortitude") then
		if CJ_Cast("Power Word: Fortitude") then return true end
	end
	
	if not CJ_HB("Shadow Protection") then
		if CJ_Cast("Shadow Protection") then return true end
	end
	
	if not CJ_HB("Inner Fire") then
		if CJ_Cast("Inner Fire") then return true end
	end
	
	if not CJ_HB("Vampiric Embrace") then
		if CJ_Cast("Vampiric Embrace") then return true end
	end
	
	if GetShapeshiftForm() ~= 1 then
		CastShapeshiftForm(1)
		return true
	end
	
	return false
end

function CJSpriestRot()
	CJ_Interrupt("Silence")
	if CJ_OC() then StopAttack() return end
	if not CJ_GCD() then return end
	if CJ_Casting() then return end
	if CJ_HB("Dispersion") then return end
	
	if CJ_ShadowBuffs() then return end
	
	if cj_decurseself then
		if CJ_DecurseSelf() then return end
	end
	
	if AmIFacing == false then return end
	
	if CJ_HP("player") < 15 then
		if CJ_Cast("Dispersion") then return end
	end
	
	CJ_OffensiveDispel("Dispel Magic")
	
	if IsSpellInRange("Mind Blast") == 0 then return end
	
	if GetUnitSpeed("player") > 0 then
		if CJ_DTR("Shadow Word: Pain") < 2 then
			if CJ_Cast("Shadow Word: Pain") then return end
		end
		
		if CJ_DTR("Devouring Plague") < 2 then
			if CJ_Cast("Devouring Plague") then return end
		end
		
		if CJ_HP("player") > 15 and not UnitName("target") == "Halfus Wyrmbreaker" then
			if CJ_Cast("Shadow Word: Death") then return end
		end
		
		if CJ_MP("player") > 50 then
			if CJ_Cast("Devouring Plague") then return end
		end
		return
	end
	
	if cj_aoemode then
		if CJ_Cast("Mind Sear") then return end
	end
	
	if CJ_HB("Shadow Orb") then
		if CJ_Cast("Mind Blast") then return end
	end
	
	if CJ_DTR("Shadow Word: Pain") < 2 then
		if CJ_Cast("Shadow Word: Pain") then return end
	end
	
	if CJ_DTR("Devouring Plague") < 2 then
		if CJ_Cast("Devouring Plague") then return end
	end
	
	if (CJ_DTR("Vampiric Touch") - (select(7,GetSpellInfo("Vampiric Touch"))/1000)) < 2 and (GetTime() - vtcast > 2.5) then
		if CJ_Cast("Vampiric Touch") then vtcast = GetTime() return end
	end
	
	if CJ_MP("player") <= 75 and cj_cooldowns and CJ_DTR("Vampiric Touch") > 5 and CJ_DTR("Devouring Plague") > 5 and CJ_BS("Dark Evangelism") == 5 then
		CJ_Cast("Dark Archangel")
	end
	
	if CJ_HP("target") < 25 and CJ_HP("player") > 15 then
		if CJ_Cast("Shadow Word: Death") then return end
	end
	
	if CJ_MP("player") < 50 and cj_dispersion then
		if CJ_Cast("Dispersion") then return end
	end
	
	if CJ_Cast("Mind Blast") then return end
	if CJ_Cast("Mind Flay") then return end
end

---------------------
--------Disc---------
---------------------
local function CJ_DiscBuffs()
	if not CJ_HB("Power Word: Fortitude") then
		if CJ_Cast("Power Word: Fortitude") then return true end
	end
	
	if not CJ_HB("Shadow Protection") then
		if CJ_Cast("Shadow Protection") then return true end
	end
	
	if not CJ_HB("Inner Fire") then
		if CJ_Cast("Inner Fire") then return true end
	end
	
	return false
end

function CJDiscPriestRot()
	if CJ_OC() then StopAttack() return end
	if not CJ_GCD() then return end
	if CJ_Casting() then return end
	
	if CJ_DiscBuffs() then return end
	
	if cj_decurseself then
		if CJ_DecurseSelf() then return end
	end
	
	if cj_decurseparty then
		if CJ_DecurseAll() then return end
	end
	
	if AmIFacing == false then return end
	
	CJ_OffensiveDispel("Dispel Magic")
	
	if cj_cooldowns then
		CJ_Cast("Power Infusion")
		if CJ_BS("Evangelism") == 5 then
			CJ_Cast("Archangel")
		end
	end
	
	if IsSpellInRange("Holy Fire") == 0 then return end
	
	if GetUnitSpeed("player") > 0 then
		if not UnitDebuff("targettarget","Weakened Soul") then
			CJ_CastTarget("Power Word: Shield","targettarget")
		end
		
		if CJ_HB("Borrowed Time") and not cj_healonly then
			if CJ_DTR("Shadow Word: Pain") < 2 then
				if CJ_Cast("Shadow Word: Pain") then return end
			end
			
			if CJ_DTR("Devouring Plague") < 2 then
				if CJ_Cast("Devouring Plague") then return end
			end
		end
		return
	end
	
	if cj_aoemode then
		if CJ_Cast("Mind Sear") then return end
	end
	
	if CJ_Cast("Holy Fire") then return end
	
	if not UnitDebuff("targettarget","Weakened Soul") then
		CJ_CastTarget("Power Word: Shield","targettarget")
	end
	
	if CJ_HB("Borrowed Time") and not cj_healonly then
		if CJ_DTR("Shadow Word: Pain") < 2 then
			if CJ_Cast("Shadow Word: Pain") then return end
		end
		
		if CJ_DTR("Devouring Plague") < 2 then
			if CJ_Cast("Devouring Plague") then return end
		end
	end
	
	if not cj_healonly then
		if CJ_Cast("Penance") then return end
	end
	
	if CJ_Cast("Smite") then return end
	
end