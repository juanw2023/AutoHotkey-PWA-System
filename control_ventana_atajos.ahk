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

; Atajo principal para mostrar/ocultar ventana de atajos
; Usa Win+Alt+Space (evita conflicto con ChatGPT)
#!Space::ToggleAtajosWindow()

; Atajo alternativo con Win+Alt+A
#!a::ToggleAtajosWindow()

; Atajo para abrir la aplicación de Edge específica
^!#e::OpenEdgeApp()

; Atajo para abrir la PWA de atajos si no está abierta
^!h::OpenAtajosPWA()

; ========================================
; FUNCIONES PRINCIPALES
; ========================================

ToggleAtajosWindow() {
    global atajosWindowId, isWindowVisible
    
    ; Buscar la ventana de atajos
    if (!FindAtajosWindow()) {
        ; Si no se encuentra, abrir la PWA
        OpenAtajosPWA()
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

OpenAtajosPWA() {
    ; Ruta al archivo HTML
    htmlPath := A_ScriptDir . "\atajos_teclado.html"
    
    ; Verificar si el archivo existe
    if (!FileExist(htmlPath)) {
        return
    }
    
    ; Abrir con Edge en modo aplicación
    edgePath := "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    if (!FileExist(edgePath)) {
        edgePath := "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
    }
    
    if (FileExist(edgePath)) {
        ; Abrir como PWA
        Run(Chr(34) . edgePath . Chr(34) . " --app=" . Chr(34) . htmlPath . Chr(34))
    } else {
        ; Fallback: abrir con navegador por defecto
        Run(htmlPath)
    }
}

OpenEdgeApp() {
    ; Abrir la aplicación de Edge específica
    ; ID: hambcbdmoijfllbddakfglefcahfejcl
    edgePath := "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    if (!FileExist(edgePath)) {
        edgePath := "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
    }
    
    if (FileExist(edgePath)) {
        ; Abrir aplicación específica de Edge
        Run(Chr(34) . edgePath . Chr(34) . " --app-id=hambcbdmoijfllbddakfglefcahfejcl")
    }
}



; ========================================
; ATAJOS CON COMPORTAMIENTO TIPO CHATGPT
; ========================================
; Todos los atajos ahora muestran/ocultan la ventana de atajos

^!1::ToggleAtajosWindow()
^!2::ToggleAtajosWindow()
#!j::ToggleAtajosWindow()
^!v::ToggleAtajosWindow()

^!w::ToggleAtajosWindow()
^!e::ToggleAtajosWindow()
^!r::ToggleAtajosWindow()
^!t::ToggleAtajosWindow()
^!y::ToggleAtajosWindow()
^!u::ToggleAtajosWindow()
^!i::ToggleAtajosWindow()
^!o::ToggleAtajosWindow()
^!p::ToggleAtajosWindow()
^!s::ToggleAtajosWindow()
^!a::ToggleAtajosWindow()
^!d::ToggleAtajosWindow()
^!f::ToggleAtajosWindow()
^!g::ToggleAtajosWindow()

#j::ToggleAtajosWindow()
^!c::ToggleAtajosWindow()
^!j::ToggleAtajosWindow()

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
