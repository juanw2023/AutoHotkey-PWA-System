#Requires AutoHotkey v2.0

; Converted to AutoHotkey v1 (legacy) syntax to avoid #Warn about function-like commands
; SetBatchLines is not needed in AHK v2 and has been removed.

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

#j::Run("C:\Users\J.J. R\AppData\Local\Programs\Warp\warp.exe")
^!c::Run('"C:\Program Files\Google\Chrome\Application\chrome.exe" "https://www.chatgpt.com"')
^!j:: {
	exe := 'C:\Users\J.J. R\AppData\Local\Programs\cursor\Cursor.exe'
	arg := 'C:\Users\J.J. R\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup'
	Run(Chr(34) . exe . Chr(34) . ' ' . Chr(34) . arg . Chr(34))
}
;! #Requires AutoHotkey v2.https://urbania.pe/inmueble/clasificado/alcllcin-alquiler-de-local-comercial-en-lince-lima-147057153https://urbania.pe/inmueble/clasificado/alcllcin-alquiler-de-local-comercial-en-lince-lima-147057153https://urbania.pe/inmueble/clasificado/alcllcin-alquiler-de-local-comercial-en-lince-lima-1470571530

#!r::Reload  ; recargar script con Ctrl+Win+R (más fiable)
^Esc::ExitApp
