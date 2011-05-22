--Warrior Rotations

--------------------------------
------------Fury----------------
--------------------------------

function CJ_WarriorSelectShout()
	if not (CJCooldown("Battle Shout") == 0 or CJCooldown("Commanding Shout") == 0) then return end;
	if (CJ_HasBuff("player","Horn of Winter") or CJ_HasBuff("player","Strength of Earth Totem") or CJ_HasBuff("player","Roar of Courage")) then
		CastSpell("Commanding Shout");
		return;
	else
		CastSpell("Battle Shout");
		return;
	end
	CastSpell("Battle Shout");
	return;			
end

function CJ_WarriorCanUse(spell)
	if cj_interruptmode then
		if CJ_HasBuff("Battle Trance") then
			return true;
		else
			return UnitPower("player") > (select(4,GetSpellInfo("Pummel")) + select(4,GetSpellInfo(spell)));
		end
	else
		return select(2,IsUsableSpell(spell)) == nil;
	end
end

function CJSMFRotation()
	if not CJ_HasBuff("player","Battle Shout") and not CJ_HasBuff("player","Commanding Shout") then
		CJ_WarriorSelectShout();
		return;
	end	
	
	if GetShapeshiftForm() ~= 3 then
		CastShapeshiftForm(3);
		return;
	end
	
	if cj_aoemode and CJCooldown("Whirlwind") == 0 and CJ_WarriorCanUse("Whirlwind") then
		CastSpell("Whirlwind");
		return;
	end
	
	if CJCooldown("Bloodthirst") < .3 and CJCooldown("Bloodthirst") > 0 then
		return;
	end
	
	if not cj_aoemode and CJ_DetectHero() and CJCooldown("Shattering Throw") == 0 and CJ_WarriorCanUse("Shattering Throw") then
		CastShapeshiftForm("1");
		CastSpell("Shattering Throw");
		return;
	end
	
	if (CJHealthPercent("target") < 20 and CJ_HasBuff("player","Executioner")) and CJ_WarriorCanUse("Execute") then
		if (select(2,CJ_BuffInfo("player","Executioner")) < 1.5) then
			CastSpell("Execute");
			return;
		end
	end
	
	if CJCooldown("Colossus Smash") == 0 and CJ_WarriorCanUse("Colossus Smash") then
		CastSpell("Colossus Smash");
		return;
	end
	
	if CJHealthPercent("target") < 20 and CJ_HasBuff("player","Executioner") and CJ_WarriorCanUse("Execute") then
		if CJ_BuffInfo("player","Executioner") < 5 and CJCooldown("Execute") == 0 then
			CastSpell("Execute");
			return;
		end
	end
	
	if CJCooldown("Bloodthirst") == 0 and CJ_WarriorCanUse("Bloodthirst") then
		CastSpell("Bloodthirst");
		return;
	end
	
	if CJ_HasBuff("player","Bloodsurge") then
		CastSpell("Slam");
		return;
	end
	
	if CJHealthPercent("target") < 20 and UnitPower("player") >= 50 then
		CastSpell("Execute");
		return;
	end
	
	if CJCooldown("Berserker Rage") == 0 and not ((CJ_HasBuff("player","Death Wish") or CJ_HasBuff("player","Enrage") or CJ_HasBuff("player","Unholy Frenzy")) 
	and UnitPower("player") > 15 and CJCooldown("Raging Blow") < 1) then
		CastSpell("Berserker Rage");
		return;
	end
	
	if CJCooldown("Raging Blow") == 0 and IsUsableSpell("Raging Blow") and CJ_WarriorCanUse("Raging Blow") then
		CastSpell("Raging Blow");
		return;
	end
	
	if UnitPower("player") < 70 then
		CJ_WarriorSelectShout();
	end
end

