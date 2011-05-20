-------------------------------------------
--  CJ Rotator
-------------------------------------------
-- Change your key here.
local ACTIONKEY = "F";
local AOETOGGLEKEY = "G";
local INTERRUPTTOGGLEKEY = "`";
local HOLDDOWN = false;-- If this is true, you have to hold the key down.  If it is false, just press it to turn it on, press again to turn off.
local STOPAFTERCOMBAT = true;-- Disable after combat
local DEBUGMODE = false;-- debugmode
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------

cj_action = false;
cj_aoemode = false;
cj_interruptmode = false;
local f = CreateFrame("Frame");
currentRotation = 0;
local _G = getfenv();
local loaded = false;


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

local function OnUpdate(...)
	if currentRotation == 0 then CJ_SelectSpec() return end;
	if not cj_action then return end;
	if cj_rotationTable[currentRotation] == nil then
		printf("Your spec is currently not supported!");
		cj_action = false;
		printf("CJ Rotator Finished");
		return;
	end
	
	if (not UnitExists("target") or not UnitCanAttack("player","target") or UnitIsDead("target")) and 
	(not UnitExists("focus") or not UnitCanAttack("player","focus") or UnitIsDead("focus")) then return end;
	
	_G[cj_rotationTable[currentRotation]]();
end

local function OnEvent(self,event)
	if event ~= "PLAYER_REGEN_ENABLED" then
		CJ_SelectSpec();
	else
		if cj_action then
			cj_action = false;
			DEFAULT_CHAT_FRAME:AddMessage("CJ Rotator Finished");
		end
	end
end

local function CJToggleOn()
	cj_action = not cj_action;
	
	if cj_action then printf("CJ Rotator Started") else printf("CJ Rotator Finished") end
end

local function CJToggleAoE()
	cj_aoemode = not cj_aoemode;
	
	if cj_aoemode then printf("CJ Rotator: AoE Mode") else printf("CJ Rotator: Single Target Mode") end
end

local function CJToggleInterrupt()
	cj_interruptmode = not cj_interruptmode;
	
	if cj_interruptmode then printf("CJ Rotator: Interrupting") else printf("CJ Rotator: Not Interrupting") end
end

local function OnLoad()
	f:RegisterEvent("PLAYER_ENTERING_WORLD");
	f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	f:RegisterEvent("CHARACTER_POINTS_CHANGED");
	if STOPAFTERCOMBAT then
		f:RegisterEvent("PLAYER_REGEN_ENABLED");
	end
	f:SetScript("OnEvent", OnEvent);
	SetOverrideBinding(f, true, ACTIONKEY, "CLICK NAActionButton:LeftClick");
	SetOverrideBinding(f, true, AOETOGGLEKEY, "CLICK NAAoEButton:LeftClick");
	SetOverrideBinding(f, true, INTERRUPTTOGGLEKEY, "CLICK NAInterruptButton:LeftClick");
	f:SetScript("OnUpdate", OnUpdate);
	DEFAULT_CHAT_FRAME:AddMessage("CJ Rotator Loaded");
end

SLASH_CJROTATOR1 = "/cjrotator"
SlashCmdList["CJROTATOR"] = CJToggleOn;
SLASH_CJTOGGLE1 = "/cjaoetoggle";
SlashCmdList["CJTOGGLE"] = CJToggleAoE;
SLASH_CJINTERRUPT1 = "/cjinterrupttoggle";
SlashCmdList["CJINTERRUPT"] = CJToggleInterrupt;
OnLoad();