#Requires AutoHotkey v2.0


; ============================================================
; PowerShell でフォルダを開くショートカット集
; ============================================================

#Hotstring *

; ============================================================
; ヘルパー関数
; ============================================================

OpenPowerShell(path) {
    ; 管理者権限で動いている場合は一般ユーザー権限に降格してから起動する
    ; runas /trustlevel:0x20000 = 標準ユーザーとして実行
    if A_IsAdmin
        Run('runas /trustlevel:0x20000 "pwsh.exe"', path)
    else
        Run("pwsh.exe", path)
}

; ============================================================
; Win+T: デスクトップで pwsh を開く
; ============================================================
#t:: {
    OpenPowerShell(A_Desktop)
}

; ============================================================
; Desktop 直下
; ============================================================

:*://des:: {
    OpenPowerShell(A_Desktop)
}

:*://memo:: {
    OpenPowerShell(A_Desktop "\memo")
}

:*://mus:: {
    OpenPowerShell(A_Desktop "\music")
}

; ============================================================
; Desktop\local
; ============================================================

:*://loc:: {
    OpenPowerShell(A_Desktop "\local")
}

:*://play:: {
    OpenPowerShell(A_Desktop "\local\playwright")
}

; ============================================================
; Desktop\restart
; ============================================================

:*://res:: {
    OpenPowerShell(A_Desktop "\restart")
}



; ============================================================
; E:\ ドライブ
; ============================================================
:*://e\:: {
    OpenPowerShell("E:\")
}

:*://mei:: {
    OpenPowerShell("E:\meisvy_line")
}

:*://ref:: {
    OpenPowerShell("E:\refactoring\ops5k_x64")
}

:*://sto:: {
    OpenPowerShell("E:\stock")
}

:*://in_mem:: {
    OpenPowerShell("E:\in_memory_data_store")
}

:*://land:: {
    OpenPowerShell("C:\Users\0000250059\Desktop\land_value_research")
}

:*://valky:: {
    OpenPowerShell("E:\wsl-offline")
}

; ============================================================
; 設定・ツール
; ============================================================

:*://.codex:: {
    OpenPowerShell(EnvGet("USERPROFILE") "\.codex")
}

:*://.cl:: {
    OpenPowerShell(EnvGet("USERPROFILE") "\.claude")
}

:*://qute:: {
    OpenPowerShell(EnvGet("APPDATA") "\qutebrowser\config")
}

:*://vim:: {
    OpenPowerShell(EnvGet("LOCALAPPDATA") "\nvim")
}

:*://ahk:: {
    OpenPowerShell("C:\Users\0000250059\Documents\AutoHotkey")
}

:*://pwsh:: {
    OpenPowerShell(EnvGet("USERPROFILE") "\Documents\PowerShell")
}

; ============================================================
; Windows Startup フォルダ
; ============================================================

:*://stae:: {
    OpenPowerShell(EnvGet("USERPROFILE") "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\startup")
}

; ============================================================
; 業務 (日報)
; ============================================================

:*://rep:: {
    y := FormatTime(, "yyyy")
    m := FormatTime(, "M")
    path := "C:\MEIDEN\Box\DA\システム管理課\K-教育訓練\新入社員教育など\20250804_教育資料（藤田充人）\daily_repport\" y "\" m
    ; Box フォルダが無ければ Box を起動して待つ
    if !DirExist(path) {
        Run('"C:\Program Files\Box\Box\Box.exe"')
        ToolTip("Box を起動中...")
        timeout := 60
        loop timeout * 2 {
            if DirExist(path)
                break
            Sleep(500)
        }
        ToolTip()
        if !DirExist(path) {
            ToolTip("Box の起動がタイムアウトしました")
            SetTimer(() => ToolTip(), -3000)
            return
        }
    }
    OpenPowerShell(path)
    d := FormatTime(, "yyyy-MM-dd")
    mdFile := d ".md"
    nvim := EnvGet("LOCALAPPDATA") "\Programs\Neovim\nvim-win64\bin\nvim.exe"
    vimArg := "& '" nvim "' '" mdFile "'"
    if A_IsAdmin
        Run('runas \trustlevel:0x20000 "pwsh.exe -NoExit -Command ' vimArg '"', path)
    else
        Run('pwsh.exe -NoExit -Command "' vimArg '"', path)
}
