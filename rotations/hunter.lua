---------------------
------Marksmanship---
---------------------
local numsteady = 0;
local lastss = 0
local lastba = 0
--[[ Hawk
Fox
Cheetah
Pack
Resist
--]]

function CJ_MarksBuffs()
        return false
end

function CJMarksHunterRot()
        if CJ_OC() then StopAttack() return end
        if AmIFacing == false then return end;
        CJ_Interrupt("Silencing Shot");
        
        if not CJ_HB("Trueshot Aura") then
                if CJ_Cast("Trueshot Aura") then return end
        end
        
        if cj_wildaspect then
                if not CJ_HB("Aspect of the Wild") then
                        if CJ_Cast("Aspect of the Wild") then return end
                end
        else
                if GetUnitSpeed("player") > 0 then
                        if not CJ_HB("Aspect of the Fox") then
                                CJ_Cast("Aspect of the Fox");
                        end
                else
                        if not CJ_HB("Aspect of the Hawk") then
                                CJ_Cast("Aspect of the Hawk")
                        end
                end
        end
        StartAttack()
        
        if not IsPetAttackActive() then
                PetAttack("target")
        end
        
        if not CJ_GCD() then return end;
        if CJ_Casting() then return end
        
        if CJ_OffensiveDispel("Tranquilizing Shot") then numsteady = 0 return end
        
        if UnitExists("pet") and not UnitIsDead("pet") and CJ_HP("pet") < 30 and not UnitBuff("pet","Mend Pet") then
                if CJ_Cast("Mend Pet") then return end
        end
        
        if not CJ_HD("Hunter's Mark") and not CJ_HB("Rapid Fire") and not CJ_HB("Berserking") and CJ_HP("target") > 10 and UnitHealth("target") > 1000 and not cj_aoemode and not (UnitHealth("target") <= (UnitHealth("player")*3.5)) and IsSpellInRange("Hunter's Mark","target") then
                if CJ_Cast("Hunter's Mark") then return end
        end
        if not CJ_Hero() and not CJ_HB("Rapid Fire") and not CJ_HB("Berserking") and cj_cooldowns then
                CJ_Cast("Berserking")
        end
        if cj_aoemode then
                if CJ_Cast("Multi-Shot") then numsteady = 0 return end
        end
        
        if cj_aoemode then
                if CJ_HB("Fire!") then
                        if CJ_Cast("Aimed Shot") then numsteady = 0 return end
                end
                if CJ_Cast("Steady Shot") then numsteady = numsteady + 1; if numsteady >= 2 then numsteady = 0 end return end
        end
        
        if CJ_HP("target") <= 90 and not CJ_HD("Serpent Sting") and GetTime() - lastss > 3 then
                if CJ_Cast("Serpent Sting") then lastss = GetTime(); numsteady = 0 return end
        end
        
        if CJ_HP("target") <= 90 then
                if CJ_Cast("Chimera Shot") then numsteady = 0 return end
        end
        
        if cj_cooldowns then
                if not CJ_Hero() and not CJ_HB("Rapid Fire") and not CJ_HB("Berserking") then
                        CJ_Cast("Rapid Fire")
                end
                if CJ_HB("Rapid Fire") or CJ_HB("Berserking") or CJ_Hero() then
                        CJ_Cast("Call of the Wild")
                end
                if IsUsableSpell("Rapid Fire") and CJ_CD("Rapid Fire") > 30 then
                        if CJ_Cast("Readiness") then return end
                end
        end
        
        if numsteady >= 1 and CJ_BTR("Improved Steady Shot") < 3 then
                if CJ_Cast("Steady Shot") then numsteady = 0 return end
        end
        
        if CJ_Cast("Kill Shot") then numsteady = 0 return end
        
        if CJ_HB("Fire!") then
                if CJ_Cast("Aimed Shot") then numsteady = 0 return end
        end
        
        if GetUnitSpeed("player") == 0 then
                if CJ_CD("Chimera Shot") > 5 or UnitPower("player") >= 80 or CJ_HB("Rapid Fire") or CJ_Hero() or CJ_HP("target") > 80 then
                        if CJ_Cast("Aimed Shot") then numsteady = 0 return end
                end
        elseif CJ_HB("Aspect of the Fox") then
                if CJ_Cast("Steady Shot") then numsteady = numsteady + 1; if numsteady >= 2 then numsteady = 0 end return end
        end
        
        --if (UnitPower("player") >= 66 or CJ_CD("Chimera Shot") > 5) and (CJ_HP("target") < 80 and not CJ_HB("Rapid Fire") and not CJ_Hero() and not CJ_HB("Berserking")) then
        --      if CJ_Cast("Arcane Shot") then numsteady = 0 return end
        --end
        
        if CJ_Cast("Steady Shot") then numsteady = numsteady + 1; if numsteady >= 2 then numsteady = 0 end return end;
        if CJ_Cast("Immolation Trap") then numsteady = 0 return end
        if CJ_Cast("Snake Trap") then numsteady = 0 return end
        if CJ_Cast("Raptor Strike") then numsteady = 0 return end
