#include <cstrike>

#define MOD_TAG "\x01\x0B★ \x07[StudioADEPT]\x04 "

ConVar b_enable;

public Plugin myinfo = 
{
	name = "ADEPT --> BlockTeamChange", 
	description = "Autorski Plugin StudioADEPT.net", 
	author = "Brum Brum", 
	version = "0.1", 
	url = "http://www.StudioADEPT.net/forum", 
};

public void OnPluginStart()
{
	b_enable = CreateConVar("sm_btc", "1", "1-Zakazuje zmiany teamu po wybraniu 0-Zezwala na zmianę teamu");
	
	AddCommandListener(JoinTeam, "jointeam");
	AddCommandListener(JoinTeam, "spectate");
}

public Action JoinTeam(int client, const char[] command, int args)
{
	int aktteam = GetClientTeam(client);
	if(GetConVarInt(b_enable) == 1)
	{
		if(GetClientTeam(client) == 1)
		{
			return Plugin_Continue;
		}
		if(aktteam > CS_TEAM_CT)
		{
			if(GetUserFlagBits(client) & ADMFLAG_GENERIC)
			{
				return Plugin_Continue;
			}
			else
			{
				PrintToChat(client, "%s Zmiana teamu została zablokowana", MOD_TAG);
				return Plugin_Handled;
			}
		}
		if(aktteam > CS_TEAM_T)
		{
			if(GetUserFlagBits(client) & ADMFLAG_GENERIC)
			{
				return Plugin_Continue;
			}
			else
			{
				PrintToChat(client, "%s Zmiana teamu została zablokowana", MOD_TAG);
				return Plugin_Handled;
			}
		}
		if(aktteam > CS_TEAM_SPECTATOR)
		{
			if(GetUserFlagBits(client) & ADMFLAG_GENERIC)
			{
				return Plugin_Continue;
			}
			else
			{
				PrintToChat(client, "%s Zmiana teamu została zablokowana", MOD_TAG);
				return Plugin_Handled;
			}
		}
	}
	return Plugin_Continue;
}﻿
