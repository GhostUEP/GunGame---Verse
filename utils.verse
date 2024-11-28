# CODE BY @GhostUEP ON X AND OTHER PLATFORMS #

# FEEL FREE TO USE THIS CODE AND EXPLORE IT! HIT ME ON X! #

using { /Verse.org/Simulation/Tags }
using { /Verse.org/Colors/NamedColors }
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using {/Verse.org/Native}

player_manager_tag:=class(tag){}

player_spawners_tag:=class(tag){}

LoadData(CP:custom_player, P:player):void=
    if (Data:=PersistableMap[player[CP.A]]):
        CP.SetData(ConvertPersistence(Data))
    else:
        if (set PersistableMap[P] = persistable_data{}) {}
        
SaveData(CP:custom_player, P:player):void=
    if (set PersistableMap[P] = ConvertData(CP.GetData())) {}

ConvertPersistence(PersistableData:persistable_data)<transacts>:agent_data_class=
    agent_data_class:
        TotalKills:=PersistableData.TotalKills
        TotalDeaths:=PersistableData.TotalDeaths
        playerKDA:=((PersistableData.TotalKills * 1.0) / (PersistableData.TotalDeaths * 1.0))

ConvertData(Data:agent_data_class)<transacts>:persistable_data=
    persistable_data:
        TotalKills:=Data.TotalKills
        TotalDeaths:=Data.TotalDeaths