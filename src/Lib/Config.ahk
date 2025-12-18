#Requires AutoHotkey v2

/**
 * Configuration manager for Arc Raiders Tools.
 * Handles loading and saving user preferences.
 */
class Config {
    static ConfigFile := A_ScriptDir . "\config.ini"
    
    /**
     * Loads configuration from file.
     * Creates default config if file doesn't exist.
     */
    static Load() {
        ; Check if config file exists
        if !FileExist(this.ConfigFile) {
            OutputDebug "Config: No config file found, creating default`n"
            this.CreateDefault()
            return
        }
        
        try {
            ; Load Scanner scan area settings
            Scanner.ScanOffsetX := Integer(IniRead(this.ConfigFile, "Scanner", "ScanOffsetX", "0"))
            Scanner.ScanOffsetY := Integer(IniRead(this.ConfigFile, "Scanner", "ScanOffsetY", "40"))
            Scanner.ScanWidth := Integer(IniRead(this.ConfigFile, "Scanner", "ScanWidth", "600"))
            Scanner.ScanHeight := Integer(IniRead(this.ConfigFile, "Scanner", "ScanHeight", "400"))
            
            OutputDebug "Config: Loaded - Scan area: Offset(" . Scanner.ScanOffsetX . ", " . Scanner.ScanOffsetY . "), Size(" . Scanner.ScanWidth . "x" . Scanner.ScanHeight . ")`n"
        } catch as e {
            OutputDebug "Config: Load error - " . e.Message . "`n"
            this.CreateDefault()
        }
    }
    
    /**
     * Saves current configuration to file.
     */
    static Save() {
        try {
            ; Save Scanner scan area settings
            IniWrite(Scanner.ScanOffsetX, this.ConfigFile, "Scanner", "ScanOffsetX")
            IniWrite(Scanner.ScanOffsetY, this.ConfigFile, "Scanner", "ScanOffsetY")
            IniWrite(Scanner.ScanWidth, this.ConfigFile, "Scanner", "ScanWidth")
            IniWrite(Scanner.ScanHeight, this.ConfigFile, "Scanner", "ScanHeight")
            
            OutputDebug "Config: Saved - Scan area: Offset(" . Scanner.ScanOffsetX . ", " . Scanner.ScanOffsetY . "), Size(" . Scanner.ScanWidth . "x" . Scanner.ScanHeight . ")`n"
        } catch as e {
            OutputDebug "Config: Save error - " . e.Message . "`n"
        }
    }
    
    /**
     * Creates a default configuration file.
     */
    static CreateDefault() {
        try {
            IniWrite("0", this.ConfigFile, "Scanner", "ScanOffsetX")
            IniWrite("40", this.ConfigFile, "Scanner", "ScanOffsetY")
            IniWrite("600", this.ConfigFile, "Scanner", "ScanWidth")
            IniWrite("400", this.ConfigFile, "Scanner", "ScanHeight")
            
            OutputDebug "Config: Default config created`n"
        } catch as e {
            OutputDebug "Config: Create default error - " . e.Message . "`n"
        }
    }
    
    /**
     * Resets configuration to defaults.
     */
    static Reset() {
        try {
            if FileExist(this.ConfigFile)
                FileDelete(this.ConfigFile)
            this.CreateDefault()
            this.Load()
            OutputDebug "Config: Reset to defaults`n"
        } catch as e {
            OutputDebug "Config: Reset error - " . e.Message . "`n"
        }
    }
}
