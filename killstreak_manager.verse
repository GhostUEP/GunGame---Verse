# CODE BY @GhostUEP ON X AND OTHER PLATFORMS #

# FEEL FREE TO USE THIS CODE AND EXPLORE IT! HIT ME ON X! #

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Colors/NamedColors }

ks_xp_devices:=struct<concrete>:

    KSXPMSG<localizes><public>:message="KillStreakXP Device."
    @editable{ToolTip := KSXPMSG} KillStreakXPDevice : accolades_device = accolades_device{}

ks_mesages:=struct<concrete>:

    KSMSG<localizes><public>:message="KillStreak Message Device"
    @editable{ToolTip := KSMSG} KillStreakHUD : hud_message_device = hud_message_device{}

killstreak_manager:=class<concrete>:

    DevicesMSG<localizes><public>:message="Message Devices"
    @editable{ToolTip := DevicesMSG} Devices : ks_mesages = ks_mesages{}

    XPDevicesMSG<localizes><public>:message="XP Devices"
    @editable{ToolTip := XPDevicesMSG} XPDevices : ks_xp_devices = ks_xp_devices{}

    KillStreamMessage<public><localizes>(Text:string):message="{Text}"
    
    ManageKillStreak(CP:custom_player):void=
        CP.AddKillStreak()
        CP.SetKSTime()
        Message := CP.GetKSMessage()
        if (not Message = ""):
            Devices.KillStreakHUD.SetText(KillStreamMessage("{Message}"))
            Devices.KillStreakHUD.Show(CP.A)
            XPDevices.KillStreakXPDevice.Award(CP.A)
            Print("KillStreak Message Showed: {Message}", ?Duration := 20.0, ?Color := Orange)
        if (not CP.IsInLoop[]):
            CP.SetIsInLoop(true)
            spawn. StartKSCD(CP)

    # Função para iniciar a contagem regressiva do kill streak
    StartKSCD(CP:custom_player)<suspends>: void =
        Print("Starting Player Killstreak Loop", ?Duration := 20.0, ?Color := Purple)
        loop:
            if (not CP.IsInLoop[] or not player[CP.A].IsActive[]):
                Print("Player left or killstreak ended.", ?Duration := 20.0, ?Color := DarkRed)
                CP.ResetKSTime()  # Reseta o tempo de kill streak
                CP.ResetKillStreakCount()  # Reseta o contador de kill streak
                CP.SetIsInLoop(false)
                break
            else:
                CP.RemoveKSTime(1.0)  # Remove 1 segundo do tempo de kill streak
                if (CP.GetKSTime() <= 0.0):
                    Print("Time to kill ended for Player.", ?Duration := 20.0, ?Color := DarkRed)
                    CP.ResetKSTime()  # Reseta o tempo de kill streak
                    CP.ResetKillStreakCount()
                    CP.SetIsInLoop(false)  # Reseta o contador de kill streak
                    break
            Sleep(1.0)  # Espera 1 segundo antes de repetir o loop