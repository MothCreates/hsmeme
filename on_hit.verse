
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters}
using { /Fortnite.com/Game}
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using {/UnrealEngine.com/Temporary/SpatialMath}
# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
on_hit := class(creative_device):

    @editable
    RizzConditionalButton : conditional_button_device = conditional_button_device{}
    @editable
    CatConditionalButton : conditional_button_device = conditional_button_device{}
    @editable
    CatConditional2Button : conditional_button_device = conditional_button_device{}
    @editable
    CatConditional3Button : conditional_button_device = conditional_button_device{}

    @editable
    OnSpawnTimer2 : timer_device = timer_device{}
    @editable
    ChadDeathTimer : timer_device = timer_device{}

    @editable
    RizzAudioPlayer : audio_player_device = audio_player_device{}
    @editable
    ChadAudioPlayer : audio_player_device = audio_player_device{}

    @editable
    BackwardsMM : movement_modulator_device = movement_modulator_device{}

    @editable
    BackwardsMoverSphere : creative_prop = creative_prop{}

    @editable
    GuardSpawner1 : npc_spawner_device = npc_spawner_device{}
    @editable
    GuardSpawner2 : npc_spawner_device = npc_spawner_device{}

    @editable
    GuardHealBuffsDevice : health_powerup_device = health_powerup_device{}
    @editable
    DamageBuffsDevice : damage_amplifier_powerup_device= damage_amplifier_powerup_device{}

  
    @editable
    Lock : lock_device = lock_device{}
  
    @editable
    Light : customizable_light_device = customizable_light_device{}
    var IsGuard1Dead : logic = false
    var IsGuard2Dead : logic = false
    var IsChadResUsed : logic = false

    var NewRotationAngle : float = 0.0
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        OnSpawnTimer2.SuccessEvent.Subscribe(CheckForDamage)
        ChadDeathTimer.SuccessEvent.Subscribe(ChangeVulnerability)

        GuardSpawner1.SpawnedEvent.Subscribe(GiveGuardBuffs1)
        GuardSpawner2.SpawnedEvent.Subscribe(GiveGuardBuffs2)

        GuardSpawner1.SpawnedEvent.Subscribe(GiveGuardBuffs1)
        GuardSpawner2.SpawnedEvent.Subscribe(GiveGuardBuffs2)

        GuardSpawner1.EliminatedEvent.Subscribe(RemoveGuardBuffs1)
        GuardSpawner2.EliminatedEvent.Subscribe(RemoveGuardBuffs2)

        Players:= GetPlayspace().GetPlayers()
        for (Player : Players , FortChar := Player.GetFortCharacter[]):
            FortChar.JumpedEvent().Subscribe(GetRotationAngle)
        


    CheckForDamage(MaybeAgent : ? agent ): void =
        Players:= GetPlayspace().GetPlayers()
        for (Player : Players , FortChar := Player.GetFortCharacter[]):
            FortChar.DamagedEvent().Subscribe(OnPlayerHit)
            FortChar.DamagedShieldEvent().Subscribe(OnPlayerHit)


    OnPlayerHit(DamageResult : damage_result): void = 

        <# Print("OnPlayerHit") #>
        

        Target := DamageResult.Target
        Amount := DamageResult.Amount
        TeamCollection := GetPlayspace().GetTeamCollection()
        if (Instigator := DamageResult.Instigator?, Agent := Instigator.GetInstigatorAgent[], FortCharInstigator := Agent.GetFortCharacter[]):
            if (FortCharTargeted := fort_character[Target], AgentTargeted := FortCharTargeted.GetAgent[]):
                FortCharTargeted.ReleaseFromStasis()
                if (Agent = AgentTargeted):
                else:

                    if(AgentsTeam := TeamCollection.GetTeam[Agent], TeamTarget := TeamCollection.GetTeam[AgentTargeted]):
                        TeamsArray := TeamCollection.GetTeams()
                        for (TeamNumber -> Team : TeamsArray):
                            if (AgentsTeam = Team):
                                
                                <# Print("instigator is on team") #>
                                <# Print("{TeamNumber}") #>

                                if (TeamNumber = 3):
                                    if( RizzConditionalButton.IsHoldingItem[Agent]):
                                        spawn:
                                            FreezePlayer(FortCharTargeted, FortCharInstigator, Amount)
                                if (TeamNumber = 1):
                                    BackwardsImpulseSetup(AgentTargeted, Agent)
                                if (TeamNumber = 12):
                                    if(CatConditionalButton.IsHoldingItem[Agent] or CatConditional2Button.IsHoldingItem[Agent] or CatConditional3Button.IsHoldingItem[Agent]):

                                        <# Print(" is holding an item") #>

                                    else:
                                        FortCharTargeted.Damage(Amount * 5)

                                        <# Print("Damage Targeted 5 times") #>
                            
                                
                            if (TeamTarget = Team):
                                if (TeamNumber = 2):
                                    spawn:
                                        CheckForLethalDamage(AgentTargeted)


    FreezePlayer(FortCharTargeted : fort_character,FortCharInstigator:  fort_character,  Amount : float)<suspends> : void = 
        FortCharInstigator.ReleaseFromStasis()
        FortCharTargeted.ReleaseFromStasis()
        Sleep(0.0)
        FortCharTargeted.PutInStasis(stasis_args{AllowTurning := false, AllowEmotes := false, AllowFalling := false})
       
    
        if (Amount > 90.0 , FortCharTargeted.IsActive[] ):

            EnemyLoc := FortCharTargeted.GetTransform().Translation
            PlayerLoc := FortCharInstigator.GetTransform().Translation
            Rotation := FortCharTargeted.GetViewRotation()
            RotationAngle := Rotation.GetAngle()

   
            RotationAxis := Rotation.GetAxis()
            if (RotationAngle <=3.14):
                set NewRotationAngle = RotationAngle+3.14
            else if(3.14 < RotationAngle <= 6.28) :
                set NewRotationAngle = RotationAngle -3.14
            <# Print("{RotationAngle} Rotation Angle , {NewRotationAngle} opposite angle") #>
            CompleteRotation := MakeRotation(RotationAxis, NewRotationAngle)
            if (Yaw := FortCharTargeted.GetViewRotation().GetYawPitchRollDegrees()[0]):
                if (-46.0 <= Yaw < 0.0 or 0.0 <= Yaw < 46.0):
                    if ( EnemyLoc.X <  106.0):
                        if (FortCharInstigator.TeleportTo[FortCharTargeted.GetTransform().Translation + vector3{X:=+100.0, Z:= 50.0}, CompleteRotation]):
                            Sleep(0.0)
                            FortCharInstigator.PutInStasis(stasis_args{AllowTurning := false, AllowEmotes := true, AllowFalling := true})
                   <#  else:
                        <Print("too close to wall") #>
 
                else if  (-135.0 <= Yaw < -0.46 ):
                    if (EnemyLoc.Y >  -706.0):
                        if (FortCharInstigator.TeleportTo[FortCharTargeted.GetTransform().Translation + vector3{Y:=-100.0, Z:= 50.0}, CompleteRotation]):
                            Sleep(0.0)
                            FortCharInstigator.PutInStasis(stasis_args{AllowTurning := false, AllowEmotes := true, AllowFalling := true})
                    <# else:
                        Print("too close to wall")  #>
                                
                else if (-180.0 <= Yaw < -135.0  or  180.0 >= Yaw > 135.0 ):
                    if (EnemyLoc.X >  -3281.683257 +150.0):
                        if (FortCharInstigator.TeleportTo[FortCharTargeted.GetTransform().Translation + vector3{X:=-100.0, Z:= 50.0}, CompleteRotation]):
                            Sleep(0.0)
                            FortCharInstigator.PutInStasis(stasis_args{AllowTurning := false, AllowEmotes := true, AllowFalling := true})
                   <#  else:
                        Print("too close to wall")  #>
                              
                else if (0.46 <= Yaw < 135.0 ):
                    if (EnemyLoc.Y <  2816.0 - 150.0):
                        if (FortCharInstigator.TeleportTo[FortCharTargeted.GetTransform().Translation + vector3{X:=+100.0, Z:= 50.0}, CompleteRotation]):
                            Sleep(0.0)
                            FortCharInstigator.PutInStasis(stasis_args{AllowTurning := false, AllowEmotes := true, AllowFalling := true})
                   <#  else:
                         Print("too close to wall")  #>
                <# Print("Yaw {Yaw}") #>
               <#  if (20.0 >= Yaw >= 0.0 or -20.0 <= Yaw <= 0.0):

                    ## workS
                    if (FortCharInstigator.TeleportTo[FortCharTargeted.GetTransform().Translation + vector3{X:= 100.0, Y:= 0.0, Z:= 20.0},FortCharInstigator.GetTransform().Rotation]):
                else if (-75.0 <= Yaw <= -20.0 ):
                    if (FortCharInstigator.TeleportTo[FortCharTargeted.GetTransform().Translation + vector3{X:=- 100.0, Y:= 100.0, Z:= 2.0},FortCharInstigator.GetTransform().Rotation]):
                        ## works
                else if (-105.0 <= Yaw <= -75.0  ):
                    if (FortCharInstigator.TeleportTo[FortCharTargeted.GetTransform().Translation + vector3{X:= 0.0, Y:= 100.0, Z:= 20.0},FortCharInstigator.GetTransform().Rotation]):
                        ## works
                else if  (-165.0 <= Yaw <= -105.0 ):
                    if (FortCharInstigator.TeleportTo[FortCharTargeted.GetTransform().Translation + vector3{X:=100.0, Y:= 100.0, Z:= 20.0},FortCharInstigator.GetTransform().Rotation]):
                        ## WORKS
                else if  (-180.0 <= Yaw <= -165.0 or 160.0 <= Yaw <= 180.0):
                    if (FortCharInstigator.TeleportTo[FortCharTargeted.GetTransform().Translation + vector3{X:=100.0, Y:= 0.0, Z:= 20.0},FortCharInstigator.GetTransform().Rotation]):
                        ## WORKS
                else if ( 105.0 <= Yaw <= 160.0 ):
                    if (FortCharInstigator.TeleportTo[FortCharTargeted.GetTransform().Translation + vector3{X:=100.0, Y:= -100.0, Z:= 20.0},FortCharInstigator.GetTransform().Rotation]):
                        ## WORKS
                else if ( 70.0 <= Yaw <= 105.0 ):
                    if (FortCharInstigator.TeleportTo[FortCharTargeted.GetTransform().Translation + vector3{X:=0.0, Y:= -100.0, Z:= 20.0},FortCharInstigator.GetTransform().Rotation]):
                        ## WORKS
                else if ( 20.0 <= Yaw <= 70.0):
                    if (FortCharInstigator.TeleportTo[FortCharTargeted.GetTransform().Translation + vector3{X:=-100.0, Y:= -100.0, Z:= 20.0},FortCharInstigator.GetTransform().Rotation]):
                        ## woRKS #>
                if (Agent := FortCharInstigator.GetAgent[]):
                    RizzAudioPlayer.Play(Agent)
                    
         
            else:
        else:         
        spawn:
            UnFreezePlayer(FortCharInstigator, 1.5)
        spawn:
            UnFreezePlayer(FortCharTargeted, 2.0)
    
        
       

    GetRotationAngle(FortChar : fort_character) : void = 
        Rotation := FortChar.GetViewRotation()
        if (Yaw := FortChar.GetViewRotation().GetYawPitchRollDegrees()[0]):
            <#  Print("Yaw {Yaw}") #> 
        RotationAngle := Rotation.GetAngle()
            <#  Print("RotationAngle {RotationAngle}")  #>
            
        
            

        <# Print("Rotation angle {RotationAngle}") #>
       

    BackwardsImpulseSetup(AgentTargeted : agent, AgentInstigator : agent ):void =

        <# Print("BackwardsImpulseSetup") #>

        if (FortChar := AgentTargeted.GetFortCharacter[],  FortCharInstigator := AgentInstigator.GetFortCharacter[]):
            option: 
                BackwardsMoverSphere.TeleportTo[FortChar.GetTransform().Translation, FortCharInstigator.GetTransform().Rotation]
            spawn:
                BackwardsMoverSphere.ActivateKnockBackEffect(AgentTargeted, AgentInstigator)

    (Prop : creative_prop).ActivateKnockBackEffect(AgentTargeted : agent, AgentInstigator : agent)<suspends> : void = 
        if (FortCharTargeted := AgentTargeted.GetFortCharacter[], FortCharInstigator := AgentInstigator.GetFortCharacter[]):

            <# Print("Activate KnockBack Effect") #>

            if (Yaw := FortCharInstigator.GetViewRotation().GetYawPitchRollDegrees()[0] ):
                <# Print("{Yaw}") #>
            option:
                Yaw := FortCharInstigator.GetViewRotation().GetYawPitchRollDegrees()[0]
                Pitch:=  0.0
                Roll := 0.0
                NewRotation := MakeRotationFromYawPitchRollDegrees(Yaw, Pitch,Roll)
                if (Prop.TeleportTo[FortCharTargeted.GetTransform().Translation - vector3{Z := 120.0}, NewRotation]):
          
            Sleep (0.1)
           <#  BackwardsMM.Activate(AgentTargeted) #>
            Sleep(0.1)

            option:
                Prop.TeleportTo[Prop.GetTransform().Translation - vector3{Z := 1000.0}, Prop.GetTransform().Rotation]
        if (Prop.TeleportTo[Prop.GetTransform().Translation - vector3{Z := 1000.0}, Prop.GetTransform().Rotation]):
            <# Print("tp underground") #>
            

    CheckForLethalDamage(Agent : agent)<suspends>: void = 
        if (FortChar := Agent.GetFortCharacter[]):
            CurrHealth := FortChar.GetHealth()
            
            if (CurrHealth <1.0 , IsChadResUsed = false):
                FortChar.SetHealth(FortChar.GetMaxHealth())
                FortChar.SetShield(FortChar.GetMaxShield())
                if (FortChar.TeleportTo[vector3{X:=-3628.000001, Y:= 971.999999, Z:= 30.0 +384.0},FortChar.GetTransform().Rotation]):
                    
                    <# Print("chad tp'ed after death") #>

                else: 
                    
                    <# Print("chad couldn't tp") #>
                
                FortChar.SetVulnerability(false)
                GuardSpawner1.Spawn()
                GuardSpawner2.Spawn()
               
                
                
                Sleep(1.0)

                Light.TurnOn()
                spawn:
                    TurnOffLight()
                FortChar.SetVulnerability(true)
                
                ChadAudioPlayer.Play()
               
                Lock.Unlock(Agent)
                Lock.Open(Agent)
                set  IsChadResUsed = true
     
                <# Print("chad can be damaged") #>


    ChangeVulnerability(MaybeAgent: ? agent): void =
        if (Agent := MaybeAgent?, FortChar := Agent.GetFortCharacter[] ):
         


        
    GiveGuardBuffs1(Agent : agent) :void = 
        spawn:
            GuardBuffsLoop1(Agent)
    
    GiveGuardBuffs2(Agent : agent) :void = 
        spawn:
            GuardBuffsLoop2(Agent)

    GuardBuffsLoop1(Agent : agent)<suspends>: void = 
       
        <# Print("giveguardbuffsloop1") #>
        
        loop:
            if (IsGuard1Dead= true):
                break
            Players:= GetPlayspace().GetPlayers()
            for (Player : Players , FortChar := Player.GetFortCharacter[]):
                TeamCollection := GetPlayspace().GetTeamCollection()
                if (AgentsTeam := TeamCollection.GetTeam[Agent]):
                    TeamsArray := TeamCollection.GetTeams()
                    for (TeamNumber -> Team: TeamsArray):
                        if(AgentsTeam = Team):
                            if (TeamNumber = 2): 
                                GuardHealBuffsDevice.Pickup(Agent)


            Sleep(3.0)

    GuardBuffsLoop2(Agent : agent)<suspends>: void = 

        DamageBuffsDevice.Pickup(Agent)
         loop:
            if (IsGuard2Dead= true):
                break
            Players:= GetPlayspace().GetPlayers()
            for (Player : Players , FortChar := Player.GetFortCharacter[]):
                TeamCollection := GetPlayspace().GetTeamCollection()
                if (AgentsTeam := TeamCollection.GetTeam[Agent]):
                    TeamsArray := TeamCollection.GetTeams()
                    for (TeamNumber -> Team: TeamsArray):
                        if(AgentsTeam = Team):
                            if (TeamNumber = 2): 
                                GuardHealBuffsDevice.Pickup(Agent)

            Sleep(3.0)


           


    RemoveGuardBuffs1(AIResult : device_ai_interaction_result): void =
        set IsGuard1Dead = true
    

    RemoveGuardBuffs2(AIResult : device_ai_interaction_result): void =
        set IsGuard1Dead = true


    UnFreezePlayer(FortCharacter : fort_character, Time : float)<suspends>: void =
        Sleep(Time)
        FortCharacter.ReleaseFromStasis()

    TurnOffLight ()<suspends>: void = 
        Sleep(8.0)
        Light.TurnOff()