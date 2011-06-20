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
cj_verbose = false;
--Class Specific Variables
cj_decurseself = false
cj_decurseparty = false

if cj_stopmovement == nil then
	cj_stopmovement = 0;
end

--Warlocks
cj_lifetap = false;

--Warriors
cj_hamstring = false
cj_sunder = false
cj_rend = 0;
cj_shatter = false;
cj_commanding = false;
cj_throwdown = false;

--Priest
cj_dispersion = false;
cj_healonly = false

--Mages
cj_orbspells = false;

--Rogues
cj_hatproc = 9999999;
cj_hatexpect = 0;
cj_combosaved = 0;

--Hunters
cj_wildaspect = false;

--Death Knights
cj_deathstrike = false;

--Druids
cj_feralcharge = false
cj_thrash = false;

--Shamans
cj_frostshock  = false;
cj_pickuptotems = nil;

local info = {}

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

local ldb = LibStub:GetLibrary("LibDataBroker-1.1");

local ldbObject = {
	type = "launcher",
	text = "CJRotator",
	icon = "Interface\\ICONS\\spell_nature_bloodlust",
	label = "CJRotator",
	OnClick = function(self,button)
		if CJRotatorFrame:IsShown() then
			CJRotatorFrame:Hide()
		else
			CJRotatorFrame:Show()
		end
	end,
	OnTooltipShow = function(self,button)
		self:AddLine("CJR Show/Hide");
	end,
};

