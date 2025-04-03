
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }
using {/UnrealEngine.com/Temporary/SpatialMath}
# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
game_manager := class(creative_device):
    var PlayersMap: [agent]customPlayer = map{}
    var DidVotingWork: logic = false
    @editable
    ConditionalItemVoting : conditional_button_device = conditional_button_device{}
    @editable
    ConditionalItemVoting2 : conditional_button_device = conditional_button_device{}
    @editable
    TimerDeviceLoadout: timer_device = timer_device{}


    @editable
    Chairs :  []chair_device = array{}
    @editable
    Desks :  creative_prop = creative_prop{}
   
 

    @editable
    FailSafeItemGranter : item_granter_device=  item_granter_device{}
    @editable 
    PlayerSpawner1:player_spawner_device = player_spawner_device{}
    @editable 
    PlayerSpawner2:player_spawner_device = player_spawner_device{}
    @editable 
    PlayerSpawner3:player_spawner_device = player_spawner_device{}
    @editable 
    PlayerSpawner4:player_spawner_device = player_spawner_device{}
    @editable 
    PlayerSpawner5:player_spawner_device = player_spawner_device{}
    @editable 
    PlayerSpawner6:player_spawner_device = player_spawner_device{}
    @editable 
    PlayerSpawner7:player_spawner_device = player_spawner_device{}
    @editable 
    PlayerSpawner8:player_spawner_device = player_spawner_device{}
    @editable 
    PlayerSpawner9:player_spawner_device = player_spawner_device{}
    @editable 
    PlayerSpawner10:player_spawner_device = player_spawner_device{}
    @editable 
    PlayerSpawner11:player_spawner_device = player_spawner_device{}
    @editable 
    PlayerSpawner12:player_spawner_device = player_spawner_device{}
    
    @editable
    OnSpawnTimer1 : timer_device = timer_device{}
    @editable
    OnSpawnTimer2 : timer_device = timer_device{}
    @editable
    OnSpawnTimer3 : timer_device = timer_device{}

    @editable
    HUDRanked : hud_message_device = hud_message_device{}

   

    @editable
    AssignRankTrigger : trigger_device = trigger_device{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        PlayerSpawner1.SpawnedEvent.Subscribe(OnPlayerSpawned)
        PlayerSpawner2.SpawnedEvent.Subscribe(OnPlayerSpawned)
        PlayerSpawner3.SpawnedEvent.Subscribe(OnPlayerSpawned)
        PlayerSpawner4.SpawnedEvent.Subscribe(OnPlayerSpawned)
        PlayerSpawner5.SpawnedEvent.Subscribe(OnPlayerSpawned)
        PlayerSpawner6.SpawnedEvent.Subscribe(OnPlayerSpawned)
        PlayerSpawner7.SpawnedEvent.Subscribe(OnPlayerSpawned)
        PlayerSpawner8.SpawnedEvent.Subscribe(OnPlayerSpawned)
        PlayerSpawner9.SpawnedEvent.Subscribe(OnPlayerSpawned)
        PlayerSpawner10.SpawnedEvent.Subscribe(OnPlayerSpawned)
        PlayerSpawner11.SpawnedEvent.Subscribe(OnPlayerSpawned)
        PlayerSpawner12.SpawnedEvent.Subscribe(OnPlayerSpawned)


        OnSpawnTimer1.SuccessEvent.Subscribe(LoadInitialPlayer)
    
        OnSpawnTimer2.SuccessEvent.Subscribe(DisableChairs)

    


        TimerDeviceLoadout.SuccessEvent.Subscribe(CheckForItems)
    OnPlayerSpawned(Agent : agent): void =
        if (PlayerExists := PlayersMap[Agent]):
            #do nothing player already exists
        else:
            if (FortChar : fort_character = Agent.GetFortCharacter[]):
                FortChar.ReleaseFromStasis()
                <# FortChar.Hide() #>
            
            CPlayer : customPlayer = customPlayer{MyAgentObj := Agent}
            if( set PlayersMap[Agent]= CPlayer):

            option:
                set PlayersMap[Agent] = CPlayer
            AssignRankTrigger.Trigger(Agent)
            TimerDeviceLoadout.Start(Agent)   
    LoadInitialPlayer(MaybeAgent:? agent): void = 
        AllPlayers := GetPlayspace().GetPlayers()
            if (FirstPlayer : player = AllPlayers[0]):
    

    CheckForItems(MaybeAgent : ?agent): void = 

        <# Print("check for items") #>

        if (Agent := MaybeAgent?):
            if (ConditionalItemVoting.HasAllItems[Agent]  or ConditionalItemVoting2.HasAllItems[Agent]):
    
                set DidVotingWork = true

                <# Print("voting did work XDDDDDDDDDDDDD") #>

            else:

               <#  Print(" doesn't have items") #>

            if (DidVotingWork = false):
                    FailSafeItemGranter.GrantItem(Agent)

                   <#  Print("granting failsafe items") #>



    DisableChairs(MaybeAgent :? agent): void = 
        for (Chair : Chairs): 
            Chair.Disable() 
        if (Desks.TeleportTo[vector3{X:=8964.0, Y:= -1716.0, Z:= 2000.0},Desks.GetTransform().Rotation]):


                           