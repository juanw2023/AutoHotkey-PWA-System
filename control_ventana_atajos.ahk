#Requires AutoHotkey v2.0

; ========================================
; CONTROL DE VENTANA DE ATAJOS - TIPO CHATGPT
; ========================================
; Este script controla la ventana de la PWA de atajos
; Permite ocultar/mostrar con el mismo atajo de teclado
; También integra la aplicación de Edge especificada

; Variables globales
atajosWindowTitle := "Atajos"  ; Título de la ventana de la PWA
atajosWindowId := 0
isWindowVisible := true
atajosProcessPath := ""

; ========================================
; CONFIGURACIÓN DE ATAJOS DE TECLADO
; ========================================

; Atajo principal para mostrar/ocultar ventana de atajos (PWA)
; Usa Win+Alt+Space (evita conflicto con ChatGPT)
#Space::TogglePWA("", "Atajos")

; Atajo alternativo con Win+Alt+A
#!a::ToggleAtajosWindow()

; ========================================
; ATAJOS INDIVIDUALES PARA PWAs
; ========================================
; Cada PWA tiene su propio atajo específico

; PWA de Atajos
^!h::TogglePWA("", "Atajos")

; PWA de xAI (tu app Edge)
^!#e::TogglePWA("hambcbdmoijfllbddakfglefcahfejcl", "xAI")
^!#g::TogglePWA("bcmmjkglicliekcndffbfgcfopnidllp", "Google AI Studio")


; Ejemplos de más PWAs (descomenta y ajusta según necesites):
; ^!s::TogglePWA("spotify_id", "Spotify")
; ^!d::TogglePWA("discord_id", "Discord")
; ^!t::TogglePWA("twitter_id", "Twitter")

; ========================================
; FUNCIONES PRINCIPALES
; ========================================

ToggleAtajosWindow() {
    global atajosWindowId, isWindowVisible
    
    ; Buscar la ventana de atajos
    if (!FindAtajosWindow()) {
        ; Si no se encuentra, abrir la PWA
        TogglePWA("", "Atajos")
        Sleep(2000)  ; Esperar a que se abra
        FindAtajosWindow()
    }
    
    if (atajosWindowId != 0) {
        if (isWindowVisible) {
            ; Ocultar ventana
            WinHide(atajosWindowId)
            isWindowVisible := false
        } else {
            ; Mostrar ventana
            WinShow(atajosWindowId)
            WinActivate(atajosWindowId)
            isWindowVisible := true
        }
    }
}

; --------------------
; Helpers de toggle genéricos
; --------------------

ToggleWindowByTitle(winTitle, runCommand) {
    hwnd := WinExist(winTitle)
    if (hwnd) {
        if (WinActive("ahk_id " . hwnd)) {
            WinMinimize(hwnd)
            return
        }
        WinShow(hwnd)
        WinRestore(hwnd)
        WinActivate(hwnd)
        return
    }
    if (runCommand != "") {
        Run(runCommand)
    }
}

ToggleWindowByExe(exeName, runCommand) {
    hwnd := WinExist("ahk_exe " . exeName)
    if (hwnd) {
        if (WinActive("ahk_id " . hwnd)) {
            WinMinimize(hwnd)
            return
        }
        WinShow(hwnd)
        WinRestore(hwnd)
        WinActivate(hwnd)
        return
    }
    if (runCommand != "") {
        Run(runCommand)
    }
}

TogglePWA(pwaId, pwaName) {
    ; Buscar ventana por título de la PWA
    hwnd := WinExist(pwaName)
    
    ; Si no se encuentra por título, buscar por clase de ventana de Edge
    if (hwnd == 0) {
        hwnd := WinExist("ahk_class Chrome_WidgetWin_1")
        ; Verificar si es la ventana correcta buscando en el título
        if (hwnd != 0) {
            currentTitle := WinGetTitle(hwnd)
            if (!InStr(currentTitle, pwaName)) {
                hwnd := 0
            }
        }
    }
    
    if (hwnd) {
        if (WinActive("ahk_id " . hwnd)) {
            WinMinimize(hwnd)
            return
        }
        WinShow(hwnd)
        WinRestore(hwnd)
        WinActivate(hwnd)
        return
    }
    
    ; Si no se encuentra, abrir la PWA
    edgePath := "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    if (!FileExist(edgePath)) {
        edgePath := "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
    }
    
    if (FileExist(edgePath)) {
        if (pwaId != "") {
            ; PWA con ID (app instalada)
            Run(Chr(34) . edgePath . Chr(34) . " --app-id=" . pwaId)
        } else {
            ; PWA desde archivo HTML (como atajos_teclado.html)
            if (pwaName == "Atajos") {
                htmlPath := A_ScriptDir . "\atajos_teclado.html"
                if (FileExist(htmlPath)) {
                    Run(Chr(34) . edgePath . Chr(34) . " --app=" . Chr(34) . htmlPath . Chr(34))
                }
            }
        }
    }
}