ldb:NewDataObject("CJRLDB",ldbObject);
LibStub("LibDBIcon-1.0"):Register("CJRLDB",ldbObject,cjrminimapbutton);
local function CJCreateFrame()
	if frameLoaded then return end;
	frameLoaded = true
	local f = CreateFrame("Frame","CJRotatorFrame",UIParent);
	f:SetSize(230,180)
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
	fa:SetSize(190,42)
	fa:SetPoint("TOPLEFT",24,-120)
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
	fb:SetPoint("TOPLEFT",24,-20);
	fb:SetScript("OnClick",function(self)
		cj_tclap = 0;
		cj_lastcall = nil;
		cj_aoemode = self:GetChecked()
	end)

	local fc = CreateFrame("CheckButton","CJCooldownsCheckbox",f,"UICheckButtonTemplate")
	_G[fc:GetName().."Text"]:SetText("Cooldowns")
	fc:SetPoint("TOPLEFT",115,-20);
	fc:SetChecked(cj_cooldowns)
	fc:SetScript("OnClick",function(self)
		cj_cooldowns = self:GetChecked()
	end)

	local fd = CreateFrame("CheckButton","CJPurgeCheckbox",f,"UICheckButtonTemplate")
	_G[fd:GetName().."Text"]:SetText("Purge")
	fd:SetPoint("TOPLEFT",24,-58)
	fd:SetChecked(cj_purgemode)
	fd:SetScript("OnClick",function(self)
		cj_purgemode = self:GetChecked()
	end)

	local fh = CreateFrame("CheckButton","CJInterruptsCheck",f,"UICheckButtonTemplate")
	_G[fh:GetName().."Text"]:SetText("Interrupts")
	fh:SetPoint("TOPLEFT",115,-58)
	fh:SetChecked(cj_interruptmode)
	fh:SetScript("OnClick",function(self)
		cj_interruptmode = self:GetChecked()
	end)

	local fk = CreateFrame("Button","CJMinimizeButton",f,"UIPanelCloseButton")
	fk:SetSize(20,20)
	fk:SetPoint("TOPRIGHT",-7,-7)
	fk:SetScript("OnClick",function(self)
		CJ_Minimize()
	end)
	
	local fh = CreateFrame("Button","CJCloseButton",f,"UIPanelCloseButton")
	fh:SetSize(20,20)
	fh:SetPoint("TOPLEFT",7,-7)
	fh:SetScript("OnClick",function(self)
		f:Hide();
	end)
	
	local fg = CreateFrame("Button","CJClassDropDown",f,"UIDropDownMenuTemplate")
	fg:SetPoint("TOPLEFT",10,-90);
	fg.noResize = true;
	UIDropDownMenu_SetWidth(fg,165)
	CJClassDropDownText:SetText("Class Options");
	CJClassDropDownText:SetJustifyH("CENTER");
	fg.initialize = function(self,level)
		if not level then return end
		wipe(info)
		if level == 1 then
			UIDropDownMenu_EnableDropDown(self)
			if cj_currentRotation == 81 or cj_currentRotation == 82 then
				info.text = "Use Frost Shock"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_frostshock = not cj_frostshock end
				info.checked = cj_frostshock
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Decurse Self"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_decurseself = not cj_decurseself end
				info.checked = cj_decurseself
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Decurse All"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_decurseparty = not cj_decurseparty end
				info.checked = cj_decurseparty
				UIDropDownMenu_AddButton(info,level)
			elseif cj_currentRotation == 101 or cj_currentRotation == 102 then
				info.text = "Use Hamstring"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_hamstring = not cj_hamstring end
				info.checked = cj_hamstring
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Use Sunder"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_sunder = not cj_sunder end
				info.checked = cj_sunder
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Shattering Throw"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_shatter = not cj_shatter end
				info.checked = cj_shatter
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Commanding Shout"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_commanding = not cj_commanding end
				info.checked = cj_commanding
				UIDropDownMenu_AddButton(info,level)
				
				if cj_currentRotation == 101 then
					info.text = "Throwdown"
					info.keepShownOnClick = 1
					info.disabled = nil
					info.isTitle = nil
					info.notCheckable = nil
					info.minWidth = 165
					info.func = function() cj_throwdown = not cj_throwdown end
					info.checked = cj_throwdown
					UIDropDownMenu_AddButton(info,level)
				end
			elseif cj_currentRotation == 103 then				
				info.text = "Use Defensive Cooldowns"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_defensivecooldowns = not cj_defensivecooldowns end
				info.checked = cj_defensivecooldowns
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Commanding Shout"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_commanding = not cj_commanding end
				info.checked = cj_commanding
				UIDropDownMenu_AddButton(info,level)
			elseif cj_currentRotation == 53 then
				info.text = "Decurse Self"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_decurseself = not cj_decurseself end
				info.checked = cj_decurseself
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Decurse All"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_decurseparty = not cj_decurseparty end
				info.checked = cj_decurseparty
				UIDropDownMenu_AddButton(info,level)
			elseif cj_currentRotation == 52 then
				info.text = "Use Defensive Cooldowns"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_defensivecooldowns = not cj_defensivecooldowns end
				info.checked = cj_defensivecooldowns
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Decurse Self"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_decurseself = not cj_decurseself end
				info.checked = cj_decurseself
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Decurse All"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_decurseparty = not cj_decurseparty end
				info.checked = cj_decurseparty
				UIDropDownMenu_AddButton(info,level)
			elseif cj_currentRotation == 22 then
				info.text = "Use Defensive Cooldowns"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_defensivecooldowns = not cj_defensivecooldowns end
				info.checked = cj_defensivecooldowns
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Feral Charge"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_feralcharge = not cj_feralcharge end
				info.checked = cj_feralcharge
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Single Targ Thrash"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_thrash = not cj_thrash end
				info.checked = cj_thrash
				UIDropDownMenu_AddButton(info,level)
			elseif cj_currentRotation == 11 then
				info.text = "Use Defensive Cooldowns"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_defensivecooldowns = not cj_defensivecooldowns end
				info.checked = cj_defensivecooldowns
				UIDropDownMenu_AddButton(info,level)
			elseif cj_class == "Warlock" then
				info.text = "Use Life Tap"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_lifetap = not cj_lifetap end
				info.checked = cj_lifetap
				UIDropDownMenu_AddButton(info,level)
			elseif cj_class == "Mage" then
				info.text = "Flame/Frost Orb"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_orbspells = not cj_orbspells end
				info.checked = cj_orbspells
				UIDropDownMenu_AddButton(info,level)
			
				info.text = "Decurse Self"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_decurseself = not cj_decurseself end
				info.checked = cj_decurseself
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Decurse All"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_decurseparty = not cj_decurseparty end
				info.checked = cj_decurseparty
				UIDropDownMenu_AddButton(info,level)
			elseif cj_currentRotation == 61 then
				info.text = "Smite/HF Only"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_healonly = not cj_healonly end
				info.checked = cj_healonly
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Decurse Self"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_decurseself = not cj_decurseself end
				info.checked = cj_decurseself
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Decurse All"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_decurseparty = not cj_decurseparty end
				info.checked = cj_decurseparty
				UIDropDownMenu_AddButton(info,level)
			elseif cj_currentRotation == 62 then
				info.text = "Decurse Self"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_decurseself = not cj_decurseself end
				info.checked = cj_decurseself
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Decurse All"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_decurseparty = not cj_decurseparty end
				info.checked = cj_decurseparty
				UIDropDownMenu_AddButton(info,level)
			elseif cj_currentRotation == 63 then
				info.text = "Use Dispersion"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_dispersion = not cj_dispersion end
				info.checked = cj_dispersion
				UIDropDownMenu_AddButton(info,level)
				
				info.text = "Decurse Self"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_decurseself = not cj_decurseself end
				info.checked = cj_decurseself
				UIDropDownMenu_AddButton(info,level)
			elseif cj_currentRotation == 12 or cj_currentRotation == 13 then
				info.text = "Use Death Strike"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_deathstrike = not cj_deathstrike end
				info.checked = cj_deathstrike
				UIDropDownMenu_AddButton(info,level)
			elseif cj_class == "Hunter" then
				info.text = "Aspect of the Wild"
				info.keepShownOnClick = 1
				info.disabled = nil
				info.isTitle = nil
				info.notCheckable = nil
				info.minWidth = 165
				info.func = function() cj_wildaspect = not cj_wildaspect end
				info.checked = cj_wildaspect
				UIDropDownMenu_AddButton(info,level)
			else
				UIDropDownMenu_DisableDropDown(self)
			end
		end
	end
	
	
	fk:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-Minimize-Up")
	fk:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-Minimize-Highlight")
	fk:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-Minimize-Down")

	fh:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-Maximize-Up")
	fh:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-Maximize-Highlight")
	fh:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-Maximize-Down")
	
	f:Show();
