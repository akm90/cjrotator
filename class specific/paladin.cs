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

                   new Decorator(cjr => targ != null && (lib.GCD() || targ.Distance > (10 + (lib.Talent(3, 3) * 2))),
                        new Action(cjr => RunStatus.Success)),

                   lib.Cast("Judgement", cjr => targ.Distance > 5),
                   lib.Cast("Exorcism", cjr => lib.HB("The Art of War") && targ.Distance > 5),

                   lib.Cast("Inquisition", cjr => (lib.HB("Divine Purpose") || Me.CurrentHolyPower == 3) && !StyxWoW.Me.HasAura("Inquisition")),
                   lib.Cast("Inquisition", cjr => (lib.HB("Divine Purpose") || Me.CurrentHolyPower == 3) && lib.BTR("Inquisition") < 7 && StyxWoW.Me.HasAura("Inquisition")),
                   lib.Cast("Divine Storm", cjr => lib.Adds.Count(u => u.DistanceSqr < 8*8) > 3 && lib.Talent(3,10) > 1),
                   lib.Cast("Crusader Strike", cjr => lib.Adds.Count(u => u.DistanceSqr < 8*8) > 3 && lib.Talent(3,10) <= 1),
                   lib.Cast("Exorcism", cjr => lib.HB("The Art of War") && lib.IsUDDemon()),
                   lib.Cast("Hammer of Wrath"),
                   lib.Cast("Exorcism", cjr => lib.HB("The Art of War") && !lib.IsUDDemon()),
                   lib.Cast("Templar's Verdict", cjr => Me.CurrentHolyPower == 3),
                   lib.Cast("Templar's Verdict", cjr => lib.HB("Divine Purpose") && lib.HB("Templar's Verdict")),
                   lib.Cast("Judgement"),
                   lib.Cast("Holy Wrath"),
                   lib.Cast("Consecration", cjr => lib.Adds.Count(u => u.DistanceSqr < 8*8) >= 5 && Me.ManaPercent > 80)
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