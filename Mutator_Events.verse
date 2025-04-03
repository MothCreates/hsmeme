
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters}
using {/UnrealEngine.com/Temporary/SpatialMath}
# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
Mutator_Events := class(creative_device):
    @editable
    MutatorZone : mutator_zone_device = mutator_zone_device{}

    @editable
    UndergroundMutatoroZone : mutator_zone_device = mutator_zone_device{}
    @editable
    WeebTimer : timer_device = timer_device{}

    @editable
    EmoteTriggerStart : trigger_device = trigger_device{}
    @editable
    EmoteTriggerStop : trigger_device = trigger_device{}

    @editable
    WeebHealthPowerup : health_powerup_device = health_powerup_device{}

    @editable
    WeebPowerTimer :timer_device = timer_device{}

    @editable
    AudioPlayerWeebScream : audio_player_device = audio_player_device{}
    var TimesEmoted :int = 1
    var IsWeebOnCD : logic = true
    var IsWeebEmoting: logic  = false
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
       MutatorZone.AgentBeginsEmotingEvent.Subscribe(TestFunctionName)
       MutatorZone.AgentEndsEmotingEvent.Subscribe(CheckEmoteCompletion)

       UndergroundMutatoroZone.AgentEntersEvent.Subscribe(TPOut)
       WeebTimer.SuccessEvent.Subscribe(CheckTimerComplete)
        WeebPowerTimer.SuccessEvent.Subscribe(ChangeWeebCD)
    TestFunctionName(Agent: agent): void =
        TeamCollection := GetPlayspace().GetTeamCollection()
        if (AgentsTeam:= TeamCollection.GetTeam[Agent]):
            TeamsArray := TeamCollection.GetTeams()
            for (TeamNumber -> Team: TeamsArray):
                if(AgentsTeam = Team):
                    if (TeamNumber = 14, IsWeebOnCD= true):
                        set IsWeebEmoting = true
                        AudioPlayerWeebScream.Play(Agent)
                        EmoteTriggerStart.Trigger(Agent)
                        WeebTimer.Start(Agent)

    CheckEmoteCompletion(Agent: agent): void =
        TeamCollection := GetPlayspace().GetTeamCollection()
        if (AgentsTeam:= TeamCollection.GetTeam[Agent]):
            TeamsArray := TeamCollection.GetTeams()
            for (TeamNumber -> Team: TeamsArray):
                if(AgentsTeam = Team):
                    if (TeamNumber = 14, IsWeebOnCD = true):
                        set IsWeebEmoting = false
                        EmoteTriggerStop.Trigger(Agent)
                        WeebTimer.Reset(Agent)
                        AudioPlayerWeebScream.Stop()
    

    CheckTimerComplete(MaybeAgent: ? agent): void = 
        if(Agent:= MaybeAgent?, FortCharacter := Agent.GetFortCharacter[]):
            TeamCollection := GetPlayspace().GetTeamCollection()
            if (AgentsTeam := TeamCollection.GetTeam[Agent]):
                TeamsArray := TeamCollection.GetTeams()
                for (TeamNumber -> Team: TeamsArray):
                    if(AgentsTeam = Team):
                        if (TeamNumber = 14, IsWeebOnCD= true):
                            if(IsWeebEmoting= true):
                               FortCharacter.SetMaxHealth(100.0+ (25.0 * TimesEmoted))
                               FortCharacter.SetMaxShield(80.0+ (25.0 * TimesEmoted))
                               WeebHealthPowerup.Pickup(Agent)
                               set TimesEmoted += 1
                               set IsWeebOnCD= false
                               WeebPowerTimer.Start(Agent)
                
    ChangeWeebCD(MaybeAgent : ? agent): void = 
        set IsWeebOnCD= true


    TPOut (Agent : agent): void =
        
        <# Print("tp out") #>

        if( FortChar := Agent.GetFortCharacter[]):
            TeamCollection := GetPlayspace().GetTeamCollection()
            if (AgentsTeam := TeamCollection.GetTeam[Agent]):
                TeamsArray := TeamCollection.GetTeams()
                for (TeamNumber -> Team: TeamsArray):
                    if(AgentsTeam = Team):
                        if (TeamNumber = 5):
                        else:
                            Pos : vector3 = FortChar.GetTransform().Translation
                            AboveGroundPos :vector3 = vector3{X := Pos.X, Y := Pos.Y, Z:= 420.0}
                           <#  if (FortChar.TeleportTo[AboveGroundPos, FortChar.GetTransform().Rotation]): #>
                    
