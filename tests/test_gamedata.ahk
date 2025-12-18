#Requires AutoHotkey v2
#Include ../src/Lib/GameData.ahk
#Include ../src/Lib/JSON.ahk

; Mock environment or point to real data
dataDir := A_ScriptDir . "\..\arcraiders-data"

if !DirExist(dataDir) {
    MsgBox "Error: arcraiders-data directory not found at `n" . dataDir
    ExitApp
}

OutputDebug "Starting GameData Tests...`n"

try {
    ; T004: Load Data
    GameData.Load(dataDir)
    
    if (GameData.Items.Count == 0)
        throw Error("GameData.Items is empty!")
    
    OutputDebug "PASS: Data Loading (Count: " . GameData.Items.Count . ")`n"

    ; T005: Fuzzy Matching
    
    ; Test 1: Exact Match (Normalized)
    match := GameData.FindClosestItem("Adrenaline Shot")
    if !IsObject(match) || match["id"] != "adrenaline_shot"
        throw Error("Exact match failed. Expected adrenaline_shot, got " . (IsObject(match) ? match["id"] : "nothing"))
    OutputDebug "PASS: Exact Match`n"

    ; Test 2: Typo Match
    match := GameData.FindClosestItem("Adrenalin Sho") ; Missing 't'
    if !IsObject(match) || match["id"] != "adrenaline_shot"
        throw Error("Fuzzy match 1 failed. Expected adrenaline_shot")
    OutputDebug "PASS: Fuzzy Match (Typo)`n"
    
    ; Test 3: Large difference (Should fail or return best guess if threshold high, but we expect strictish)
    match := GameData.FindClosestItem("Banana", 1) ; High strictness
    if IsObject(match) && match["id"] == "adrenaline_shot"
        throw Error("Negative match failed. 'Banana' matched 'Adrenaline Shot'?")
    OutputDebug "PASS: Negative Match`n"

    MsgBox "All GameData tests passed!`nCheck OutputDebug for details."

} catch as e {
    MsgBox "TEST FAILED: " . e.Message . "`nLine: " . e.Line . "`nFile: " . e.File
}
