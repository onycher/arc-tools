#Requires AutoHotkey v2

/**
 * Basic JSON Parser using Windows HTMLFile COM Object (JScript)
 * Suitable for parsing standard JSON files.
 */
class JSON {
    /**
     * Parses a JSON string into an AHK Map or Array.
     * @param str The JSON string to parse.
     * @returns {Map|Array|String|Number|Null} The AHK equivalent object.
     */
    static Parse(str) {
        static html := "", js := ""
        if !html {
            html := ComObject("HTMLFile")
            html.write('<meta http-equiv="X-UA-Compatible" content="IE=9">')
            js := html.parentWindow
        }
        
        try {
            ; Evaluate the JSON string safely
            jsonObj := js.eval("(" . str . ")")
            return this._ToAHK(jsonObj)
        } catch as e {
            throw Error("JSON Parse Error: " e.message)
        }
    }

    /**
     * Internal method to convert JScript objects to AHK objects.
     */
    static _ToAHK(jsObj) {
        if !IsObject(jsObj)
            return jsObj
            
        ; Check if it's an array
        try isArray := jsObj.constructor.toString().indexOf("Array") != -1
        catch
            isArray := false
            
        if isArray {
            arr := []
            loop jsObj.length
                arr.Push(this._ToAHK(jsObj.%A_Index-1%))
            return arr
        } else {
            ; Assume it's an object/map
            mapObj := Map()
            try {
                keys := jsObj.keys ? jsObj.keys() : [] ; Helper if defined, else iterate
                ; JScript for-in loop simulation in AHK is tricky with COM, 
                ; but standard Dispatch objects can often be enumerated.
                for key in jsObj
                    mapObj[key] := this._ToAHK(jsObj.%key%)
            } catch {
                ; Fallback for some COM objects
                return jsObj
            }
            return mapObj
        }
    }
}