end

local info = {};
function CJClassHelper(self,level)
	printf("here");
	if not level then return end
	wipe(info)
	if level == 1 then
		info.isTitle = 1
		info.text = "Class Options"
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info,level)
	end
end

function CJ_Minimize()
	if not cjmin then
		CJRotatorFrame:SetSize(140,40)
		CJMinimizeButton:SetHeight(23)
		CJAoECheckbox:Hide()
		CJCooldownsCheckbox:Hide()
		CJPurgeCheckbox:Hide()
		CJInterruptsCheck:Hide()
		CJClassDropDown:Hide();
		CJCloseButton:Hide()
		CJActionButton:SetPoint("TOPLEFT",6,-7)
		CJActionButton:SetSize(110,23)
		cjmin = not cjmin;
	else
		CJRotatorFrame:SetSize(230,180)
		CJAoECheckbox:Show()
		CJCooldownsCheckbox:Show()
		CJPurgeCheckbox:Show()
		CJInterruptsCheck:Show()
		CJClassDropDown:Show()
		CJActionButton:SetPoint("TOPLEFT",24,-120)
		CJActionButton:SetSize(190,42)
		CJMinimizeButton:SetSize(20,20)
		CJCloseButton:Show()
		cjmin = not cjmin;
	end
end

local function OnUpdate(...)
	if StaticPopup_Visible("ADDON_ACTION_FORBIDDEN") then
		StaticPopup_Hide("ADDON_ACTION_FORBIDDON")
	end
--	if cj_currentRotation == 0 then CJ_SelectSpec() return end;
	if cj_pickuptotems ~= nil and GetTime() - cj_pickuptotems > 3 and cj_class == "Shaman" then
		if UnitAffectingCombat("player") == 1 then 
			cj_pickuptotems = nil
		elseif UnitAffectingCombat("player") == nil and not CJ_HB("Food") and not CJ_HB("Drink") then
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
	
	--[[if UnitAffectingCombat("player") == 1 and (UnitIsDead("target") or not UnitExists("target")) then
		RunMacroText("/targetenemy");
	end--]]
	
	if IsMounted() == 1 then return end
	
	if (not UnitExists("target") or not UnitCanAttack("player","target") or UnitIsDead("target")) and 
	(not UnitExists("focus") or not UnitCanAttack("player","focus") or UnitIsDead("focus")) and 
	UnitName("target") ~= "Cho'gall" and UnitName("target") ~= "Corrupting Adherent" then return end;
	
	_G[cj_rotationTable[cj_currentRotation]]();
end

local function OnEvent(self,event,...)
	if event == "PLAYER_REGEN_ENABLED" then
		if cj_action and cj_stopaftercombat then
			cj_action = false;
			if cj_action then CJActionButton:SetText("Disable") else CJActionButton:SetText("Enable") end
		end
		cj_pickuptotems = GetTime();
		cj_tclap = 0;
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
		elseif type == "SPELL_CAST_SUCCESS" and spellName == "Thunder Clap" and sGUID == UnitGUID("player") then
			cj_tclap = GetTime();
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
		UIDropDownMenu_EnableDropDown(CJClassDropDown)
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
	cj_tclap = 0;
    if cj_aoemode then printf("CJ Rotator: AoE Mode") else printf("CJ Rotator: Single Target Mode") end
end

function cjhandler(msg,editbox)
	 local command, rest = msg:match("^(%S*)%s*(.-)$");
	
	command = string.lower(command)
	
	if command == "show" then
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
		NAActionButton:UnregisterAllEvents()
		if cj_holddown then
			NAActionButton:RegisterForClicks("AnyUp", "AnyDown");
		else
			NAActionButton:RegisterForClicks("AnyUp");
		end
	elseif command == "verbose" then
		cj_verbose = not cj_verbose;
		if cj_verbose then
			printf("CJR: Verbose On");
		else
			printf("CJR: Verbose Off");
		end
	elseif command == "purgeplayers" then
		cj_purgeplayers = not cj_purgeplayers;
		if cj_purgeplayers then
			printf("CJR: Purging Players");
		else
			printf("CJR: Purging Players");
		end
	elseif command == "stopmovement" then
		if cj_stopmovement == 1 then
			cj_stopmovement = 0;
		else
			cj_stopmovement = 1;
		end
		
		if cj_stopmovement == 1 then
			printf("CJR: No Movement");
		else
			printf("CJR: Movement");
		end
	else
		printf("Syntax: /cjr (show|stopaftercombat||holddown|purgeplayers|verbose|stopmovement)")
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
SLASH_CJROTATOR1 = "/cjrotator"
SlashCmdList["CJROTATOR"] = CJToggleOn;
SLASH_CJTOGGLE1 = "/cjaoetoggle";
SlashCmdList["CJTOGGLE"] = CJToggleAoE;
OnLoad();