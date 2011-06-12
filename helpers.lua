--Helper Functions
cj_class = "";
cj_currentRotation = 0;


function CJ_IsRaidBoss()
	if UnitClassification("target") == "worldboss" then return true else return false end
end

function CJ_IsBoss()
	if tableContains(cj_bosslist,UnitName("target")) then return true else return false end
end

-------------------
----Buff Checks----
-------------------

--Buff Stacks
function CJ_BS(buff)
	local name,_,_,count = UnitBuff("player",buff);
	if not name then return 0 end
	return count
end

--Buff Time Remaining
function CJ_BTR(buff)
	local name,_,_,_,_,_,expiration = UnitBuff("player",buff);
	if not name then return 0 end
	return (expiration - GetTime());
end

--Has Buff
function CJ_HB(buff)
	if not UnitBuff("player",buff) then return false else return true end;
end

function CJ_Hero()
	if CJ_HB("Heroism") or CJ_HB("Time Warp") or CJ_HB("Ancient Hysteria") or CJ_HB("Bloodlust") then
		return true;
	else
		return false;
	end
end

-------------------
--Debuff Checks----
-------------------

--Debuff is on target (Doesn't have to be ours)
function CJ_OD(debuff)
	if not UnitDebuff("target",debuff) then return false else return true end;
end

--Debuff Stacks
function CJ_DS(debuff)
	local rank = select(2,UnitDebuff("target",debuff));
	if not rank then return 0 end
	local name,_,_,count = UnitDebuff("target",debuff,rank,"PLAYER");
	if not name then return 0 end
	return count;
end

--Debuff Time Remaining
function CJ_DTR(debuff)
	local rank = select(2,UnitDebuff("target",debuff));
	if not rank then return 0 end
	local name,_,_,_,_,_,expiration = UnitDebuff("target",debuff,rank,"PLAYER");
	if not name then return 0 end
	return (expiration - GetTime());
end

--Has Debuff
function CJ_HD(debuff)
	local rank = select(2,UnitDebuff("target",debuff));
	if not rank then return false end
	if not UnitDebuff("target",debuff,rank,"PLAYER") then return false else return true end;
end

--Has Debuff Override (For Arcane Blast)
function CJ_HSD(debuff)
	if not UnitDebuff("player",debuff) then return false else return true end;
end

function CJ_SDS(debuff)
	local name,_,_,count = UnitDebuff("player",debuff);
	if not name then return 0 end
	return count
end

-------------
-----HP/MP---
-------------

--Health Percent
function CJ_HP(unit)
	return (((UnitHealth(unit) / UnitHealthMax(unit)) * 100));
end

--Mana Percent
function CJ_MP(unit)
	return (((UnitPower(unit) / UnitPowerMax(unit)) * 100));
end

------------------
--Spell Functions-
------------------

--Cast Spell
function CJ_Cast(spell,arg1,arg2)
	local usable,mana = IsUsableSpell(spell)
	
	if usable and mana == nil then
		if GetSpellCooldown(spell) == 0 then
			CastSpellByName(spell)
			if cj_verbose then
				printf("Casting: "..spell);
			end
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

function CJ_CastTarget(spell,target)
	local usable,mana = IsUsableSpell(spell)
	
	if usable and mana == nil then
		if GetSpellCooldown(spell) == 0 then
			CastSpellByName(spell,target)
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

--Spell Cooldown
function CJ_CD(spell)
	local start,duration,enable = GetSpellCooldown(spell);
	if start == nil then return 99999 end
	
	if start == 0 then
		return 0;
	else
		return duration - (GetTime() - start);
	end
end

--Already Casting
function CJ_Casting()
	if UnitCastingInfo("player") ~= nil then
		if (select(6,UnitCastingInfo("player")) - 30) - (GetTime()*1000) - select(4,GetNetStats()) < 0 then return false else return true end;
	elseif UnitChannelInfo("player") ~= nil then
		if UnitChannelInfo("player") == "Drain Soul" then return false end
		if (select(6,UnitChannelInfo("player")) - 30) - (GetTime()*1000)  - select(4,GetNetStats()) < 0 then return false else return true end;
	end
	return false;
end

--Interrupt Checks
function CJ_Interrupt(spell)
	if not IsUsableSpell(spell) then return end;
	if not cj_interruptmode then return end;
	if CJ_CD(spell) ~= 0 then return end;
	
	if not UnitExists("focus") or not UnitCanAttack("player","focus") then		
		if UnitCastingInfo("target") and select(9,UnitCastingInfo("target")) == false then
			if not tableContains(cj_interruptBlacklist[UnitName("target")],UnitCastingInfo("target")) and IsSpellInRange(spell,"target") then CJ_Cast(spell) else return end;
		end
		
		if UnitChannelInfo("target") and select(8,UnitChannelInfo("target")) == false then
			if not tableContains(cj_interruptBlacklist[UnitName("target")],UnitChannelInfo("target")) and IsSpellInRange(spell,"target") then CJ_Cast(spell) else return end;
		end
	else
		if UnitCastingInfo("focus") and select(9,UnitCastingInfo("focus")) == false then
			if not tableContains(cj_interruptBlacklist[UnitName("focus")],UnitCastingInfo("focus")) and IsSpellInRange(spell,"focus") then CJ_CastTarget(spell,"focus") else return end;
		end
		
		if UnitChannelInfo("focus") and select(8,UnitChannelInfo("focus")) == false then
			if not tableContains(cj_interruptBlacklist[UnitName("focus")],UnitChannelInfo("focus")) and IsSpellInRange(spell,"focus") then CJ_CastTarget(spell,"focus") else return end;
		end
	end
end

function CJ_PetSpell(spell)
	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		if (select(1,GetPetActionInfo(i))) == spell then
			CastPetAction(i);
			return true;
		end
	end
	return false;
end

function CJ_PetSpellFocus(spell)
	if not CJ_PetUsable(spell) then return false end;
	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		if (select(1,GetPetActionInfo(i))) == spell then
			CastPetAction(i,"focus");
			return true;
		end
	end
	return false;
end

function CJ_PetUsable(spell)
	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		if (select(1,GetPetActionInfo(i))) == spell then
			if GetPetActionCooldown(i) == 0 then return true else return false end;
		end
	end
	return false;
end

function CJ_PetInterrupt(spell)
	if not CJ_PetUsable(spell) then return end;
	if not cj_interruptmode then return end;
	--if CJ_CD(spell) ~= 0 then return end;
	if not UnitExists("focus") or not UnitCanAttack("player","focus") then		
		if UnitCastingInfo("target") and select(9,UnitCastingInfo("target")) == false then
			if not tableContains(cj_interruptBlacklist[UnitName("target")],UnitCastingInfo("target")) and IsSpellInRange(spell,"target") then CJ_PetSpell(spell) else return end;
		end
		
		if UnitChannelInfo("target") and select(8,UnitChannelInfo("target")) == false then
			if not tableContains(cj_interruptBlacklist[UnitName("target")],UnitChannelInfo("target")) and IsSpellInRange(spell,"target") then CJ_PetSpell(spell) else return end;
		end
	else
		if UnitCastingInfo("focus") and select(9,UnitCastingInfo("focus")) == false then
			if not tableContains(cj_interruptBlacklist[UnitName("focus")],UnitCastingInfo("focus")) and IsSpellInRange(spell,"focus") then CJ_PetSpellFocus(spell) else return end;
		end
		
		if UnitChannelInfo("focus") and select(8,UnitChannelInfo("focus")) == false then
			if not tableContains(cj_interruptBlacklist[UnitName("focus")],UnitChannelInfo("focus")) and IsSpellInRange(spell,"focus") then CJ_PetSpellFocus(spell) else return end;
		end
	end
	return;
end
--table.contains helper
function tableContains(t,element)
	if t == nil then return false end;
	for key, value in pairs(t) do
		if value == element then
			return true
		end
	end
	return false
end

--Shaman Totem Manager
function CJ_Totems()
	if cj_lastcall == nil then
		if cj_aoemode then
			if CJ_Cast("Call of the Ancestors") then return true end
		else
			if CJ_Cast("Call of the Elements") then return true end	
		end
	end
	
	
	if GetTime() - cj_lastcall > 2 and GetTime() - cj_lastcall < 4.5 then
		for i =1,4 do
			local a,b,c,d = GetTotemInfo(i);
			if i == 1 then
				cj_firetotem = b;
			elseif i == 2 then
				cj_earthtotem = b;
			elseif i == 3 then
				cj_watertotem = b;
			else
				cj_airtotem = b;
			end
		end
	elseif GetTime() - cj_lastcall < 4.5 then
		return false
	end
	
	local countTotem = 0;
	local updateFire = false;
	local updateEarth = false;
	local updateAir = false;
	local updateWater = false;
	
	local _,fireTotem = GetTotemInfo(1);
	local _,earthTotem = GetTotemInfo(2);
	local _,waterTotem = GetTotemInfo(3);
	local _,airTotem = GetTotemInfo(4);
	
	if fireTotem ~= cj_firetotem then
		if fireTotem ~= "Fire Elemental Totem" then
			updateFire = true;
			countTotem = countTotem + 1;
		end
	end
	
	if earthTotem ~= cj_earthtotem then
		if earthTotem ~= "Earthbind Totem" and earthTotem ~= "Earth Elemental Totem" then
			updateEarth = true;
			countTotem = countTotem + 1;
		end
	end
	
	if waterTotem ~= cj_watertotem then
		if waterTotem ~= "Mana Tide Totem" then
			updateWater = true;
			countTotem = countTotem + 1;
		end
	end
	
	if airTotem ~= cj_airtotem then
		if airTotem ~= "Spirit Link Totem" then
			updateAir = true;
			countTotem = countTotem + 1;
		end
	end
	
	if countTotem == 0 then 
		return false;
	elseif countTotem == 1 then
		if updateFire then if CJ_Cast(cj_firetotem) then return true end end;
		if updateWater then if CJ_Cast(cj_watertotem) then return true end end;
		if updateEarth then if CJ_Cast(cj_earthtotem) then return true end end;
		if updateAir then if CJ_Cast(cj_airtotem) then return true end end;
	else
		if fireTotem ~= "Fire Elemental Totem" and earthTotem ~= "Earth Elemental Totem" and earthTotem ~= "Earthbind Totem" and waterTotem ~= "Mana Tide Totem" and airTotem ~= "Spirit Link Totem" then
			if cj_aoemode then
				if CJ_Cast("Call of the Ancestors") then return true end				
			else
				if CJ_Cast("Call of the Elements") then return true end
			end
		else
			if updateFire then if CJ_Cast(cj_firetotem) then return true end end;
			if updateWater then if CJ_Cast(cj_watertotem) then return true end end;
			if updateEarth then if CJ_Cast(cj_earthtotem) then return true end end;
			if updateAir then if CJ_Cast(cj_airtotem) then return true end end;
		end
	end
	
	return false;
end

function CJ_SelectSpec()
	cj_class = UnitClass("player");
	c = cj_class;
	printf("Class detected as "..cj_class);
	local tt = GetPrimaryTalentTree();
	if tt == nil then cj_action = false; printf("No primary talent tree") return end;
	if c == "Death Knight" then
		cj_currentRotation = 10 + tt;
	elseif c == "Druid" then
		cj_currentRotation = 20 + tt;
	elseif c == "Hunter" then
		cj_currentRotation = 30 + tt;
	elseif c == "Mage" then
		cj_currentRotation = 40 + tt;
	elseif c == "Paladin" then
		cj_currentRotation = 50 + tt;
	elseif c == "Priest" then
		cj_currentRotation = 60 + tt;
	elseif c == "Rogue" then
		cj_currentRotation = 70 + tt;
	elseif c == "Shaman" then
		cj_currentRotation = 80 + tt;
	elseif c == "Warlock" then
		cj_currentRotation = 90 + tt;
	elseif c == "Warrior" then
		cj_currentRotation = 100 + tt;
	end
	if cj_rotationTable[cj_currentRotation] == nil then CJActionButton:Disable(); else CJActionButton:Enable() end
end

--Offensive Dispels
function CJ_OffensiveDispel(spell)
	if UnitIsPlayer("target") and not cj_purgeplayers then return false end;
	if not cj_purgemode then return false end;
	if cj_class == "Shaman" then
		for i = 1,40 do
			local _,_,_,_,dispelType = UnitBuff("target",i);
			
			if dispelType == "Magic" then
				return CJ_Cast(spell)
			end
		end
	elseif cj_class == "Priest" then
		for i = 1,40 do
			local _,_,_,_,dispelType = UnitBuff("target",i);
			
			if dispelType == "Magic" then
				return CJ_Cast(spell)
			end
		end
	elseif cj_class == "Mage" then
		for i = 1,40 do
			if select(9,UnitAura("target",i)) == 1 or select(9,UnitBuff("target",i)) == 1 then
				return CJ_Cast(spell)
			end
		end
	elseif cj_class == "Hunter" then
		for i = 1,40 do
			if select(5,UnitBuff("target",i)) == "Magic" then
				return CJ_Cast(spell)
			end
			
			if enrageEffectIDs[select(11,UnitBuff("target",i))] then
				return CJ_Cast(spell)
			end
		end
	elseif cj_class == "Rogue" then
		for i = 1,40 do
			if enrageEffectIDs[select(11,UnitBuff("target",i))] then
				return CJ_Cast(spell)
			end
		end
	end
	return false;
end

-----------------------
-----Decurse-----------
-----------------------
function CJ_DecurseSelf()
	if cj_class == "Mage" then
		for i = 1,40 do
			if select(5,UnitDebuff("player",i)) == "Curse" then
				return CJ_CastTarget("Remove Curse","player")
			end
		end
	elseif cj_class == "Priest" then
		for i = 1,40 do
			if select(5,UnitDebuff("player",i)) == "Magic" then
				return CJ_CastTarget("Dispel Magic","player")
			end
			
			if select(5,GetTalentInfo(2,14,false,false,nil)) > 0 then
				if select(5,UnitDebuff("player",i)) == "Poison" then
					return CJ_CastTarget("Cure Disease","player")
				end
			end
			
			if cj_currentRotation == 61 or cj_currentRotation == 62 then
				if select(5,UnitDebuff("player",i)) == "Disease" then
					return CJ_CastTarget("Cure Disease","player")
				end
			end
		end
	elseif cj_class == "Paladin" then
		for i = 1,40 do
			if select(5,UnitDebuff("player",i)) == "Poison" then
				return CJ_CastTarget("Cleanse","player")
			end
			
			if select(5,UnitDebuff("player",i)) == "Disease" then
				return CJ_CastTarget("Cleanse","player")
			end
			
			if select(5,GetTalentInfo(1,14,false,false,nil)) > 0 then
				if select(5,UnitDebuff("player",i)) == "Magic" then
					return CJ_CastTarget("Cleanse","player")
				end
			end
		end
	elseif cj_class == "Shaman" then
		for i = 1,40 do
			if select(5,UnitDebuff("player",i)) == "Curse" then
				return CJ_CastTarget("Cleanse Spirit","player")
			end
			
			if select(5,GetTalentInfo(3,12,false,false,nil)) > 0 then
				if select(5,UnitDebuff("player",i)) == "Magic" then
					return CJ_CastTarget("Cleanse Spirit","player")
				end
			end
		end
	elseif cj_class == "Druid" then
		for i = 1,40 do
			if select(5,UnitDebuff("player",i)) == "Curse" then
				return CJ_CastTarget("Remove Corruption","player")
			end
			
			if select(5,UnitDebuff("player",i)) == "Poison" then
				return CJ_CastTarget("Remove Corruption","player")
			end
			
			if select(5,GetTalentInfo(3,17,false,false,nil)) > 0 then
				if select(5,UnitDebuff("player",i)) == "Magic" then
					return CJ_CastTarget("Remove Corruption","player")
				end
			end
		end
	end
end

function CJ_DecurseAll()
	if GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0 then return end
	local count = 0
	local grouptype = "raid"
	count = GetNumRaidMembers()
	if count == 0 then
		grouptype = "party"
		count = GetNumPartyMembers()
	end
		
	if cj_class == "Mage" then
		for i = 1,count do
			for j = 1,40 do
				if select(5,UnitDebuff(grouptype..i,j)) == "Curse" then
					return CJ_CastTarget("Remove Curse",grouptype..i)
				end
			end
		end
	elseif cj_currentRotation == 61 or cj_currentRotation == 62 then
		for i = 1,count do
			for j = 1,40 do
				if select(5,UnitDebuff(grouptype..i,j)) == "Magic" then
					return CJ_CastTarget("Remove Curse",grouptype..i)
				end
				
				if select(5,UnitDebuff(grouptype..i,j)) == "Disease" then
					return CJ_CastTarget("Cure Disease",grouptype..i)
				end
			end
		end
	elseif cj_class == "Paladin" then
		for i = 1,count do
			for j = 1,40 do
				if select(5,UnitDebuff(grouptype..i,j)) == "Curse" then
					return CJ_CastTarget("Remove Corruption",grouptype..i)
				end
				
				if select(5,UnitDebuff(grouptype..i,j)) == "Disease" then
					return CJ_CastTarget("Remove Corruption",grouptype..i)
				end
				
				if select(5,GetTalentInfo(1,14,false,false,nil)) > 0 then
					if select(5,UnitDebuff(grouptype..i,j)) == "Magic" then
						return CJ_CastTarget("Cleanse",grouptype..i)
					end
				end
			end
		end
	elseif cj_class == "Shaman" then
		for i = 1,count do
			for j = 1,40 do
				if select(5,GetTalentInfo(3,12,false,false,nil)) > 0 then
					if select(5,UnitDebuff(grouptype..i,j)) == "Magic" then
						return CJ_CastTarget("Cleanse Spirit",grouptype..i)
					end
				end
				
				if select(5,UnitDebuff(grouptype..i,j)) == "Curse" then
					return CJ_CastTarget("Cleanse Spirit",grouptype..i)
				end
			end
		end
	elseif cj_class == "Druid" then
		for i =1,count do
			for j = 1,40 do
				if select(5,UnitDebuff(grouptype..i,j)) == "Curse" then
					return CJ_CastTarget("Remove Corruption",grouptype..i)
				end
				
				if select(5,UnitDebuff(grouptype..i,j)) == "Poison" then
					return CJ_CastTarget("Remove Corrruption",grouptype..i)
				end
				
				if select(5,GetTalentInfo(3,17,false,false,nil)) > 0 then
					if select(5,UnitDebuff(grouptype..i,j)) == "Magic" then
						return CJ_CastTarget("Remove Corruption",grouptype..i)
					end
				end
			end		
		end
	end
end

function CJ_OffensiveDispelPet(spell)
	if UnitIsPlayer("target") and not cj_purgeplayers then return false end;
	if not cj_purgemode then return false end;
	if cj_class == "Warlock" then
		if not CJ_PetUsable(spell) then return false end;
		for i = 1,40 do
			local _,_,_,_,dispelType = UnitBuff("target",i);
			if dispelType == "Magic" then
				return CJ_PetSpell(spell)
			end
		end
	end
	
	return false;
end
--Global Cooldown Check
function CJ_GCD()
	if GetSpellCooldown(61304) == 0 then
		return true;
	end
	
	return false;
end

--print
function printf(message)
	DEFAULT_CHAT_FRAME:AddMessage(message);
end

function CJ_T(tree,talent)
	return select(5,GetTalentInfo(tree,talent,false,false,nil))
end