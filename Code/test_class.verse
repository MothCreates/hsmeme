
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
<# test_class := class(creative_device):


    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        Players := GetPlayspace().GetPlayers()
        for (Player : Players):
            spawn:
                GetViewRotate(Player)
    


    GetViewRotate(Player: player)<suspends>: void = 
        if (FortChar := Player.GetFortCharacter[]):
            
            if (Angle > 0 and Angle < 90.0):

 #>