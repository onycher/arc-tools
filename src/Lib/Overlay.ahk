#Requires AutoHotkey v2

class Overlay {
    static GuiObj := ""
    static IsVisible := false

    /**
     * Initializes the overlay window.
     * @param title Window title (default: "ArcToolsOverlay")
     */
    static Init(title := "ArcToolsOverlay") {
        if (this.GuiObj)
            return

        ; Create GUI
        ; +AlwaysOnTop: Keeps it above game
        ; +ToolWindow: Hides from taskbar
        ; -Caption: Removes title bar/borders
        ; +E0x20: WS_EX_TRANSPARENT (Click-through)
        ; +E0x80000: WS_EX_LAYERED (Required for transparency)
        this.GuiObj := Gui("+AlwaysOnTop +ToolWindow -Caption +E0x20 +E0x80000", title)
        
        ; Set background color and make it transparent
        ; T020: Adjusted transparency for slightly better contrast (220/255)
        this.GuiObj.BackColor := "000000"
        WinSetTransColor("000000 220", this.GuiObj.Hwnd)

        ; Set font style
        ; T020: Increased font size to 14
        this.GuiObj.SetFont("s14 cWhite", "Segoe UI")
        
        ; Add main status text
        this.GuiObj.Add("Text", "vStatusText w300 Center", "Ready - Hover & Ctrl+D to scan")
        
        ; Position top-right or custom
        this.GuiObj.Show("NoActivate x0 y0 w300 h80")
        
        this.IsVisible := true
        OutputDebug "Overlay: Initialized.`n"
    }

    /**
     * Toggles overlay visibility.
     */
    static Toggle() {
        if !this.GuiObj
            return

        if (this.IsVisible) {
            this.GuiObj.Hide()
            this.IsVisible := false
            OutputDebug "Overlay: Hidden.`n"
        } else {
            this.GuiObj.Show("NoActivate")
            this.IsVisible := true
            OutputDebug "Overlay: Shown.`n"
        }
    }

    /**
     * Updates the text content of the overlay.
     * @param text The text to display.
     */
    static UpdateText(text) {
        if !this.GuiObj
            return
            
        try {
            ctrl := this.GuiObj["StatusText"]
            ctrl.Value := text
        } catch {
            OutputDebug "Overlay: Failed to update text.`n"
        }
    }
    


    /**
     * Displays formatted item details on the overlay.
     * @param itemData The item data object from GameData.
     */
    static ShowItem(itemData) {
        if !this.GuiObj
            return

        itemName := itemData["name"]["en"]
        itemValue := itemData.Has("value") ? itemData["value"] : "N/A"
        itemWeight := itemData.Has("weightKg") ? itemData["weightKg"] : "N/A"
        
        displayText := itemName . "`nValue: " . itemValue . " | Wgt: " . itemWeight
        
        if itemData.Has("recipe") {
            recipeStr := ""
            for k, v in itemData["recipe"]
                recipeStr .= k . ": " . v . ", "
            displayText .= "`nRecipe: " . RTrim(recipeStr, ", ")
        }
        
        this.UpdateText(displayText)
    }
}
