#Requires AutoHotkey v2
#Include OCR.ahk

class Scanner {
    ; Template image for finding tooltip location
    static TemplateImage := A_ScriptDir . "\actions.png"
    
    ; Scan area configuration relative to template
    static ScanOffsetX := 0     ; Horizontal offset from template
    static ScanOffsetY := 40    ; Scan starts below the template (actions icons)
    static ScanWidth := 600     ; Width of scan region
    static ScanHeight := 400    ; Height of scan region
    
    /**
     * Scans for text by first finding the tooltip using template matching.
     * Uses the actions.png template to locate the tooltip, then scans the area below it.
     * @returns {OCR.Result} The OCR result object.
     */
    static Scan() {
        try {
            ; T019: Set PerformanceMode to Fast (2) for speedier simple text scanning
            OCR.PerformanceMode := 2
            
            ; Find the tooltip location using template matching
            if (this.FindTemplate(&templateX, &templateY)) {
                ; Calculate scan region below the template (where tooltip text is)
                scanX := templateX + this.ScanOffsetX
                scanY := templateY + this.ScanOffsetY
                scanW := this.ScanWidth
                scanH := this.ScanHeight
                
                ; Ensure scan stays within screen bounds
                screenW := A_ScreenWidth
                screenH := A_ScreenHeight
                
                if (scanX + scanW > screenW)
                    scanW := screenW - scanX
                if (scanY + scanH > screenH)
                    scanH := screenH - scanY
                    
                OutputDebug "Scanner: Template found at (" . templateX . ", " . templateY . "), scanning region (" . scanX . ", " . scanY . ", " . scanW . ", " . scanH . ")`n"
                
                return OCR.FromRect(scanX, scanY, scanW, scanH)
            } else {
                ; Fallback: scan full screen if template not found
                OutputDebug "Scanner: Template not found, falling back to desktop scan`n"
                return this.ScanDesktop()
            }
        } catch as e {
            OutputDebug "Scanner Error: " . e.Message . "`n"
            throw e
        }
    }
    
    /**
     * Finds the template image on screen using ImageSearch.
     * @param foundX Output variable for X coordinate
     * @param foundY Output variable for Y coordinate
     * @returns {Boolean} True if template found, False otherwise
     */
    static FindTemplate(&foundX, &foundY) {
        ; Check if template file exists
        if !FileExist(this.TemplateImage) {
            OutputDebug "Scanner: Template image not found: " . this.TemplateImage . "`n"
            return false
        }
        
        try {
            ; ImageSearch looks for the template image on screen
            ; Variation parameter allows for slight color differences (0-255)
            ; Lower = exact match, higher = more tolerant
            if ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*50 " . this.TemplateImage)
            {
                OutputDebug "Scanner: Template found at (" . foundX . ", " . foundY . ")`n"
                return true
            } else {
                OutputDebug "Scanner: Template not found on screen`n"
                return false
            }
        } catch as e {
            OutputDebug "Scanner: ImageSearch error - " . e.Message . "`n"
            return false
        }
    }
    
    /**
     * Scans the entire desktop for text (fallback mode).
     * @returns {OCR.Result} The OCR result object.
     */
    static ScanDesktop() {
        OutputDebug "Scanner: Scanning full desktop`n"
        return OCR.FromDesktop()
    }
    
    /**
     * Sets the scan area configuration relative to template.
     * @param offsetX Horizontal offset from template (default: 0)
     * @param offsetY Vertical offset from template (default: 40)
     * @param width Width of scan region (default: 600)
     * @param height Height of scan region (default: 400)
     */
    static SetScanArea(offsetX := 0, offsetY := 40, width := 600, height := 400) {
        this.ScanOffsetX := offsetX
        this.ScanOffsetY := offsetY
        this.ScanWidth := width
        this.ScanHeight := height
        OutputDebug "Scanner: Scan area configured - Offset(" . offsetX . ", " . offsetY . "), Size(" . width . "x" . height . ")`n"
    }
}