FindAtajosWindow() {
    global atajosWindowId, atajosWindowTitle
    
    ; Buscar ventana por título
    atajosWindowId := WinExist(atajosWindowTitle)
    
    ; Si no se encuentra por título, buscar por clase de ventana de Edge
    if (atajosWindowId == 0) {
        atajosWindowId := WinExist("ahk_class Chrome_WidgetWin_1")
        ; Verificar si es la ventana correcta buscando en el título
        if (atajosWindowId != 0) {
            currentTitle := WinGetTitle(atajosWindowId)
            if (!InStr(currentTitle, "Atajos") && !InStr(currentTitle, "atajos_teclado")) {
                atajosWindowId := 0
            }
        }
    }
    
    return (atajosWindowId != 0)
}




; ========================================
; ATAJOS A SUS DESTINOS CORRECTOS
; ========================================
; Usando las URLs/ comandos que dejaste en comentarios

^!1::Run("https://www.google.com/")
^!2::Run("https://www.youtube.com")
#!j::Run("https://python.langchain.com/docs")
^!v::Run("https://www.chatgpt.com")

^!w::Run("https://www.aigoogle.studio.com")
^!e::Run("https://www.explainshell.com")
^!r::Run("https://www.reddit.com")
^!t::Run("https://www.tiktok.com")
^!y::Run("https://www.youtube.com")
^!u::Run("https://www.twitter.com")
^!i::Run("https://www.instagram.com")
^!o::Run("https://www.linkedin.com")
^!p::Run("https://www.pinterest.com")
^!s::Run("https://www.stackoverflow.com")
^!a::Run("https://www.amazon.com")
^!d::Run("https://www.dev.to")
^!f::Run("https://www.facebook.com")
^!g::Run("https://www.github.com")

; Apps con comportamiento toggle (mismo atajo minimiza/restaura)
#j::ToggleWindowByTitle("Warp", '"C:\\Users\\J.J. R\\AppData\\Local\\Programs\\Warp\\warp.exe"')
^!c::ToggleWindowByExe("chrome.exe", '"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe" "https://www.chatgpt.com"')
^!j::ToggleWindowByExe("Cursor.exe", '"C:\\Users\\J.J. R\\AppData\\Local\\Programs\\cursor\\Cursor.exe" "C:\\Users\\J.J. R\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup"')


#Requires AutoHotkey v2.0

; Converted to AutoHotkey v1 (legacy) syntax to avoid #Warn about function-like commands
; SetBatchLines is not needed in AHK v2 and has been removed.

;^!1::Run("https://www.google.com/")
;^!2::Run("https://www.youtube.com")
;#!j::Run("https://python.langchain.com/docs")
;^!v::Run("https://www.chatgpt.com")

;^!w::Run("https://www.aigoogle.studio.com")
;^!e::Run("https://www.explainshell.com")
;^!r::Run("https://www.reddit.com")
;^!t::Run("https://www.tiktok.com")
;^!y::Run("https://www.youtube.com")
;^!u::Run("https://www.twitter.com")
;^!i::Run("https://www.instagram.com")
;^!o::Run("https://www.linkedin.com")
;   ^!p::Run("https://www.pinterest.com")

;^!d::Run("https://www.dev.to")
;^!f::Run("https://www.facebook.com")
;^!g::Run("https://www.github.com")

;#j::Run("C:\Users\J.J. R\AppData\Local\Programs\Warp\warp.exe")
;^!c::Run('"C:\Program Files\Google\Chrome\Application\chrome.exe" "https://www.chatgpt.com"')
;^!j:: {
;	exe := 'C:\Users\J.J. R\AppData\Local\Programs\cursor\Cursor.exe'
;	arg := 'C:\Users\J.J. R\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup'
;	Run(Chr(34) . exe . Chr(34) . ' ' . Chr(34) . arg . Chr(34))
;}
;! #Requires AutoHotkey v2.https://urbania.pe/inmueble/clasificado/alcllcin-alquiler-de-local-comercial-en-lince-lima-147057153https://urbania.pe/inmueble/clasificado/alcllcin-alquiler-de-local-comercial-en-lince-lima-147057153https://urbania.pe/inmueble/clasificado/alcllcin-alquiler-de-local-comercial-en-lince-lima-1470571530

;#!r::Reload  ; recargar script con Ctrl+Win+R (más fiable)


; ========================================
; ATAJOS DE SISTEMA
; ========================================

#!r::Reload  ; recargar script con Win+Alt+R
^Esc::ExitApp

; ========================================
; INICIALIZACIÓN
; ========================================

; Buscar ventana existente al iniciar
SetTimer(CheckAtajosWindow, 5000)  ; Verificar cada 5 segundos

CheckAtajosWindow() {
    global atajosWindowId, isWindowVisible
    
    if (atajosWindowId != 0) {
        ; Verificar si la ventana sigue existiendo
        if (!WinExist(atajosWindowId)) {
            atajosWindowId := 0
            isWindowVisible := true
        }
    }
}
