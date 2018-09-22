#include <cstrike>
#define MOD_TAG "\x01\x0B★ \x07[StudioADEPT]\x04 "

ConVar b_enable;

public Plugin myinfo = 
{
	name = "ADEPT --> ResetScore", 
	description = "Autorski Plugin StudioADEPT.net", 
	author = "Brum Brum", 
	version = "0.1", 
	url = "http://www.StudioADEPT.net/forum", 
};

public void OnPluginStart()
{
	b_enable = CreateConVar("sm_rsenable", "1", "1-Włącza/wyłącza plugin");
	RegConsoleCmd("sm_rs", CMD_rs);
	OnMapStart();
}

public void OnMapStart()
{
  ServerCommand("mp_backup_round_file \"\"");
  ServerCommand("mp_backup_round_file_last \"\"");
  ServerCommand("mp_backup_round_file_pattern \"\"");
  ServerCommand("mp_backup_round_auto 0");
}

public Action CMD_rs(int client, int args)
{
	if(GetConVarInt(b_enable) == 1)
	{
		if(IsValidClient(client))
		{
			SetEntProp(client, Prop_Data, "m_iFrags", 0);
			SetEntProp(client, Prop_Data, "m_iDeaths", 0);
			CS_SetClientAssists(client, 0);
			CS_SetMVPCount(client, 0);
			CS_SetClientContributionScore(client, 0);
			PrintToChat(client, "%s Właśnie wyzerowałeś swoje statystyki!", MOD_TAG);
		}
	}
}

public bool IsValidClient(int client) 
{
    if(!(1 <= client <= MaxClients) || !IsClientInGame(client)) 
        return false; 
     
    return true; 
}