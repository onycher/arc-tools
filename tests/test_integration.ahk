#Requires AutoHotkey v2
#Include "../src/Lib/GameData.ahk"
#Include "../src/Lib/Overlay.ahk"

OutputDebug "TEST_INTEGRATION: Starting...`n"

try {
    ; 1. Load Data
    dataDir := A_ScriptDir . "\..\arcraiders-data"
    GameData.Load(dataDir)
    OutputDebug "TEST_INTEGRATION: GameData Loaded.`n"

    ; 2. Init Overlay
    Overlay.Init("TestOverlay")
    OutputDebug "TEST_INTEGRATION: Overlay Initialized.`n"

    ; 3. Find Item with typo (Fuzzy Match Test)
    ; "Adrenalin Shot" is missing an 'e'
    match := GameData.FindClosestItem("Adrenalin Shot")
    
    if !match {
        throw Error("Failed to find 'Adrenaline Shot' via fuzzy match")
    }
    OutputDebug "TEST_INTEGRATION: Found Item: " . match["name"]["en"] . "`n"

    ; 4. Display Item (Verify no crash)
    Overlay.ShowItem(match)
    OutputDebug "TEST_INTEGRATION: Item Displayed on Overlay.`n"

    ; Brief sleep to simulate viewing (optional in headless but good for local check)
    Sleep 100

    OutputDebug "TEST_INTEGRATION: Passed.`n"
    ExitApp 0

} catch as e {
    OutputDebug "TEST_INTEGRATION: Failed - " . e.Message . "`n"
    ExitApp 1
}
