-------------------------------------------
--  CJ Rotator
-------------------------------------------
-- Change your key here.
local ACTIONKEY = "F";
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
	ff:SetChecked(cj_purgemode)
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
	if cj_class == "Warrior" then
		CJClassToggleText:SetText("Use Hamstring")
	elseif cj_class == "Druid" then
		CJClassToggleText:SetText("Defensive Cooldowns")
		CJClassToggle:Enable()
		cj_defensivecooldowns = CJClassToggle:GetChecked()
	elseif cj_class == "Death Knight" then
		CJClassToggleText:SetText("Defensive Cooldowns")
		CJClassToggle:Enable()
		cj_defensivecooldowns = CJClassToggle:GetChecked()
	elseif cj_class == "Paladin" then
		CJClassToggleText:SetText("Defensive Cooldowns")
		CJClassToggle:Enable()
		cj_defensivecooldowns = CJClassToggle:GetChecked()
	elseif cj_currentRotation == 61 then
		CJClassToggleText:SetText("Heal Only");
	else
		CJClassToggleText:SetText("Disabled");
		CJClassToggle:Disable();
	end
end

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
		if cj_action and cj_stopaftercombat then
			cj_action = false;
			if cj_action then CJActionButton:SetText("Disable") else CJActionButton:SetText("Enable") end
		end
	elseif event == "ADDON_LOADED" then
		CJCreateFrame()
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


local function OnLoad()
	h:RegisterEvent("PLAYER_ENTERING_WORLD");
	h:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	h:RegisterEvent("CHARACTER_POINTS_CHANGED");
	h:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	h:RegisterEvent("ADDON_LOADED")
	h:RegisterEvent("PLAYER_REGEN_ENABLED");
	h:RegisterEvent("PET_ATTACK_START");
	h:RegisterEvent("PET_ATTACK_STOP");
	h:SetScript("OnEvent", OnEvent);
	SetOverrideBinding(h, true, ACTIONKEY, "CLICK NAActionButton:LeftClick");
	h:SetScript("OnUpdate", OnUpdate);
	DEFAULT_CHAT_FRAME:AddMessage("CJ Rotator Loaded");
end

SLASH_CJROTATOR1 = "/cjrotator"
SlashCmdList["CJROTATOR"] = CJToggleOn;
OnLoad();