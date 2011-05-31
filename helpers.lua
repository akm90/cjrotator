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
	if CJ_HasBuff("player","Heroism") or CJ_HasBuff("player","Time Warp") or CJ_HasBuff("player","Ancient Hysteria") or CJ_HasBuff("player","Bloodlust") then
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
function CJ_Cast(spell)
	local usable,mana = IsUsableSpell(spell)
	
	if usable and mana == nil then
		if GetSpellCooldown(spell) == 0 then
			CastSpellByName(spell)
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
	
	if start == 0 then
		return 0;
	else
		return duration - (GetTime() - start);
	end
end

--Already Casting
function CJ_Casting()
	if UnitCastingInfo("player") then
		if (GetTime()*1000) - (select(6,UnitCastingInfo("player")) - 30) - select(4,GetNetStats()) > 0 then return false else return true end;
	elseif UnitChannelInfo("player") then
		if (GetTime()*1000) - (select(6,UnitChannelInfo("player")) - 30) - select(4,GetNetStats()) > 0 then return false else return true end;
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
			CJ_Cast("Call of the Ancestors");
			return true;
		else
			CJ_Cast("Call of the Elements");
			return true;
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
		if updateFire then CJ_Cast(cj_firetotem) return true end;
		if updateWater then CJ_Cast(cj_watertotem) return true end;
		if updateEarth then CJ_Cast(cj_earthtotem) return true end;
		if updateAir then CJ_Cast(cj_airtotem) return true end;
	else
		if fireTotem ~= "Fire Elemental Totem" and earthTotem ~= "Earth Elemental Totem" and earthTotem ~= "Earthbind Totem" and waterTotem ~= "Mana Tide Totem" and airTotem ~= "Spirit Link Totem" then
			if cj_aoemode then
				CJ_Cast("Call of the Ancestors")
				return true;
			else
				CJ_Cast("Call of the Elements");
				return true;
			end
		else
			if updateFire then CJ_Cast(cj_firetotem) return true end;
			if updateWater then CJ_Cast(cj_watertotem) return true end;
			if updateEarth then CJ_Cast(cj_earthtotem) return true end;
			if updateAir then CJ_Cast(cj_airtotem) return true end;
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
	CJClassTogHandler()
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