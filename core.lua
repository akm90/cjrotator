-------------------------------------------
--  CJ Rotator
-------------------------------------------
-- Change your key here.
local ACTIONKEY = "F";
local AOEKEY = "G";
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
-----------------------------DO NOT CHANGE ANYTHING BELOW THIS LINE-------------------------------------------
local cjmin = false;
local frameLoaded = false;
cj_action = false;
cj_aoemode = false;
cj_defensivecooldowns = false
cj_petattacking = false;
cj_lifetap = false;
cj_hamstring = false
cj_dispersion = false;
cj_healonly = false
cj_hatproc = 9999999;
cj_hatexpect = 0;
cj_combosaved = 0;
cj_wildaspect = false;
cj_deathstrike = false;
cj_frostshock  = false;
cj_pickuptotems = nil;
cj_verbose = false;
cj_rend = 0;

local h = CreateFrame("Frame");
local _G = getfenv();
local loaded = false;

--Shaman Specific Crap
cj_earthtotem = nil;
cj_firetotem = nil;
cj_waterttotem = nil;
cj_airtotem = nil;
cj_lastcall = nil;

h:SetFrameStrata("TOOLTIP");
h:Show();
h:SetWidth(1);
h:SetHeight(1);

local b = CreateFrame("CheckButton", "NAActionButton", nil, "SecureActionButtonTemplate, ActionButtonTemplate");
if cj_holddown then
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

local hatframe = CreateFrame("frame","CJHaTFrame");

local function CJCreateFrame()
	if frameLoaded then return end;
	frameLoaded = true
	local f = CreateFrame("Frame","CJRotatorFrame",UIParent);
	f:SetSize(296,271)
	f:SetPoint("CENTER",0,0)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:SetBackdrop({
		bgFile=[[Interface\DialogFrame\UI-DialogBox-Background]],
		edgeFile=[[Interface\DialogFrame\UI-DialogBox-Border]],
		tile=true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left=11, right=12, top=12,bottom=11},
	})

	f:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)

	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)

	f:RegisterForDrag("LeftButton");

	f:CreateTitleRegion()

	local fa = CreateFrame("Button","CJActionButton",f,"UIPanelButtonTemplate","SecureActionButtonTemplate","ActionButtonTemplate")
	fa:SetText("Enable");
	fa:SetSize(238,42)
	fa:SetPoint("TOPLEFT",24,-201)
	fa:SetScript("OnMouseDown",function(self)
		cj_action = not cj_action
		if cj_action then self:SetText("Disable") else self:SetText("Enable") end
	end)

	fa:SetScript("OnMouseUp",function(self)
		if cj_holddown then cj_action = not cj_action end
		if cj_action then self:SetText("Disable") else self:SetText("Enable") end
	end)

	local fb = CreateFrame("CheckButton","CJAoECheckbox",f,"UICheckButtonTemplate")
	_G[fb:GetName().."Text"]:SetText("AoE Mode")
	fb:SetPoint("TOPLEFT",24,-25);
	fb:SetScript("OnClick",function(self)
		cj_lastcall = nil;
		cj_aoemode = self:GetChecked()
	end)

	local fc = CreateFrame("CheckButton","CJCooldownsCheckbox",f,"UICheckButtonTemplate")
	_G[fc:GetName().."Text"]:SetText("Cooldowns")
	fc:SetPoint("TOPLEFT",146,-25);
	fc:SetChecked(cj_cooldowns)
	fc:SetScript("OnClick",function(self)
		cj_cooldowns = self:GetChecked()
	end)

	local fd = CreateFrame("CheckButton","CJPurgeCheckbox",f,"UICheckButtonTemplate")
	_G[fd:GetName().."Text"]:SetText("Offensive Dispel")
	fd:SetPoint("TOPLEFT",24,-68)
	fd:SetChecked(cj_purgemode)
	fd:SetScript("OnClick",function(self)
		cj_purgemode = self:GetChecked()
	end)

	local fe = CreateFrame("CheckButton","CJStopAC",f,"UICheckButtonTemplate")
	_G[fe:GetName().."Text"]:SetText("Stop After Combat")
	fe:SetPoint("TOPLEFT",146,-68)
	fe:SetChecked(cj_stopaftercombat)
	fe:SetScript("OnClick",function(self)
		cj_stopaftercombat = self:GetChecked()
	end)

	local ff = CreateFrame("CheckButton","CJPurgePlayers",f,"UICheckButtonTemplate")
	_G[ff:GetName().."Text"]:SetText("Purge Players")
	ff:SetPoint("TOPLEFT",24,-111)
	ff:SetChecked(cj_purgeplayers)
	ff:SetScript("OnClick",function(self)
		cj_purgeplayers = self:GetChecked()
	end)

	local fg = CreateFrame("CheckButton","CJHoldDownCheckbox",f,"UICheckButtonTemplate")
	_G[fg:GetName().."Text"]:SetText("Hold Down")
	fg:SetPoint("TOPLEFT",146,-111)
	fg:SetChecked(cj_holddown)
	fg:SetScript("OnClick",function(self)
		cj_holddown = self:GetChecked()
		NAActionButton:UnregisterAllEvents()
		if cj_holddown then
			NAActionButton:RegisterForClicks("AnyUp", "AnyDown");
		else
			NAActionButton:RegisterForClicks("AnyUp");
		end
	end)

	local fh = CreateFrame("CheckButton","CJInterruptsCheck",f,"UICheckButtonTemplate")
	_G[fh:GetName().."Text"]:SetText("Interrupts")
	fh:SetPoint("TOPLEFT",24,-153)
	fh:SetChecked(cj_interruptmode)
	fh:SetScript("OnClick",function(self)
		cj_interruptmode = self:GetChecked()
	end)

	local fi = CreateFrame("CheckButton","CJClassToggle",f,"UICheckButtonTemplate")
	_G[fi:GetName().."Text"]:SetText("Class Toggle")
	fi:SetPoint("TOPLEFT",146,-153)
	fi:SetDisabledTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
	fi:SetScript("OnClick",function(self)
		CJClassTogHandler()
	end)

	local fk = CreateFrame("Button","CJMinimizeButton",f,"UIPanelCloseButton")
	fk:SetPoint("TOPRIGHT",-7,-7)
	fk:SetScript("OnClick",function(self)
		CJ_Minimize()
	end)

	fk:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-Minimize-Up")
	fk:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-Minimize-Highlight")
	fk:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-Minimize-Down")

	f:Show();