function CJTitansRotation()
	if not CJ_HasBuff("player","Battle Shout") and not CJ_HasBuff("player","Commanding Shout") then
		CJ_WarriorSelectShout();
		return;
	end	
	
	if GetShapeshiftForm() ~= 3 then
		CastShapeshiftForm(3);
		return;
	end
	
	if cj_aoemode and CJCooldown("Whirlwind") == 0 and CJ_WarriorCanUse("Whirlwind") then
		CastSpell("Whirlwind");
		return;
	end
	
	if CJCooldown("Bloodthirst") < .3 and CJCooldown("Bloodthirst") > 0 then
		return;
	end
	
	if not cj_aoemode and CJ_DetectHero() and CJCooldown("Shattering Throw") == 0 and CJ_WarriorCanUse("Shattering Throw") then
		CastShapeshiftForm("1");
		CastSpell("Shattering Throw");
		return;
	end
	
	if (CJHealthPercent("target") < 20 and CJ_HasBuff("player","Executioner")) and CJ_WarriorCanUse("Execute") then
		if (select(2,CJ_BuffInfo("player","Executioner")) < 1.5) then
			CastSpell("Execute");
			return;
		end
	end
	
	if CJCooldown("Colossus Smash") == 0 and CJ_WarriorCanUse("Colossus Smash") then
		CastSpell("Colossus Smash");
		return;
	end
	
	if CJHealthPercent("target") < 20 and CJ_HasBuff("player","Executioner") and CJ_WarriorCanUse("Execute") then
		if CJ_BuffInfo("player","Executioner") < 5 and CJCooldown("Execute") == 0 then
			CastSpell("Execute");
			return;
		end
	end
	
	if CJCooldown("Bloodthirst") == 0 and CJ_WarriorCanUse("Bloodthirst") then
		CastSpell("Bloodthirst");
		return;
	end
	
	if CJCooldown("Berserker Rage") == 0 and not ((CJ_HasBuff("player","Death Wish") or CJ_HasBuff("player","Enrage") or CJ_HasBuff("player","Unholy Frenzy")) 
	and UnitPower("player") > 15 and CJCooldown("Raging Blow") < 1) then
		CastSpell("Berserker Rage");
		return;
	end
	
	if CJCooldown("Raging Blow") == 0 and IsUsableSpell("Raging Blow") and CJ_WarriorCanUse("Raging Blow") then
		CastSpell("Raging Blow");
		return;
	end
	
	if CJ_HasBuff("player","Bloodsurge") then
		CastSpell("Slam");
		return;
	end
	
	if CJHealthPercent("target") < 20 and UnitPower("player") >= 50 then
		CastSpell("Execute");
		return;
	end
	
	if UnitPower("player") < 70 then
		CJ_WarriorSelectShout();
	end
end

function CJFuryWarRot()
	if cj_interruptmode and CJCooldown("Rebuke") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Rebuke",thing) then
				CastSpellByName("Rebuke",thing);
			end
		end
	end

	if AmIFacing == "false" then return end;
	
	if not IsSpellInRange("Heroic Strike") then
		if CJCooldown("Intercept") == 0 and IsSpellInRange("Intercept") ~= 0 then
			CastSpell("Intercept");
			return;
		elseif CJCooldown("Heroic Fury") == 0 and IsSpellInRange("Intercept") then
			CastSpell("Heroic Fury");
			CastSpell("Intercept");
			return			
		end
		return;
	end
	
	if cj_aoemode and CJCooldown("Cleave") == 0 and UnitPower("player") >= 30 then
		CastSpell("Cleave")
	end
	
	StartAttack();
	
	if CJCooldown("Heroic Strike") == 0 then
		if (UnitPower("player") > 85 and CJHealthPercent("target") > 20) or (CJ_HasBuff("player","Battle Trance")) or
		((CJ_HasBuff("player","Incite") or CJ_HasDebuff("target","Colossus Smash")) and 
		((UnitPower("player") >= 50 and CJHealthPercent("target") >= 20) or (UnitPower("player")  >= 75 and CJHealthPercent("target") < 20))) then
			CastSpell("Heroic Strike");
		end
	end
	
	if not CJ_GCD() then return end; -- Check for GCD
	
	if select(5,GetTalentInfo(2,20,false,false,nil))==1 then
		CJTitansRotation();
	else
		CJSMFRotation();
	end
end