end

------------------------
------Survival----------
------------------------
local lastexplosive = false;
function CJ_SurvBuffs()
        return false;
end

function CJSurvHunterRot()
        if CJ_OC() then StopAttack() return end
        if AmIFacing == false then return end;
        
        if cj_wildaspect then
                if not CJ_HB("Aspect of the Wild") then
                        CJ_Cast("Aspect of the Wild")
                end
        else
                if GetUnitSpeed("player") > 0 then
                        if not CJ_HB("Aspect of the Fox") then
                                if CJ_Cast("Aspect of the Fox") then return end;
                        end
                else
                        if not CJ_HB("Aspect of the Hawk") then
                                if CJ_Cast("Aspect of the Hawk") then return end
                                
                        end
                end
        end
        
        StartAttack()
        
        if not IsPetAttackActive() then
                PetAttack("target")
        end
        
        if not CJ_GCD() then return end;
        if CJ_Casting() then return end
        if CJ_OffensiveDispel("Tranquilizing Shot") then return end
        
        if UnitExists("pet") and not UnitIsDead("pet") and CJ_HP("pet") < 30 and not UnitBuff("pet","Mend Pet") then
                if CJ_Cast("Mend Pet") then return end
        end
        
        if not CJ_HD("Hunter's Mark") and not CJ_HB("Rapid Fire") and not CJ_HB("Berserking") and CJ_HP("target") > 10 and UnitHealth("target") > 1000 and not cj_aoemode and not (UnitHealth("target") <= (UnitHealth("player")*3.5)) and IsSpellInRange("Hunter's Mark","target") then
                if CJ_Cast("Hunter's Mark") then return end
        end
        
        if cj_aoemode then
                if CJ_Cast("Multi-Shot") then lastexplosive = false return end
                if CJ_Cast("Cobra Shot") then lastexplosive = false return end
        end
        
        if not CJ_HD("Serpent Sting") and GetTime() - lastss > 3 and not cj_aoemode then
                if CJ_Cast("Serpent Sting") then lastss = GetTime() lastexplosive = false return end
        end
        
        if cj_cooldowns then
                CJ_Cast("Rapid Fire")
                if CJ_HB("Rapid Fire") then
                        if CJ_Cast("Call of the Wild") then return end
                end
        end
        
        if not lastexplosive and not cj_aoemode then
                if CJ_Cast("Explosive Shot") then lastexplosive = true return end
        end
        
        if not CJ_HD("Black Arrow") and GetTime() - lastba > 3 and not cj_aoemode then
                if CJ_Cast("Black Arrow") then lastba = GetTime(); lastexplosive = false return end
        end
        
        if CJ_Cast("Kill Shot") then lastexplosive = false return end
        
        if UnitPower("player") >= 70 and not CJ_HB("Lock and Load") and not cj_aoemode then
                if CJ_Cast("Arcane Shot") then lastexplosive = false return end
        end
        
        if CJ_Cast("Cobra Shot") then lastexplosive = false return end
        if CJ_Cast("Steady Shot") then lastexplosive = false return end
        if CJ_Cast("Immolation Trap") then return end
        if CJ_Cast("Snake Trap") then return end
        if CJ_Cast("Raptor Strike") then return end

