local function CJ_Shout()
	if CJ_CD("Battle Shout") > 0 then return false end
	
	if CJ_HB("Horn of Winter") or CJ_HB("Strength of Earth Totem") or CJ_HB("Roar of Courage") then
		if CJ_Cast("Commanding Shout") then return true end
	else
		if CJ_Cast("Battle Shout") then return true end
	end
	if CJ_Cast("Battle Shout") then return true end
end

--------------------------------
------------Fury----------------
--------------------------------

function CJ_TGRotation()
	if cj_cooldowns then
		if CJ_HP("player") > 50 then
			CJ_Cast("Recklessness")
		end
		
		if not (CJ_HB("Enrage") or CJ_HB("Unholy Frenzy")) then
			CJ_Cast("Death Wish")
		end
	end
	
	if CJ_CD("Bloodthirst") > 0 and CJ_CD("Bloodthirst") < .3 then return end
	
	if CJ_BTR("Executioner") < 1.5 then
		if CJ_Cast("Execute") then return end
	end
	
	if CJ_Cast("Colossus Smash") then return end
	
	if CJ_BS("Executioner") < 5 then
		if CJ_Cast("Execute") then return end
	end
	
	if CJ_Cast("Bloodthirst") then return end
	
	if (not (CJ_HB("Death Wish") or CJ_HB("Unholy Frenzy"))) and UnitPower("player") > 15 and CJ_CD("Raging Blow") < 1 then
		CJ_Cast("Berserker Rage")
	end
	
	if CJ_Cast("Raging Blow") then return end
	
	if CJ_HB("Bloodsturge") then
		if CJ_Cast("Slam") then return end
	end
	
	if UnitPower("player") >= 50 then
		if CJ_Cast("Execute") then return end
	end
	
	if UnitPower("player") < 70 then
		if CJ_Shout() then return end
	end
end

function CJ_SMFRotation()
	if cj_cooldowns then
		if CJ_HP("player") > 50 then
			CJ_Cast("Recklessness")
		end
		
		if not (CJ_HB("Enrage") or CJ_HB("Unholy Frenzy")) then
			CJ_Cast("Death Wish")
		end
	end
	
	if CJ_CD("Bloodthirst") > 0 and CJ_CD("Bloodthirst") < .3 then return end
	
	if CJ_BTR("Executioner") < 1.5 then
		if CJ_Cast("Execute") then return end
	end
	
	if CJ_Cast("Colossus Smash") then return end
	
	if CJ_BS("Executioner") < 5 then
		if CJ_Cast("Execute") then return end
	end
	
	if CJ_Cast("Bloodthirst") then return end
	
	if CJ_HB("Bloodsturge") then
		if CJ_Cast("Slam") then return end
	end
	
	if UnitPower("player") >= 50 then
		if CJ_Cast("Execute") then return end
	end
	
	if (not (CJ_HB("Death Wish") or CJ_HB("Unholy Frenzy"))) and UnitPower("player") > 15 and CJ_CD("Raging Blow") < 1 then
		CJ_Cast("Berserker Rage")
	end
	
	if CJ_Cast("Raging Blow") then return end
	
	if UnitPower("player") < 70 then
		if CJ_Shout() then return end
	end
end


