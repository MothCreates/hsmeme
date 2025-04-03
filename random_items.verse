
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
random_items := class(creative_device):

    @editable
    ConditionalItemVoting : conditional_button_device = conditional_button_device{}
    @editable
    ConditionalItemVoting2 : conditional_button_device = conditional_button_device{}

    @editable
    ButtonFood1 : button_device = button_device{}
   
    @editable
    ButtonMystery1 : button_device = button_device{}
    @editable
    ButtonMystery2 : button_device = button_device{}

    @editable
    ButtonUpgrade : button_device = button_device{}
    @editable
    ButtonUpgrade2 : button_device = button_device{}
    @editable
    ButtonUpgrade3 : button_device = button_device{}

    @editable
    FoodItemGranter : item_granter_device=  item_granter_device{}
    @editable
    FoodItemGranter2 : item_granter_device=  item_granter_device{}
    @editable
    FoodItemGranter3 : item_granter_device=  item_granter_device{}
    @editable
    FoodItemGranter4 : item_granter_device=  item_granter_device{}
    @editable
    ItemGranter : item_granter_device=  item_granter_device{}
    @editable
    ItemGranter2 : item_granter_device=  item_granter_device{}
    @editable
    ItemGranter3 : item_granter_device=  item_granter_device{}
    @editable
    ItemGranter4 : item_granter_device=  item_granter_device{}
    @editable
    UpgradeGranter : item_granter_device=  item_granter_device{}
    @editable
    UpgradeGranter2 : item_granter_device=  item_granter_device{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=

        ButtonFood1.InteractedWithEvent.Subscribe(GiveRandomFood1)

        ButtonMystery1.InteractedWithEvent.Subscribe(GiveRandomItem)
        ButtonMystery2.InteractedWithEvent.Subscribe(GiveRandomItem)
        # TODO: Replace this with your code
        
        ButtonUpgrade.InteractedWithEvent.Subscribe(GiveRandomUpgrade)
        ButtonUpgrade2.InteractedWithEvent.Subscribe(GiveRandomUpgrade)
        ButtonUpgrade3.InteractedWithEvent.Subscribe(GiveRandomUpgrade)

    GiveRandomFood1(Agent :  agent): void = 
        var RandomInt : int = GetRandomInt(0,20)

        if ( 0 <= RandomInt < 7):
            FoodItemGranter.GrantItem(Agent)
        else if ( 7 <= RandomInt < 14):
            FoodItemGranter2.GrantItem(Agent)
        else if ( 14 <= RandomInt < 20):
            FoodItemGranter3.GrantItem(Agent)
        else if ( RandomInt = 20):
            FoodItemGranter4.GrantItem(Agent)


    GiveRandomItem(Agent :  agent): void = 
        var RandomInt : int = GetRandomInt(0,20)

        if ( 0 <= RandomInt < 7):
            ItemGranter.GrantItem(Agent)
        else if ( 7 <= RandomInt < 14):
            ItemGranter2.GrantItem(Agent)
        else if ( 14 <= RandomInt < 20):
            ItemGranter3.GrantItem(Agent)
        else if ( RandomInt = 20):
            ItemGranter4.GrantItem(Agent)

    GiveRandomUpgrade(Agent :  agent): void = 
        if (ConditionalItemVoting.HasAllItems[Agent]):
            ConditionalItemVoting.Activate(Agent)
            UpgradeGranter.GrantItem(Agent)
        else if (ConditionalItemVoting2.HasAllItems[Agent]):
            ConditionalItemVoting2.Activate(Agent)
            UpgradeGranter2.GrantItem(Agent)
        