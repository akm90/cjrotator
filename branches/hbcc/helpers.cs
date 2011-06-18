using Styx.Logic;
using Styx.Logic.Combat;
using Styx.Logic.Pathing;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;
using System;
using System.Linq;
using CJR.Lists;
using System.Collections.Generic;
using Styx;
using Styx.Helpers;
using TreeSharp;
using Action = TreeSharp.Action;

namespace CJR.Helpers
{
    internal static class lib
    {
        private static LocalPlayer Me { get { return ObjectManager.Me; } }
        private static readonly List<WoWPetSpell> PetSpells = new List<WoWPetSpell>();

        public delegate WoWUnit UnitSelectionDelegate(object context);

        public delegate bool SimpleBooleanDelegate(object context);

        public static int Talent(int tree, int talent)
        {
            List<string> a = Lua.GetReturnValues("return GetTalentInfo(" + tree.ToString() + "," + talent.ToString() + ",false,false,nil)");

            int num = Convert.ToInt32(a[4]);

            return num;
        }

        public static bool Face()
        {
            return Me.IsFacing(Me.CurrentTarget);
        }

        public static List<WoWUnit> Adds
        {
            get
            {
                return ObjectManager.GetObjectsOfType<WoWUnit>(false, false).Where(p => p.IsHostile && !p.Dead && !p.IsPet && p.DistanceSqr <= 40 * 40).ToList();
            }
        }
        /*-------------------------
        --------Unit Type Check----
        -------------------------*/
        //Target is a raid boss
        public static bool IsRaidBoss()
        {
            List<string> classcheck = Lua.GetReturnValues("return UnitClassification(\"target\")", "abc.lua");
            if (classcheck[0] == "worldboss")
            {
                return true;
            }
            return false;
        }

        //Is any boss level mob
        public static bool IsGenericBoss()
        {
            return Lists.BossList.BossIds.Contains(Me.CurrentTarget.Entry);
        }

        //Is Undead of Demon
        public static bool IsUDDemon()
        {
            return Me.CurrentTarget.CreatureType == WoWCreatureType.Undead
                    || Me.CurrentTarget.CreatureType == WoWCreatureType.Demon;
        }

        /*-------------------------
        --------Buff Crap----------
        -------------------------*/
        //Has Buff
        public static bool HB(string BuffName)
        {
            List<string> b = Lua.GetReturnValues("return UnitBuff(\"player\",\"" + BuffName + "\")", "abc.lua");
            if (Equals(null, b))
            {
                return false;
            }
            else
            {
                return true;
            }
        }
        //Stacks of buff
        public static int BS(string BuffName)
        {
            List<string> b = Lua.GetReturnValues("return UnitBuff(\"player\",\"" + BuffName + "\")", "abc.lua");
            if (Equals(null, b))
            {
                return 0;
            }

            return Convert.ToInt32(b[3]);
        }
        //Buff Time Remaining
        public static double BTR(string BuffName)
        {
            List<string> a = Lua.GetReturnValues("return GetTime()", "abc.lua");
            List<string> b = Lua.GetReturnValues("return UnitBuff(\"player\",\"" + BuffName + "\")", "abc.lua");
            if (Equals(null, b))
            {
                return 0;
            }

            return Convert.ToDouble(b[6]) - Convert.ToDouble(a[0]);
        }
        //Heroism
        public static bool Hero()
        {
            return Me.HasAnyAura("Heroism", "Time Warp", "Ancient Hysteria", "Bloodlust");
        }

