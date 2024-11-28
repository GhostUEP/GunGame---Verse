# CODE BY @GhostUEP ON X AND OTHER PLATFORMS #

# FEEL FREE TO USE THIS CODE AND EXPLORE IT! HIT ME ON X! #

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors/NamedColors }

persistable_data_settings:=struct<concrete>:

    PersistableMSG<public><localizes>:message="Want to use persistense?"
    @editable{ToolTip:=PersistableMSG} UsarPersistencia<public> : logic = false

    Persistable2MSG<public><localizes>:message="Check this to RESET data for everymatch!"
    @editable{ToolTip:=Persistable2MSG} ResetarPersistencia<public> : logic = false

player_manager_device := class(creative_device):

    var CustomPlayers<public> : [agent]custom_player=map{}
    
    PersistableSMSG<public><localizes>:message="Persistable Settings"
    @editable{ToolTip:=PersistableSMSG} PersistableSettings<public> : persistable_data_settings = persistable_data_settings{}
    
    OnBegin<override>()<suspends>:void=
        InitSpawners()
        InitAllPlayers()
        spawn. CheckPlayerLeave()
        if (PersistableSettings.UsarPersistencia?):
            if (PersistableSettings.ResetarPersistencia?):
                ResetPersistence()

    ResetPersistence():void=
        for (P:GetPlayspace().GetPlayers(), Data:=PersistableMap[P]):
            if (set PersistableMap[P] = persistable_data{}):
                Print("Player persistence reseted!", ?Duration:=10.0, ?Color:=Red)

    CheckPlayerLeave()<suspends>:void=
        loop:
            Sleep(0.0)
            P := GetPlayspace().PlayerRemovedEvent().Await()
            PlayerLeft(P)

    InitSpawners():void=
        OBJS:=FindCreativeObjectsWithTag(player_spawners_tag{})
        for (OBJ:OBJS, Spawner:=team_settings_and_inventory_device[OBJ]):
            Spawner.TeamMemberSpawnedEvent.Subscribe(PlayerSpawned)

    InitPlayer(A:agent)<suspends>:void=
        CP := custom_player{A:=A}
        if (set CustomPlayers[A] = CP, P:=player[A]):
            Print("New player registered!", ?Duration:=10.0, ?Color:=LimeGreen)
            if (PersistableSettings.UsarPersistencia?):
                LoadData(CP, P)

    InitAllPlayers():void=
        for (A : GetPlayspace().GetPlayers()):
            spawn. InitPlayer(A)

    PlayerSpawned(A:agent):void=
        if (CP:=CustomPlayers[A]):
        else:
            spawn. InitPlayer(A)

    PlayerLeft(P:player):void=
        if (CP:=CustomPlayers[P]):
            if (PersistableSettings.UsarPersistencia?):
                SaveData(CP, P)
            var NewCPMap : [agent]custom_player=map{}
            for (Key -> Value : CustomPlayers, Key <> P):
                set NewCPMap = ConcatenateMaps(NewCPMap, map{Key=>Value})
            set CustomPlayers = NewCPMap
            Print("Player Removido!", ?Duration:=10.0, ?Color:=Red)