end

------------------------
------Beastmaster-------
------------------------

function CJ_BMBuffs()
        return false;
end

function CJBMHunterRot()
        if CJ_OC() then StopAttack() return end
        if AmIFacing == false then return end;
        if UnitThreatSituation("player","target") == 2 or UnitThreatSituation("player","target") == 3 then
                if CJ_Cast("Feign Death") then FeignTime = GetTime() StopAttack() return end
        else
                if FeignTime ~= nil then
                        if GetTime() < FeignTime+2 and CJ_HB("Feign Death") then
                                return
                        else
                                CancelUnitBuff("player","Feign Death")
                                FeignTime = nil
                        end
                end
        end
        if cj_wildaspect then
                if not CJ_HB("Aspect of the Wild") then
                        CJ_Cast("Aspect of the Wild")
                end
        else
                if GetUnitSpeed("player") > 0 then
                        if not CJ_HB("Aspect of the Fox") then
                                CJ_Cast("Aspect of the Fox");
                        end
                else
                        if not CJ_HB("Aspect of the Hawk") then
                                CJ_Cast("Aspect of the Hawk")
                        end
                end
        end
        
        StartAttack()
        
        if not IsPetAttackActive() then
                PetAttack("target")
        end
        
        if not CJ_GCD() then return end;
        if CJ_Casting() then return end
        
        if not CJ_HD("Hunter's Mark") and CJ_HP("target") > 10 and UnitHealth("target") > 1000 then
                if CJ_Cast("Hunter's Mark") then return end
        end
        
        if UnitExists("pet") and not UnitIsDead("pet") and CJ_HP("pet") < 60 and not UnitBuff("pet","Mend Pet") then
                if CJ_Cast("Mend Pet") then return end
        end
        
        if CJ_OffensiveDispel("Tranquilizing Shot") then return end
        
        if UnitPower("player") > 60 and cj_cooldowns and GetPetActionCooldown(4)~=0 then
                CJ_Cast("Bestial Wrath")
        end
        
        if cj_aoemode then
                if CJ_Cast("Multi-Shot") then return end
                if CJ_Cast("Cobra Shot") then return end
        end
        
        if not CJ_HD("Serpent Sting") and GetTime() - lastss > 3 then
                if CJ_Cast("Serpent Sting") then lastss = GetTime() return end
        end
        
        if CJ_Cast("Kill Shot") then return end
        
        if cj_cooldowns and not CJ_Hero() and not CJ_HB("The Beast Within") then
                CJ_Cast("Rapid Fire");
                if CJ_HB("Rapid Fire") then
                        CJ_Cast("Call of the Wild")
                end

        end
        if GetPetActionCooldown(4)~=0 then
                if CJ_Cast("Kill Command") then return end
                if CJ_Cast("Intimidation") then return end
        end
        if cj_cooldowns and UnitPower("player") <= 20 then
                CJ_Cast("Fervor")
        end
        
        local _,_,_,count = UnitBuff('pet',GetSpellInfo(19615));
        
        if count ~= nil then
                if count == 5 and not CJ_HB("The Beast Within") then
                        if CJ_Cast("Focus Fire") then return end
                end
        end
        
        if UnitPower("player") >= 90 or CJ_HB("The Beast Within") then
                if CJ_Cast("Arcane Shot") then return end
        end
        
        if CJ_Cast("Raptor Strike") then CJ_Cast("Disengage") return end
        
        if CJ_Cast("Cobra Shot") then return end
        if CJ_Cast("Steady Shot") then return end
        if CJ_Cast("Immolation Trap") then return end
        if CJ_Cast("Snake Trap") then return end

end
