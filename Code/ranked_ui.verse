
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Colors }
using { /Verse.org/Assets }
using { /Fortnite.com/Characters }
# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
ranked_ui := class(creative_device):

    var CanvasPerPlayer : [agent]?canvas = map{}
    var ProgressBarPerPlayer : [agent]?progress_bar = map{}

    Omega : float = 10.0
    Gamma : float = 20.0
    Delta : float = 40.0
    Beta  :float = 60.0
    Sigma : float = 80.0
    Alpha : float = 100.0
    
    @editable
    AccoladeAlpha : accolades_device =accolades_device{}
    ##REMOVE
    @editable
    ResetKills : button_device = button_device{}

    @editable
    TriggerElim : trigger_device = trigger_device{}

    @editable
    TriggerAddElim : trigger_device = trigger_device{}
    @editable
    TriggerAddWin : trigger_device = trigger_device{}

    @editable
    TriggerAssign : trigger_device = trigger_device{}
    @editable
    TriggerCheckProgress : trigger_device = trigger_device{}

    @editable
    TriggerRefreshUI : trigger_device = trigger_device{}
    @editable
    TrackerElims : tracker_device = tracker_device{}
    @editable
    TrackerWin : tracker_device = tracker_device{}
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        TriggerElim.TriggeredEvent.Subscribe(ProgressUI)

        TriggerAssign.TriggeredEvent.Subscribe(AssignUI)
        
        <# TriggerCheckProgress.TriggeredEvent.Subscribe(CheckProgressUI) #>
        TriggerCheckProgress.TriggeredEvent.Subscribe(RefreshUI)
        TriggerRefreshUI.TriggeredEvent.Subscribe(RefreshUI)
        # TODO: Replace this with your code
        ## REMOVE
        TriggerAddElim.TriggeredEvent.Subscribe(AddElim)
        TriggerAddWin.TriggeredEvent.Subscribe(AddWin)

        ResetKills.InteractedWithEvent.Subscribe(SetKills0)
    MakeBasicCanvas(Agent: agent):tuple(canvas, progress_bar) = 
        MyRankedStats := CheckProgress(Agent)
        RankIndex := MyRankedStats(1)
        MyProgressBar := MakeProgressBar(1.0, RightToLeft, vector2{X:=300.0, Y:= 15.0},MakeColorFromSRGB(0.0, 0.1, 1.0), MakeColorFromSRGB(1.0, 1.0, 1.0) )
        MyWidget := MyProgressBar.GetWidget(RankIndex)
        Canvas := canvas:
            Slots:= array:
                canvas_slot:
                    Widget:= MyWidget
                    SizeToContent:= true
                    Anchors := anchors{Minimum := vector2{X := 0.02, Y := 0.3}, Maximum := vector2{X := 0.02, Y := 0.3}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.02, Y := 0.3}
                

                 
        return(Canvas, MyProgressBar)

    
    ProgressUI(MaybeAgent : ?agent): void = 

        
        <# Print("kill") #>
        
        if (Agent := MaybeAgent?):
            PrevElims := TrackerElims.GetValue(Agent)
            NewElims := PrevElims + 5
            TrackerElims.SetValue(Agent, NewElims)

            <# Print("Elims {NewElims}") #>
           <#  if (PB := ProgressBarPerPlayer[Agent]?):
                PB.SetProgress(-0.1)  #>
    CheckProgressUI(MaybeAgent : ?agent): void = 
        
       
        <# Print("check progress UI") #>

        if (Agent := MaybeAgent?):
            if (PB := ProgressBarPerPlayer[Agent]?):
                MyRankedStats := CheckProgress(Agent)
                TotalRankedXPRatio := MyRankedStats(0)
                MyRankIndex := MyRankedStats(1)
    
                PB.SetProgress(1.0-TotalRankedXPRatio)

    CheckProgress (Agent : agent):tuple(float, int)=
        TotalElims  := GetElims(Agent)
        TotalWins := GetWins(Agent)

        TotalRankedXP := ((TotalWins*3 ) + (TotalElims))*1.0
        var TotalRankedXPRatio : float = 0.0
        var Rank: int = 0
        

        ##    Omega : float = 10.0 Gamma : float = 20.0  Delta : float = 40.0 Beta  :float = 60.0 Sigma : float = 80.0 Alpha : float = 100.0
    
        if (TotalRankedXP <= Omega - 1.0):
          set  TotalRankedXPRatio = (TotalRankedXP / Omega)
            set Rank = 0

        else if(TotalRankedXP <= Gamma - 1.0):
            set  TotalRankedXPRatio = ((TotalRankedXP - Omega) / (Gamma - Omega))
            set Rank = 1
           
    

        else if (TotalRankedXP <= Delta - 1.0):
            set  TotalRankedXPRatio = ((TotalRankedXP -Gamma )/ (Delta- Gamma))
            set Rank = 2
         
        else if (TotalRankedXP <= Beta - 1.0):
            set TotalRankedXPRatio = ((TotalRankedXP- Delta )/ (Beta- Delta))
            set Rank = 3
           
        else if (TotalRankedXP <= Sigma - 1.0):
            set TotalRankedXPRatio = ((TotalRankedXP - Beta) / (Sigma - Beta))
            set Rank = 4
          
        else if (TotalRankedXP = Sigma ):
            set TotalRankedXPRatio = ((TotalRankedXP - Sigma )/ (Alpha - Alpha))
            set Rank = 5
            <# AccoladeAlpha.Award(Agent) #>    
        else if (TotalRankedXP > Sigma ):
            set TotalRankedXPRatio = ((TotalRankedXP - Sigma )/ (Alpha - Alpha))
            set Rank = 5
  
           
        <# Print("Total Ranked XP {TotalRankedXP} Total elims {TotalElims} Totalwins {TotalWins} XpRatio {TotalRankedXPRatio} RankIndex {Rank}")  #>
        
        return (TotalRankedXPRatio, Rank)


    AssignUI(MaybeAgent : ?agent): void = 

        <# Print("asign UI") #>

        if (Agent:= MaybeAgent?):
            CanvasTuple := MakeBasicCanvas(Agent)
            Canvas := CanvasTuple(0)
            ProgressBar := CanvasTuple(1)

            if:
                PlayerUI:= GetPlayerUI[player[Agent]]
            then:
                PlayerUI.AddWidget(Canvas, player_ui_slot{InputMode:= ui_input_mode.None})
                if:
                    set CanvasPerPlayer[Agent] = option{Canvas}
                    set ProgressBarPerPlayer[Agent] = option{ProgressBar}
                CheckProgressUI(MaybeAgent)

    RefreshUI(MaybeAgent : ?agent): void = 
        if (Agent := MaybeAgent?):

            <# Print("refresh ui") #>
        
            if:
                PlayerUI:= GetPlayerUI[player[Agent]]
                MaybeCanvas := CanvasPerPlayer[Agent] 
                Canvas := MaybeCanvas ?
            then:
                PlayerUI.RemoveWidget(Canvas)
                TriggerAssign.Trigger(Agent)


            

    GetElims(Agent: agent): int =
        <# Print("getelims") #>
        var ElimCount :int = TrackerElims.GetValue(Agent)
        <# Print("{ElimCount}") #>
        return ElimCount
        
    GetWins(Agent: agent): int =
        <# Print("getelims") #>
        var WinCount :int = TrackerWin.GetValue(Agent)
        <# Print("{ElimCount}") #>
        return WinCount


    ## REMOVE
    SetKills0(Agent : agent):void = 

        <# Print("ResetKills") #>
        TrackerElims.SetValue(0)
        TrackerWin.SetValue(0)


    ##removE once tracker fixed
    AddElim(MaybeAgent :? agent) : void = 
        if (Agent := MaybeAgent?):
            PrevElims := TrackerElims.GetValue(Agent)
            NewElims := PrevElims + 1
            TrackerElims.SetValue(Agent, NewElims)
            RefreshUI(MaybeAgent)
    AddWin(MaybeAgent :? agent) : void = 
        if (Agent := MaybeAgent?):
            PrevWins := TrackerWin.GetValue(Agent)
            NewWins := PrevWins + 1
            TrackerWin.SetValue(Agent, NewWins)
            RefreshUI(MaybeAgent)