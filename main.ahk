#Requires AutoHotkey v2.0
DetectHiddenWindows(true)
SetTitleMatchMode(2)
if !WinExist("keybinds.ahk ahk_class AutoHotkey")
    Run('"' A_ScriptDir '\keybinds.ahk" ' ProcessExist())

logDir := A_ScriptDir "\.log"
if !DirExist(logDir)
    DirCreate(logDir)
logFile := logDir "\error.log"
if FileExist(logFile)
    FileDelete(logFile)
FileAppend("", logFile, "UTF-8-RAW")

scripts := ["hotstrings\stamp\stamp.ahk","hotstrings\snippets.ahk", "hotstrings\vscode-open.ahk", "hotstrings\powershell-open.ahk"]

for _, script in scripts {
    fullPath := A_ScriptDir "\" script
    if !FileExist(fullPath) {
        FileAppend("見つからない: " fullPath "`n", logFile, "UTF-8-RAW")
        continue
    }
    if !WinExist(fullPath " ahk_class AutoHotkey") {
        try {
            Run('"' fullPath '" ' ProcessExist())
        } catch as e {
            FileAppend("起動失敗: " script " - " e.Message "`n", logFile, "UTF-8-RAW")
        }
    }
}

Sleep(10000)

for _, script in scripts {
    fullPath := A_ScriptDir "\" script
    if WinExist(fullPath " ahk_class AutoHotkey")
        FileAppend("起動成功: " script "`n", logFile, "UTF-8-RAW")
    else
        FileAppend("起動後すぐ終了: " script "`n", logFile, "UTF-8-RAW")
}