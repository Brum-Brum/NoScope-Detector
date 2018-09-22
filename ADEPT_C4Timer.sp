#pragma newdecls required

ConVar Timer;
int C4TimerON, C4Timer;

public Plugin myinfo = 
{
	name = "ADEPT --> C4 Timer", 
	description = "Autorski Plugin StudioADEPT.net", 
	author = "Brum Brum", 
	version = "1.0", 
	url = "http://www.StudioADEPT.net/forum", 
};

public void OnPluginStart()
{
	Timer = FindConVar("mp_c4timer");
	HookEvent("bomb_planted", Event_BombPlanted);
	HookEvent("bomb_defused", Event_BombDefused);
	HookEvent("round_start", Event_RoundStart);
	CreateTimer(1.0, C4, _, TIMER_REPEAT);
}

public Action Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	C4TimerON = 0;
}

public Action Event_BombDefused(Event event, const char[] name, bool dontBroadcast)
{
	C4TimerON = 2;
}

public Action Event_BombPlanted(Event event, const char[] name, bool dontBroadcast)
{
	C4TimerON = 1;
	C4Timer = Timer.IntValue;
	C4Timer--;
}
public Action C4(Handle timer)
{
	if (C4TimerON == 1)
	{
		C4Timer--;
		SetHudTextParams(0.3, 0.9, 0.35, 0, 255, 0, 255, 0, 0.25, 1.5, 0.5);
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{
				if (C4Timer >= 1)
				{
					
					ShowHudText(i, -1, "Czas do wybuchu bomby %i!", C4Timer);
				}
				else if (C4Timer <= 0)
				{
					ShowHudText(i, -1, "Bomba wybuchła!");
				}
			}
		}
	}
	else if (C4TimerON == 2)
	{
		SetHudTextParams(0.3, 0.9, 0.35, 0, 255, 0, 255, 0, 0.25, 1.5, 0.5);
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{
				ShowHudText(i, -1, "Bomba została rozbrojona!");
			}
		}
	}
}

public bool IsValidClient(int client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client))
		return false;
	
	return true;
} 