end



function CJ_Minimize()
	if not cjmin then
		CJRotatorFrame:SetSize(247,57)
		CJMinimizeButton:SetHeight(42)
		CJAoECheckbox:Hide()
		CJCooldownsCheckbox:Hide()
		CJPurgeCheckbox:Hide()
		CJStopAC:Hide()
		CJPurgePlayers:Hide()
		CJHoldDownCheckbox:Hide()
		CJInterruptsCheck:Hide()
		CJClassToggle:Hide()
		CJActionButton:SetPoint("TOPLEFT",5,-7)
		CJActionButton:SetSize(210,42)
		cjmin = not cjmin;
	else
		CJRotatorFrame:SetSize(296,271)
		CJAoECheckbox:Show()
		CJCooldownsCheckbox:Show()
		CJPurgeCheckbox:Show()
		CJStopAC:Show()
		CJPurgePlayers:Show()
		CJHoldDownCheckbox:Show()
		CJInterruptsCheck:Show()
		CJClassToggle:Show()
		CJActionButton:SetPoint("TOPLEFT",24,-201)
		CJActionButton:SetSize(238,42)
		CJMinimizeButton:SetHeight(32)
		cjmin = not cjmin;
	end
end


function CJClassTogHandler()
	if cj_currentRotation == 101 or cj_currentRotation == 102 then
		CJClassToggleText:SetText("Use Hamstring")
		CJClassToggle:Enable()
		cj_hamstring = CJClassToggle:GetChecked()
	elseif cj_currentRotation == 103 then
		CJClassToggleText:SetText("Defensive Cooldowns")
		CJClassToggle:Enable()
		cj_defensivecooldowns = CJClassToggle:GetChecked()
	elseif cj_class == "Warlock" then
		CJClassToggleText:SetText("Use Life Tap")
		CJClassToggle:Enable()
		cj_lifetap = CJClassToggle:GetChecked()
	elseif cj_currentRotation == 22 then
		CJClassToggleText:SetText("Defensive Cooldowns")
		CJClassToggle:Enable()
		cj_defensivecooldowns = CJClassToggle:GetChecked()
	elseif cj_currentRotation == 11 then
		CJClassToggleText:SetText("Defensive Cooldowns")
		CJClassToggle:Enable()
		cj_defensivecooldowns = CJClassToggle:GetChecked()
	elseif cj_currentRotation == 52 then
		CJClassToggleText:SetText("Defensive Cooldowns")
		CJClassToggle:Enable()
		cj_defensivecooldowns = CJClassToggle:GetChecked()
	elseif cj_currentRotation == 61 then
		CJClassToggleText:SetText("Heal Only");
		CJClassToggle:Enable()
		cj_healonly = CJClassToggle:GetChecked()
	elseif cj_currentrotation == 63 then
		CJClassToggleText:SetText("Use Dispersion");
		CJClassToggle:Enable()
		cj_dispersion = CJClassToggle:GetChecked()
	elseif cj_currentRotation == 12 or cj_currentRotation == 13 then
		CJClassToggleText:SetText("Death Strike");
		CJClassToggle:Enable()
		cj_deathstrike = CJClassToggle:GetChecked()
	elseif cj_class == "Hunter" then
		CJClassToggleText:SetText("Aspect of the Wild");
		CJClassToggle:Enable()
		cj_wildaspect = CJClassToggle:GetChecked()
	elseif cj_class == "Shaman" then
		CJClassToggleText:SetText("Frost Shock");
		CJClassToggle:Enable()
		cj_frostshock = CJClassToggle:GetChecked()
	else
		CJClassToggleText:SetText("Disabled");
		CJClassToggle:Disable();
	end
