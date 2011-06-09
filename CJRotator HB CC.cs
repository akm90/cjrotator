using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
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

namespace CJRotatorCC
{
    class CJRotatorCC : CombatRoutine
    {
		private static LocalPlayer Me { get { return ObjectManager.Me; } }
		private bool initialized = false;
		private int currentRotation = 0;
        public override void Combat()
        {
			if (Me.Mounted){
				Mount.Dismount();
			}
			List<string> blargh = Lua.GetReturnValues("return cj_action","ashdioahsdas.lua");
			if (blargh[0] != "true"){
				Lua.DoString("cj_action = true");
			}
			if (Me.GotTarget && !Me.CurrentTarget.IsAlive)
			{
				Me.ClearTarget();
			}
			
			if (!Me.GotTarget && Me.GotAlivePet && Me.Pet.GotTarget){
				Me.Pet.CurrentTarget.Target();
			}
			
            WoWMovement.Face();
			if (currentRotation == 22){
				if (ObjectManager.Me.Shapeshift.ToString() !="Cat"){
					SpellManager.Cast("Cat Form");
				}
				MeleeMove();
			}else if (currentRotation == 11 || currentRotation == 12 || currentRotation == 13 || currentRotation == 52 || currentRotation == 53 || currentRotation == 71 || currentRotation == 72 || currentRotation == 73 || currentRotation == 82 || currentRotation > 100){
					MeleeMove();
			}else{
				RangedMove();
			}
        }
		
		public override void Pull(){
			if (Me.Mounted){
				Mount.Dismount();
			}
			List<string> blargh = Lua.GetReturnValues("return cj_action","ashdioahsdas.lua");
			if (blargh[0] != "true"){
				Lua.DoString("cj_action = true");
			}
			if (Me.GotTarget && !Me.CurrentTarget.IsAlive)
			{
				Me.ClearTarget();
			}
			
			if (!Me.GotTarget && Me.GotAlivePet && Me.Pet.GotTarget){
				Me.Pet.CurrentTarget.Target();
			}
			
            WoWMovement.Face();
			if (currentRotation == 22){
				if (ObjectManager.Me.Shapeshift.ToString() !="Cat"){
					SpellManager.Cast("Cat Form");
				}
				MeleeMove();
			}else if (currentRotation == 11 || currentRotation == 12 || currentRotation == 13 || currentRotation == 52 || currentRotation == 53 || currentRotation == 71 || currentRotation == 72 || currentRotation == 73 || currentRotation == 82 || currentRotation > 100){
					MeleeMove();
			}else{
				RangedMove();
			}
		}
		
        public override sealed string Name { get { return "CJRotator Custom Class"; } }
        public override WoWClass Class { get { return StyxWoW.Me.Class; } }
		
		void MeleeMove()
        {
            if (Me.CurrentTarget.Distance > 2f){
				Navigator.MoveTo(WoWMovement.CalculatePointFrom(ObjectManager.Me.CurrentTarget.Location, 2f));
			}else{
				WoWMovement.MoveStop();
			}
        }
		
		void RangedMove(){
			if (Me.CurrentTarget.Distance > 25){
				Navigator.MoveTo(WoWMovement.CalculatePointFrom(ObjectManager.Me.CurrentTarget.Location, 25f));
			}else{
				WoWMovement.MoveStop();
			}
		}
		
		public override bool NeedRest
        {
            get
            {
				if (!initialized){
					List<string> blah = Lua.GetReturnValues("return cj_currentRotation","basdoajdo.lua");
					currentRotation = blah[0].ToInt32();
					initialized = true;
				}
				
                if (ObjectManager.Me.Combat)
                {
                    return false;
                }

                if (ObjectManager.Me.Auras.ContainsKey("Resurrection Sickness"))
                {
                    return true;
                }

                if (ObjectManager.Me.IsSwimming)
                {
                    return false;
                }

                bool ret = false;

                if (ObjectManager.Me.HealthPercent <= 35)
                {
                   ret = true;
                }

                if (ObjectManager.Me.ManaPercent <= 35)
                {
                    ret = true;
                }

                return ret;
            }
        }
		
		public override void Rest()
        {
            if (Me.HealthPercent < 35)
            {
                Styx.Logic.Common.Rest.Feed();
            }

			
            if (Me.ManaPercent < 35)
            {
                Styx.Logic.Common.Rest.Feed();
            }
        }
    }
}