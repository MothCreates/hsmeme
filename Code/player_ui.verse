
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
player_ui := class(creative_device):

    @editable
    OnSpawnTimer2 : timer_device = timer_device{}

    @editable
    HUDBarrierDevice : hud_message_device = hud_message_device{}
    @editable
    HUDGoDevice : hud_message_device = hud_message_device{}
    @editable
    HUDDeviceEmoteChannel : hud_message_device = hud_message_device{}
    @editable
    HUDDeviceRemote: hud_message_device = hud_message_device{}
    @editable
    HUDDeviceFurry: hud_message_device = hud_message_device{}

    @editable
    EmoteTriggerStart : trigger_device = trigger_device{}
    @editable
    EmoteTriggerStop : trigger_device = trigger_device{}
    @editable
    TriggerPopularLoner : trigger_device = trigger_device{}
    @editable
    TriggerFurry : trigger_device = trigger_device{}
    @editable
    TriggerWeirdKid : trigger_device = trigger_device{}
    @editable
    TriggerPlug : trigger_device = trigger_device{}
    @editable
    TriggerQuietKid : trigger_device = trigger_device{}
    @editable
    TriggerWeeb : trigger_device = trigger_device{}
    @editable
    TriggerSuper : trigger_device = trigger_device{}


    @editable
    PowerTriggerPopularLoner : trigger_device = trigger_device{}
    @editable
    PowerTriggerFurry : trigger_device = trigger_device{}
    @editable
    PowerTriggerWeirdKid : trigger_device = trigger_device{}
    @editable
    PowerTriggerPlug : trigger_device = trigger_device{}
    @editable
    PowerTriggerQuietKid : trigger_device = trigger_device{}
    @editable
    PowerTriggerWeeb : trigger_device = trigger_device{}
    @editable
    PowerTriggerSuper : trigger_device = trigger_device{}


    var FurryUndergroundRemainingTime : float = 7.0
    var BarrierRemainingTime : float = 6.0
    var IsCancelledWeeb : logic = false
    var EmoteRemainingTimeWeeb : float = 4.0
    var RemainingTimeFurry : float = 30.0
    var RemainingTimePopularLoner : float = 30.0
    var RemainingTimeWeirdKid : float = 30.0
    var RemainingTimePlug : float = 30.0
    var RemainingTimeQuietKid : float = 30.0
    var RemainingTimeWeeb : float = 15.0
    var RemainingTimeSuper : float = 30.0


    RemainingTimeText<localizes> (CurrentRemainingTime: float) : message = "CoolDown: {CurrentRemainingTime}"
    BarrierRemainingTimeText<localizes> (BarrierCurrentRemainingTime: float) : message = "{BarrierCurrentRemainingTime}"
    AbilityReadText<localizes> (String: string) : message = "{String}"
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        
       OnSpawnTimer2.SuccessEvent.Subscribe(StartBarrierCountdown)

        TriggerPopularLoner.TriggeredEvent.Subscribe(ShowPowerHUD)
        TriggerFurry.TriggeredEvent.Subscribe(ShowPowerHUD)
        TriggerWeirdKid.TriggeredEvent.Subscribe(ShowPowerHUD)
        TriggerPlug.TriggeredEvent.Subscribe(ShowPowerHUD)
        TriggerQuietKid.TriggeredEvent.Subscribe(ShowPowerHUD)
        TriggerWeeb.TriggeredEvent.Subscribe(ShowPowerHUD)
        TriggerSuper.TriggeredEvent.Subscribe(ShowPowerHUD)

       EmoteTriggerStart.TriggeredEvent.Subscribe(ShowEmoteHUD)
       EmoteTriggerStop.TriggeredEvent.Subscribe(HideEmoteHUD)
    StartBarrierCountdown(MaybeAgent: ?agent) : void = 
        spawn:
            RunBarrierCountdown()


    RunBarrierCountdown()<suspends> : void = 
        loop:
            Sleep(1.0)

            set BarrierRemainingTime = BarrierRemainingTime - 1.0
            UpdateBarrierUI()

            if (BarrierRemainingTime <= 0.0):
                HUDBarrierDevice.Hide()
                HUDGoDevice.Show()
                Sleep(1.0)
                HUDGoDevice.Hide()
                break




    UpdateBarrierUI(): void =

        if (FloatTime := float[BarrierRemainingTime]):
            AllPlayers := GetPlayspace().GetPlayers()
            for (Player : AllPlayers, Agent := agent[Player]):
                HUDBarrierDevice.SetText(BarrierRemainingTimeText(FloatTime))
                HUDBarrierDevice.Show(Agent)



    UpdateEmotingUI(Agent: agent, TeamNumber : int ): void = 
        if (TeamNumber = 14):
            if (FloatTime := float[EmoteRemainingTimeWeeb]):
                HUDDeviceEmoteChannel.SetText(BarrierRemainingTimeText(FloatTime))
                HUDDeviceEmoteChannel.Show(Agent)

    ShowEmoteHUD(MaybeAgent : ? agent ): void = 
        if (Agent := MaybeAgent?):
            TeamCollection := GetPlayspace().GetTeamCollection()
            if (AgentsTeam := TeamCollection.GetTeam[Agent]):
                TeamsArray := TeamCollection.GetTeams()
                for (TeamNumber -> Team: TeamsArray):
                    if(AgentsTeam = Team):
                        if (TeamNumber = 14):
                            set IsCancelledWeeb = false
                            spawn: 
                                StartEmoteCountdown(Agent, TeamNumber)
                
                
            
                        
    StartEmoteCountdown(Agent : agent, TeamNumber : int)<suspends>: void = 
        loop:
            if (TeamNumber = 14):
                if (IsCancelledWeeb = true):
                    set EmoteRemainingTimeWeeb = 4.0
                    HUDDeviceEmoteChannel.Hide()

                    # change if multiple emoters / will cancels rons
                    break
            Sleep(0.1)
            if (TeamNumber = 14):
                set EmoteRemainingTimeWeeb = EmoteRemainingTimeWeeb - 0.1
                UpdateEmotingUI(Agent, TeamNumber)
                if  (EmoteRemainingTimeWeeb <= 0.0):
                    HUDDeviceEmoteChannel.Hide()
                    # change if multiple emoters / will cancels rons
                    set EmoteRemainingTimeWeeb = 4.0
                    PowerTriggerWeeb.Trigger(Agent)
                    break


    ### POWERUPS
    ShowPowerHUD(MaybeAgent : ? agent): void = 
        if (Agent := MaybeAgent?):

            <# Print("Show HUD") #>

            HUDDeviceRemote.SetText(AbilityReadText("POWER READY"))
            HUDDeviceRemote.Show(Agent)
            PowerTriggerFurry.TriggeredEvent.Subscribe(StartPowerCountdown)
            PowerTriggerPlug.TriggeredEvent.Subscribe(StartPowerCountdown)
            PowerTriggerPopularLoner.TriggeredEvent.Subscribe(StartPowerCountdown)
            PowerTriggerQuietKid.TriggeredEvent.Subscribe(StartPowerCountdown)
            PowerTriggerWeirdKid.TriggeredEvent.Subscribe(StartPowerCountdown)
            PowerTriggerWeeb.TriggeredEvent.Subscribe(StartPowerCountdown)
            PowerTriggerSuper.TriggeredEvent.Subscribe(StartPowerCountdown)

    StartPowerCountdown(MaybeAgent :? agent): void =
        if (Agent := MaybeAgent?):
            spawn:
                RunPowerCountdown(Agent)


    RunPowerCountdown(Agent : agent)<suspends> : void = 
        TeamCollection := GetPlayspace().GetTeamCollection()
            if (AgentsTeam := TeamCollection.GetTeam[Agent]):
                TeamsArray := TeamCollection.GetTeams()
                for (TeamNumber -> Team: TeamsArray):
                    if(AgentsTeam = Team):
                        if (TeamNumber = 5):
                            loop:
                                Sleep(1.0)
                                set RemainingTimeFurry = RemainingTimeFurry - 1.0
                                UpdateUIPower(Agent)
                                
                                if (RemainingTimeFurry <= 0.0):
                                    set RemainingTimeFurry = 30.0 
                                    HUDDeviceRemote.SetText(AbilityReadText("POWER READY"))
                                    HUDDeviceRemote.Show(Agent)
                                    break
                        if (TeamNumber = 6):
                            loop:
                                Sleep(1.0)
                                set RemainingTimeSuper = RemainingTimeSuper - 1.0
                                UpdateUIPower(Agent)
                                
                                if (RemainingTimeSuper <= 0.0):
                                    set RemainingTimeSuper= 30.0 
                                    HUDDeviceRemote.SetText(AbilityReadText("POWER READY"))
                                    HUDDeviceRemote.Show(Agent)
                                    break
                        if (TeamNumber = 7):
                            loop:
                                Sleep(1.0)
                                set RemainingTimePopularLoner = RemainingTimePopularLoner - 1.0
                                UpdateUIPower(Agent)
                                
                                if (RemainingTimePopularLoner <= 0.0):
                                    set RemainingTimePopularLoner = 30.0 
                                    HUDDeviceRemote.SetText(AbilityReadText("POWER READY"))
                                    HUDDeviceRemote.Show(Agent)
                                    break
                        if (TeamNumber = 8):
                            loop:
                                Sleep(1.0)
                                set RemainingTimeWeirdKid = RemainingTimeWeirdKid - 1.0
                                UpdateUIPower(Agent)
                                
                                if (RemainingTimeWeirdKid <= 0.0):
                                    set RemainingTimeWeirdKid = 30.0 
                                    HUDDeviceRemote.SetText(AbilityReadText("POWER READY"))
                                    HUDDeviceRemote.Show(Agent)
                                    break

                        if (TeamNumber = 10):
                            loop:
                                Sleep(1.0)
                                set RemainingTimePlug = RemainingTimePlug - 1.0
                                UpdateUIPower(Agent)
                                
                                if (RemainingTimePlug <= 0.0):
                                    set RemainingTimePlug = 30.0 
                                    HUDDeviceRemote.SetText(AbilityReadText("POWER READY"))
                                    HUDDeviceRemote.Show(Agent)
                                    break
                        if (TeamNumber = 14):
                            loop:
                                Sleep(1.0)
                                set RemainingTimeWeeb = RemainingTimeWeeb - 1.0
                                UpdateUIPower(Agent)


                                <# Print("weeb loop") #>
                                
                                if (RemainingTimeWeeb <= 0.0):
                                    set RemainingTimeWeeb= 15.0
                                    HUDDeviceRemote.SetText(AbilityReadText("POWER READY"))
                                    HUDDeviceRemote.Show(Agent)
                                    break            
                        if (TeamNumber = 15):
                            loop:
                                Sleep(1.0)
                                set RemainingTimeQuietKid = RemainingTimeQuietKid - 1.0
                                UpdateUIPower(Agent)
                                
                                if (RemainingTimeQuietKid <= 0.0):
                                    set RemainingTimeQuietKid = 30.0
                                    HUDDeviceRemote.SetText(AbilityReadText("POWER READY"))
                                    HUDDeviceRemote.Show(Agent)
                                    break

    UpdateUIPower(Agent: agent): void =
        TeamCollection := GetPlayspace().GetTeamCollection()
            if (AgentsTeam := TeamCollection.GetTeam[Agent]):
                TeamsArray := TeamCollection.GetTeams()
                for (TeamNumber -> Team: TeamsArray):
                    if(AgentsTeam = Team):
                        if (TeamNumber = 5):
                            if (FloatTime := float[RemainingTimeFurry]):
                                HUDDeviceRemote.SetText(RemainingTimeText(FloatTime))
                                HUDDeviceRemote.Show(Agent)
                        if (TeamNumber = 6):
                            if (FloatTime := float[RemainingTimeSuper]):
                                HUDDeviceRemote.SetText(RemainingTimeText(FloatTime))
                                HUDDeviceRemote.Show(Agent)

                        if (TeamNumber = 7):
                            if (FloatTime := float[RemainingTimePopularLoner]):
                                HUDDeviceRemote.SetText(RemainingTimeText(FloatTime))
                                HUDDeviceRemote.Show(Agent)

                        if (TeamNumber = 8):
                            if (FloatTime := float[RemainingTimeWeirdKid]):
                                HUDDeviceRemote.SetText(RemainingTimeText(FloatTime))
                                HUDDeviceRemote.Show(Agent)

                        if (TeamNumber = 10):
                            if (FloatTime := float[RemainingTimePlug]):
                                HUDDeviceRemote.SetText(RemainingTimeText(FloatTime))
                                HUDDeviceRemote.Show(Agent)
                        if (TeamNumber = 14):
                            if (FloatTime := float[RemainingTimeWeeb]):
                                HUDDeviceRemote.SetText(RemainingTimeText(FloatTime))
                                HUDDeviceRemote.Show(Agent)
                        if (TeamNumber = 15):
                            if (FloatTime := float[RemainingTimeQuietKid]):
                                HUDDeviceRemote.SetText(RemainingTimeText(FloatTime))
                                HUDDeviceRemote.Show(Agent)


    HideEmoteHUD(MaybeAgent : ? agent ): void = 
        set IsCancelledWeeb = true
        HUDDeviceEmoteChannel.Hide()

    RunFurryCountdown(MaybeAgent :? agent)<suspends> : void = 
        if (Agent:= MaybeAgent ?):
            loop:
                Sleep(1.0)

                set FurryUndergroundRemainingTime = FurryUndergroundRemainingTime - 1.0
                UpdateFurryUI(Agent)

                if (FurryUndergroundRemainingTime <= 0.0):
                    HUDDeviceFurry.Hide()
                    set FurryUndergroundRemainingTime = 7.0
                    break
    UpdateFurryUI(Agent :  agent): void =

        if (FloatTime := float[FurryUndergroundRemainingTime]):
            HUDDeviceFurry.SetText(BarrierRemainingTimeText(FloatTime))
            HUDDeviceFurry.Show(Agent)