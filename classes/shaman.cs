using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading;

using Styx;
using Styx.Combat.CombatRoutine;
using Styx.Helpers;
using Styx.Logic;
using Styx.Logic.BehaviorTree;
using Styx.Logic.Combat;
using Styx.Logic.Pathing;
using Styx.Logic.Profiles;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;

using CJR.Helpers;
using TreeSharp;
using Action = TreeSharp.Action;

namespace CJR.Classes
{
    public class Shaman
    {
        private static LocalPlayer Me { get { return ObjectManager.Me; } }
        private static WoWUnit targ { get { return ObjectManager.Me.CurrentTarget; } }

        public static Composite EnhShamanCombat()
        {
            return new PrioritySelector(
                new Decorator(cjr => targ == null,
                        new Action(cjr => RunStatus.Success)),

                new Decorator(cjr => targ != null && (lib.GCD() || targ.Distance > (10 + (lib.Talent(3, 3) * 10))),
                    new Action(cjr => RunStatus.Success)),

                lib.Cast("Call of the Elements",cjr => lib.NeedsTotems()),
                lib.Cast("Lava Lash"),
                lib.Cast("Lightning Bolt", cjr => lib.BS("Maelstrom Weapon") == 5),
                lib.Cast("Unleash Elements"),
                lib.Cast("Flame Shock", cjr => !lib.HD("Flame Shock") || lib.DTR(targ,"Flame Shock",true) < 3),
                lib.Cast("Earth Shock"),
                lib.Cast("Stormstrike")
            );
        }

        public static Composite EnhShamanCombatBuffs()
        {
            return new PrioritySelector(
                new Decorator(ret => lib.WeaponEnchant(),
                    new Sequence(
                        new Action(ret => Lua.DoString("CancelItemTempEnchantment(1)")),
                        new Action(ret => Lua.DoString("CancelITemTempEnchantment(2)")),
                        lib.Cast("Windfury Weapon"),
                        lib.Cast("Flametongue Weapon")
                    )
                ),
                lib.Cast("Lightning Shield",cjr => !lib.HB("Lightning Shield"))
            );
        }

    
    }
}