function CJFuryWarRot()
	if AmIFacing == false then return end
	CJ_Interrupt("Pummel")
	
	if GetShapeshiftForm("player") ~= 3 then
		CastShapeshiftForm(3)
	end
	
	if IsSpellInRange("Heroic Strike") == 0 and IsSpellInRange("Intercept") == 1 then
		if not CJ_CD("Intercept") == 0 and CJ_CD("Heroic Fury") == 0 then return end
		if PlayerToTarget <= 8 or PlayerToTarget >= 25 then return end
		if UnitPower("player") < 10 and CJ_CD("Battle Shout") == 0 then
			if CJ_Shout() then return end
		end
		if CJ_Cast("Intercept") then return end
		
		if CJ_CD("Intercept") > 0 then
			if CJ_Cast("Heroic Fury") then CJ_Cast("Intercept") return end
		end
		return
	end
	
	if cj_aoemode and cj_cooldowns then
		CJ_Cast("Inner Rage")
	end
	
	if cj_aoemode and UnitPower("player") >= 30 then
		CJ_Cast("Cleave")
	end
	
	StartAttack()
	
	if ((UnitPower("player") > 85 and CJ_HP("target") >= 20)) or (CJ_HB("Battle Trance")) or 
		((CJ_HB("Incite") or CJ_HD("Colossus Smash")) and 
		((UnitPower("player") >= 50 and CJ_HP("target") >= 20) or (UnitPower("player") >=75 and CJ_HP("target") < 20))) then
		CJ_Cast("Heroic Strike")
	end
	
	if not CJ_GCD() then return end
	
	if cj_hamstring and not CJ_HD("Hamstring") then
		if CJ_Cast("Hamstring") then return end
	end
	
	if CJ_IsBoss() and (not (CJ_OD("Faerie Fire") or CJ_OD("Sunder Armor") or CJ_OD("Expose Armor")) or 
	(CJ_DS("Sunder Armor") < 3 or CJ_DTR("Sunder Armor") < 4)) then
		if CJ_Cast("Sunder Armor") then return end;
	end
	
	if cj_aoemode and CJ_HP("player") < 50 then
		CJ_Cast("Enraged Regeneration")
	end
	
	if cj_aoemode then
		if CJ_Cast("Whirlwind") then return end
	end
	
	if CJ_Hero() and CJ_CD("Shattering Throw") == 0 and cj_cooldowns then
		CastShapeshiftForm(1)
		CJ_Cast("Shattering Throw")
	end
	
	if CJ_HP("player") < 70 then
		if CJ_Cast("Victory Rush") then return end
	end
	
	if select(5,GetTalentInfo(2,20,false,false,nil))==1 then
		CJ_TGRotation();
	else
		CJ_SMFRotation();
	end
end

--------------------------------
------------Arms----------------
--------------------------------
function CJArmsWarRot()
	if AmIFacing == false then return end
	CJ_Interrupt("Pummel")
	
	if (not CJ_HD("Rend")) or (((CJ_HB("Overpower") or CJ_HB("Taste for Blood")) and CJ_CD("Mortal Strike") > 1) 
		and UnitPower("player") >= 75) or (CJ_Hero() and CJ_CD("Shattering Throw") == 0) then
		if GetShapeshiftForm() ~= 1 then CastShapeshiftForm(1) end
	elseif (not CJ_HB("Taste for Blood")) and UnitPower("player") < 75 then
		if GetShapeshiftForm() ~= 3 then CastShapeshiftForm(3) end
	end
	
	if IsSpellInRange("Heroic Strike") == 0 and IsSpellInRange("Charge") == 1 then
		if PlayerToTarget >=8 and PlayerToTarget <= 25 then
			if CJ_Cast("Charge") then return end
		end
		return
	end
	
	if PlayerToTarget <= 25 and PlayerToTarget >= 8 then
		CJ_Cast("Charge")
	end
	
	if cj_cooldowns then
		if CJ_HP("target") > 20 and CJ_IsRaidBoss() then
			CJ_Cast("Recklessness")
		elseif CJ_HP("target") < 20 and CJ_IsBoss() then
			CJ_Cast("Recklessness")
		end
		
		if UnitPower("player") < 30 and ((CJ_HP("target") > 20 and CJ_IsRaidBoss()) or 
		(CJ_HP("target") <= 20 and CJ_IsBoss() and not CJ_HB("Recklessness"))) then
			CJ_Cast("Deadly Calm")
		end
	end
	
	StartAttack()
	
	if GetShapeshiftForm() == 3 then
		if cj_aoemode and (UnitPower("player") > 40 or CJ_HB("Battle Trance") or CJ_HB("Deadly Calm")) then
			CJ_Cast("Cleave")
		end
		
		if UnitPower("player") > 80 or CJ_HB("Deadly Calm") or CJ_HB("Incite") or CJ_HB("Battle Trance") then
			CJ_Cast("Heroic Strike")
		end
		
		if not CJ_GCD() then return end
		
		if CJ_HP("player") < 70 then
			if CJ_Cast("Victory Rush") then return end
		end
		
		if CJ_IsBoss() and (not (CJ_OD("Faerie Fire") or CJ_OD("Sunder Armor") or CJ_OD("Expose Armor")) or 
		(CJ_DS("Sunder Armor") < 3 or CJ_DTR("Sunder Armor") < 4)) then
			if CJ_Cast("Sunder Armor") then return end;
		end
		
		if cj_hamstring and not CJ_HD("Hamstring") then
			if CJ_Cast("Hamstring") then return end
		end
		
		if cj_aoemode and CJ_CD("Sweeping Strike") == 0 then
			if UnitPower("player")  < 30 then return end
			CJ_Cast("Sweeping Strike")
		end
		
		if not CJ_HB("Deadly Calm") and UnitPower("player") > 80 and CJ_CD("Deadly Calm") > 15 then
			CJ_Cast("Inner Rage")
		end
		
		if CJ_HP("target") > 20 or UnitPower("player") >= 30 then
			if CJ_Cast("Mortal Strike") then return end
		end
		
		if CJ_HB("Battle Trance") then
			if CJ_Cast("Execute") then return end
		end
		
		if CJ_HB("Deadly Calm") or CJ_HB("Recjlessness") then
			if CJ_Cast("Execute") then return end
		end
		
		if CJ_Cast("Mortal Strike") then return end
		
		if CJ_Cast("Execute") then return end
		
		if (CJ_CD("Mortal Strike") >= 1.5 and (UnitPower("player") >= 35 or CJ_HB("Deadly Calm") or CJ_HD("Colossus Smash"))) or
			(CJ_CD("Mortal Strike") >= 1.2 and CJ_DTR("Colossus Smash") > .5 and UnitPower("player") >= 35) then
			CJ_Cast("Slam")
		end
		
		if UnitPower("player") < 20 then
			if CJ_Shout() then return end
		end
	elseif GetShapeshiftForm() == 1 then
		if not CJ_GCD() then return end
		if CJ_Hero() then
			if CJ_Cast("Shattering Throw") then return end
		end
		
		if cj_hamstring and not CJ_HD("Hamstring") then
			if CJ_Cast("Hamstring") then return end
		end
		
		if CJ_HB("Taste for Blood") then
			if CJ_Cast("Overpower") then return end
		end
		
		if not CJ_HD("Rend") then
			if CJ_Cast("Rend") then return end
		end
		
		if CJ_Cast("Overpower") then return end
		
		if UnitPower("player") < 20 then
			if CJ_Shout() then return end
		end
	end	
