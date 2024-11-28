# CODE BY @GhostUEP ON X AND OTHER PLATFORMS #

# FEEL FREE TO USE THIS CODE AND EXPLORE IT! HIT ME ON X! #

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors/NamedColors }

xp_devices:=struct<concrete>:
    
    XP1MSG<public><localizes>:message="VictoryXP Device!"
    @editable{ToolTip:=XP1MSG} VictoryXPDevice : accolades_device = accolades_device{}
    
    XP2MSG<public><localizes>:message="KillXP Device!"
    @editable{ToolTip:=XP2MSG} KillXPDevice : accolades_device = accolades_device{}
    
    XP3MSG<public><localizes>:message="LastWeaponXP Device!"
    @editable{ToolTip:=XP3MSG} LastWeaponXPDevice : accolades_device = accolades_device{}

gungame_tutorial_manager := class(creative_device):

    GunMSG<public><localizes>:message="AGuns for the Gun Game!\n*MUST BE AT LEAST ONE!*"
    @editable{ToolTip:=GunMSG} Guns : gun_settings = gun_settings{}

    DevicesMSG<public><localizes>:message="Devices for the Gun Game!"
    @editable{ToolTip:=DevicesMSG} Dispositivos : gun_settings_devices = gun_settings_devices{}

    XPDevicesMSG<public><localizes>:message="XP Devices for the Gun Game!"
    @editable{ToolTip:=XPDevicesMSG} XPDevices : xp_devices = xp_devices{}

    MessagesMSG<public><localizes>:message="Messages for the Gun Game!"
    @editable{ToolTip:=MessagesMSG} Mensagens : gun_settings_messages = gun_settings_messages{}

    GunGameManagerDMSG<localizes><public>:message="KillStreak Manager"
    @editable{ToolTip := GunGameManagerDMSG} KillStreakManager : killstreak_manager = killstreak_manager{}

    AgentToMSG<public><localizes>(A_001:agent):message = "{A_001}"

    var isInGame : logic = true

    var hasWinnner : logic = false
    
    OnBegin<override>()<suspends>:void=
        InitSpawners()
        Dispositivos.EliminationManagerSelf.EliminatedEvent.Subscribe(PlayerDiedEvent)
        Dispositivos.EliminationManager.EliminationEvent.Subscribe(PlayerKillEvent)
        set isInGame = true

    OnEnd<override>():void=
        for (P:GetPlayspace().GetPlayers(), CP:=P.GetCustomAgent[]):
            if (GetPlayerManager().PersistableSettings.UsarPersistencia?):
                SaveData(CP, P)
        
    GiveWeapon(CP:custom_player)<suspends>:void=
        (0.1)
        GiveCurrentGun(CP)
        
    GiveWeapon(A:agent)<suspends>:void=
        (0.1)
        GiveCurrentGun(A)

    GivePlayerWeapon(CP:custom_player):void=
        spawn. GiveWeapon(CP)

    PlayerKillEvent(A:?agent):void=
        if (Player:=player[A?], CP:=Player.GetCustomAgent[]):
            CP.AddKill()
            CP.ManageWeapon()
            KillStreakManager.ManageKillStreak(CP)
            if (Mensagens.ShowMessages?):
                Mensagens.KillMessage.Show(CP.A)
            XPDevices.KillXPDevice.Award(CP.A)
            if (GetPlayerManager().PersistableSettings.UsarPersistencia?):
                SaveData(CP, Player)

    PlayerDiedEvent(A:agent):void=
        if (CP:=A.GetCustomAgent[], P:=player[A]):
            CP.AddDeath()
            Print("Player Deaths: {CP.GetDeaths()}", ?Duration:=10.0, ?Color:=Aqua)
            if (Mensagens.ShowMessages?):
                Mensagens.DeathMessage.Show(CP.A)
            if (GetPlayerManager().PersistableSettings.UsarPersistencia?):
                SaveData(CP, P)

    InitSpawners():void=
        OBJS:=FindCreativeObjectsWithTag(player_spawners_tag{})
        for (OBJ:OBJS, Spawner:=team_settings_and_inventory_device[OBJ]):
            Spawner.TeamMemberSpawnedEvent.Subscribe(PlayerSpawned)

    PlayerSpawned(A:agent):void=
        if (CP:=A.GetCustomAgent[]):
            spawn. GiveWeapon(CP)
        else:
            spawn. GiveWeapon(A)

    (CP:custom_player).ManageWeapon():void=
        CP.AddWeapon()
        if (CP.GetWeapon() > GetMaxWeapons() and not hasWinnner?):
            Print("Player Won", ?Duration := 20.0, ?Color := LimeGreen)
            set hasWinnner = true
            spawn. StartWinner(CP)
            XPDevices.VictoryXPDevice.Award(CP.A)
            Print("Player Kills: {CP.GetKills()}\nCurrent Weapon: {CP.GetWeapon()}!", ?Duration:=10.0, ?Color:=LimeGreen)
        else if (CP.GetWeapon() = GetMaxWeapons()):
            Mensagens.MessageLastWeapon.Show(CP.A)
            spawn. GiveWeapon(CP)
            XPDevices.LastWeaponXPDevice.Award(CP.A)
            Print("Player Kills: {CP.GetKills()}\nCurrent Weapon: {CP.GetWeapon()}!", ?Duration:=10.0, ?Color:=LimeGreen)
            Print("PLAYER IN LAST WEAPON!", ?Duration := 20.0, ?Color := LimeGreen)
        else:
            Print("Player Kills: {CP.GetKills()}\nCurrent Weapon: {CP.GetWeapon()}!", ?Duration:=10.0, ?Color:=LimeGreen)
            spawn. GiveWeapon(CP)

    GetPlayerManager()<transacts>:player_manager_device=
        OBJS:=FindCreativeObjectsWithTag(player_manager_tag{})
        for (OBJ:OBJS, Manager:=player_manager_device[OBJ]):
            return Manager
        Print("ERROR WITH PLAYER MANAGER\nFortgot tag for device!", ?Duration:=20.0, ?Color:=Red)
        player_manager_device{}

    (A:agent).GetCustomAgent()<transacts><decides>:custom_player=
        GetPlayerManager().CustomPlayers[A]

    StartWinner(CP:custom_player)<suspends>:void=
        Mensagens.VictoryMessage.SetText(AgentToMSG(CP.A))
        Mensagens.VictoryMessage.Show()
        Sleep(6.0)
        Dispositivos.EndGameDevice.Activate(CP.A)

    GiveCurrentGun(CP:custom_player):void=
        if (Weapon:=Guns.GunGameWeapons[CP.GetWeapon()]):
            Weapon.GrantItem(CP.A)
            Print("Player got weapon {CP.GetWeapon() + 1}", ?Duration := 20.0, ?Color := LimeGreen)

    GiveCurrentGun(A:agent):void=
        if (CP:=A.GetCustomAgent[], Weapon:=Guns.GunGameWeapons[CP.GetWeapon()]):
            Weapon.GrantItem(CP.A)
            Print("Player got weapon {CP.GetWeapon() + 1}", ?Duration := 20.0, ?Color := LimeGreen)

    GetMaxWeapons()<transacts>:int=
        Guns.GunGameWeapons.Length-1