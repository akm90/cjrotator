-------------------------------------------
--  CJ Rotator
-------------------------------------------
-- Change your key here.
local ACTIONKEY = "F";
local AOETOGGLEKEY = "G";
local INTERRUPTTOGGLEKEY = "`";
local PURGEKEY = "Z";
local HOLDDOWN = false;-- If this is true, you have to hold the key down.  If it is false, just press it to turn it on, press again to turn off.
local STOPAFTERCOMBAT = true;-- Disable after combat
CJ_PURGEPLAYERS = false;
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------

cj_action = false;
cj_aoemode = false;
cj_purgemode = false;
cj_interruptmode = false;
cj_feraltank = false;
local f = CreateFrame("Frame");
local _G = getfenv();
local loaded = false;

--Shaman Specific Crap
cj_earthtotem = nil;
cj_firetotem = nil;
cj_waterttotem = nil;
cj_airtotem = nil;
cj_lastcall = nil;

f:SetFrameStrata("TOOLTIP");
f:Show();
f:SetWidth(1);
f:SetHeight(1);

local b = CreateFrame("CheckButton", "NAActionButton", nil, "SecureActionButtonTemplate, ActionButtonTemplate");
if HOLDDOWN then
	b:RegisterForClicks("AnyUp", "AnyDown");
else
	b:RegisterForClicks("AnyUp");
end
b:SetAttribute("downbutton", true);

b:SetAttribute("type", "macro");
b:SetAttribute("macrotext", "/cjrotator");

local c = CreateFrame("CheckButton","NAAoEButton",nil,"SecureActionButtonTemplate, ActionButtonTemplate");
c:RegisterForClicks("AnyUp");

c:SetAttribute("downbutton", true);
c:SetAttribute("type","macro");
c:SetAttribute("macrotext","/cjaoetoggle");

local d = CreateFrame("CheckButton","NAInterruptButton",nil,"SecureActionButtonTemplate, ActionButtonTemplate");
d:RegisterForClicks("AnyUp");

d:SetAttribute("downbutton", true);
d:SetAttribute("type","macro");
d:SetAttribute("macrotext","/cjinterrupttoggle");

local e = CreateFrame("CheckButton","NAPurgeButton",nil,"SecureActionButtonTemplate, ActionButtonTemplate");
e:RegisterForClicks("AnyUp");
e:SetAttribute("downbutton", true);
e:SetAttribute("type","macro");
e:SetAttribute("macrotext","/cjpurgetoggle");

local function OnUpdate(...)
	if ck_currentRotation == 0 then CJ_SelectSpec() return end;
	if not cj_action then return end;
	if cj_rotationTable[cj_currentRotation] == nil then
		printf("Your spec is currently not supported!");
		cj_action = false;
		printf("CJ Rotator Finished");
		return;
	end
	
	if (not UnitExists("target") or not UnitCanAttack("player","target") or UnitIsDead("target")) and 
	(not UnitExists("focus") or not UnitCanAttack("player","focus") or UnitIsDead("focus")) then return end;
	
	_G[cj_rotationTable[cj_currentRotation]]();
end

local function OnEvent(self,event,...)
	if event == "PLAYER_REGEN_ENABLED" then
		if cj_action then
			cj_action = false;
			DEFAULT_CHAT_FRAME:AddMessage("CJ Rotator Finished");
		end
	elseif (event == "UNIT_SPELLCAST_SUCCEEDED") then
		local unit,spell = ...;
		if (unit == "player") then
			if (cj_class == "Shaman") then
				if spell == "Call of the Elements" or spell == "Call of the Ancestors" then
					cj_lastcall = GetTime();
				elseif spell == "Totemic Recall" then
					cj_lastcall = nil;
					cj_firetotem = nil;
					cj_earthtotem = nil
					cj_watertotem = nil;
					cj_airtotem = nil;
				end
			end				
		end
	else
		CJ_SelectSpec();
	end
end

local function CJToggleOn()
	cj_action = not cj_action;
	
	if cj_action then printf("CJ Rotator Started") else printf("CJ Rotator Finished") end
end

local function CJToggleAoE()
	cj_aoemode = not cj_aoemode;
	cj_lastcall = nil
	if cj_aoemode then printf("CJ Rotator: AoE Mode") else printf("CJ Rotator: Single Target Mode") end
end

local function CJToggleInterrupt()
	cj_interruptmode = not cj_interruptmode;
	
	if cj_interruptmode then printf("CJ Rotator: Interrupting") else printf("CJ Rotator: Not Interrupting") end
end

local function CJPurgeToggle()
	if not cj_class == "Druid" then
		cj_purgemode = not cj_purgemode;
		
		if cj_purgemode then printf("CJ Rotator: Purging") else printf("CJ Rotator: Not Purging") end
	else
		cj_feraltank = not cj_feraltank;
		
		if cj_feraltank then printf("CJ Rotator: Bare Tank") else printf("CJ Rotator: Kitty Mode!") end
	end
end

local function CJSlashHandler(args)
	if args == "stopaftercombat" then
		STOPAFTERCOMBAT = not STOPAFTERCOMBAT;
		if STOPAFTERCOMBAT then printf("CJ Rotator: Stopping After Combat") else printf("CJ Rotator: Not Stopping after Combat") end
	elseif args == "holddown" then
		HOLDDOWN = not HOLDDOWN;
		if HOLDDOWN then printf("CJ Rotator: Stopping After Combat") else printf("CJ Rotator: Not Stopping after Combat") end
	end	
end


local function OnLoad()
	f:RegisterEvent("PLAYER_ENTERING_WORLD");
	f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	f:RegisterEvent("CHARACTER_POINTS_CHANGED");
	f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	if STOPAFTERCOMBAT then
		f:RegisterEvent("PLAYER_REGEN_ENABLED");
	end
	f:SetScript("OnEvent", OnEvent);
	SetOverrideBinding(f, true, ACTIONKEY, "CLICK NAActionButton:LeftClick");
	SetOverrideBinding(f, true, AOETOGGLEKEY, "CLICK NAAoEButton:LeftClick");
	SetOverrideBinding(f, true, INTERRUPTTOGGLEKEY, "CLICK NAInterruptButton:LeftClick");
	SetOverrideBinding(f, true, PURGEKEY, "CLICK NAPurgeButton:LeftClick");
	f:SetScript("OnUpdate", OnUpdate);
	DEFAULT_CHAT_FRAME:AddMessage("CJ Rotator Loaded");
end

SLASH_CJROTATOR1 = "/cjrotator"
SlashCmdList["CJROTATOR"] = CJToggleOn;
SLASH_CJTOGGLE1 = "/cjaoetoggle";
SlashCmdList["CJTOGGLE"] = CJToggleAoE;
SLASH_CJINTERRUPT1 = "/cjinterrupttoggle";
SlashCmdList["CJINTERRUPT"] = CJToggleInterrupt;
SLASH_CJPURGE1 = "/cjpurgetoggle"
SlashCmdList["CJPURGE"] = CJPurgeToggle;
SLASH_CJSLASH1 = "/cj"
SlashCmdList["CJSLASH"} = CJSlashHandler;
OnLoad();