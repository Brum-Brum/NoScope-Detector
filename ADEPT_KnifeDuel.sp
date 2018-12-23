#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

#define MOD_TAG "\x01\x0B★ \x07[Knife Duel]\x04 " 
#define CS_TEAM_CT 3
#define CS_TEAM_TT 2

int VoteSucces = 0, VoteDecline = 0;

char WeaponList[][] = 
{
	"weapon_glock", "weapon_usp_silencer", "weapon_deagle", "weapon_tec9", "weapon_hkp2000", "weapon_p250", "weapon_fiveseven", "weapon_elite", "weapon_cz75a", "weapon_galilar", "weapon_famas", "weapon_ak47", "weapon_m4a1", "weapon_m4a1_silencer", "weapon_ssg08", "weapon_aug", "weapon_sg556", "weapon_awp", "weapon_scar20", "weapon_g3sg1", "weapon_nova", "weapon_xm1014", "weapon_mag7", "weapon_m249", "weapon_negev", "weapon_mac10", "weapon_mp9", "weapon_mp7", "weapon_ump45", "weapon_p90", "weapon_bizon", "weapon_mp5sd", "weapon_sawedoff", "weapon_knife", "weapon_flashbang", "weapon_hegrenade", "weapon_smokegrenade", "weapon_healthshot", "weapon_decoy", "weapon_molotov", "weapon_incgrenade", "weapon_tagrenade", "weapon_taser", 
};

public Plugin myinfo = 
{
	name = "ADEPT -> Knife Duel", 
	description = "Autorski plugin StudioADEPT.net", 
	author = "Brum Brum", 
	version = "1.0", 
}

public void OnPluginStart()
{
	HookEvent("player_death", Event_PlayerDeath);
}

public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	if (IsWarmup())return Plugin_Continue;
	
	if (CTCount() == 1 && TTCount() == 1)
	{
		ShowVote();
	}
	return Plugin_Continue;
}

void ShowVote()
{
	VoteSucces = 0, VoteDecline = 0;
	Menu menu = new Menu(VoteMenu_Handler);
	menu.SetTitle("Może pojedynek na noże?");
	menu.AddItem("", "Tak");
	menu.AddItem("", "Nie");
	menu.ExitButton = false;
	for (int i = 1; i < MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i))
		{
			menu.Display(i, MENU_TIME_FOREVER);
		}
	}
}

public int VoteMenu_Handler(Menu menu, MenuAction action, int client, int item)
{
	if (action == MenuAction_Select)
	{
		switch (item)
		{
			case 0:Accept(client);
			case 1:
			{
				Decline(client);
				delete menu;
			}
		}
	}
}

public void Accept(int client)
{
	VoteSucces++;
	PrintToChatAll("%s Gracz \x07%N\x04 zgodził się na pojedynek na noże!", MOD_TAG, client);
	checkvotes();
}

public void Decline(int client)
{
	VoteDecline++;
	PrintToChatAll("%s Gracz \x07%N\x04 niezgodził się na pojedynek na noże!", MOD_TAG, client);
	checkvotes();
}

void checkvotes()
{
	if (VoteSucces == 2)Start();
	else if (VoteDecline >= 1)PrintToChatAll("%s Pojedynek na noże został odwołany!", MOD_TAG);
}

void Start()
{
	RemoveWeapons();
	for (int i = 1; i < MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i))GivePlayerItem(i, "weapon_knife");
	}
	ServerCommand("sm_beacon @alive");
	PrintToChatAll("%s Rozpoczął się pojedynek na noże!", MOD_TAG);
}

void RemoveWeapons()
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

public int CTCount()
{
	int CountCT;
	for (int i = 1; i < MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == CS_TEAM_CT)CountCT++;
	}
	return CountCT;
}

public int TTCount()
{
	int CountTT;
	for (int i = 1; i < MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == CS_TEAM_TT)CountTT++;
	}
	return CountTT;
}

public bool IsValidClient(int client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client) || !IsClientConnected(client) || IsFakeClient(client) || IsClientSourceTV(client))
		return false;
	
	return true;
}

bool IsWarmup()
{
	int warmup = GameRules_GetProp("m_bWarmupPeriod", 4, 0);
	if (warmup == 1)return true;
	else return false;
} 