--Warlock Rotations
local lastuacast = 0
local lastpetcast = 0;
local lastimmolatecast = 0;
local lasthauntcast = 0;
local lastsoulfirecast = 0;
local soulswap = false;
local seedcast = false;
local lastsboltcast = 0;

-----------------------------
---------Affliction----------
-----------------------------
function AffLockSpiritRot()
	if (CJ_DTRF("Haunt") - (select(7,GetSpellInfo("Haunt"))/1000)) < 2 and (GetTime() - lasthauntcast > 2.5) 
		and GetUnitSpeed("player") == 0 then
		if CJ_CastTarget("Haunt","focus") then lasthauntcast = GetTime() return end
	end
	
	if CJ_DTRF("Corruption") < 2 then
		if CJ_CastTarget("Corruption","focus") then return end
	end
	
	if not CJ_HDF("Bane of Doom") then
		if CJ_CastTarget("Bane of Doom","focus") then return end
	end
	
	if (CJ_DTRF("Unstable Affliction") - (select(7,GetSpellInfo("Unstable Affliction"))/1000)) < 2 and (GetTime() - lastuacast > 2.5) 
		and GetUnitSpeed("player") == 0 then
		if CJ_CastTarget("Unstable Affliction","focus") then lastuacast = GetTime() return end
	end
	
	if CJ_HP("target") < 25 and (select(1,UnitChannelInfo("player")) ~= "Drain Soul") then
		if CJ_Cast("Drain Soul") then return end
	end

	if CJ_DTR("Corruption") < 2 then
		if CJ_Cast("Corruption") then return end;
	end
	
	if not UnitCastingInfo("player") then
		if CJ_Cast("Shadow Bolt") then return end
	end
end

function AffLockSwillRot()
	if CJ_HB("Soulburn") and not seedcast then
		if CJ_Cast("Seed of Corruption") then seedcast = true return end
	end

	if CJ_DTRF("Corruption") < 2 then
		if CJ_CastTarget("Corruption","focus") then return end
	end
	
	if not CJ_HDF("Bane of Doom") then
		if CJ_CastTarget("Bane of Doom","focus") then return end
	end
	
	if (CJ_DTRF("Unstable Affliction") - (select(7,GetSpellInfo("Unstable Affliction"))/1000)) < 2 and (GetTime() - lastuacast > 2.5) 
		and GetUnitSpeed("player") == 0 then
		if CJ_CastTarget("Unstable Affliction","focus") then lastuacast = GetTime() return end
	end
	
	if CJ_CD("Soulburn") == 0 and GetUnitSpeed("player") == 0 then
		if CJ_Cast("Soulburn") then if CJ_Cast("Seed of Corruption") then seedcast = true return end end
	end
	
	if not CJ_HD("Bane of Agony") and not CJ_HD("Bane of Doom") then
		if CJ_Cast("Bane of Agony") then return end
	end
	
	if (CJ_DTR("Unstable Affliction") - (select(7,GetSpellInfo("Unstable Affliction"))/1000)) < 2 and (GetTime() - lastuacast > 2.5) 
		and GetUnitSpeed("player") == 0 then
		if CJ_Cast("Unstable Affliction") then lastuacast = GetTime() return end
	end
	
	if not seedcast then
		if CJ_Cast("Seed of Corruption") then seedcast = true return end
	end
	
	if seedcast then
		seedcast = false;
		RunMacroText("/targetenemy");
	end
end

function CJ_AffBuffs()
	if not CJ_HB("Fel Armor") then
		if CJ_Cast("Fel Armor") then return true end
	end
	if not CJ_HB("Soul Link") then
		if CJ_Cast("Soul Link") then return true end
	end
	return false
end

