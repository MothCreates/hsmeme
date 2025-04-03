using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters}
using { /Fortnite.com/Game}
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using {/UnrealEngine.com/Temporary/SpatialMath}

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
remote_device := class(creative_device):
    @editable
    OrangeRemote : signal_remote_manager_device = signal_remote_manager_device{}

    @editable
    PopularLonerExplosive : explosive_device = explosive_device{}

    @editable
    PopularLonerTriggerPower : trigger_device = trigger_device{}
    @editable
    FurryTriggerPower : trigger_device = trigger_device{}
    @editable
    DModTriggerPower : trigger_device = trigger_device{}
    @editable
    QuietKidTriggerPower : trigger_device = trigger_device{}
    @editable
    PlugTriggerPower : trigger_device = trigger_device{}
    @editable
    SuperTriggerPower : trigger_device = trigger_device{}
 <#    @editable
    InputDevice : input_trigger_device =input_trigger_device{} #>
    @editable
    ItemRemoverQuietKid : item_remover_device = item_remover_device{}


    @editable
    FurryTimer : timer_device = timer_device{}
    @editable
    PopularLonerTimer : timer_device = timer_device{}
    @editable
    PlugTimer : timer_device = timer_device{}
    @editable
    DmodTimer : timer_device = timer_device{}
    @editable
    QuietKidTimer : timer_device = timer_device{}
    @editable
    SuperTimer : timer_device = timer_device{}

    @editable
    CinameticSequencePlug : cinematic_sequence_device =cinematic_sequence_device{}
    @editable
    CinameticSequenceJumpScare : cinematic_sequence_device =cinematic_sequence_device{}
    

    var IsPopularOnCD : logic = false
    var IsFurryOnCD : logic = false
    var IsQuietKidOnCD : logic = false
    var IsDModOnCD : logic = false
    var IsPlugOnCD : logic = false
    var isSuperSeniorOnCD : logic = false
    var IsFurryUnderground: logic = false
     

    @editable
    AudioPlayerSuper : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerQuietKid : audio_player_device = audio_player_device{}
    @editable
    AudioPlayerPlug : audio_player_device = audio_player_device{}
    
    @editable
    FurryUndergroundTimer : timer_device = timer_device{}

    var ClosestPlayer :?agent = false
    var DistanceToMe : float = 1000000000.0 
    var FoundPlayer : logic = false

    var ClosestPlayerPlug :?agent = false
    var DistanceToMePlug : float = 1000000000.0 
    var FoundPlayerPlug : logic = false

    var ClosestPlayerWeird :?agent = false
    var DistanceToMeWeird : float = 1000000000.0 
    var FoundPlayerWeird : logic = false

    var ClosestPlayerSuper :?agent = false
    var DistanceToMeSuper : float = 1000000000.0 
    var FoundPlayerSuper : logic = false

    var NewRotationAngle : float = 0.0
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        OrangeRemote.PrimarySignalEvent.Subscribe(OnRemoteClick)
        OrangeRemote.SecondarySignalEvent.Subscribe(OnRemoteClick)
       <#  InputDevice.PressedEvent.Subscribe(OnRemoteClick) #>
        
        # TODO: Replace this with your code
        FurryTimer.SuccessEvent.Subscribe(TimerCompleted)
        PopularLonerTimer.SuccessEvent.Subscribe(TimerCompleted)
        PlugTimer.SuccessEvent.Subscribe(TimerCompleted)
        DmodTimer.SuccessEvent.Subscribe(TimerCompleted)
        QuietKidTimer.SuccessEvent.Subscribe(TimerCompleted)
        SuperTimer.SuccessEvent.Subscribe(TimerCompleted)

        FurryUndergroundTimer.SuccessEvent.Subscribe(SendFurryAbove)
        
    OnRemoteClick(Agent : agent): void = 
        TeamCollection := GetPlayspace().GetTeamCollection()
        if (AgentsTeam := TeamCollection.GetTeam[Agent]):
            TeamsArray := TeamCollection.GetTeams()
            for (TeamNumber -> Team: TeamsArray):
                if(AgentsTeam = Team):
                    if (TeamNumber = 7):
                        if (IsPopularOnCD = false, FortChar := Agent.GetFortCharacter[]):
                            if(PopularLonerExplosive.TeleportTo[FortChar.GetTransform().Translation, FortChar.GetTransform().Rotation]):

                                <# Print("explode") #>
                                
                                set IsPopularOnCD = true
                                PopularLonerExplosive.Explode(Agent)
                                PopularLonerExplosive.Reset()
                                PopularLonerTimer.Start(Agent)
                                PopularLonerTriggerPower.Trigger(Agent)
                    if (TeamNumber = 5, IsFurryOnCD = false,  FortChar := Agent.GetFortCharacter[]):
                        if (IsFurryUnderground = false):
                            FurryPos : vector3 = FortChar.GetTransform().Translation
                            UnderGroundPos :vector3 = vector3{X := FurryPos.X, Y := FurryPos.Y, Z:= 40.0}
                            if (FortChar.TeleportTo[UnderGroundPos, FortChar.GetTransform().Rotation]):
                                set IsFurryUnderground = true
                                FurryUndergroundTimer.Start(Agent)

                                
                                <# Print("furry is underground") #>
                        
                        else if (IsFurryUnderground = true):
                            FurryPos : vector3 = FortChar.GetTransform().Translation
                            AboveGroundPos :vector3 = vector3{X := FurryPos.X, Y := FurryPos.Y, Z:= 420.0}
                            if (FortChar.TeleportTo[AboveGroundPos, FortChar.GetTransform().Rotation]):
                                FurryTriggerPower.Trigger(Agent)
                                set IsFurryUnderground = false
                                set IsFurryOnCD = true
                                FurryTimer.Start(Agent)

                                <# Print("furry is above ground") #>
                    if (TeamNumber = 6, isSuperSeniorOnCD = false):
                        AllPlayers : []player = GetPlayspace().GetPlayers()
                        for (Player : AllPlayers):
                            if (Player <> Agent):

                                <# Print("player isnot same") #>

                                if (MyFortChar :  fort_character = Agent.GetFortCharacter[], OtherFC : fort_character = Player.GetFortCharacter[]):
                                    MyPosSuper : vector3 = MyFortChar.GetTransform().Translation
                                    OtherPosSuper: vector3 = OtherFC.GetTransform().Translation
                                    TotalDistanceSuper : float = Distance (MyPosSuper,OtherPosSuper) / 100.0

                                    if (TotalDistanceSuper < DistanceToMeSuper):
                                        
                                        set FoundPlayerSuper = true
                                        
                                        <# Print("foundplayer") #>

                                        set DistanceToMeSuper = TotalDistanceSuper
                                        
                                        set ClosestPlayerSuper = option{Player}    
                                        if (FoundPlayerSuper= true):
    
                        if(PlayerAgent : agent = agent[ClosestPlayerSuper?]):
                            if (FortChar : fort_character = PlayerAgent.GetFortCharacter[]):

                                spawn:
                                    TeleportSuper(FortChar, Agent)
                                set FoundPlayerSuper = false
                                
                                set DistanceToMeSuper  = 10000000000.0
                    if (TeamNumber = 10, IsPlugOnCD = false):
                        AllPlayers : []player = GetPlayspace().GetPlayers()
                        for (Player : AllPlayers):
                            if (Player <> Agent):

                                <# Print("player isnot same") #>

                                if (MyFortChar :  fort_character = Agent.GetFortCharacter[], OtherFC : fort_character = Player.GetFortCharacter[]):
                                    MyPosPlug : vector3 = MyFortChar.GetTransform().Translation
                                    OtherPosPlug: vector3 = OtherFC.GetTransform().Translation
                                    TotalDistancePlug : float = Distance (MyPosPlug,OtherPosPlug) / 100.0

                                    if (TotalDistancePlug < DistanceToMePlug):
                                        
                                        set FoundPlayerPlug = true
                                        
                                        <# Print("foundplayer") #>

                                        set DistanceToMePlug = TotalDistancePlug
                                        
                                        set ClosestPlayerPlug = option{Player}      
                        if (FoundPlayerPlug= true):
    
                            if(PlayerAgent : agent = agent[ClosestPlayerPlug?]):
                                if (FortChar : fort_character = PlayerAgent.GetFortCharacter[]):
                            

                                    <# if (MoverSpherePlug.TeleportTo[FortChar.GetTransform().Translation + vector3{ Z := 30.0}, FortChar.GetTransform().Rotation ]): #>

                                    <# Print("play cinematic Plug") #>

                                    PlugTriggerPower.Trigger(Agent)
                                    CinameticSequencePlug.Play(PlayerAgent)
                                    AudioPlayerPlug.Play(PlayerAgent)
                                    PlugTimer.Start(Agent)
                                    set FoundPlayerPlug = false
                                    set IsPlugOnCD = true
                                    set DistanceToMePlug  = 10000000000.0
                    if (TeamNumber = 15, IsQuietKidOnCD = false):
                        AllPlayers : []player = GetPlayspace().GetPlayers()
                        for (Player : AllPlayers):
                            if (Player <> Agent):

                                <# Print("player isnot same") #>

                                if (MyFortChar :  fort_character = Agent.GetFortCharacter[], OtherFC : fort_character = Player.GetFortCharacter[]):
                                    MyPos : vector3 = MyFortChar.GetTransform().Translation
                                    OtherPos: vector3 = OtherFC.GetTransform().Translation
                                    TotalDistance : float = Distance (MyPos,OtherPos) / 100.0

                                    if (TotalDistance < DistanceToMe):
                                       
                                        set FoundPlayer = true
                                        
                                        set DistanceToMe = TotalDistance
                                        
                                        set ClosestPlayer = option{Player}    

                        if (FoundPlayer = true):
                    
                            if(PlayerAgent : agent = agent[ClosestPlayer?]):
                                if (FC : fort_character = PlayerAgent.GetFortCharacter[]):
                                    
                                    <# Print("remove items") #>

                                    QuietKidTriggerPower.Trigger(Agent)
                                    ItemRemoverQuietKid.Remove(PlayerAgent)
                                    QuietKidTimer.Start(Agent)
                                    AudioPlayerQuietKid.Play(PlayerAgent)
                                    
                                    set FoundPlayer = false
                                    set DistanceToMe  = 10000000000.0
                                    set IsQuietKidOnCD = true

                    if (TeamNumber = 8 , IsDModOnCD = false):
                        AllPlayers : []player = GetPlayspace().GetPlayers()
                        for (Player : AllPlayers):
                            if (Player <> Agent):

                                <# Print("player isnot same") #>

                                if (MyFortChar :  fort_character = Agent.GetFortCharacter[], OtherFC : fort_character = Player.GetFortCharacter[]):
                                    MyPos : vector3 = MyFortChar.GetTransform().Translation
                                    OtherPos: vector3 = OtherFC.GetTransform().Translation
                                    TotalDistanceWeird : float = Distance (MyPos,OtherPos) / 100.0

                                    if (TotalDistanceWeird < DistanceToMeWeird):
                                       
                                        set FoundPlayerWeird = true
                                        
                                        set DistanceToMeWeird = TotalDistanceWeird
                                        
                                        set ClosestPlayerWeird = option{Player}    

                        if (FoundPlayerWeird = true):
                    
                            if(PlayerAgent : agent = agent[ClosestPlayerWeird?]):
                                if (OtherFortChar : fort_character = PlayerAgent.GetFortCharacter[]):
                                    
                                    <# Print("spawn teleport weird kid") #>

                                    CinameticSequenceJumpScare.Play(PlayerAgent)
                                    spawn:
                                        TeleportDMod(OtherFortChar, Agent)
                                    set FoundPlayerWeird = false
                                    set DistanceToMeWeird  = 10000000000.0
                                    set IsDModOnCD = true  
                                    DmodTimer.Start(Agent)   

    TeleportDMod(OtherFortChar : fort_character, Agent : agent)<suspends>: void = 
        Sleep(2.0)

        <# Print("starting teleport weird kid") #>

        if (MyFortChar := Agent.GetFortCharacter[]):
            EnemyLoc := OtherFortChar.GetTransform().Translation
            PlayerLoc := MyFortChar.GetTransform().Translation
            Rotation := OtherFortChar.GetViewRotation()
            RotationAngle := Rotation.GetAngle()
            
            if (Yaw := OtherFortChar.GetViewRotation().GetYawPitchRollDegrees()[0], OtherFortChar.IsActive[]):
                <# Print("Rotatoin angle {RotationAngle}") #>
                if (-46.0 <= Yaw < 0.0 or 0.0 <= Yaw < 46.0):
                    if ( EnemyLoc.X >  -3328.0 + 150.0):
                        if (MyFortChar.TeleportTo[OtherFortChar.GetTransform().Translation + vector3{X:=-50.0},OtherFortChar.GetTransform().Rotation]):
                            DModTriggerPower.Trigger(Agent)
                    
                    else:
                        <# Print("too close to wall") #>

                else if  (-135.0 <= Yaw < -0.46 ):
                    if ( EnemyLoc.Y <  2816.0 - 150.0):
                        if (MyFortChar.TeleportTo[OtherFortChar.GetTransform().Translation + vector3{ Y:= 50.0},OtherFortChar.GetTransform().Rotation]):
                            DModTriggerPower.Trigger(Agent)
                           
                    else:
                       <#  Print("too close to wall") #>
                                
                else if (-180.0 <= Yaw < -135.0  or  180.0 >= Yaw > 135.0 ):
                    if (EnemyLoc.X <  106.00):
                        if (MyFortChar.TeleportTo[OtherFortChar.GetTransform().Translation + vector3{X:=50.0},OtherFortChar.GetTransform().Rotation]):
                            DModTriggerPower.Trigger(Agent)
                            
                    else:
                        <# Print("too close to wall") #>
                              
                else if (0.46 <= Yaw < 135.0 ):
                    if (EnemyLoc.Y >  -706.0    ):
                        if (MyFortChar.TeleportTo[OtherFortChar.GetTransform().Translation + vector3{Y:= -50.0},OtherFortChar.GetTransform().Rotation]):
                            DModTriggerPower.Trigger(Agent)
                            
                    else:
                        <# Print("too close to wall") #>

    TeleportSuper(OtherFortChar : fort_character, Agent : agent)<suspends>: void = 


        <# Print("starting teleport SUPER")  #>

        if (MyFortChar := Agent.GetFortCharacter[]):
            EnemyLoc := OtherFortChar.GetTransform().Translation
            PlayerLoc := MyFortChar.GetTransform().Translation
            Rotation := OtherFortChar.GetViewRotation()
            RotationAngle := Rotation.GetAngle()
            RotationAxis := Rotation.GetAxis()

            if (RotationAngle <=3.14):
                set NewRotationAngle = RotationAngle+3.14
            else if(3.14 < RotationAngle <= 6.28) :
                set NewRotationAngle = RotationAngle -3.14
            <# Print("{RotationAngle} Rotation Angle , {NewRotationAngle} opposite angle") #>
            CompleteRotation := MakeRotation(RotationAxis, NewRotationAngle)


            OtherFortChar.ReleaseFromStasis()
            MyFortChar.ReleaseFromStasis()
            


        
            if (Yaw := OtherFortChar.GetViewRotation().GetYawPitchRollDegrees()[0], OtherFortChar.IsActive[]):
                <# Print("Rotatoin angle {RotationAngle}") #>
                if (-46.0 <= Yaw < 0.0 or 0.0 <= Yaw < 46.0):
                    if ( EnemyLoc.X <  106.00):
                        if (MyFortChar.TeleportTo[OtherFortChar.GetTransform().Translation + vector3{X:=50.0},CompleteRotation]):
                            SuperTriggerPower.Trigger(Agent)
                            SuperTimer.Start(Agent)
                            Sleep(0.0)
                            OtherFortChar.PutInStasis(stasis_args{AllowTurning := false, AllowEmotes := false, AllowFalling := false})
                            Sleep(0.0)
                            MyFortChar.PutInStasis(stasis_args{AllowTurning := false, AllowEmotes := true, AllowFalling := false})
                            AudioPlayerSuper.Play(Agent)
                            set isSuperSeniorOnCD = true 
                    else:
                        <# Print("too close to wall") #>

                else if  (-135.0 <= Yaw < -0.46  ):
                    if (EnemyLoc.Y >  -706.0):
                        if (MyFortChar.TeleportTo[OtherFortChar.GetTransform().Translation + vector3{ Y:= -50.0},CompleteRotation]):
                            SuperTriggerPower.Trigger(Agent)
                            SuperTimer.Start(Agent)
                            Sleep(0.0)
                            OtherFortChar.PutInStasis(stasis_args{AllowTurning := false, AllowEmotes := false, AllowFalling := false})
                            Sleep(0.0)
                            MyFortChar.PutInStasis(stasis_args{AllowTurning := false, AllowEmotes := true, AllowFalling := false})
                            AudioPlayerSuper.Play(Agent)
                            set isSuperSeniorOnCD = true 
                    else:
                        <#  Print("too close to wall") #>
                                
                else if (-180.0 <= Yaw < -135.0  or  180.0 >= Yaw > 135.0 ):
                    if (EnemyLoc.X >  -3328.0 + 150.0 ):
                        if (MyFortChar.TeleportTo[OtherFortChar.GetTransform().Translation + vector3{X:=-50.0},CompleteRotation]):
                            SuperTriggerPower.Trigger(Agent)
                            SuperTimer.Start(Agent)
                            Sleep(0.0)
                            OtherFortChar.PutInStasis(stasis_args{AllowTurning := false, AllowEmotes := false, AllowFalling := false})
                            Sleep(0.0)
                            MyFortChar.PutInStasis(stasis_args{AllowTurning := false, AllowEmotes := true, AllowFalling := false})
                            AudioPlayerSuper.Play(Agent)
                            set isSuperSeniorOnCD = true 

                    else:
                        <# Print("too close to wall") #>
                                
                else if (0.46 <= Yaw < 135.0 ):
                    if (EnemyLoc.Y <  2769.132032 - 150.0):
                        if (MyFortChar.TeleportTo[OtherFortChar.GetTransform().Translation + vector3{Y:= 50.0},CompleteRotation]):
                            SuperTriggerPower.Trigger(Agent)
                            SuperTimer.Start(Agent)
                            Sleep(0.0)
                            OtherFortChar.PutInStasis(stasis_args{AllowTurning := false, AllowEmotes := false, AllowFalling := false})
                            Sleep(0.0)
                            MyFortChar.PutInStasis(stasis_args{AllowTurning := false, AllowEmotes := true, AllowFalling := false})
                            AudioPlayerSuper.Play(Agent)
                            set isSuperSeniorOnCD = true 

                    else:
                        <# Print("too close to wall") #>
                spawn:
                    UnFreezePlayer(MyFortChar, 1.0)
                spawn:
                    UnFreezePlayer(OtherFortChar, 1.0)
                    
    TimerCompleted(MaybeAgent : ? agent): void = 
        if (Agent := MaybeAgent?):
            TeamCollection := GetPlayspace().GetTeamCollection()
            if (AgentsTeam := TeamCollection.GetTeam[Agent]):
                TeamsArray := TeamCollection.GetTeams()
                for (TeamNumber -> Team: TeamsArray):
                    if(AgentsTeam = Team):
                        if (TeamNumber = 5):
                            set IsFurryOnCD = false
                        if( TeamNumber = 6):
                            set isSuperSeniorOnCD = false
                        if (TeamNumber = 7):
                            set IsPopularOnCD = false
                        if (TeamNumber = 8):
                            set IsDModOnCD = false
                        if (TeamNumber = 10):
                            set IsPlugOnCD = false
                        if (TeamNumber =15):
                            set IsQuietKidOnCD = false
    
    SendFurryAbove(MaybeAgent: ? agent): void =
        if (Agent := MaybeAgent?): 
            if (IsFurryUnderground = true):
                OnRemoteClick(Agent)

    UnFreezePlayer(FortCharacter : fort_character, Time : float)<suspends>: void =
        Sleep(Time)
        FortCharacter.ReleaseFromStasis()