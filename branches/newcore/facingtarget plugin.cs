//!CompilerOption:Optimize:On
// the above line is a flag that turns on optimization.. leave it as it is

// ********************* Highvoltz's Premium Honorbuddy Plugin Template **********************

// if the project files are not in HB's folder you can have the Post Build events automatically copy the files over
// to the Honorbuddy folder. To set it up go to Project -> Project Properties -> Build Events -> Edit Post Build
// and remove the 'rem' at the front of the line and change the 2nd string to the path you want to copy the files to.
// can be relative or absolute path. If you have a dropbox account you can also have it copy directly to your Dropbox folder
// xcopy "$(ProjectDir)*.cs" "$(ProjectDir)..\..\Honorbuddy\Plugins\TestPLGIN" /I /S /Y

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Windows.Forms;
using System.Diagnostics;
using System.IO;

using Styx;
using Styx.Helpers;
using Styx.Logic;
using Styx.Logic.AreaManagement;
using Styx.Logic.BehaviorTree;
using Styx.Logic.Combat;
using Styx.Logic.Inventory.Frames.Gossip;
using Styx.Logic.Inventory.Frames.LootFrame;
using Styx.Logic.Pathing;
using Styx.Logic.Profiles;
using Styx.Plugins;
using Styx.Plugins.PluginClass;
using Styx.WoWInternals;
using Styx.WoWInternals.World;
using Styx.WoWInternals.WoWObjects;
using System.Collections.Specialized;

namespace facing
{
    class FacingTarget : HBPlugin, IDisposable
    {
        public override string Name { get { return "facingtarget"; } }
        public override string Author { get { return "CptJesus"; } }
        public override Version Version { get { return new Version(1, 0, 0, 0); } }
        public override string ButtonText { get { return Name; } }
        public override bool WantButton { get { return true; } }

        LocalPlayer Me = ObjectManager.Me;

        Thread facingthread;

        public FacingTarget() {
            Logging.Write("FacingTarget Script Started");
        }

        // this gets called on every plugin pulse.. like 13 times per sec, put your main code here
        public override void Pulse()
        {
			 if (Me.CurrentTarget != null && Me.CurrentTarget.IsAlive)
			{
				if (Me.IsSafelyFacing(Me.CurrentTarget))
				{
					Lua.DoString("AmIFacing = true");
				}
				else
				{
					Lua.DoString("AmIFacing = false");
				}
				
				if (Me.CurrentTarget.MeIsSafelyBehind)
				{
					Lua.DoString("AmIBehind = true");
				}
				else
				{
					Lua.DoString("AmIBehind = false");
				}

				Lua.DoString("PlayerToTarget = " + Me.CurrentTarget.Distance);
			}
			else
			{
				Lua.DoString("AmIBehind = false");
				Lua.DoString("PlayerToTarget = 999999999");
			}
        }

        public override void Dispose()
        {
        }
    }
}