function CJArmsWarRot()
	if CJ_HasBuff("player","Bladestorm") then return end;
	if cj_interruptmode and CJCooldown("Rebuke") == 0 then
		local thing = CJ_Interrupt();
		if (thing ~= false) then
			if IsSpellInRange("Rebuke",thing) then
				CastSpellByName("Rebuke",thing);
			end
		end
	end
	
	if AmIFacing == "false" then return end;
	
	if not IsSpellInRange("Heroic Strike") then
		if CJCooldown("Charge") == 0 and IsSpellInRange("Charge") then
			CastSpell("Charge");
			return;
		end
		return;
	end
	
	if cj_aoemode and CJCooldown("Cleave") == 0 and UnitPower("player") >= 30 then
		CastSpell("Cleave")
	end
	
	StartAttack();
	
	if CJCooldown("Heroic Strike") == 0 then
		if UnitPower("player") > 85 or CJ_HasBuff("player","Deadly Calm") or CJ_HasBuff("player","Incite") or CJ_HasBuff("player","Battle Trance") then
			CastSpell("Heroic Strike");
		end
	end
	
	if GetShapeShiftForm() ~= 1 and CJCooldown("Battle Stance") == 0 and select(2,CJ_DebuffInfo("target","Rend"))<.2 or (CJ_HasBuff("player","Taste for Blood") and CJCooldown("Mortal Strike") > 1 and UnitPower("player") <= 75) then
		CastShapeshiftForm(1);
		return;
	elseif UnitPower("player") < 75 and not CJ_HasBuff("player","Taste for Blood") and GetShapeshiftForm() ~= 3 and CJ_Cooldown("Berserker Stance") == 0 then
		CastShapeshiftForm(3);	
		return;
	end
	
	if CJ_Cooldown("Charge") == 0 and IsUsableSpell("Charge") then
		CastSpell("Charge");
	end
	
	if UnitPower("player") < 70 and not CJ_HasBuff("Deadly Calm") then
		CastSpell("Berserker Rage");
	end
	
	if cj_aoemode and CJCooldown("Sweeping Strike") == 0 and CJ_WarriorCanUse("Sweeping Strikes") then
		CastSpell("Sweeping Strikes")
	end
	
	if cj_aoemode and CJCooldown("Cleave") == 0 and UnitPower("player") >= 30 and CJ_WarriorCanUse("Cleave") then
		CastSpell("Cleave")
	end
	
	if CJCooldown("Inner Rage") == 0 and not CJ_HasBuff("Deadly Calm") and UnitPower("player") > 80  and CJCooldown("Deadly Calm") > 15 then
		CastSpell("Inner Rage");
	end
	
	if not CJ_GCD() then return end;
	
	if cj_aoemode and not CJ_HasBuff("player","Deadly Calm") and not CJ_HasBuff("player","Sweeping Strikes") and CJCooldown("Bladestorm") == 0 and CJ_WarriorCanUse("Bladestorm") then
		CastSpell("Bladestorm");
		return
	end
	
	if GetShapeshiftForm() == 1 and CJCooldown("Overpower") == 0 and select(2,CJ_BuffInfo("player","Taste for Blood") < 1.5) and CJ_WarriorCanUse("Overpower") then
		CastSpell("Overpower");
		return;
	end
	
	if CJCooldown("Mortal Strike") == 0 and (CJHealthPercent("target") > 20 or UnitPower("player") >= 30) and CJ_WarriorCanUse("Mortal Strike") then
		CastSpell("Mortal Strike");
		return;
	end
	
	if CJCooldown("Execute") == 0 and CJHealthPercent("target") < 20 and CJ_HasBuff("player","Deadly Calm") and CJ_WarriorCanUse("Execute") then
		CastSpell("Execute");
		return;
	end
	
	if not CJ_HasDebuff("Rend") and GetShapeshiftForm() == 1 and CJ_WarriorCanUse("Rend") then
		CastSpell("Rend");
		return;
	end
	
	if CJCooldown("Colossus Smash") == 0 and select(2,CJ_DebuffInfo("target","Colossus Smash")) < .5 and CJ_WarriorCanUse("Colossus Smash") then
		CastSpell("Colossus Smash");
		return;
	end
	
	if CJHealthPercent("target") < 20 and (CJ_HasBuff("player","Deadly Calm") or CJ_HasBuff("player","Recklessness")) and CJCooldown("Execute") == 0 and CJ_WarriorCanUse("Execute")  then
		CastSpell("Execute");
		return;
	end
	
	if CJCooldown("Mortal Strike") == 0 and CJ_WarriorCanUse("Mortal Strike") then
		CastSpell("Mortal Strike");
		return;
	end
	
	if GetShapeshiftForm() == 1 and CJCooldown("Overpower") == 0 and CJ_WarriorCanUse("Overpower") then
		CastSpell("Overpower");
		return;
	end
	
	if CJHealthPercent("target") < 20 and CJCooldown("Execute") == 0 and CJ_WarriorCanUse("Execute") then
		CastSpell("Execute");
		return;
	end
	
	if (CJCooldown("Mortal Strike") > 1.5 and (UnitPower("player") > 30 or CJ_HasBuff("player","Deadly Calm") or CJ_HasDebuff("target","Colossus Smash"))) or (CJCooldown("Mortal Strike") > 1.2 
	and select(2,CJ_DebuffInfo("target","Colossus Smash")) > .5 and UnitPower("player") >= 35) then
		CastSpell("Slam");
		return;
	end
	
	if UnitPower("player") < 20 then
		CJWarriorSelectShout();
		return;
	end	
end