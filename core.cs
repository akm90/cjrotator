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

using CJR.Classes;
using CJR.Lists;

namespace CJR
{
	class CJR : CombatRoutine
	{
		public override sealed string Name { get { return "CJR"; } }
        public override WoWClass Class { get { return StyxWoW.Me.Class; } }
		
		public override void Combat()
		{
			Paladin.RetPallyCombat();
		}
	}
}