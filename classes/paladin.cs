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
    public class Paladin
    {
        private static LocalPlayer Me { get { return ObjectManager.Me; } }
        private static WoWUnit targ { get { return ObjectManager.Me.CurrentTarget; } }

        public static Composite RetPallyCombat()
        {

            return new PrioritySelector(

                    new Decorator(cjr => targ == null,
                        new Action(cjr => RunStatus.Success)),

                    new Decorator(cjr => targ != null && (targ.Distance > (10 + (lib.Talent(3, 3) * 10))),
                        new Action(cjr => RunStatus.Success)),
                    lib.Cast("Judgement", cjr => targ.Distance > 9),
                    lib.Cast("Exorcism", cjr => lib.HB("The Art of War") && targ.Distance > 5),
                    lib.Cast("Inquisition", cjr => (lib.HB("Divine Purpose") || Me.CurrentHolyPower == 3) && !StyxWoW.Me.HasAura("Inquisition")),
                    lib.Cast("Inquisition", cjr => (lib.HB("Divine Purpose") || Me.CurrentHolyPower == 3) && lib.BTR("Inquisition") < 9 && StyxWoW.Me.HasAura("Inquisition")),
                    new Decorator(cjr => Me.CurrentHolyPower < 3,
                        new PrioritySelector(
                            lib.Cast("Divine Storm", cjr => (lib.AoE() == true && lib.Talent(3, 3) == 1)),
                            lib.Cast("Crusader Strike", cjr => (lib.AoE() == false))
                        )
                    ),
                    lib.Cast("Exorcism", cjr => lib.HB("The Art of War") && lib.IsUDDemon()),
                    lib.Cast("Hammer of Wrath"),
                    lib.Cast("Exorcism", cjr => lib.HB("The Art of War") && !lib.IsUDDemon()),
                    lib.Cast("Templar's Verdict", cjr => Me.CurrentHolyPower == 3 || lib.HB("Divine Purpose")),
                    lib.Cast("Judgement"),
                    lib.Cast("Holy Wrath"),
                    lib.Cast("Consecration", cjr => lib.AoE() == true && Me.ManaPercent > 80)
             );
        }

        public static Composite RetPallyBuffs()
        {
            return new PrioritySelector(

                   lib.Cast("Seal of Righteousness", cjr => lib.Adds.Count(u => u.DistanceSqr < 8 * 8) >= 3 && !lib.HB("Seal of Righteousness")),
                   lib.Cast("Seal of Truth", cjr => !lib.HB("Seal of Truth"))
            );
        }
    }
}