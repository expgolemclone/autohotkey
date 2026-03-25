#Requires AutoHotkey v2.0

; ============================================================
; AUTO-GENERATED from powershell-open.ahk - 編集禁止
; VSCode でフォルダ/ファイルを開くショートカット集
; ============================================================

#Hotstring *

; ============================================================
; ヘルパー関数
; ============================================================

OpenInVSCode(path) {
    code := EnvGet("LOCALAPPDATA") '\Programs\Microsoft VS Code\bin\code.cmd'
    cmd := '"' code '" "' path '"'
    if A_IsAdmin
        Run('runas /trustlevel:0x20000 "' cmd '"',, "Hide")
    else
        Run(cmd,, "Hide")
}

; ============================================================
; Desktop 直下
; ============================================================

:*://vdes:: {
    OpenInVSCode(A_Desktop)
}

:*://vmemo:: {
    OpenInVSCode(A_Desktop "\memo")
}

:*://vmus:: {
    OpenInVSCode(A_Desktop "\music")
}

; ============================================================
; Desktop\local
; ============================================================

:*://vloc:: {
    OpenInVSCode(A_Desktop "\local")
}

:*://vplay:: {
    OpenInVSCode(A_Desktop "\local\playwright")
}

; ============================================================
; Desktop\restart
; ============================================================

:*://vres:: {
    OpenInVSCode(A_Desktop "\restart")
}



; ============================================================
; E:\ ドライブ
; ============================================================
:*://ve\:: {
    OpenInVSCode("E:\")
}

:*://vmei:: {
    OpenInVSCode("E:\meisvy_line")
}

:*://vref:: {
    OpenInVSCode("E:\refactoring\ops5k_x64")
}

:*://vsto:: {
    OpenInVSCode("E:\stock")
}

:*://vin_mem:: {
    OpenInVSCode("E:\in_memory_data_store")
}

:*://vland:: {
    OpenInVSCode("C:\Users\0000250059\Desktop\land_value_research")
}

:*://vvalky:: {
    OpenInVSCode("E:\wsl-offline")
}

; ============================================================
; 設定・ツール
; ============================================================

:*://v.codex:: {
    OpenInVSCode(EnvGet("USERPROFILE") "\.codex")
}

:*://v.cl:: {
    OpenInVSCode(EnvGet("USERPROFILE") "\.claude")
}

:*://vqute:: {
    OpenInVSCode(EnvGet("APPDATA") "\qutebrowser\config")
}

:*://vvim:: {
    OpenInVSCode(EnvGet("LOCALAPPDATA") "\nvim")
}

:*://vahk:: {
    OpenInVSCode("C:\Users\0000250059\Documents\AutoHotkey")
}

:*://vpwsh:: {
    OpenInVSCode(EnvGet("USERPROFILE") "\Documents\PowerShell")
}

; ============================================================
; Windows Startup フォルダ
; ============================================================

:*://vstae:: {
    SendInput("shell:startup{Enter}")
}

; ============================================================
; 業務 (日報)
; ============================================================

:*://vrep:: {
    y := FormatTime(, "yyyy")
    m := FormatTime(, "M")
    d := FormatTime(, "yyyy-MM-dd")
    path := "C:\MEIDEN\Box\DA\システム管理課\K-教育訓練\新入社員教育など\20250804_教育資料（藤田充人）\daily_repport\" y "\" m ""
    OpenInVSCode(path)
}
