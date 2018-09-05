#include <clientprefs>

#define MOD_TAG "\x01\x0B★ \x07[StudioADEPT]\x04 "
int iloscns[MAXPLAYERS+1];
int iloscnshs[MAXPLAYERS+1];

Handle ns;
Handle nshs;

public Plugin myinfo = 
{
	name = "ADEPT --> NoScope Detector", 
	description = "Autorski Plugin StudioADEPT.net", 
	author = "Brum Brum", 
	version = "0.1", 
	url = "http://www.StudioADEPT.net/forum", 
};

public void OnPluginStart()
{
	HookEvent("player_death", Event_PlayerDeath);
	ns = RegClientCookie("sm_iloscns", "Ilość zabójstw przez noscope", CookieAccess_Protected);
	nshs = RegClientCookie("sm_iloscnshs", "Ilość zabójstw przez noscope + hs", CookieAccess_Protected);
	RegConsoleCmd("sm_ns", CMD_ns, "Pokazuje ilość zrobionych NS oraz NS + HS");
}

public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	char nicki_graczy[32];
	char bronie[32]
	bool hs = GetEventBool(event, "headshot");
	int zabojca = GetClientOfUserId(event.GetInt("attacker"));
	int scope = GetEntProp(zabojca, Prop_Send, "m_bIsScoped");
	GetClientName(zabojca, nicki_graczy, sizeof(nicki_graczy));
	GetEventString(event, "weapon", bronie, sizeof(bronie));
	if(StrEqual(bronie, "awp") || StrEqual(bronie, "ssg08") || StrEqual(bronie, "scar20"))
	{
		if(hs && !scope)
		{
			iloscnshs[zabojca]++
			PrintToChatAll("%s Właśnie \x07%s \x04zrobił \x07Noscope + Heashot\x04 to już jego \x07 %i Noscope + Heashot", MOD_TAG, nicki_graczy, iloscnshs[zabojca]);
			PrintToChat(zabojca, "%s To jest twój \x07 %i \x04 Noscope + Heashot", MOD_TAG, iloscnshs[zabojca]);
		}
		else if(!scope)
		{
			iloscns[zabojca]++
			PrintToChatAll("%s Właśnie \x07%s \x04zrobił \x07Noscope\x04 to już jego \x07 %i Noscope", MOD_TAG, nicki_graczy, iloscns[zabojca]);
			PrintToChat(zabojca, "%s To jest twój \x07 %i \x04 Noscope", MOD_TAG, iloscns[zabojca]);
		}
	}
}

public Action CMD_ns(int client, int args)
{
	PrintToChat(client, "%s Twoja liczba noscope to \x07%i", MOD_TAG, iloscns[client]);
	PrintToChat(client, "%s Twoja liczba noscope + headshot to \x07%i", MOD_TAG, iloscnshs[client]);
}

public void OnClientCookiesCached(int client)
{
	char IloscNs[32];
	char IloscNsHs[32];
	GetClientCookie(client, ns, IloscNs, sizeof(IloscNs));
	iloscns[client] = StringToInt(IloscNs);
	GetClientCookie(client, nshs, IloscNsHs, sizeof(IloscNsHs));
	iloscnshs[client] = StringToInt(IloscNsHs);
}

public void OnClientDisconnect(int client) {
	if(AreClientCookiesCached(client))
	{
		char IloscNs[32];
		char IloscNsHs[32];
		Format(IloscNs, sizeof(IloscNs), "%i", iloscns[client]);
		SetClientCookie(client, ns, IloscNs);
		Format(IloscNsHs, sizeof(IloscNsHs), "%i", iloscnshs[client]);
		SetClientCookie(client, nshs, IloscNsHs);
	}
} 