function CJAffLockRot()
	local hasFocus = false
	if CJ_OC() then StopAttack() return end
	CJ_PetInterrupt("Spell Lock");
	
	if not IsPetAttackActive() then
		PetAttack("target")
	end
	
	if UnitExists("focus") and UnitCanAttack("player","focus") and (UnitName("focus") ~= "Maloriak" or UnitName("focus") ~= "Majordomo Staghelm") and UnitGUID("target") ~= UnitGUID("focus") then
		hasFocus = true
	else
		hasFocus = false;
	end
	
	if UnitName("target") == "Maloriak" and (UnitName("focus") ~= "Maloriak" or not UnitExists("focus")) then
		RunMacroText("/focus");
	end

	if UnitName("target") == "Majordomo Staghelm" and (UnitName("focus") ~= "Majordomo Staghelm" or not UnitExists("focus")) then
		RunMacroText("/focus");
	end
	
	if AmIFacing == false then return end;
	
	if not CJ_GCD() then return end;
	if CJ_Casting() then return end
	if CJ_AffBuffs() then return end;
	
	if UnitPower("player") < ((UnitHealthMax("player")*.15)*1.4)  and CJ_HP("player") > 20 and cj_lifetap then
		if CJ_Cast("Life Tap") then return end
	end
	
	if IsSpellInRange("Fel Flame") == 0 then return end;
	
	CJ_OffensiveDispelPet("Devour Magic");
	
	if UnitName("target") == "Vile Swill" then
		AffLockSwillRot()
		return
	end
	
	if UnitName("target") == "Spirit of the Flame" then
		AffLockSpiritRot()
		return
	end

	if CJ_HB("Soul Swap") and hasFocus and not (UnitGUID("target") == UnitGUID("focus")) and PlayerToFocus < 40
	and not (UnitDebuff("focus","Fear") or UnitDebuff("focus","Banish") or UnitDebuff("focus","Howl of Terror") or UnitDebuff("focus","Seduction")) then
		if CJ_CastTarget("Soul Swap","focus") then return end;
	end
	
	if GetUnitSpeed("player") > 0 then
		if not CJ_OD("Curse of the Elements") and not CJ_OD("Jinx: Curse of the Elements") then
			if CJ_Cast("Curse of the Elements") then return end;
		end
		
		if CJ_DTR("Corruption") < 2 then
			if CJ_Cast("Corruption") then return end;
		end
		
		if hasFocus or not CJ_IsBoss() or (CJ_IsBoss() and UnitHealth("target") < 60000) then
			if not CJ_HD("Bane of Agony") then
				if CJ_Cast("Bane of Agony") then return end;
			end
		else
		        if not CJ_HD("Bane of Doom") then
				if CJ_Cast("Bane of Doom") then return end
			end
		end
		
		if CJ_HB("Shadow Trance") then
			if CJ_Cast("Shadow Bolt") then return end
		end
		
		if CJ_Cast("Fel Flame") then return end
		return
	end
	
	if select(1,UnitChannelInfo("player")) == "Drain Soul" and CJ_HP("target") < 3 then return end;
	
	if not CJ_OD("Curse of the Elements") and not CJ_OD("Jinx: Curse of the Elements") then
		if CJ_Cast("Curse of the Elements") then return end;
	end
	
	if cj_aoemode then
		if PlayerToTarget < 10 then
			if CJ_Cast("Shadowflame") then return end;
		end
		if CJ_Cast("Soulburn") then return end;

		if not CJ_HD("Seed of Corruption") then
			if CJ_Cast("Seed of Corruption") then return end;
		end
		
	end
	
	if (CJ_DTR("Corruption") > 0 and CJ_DTR("Unstable Affliction") > 0 and CJ_DTR("Haunt") > 0 and 
	(CJ_DTR("Bane of Agony") > 0 or CJ_DTR("Bane of Doom") > 0)) and cj_cooldowns then
		CJ_Cast("Demon Soul");
	end

	if not CJ_HD("Shadow and Flame") and (GetTime() - lastsboltcast > 2.5) then
		if CJ_Cast("Shadow Bolt") then lastsboltcast = GetTime() return end;
	end

	if (not CJ_HD("Haunt")) or (CJ_DTR("Haunt") - (select(7,GetSpellInfo("Haunt"))/1000)) < 4 and (GetTime() - lasthauntcast > 2.5) then
		if CJ_Cast("Haunt") then lasthauntcast = GetTime() return end
	end
	
	if CJ_DTR("Corruption") < 2 then
		if CJ_Cast("Corruption") then return end;
	end
	
	if CJ_HB("Fel Spark") and CJ_DTR("Unstable Affliction") < 8 and CJ_HD("Unstable Affliction") then
		if CJ_Cast("Fel Flame") then return end;
	end

	if (CJ_DTR("Unstable Affliction") - (select(7,GetSpellInfo("Unstable Affliction"))/1000)) < 3 and (GetTime() - lastuacast > 2.5) then
		if CJ_Cast("Unstable Affliction") then lastuacast = GetTime() return end
	end
	
	if hasFocus or not CJ_IsBoss() or (CJ_IsBoss() and UnitHealth("target") < 60000) then
		if not CJ_HD("Bane of Agony") then
			if CJ_Cast("Bane of Agony") then return end;
		end
	else
	        if not CJ_HD("Bane of Doom") then 
			if CJ_Cast("Bane of Doom") then return end;
		end
	end
		
	if not (UnitGUID("target") == (UnitGUID("focus"))) and hasFocus and not CJ_HB("Soul Swap")
		and not (UnitDebuff("focus","Fear") or UnitDebuff("focus","Banish") or UnitDebuff("focus","Howl of Terror") or UnitDebuff("focus","Seduction")) then
		if CJ_CastTarget("Soul Swap","target") then soulswap = true return end
	end
	
	if CJ_HP("target") < 25 and (select(1,UnitChannelInfo("player")) ~= "Drain Soul") then
		if CJ_Cast("Drain Soul") then return end
	end
	
	if select(1,UnitChannelInfo("player")) == "Drain Soul" then return end
	
	if PlayerToTarget < 10 then
		if CJ_Cast("Shadowflame") then return end;
	end
	
	if CJ_HB("Shadow Trance") then
		if CJ_Cast("Shadow Bolt") then return end
	end
	
	if not CJ_HB("Demon Soul: Felhunter") and cj_cooldowns then
		if CJ_Cast("Soulburn") then return end
	end
	
	if CJ_HB("Soulburn") then
		if CJ_Cast("Soul Fire") then return end
	end
	
	if CJ_HB("Shadow Trance") then
		if CJ_Cast("Shadow Bolt") then return end
	end

	if not UnitCastingInfo("player") then
		if CJ_Cast("Shadow Bolt") then return end
	end
