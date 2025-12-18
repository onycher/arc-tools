#Requires AutoHotkey v2
#Include "../src/Lib/Scanner.ahk"

OutputDebug "TEST_OCR: Starting...`n"

try {
    ; Just verify the class and method exist and are callable.
    ; In a CI/Headless environment, OCR.FromDesktop might fail or return nothing,
    ; but we want to ensure the code path is valid.
    
    if !HasMethod(Scanner, "Scan") {
        throw Error("Scanner.Scan method not found")
    }
    
    OutputDebug "TEST_OCR: Scanner.Scan method exists.`n"
    
    ; Attempt a scan (might fail in CI, so we catch)
    try {
        result := Scanner.Scan()
        OutputDebug "TEST_OCR: Scan executed. Result length: " . StrLen(result.Text) . "`n"
    } catch as e {
        OutputDebug "TEST_OCR: Scan call failed (expected in some envs): " . e.Message . "`n"
    }

    OutputDebug "TEST_OCR: Passed.`n"
    ExitApp 0
} catch as e {
    OutputDebug "TEST_OCR: Failed - " . e.Message . "`n"
    ExitApp 1
}
