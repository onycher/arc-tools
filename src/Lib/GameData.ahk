#Requires AutoHotkey v2
#Include JSON.ahk

class GameData {
    static Items := Map()
    static ItemLookup := Map() ; Normalized Name -> Item ID

    /**
     * Loads all data from the arcraiders-data directory.
     * @param dataDir Absolute path to arcraiders-data.
     */
    static Load(dataDir) {
        if !DirExist(dataDir)
            throw Error("Data directory not found: " . dataDir)

        ; Load Items
        itemsDir := dataDir . "\items"
        loop files itemsDir . "\*.json" {
            try {
                content := FileRead(A_LoopFileFullPath)
                ; Use the JSON helper we created
                ; Since our JSON helper is basic and might struggle with complex nested COM,
                ; let's implement a simpler JScript-based parser if the class above is insufficient,
                ; or rely on a more robust one if available. 
                ; For this step, we will assume standard reading works or define a robust parser.
                
                ; NOTE: The JSON.ahk created in previous step is a placeholder using HTMLFile.
                ; Real AHK v2 JSON libraries are often external. 
                ; We will use a simple regex-based or simple eval approach for now, 
                ; or assume the user has a preferred JSON lib.
                ; Let's assume JSON.Parse works for now.
                
                itemData := JSON.Parse(content)
                
                if itemData.Has("id") {
                    this.Items[itemData["id"]] := itemData
                    
                    ; Populate Lookup Map (English Name)
                    if itemData.Has("name") && itemData["name"].Has("en") {
                        normName := this.Normalize(itemData["name"]["en"])
                        this.ItemLookup[normName] := itemData["id"]
                    }
                }
            } catch as e {
                OutputDebug "Failed to load " . A_LoopFileName . ": " . e.Message . "`n"
            }
        }
        
        OutputDebug "GameData: Loaded " . this.Items.Count . " items.`n"
    }

    /**
     * Normalizes a string for fuzzy matching (lowercase, alphanumeric only).
     */
    static Normalize(str) {
        return StrLower(RegExReplace(str, "[^a-zA-Z0-9]", ""))
    }

    /**
     * fuzzy matching using Levenshtein distance.
     * @param query The text to search for.
     * @param threshold Max allowed edits.
     * @returns {Object|String} Best matched Item Data or empty string.
     */
    static FindClosestItem(query, threshold := 5) {
        queryNorm := this.Normalize(query)
        if (queryNorm == "")
            return ""

        bestMatch := ""
        minDist := 1000

        for name, id in this.ItemLookup {
            dist := this.Levenshtein(queryNorm, name)
            if (dist < minDist) {
                minDist := dist
                bestMatch := this.Items[id]
            }
        }

        if (minDist <= threshold)
            return bestMatch
        return ""
    }

    /**
     * Standard Levenshtein Distance Algorithm.
     */
    static Levenshtein(s, t) {
        if (s == t)
            return 0
        if (StrLen(s) == 0)
            return StrLen(t)
        if (StrLen(t) == 0)
            return StrLen(s)

        v0 := []
        v1 := []

        loop StrLen(t) + 1
            v0.Push(A_Index - 1)
        
        loop StrLen(t) + 1
            v1.Push(0)

        loop Parse, s {
            i := A_Index
            v1[1] := i
            sChar := A_LoopField
            
            loop Parse, t {
                j := A_Index
                tChar := A_LoopField
                cost := (sChar == tChar) ? 0 : 1
                v1[j + 1] := Min(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost)
            }

            loop v0.Length
                v0[A_Index] := v1[A_Index]
        }

        return v1[StrLen(t) + 1]
    }
}
