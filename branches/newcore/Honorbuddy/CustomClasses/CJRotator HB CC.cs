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
			
			List<string> blargh = Lua.GetReturnValues("return cj_stopmovement","ashdioahsdas.lua");
			
			if (blargh[0] == "1")
			{
				return;
			}
			List<WoWUnit> addslist = (from unit in ObjectManager.ObjectList
                                      where unit is WoWUnit
                                      let u = unit.ToUnit()
                                      where u.Distance2D < 40
                                          && !u.Dead && u.Combat && u.IsTargetingMeOrPet && u.Attackable
                                      select u).ToList();
		
			List<string> blargh2 = Lua.GetReturnValues("return cj_aoemode","ashdioahsdas.lua");
			
			if (addslist.Count >= 3){
				if (blargh2[0] != "1"){
					Lua.DoString("CJAoECheckbox:Click()");
				}
			}else{
				if (blargh2[0] != ""){
					Lua.DoString("CJAoECheckbox:Click()");
				}
			}
		
			if (Me.Mounted){
				Mount.Dismount();
			}
			
			Lua.DoString("if not cj_action then NAActionButton:Click() end");

			
			if (Me.GotTarget && !Me.CurrentTarget.IsAlive)
			{
				Me.ClearTarget();
			}
			
			if (!Me.GotTarget && Me.GotAlivePet && Me.Pet.GotTarget){
				Me.Pet.CurrentTarget.Target();
			}
			
			if (!Me.GotTarget){		  
				addslist[0].Target();
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
			
			List<string> blargh = Lua.GetReturnValues("return cj_stopmovement","ashdioahsdas.lua");
			
			if (blargh[0] == "1")
			{
				return;
			}
			if (Me.Mounted){
				Mount.Dismount();
			}
			
			Lua.DoString("if not cj_action then NAActionButton:Click() end");
			
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
			float cr = System.Convert.ToSingle(Me.CurrentTarget.CombatReach + 2.8333333);
			if (cr < 5)
			{
				cr = 5;
			}
			
            if (Me.CurrentTarget.Distance > cr){
				Navigator.MoveTo(WoWMovement.CalculatePointFrom(ObjectManager.Me.CurrentTarget.Location, System.Convert.ToSingle(cr - .25)));
			}else{
				WoWMovement.MoveStop();
			}
        }
		
		void RangedMove(){
		
			float cr = System.Convert.ToSingle(Me.CurrentTarget.CombatReach + 2.8333333);
			if (cr < 5)
			{
				cr = 5;
			}
			if (Me.CurrentTarget.Distance > cr + 25){
				Navigator.MoveTo(WoWMovement.CalculatePointFrom(ObjectManager.Me.CurrentTarget.Location, System.Convert.ToSingle(cr + 25f)));
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
			if (!Me.IsAlive)
			{
				return;
			}
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