        /*-------------------------
        --------Debuff Checks------
        -------------------------*/
        //Has Debuff Generic
        public static bool OD(string BuffName)
        {
            List<string> b = Lua.GetReturnValues("return UnitDebuff(\"target\",\"" + BuffName + "\")", "abc.lua");
            if (Equals(null, b))
            {
                return false;
            }
            else
            {
                return true;
            }
        }
        //Has Your Debuff
        public static bool HD(string BuffName)
        {
            List<string> b = Lua.GetReturnValues("return UnitDebuff(\"target\",\"" + BuffName + "\")", "abc.lua");

            if (Equals(null, b))
            {
                return false;
            }

            string rank = b[1];

            List<string> c = Lua.GetReturnValues("return UnitDebuff(\"target\",\"" + BuffName + "\"," + rank + ",\"PLAYER\")", "abc.lua");
            if (Equals(null, c))
            {
                return false;
            }
            else
            {
                return true;
            }
        }
        //Stacks of Debuff
        public static int DS(string BuffName)
        {
            List<string> b = Lua.GetReturnValues("return UnitDebuff(\"target\",\"" + BuffName + "\")", "abc.lua");

            if (Equals(null, b))
            {
                return 0;
            }

            string rank = b[1];

            List<string> c = Lua.GetReturnValues("return UnitDebuff(\"target\",\"" + BuffName + "\"," + rank + ",\"PLAYER\")", "abc.lua");
            if (Equals(null, c))
            {
                return 0;
            }

            return Convert.ToInt32(c[3]);
        }
        //Debuff Time Remaining
        public static double DTR(string BuffName)
        {
            List<string> a = Lua.GetReturnValues("return GetTime()", "abc.lua");
            List<string> b = Lua.GetReturnValues("return UnitDebuff(\"target\",\"" + BuffName + "\")", "abc.lua");

            if (Equals(null, b))
            {
                return 0;
            }

            string rank = b[1];

            List<string> c = Lua.GetReturnValues("return UnitDebuff(\"target\",\"" + BuffName + "\"," + rank + ",\"PLAYER\")", "abc.lua");
            if (Equals(null, c))
            {
                return 0;
            }

            return Convert.ToDouble(c[6]) - Convert.ToDouble(a[0]);
        }
        //Debuff on Self
        public static bool HSD(string BuffName)
        {
            List<string> b = Lua.GetReturnValues("return UnitDebuff(\"player\",\"" + BuffName + "\")", "abc.lua");
            if (Equals(null, b))
            {
                return false;
            }
            else
            {
                return true;
            }
        }
        //Debuff Stacks on Self
        public static int SDS(string BuffName)
        {
            List<string> b = Lua.GetReturnValues("return UnitDebuff(\"player\",\"" + BuffName + "\")", "abc.lua");
            if (Equals(null, b))
            {
                return 0;
            }

            return Convert.ToInt32(b[3]);
        }

        /*-------------------------
        --------HP/MP Checks-------
        -------------------------*/
        public static double HP(WoWUnit unit)
        {
            return unit.HealthPercent;
        }

        public static double MP(WoWUnit unit)
        {
            return unit.ManaPercent;
        }

        /*-------------------------
        --------Spell Functions----
        -------------------------*/
        //Casts a Spell. 

        public static Composite Cast(string name)
        {
            return Cast(name, ret => true);
        }

        public static Composite Cast(string name, SimpleBooleanDelegate requirements)
        {
            return Cast(name, ret => StyxWoW.Me.CurrentTarget, requirements);
        }

        public static Composite Cast(string name, UnitSelectionDelegate onUnit)
        {
            return Cast(name, onUnit, ret => true);
        }

        public static Composite Cast(string name, UnitSelectionDelegate onUnit, SimpleBooleanDelegate requirements)
        {
            return new Decorator(
                ret =>
                {
                    return requirements != null && onUnit != null && requirements(ret) && onUnit(ret) != null && Usable(name);
                },
                    new Action(
                        ret =>
                        {
                            Logging.Write("[CJR] Casting: " + name);
                            SpellManager.Cast(name, onUnit(ret));
                        })
                );
        }


        public static RunStatus CastTarget(string SpellName, string target)
        {
            if (SpellManager.CanCast(SpellName))
            {
                Lua.DoString("CastSpellByName(\"" + SpellName + "\",\"" + target + "\")");
                return RunStatus.Success;
            }
            else
            {
                return RunStatus.Failure;
            }
        }

