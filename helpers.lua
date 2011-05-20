--Helpers File
class = "";
currentRotation = 0;

function CJ_BuffInfo(unit,buff)
	local name,_,_,count,_,_,expiration,_,_,_,_ = UnitBuff(unit,buff);
	if not name then return 0 end
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
	local name,_,_,count,_,_,expiration = UnitDebuff(unit,debuff,select(2,UnitDebuff(unit,debuff)),"PLAYER");
	if not name then return 0 end
	return count,(expiration - GetTime())
end

function CJHealthPercent(unit)
	return (((UnitHealth("player") / UnitHealthMax("player")) * 100));
end

function CJManaPercent(unit)
	return (((UnitPower("player") / UnitPowerMax("player")) * 100));
end

function CastSpell(spell)
	CastSpellByName(spell);
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
	return (not UnitChannelInfo("player") and not UnitCastingInfo("player"));
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
	local countTotems = 0;
	local updateFire = false;
	local updateEarth = false;
	local updateAir = false;
	local updateWater = false;
	local earthTotem = "";
	local fireTotem = "";
	local waterTotem = "";
	local airTotem = "";
	
	local f = CreateFrame('GameTooltip', 'MyTooltip', UIParent, 'GameTooltipTemplate')
	
	if cj_aoemode then
		--Earth Totem
		f:SetOwner(UIParent,'ANCHOR_NONE')
		f:SetAction(MultiCastActionButton5.action);
		earthTotem = f:GetSpell();
		local _,totemName = GetTotemInfo(2);
		if totemName ~= "Earth Elemental Totem" and earthTotem ~= totemName then
			updateEarth = true;
			countTotems = countTotems + 1;
		end

		--Fire Totem
		f:SetOwner(UIParent,'ANCHOR_NONE')
		f:SetAction(MultiCastActionButton6.action);
		fireTotem = f:GetSpell();
		local _,totemName = GetTotemInfo(1);
		if totemName ~= "Fire Elemental Totem" and fireTotem ~= totemName then
			updateFire = true;
			countTotems = countTotems + 1;
		end

		--Water Totem
		f:SetOwner(UIParent,'ANCHOR_NONE')
		f:SetAction(MultiCastActionButton7.action);
		waterTotem = f:GetSpell();
		local _,totemName = GetTotemInfo(3);
		if waterTotem ~= totemName then
			updateWater = true;
			countTotems = countTotems + 1;
		end

		--Air Totem
		f:SetOwner(UIParent,'ANCHOR_NONE')
		f:SetAction(MultiCastActionButton8.action);
		airTotem = f:GetSpell();
		local _,totemName = GetTotemInfo(4);
		if airTotem ~= totemName then
			updateWater = true;
			countTotems = countTotems + 1;
		end
	else
		--Earth Totem
		f:SetOwner(UIParent,'ANCHOR_NONE')
		f:SetAction(MultiCastActionButton1.action);
		earthTotem = f:GetSpell();
		local _,totemName = GetTotemInfo(2);
		if totemName ~= "Earth Elemental Totem" and earthTotem ~= totemName then
			updateEarth = true;
			countTotems = countTotems + 1;
		end

		--Fire Totem
		f:SetOwner(UIParent,'ANCHOR_NONE')
		f:SetAction(MultiCastActionButton2.action);
		fireTotem = f:GetSpell();
		local _,totemName = GetTotemInfo(1);
		if totemName ~= "Fire Elemental Totem" and fireTotem ~= totemName then
			updateFire = true;
			countTotems = countTotems + 1;
		end

		--Water Totem
		f:SetOwner(UIParent,'ANCHOR_NONE')
		f:SetAction(MultiCastActionButton3.action);
		waterTotem = f:GetSpell();
		local _,totemName = GetTotemInfo(3);
		if waterTotem ~= totemName then
			updateWater = true;
			countTotems = countTotems + 1;
		end

		--Air Totem
		f:SetOwner(UIParent,'ANCHOR_NONE')
		f:SetAction(MultiCastActionButton4.action);
		airTotem = f:GetSpell();
		local _,totemName = GetTotemInfo(4);
		if airTotem ~= totemName then
			updateWater = true;
			countTotems = countTotems + 1;
		end
	end
	
	f:Hide();
	if countTotems >= 3 then
		if cj_aoemode then
			CastSpell("Call of the Ancestors");
			return true;
		else
			CastSpell("Call of the Elements");
			return true;
		end
	else
		if updateFire then
			CastSpell(fireTotem);
			return true;
		end
		
		if updateEarth then
			CastSpell(earthTotem);
			return true;
		end
		
		if updateWater then
			CastSpell(waterTotem);
			return true;
		end
		
		if updateAir then
			CastSpell(airTotem);
			return true;
		end
	end
	return false;
end

function CJ_SelectSpec()
	class = UnitClass("player");
	c = class;
	printf("Class detected as "..class);
	local tt = GetPrimaryTalentTree();
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
		if GetSpellCooldown("Sinister Strike") then return true end;
	elseif class == "Shaman" then
		if GetSpellCooldown("Flametongue Weapon") == 0 then return true end;
	elseif class == "Warlock" then
		if GetSpellCooldown("Demon Skin") == 0 then return true end;
	elseif class == "Warrior" then
		if GetSpellCooldown("Slam") == 0 then return true end;
	end
end

function printf(message)
	DEFAULT_CHAT_FRAME:AddMessage(message);
end