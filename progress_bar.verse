# fill this file with your verse-script
using{/Fortnite.com/UI}
using{/UnrealEngine.com/Temporary/UI}
using{/UnrealEngine.com/Temporary/SpatialMath}
using{/Verse.org/Colors}
using{/Verse.org/Assets}

RightToLeft:tuple(horizontal_alignment,vertical_alignment)=(horizontal_alignment.Right,vertical_alignment.Fill)
LeftToRight:tuple(horizontal_alignment,vertical_alignment)=(horizontal_alignment.Left,vertical_alignment.Fill)
DownToUp:tuple(horizontal_alignment,vertical_alignment)=(horizontal_alignment.Fill,vertical_alignment.Bottom)
UpToDown:tuple(horizontal_alignment,vertical_alignment)=(horizontal_alignment.Fill,vertical_alignment.Top)

MakeProgressBar(InProgress:float,InOrientation:tuple(horizontal_alignment,vertical_alignment),InSize:vector2,InFrontColor:color,InBackColor:color):progress_bar=
    return progress_bar{Progress:=InProgress,Orientation:=InOrientation,Size:=InSize,FrontColor:=InFrontColor,BackColor:=InBackColor}
 
progress_bar := class:
 
    var Progress : float = 0.0
    var PrevProgress : float = 0.0
    var TotalElims : int = 0 

    Orientation : tuple(horizontal_alignment,vertical_alignment)
    Size : vector2
    var FrontColor : color = color{}
    var BackColor : color = color{}
 
    var FrontColorBlock : color_block = color_block{}
    var BackColorBlock : color_block = color_block{}

    var FrontBar : texture_block = texture_block{DefaultImage := Ranked.full_bar}
    var BackBar : texture_block = texture_block{DefaultImage := Ranked.blank_bar}
  <#   var TextImage : texture_block = texture_block{DefaultImage := Ranked.rank_Gamma, DefaultDesiredSize := vector2{X:=160.0, Y:= 80.0}} #>
    var ImageSize : vector2 = vector2{}
 
    TexturesBar : []texture = array:
        Ranked.omega
        Ranked.Gamma
        Ranked.delta
        Ranked.beta
        Ranked.SIGMA
        Ranked.alpha
     
    #Return a widget to be used in your UI
    #As a widget, you can only use one progress_bar once.
    GetWidget(Index : int):stack_box=
        <# set FrontColorBlock = color_block{DefaultColor:=FrontColor,DefaultDesiredSize:=vector2{X:=0.0,Y:=0.0}}
        set BackColorBlock = color_block{DefaultColor:=BackColor,DefaultDesiredSize:=Size} #>
        set FrontBar = texture_block{DefaultImage := Ranked.blank_bar, DefaultDesiredSize := vector2{X:=0.0, Y:= 0.0}}
        set BackBar = texture_block{DefaultImage := Ranked.full_bar, DefaultDesiredSize := Size}
        SetProgress(Progress)
        return stack_box:
            Orientation := orientation.Vertical
            Slots := array:
                stack_box_slot:
                    Widget:= overlay:
                        Slots:= array:
                            overlay_slot:
                                Widget:= GetImageWidgetBar(Index)
                                HorizontalAlignment:=horizontal_alignment.Fill
                                VerticalAlignment:=vertical_alignment.Fill
                                Padding := margin{Bottom := 20.0}
                                
                                
                   
                stack_box_slot:
                    Widget := overlay:
                        Slots := array:
                            overlay_slot:
                                <# Widget:=BackColorBlock #>
                                Widget:=  BackBar
                                HorizontalAlignment:=horizontal_alignment.Fill
                                VerticalAlignment:=vertical_alignment.Fill
                    
                            overlay_slot:
                                <# Widget:=FrontColorBlock #>
                                Widget:=FrontBar
                                HorizontalAlignment:=Orientation(0)
                                VerticalAlignment:=Orientation(1)
        

    #Updates the progress displayed
    SetProgress(InProgress:float):void=
       
        set Progress = InProgress

        
        #If the orientation is vertical
        if(Orientation(0)=horizontal_alignment.Fill):
            
            <# FrontColorBlock.SetDesiredSize(vector2{Y:=Size.Y*(Progress+PrevProgress)}) #>
            FrontBar.SetDesiredSize(vector2{Y:=Size.Y*(Progress)})
 
        #If the orientation is horizontal
        if(Orientation(1)=vertical_alignment.Fill):
            <# FrontColorBlock.SetDesiredSize(vector2{X:=Size.X*(Progress+PrevProgress)}) #>
            FrontBar.SetDesiredSize(vector2{X:=Size.X*(Progress)})
            
        
        set PrevProgress = Progress 
        <# Print("{PrevProgress}") #>
    #Sets the color of the front of the progress bar
    SetFrontColor(MyColor:color):void=
        set FrontColor = MyColor
        FrontColorBlock.SetColor(FrontColor)
 
    #Sets the color of the back of the progress bar 
    SetBackColor(MyColor:color):void=
        set BackColor = MyColor
        BackColorBlock.SetColor(BackColor)

    GetImageWidgetBar(Index : int) : widget =
        if ( Texture := TexturesBar[Index]):
            return texture_block:
                DefaultImage := Texture
                DefaultDesiredSize := vector2{X:=500.0, Y:= 200.0}
        else:
            return color_block:
                DefaultColor :=  FrontColor
                DefaultDesiredSize := 0.9 * ImageSize

    SetElims(I : int ): void =
        set TotalElims = I
        

  
