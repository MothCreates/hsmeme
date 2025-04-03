
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters}
using { /Fortnite.com/Game}
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }
using {/UnrealEngine.com/Temporary/SpatialMath}
# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
on_elim := class(creative_device):

    @editable
    ElimManager : elimination_manager_device = elimination_manager_device{}

    @editable
    TriggerAddElim : trigger_device = trigger_device{}
    @editable
    TriggerAddWin : trigger_device = trigger_device{}

    @editable
    AudioPlayerNerd : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerSigma : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerChad : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerRizzer : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerRizzerFreeze : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerWolf : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerWolf2 : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerFurry : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerSuper : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerSuper2 : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerPopularLoner : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerPopularLoner2 : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerDiscordMod : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerDiscordMod2 : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerGoth : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerPlug : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerEater : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerEater2 : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerCatgirl : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerBrony : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerBrony2 : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerWeeb : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerWeeb2 : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerQuietKid : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerQuietKid2 : audio_player_device = audio_player_device{}

    @editable
    TimerPostElim : timer_device = timer_device{}
    @editable
    TimerEndRound : timer_device = timer_device{}

    @editable
    EndGameDevice : end_game_device = end_game_device{}
    
    @editable
    PlayerCounter : player_counter_device = player_counter_device{}

    @editable
    AccoladeWin : accolades_device =accolades_device{}
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=

        Players := GetPlayspace().GetPlayers()
        for (Player : Players , FortChar := Player.GetFortCharacter[]):
            FortChar.EliminatedEvent().Subscribe(OnPlayerEliminated)
        # TODO: Replace this with your code
        PlayerCounter.CountSucceedsEvent.Subscribe(EndRoundIfOneAliveTimer) 
        TimerPostElim.SuccessEvent.Subscribe(OnCompletePostElimTimer)
        TimerEndRound.SuccessEvent.Subscribe(EndRoundIfOneAlive)
    OnPlayerEliminated(ElimResult : elimination_result ): void = 
        Eliminated := ElimResult.EliminatedCharacter
        Eliminator := ElimResult.EliminatingCharacter
        
        <# Print("player elminated") #>
        
        if (FortCharEliminator := Eliminator?, AgentEliminator := FortCharEliminator.GetAgent[], AgentEliminated := Eliminated.GetAgent[]):
            if (AgentEliminated = AgentEliminator):
            
            else:
         
                TimerPostElim.Start(AgentEliminator)
                TeamCollection := GetPlayspace().GetTeamCollection()
                if (AgentsTeam:= TeamCollection.GetTeam[AgentEliminator]):
                    TeamsArray := TeamCollection.GetTeams()
                    for (TeamNumber -> Team: TeamsArray):
                        if(AgentsTeam = Team):
                            if (TeamNumber = 0):
                                AudioPlayerNerd.Play(AgentEliminator)
                            if (TeamNumber = 1):
                                AudioPlayerSigma.Play(AgentEliminator)
                            if (TeamNumber = 2):
                                AudioPlayerChad.Play(AgentEliminator)
                            if (TeamNumber = 3):
                                AudioPlayerRizzer.Play(AgentEliminator)
                                AudioPlayerRizzerFreeze.Stop()
                            if (TeamNumber = 4):
                                var RandomInt : int = GetRandomInt(0,1)
                                if (RandomInt = 0):
                                    AudioPlayerWolf.Play(AgentEliminator)
                                if (RandomInt = 1):
                                    AudioPlayerWolf2.Play(AgentEliminator)
                            if (TeamNumber = 5):
                                AudioPlayerFurry.Play(AgentEliminator)
                            if (TeamNumber = 6):
                                var RandomInt : int = GetRandomInt(0,1)

                                if (RandomInt = 0):
                                    AudioPlayerSuper.Play(AgentEliminator)

                                if (RandomInt = 1):
                                    AudioPlayerSuper2.Play(AgentEliminator)
                                AudioPlayerSuper.Play(AgentEliminator)
                            if (TeamNumber = 7):
                                var RandomInt : int = GetRandomInt(0,1)
                                if (RandomInt = 0):
                                    AudioPlayerPopularLoner.Play(AgentEliminator)
                                if (RandomInt = 1):
                                    AudioPlayerPopularLoner2.Play(AgentEliminator)
                                
                            if (TeamNumber = 8):
                                var RandomInt : int = GetRandomInt(0,1)

                                <# Print(" RANDOM INT IS {RandomInt}") #>
                                
                                if (RandomInt = 0):
                                    AudioPlayerDiscordMod.Play(AgentEliminator)

                                    <# Print(" play {RandomInt}") #>

                                if (RandomInt = 1):
                                    AudioPlayerDiscordMod2.Play(AgentEliminator)
                                
                                    <# Print(" play {RandomInt}") #>

                            if (TeamNumber = 9):
                                AudioPlayerGoth.Play(AgentEliminator)
                            if (TeamNumber =10):
                                AudioPlayerPlug.Play(AgentEliminator)
                            if (TeamNumber = 11):
                                MaxHealthEliminated := Eliminated.GetMaxHealth()
                                CurrMaxHealthEliminator := FortCharEliminator.GetMaxHealth()

                                <# Print("{MaxHealthEliminated} MaxHealthEliminated")
                                Print("{CurrMaxHealthEliminator} CurrMaxHealth") #>

                                NewMaxHealth := (MaxHealthEliminated / 2.0 + CurrMaxHealthEliminator)
                                FortCharEliminator.SetMaxHealth(NewMaxHealth)

                                <# Print("{NewMaxHealth} NewMaxHealth") #>
                                
                                var RandomInt : int = GetRandomInt(0,1)
                                if (RandomInt = 0):
                                    AudioPlayerEater.Play(AgentEliminator)
                                if (RandomInt = 1):
                                    AudioPlayerEater2.Play(AgentEliminator)
                            

                            if (TeamNumber = 12):
                                AudioPlayerCatgirl.Play(AgentEliminator)
                            if (TeamNumber = 13):
                                var RandomInt : int = GetRandomInt(0,1)
                                if (RandomInt = 0):
                                    AudioPlayerBrony.Play(AgentEliminator)
                                if (RandomInt = 1):
                                    AudioPlayerBrony2.Play(AgentEliminator)
                                
                            if (TeamNumber = 14):
                                var RandomInt : int = GetRandomInt(0,1)
                                if (RandomInt = 0):
                                    AudioPlayerWeeb.Play(AgentEliminator)
                                if (RandomInt = 1):
                                    AudioPlayerWeeb2.Play(AgentEliminator)
                            if (TeamNumber = 15):
                                var RandomInt : int = GetRandomInt(0,1)
                                if (RandomInt = 0):
                                    AudioPlayerQuietKid.Play(AgentEliminator)
                                if (RandomInt = 1):
                                    AudioPlayerQuietKid2.Play(AgentEliminator)
                            
    OnCompletePostElimTimer(MaybeAgent : ? agent): void = 
        if (Agent := MaybeAgent?):

            TriggerAddElim.Trigger(Agent)

            <# Print("post elim timer") #>
        else:
            <# Print("didn't work") #>


    EndRoundIfOneAliveTimer(): void = 
        TimerEndRound.Start()
    EndRoundIfOneAlive(MaybeAgent :? agent) : void =
        Result := CheckOneAlive()
        IsCountUnderOne := Result(0)
        FoundPlayer := Result(1)
        
        if (IsCountUnderOne?):
            <# Print("count under 1") #>
            if(_FoundPlayer := FoundPlayer?):
                <# Print("one player alive") #>
                #end game
                TriggerAddWin.Trigger(_FoundPlayer)
                AccoladeWin.Award(_FoundPlayer)
                EndGameDevice.Activate(_FoundPlayer)

            else:
                <# Print("not one player alive") #>
                #not one alive
                EndGameDevice.Activate
    CheckOneAlive() : tuple(logic, ?player) =
        <# Print("Checkonealive") #>
        var Count : int = 0
        var LastIteratedPlayer : ?player = false
        AllPlayers := GetPlayspace().GetPlayers()
        for (Agent : AllPlayers, Player := player[Agent], FortCharacter := Player.GetFortCharacter[], FortCharacter.IsActive[]):
            set Count += 1
            <# Print("{Count}") #>
            set LastIteratedPlayer = option{Player}
        return if(Count <= 1) then (true, LastIteratedPlayer) else (false, LastIteratedPlayer)