end

local function OnUpdate(...)
--	if cj_currentRotation == 0 then CJ_SelectSpec() return end;
	if cj_pickuptotems ~= nil and GetTime() - cj_pickuptotems > 3 then
		if UnitAffectingCombat("player") == 1 then 
			cj_pickuptotems = nil
		elseif UnitAffectingCombat("player") == 0 then
			if CJ_Cast("Totemic Recall") then cj_pickuptotems = nil return end
		end
	end
	
	if not cj_action then return end;
	if cj_rotationTable[cj_currentRotation] == nil then
		printf("Your spec is currently not supported!");
		cj_action = false;
		printf("CJ Rotator Finished");
		return;
	end
	
	if IsMounted() == 1 then return end
	
	if (not UnitExists("target") or not UnitCanAttack("player","target") or UnitIsDead("target")) and 
	(not UnitExists("focus") or not UnitCanAttack("player","focus") or UnitIsDead("focus")) then return end;
	
	_G[cj_rotationTable[cj_currentRotation]]();
end

local function OnEvent(self,event,...)
	if event == "PLAYER_REGEN_ENABLED" then
		if cj_action and cj_stopaftercombat then
			cj_action = false;
			if cj_action then CJActionButton:SetText("Disable") else CJActionButton:SetText("Enable") end
			cjpickuptotems = GetTime();
		end
	elseif event == "ADDON_LOADED" then
		CJCreateFrame()
	elseif (event == "UNIT_SPELLCAST_SUCCEEDED") then
		local unit,spell,rank,_,spellID = ...;
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
			elseif cj_currentRotation == 73 then
				if ((spellID == 14183) or (spellID == 73981)) and unitID == "player" then
					cj_hatexpect = 1
				end
			end				
		end
	elseif (event == "COMBAT_LOG_EVENT_UNFILTERED")then
		local timestamp, type, hideCaster, sGUID, sName, sFlags, dGUID, dName, dFlags, spellID, spellName, sSchool, dDealt = ...;			
		if (type=="SPELL_DAMAGE") then
			if ((spellID == 1752 or spellID == 53 or spellID == 1776 or spellID == 5938 or spellID == 16511) and sName == UnitName("player")) then
				cj_hatexpect = 1
			elseif ((spellID == 703 or spellID == 1833 or spellID == 8676) and sName == UnitName("player")) then
				cj_hatexpect = 2
			end
		elseif type == "SPELL_CAST_SUCCESS" and spellName == "Rend" and sGUID == UnitGUID("player") then
			cj_rend = GetTime();
		end
	elseif (event == "UNIT_COMBO_POINTS") then
		if cj_currentRotation ~= 73 then return end
		if GetComboPoints("player","target") < cj_combosaved then
			cj_combosaved = GetComboPoints("player","target");
		else
			if cj_hatexpect == 0 then
				hatframe.wait = hatframe.wait or CreateFrame("Frame")
				hatframe.wait.timer = 0
				hatframe.wait:SetScript("OnUpdate", function(self, elapsed, ...)
					hatframe.wait.timer = hatframe.wait.timer + elapsed*1000
					if(hatframe.wait.timer >= 500) then
						if cj_hatexpect >= 1 then
							cj_hatexpect = 0
						else
							if(GetComboPoints("player","target") ~= 0) then	
								cj_hatproc = GetTime();
							end
						end
						hatframe.wait:SetScript("OnUpdate", nil)
					else
						if cj_hatexpect >= 1 then
							cj_hatexpect = 0
							f.wait:SetScript("OnUpdate", nil)
						end
					end
				end)
			else 
				cj_hatexpect = 0
			end
			cj_combosaved = GetComboPoints("player","target")						
		end
	elseif event == "PET_ATTACK_START" then
		cj_petattacking = true
	elseif event == "PET_ATTACK_STOP" then
		cj_petattacking = false;
	else
		CJ_SelectSpec();
	end