end

--------------------------------
---------Protection-------------
--------------------------------
function CJProtWarRot()
	if AmIFacing == false then return end
	CJ_Interrupt("Pummel")
	
	if IsSpellInRange("Heroic Strike") == 0 and IsSpellInRange("Heroic Throw") == 1 then
		if CJ_Cast("Heroic Throw") then return end
		if PlayerToTarget >=8 and PlayerToTarget <= 25 then
			if CJ_Cast("Charge") then CJ_Shout() return end
		end
		return
	end
	
	StartAttack()
	
	if GetShapeshiftForm() ~= 2 then
		CastShapeshiftForm(2)
	end
	
	if cj_defensivecooldowns then
		if CJ_HP("player") < 70 then
			CJ_Cast("Shield Block")
		end
		
		if CJ_HP("player") < 30 then
			CJ_Cast("Shield Wall")
		end
		
		if CJ_HP("player") < 10 then
			CJ_Cast("Enraged Regeneration")
		end
	end
	
	if cj_cooldowns then
		CJ_Cast("Berserker Rage")
	end
	
	if not cj_aoemode then
		if UnitPower("player") > 55 then
			CJ_Cast("Heroic Strike")
		end
	else
		if UnitPower("player") > 50 then
			CJ_Cast("Cleave")
		end
	end
	
	if not CJ_GCD() then return end
	if AmIFacing == false then return end
	
	if not (CJ_HB("Battle Shout") or CJ_HB("Commanding Shout")) then
		CJ_Shout()
	end
	
	if not CJ_HD("Demoralizing Shout") then
		if CJ_Cast("Demoralizing Shout") then return end
	end
	
	if not cj_aoemode then
		if CJ_Cast("Shield Slam") then return end
		if CJ_HD("Rend") and CJ_DTR("Rend") < 4.5 then
			if CJ_Cast("Thunder Clap") then return end
			return
		end
		if CJ_Cast("Revenge") then return end
		if not CJ_HD("Rend") then
			if CJ_Cast("Rend") then return end
		end
		if CJ_Cast("Devastate") then return end
		if CJ_Shout() then return end
	else
		if not CJ_HD("Rend") then
			if CJ_Cast("Rend") then return end
			return
		end	
		if CJ_Cast("Thunder Clap") then return end
		if CJ_Cast("Shockwave") then return end
		if CJ_Cast("Revenge") then return end
		if CJ_Cast("Shield Slam") then return end
		if CJ_Cast("Devastate") then return end
		if CJ_Shout() then return end
	end
end