# CODE BY @GhostUEP ON X AND OTHER PLATFORMS #

# FEEL FREE TO USE THIS CODE AND EXPLORE IT! HIT ME ON X! #

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }

gun_settings_messages:=struct<concrete>:

    TrackerMSG<public><localizes>:message="Show Messages?"
    @editable{ToolTip:=TrackerMSG} ShowMessages<public> : logic = true

    WinMSG<public><localizes>:message="Win Message"
    @editable{ToolTip:=WinMSG} VictoryMessage<public> : hud_message_device=hud_message_device{}

    GunsMSG1<public><localizes>:message="Kill Message"
    @editable{ToolTip:=GunsMSG1} KillMessage<public> : hud_message_device=hud_message_device{}

    GunsMSG2<public><localizes>:message="Death Message"
    @editable{ToolTip:=GunsMSG2} DeathMessage<public> : hud_message_device=hud_message_device{}

    Guns2MSG2<public><localizes>:message="Last Weapon Message"
    @editable{ToolTip:=Guns2MSG2} MessageLastWeapon<public> : hud_message_device=hud_message_device{}

gun_settings:=struct<concrete>:

    GunsMSG<public><localizes>:message="Weapons list."
    @editable{ToolTip:=GunsMSG} GunGameWeapons<public> : []item_granter_device=array{}

gun_settings_devices:=class<concrete>:

    EliminationMSG<public><localizes>:message="Elimination manager device."
    @editable{ToolTip:=EliminationMSG} EliminationManager : elimination_manager_device=elimination_manager_device{}

    Elimination2MSG<public><localizes>:message="Self Elimination manager device.\nFOR SELF KILLS"
    @editable{ToolTip:=Elimination2MSG} EliminationManagerSelf : elimination_manager_device=elimination_manager_device{}

    EndGameMSG<public><localizes>:message="End Game Device."
    @editable{ToolTip:=EndGameMSG} EndGameDevice : end_game_device=end_game_device{}