end

-----------------------------
---------Destruction---------
-----------------------------
function CJ_DestroBuffs()
	if not CJ_HB("Fel Armor") then
		if CJ_Cast("Fel Armor") then return true end
	end
	return false
end

function CJDestLockRot()
	if CJ_OC() then StopAttack() return end
	if AmIFacing == false then return end;
	
	if not IsPetAttackActive() then
		PetAttack("target")
	end
	
	if not CJ_GCD() then return end;
	if CJ_Casting() then return end
	if CJ_DestroBuffs() then return end;
	
	if UnitPower("player") < ((UnitHealthMax("player")*.15)*1.4)  and CJ_HP("player") > 20 and cj_lifetap then
		if CJ_Cast("Life Tap") then return end
	end
	
	if IsSpellInRange("Fel Flame") == 0 then return end;
	
	if GetUnitSpeed("player") > 0 then
		if CJ_HD("Immolate") and CJ_DTR("Immolate") < 8 then
			if CJ_Cast("Fel Flame") then return end
		end
		
		if not CJ_OD("Curse of the Elements") and not CJ_OD("Jinx: Curse of the Elements") then
			if CJ_Cast("Curse of the Elements") then return end;
		end
		
		if CJ_DTR("Corruption") < 2 then
			if CJ_Cast("Corruption") then return end;
		end
		
		if not CJ_HD("Bane of Doom") then
			if CJ_Cast("Bane of Doom") then return end
		end
			
		if CJ_Cast("Fel Flame") then return end
		return
	end
	
	if not CJ_OD("Curse of the Elements") and not CJ_OD("Jinx: Curse of the Elements") then
		if CJ_Cast("Curse of the Elements") then return end;
	end
	
        if (CJ_BTR("Improved Soul Fire") - ((select(7,GetSpellInfo("Soul Fire"))/1000)) + .5) < 5 and (GetTime() - lastsoulfirecast > 3.5) then
		if CJ_Cast("Soul Fire") then lastsoulfirecast = GetTime() return end
	end

	if cj_cooldowns then
		if CJ_Cast("Demon Soul") then return end
		if not CJ_Hero() then
			if CJ_Cast("Soulburn") then return end
		end
	end

        if CJ_HB("Fel Spark") and CJ_DTR("Immolate") < 8 and CJ_HD("Immolate") then
		if CJ_Cast("Fel Flame") then return end;
	end
	
	if (CJ_DTR("Immolate") - (select(7,GetSpellInfo("Immolate"))/1000)) < 2 and (GetTime() - lastimmolatecast > 2.5) then
		if CJ_Cast("Immolate") then lastimmolatecast = GetTime() return end
	end

        if CJ_Cast("Conflagrate") then return end

        if not CJ_HD("Bane of Doom") then
		if CJ_Cast("Bane of Doom") then return end
	end
	
	if CJ_DTR("Corruption") < 2 then
		if CJ_Cast("Corruption") then return end;
	end

        if PlayerToTarget < 10 then
		if CJ_Cast("Shadowflame") then return end
	end

        if CJ_HB("Empowered Imp") and (CJ_BTR("Empowered Imp") < CJ_BTR("Improved Soul Fire") + .5) then
		if CJ_Cast("Soul Fire") then return end
	end

        if CJ_Cast("Chaos Bolt") then return end

        if CJ_HP("target") < 20 and CJ_Cast("Shadowburn") then return end

        if CJ_Cast("Incinerate") then return end