		public static bool Usable(string SpellName)
		{
			List<string> a = Lua.GetReturnValues("return IsUsableSpell(\"" + SpellName + "\")", "abc.lua");
			
			if (a[0] == "1" && a[1] == "")
			{
				if (CD(SpellName) < .25)
				{
					return true;
				}
			}
			
			return false;
		}
		
        //Returns Cooldown of the Spell
        public static double CD(string SpellName)
        {
            List<string> a = Lua.GetReturnValues("return GetTime()", "abc.lua");
            List<string> b = Lua.GetReturnValues("return GetSpellCooldown(\"" + SpellName + "\")", "abc.lua");

            if (Equals(b, null))
            {
                return 9999;
            }

            if (b[0] == "0")
            {
                return 0;
            }
            else
            {
                return Convert.ToDouble(b[1]) - (Convert.ToDouble(a[0]) - Convert.ToDouble(b[0]));
            }
        }

        //Returns if you are currently casting.
        public static bool Casting()
        {
            List<string> a = Lua.GetReturnValues("return GetTime()", "abc.lua");
            List<string> b = Lua.GetReturnValues("return UnitCastingInfo(\"player\")", "abc.lua");
            List<string> c = Lua.GetReturnValues("return UnitChannelInfo(\"player\")", "abc.lua");
            List<string> d = Lua.GetReturnValues("return GetNetStats()", "abc.lua");

            if (!Equals(b, null))
            {
                if (((Convert.ToDouble(b[5]) - 30) - (Convert.ToDouble(a[0]) * 1000) - (Convert.ToDouble(d[3]))) < 0)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }

            if (!Equals(c, null))
            {
                if (c[0] == "Drain Soul")
                {
                    return false;
                }

                if (((Convert.ToDouble(c[5]) - 30) - (Convert.ToDouble(a[0]) * 1000) - (Convert.ToDouble(d[3]))) < 0)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }

            return false;
        }

        public static RunStatus Interrupt(string SpellName)
        {
            if (!SpellManager.CanCast(SpellName))
            {
                return RunStatus.Failure;
            }
            List<string> a = Lua.GetReturnValues("return UnitExists(\"focus\")", "abc.lua");
            List<string> b = Lua.GetReturnValues("return UnitCanAttack(\"player\",\"focus\")", "abc.lua");
            List<string> c = Lua.GetReturnValues("return UnitName(\"focus\")", "abc.lua");
            List<string> d = Lua.GetReturnValues("return UnitCastingInfo(\"target\")", "abc.lua");
            List<string> e = Lua.GetReturnValues("return UnitChannelInfo(\"target\")", "abc.lua");
            List<string> f = Lua.GetReturnValues("return UnitCastingInfo(\"focus\")", "abc.lua");
            List<string> g = Lua.GetReturnValues("return UnitChannelInfo(\"focus\")", "abc.lua");
            List<string> h = Lua.GetReturnValues("return UnitCanAttack(\"player\",\"target\")", "abc.lua");
            List<string> i = Lua.GetReturnValues("return UnitExists(\"target\")", "abc.lua");

            if (a[0] != "" && b[0] != "")
            {
                if (f[8] != "1")
                {
                    if (!Lists.InterruptBlacklist.InterruptBlist[c[0]].Contains(f[0]))
                    {
                        return CastTarget(SpellName, "focus");
                    }
                }

                if (g[7] != "1")
                {

                    if (!Lists.InterruptBlacklist.InterruptBlist[c[0]].Contains(g[0]))
                    {
                        return CastTarget(SpellName, "focus");
                    }
                }
            }

            if (i[0] != "" && h[0] != "")
            {
                string name = Me.CurrentTarget.Name;
                if (d[8] != "1")
                {
                    if (!Lists.InterruptBlacklist.InterruptBlist[name].Contains(d[0]))
                    {
                        Cast(SpellName);
                    }
                }

                if (e[7] != "1")
                {
                    if (!Lists.InterruptBlacklist.InterruptBlist[name].Contains(e[0]))
                    {
                        Cast(SpellName);
                    }
                }
            }

            return RunStatus.Failure;
        }

