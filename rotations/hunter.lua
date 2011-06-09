---------------------
------Marksmanship---
---------------------
local numsteady = 0;
local lastss = 0
local lastba = 0
--[[ Hawk
Fox
Cheetah
Pack
Resist
--]]
function CJMarksHunterRot()
	if AmIFacing == false then return end;
	CJ_Interrupt("Silencing Shot");
	
	if not CJ_HB("Trueshot Aura") then
		if CJ_Cast("Trueshot Aura") then return end
	end
	
	if cj_wildaspect then
		if not CJ_HB("Aspect of the Wild") then
			CJ_Cast("Aspect of the Wild")
		end
	else
		if GetUnitSpeed("player") > 0 then
			if not CJ_HB("Aspect of the Fox") then
				CJ_Cast("Aspect of the Fox");
			end
		else
			if not CJ_HB("Aspect of the Hawk") then
				CJ_Cast("Aspect of the Hawk")
			end
		end
	end
	
	StartAttack()
	
	if not IsPetAttackActive() then
		PetAttack("target")
	end
	
	if not CJ_GCD() then return end;
	if CJ_Casting() then return end
	
	CJ_OffensiveDispel("Tranquilizing Shot")
	
	if UnitExists("pet") and not UnitIsDead("pet") and CJ_HP("pet") < 30 and not UnitBuff("pet","Mend Pet") then
		if CJ_Cast("Mend Pet") then return end
	end
	
	if not CJ_HD("Hunter's Mark") then
		if CJ_Cast("Hunter's Mark") then return end
	end
	
	if cj_aoemode then
		if CJ_Cast("Multi-Shot") then return end
	end
	
	if CJ_HP("target") <= 80 and not CJ_HD("Serpent Sting") and GetTime() - lastss > 3 then
		if CJ_Cast("Serpent Sting") then lastss = GetTime() return end
	end
	
	if CJ_HP("target") <= 80 then
		if CJ_Cast("Chimera Shot") then return end
	end
	
	if cj_cooldowns then
		if not CJ_Hero() and CJ_IsBoss() and CJ_HP("target") < 10 and not CJ_HB("Rapid Fire") then
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
	
	if GetUnitSpeed("player") == 0 then
		if CJ_CD("Chimera Shot") > 5 or UnitPower("player") >= 80 or CJ_HB("Rapid Fire") or CJ_Hero() or CJ_HP("target") > 80 then
			if CJ_Cast("Aimed Shot") then return end
		end
	elseif CJ_HB("Aspect of the Fox") then
		if CJ_Cast("Steady Shot") then return end
	end
	
	if CJ_Cast("Steady Shot") then return end;
end

------------------------
------Survival----------
------------------------
local lastexplosive = false;
function CJSurvHunterRot()
	if AmIFacing == false then return end;
	
	if cj_wildaspect then
		if not CJ_HB("Aspect of the Wild") then
			CJ_Cast("Aspect of the Wild")
		end
	else
		if GetUnitSpeed("player") > 0 then
			if not CJ_HB("Aspect of the Fox") then
				CJ_Cast("Aspect of the Fox");
			end
		else
			if not CJ_HB("Aspect of the Hawk") then
				CJ_Cast("Aspect of the Hawk")
			end
		end
	end
	
	StartAttack()
	
	if not IsPetAttackActive() then
		PetAttack("target")
	end
	
	if not CJ_GCD() then return end;
	if CJ_Casting() then return end
	CJ_OffensiveDispel("Tranquilizing Shot")
	
	if CJ_HP("pet") < 30 and not UnitBuff("pet","Mend Pet") then
		if CJ_Cast("Mend Pet") then return end
	end
	
	if not CJ_HD("Hunter's Mark") then
		if CJ_Cast("Hunter's Mark") then lastexplosive = false return end
	end
	
	if cj_aoemode then
		if CJ_Cast("Multi-Shot") then lastexplosive = false return end
		if CJ_Cast("Cobra Shot") then lastexplosive = false return end
	end
	
	if not CJ_HD("Serpent Sting") and GetTime() - lastss > 3 then
		if CJ_Cast("Serpent Sting") then lastss = GetTime() lastexplosive = false return end
	end
	
	if cj_cooldowns and CJ_IsBoss() then
		CJ_Cast("Rapid Fire")
	end
	
	if not lastexplosive then
		if CJ_Cast("Explosive Shot") then lastexplosive = true end
	end
	
	if not CJ_HD("Black Arrow") and GetTime() - lastba > 3 then
		if CJ_Cast("Black Arrow") then lastba = GetTime() lastexplosive = false return end
	end
	
	if CJ_Cast("Kill Shot") then lastexplosive = false return end
	
	if UnitPower("player") >= 70 and not CJ_HB("Lock and Load") then
		if CJ_Cast("Arcane Shot") then lastexplosive = false return end
	end
	
	if CJ_Cast("Cobra Shot") then lastexplosive = false return end
end

function CJBMHunterRot()
	if AmIFacing == false then return end;
	
	if cj_wildaspect then
		if not CJ_HB("Aspect of the Wild") then
			CJ_Cast("Aspect of the Wild")
		end
	else
		if GetUnitSpeed("player") > 0 then
			if not CJ_HB("Aspect of the Fox") then
				CJ_Cast("Aspect of the Fox");
			end
		else
			if not CJ_HB("Aspect of the Hawk") then
				CJ_Cast("Aspect of the Hawk")
			end
		end
	end
	
	StartAttack()
	
	if not IsPetAttackActive() then
		PetAttack("target")
	end
	
	if not CJ_GCD() then return end;
	if CJ_Casting() then return end
	
	if CJ_HP("pet") < 30 and not UnitBuff("pet","Mend Pet") then
		if CJ_Cast("Mend Pet") then return end
	end
	
	CJ_OffensiveDispel("Tranquilizing Shot")
	
	if UnitPower("player") > 60 and CJ_IsBoss() and cj_cooldowns then
		CJ_Cast("Bestial Wrath")
	end
	
	if cj_aoemode then
		if CJ_Cast("Multi-Shot") then return end
		if CJ_Cast("Cobra Shot") then return end
	end
	
	if not CJ_HD("Serpent Sting") and GetTime() - lastss > 3 then
		if CJ_Cast("Serpent Sting") then lastss = GetTime() return end
	end
	
	if CJ_Cast("Kill Shot") then return end
	
	if cj_cooldowns and not CJ_Hero() and not CJ_HB("The Beast Within") then
		CJ_Cast("Rapid Fire");
	end
	
	if CJ_Cast("Kill Command") then return end
	
	if cj_cooldowns and UnitPower("player") <= 20 then
		CJ_Cast("Fervor")
	end
	
	local name,_,_,count = UnitBuff("pet","Frenzy");
	
	if count == 5 and not CJ_HB("The Beast Within") then
		if CJ_Cast("Focus Fire") then return end
	end
	
	if UnitPower("player") >= 90 or CJ_HB("The Beast Within") then
		if CJ_Cast("Arcane Shot") then return end
	end
	
	if CJ_Cast("Cobra Shot") then return end
end