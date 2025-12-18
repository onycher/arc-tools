#Requires AutoHotkey v2
#Include ../src/Lib/Overlay.ahk

OutputDebug "Starting Overlay Tests...`n"

try {
    ; T010: Verify Init and Toggle
    Overlay.Init("TestOverlay")
    
    if !Overlay.IsVisible
        throw Error("Overlay should be visible after Init")
    OutputDebug "PASS: Overlay Init`n"

    Overlay.Toggle()
    if Overlay.IsVisible
        throw Error("Overlay should be hidden after Toggle")
    OutputDebug "PASS: Overlay Toggle (Hide)`n"

    Overlay.Toggle()
    if !Overlay.IsVisible
        throw Error("Overlay should be visible after 2nd Toggle")
    OutputDebug "PASS: Overlay Toggle (Show)`n"

    Overlay.UpdateText("Test Passed!")
    OutputDebug "PASS: Text Update`n"

    MsgBox "Overlay Test Passed. You should see a transparent window with 'Test Passed!' text."
    
} catch as e {
    MsgBox "TEST FAILED: " . e.Message
}