        public static bool PetInterrupt(string SpellName)
        {
            if (!(PetUsable(SpellName)))
            {
                return false;
            }
            List<string> a = Lua.GetReturnValues("return UnitExists(\"focus\")", "abc.lua");
            List<string> b = Lua.GetReturnValues("return UnitCanAttack(\"player\",\"focus\")", "abc.lua");
            List<string> c = Lua.GetReturnValues("return UnitName(\"focus\")", "abc.lua");
            List<string> d = Lua.GetReturnValues("return UnitCastingInfo(\"target\")", "abc.lua");
            List<string> e = Lua.GetReturnValues("return UnitChannelInfo(\"target\")", "abc.lua");
            List<string> f = Lua.GetReturnValues("return UnitCastingInfo(\"focus\")", "abc.lua");
            List<string> g = Lua.GetReturnValues("return UnitChannelInfo(\"focus\")", "abc.lua");
            List<string> h = Lua.GetReturnValues("return UnitCanAttack(\"player\",\"target\")", "abc.lua");
            List<string> i = Lua.GetReturnValues("return UnitExists(\"target\")", "abc.lua");

            if (a[0] != "" && b[0] != "")
            {
                if (f[8] != "1")
                {
                    if (!Lists.InterruptBlacklist.InterruptBlist[c[0]].Contains(f[0]))
                    {
                        return PetCastFocus(SpellName);
                    }
                }

                if (g[7] != "1")
                {

                    if (!Lists.InterruptBlacklist.InterruptBlist[c[0]].Contains(g[0]))
                    {
                        return PetCastFocus(SpellName);
                    }
                }
            }

            if (i[0] != "" && h[0] != "")
            {
                string name = Me.CurrentTarget.Name;
                if (d[8] != "1")
                {
                    if (!Lists.InterruptBlacklist.InterruptBlist[name].Contains(d[0]))
                    {
                        return PetCast(SpellName);
                    }
                }

                if (e[7] != "1")
                {
                    if (!Lists.InterruptBlacklist.InterruptBlist[name].Contains(e[0]))
                    {
                        return PetCast(SpellName);
                    }
                }
            }

            return false;
        }

        public static bool PetUsable(string action)
        {
            if (!Me.GotAlivePet)
            {
                return false;
            }
            PetSpells.Clear();
            PetSpells.AddRange(StyxWoW.Me.PetSpells);
            WoWPetSpell petAction = PetSpells.FirstOrDefault(p => p.ToString() == action);
            if (petAction == null || petAction.Spell == null)
            {
                return false;
            }

            return !petAction.Spell.Cooldown;
        }

        public static bool PetCast(string PetSpell)
        {
            if (!PetUsable(PetSpell))
            {
                return false;
            }

            var spell = PetSpells.FirstOrDefault(p => p.ToString() == PetSpell);
            if (spell == null)
                return false;

            Lua.DoString("CastPetAction({0})", spell.ActionBarIndex + 1);
            return true;
        }

        public static bool PetCastFocus(string PetSpell)
        {
            if (!PetUsable(PetSpell))
            {
                return false;
            }
            var spell = PetSpells.FirstOrDefault(p => p.ToString() == PetSpell);
            if (spell == null)
                return false;

            Lua.DoString("CastPetAction({0}, 'focus')", spell.ActionBarIndex + 1);
            return true;
        }

        public static bool GCD()
        {
            List<string> a = Lua.GetReturnValues("return GetSpellCooldown(\"61304\")", "abc.lua");

            if (a[0] == "0")
            {
                return false;
            }

            return true;
        }

        public static bool HasAnyAura(this WoWUnit unit, params string[] auraNames)
        {
            var auras = unit.GetAllAuras();
            var hash = new HashSet<string>(auraNames);
            return auras.Any(a => hash.Contains(a.Name));
        }

        public static bool AoE()
        {
            return false;
        }
    }
}