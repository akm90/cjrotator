using System.Collections.Generic;

namespace CJR.Lists
{
	public class InterruptBlacklist
	{
		public static Dictionary<string,List<string>> InterruptBlist
		{
			get
			{
                return new Dictionary<string, List<string>>
					{
						{"High Priestess Kilnara",new List<string>(new string[]{"Shadow Bolt"})},
                        {"Venomancer Mauri",new List<string>(new string[]{"Poison Bolt"})},
						{"Hex Lord Malacrass",new List<string>(new string[]{"Chain Lightning","Mind Blast"})},
						{"Maloriak",new List<string>(new string[]{"Release Aberrations"})},
                        {"Naz'jar Spiritmender",new List<string>(new string[]{"Wrath"})},
						{"Stonecore Rift Conjurer",new List<string>(new string[]{"Shadow Bolt"})},
						{"Temple Adept",new List<string>(new string[]{"Holy Smite"})},
						{"Twilight Portal Shaper",new List<string>(new string[]{"Shadow Bolt"})},
						{"Lesser Priest of Bethekk",new List<string>(new string[]{"Shadow Bolt"})},
                        {"Stonecore Earthshaper",new List<string>(new string[]{"Lava Burst","Ground Shock"})}
					};
			}
		}
	}
}