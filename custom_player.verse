# CODE BY @GhostUEP ON X AND OTHER PLATFORMS #

# FEEL FREE TO USE THIS CODE AND EXPLORE IT! HIT ME ON X! #

using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors/NamedColors }

player_score_canvas:=class:
    var CurrentCanvas : ?canvas = false

killstreak_class:=class:

    var playerKSTime : float = 0.0
    var playerKillStreakCount: int = 0
    var isPlayerInLoop : logic = false

agent_data_class:=class:

    var saveData : logic = false

    var playerKills : int = 0
    var TotalKills : int = 0

    var playerDeaths : int = 0
    var TotalDeaths : int = 0

    var playerWeapon : int = 0

    var playerKDA : float = 0.0

data_class:=class:

    var PlayerData : agent_data_class = agent_data_class{}

    var ScoreCanvas : player_score_canvas = player_score_canvas{}

    var KillStreak : killstreak_class = killstreak_class{}

custom_player:=class<unique>:
    A:agent

    var Data<private> : data_class=data_class{}

    # Sets

    SetIsInLoop<public>(Should:logic):void=
        if (Should?):
            set Data.KillStreak.isPlayerInLoop = true
        else:
            set Data.KillStreak.isPlayerInLoop = false

    SetData<public>(AgentData:agent_data_class):void=
        set Data.PlayerData = AgentData

    SetScoreCanvas<public>(Canvas:player_score_canvas):void=
        set Data.ScoreCanvas = Canvas

    # Adds
    AddKill<public>():void=
        set Data.PlayerData.playerKills += 1
        set Data.PlayerData.TotalKills += 1

    AddKillStreak<public>():void=
        set Data.KillStreak.playerKillStreakCount += 1

    AddDeath<public>():void=
        set Data.PlayerData.playerDeaths += 1

    AddWeapon<public>():void=
        set Data.PlayerData.playerWeapon += 1
        
    # Gets

    GetScoreCanvas<public>()<transacts>:void=
        Data.ScoreCanvas

    GetKills<public>()<transacts>:int=
        Data.PlayerData.playerKills

    GetData<public>()<transacts>:agent_data_class=
        Data.PlayerData

    GetTotalKills<public>()<transacts>:int=
        Data.PlayerData.TotalKills

    GetTotalDeaths<public>()<transacts>:int=
        Data.PlayerData.TotalDeaths

    GetDeaths<public>()<transacts>:int=
        Data.PlayerData.playerDeaths

    GetWeapon<public>()<transacts>:int=
        Data.PlayerData.playerWeapon

    # Conditions

    # Kill Streak Stuff
    SetKSTime<public>():void=
        if (Data.KillStreak.playerKillStreakCount >= 2):
            if (Data.KillStreak.playerKillStreakCount = 2):
                set Data.KillStreak.playerKSTime = 5.0
            else:
                set Data.KillStreak.playerKSTime = 6.0
        else:
            set Data.KillStreak.playerKSTime = 4.0
        Print("Tempo de Kill Streak definido para {Data.KillStreak.playerKSTime} segundos.", ?Duration := 20.0, ?Color := Purple)

    GetKS<public>()<transacts>:int=
        Data.KillStreak.playerKillStreakCount

    ResetKillStreakCount<public>():void=
        set Data.KillStreak.playerKillStreakCount = 0
        Print("Contador de Kill Streak resetado.", ?Duration := 20.0, ?Color := Gray)

    RemoveKSTime<public>(Time:float):void=
        set Data.KillStreak.playerKSTime -= Time
        Print("Tempo de Kill Streak restante: {Data.KillStreak.playerKSTime}", ?Duration := 20.0, ?Color := Purple)

    ResetKSTime<public>():void=
        set Data.KillStreak.playerKSTime = 0.0
        Print("Tempo de Kill Streak resetado.", ?Duration := 20.0, ?Color := Gray)

    AddKSTime<public>(Time:float):void=
        set Data.KillStreak.playerKSTime += Time

    GetKSMessage<public>()<transacts>:string=
        if (Data.KillStreak.playerKillStreakCount = 2):
            return "DOUBLE KILL"
        else if (Data.KillStreak.playerKillStreakCount = 3):
            return "TRIPLE KILL"
        else if (Data.KillStreak.playerKillStreakCount = 4):
            return "QUADRA KILL"
        else if (Data.KillStreak.playerKillStreakCount = 5):
            return "PENTA KILL"
        else if (Data.KillStreak.playerKillStreakCount = 6):
            return "HEXAKILL"
        else if (Data.KillStreak.playerKillStreakCount >= 7):
            return "LEGENDARY KILLSTREAK!\nYou're unstoppable!"
        else:
            return ""

    GetKSTime<public>()<transacts>:float=
        Data.KillStreak.playerKSTime

    IsPlayerInKS<public>()<transacts><decides>:void=
        Data.KillStreak.playerKSTime > 0.0

    IsInLoop<public>()<transacts><decides>:void=
        Data.KillStreak.isPlayerInLoop?