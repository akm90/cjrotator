--Helpers File
class = "";
currentRotation = 0;

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
	if CJ_HasBuff("player","Heroism") or CJ_HasBuff("player","Time Warp") or CJ_HasBuff("player","Ancient Hysteria") then
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
	if UnitChannelInfo("player") or UnitCastingInfo("player") then return false else return true end;
end

function CJ_Interrupt()
	if not UnitExists("focus") or not UnitCanAttack("player","focus") then
		local un = UnitName("target");
		local name1,_,_,_,_,_,_,_,interrupt1 = UnitCastingInfo("target");
		local name2,_,_,_,_,_,_,_,interrupt2 = UnitChannelInfo("target");
		
		if (not name1 or name2) or (interrupt1 or interrupt2) then return false end;
		if tableContains(cj_interruptBlacklist[un],name1) or tableContains(cj_interruptBlacklist[un],name2) then return false end;
		return "target";
	else
		local un = UnitName("focus");
		local name1,_,_,_,_,_,_,_,interrupt1 = UnitCastingInfo("focus");
		local name2,_,_,_,_,_,_,_,interrupt2 = UnitChannelInfo("focus");
		
		if (not name1 or name2) or (interrupt1 or interrupt2) then return false end;
		if tableContains(cj_interruptBlacklist[un],name1) or tableContains(cj_interruptBlacklist[un],name2) then return false end;
		return "focus";
	end
	return false;
end

function tableContains(table,element)
	if table == nil then return false end;
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

function CJ_UpdateTotems()
	local countTotem = 0;
	local updateFire = false;
	local updateEarth = false;
	local updateAir = false;
	local updateWater = false;
	
	local _,fireTotem = GetTotemInfo(1);
	local _,earthTotem = GetTotemInfo(2);
	local _,waterTotem = GetTotemInfo(3);
	local _,airTotem = GetTotemInfo(4);
	
	if fireTotem ~= "Fire Elemental Totem" or fireTotem ~= cj_firetotem then
		updateFire = true;
		countTotem = countTotem + 1;
	end
	
	if earthTotem ~= "Earth Elemental Totem" or earthTotem ~= "Earthbind Totem" or earthTotem ~= cj_earthtotem then
		updateEarth = true;
		countTotem = countTotem + 1;
	end
	
	if waterTotem ~= "Mana Tide Totem" or waterTotem ~= cj_watertotem then
		updateWater = true;
		countTotem = countTotem + 1;
	end
	
	if airTotem ~= "Spirit Link Totem" or airTotem ~= cj_airtotem then
		updateAir = true;
		countTotem = countTotem + 1;
	end
	
	if countTotem == 1 then
		if updateFire then CastSpell(cj_firetotem) return end;
		if updateWater then CastSpell(cj_watertotem) return end;
		if updateEarth then CastSpell(cj_earthtotem) return end;
		if updateAir then CastSpell(cj_airtotem) return end;
	else
		if fireTotem ~= "Fire Elemental Totem" and earthTotem ~= "Earth Elemental Totem" and earthTotem ~= "Earthbind Totem" and waterTotem ~= "Mana Tide Totem" and airTotem ~= "Spirit Link Totem" then
			if cj_aoemode then
				CastSpell("Call of the Ancestors")
				return;
			else
				CastSpell("Call of the Elements");
				return;
			end
		else
			if updateFire then CastSpell(cj_firetotem) return end;
			if updateWater then CastSpell(cj_watertotem) return end;
			if updateEarth then CastSpell(cj_earthtotem) return end;
			if updateAir then CastSpell(cj_airtotem) return end;
		end
	end
end

function CJ_SelectSpec()
	class = UnitClass("player");
	c = class;
	printf("Class detected as "..class);
	local tt = GetPrimaryTalentTree();
	if tt == nil then printf("No primary talent tree") return end;
	if c == "Death Knight" then
		currentRotation = 10 + tt;
	elseif c == "Druid" then
		currentRotation = 20 + tt;
	elseif c == "Hunter" then
		currentRotation = 30 + tt;
	elseif c == "Mage" then
		currentRotation = 40 + tt;
	elseif c == "Paladin" then
		currentRotation = 50 + tt;
	elseif c == "Priest" then
		currentRotation = 60 + tt;
	elseif c == "Rogue" then
		currentRotation = 70 + tt;
	elseif c == "Shaman" then
		currentRotation = 80 + tt;
	elseif c == "Warlock" then
		currentRotation = 90 + tt;
	elseif c == "Warrior" then
		currentRotation = 100 + tt;
	end
end

function CJ_OffensiveDispel()
	if class == "Shaman" then
		for i = 1,40 do
			local _,_,_,_,dispelType = UnitBuff("target",i);
			
			if dispelType == "Magic" then
				return true;
			end
		end
	elseif class == "Priest" then
		for i = 1,40 do
			local _,_,_,_,dispelType = UnitBuff("target",i);
			
			if dispelType == "Magic" then
				return true;
			end
		end
	elseif class == "Hunter" then
		for i = 1,40 do
			local _,_,_,_,dispelType = UnitBuff("target",i);
			
			if dispelType == "Magic" then
				return true;
			end
		end
	end
	
	return false;
end

function CJ_GCD()
	if class == "Death Knight" then
		if GetSpellCooldown("Acherus Deathcharger") == 0 then return true end
	elseif class == "Druid" then
		if GetSpellCooldown("Mark of the Wild") == 0 then return true end;
	elseif class == "Hunter" then
		if GetSpellCooldown("Eagle Eye") == 0 then return true end;
	elseif class == "Mage" then
		if GetSpellCooldown("Ice Lance") == 0 then return true end;
	elseif class == "Paladin" then
		if GetSpellCooldown("Seal of Truth") == 0 then return true end;
	elseif class == "Priest" then
		if GetSpellCooldown("Inner Will") == 0 then return true end;
	elseif class == "Rogue" then
		if GetSpellCooldown("Sinister Strike") == 0 then return true end;
	elseif class == "Shaman" then
		if GetSpellCooldown("Flametongue Weapon") == 0 then return true end;
	elseif class == "Warlock" then
		if GetSpellCooldown("Fel Armor") == 0 then return true end;
	elseif class == "Warrior" then
		if GetSpellCooldown("Slam") == 0 then return true end;
	end
	
	return false;
end

function printf(message)
	DEFAULT_CHAT_FRAME:AddMessage(message);
end