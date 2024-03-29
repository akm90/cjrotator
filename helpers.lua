--Helpers File
cj_class = "";
cj_currentRotation = 0;
local tempOverride = false;

function CJ_BuffInfo(unit,buff)
	local name,_,_,count,_,_,expiration,_,_,_,_ = UnitBuff(unit,buff);
	if not name then return 0,0 end
	return count,(expiration - GetTime());
end

function CJ_HasBuff(unit,buff)
	local name = UnitBuff(unit,buff);
	if not name then return false else return true end;
end

function CJ_HasDebuff(unit,debuff)
	local name = UnitDebuff(unit,debuff,select(2,UnitDebuff(unit,debuff)),"PLAYER");
	if not name then return false else return true end;
end

function CJ_HasOtherDebuff(unit,debuff)
	local name = UnitDebuff(unit,debuff)
	if not name then return false else return true end;
end

function CJ_DebuffInfo(unit,debuff)
	local rank = select(2,UnitDebuff(unit,debuff));
	if not rank then return 0,0 end
	local name,_,_,count,_,_,expiration = UnitDebuff(unit,debuff,rank,"PLAYER");
	if not name then return 0,0 end
	return count,(expiration - GetTime())
end

function CJHealthPercent(unit)
	return (((UnitHealth(unit) / UnitHealthMax(unit)) * 100));
end

function CJManaPercent(unit)
	return (((UnitPower(unit) / UnitPowerMax(unit)) * 100));
end

function CastSpell(spell)
	if select(2,IsUsableSpell(spell)) == nil then
		CastSpellByName(spell);
	end
end

function CJ_DetectHero()
	if CJ_HasBuff("player","Heroism") or CJ_HasBuff("player","Time Warp") or CJ_HasBuff("player","Ancient Hysteria") or CJ_HasBuff("player","Bloodlust") then
		return true;
	else
		return false;
	end
end

function CJCooldown(spell)
	local start,duration,enable = GetSpellCooldown(spell);
	
	if start == 0 then
		return 0;
	else
		return duration - (GetTime() - start);
	end
end

function CJ_CheckMyCast()
	if UnitCastingInfo("player") then
		if GetTime() - (select(6,UnitCastingInfo("player")) - 30) - select(4,GetNetStats()) > 0 then return false else return true end;
	elseif UnitChannelInfo("player") then
		if GetTime() - (select(6,UnitChannelInfo("player")) - 30) - select(4,GetNetStats()) > 0 then return false else return true end;
	end
	return true;
end

function CJ_Interrupt()
	if not UnitExists("focus") or not UnitCanAttack("player","focus") then		
		if UnitCastingInfo("target") and select(9,UnitCastingInfo("target")) == false then
			if not tableContains(cj_interruptBlacklist[UnitName("target")],UnitCastingInfo("target")) then return "target" else return false end;
		end
		
		if UnitChannelInfo("target") and select(8,UnitChannelInfo("target")) == false then
			if not tableContains(cj_interruptBlacklist[UnitName("target")],UnitChannelInfo("target")) then return "target" else return false end;
		end
		
		return false;
	else
		if UnitCastingInfo("focus") and select(9,UnitCastingInfo("focus")) == false then
			if not tableContains(cj_interruptBlacklist[UnitName("focus")],UnitCastingInfo("focus")) then return "focus" else return false end;
		end
		
		if UnitChannelInfo("focus") and select(8,UnitChannelInfo("focus")) == false then
			if not tableContains(cj_interruptBlacklist[UnitName("focus")],UnitChannelInfo("focus")) then return "focus" else return false end;
		end
		
		return false;
	end
end

function tableContains(t,element)
	if t == nil then return false end;
	for key, value in pairs(t) do
		if value == element then
			return true
		end
	end
	return false
end

function CJ_UpdateTotems()
	if cj_lastcall == nil then
		if cj_aoemode then
			CastSpell("Call of the Ancestors");
			return true;
		else
			CastSpell("Call of the Elements");
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
		if updateFire then CastSpell(cj_firetotem) return true end;
		if updateWater then CastSpell(cj_watertotem) return true end;
		if updateEarth then CastSpell(cj_earthtotem) return true end;
		if updateAir then CastSpell(cj_airtotem) return true end;
	else
		if fireTotem ~= "Fire Elemental Totem" and earthTotem ~= "Earth Elemental Totem" and earthTotem ~= "Earthbind Totem" and waterTotem ~= "Mana Tide Totem" and airTotem ~= "Spirit Link Totem" then
			if cj_aoemode then
				CastSpell("Call of the Ancestors")
				return true;
			else
				CastSpell("Call of the Elements");
				return true;
			end
		else
			if updateFire then CastSpell(cj_firetotem) return true end;
			if updateWater then CastSpell(cj_watertotem) return true end;
			if updateEarth then CastSpell(cj_earthtotem) return true end;
			if updateAir then CastSpell(cj_airtotem) return true end;
		end
	end
	
	return false;
end

function CJ_SelectSpec()
	cj_class = UnitClass("player");
	c = cj_class;
	printf("cj_class detected as "..cj_class);
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
end

function CJ_OffensiveDispel()
	if UnitIsPlayer("target") and not CJ_PURGEPLAYERS then return false end;
	if cj_class == "Shaman" then
		for i = 1,40 do
			local _,_,_,_,dispelType = UnitBuff("target",i);
			
			if dispelType == "Magic" then
				return true;
			end
		end
	elseif cj_class == "Priest" then
		for i = 1,40 do
			local _,_,_,_,dispelType = UnitBuff("target",i);
			
			if dispelType == "Magic" then
				return true;
			end
		end
	elseif cj_class == "Mage" then
		for i = 1,40 do
			if select(9,UnitAura("target",i)) == 1 or select(9,UnitBuff("target",i)) == 1 then
				return true;
			end
		end
	end
	
	return false;
end

function CJ_GCD()
	if GetSpellCooldown(61304) == 0 then
		return true;
	end
	
	return false;
end

function printf(message)
	DEFAULT_CHAT_FRAME:AddMessage(message);
end