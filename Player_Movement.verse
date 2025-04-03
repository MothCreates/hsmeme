using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters}
using { /Fortnite.com/Game}
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using {/UnrealEngine.com/Temporary/SpatialMath}
# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
Player_Movement := class(creative_device):
    @editable
    FowardsMM : movement_modulator_device = movement_modulator_device{}

    @editable
    WolfTrigger : trigger_device = trigger_device{}

    @editable
    WaitForPounceTimer : timer_device = timer_device{}

    @editable
    FowardsMoverSphere : creative_prop = creative_prop{}
    
    var IsWolfCrouching : logic = false
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        WolfTrigger.TriggeredEvent.Subscribe(CheckForJump)
       
        WaitForPounceTimer.SuccessEvent.Subscribe(StartPounce)
     
    CheckForJump(MaybeAgent : ? agent): void =
        if (Agent := MaybeAgent?, FortChar := Agent.GetFortCharacter[]):
            FortChar.CrouchedEvent().Subscribe(WaitForPounce)


    WaitForPounce(FortChar : fort_character, StartedCrouching : logic): void =
        if (Agent := FortChar.GetAgent[]):
            TeamCollection := GetPlayspace().GetTeamCollection()
            if (AgentsTeam := TeamCollection.GetTeam[Agent]):
                TeamsArray := TeamCollection.GetTeams()
                for (TeamNumber -> Team: TeamsArray):
                    if(AgentsTeam = Team):
                        if (TeamNumber = 4):
                            if (StartedCrouching = true): 
                                
                                <# Print("wait for pounce") #>

                                set IsWolfCrouching = true
                                WaitForPounceTimer.Start(Agent)
                            if (StartedCrouching = false): 
                                
                                set IsWolfCrouching = false
                                WaitForPounceTimer.Reset(Agent)
    StartPounce (MaybeAgent :? agent): void =
        if (Agent := MaybeAgent ?):
            if (FortChar := Agent.GetFortCharacter[]):

                <# Print("start pounce") #>
     
                option: 
                    FowardsMoverSphere.TeleportTo[FortChar.GetTransform().Translation, FortChar.GetTransform().Rotation]
                spawn:
                    FowardsMoverSphere.ActivatePounceEffect(Agent)

    (Prop : creative_prop).ActivatePounceEffect(Agent : agent)<suspends> : void = 
        if (FortChar := Agent.GetFortCharacter[]):

            <# Print("Activate Pounce Effect") #>

            if (Yaw := FortChar.GetViewRotation().GetYawPitchRollDegrees()[0] ):
                <# Print("{Yaw}") #>
            option:
                Yaw := FortChar.GetViewRotation().GetYawPitchRollDegrees()[0]
                Pitch:=  0.0
                Roll := 0.0
                NewRotation := MakeRotationFromYawPitchRollDegrees(Yaw, Pitch,Roll)
                if (Prop.TeleportTo[FortChar.GetTransform().Translation - vector3{Z := 120.0}, NewRotation]):
            
            Sleep (0.1)
            <#  BackwardsMM.Activate(AgentTargeted) #>
            Sleep(0.1)

            option:
                Prop.TeleportTo[Prop.GetTransform().Translation - vector3{Z := 1000.0}, Prop.GetTransform().Rotation]