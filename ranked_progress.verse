
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
ranked_progress := class(creative_device):

    @editable
    CinDeviceRanked : cinematic_sequence_device = cinematic_sequence_device{}

    @editable 
    HUDRanked : hud_message_device = hud_message_device{}

    @editable
    TriggerElim : trigger_device = trigger_device{}
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # TODO: Replace this with your code
        TriggerElim.TriggeredEvent.Subscribe(IncreaseProgress)


    IncreaseProgress(MaybeAgent : ? agent): void = 
        if (Agent := MaybeAgent?):
            var PreviousFrame :float = CinDeviceRanked.GetPlaybackTime()

            <# Print("previous frame {PreviousFrame}") #>

            <# CinDeviceRanked.Play(Agent) #>
            CinDeviceRanked.SetPlaybackTime(0.5 + PreviousFrame)
            <# CinDeviceRanked.SetPlaybackFrame(5+ PreviousFrame) #>
            <# HUDRanked.Show(Agent) #>