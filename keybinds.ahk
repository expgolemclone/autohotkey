#Requires AutoHotkey v2.0
if !A_IsAdmin {
    try {
        Run('*RunAs "' A_ScriptFullPath '"')
    } catch as e {
        MsgBox("管理者昇格に失敗:`n" e.Message, "keybinds.ahk", "Icon!")
    }
    ExitApp
}

; main.ahk 監視: 親プロセスが消えたら自身も終了 (PID ベース)
if A_Args.Length {
    _parentPID := A_Args[1]
    _CheckParent() {
        if !ProcessExist(_parentPID)
            ExitApp
    }
    SetTimer(_CheckParent, 5000)
}

; ==========================================
; ヘルパー: F1 と vk1C(変換キー) の両方にバインド
; AHK の & カスタムコンボはリマップを経由しないため両方登録が必要
; ==========================================
RegisterDual(key, action) {
    Hotkey("F1 & " key, action)
    Hotkey("vk1C & " key, action)
}

; ==========================================
; メディアコントロール
; ==========================================
RegisterDual("c", (*) => Send("{Media_Prev}"))
RegisterDual("v", (*) => Send("{Media_Next}"))
; ==========================================
; 音量コントロール
; ==========================================
RegisterDual("g", (*) => Send("{Volume_Up}"))
RegisterDual("b", (*) => Send("{Volume_Down}"))
; ==========================================
; 変換キー + 矢印キー（Vimライク）
; ==========================================
RegisterDual("h", (*) => Send("{Blind}{Left}"))
RegisterDual("j", (*) => Send("{Blind}{Down}"))
RegisterDual("k", (*) => Send("{Blind}{Up}"))
RegisterDual("l", (*) => Send("{Blind}{Right}"))
; ==========================================
; 変換キー + ナビゲーション
; ==========================================
; ctrl+F1+lのみ上手くいかないのはおそらくnote pcのハード的な問題
RegisterDual("n", (*) => Send("{Blind}{Home}"))
RegisterDual("m", (*) => Send("{Blind}{End}"))
RegisterDual("f", (*) => Send("{Blind}{Backspace}"))
RegisterDual("d", (*) => Send("{Blind}{Del}"))
RegisterDual("s", (*) => Send("{Blind}{Esc}"))
RegisterDual("a", (*) => Send("{Blind}{F11}"))
; ==========================================
; 変換キー + 数字
; ==========================================
RegisterDual("q", (*) => Send("{Blind}1"))
RegisterDual("w", (*) => Send("{Blind}2"))
RegisterDual("e", (*) => Send("{Blind}3"))
RegisterDual("r", (*) => Send("{Blind}4"))
RegisterDual("t", (*) => Send("{Blind}5"))
RegisterDual("y", (*) => Send("{Blind}6"))
RegisterDual("u", (*) => Send("{Blind}7"))
RegisterDual("i", (*) => Send("{Blind}8"))
RegisterDual("o", (*) => Send("{Blind}9"))
RegisterDual("p", (*) => Send("{Blind}0"))
RegisterDual("@", (*) => Send("{Blind}-"))
RegisterDual("[", (*) => Send("{Blind}{^}"))
; ==========================================
; その他のキーマッピング
; ==========================================
RegisterDual("2", (*) => Send("{Blind}{F2}"))
RegisterDual("x", (*) => Send("AppsKey"))
RegisterDual("z", (*) => (CoordMode("Mouse", "Screen"), MouseMove(3840, 1080, 0)))

; ==========================================
; 静的ホットキー
; ==========================================
Ctrl & m::Media_Play_Pause
printscreen::Send("{Media_Prev}")
ScrollLock::Send("{Media_Play_Pause}")
Pause::Send("{Media_Next}")
PgUp::Volume_Up
PgDn::Volume_Down
^Space::vk19
vkf0::Enter
^e::Send("!{F4}")
F6::\
F1::return
vk1C::return

; ==========================================
; ウインドウ切り替え
; ==========================================
^Enter:: {
    Send("!{Tab}")
}
#Enter:: {
    Send("!{Esc}")
}

; ==========================================
; 余っているショートカット（F1との組み合わせ）
; ==========================================
;F1 & \
;F1 & Tab
;F1 & space
