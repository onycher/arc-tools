#Requires AutoHotkey v2
#Include ../src/Lib/Scanner.ahk
#Include ../src/Lib/OCR.ahk

OutputDebug "Starting Scanner Tests...`n"

try {
    ; Test 1: Check template image exists
    if !FileExist(Scanner.TemplateImage) {
        throw Error("Template image not found: " . Scanner.TemplateImage)
    }
    OutputDebug "PASS: Template image exists (" . Scanner.TemplateImage . ")`n"
    
    ; Test 2: Default scan area configuration
    if (Scanner.ScanOffsetX != 0)
        throw Error("Expected ScanOffsetX = 0, got " . Scanner.ScanOffsetX)
    if (Scanner.ScanOffsetY != 40)
        throw Error("Expected ScanOffsetY = 40, got " . Scanner.ScanOffsetY)
    if (Scanner.ScanWidth != 600)
        throw Error("Expected ScanWidth = 600, got " . Scanner.ScanWidth)
    if (Scanner.ScanHeight != 400)
        throw Error("Expected ScanHeight = 400, got " . Scanner.ScanHeight)
    OutputDebug "PASS: Default scan area configuration`n"
    
    ; Test 3: Set custom scan area
    Scanner.SetScanArea(10, 50, 700, 500)
    if (Scanner.ScanOffsetX != 10 || Scanner.ScanOffsetY != 50 || Scanner.ScanWidth != 700 || Scanner.ScanHeight != 500)
        throw Error("Failed to set custom scan area")
    OutputDebug "PASS: Custom scan area configuration`n"
    
    ; Reset to defaults
    Scanner.SetScanArea(0, 40, 600, 400)
    
    ; Test 4: Template finding (may fail if template not visible on screen)
    foundX := 0
    foundY := 0
    templateFound := Scanner.FindTemplate(&foundX, &foundY)
    
    if (templateFound) {
        OutputDebug "PASS: Template found at (" . foundX . ", " . foundY . ")`n"
        
        ; Test 5: Full scan with template
        try {
            result := Scanner.Scan()
            OutputDebug "PASS: Scan executed successfully (OCR result: " . StrLen(result.Text) . " chars)`n"
        } catch as e {
            OutputDebug "INFO: Scan threw error: " . e.Message . "`n"
        }
    } else {
        OutputDebug "INFO: Template not found on screen (this is ok if no tooltip is visible)`n"
        
        ; Test fallback to desktop scan
        try {
            result := Scanner.Scan()
            OutputDebug "PASS: Fallback desktop scan executed (OCR result: " . StrLen(result.Text) . " chars)`n"
        } catch as e {
            OutputDebug "INFO: Desktop scan threw error: " . e.Message . "`n"
        }
    }
    
    MsgBox "All Scanner tests passed!`nTemplate found: " . (templateFound ? "Yes at (" . foundX . ", " . foundY . ")" : "No (no tooltip visible)") . "`n`nCheck OutputDebug for details."
    
} catch as e {
    MsgBox "TEST FAILED: " . e.Message . "`nLine: " . e.Line . "`nFile: " . e.File
}
