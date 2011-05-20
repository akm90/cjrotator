--Warrior Rotations

--------------------------------
------------Fury----------------
--------------------------------

function CJ_FuryWarSelectShout()
	if not (CJCooldown("Battle Shout") == 0 or CJCooldown("Commanding Shout") == 0) then return end;
	if (CJ_HasBuff("player","Power Word: Fortitude") or CJ_HasBuff("player","Blood Pact")) then
		if not (CJ_HasBuff("player","Horn of Winter") or CJ_HasBuff("player","Roar of Courage") 
		or CJ_HasBuff("player","Strength of Earth Totem")) then
		CastSpell("Batle Shout");
		return;
	else
		CastSpell("Commanding Shout");
		return;
	end
	CastSpell("Commanding Shout");
	return;			
end

function CJFuryWarRot()
	if not CJ_GCD() then return end; -- Check for GCD
	if CJ_FuryWarSelectShout() then return end; -- Check our buffs
	if AmIFacing == "false" then return end;
end