end

local function CJToggleOn()
	cj_action = not cj_action;
	
	if cj_action then printf("CJ Rotator Started") else printf("CJ Rotator Finished") end
	if cj_action then CJActionButton:SetText("Disable") else CJActionButton:SetText("Enable") end
end

local function CJToggleAoE()
    RunMacroText("/click CJAoECheckbox");
    if cj_aoemode then printf("CJ Rotator: AoE Mode") else printf("CJ Rotator: Single Target Mode") end
end

local function CJToggleShow()
	if CJRotatorFrame:IsShown() then
		CJRotatorFrame:Hide()
	else
		CJRotatorFrame:Show()
	end
end

function cjhandler(msg,editbox)
	 local command, rest = msg:match("^(%S*)%s*(.-)$");
	
	if command == "hide" then
		if CJRotatorFrame:IsShown() then
			CJRotatorFrame:Hide()
		else
			CJRotatorFrame:Show()
		end
	elseif command == "stopaftercombat" then
		cj_stopaftercombat = not cj_stopaftercombat;
		if cj_stopaftercombat then
			printf("CJR: Stopping After Combat");
		else
			printf("CJR: Not Stopping After Combat");
		end
	elseif command == "holddown" then
		cj_holddown = not cj_holddown;
		if cj_holddown then
			printf("CJR: Hold Down Enabled");
		else
			printf("CJR: Hold Down Disabled");
		end
	elseif command == "verbose" then
		cj_verbose = not cj_verbose;
		if cj_holddown then
			printf("CJR: Verbose On");
		else
			printf("CJR: Verbose Off");
		end
	elseif command
	end
end

local function OnLoad()
	h:RegisterEvent("PLAYER_ENTERING_WORLD");
	h:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	h:RegisterEvent("CHARACTER_POINTS_CHANGED");
	h:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	h:RegisterEvent("ADDON_LOADED")
	h:RegisterEvent("PLAYER_REGEN_ENABLED");
	h:RegisterEvent("PET_ATTACK_START");
	h:RegisterEvent("PET_ATTACK_STOP");
	h:RegisterEvent("UNIT_COMBO_POINTS");
	h:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	h:SetScript("OnEvent", OnEvent);
	SetOverrideBinding(h, true, ACTIONKEY, "CLICK NAActionButton:LeftClick");
	SetOverrideBinding(h, true, AOEKEY, "CLICK NAAoEButton:LeftClick");
	h:SetScript("OnUpdate", OnUpdate);
	DEFAULT_CHAT_FRAME:AddMessage("CJ Rotator Loaded");
end


SLASH_CJSTUFF1 = "/cjr"
SlashCmdList["CJSTUFF"] = cjhandler;
SLASH_CJHIDE1 = "/cjhide"
SlashCmdList["CJHIDE"] = CJToggleShow;
SLASH_CJROTATOR1 = "/cjrotator"
SlashCmdList["CJROTATOR"] = CJToggleOn;
SLASH_CJTOGGLE1 = "/cjaoetoggle";
SlashCmdList["CJTOGGLE"] = CJToggleAoE;
OnLoad();