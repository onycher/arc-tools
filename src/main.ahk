#Requires AutoHotkey v2
#Include Lib/Scanner.ahk
#Include Lib/GameData.ahk
#Include Lib/Overlay.ahk
#Include Lib/Config.ahk

TraySetIcon "shell32.dll", 23 ; Help icon
A_IconTip := "Arc Raiders Tools (AHK v2)"

; Basic startup verification
OutputDebug "Arc Raiders Tools: Main script started.`n"

; Initialize Data
dataDir := A_ScriptDir . "\..\arcraiders-data"
try {
    Config.Load()  ; Load saved configuration
    GameData.Load(dataDir)
    Overlay.Init()
} catch as e {
    MsgBox "Startup Error: " . e.Message
    ExitApp
}

; Save config on exit
OnExit((*) => Config.Save())

; Hotkeys
F12::Overlay.Toggle()  ; Toggle overlay visibility

^d:: {  ; Ctrl+D for Scan and Lookup
    try {
        Overlay.UpdateText("Scanning for tooltip...")
        result := Scanner.Scan()
        scannedText := result.Text
        
        match := GameData.FindClosestItem(scannedText)
        
        if (match) {
            Overlay.ShowItem(match)
        } else {
            ; Show first 30 chars of scanned text to help user understand what went wrong
            Overlay.UpdateText("No match: " . SubStr(scannedText, 1, 30) . (StrLen(scannedText) > 30 ? "..." : ""))
        }
    } catch as e {
        Overlay.UpdateText("Scan Error: " . e.Message)
    }
}

; Keep script running
Persistent
