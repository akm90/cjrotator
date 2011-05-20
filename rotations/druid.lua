---- Druid Rotations

-----------------------------------
--------Feral Kitty----------------
-----------------------------------

local function CJCheckFeralBuffs()
	if not CJ_HasBuff("player","Mark of the Wild") then
		CastSpell("Mark of the Wild");
		return true;
	end
	
	if GetShapeshiftForm() ~= 3 then
		CastShapeshiftForm(3);
		return true;
	end
	return false;
end