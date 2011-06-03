---------------------
------Marksmanship---
---------------------
local numsteady = 0;
--[[ Hawk
Fox
Cheetah
Pack
Resist
--]]
function CJMarksHunterRot()
	if AmIFacing == "false" then return end;
	
	if not CJ_HB("Trueshot Aura") then
		if CJ_Cast("Trueshot Aura") then return end
	end
	
	if GetUnitSpeed() > 0 then
		if GetShapeshiftForm() ~= 2 then
			CastShapeshiftForm(2)
		end
	else
		if GetShapeshiftForm() ~= 1 then
			CastShapeshiftForm(1)
		end
	end
	
	StartAttack()
	
	if not CJ_GCD() then return end;
	if CJ_Casting() then return end
	
	
	if not CJ_HD("Hunter's Mark") then
		if CJ_Cast("Hunter's Mark") then return end
	end
	
	if cj_aoemode then
		if CJ_Cast("Multi Shot") then return end
	end
	
	if CJ_HP("target") <= 80 and not CJ_HD("Serpent Sting") then
		if CJ_Cast("Serpent Sting") then return end
	end
	
	if CJ_HP("target") <= 80 then
		if CJ_Cast("Chimera Shot") then return end
	end
	
	if cj_cooldowns then
		if not CJ_Hero() and CJ_IsBoss() and CJ_HP("target") < 10 then
			CJ_Cast("Rapid Fire");
		end
		
		if IsUsableSpell("Rapid Fire") and CJ_CD("Rapid Fire") > 0 and not CJ_HB("Rapid Fire") then
			if CJ_Cast("Readiness") then return end
		end
	end
	
	if numsteady == 1 and CJ_BTR("Improved Steady Shot") < 3 then
		if CJ_Cast("Steady Shot") then numsteady = 0 return end
	end
	
	if CJ_Cast("Kill Shot") then return end
	
	if CJ_HB("Fire!") then
		if CJ_Cast("Aimed Shot") then return end
	end
	
	if GetUnitSpeed == 0 then
		if CJ_CD("Chimera Shot") > 5 or UnitPower("player") >= 80 or CJ_HB("Rapid Fire") or CJ_Hero() or CJ_HP("target") > 80 then
			if CJ_Cast("Aimed Shot") then return end
		end
	elseif GetShapeshiftForm() == 2 then
		if CJ_Cast("Steady Shot") then return end
	end
	
	if CJ_Cast("Steady Shot") then return end;
end