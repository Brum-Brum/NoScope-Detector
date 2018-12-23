#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

#define MOD_TAG "\x01\x0B★ \x07[Round Chooser]\x04 "
#define WATER_LEVEL_FEET_IN_WATER 1

char RoundName[][] = 
{
	"ONLY NOSCOPE", "LOW GRAVITY", "HIGH GRAVITY", "AUTOBH + ONLY NOSCOPE"
};
char WeaponList[][] = 
{
	"weapon_glock", "weapon_usp_silencer", "weapon_deagle", "weapon_tec9", "weapon_hkp2000", "weapon_p250", "weapon_fiveseven", "weapon_elite", "weapon_cz75a", "weapon_galilar", "weapon_famas", "weapon_ak47", "weapon_m4a1", "weapon_m4a1_silencer", "weapon_ssg08", "weapon_aug", "weapon_sg556", "weapon_awp", "weapon_scar20", "weapon_g3sg1", "weapon_nova", "weapon_xm1014", "weapon_mag7", "weapon_m249", "weapon_negev", "weapon_mac10", "weapon_mp9", "weapon_mp7", "weapon_ump45", "weapon_p90", "weapon_bizon", "weapon_mp5sd", "weapon_sawedoff", "weapon_knife", "weapon_flashbang", "weapon_hegrenade", "weapon_smokegrenade", "weapon_healthshot", "weapon_decoy", "weapon_molotov", "weapon_incgrenade", "weapon_tagrenade", "weapon_taser", 
};

ConVar Freezetime, LowGravity, HighGravity;

int Round, game = -1;
bool ns, lg, hg, abhns;

public Plugin myinfo = 
{
	name = "Round Chooser", 
	author = "Brum Brum", 
	description = "Player choose round type", 
	version = "1.0", 
	url = "StudioADEPT.net/Forum"
}

public void OnPluginStart()
{
	Freezetime = FindConVar("mp_freezetime");
	LowGravity = CreateConVar("sm_lowgravity", "0.15", "Low gravity");
	HighGravity = CreateConVar("sm_highgravity", "2.5", "High gravity");
	AutoExecConfig(true, "RoundChooser");
	HookEvent("round_start", Event_RoundStart);
	HookEvent("round_end", Event_RoundEnd);
}

public Action Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	if (!IsWarmup())
	{
		Round++;
		GetRound();
		if (Round == 1)
		{
			ChooseRound();
		}
		else if (Round == 3)Round = 0;
	}
}

public Action Event_RoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	for (int i = 1; i < MaxClients; i++)
	{
		if (IsValidClient(i))
		{
			SetEntityGravity(i, 1.0);
		}
	}
}

void ChooseRound()
{
	int freeze = Freezetime.IntValue;
	Menu menu = new Menu(VoteMenu_Handler);
	menu.SetTitle("Choose round gamemode");
	menu.AddItem("", "Only NoScope");
	menu.AddItem("", "Low Gravity");
	menu.AddItem("", "High Gravity");
	menu.AddItem("", "AutoBH + NoScope");
	menu.ExitButton = false;
	menu.DisplayVoteToAll(freeze);
}

public int VoteMenu_Handler(Menu menu, MenuAction action, int client, int item)
{
	if (action == MenuAction_Select)
	{
		switch (item)
		{
			case 0:
			{
				ns = true;
				game = 0;
				GiveAWP();
			}
			case 1:
			{
				lg = true;
				game = 1;
				Gravity();
			}
			case 2:
			{
				hg = true;
				game = 2;
				Gravity();
			}
			case 3:
			{
				abhns = true;
				game = 3;
				GiveAWP();
			}
		}
		PrintToChatAll("%s The current round will be\x07 %s!", MOD_TAG, RoundName[game]);
	}
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon)
{
	if (ns)
	{
		if (buttons & IN_ATTACK2)
		{
			buttons = buttons &= ~IN_ATTACK2;
			return Plugin_Changed;
		}
	}
	else if (lg)
	{
		float lowgravity = LowGravity.FloatValue;
		if (GetEntityGravity(client) != lowgravity)
		{
			SetEntityGravity(client, lowgravity);
		}
	}
	else if (hg)
	{
		float highgravity = HighGravity.FloatValue;
		if (GetEntityGravity(client) != highgravity)
		{
			SetEntityGravity(client, highgravity);
		}
	}
	else if (abhns)
	{
		int index = GetEntProp(client, Prop_Data, "m_nWaterLevel");
		int water = EntIndexToEntRef(index);
		if (water != INVALID_ENT_REFERENCE)
		{
			if (buttons & IN_JUMP)
			{
				if (!(Client_GetWaterLevel(client) > WATER_LEVEL_FEET_IN_WATER))
				{
					if (!(GetEntityMoveType(client) & MOVETYPE_LADDER))
					{
						SetEntPropFloat(client, Prop_Send, "m_flStamina", 0.0);
						if (!(GetEntityFlags(client) & FL_ONGROUND))
						{
							buttons &= ~IN_JUMP;
						}
					}
				}
			}
		}
		if (buttons & IN_ATTACK2)
		{
			buttons = buttons &= ~IN_ATTACK2;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}

void Gravity()
{
	float lowgravity = LowGravity.FloatValue;
	float highgravity = HighGravity.FloatValue;
	for (int i = 1; i < MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i))
		{
			if (lg)SetEntityGravity(i, lowgravity);
			else if (hg)SetEntityGravity(i, highgravity);
		}
	}
}

void GiveAWP()
{
	RemoveWeapons();
	for (int i = 1; i < MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i))
		{
			GivePlayerItem(i, "weapon_knife");
			GivePlayerItem(i, "weapon_awp");
		}
	}
}

void GetRound()
{
	if (Round == 1)
	{
		ns = false;
		lg = false;
		hg = false;
		abhns = false;
	}
	else if (Round > 1 && Round <= 3)
	{
		if (ns || abhns)
		{
			GiveAWP();
		}
		else if (lg || hg)
		{
			Gravity();
		}
		PrintToChatAll("%s The current round will be\x07 %s!", MOD_TAG, RoundName[game]);
	}
}

int Client_GetWaterLevel(int client)
{
	
	return GetEntProp(client, Prop_Send, "m_nWaterLevel");
}

public bool IsValidClient(int client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client) || !IsClientConnected(client) || IsFakeClient(client) || IsClientSourceTV(client))
		return false;
	
	return true;
}

stock void RemoveWeapons()
{
	for (int i = 0; i < sizeof(WeaponList); i++)
	{
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, WeaponList[i])) != -1)
		{
			AcceptEntityInput(ent, "Kill");
		}
	}
}

stock bool IsWarmup()
{
	int warmup = GameRules_GetProp("m_bWarmupPeriod", 4, 0);
	if (warmup == 1)return true;
	else return false;
}