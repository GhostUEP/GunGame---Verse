# CODE BY @GhostUEP ON X AND OTHER PLATFORMS #

# FEEL FREE TO USE THIS CODE AND EXPLORE IT! HIT ME ON X! #

using { /Verse.org/Simulation }

persistable_data:=class<final><persistable>:
    Version:int=1
    TotalKills:int=0
    TotalDeaths:int=0

MakePlayerProfileData<constructor>(Data:persistable_data)<transacts>:=persistable_data:
    Version:=Data.Version
    TotalKills:=Data.TotalKills
    TotalDeaths:=Data.TotalDeaths

var PersistableMap:weak_map(player, persistable_data)=map{}