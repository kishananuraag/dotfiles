#Requires AutoHotkey v2.0
#SingleInstance Force

SetCapsLockState("AlwaysOff")

; ── CapsLock remaps ──────────────────────────────────────────
; Tap alone → Escape
CapsLock::Send("{Escape}")

; Hold + hjkl → arrow keys
CapsLock & h::Send("{Left}")
CapsLock & j::Send("{Down}")
CapsLock & k::Send("{Up}")
CapsLock & l::Send("{Right}")

; Hold + Enter → toggle real CapsLock on/off
CapsLock & Enter::
{
    if GetKeyState("CapsLock", "T") {
        SetCapsLockState("AlwaysOff")
        ToolTip("CapsLock OFF")
    } else {
        SetCapsLockState("AlwaysOn")
        ToolTip("CapsLock ON")
    }
    SetTimer(() => ToolTip(), -1500)
}

; Workspace switching handled by GlazeWM directly (alt+1-6)

; ── ctrl+shift+g → toggle GlazeWM on/off ────────────────────
^+g::
{
    if ProcessExist("glazewm.exe") {
        ProcessClose("glazewm.exe")
        ToolTip("GlazeWM OFF")
    } else {
        Run('"C:\Program Files\glzr.io\GlazeWM\glazewm.exe"')
        ToolTip("GlazeWM ON")
    }
    SetTimer(() => ToolTip(), -1500)
}