end

-----------------------------
---------Demonology----------
-----------------------------
function CJ_DemoBuffs()
	if not CJ_HB("Fel Armor") then
		if CJ_Cast("Fel Armor") then return true end
	end
	return false
end

function CJDemoLockRot()
	if CJ_OC() then StopAttack() return end
	CJ_PetInterrupt("Spell Lock");
	
	if not IsPetAttackActive() and not cj_aoemode then
		PetAttack("target")
	end
	
	if AmIFacing == false then return end;
	
	if not CJ_GCD() then return end;
	if CJ_Casting() then return end
	if CJ_DemoBuffs() then return end;
	
	if UnitPower("player") < ((UnitHealthMax("player")*.15)*1.4)  and CJ_HP("player") > 20 and cj_lifetap then
		if CJ_Cast("Life Tap") then return end
	end
	
	if IsSpellInRange("Fel Flame") == 0 then return end;
	CJ_OffensiveDispelPet("Devour Magic");
	if GetUnitSpeed("player") > 0 then
		if CJ_HD("Immolate") and CJ_DTR("Immolate") < 8 then
			if CJ_Cast("Fel Flame") then return end
		end
		
		if not CJ_OD("Curse of the Elements") and not CJ_OD("Jinx: Curse of the Elements") then
			if CJ_Cast("Curse of the Elements") then return end;
		end
		
		if CJ_DTR("Corruption") < 2 then
			if CJ_Cast("Corruption") then return end;
		end
		
		if not CJ_HD("Bane of Doom") then
			if CJ_Cast("Bane of Doom") then return end
		end
			
		if CJ_Cast("Fel Flame") then return end
		return
	end
	
	if not CJ_OD("Curse of the Elements") and not CJ_OD("Jinx: Curse of the Elements") then
		if CJ_Cast("Curse of the Elements") then return end;
	end
	
	if cj_cooldowns then
		if CJ_Cast("Metamorphosis") then return end
		if CJ_Cast("Demon Soul") then return end
	end

	if cj_aoemode and PlayerToTarget < 7 then
		if CJ_Cast("Hellfire") then return end
		if CJ_Cast("Felstorm") then PetFollow() return end
	end
	
	if cj_aoemode then
		if CJ_Cast("Felstorm") then return end
	end
	
	if (CJ_DTR("Corruption") > 0 and (CJ_DTR("Bane of Agony") > 0 or CJ_DTR("Bane of Doom") > 0)) and cj_cooldowns then
		CJ_Cast("Demon Soul");
	end
	
	if CJ_BTR("Metamorphosis") > 10 and PlayerToTarget <= 8 then
		if CJ_Cast("Immolation Aura") then return end
	end
	
	if not CJ_HD("Bane of Doom") then
		if CJ_Cast("Bane of Doom") then return end
	end
	
	if not CJ_HD("Immolate") and GetTime() - lastimmolatecast > 4 then
		if CJ_Cast("Immolate") then lastimmolatecast = GetTime() return end
	end

	if CJ_Cast("Hand of Gul'dan") then return end
	
	if CJ_DTR("Corruption") < 3 then
		if CJ_Cast("Corruption") then return end
	end
	
	if CJ_HB("Fel Spark") then
		if CJ_Cast("Fel Flame") then return end
	end
	
	if PlayerToTarget < 10 then
		if CJ_Cast("Shadowflame") then return end
	end
	
	if CJ_HB("Molten Core") then
		if CJ_Cast("Incinerate") then return end
	end
	
	if cj_cooldowns then
		if CJ_Cast("Soulburn") then return end
	end
	
	if CJ_HB("Decimation") or CJ_HB("Soulburn") then
		if CJ_Cast("Soul Fire") then return end
	end
	
	if CJ_Cast("Shadow Bolt") then return end
end