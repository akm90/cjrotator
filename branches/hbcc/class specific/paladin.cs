using System.Linq;
using Styx;
using Styx.Combat.CombatRoutine;
using Styx.Logic.Combat;
using CJR.Helpers;
using Styx.WoWInternals.WoWObjects;
using Styx.WoWInternals;
using System.Threading;

namespace CJR.Classes
{
	public class Paladin
	{
        private static LocalPlayer Me { get { return ObjectManager.Me; } }
        private static WoWUnit targ { get { return ObjectManager.Me.CurrentTarget; } }
		public static void RetPallyCombat()
		{
			
			if (lib.GCD())
			{
				return;
			}
			
			if (targ.Distance > (10 + (lib.Talent(3,3) * 2)))
			{
				return;
			}
			
			if (targ.Distance > 5)
			{
				if (lib.CastSpell("Judgement"))
				{
					return;
				}
				
				if (lib.HB("The Art of War") && lib.Face())
				{
					if (lib.CastSpell("Exorcism"))
					{
						return;
					}
				}
				
				if (!Me.IsMoving && Me.ManaPercent > 40 && !lib.Casting() && lib.Face())
				{
					if (lib.CastSpell("Exorcism"))
					{
						return;
					}
				}
				return;
			}
			
			if (lib.IsUDDemon())
			{
				if (lib.HB("Divine Purpose") || Me.CurrentHolyPower == 3)
				{
					if (!lib.HB("Inquisition"))
					{
						if (lib.CastSpell("Inquisition")) return;
					}
					
					if (lib.BTR("Inquisition") < 7)
					{
						if (lib.CastSpell("Inquisition")) return;
					}
				}
				
				if (Me.CurrentHolyPower < 3 && lib.Face())
				{
					if (lib.CD("Crusader Strike") < .35 && lib.CD("Crusader Strike") > 0){
						double cd = lib.CD("Crusader Strike");
                        int sleep = (int)(cd * 1000);
						Thread.Sleep(sleep);
					}
					if (lib.Adds.Count(u => u.DistanceSqr < 8*8) > 3 && lib.Talent(3,10) > 1)
					{
						if (lib.CastSpell("Divine Storm")) return;
					}else{
						if (lib.CastSpell("Crusader Strike")) return;
					}
				}
				
				if (lib.HB("The Art of War") && lib.Face())
				{
					if (lib.CastSpell("Exorcism")) return;
				}
				
				if (lib.CastSpell("Hammer of Wrath")) return;
				
				if (Me.CurrentHolyPower == 3 && lib.Face())
				{
					if (lib.CastSpell("Templar's Verdict")) return;
				}
				
				if (Me.CurrentHolyPower <= 2 && lib.HB("Divine Purpose") && lib.Face())
				{
					if (lib.CD("Crusader Strike") < .35 && lib.CD("Crusader Strike") > 0){
                        double cd = lib.CD("Crusader Strike");
                        int sleep = (int)(cd * 1000);
						Thread.Sleep(sleep);
					}
					
					if (lib.Adds.Count(u => u.DistanceSqr < 8*8) > 3 && lib.Talent(3,10) > 1)
					{
						if (lib.CastSpell("Divine Storm")) return;
					}else{
						if (lib.CastSpell("Crusader Strike")) return;
					}
				}
				
				if (lib.HB("Divine Purpose") && lib.Face())
				{
					if (lib.CastSpell("Templar's Verdict")) return;
				}
				
				if (lib.Face())
				{
					if (lib.CastSpell("Judgement")) return;
					if (lib.CastSpell("Holy Wrath")) return;
				}
				
				if (lib.Adds.Count(u => u.DistanceSqr < 8*8) >= 5 && Me.ManaPercent > 80)
				{
					if (lib.CastSpell("Consecration")) return;
				}
			}else{
				if (lib.HB("Divine Purpose") || Me.CurrentHolyPower == 3)
				{
					if (!lib.HB("Inquisition"))
					{
						if (lib.CastSpell("Inquisition")) return;
					}
					
					if (lib.BTR("Inquisition") < 7)
					{
						if (lib.CastSpell("Inquisition")) return;
					}
				}
				
				if (Me.CurrentHolyPower < 3 && lib.Face())
				{
					if (lib.CD("Crusader Strike") < .35 && lib.CD("Crusader Strike") > 0){
						double cd = lib.CD("Crusader Strike");
                        int sleep = (int)(cd * 1000);
						Thread.Sleep(sleep);
					}
					if (lib.Adds.Count(u => u.DistanceSqr < 8*8) > 3 && lib.Talent(3,10) > 1)
					{
						if (lib.CastSpell("Divine Storm")) return;
					}else{
						if (lib.CastSpell("Crusader Strike")) return;
					}
				}
				
				if (lib.Face())
				{
					if (lib.CastSpell("Hammer of Wrath")) return;
				}
				
				if (lib.HB("The Art of War") && lib.Face())
				{
					if (lib.CastSpell("Exorcism")) return;
				}				
				
				if (Me.CurrentHolyPower == 3 && lib.Face())
				{
					if (lib.CastSpell("Templar's Verdict")) return;
				}
				
				if (Me.CurrentHolyPower <= 2 && lib.HB("Divine Purpose") && lib.Face())
				{
					if (lib.CD("Crusader Strike") < .35 && lib.CD("Crusader Strike") > 0){
						double cd = lib.CD("Crusader Strike");
                        int sleep = (int)(cd * 1000);
						Thread.Sleep(sleep);
					}
					
					if (lib.Adds.Count(u => u.DistanceSqr < 8*8) > 3 && lib.Talent(3,10) > 1)
					{
						if (lib.CastSpell("Divine Storm")) return;
					}else{
						if (lib.CastSpell("Crusader Strike")) return;
					}
				}
				
				if (lib.HB("Divine Purpose") && lib.Face())
				{
					if (lib.CastSpell("Templar's Verdict")) return;
				}
				
				if (lib.CastSpell("Judgement")) return;
				
				if (lib.Face())
				{
					if (lib.CastSpell("Holy Wrath")) return;
				}
				
				if (lib.Adds.Count(u => u.DistanceSqr < 8*8) >= 5 && Me.ManaPercent > 80)
				{
					if (lib.CastSpell("Consecration")) return;
				}
			}			
		}
		
		public static void RetPallyBuffs()
		{
			if (lib.Adds.Count(u => u.DistanceSqr < 8*8) >= 3 && !lib.HB("Seal of Righteousness"))
			{
				if (lib.CastSpell("Seal of Righteousness")) return;
			}
			else if (!lib.HB("Seal of Truth"))
			{
				if (lib.CastSpell("Seal of Truth")) return;
			}
		}
	}
}