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

; Atajo para abrir el entorno: abre la carpeta de Startup y lanza atajos_teclado.html en Edge si existe
#!e::OpenEntorno()

; ========================================
; ATAJOS INDIVIDUALES PARA PWAs
; ========================================
; Cada PWA tiene su propio atajo específico

; PWA de Atajos


; PWA de xAI (tu app Edge)
^!#e::TogglePWA("ggjocahimgaohmigbfhghnlfcnjemagj", "grok")
^!#g::TogglePWA("bcmmjkglicliekcndffbfgcfopnidllp", "Google AI Studio")
^!#m::TogglePWA("mnhkaebcjjhencmpkapnbdaogjamfbcj", "Google Maps")



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
                ; Buscar el archivo atajos_teclado.html en rutas probables
                candidates := [
                    A_ScriptDir . "\\atajos_teclado.html",
                    A_Desktop . "\\atajos_teclado.html",
                    A_MyDocuments . "\\Startup_backup\\atajos_teclado.html",
                    "D:\\carpeta_de_arranque\\atajos_teclado.html"
                ]
                htmlPath := ""
                for _, p in candidates {
                    if (FileExist(p)) {
                        htmlPath := p
                        break
                    }
                }
                if (htmlPath != "") {
                    Run(Chr(34) . edgePath . Chr(34) . " --app=" . Chr(34) . htmlPath . Chr(34))
                } else {
                    MsgBox("No se encontró atajos_teclado.html en rutas probables. Comprueba dónde lo moviste y actualiza el script. Rutas probadas:" . "\n" . candidates[1] . "\n" . candidates[2] . "\n" . candidates[3] . "\n" . candidates[4])
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

^!w::Run("https://aistudio.google.com/prompts/new_chat")
^!e::Run("https://www.explainshell.com")
^!t::Run("https://www.tiktok.com")
^!y::Run("https://www.youtube.com")
^!i::Run("https://www.instagram.com")
^!o::Run("https://www.linkedin.com")
^!p::Run("https://www.pinterest.com")
^!a::Run("https://www.amazon.com")
^!f::Run("https://www.facebook.com")
^!g::Run("https://www.github.com")
^!u::Run("https://manus.im/app")
#^!a::Run("https://www.alibaba.com")

; Apps con comportamiento toggle (mismo atajo minimiza/restaura)
#j::RunElevated("C:\\Users\\J.J. R\\AppData\\Local\\Programs\\Warp\\warp.exe")
^!c::ToggleWindowByExe("chrome.exe", '"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe" "https://www.chatgpt.com"')
^!j::ToggleWindowByExe("Cursor.exe", '"C:\\Users\\J.J. R\\AppData\\Local\\Programs\\cursor\\Cursor.exe" "C:\\Users\\J.J. R\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\control_ventana_atajos.ahk"')

; ========================================
; SSH REMOTO EN VS CODE (Host: mi-vm-gcp)
; Atajo: Ctrl+Alt+Win+S  -> abre nueva ventana VS Code conectada por SSH
; Requiere que la extensión Remote - SSH esté instalada y que 'mi-vm-gcp' exista en ~/.ssh/config
^!#s::OpenVSCodeSSH()

OpenVSCodeSSH() {
    ; Intenta localizar Code.exe (similar a OpenEntorno)
    userProfile := EnvGet('USERPROFILE')
    possibleCode := [
        userProfile . "\\AppData\\Local\\Programs\\Microsoft VS Code\\Code.exe",
        "C:\\Program Files\\Microsoft VS Code\\Code.exe",
        "C:\\Program Files (x86)\\Microsoft VS Code\\Code.exe"
    ]
    codeExe := ""
    for _, p in possibleCode {
        if (FileExist(p)) {
            codeExe := p
            break
        }
    }
    remoteTarget := "vscode-remote://ssh-remote+mi-vm-gcp/"  ; raíz del host; ajusta para carpeta: .../home/root/proyecto
    if (codeExe != "") {
        ; Ejecutar VS Code con elevación
        RunElevated(codeExe, "--new-window " . remoteTarget)
        return
    }
    ; Fallback: usar 'code' en PATH con elevación (menos fiable si code.cmd abre otra ventana)
    try {
        RunElevated('cmd.exe', '/C code --new-window ' . remoteTarget)
    } catch {
        MsgBox("No se encontró VS Code. Instala VS Code o ajusta la ruta en OpenVSCodeSSH().")
    }
}



#m::SendInput("912885471")
#o::SendInput("wongcaverojuaneduardo785@gmail.com")

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

; Función para abrir el entorno: prioriza abrir la carpeta del script en VS Code; si no, Edge PWA; si no, Explorer
OpenEntorno() {
    ; Ruta real de la carpeta Startup del usuario
    startupPath := "C:\\Users\\J.J. R\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup"
    scriptDir := A_ScriptDir

    ; Intentar rutas comunes de Visual Studio Code (instalación por usuario o sistema)
    userProfile := EnvGet('USERPROFILE')
    possibleCode := [
        userProfile . "\\AppData\\Local\\Programs\\Microsoft VS Code\\Code.exe",
        "C:\\Program Files\\Microsoft VS Code\\Code.exe",
        "C:\\Program Files (x86)\\Microsoft VS Code\\Code.exe",
        "C:\\Program Files\\Microsoft VS Code\\bin\\code.cmd",
        "C:\\Program Files (x86)\\Microsoft VS Code\\bin\\code.cmd"
    ]
    for _, p in possibleCode {
        if (FileExist(p)) {
            RunElevated(p, '"' . scriptDir . '"')
            return
        }
    }

    ; Intentar 'code' en PATH (si el comando está disponible)
    try {
        RunElevated('cmd.exe', '/C code "' . scriptDir . '"')
        return
    } catch {
        ; si falla, seguir a siguientes opciones
    }

    ; Si no hay VS Code, intentar abrir atajos_teclado.html en Edge como PWA
    htmlCandidates := [scriptDir . "\\atajos_teclado.html", A_Desktop . "\\atajos_teclado.html"]
    htmlPath := ""
    for _, p in htmlCandidates {
        if (FileExist(p)) {
            htmlPath := p
            break
        }
    }

    edgePath := "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe"
    if (!FileExist(edgePath)) {
        edgePath := "C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe"
    }

    if (htmlPath != "" && FileExist(edgePath)) {
        RunElevated(edgePath, '--app=' . Chr(34) . htmlPath . Chr(34))
        return
    }

    ; Fallback: abrir la carpeta en el Explorador con elevación
    RunElevated('explorer.exe', Chr(34) . startupPath . Chr(34))
}

; Helper para ejecutar un programa con elevación (request UAC)
RunElevated(exePath, params := "") {
    ; Usa ShellExecuteW (Shell32) con verbo 'runas' para solicitar elevación (UAC)
    ; ShellExecuteW(hwnd, lpOperation, lpFile, lpParameters, lpDirectory, nShowCmd)
    op := StrPtr("runas")
    filePtr := StrPtr(exePath)
    paramsPtr := (params != "") ? StrPtr(params) : 0
    dirPtr := 0
    ; nShowCmd = 1 (SW_SHOWNORMAL)
    DllCall("Shell32.dll\ShellExecuteW", "ptr", 0, "ptr", op, "ptr", filePtr, "ptr", paramsPtr, "ptr", dirPtr, "int", 1)
}
