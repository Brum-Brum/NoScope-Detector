ConVar times[5];
int Time[5];
#define MOD_TAG "\x01\x0B★ \x07[ADEPT-Czas Mapy]\x04 "

public Plugin myinfo = 
{
	name = "ADEPT --> Czas Mapy", 
	description = "Autorski Plugin StudioADEPT.net", 
	author = "Brum Brum", 
	version = "1.0", 
	url = "http://www.StudioADEPT.net/forum", 
};

public void OnPluginStart()
{
	times[0] = CreateConVar("sm_firsttimeoption", "10", "Opcja czasowa z głosowania");
	times[1] = CreateConVar("sm_secondtimeoption", "15", "Opcja czasowa z głosowania");
	times[2] = CreateConVar("sm_thirdtimeoption", "20", "Opcja czasowa z głosowania");
	times[3] = CreateConVar("sm_fourtimeoption", "25", "Opcja czasowa z głosowania");
	times[4] = CreateConVar("sm_fivetimeoption", "30", "Opcja czasowa z głosowania");
	AutoExecConfig(true, "ADEPT_CzasMapy");
}

public void OnConfigsExecuted()
{
	for (int i = 0; i < sizeof(times); i++)
	{
		Time[i] = times[i].IntValue;
	}
}

public void OnMapStart()
{
	CreateTimer(60.0, RetryGlosowanie, _, TIMER_FLAG_NO_MAPCHANGE);
}

public int Handle_VoteMenu(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_End:
		CloseHandle(menu);
		case MenuAction_VoteEnd:
		{
			int value;
			switch (param1)
			{
				case 0:
				value = Time[0];
				case 1:
				value = Time[1];
				case 2:
				value = Time[2];
				case 3:
				value = Time[3];
				case 4:
				value = Time[4];
			}
			ServerCommand("mp_timelimit %d", value);
			PrintToChatAll("%s Ustawiono czas mapy na \x07%d minut!", MOD_TAG, value);
		}
	}
}

public void GlosowanieNaCzasMapy()
{
	if (IsVoteInProgress())
	{
		CreateTimer(5.0, RetryGlosowanie);
	}
	Menu menu = new Menu(Handle_VoteMenu);
	menu.SetTitle("ADEPT -> Czas mapy");
	for (int i = 0; i < sizeof(Time); i++)
	{
		char buffer[64];
		Format(buffer, sizeof(buffer), "%d Minut mapy", Time[i]);
		menu.AddItem("", buffer);
	}
	menu.ExitButton = false;
	menu.DisplayVoteToAll(20);
}

public Action RetryGlosowanie(Handle timer)
{
	GlosowanieNaCzasMapy();
	return Plugin_Continue;
}