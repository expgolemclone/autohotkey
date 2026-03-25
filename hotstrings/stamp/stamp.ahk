#Requires AutoHotkey v2.0

STAMP_DIR := RegExReplace(A_LineFile, "\\[^\\]+$", "")

:*://stamp::{
    global STAMP_DIR
    script := STAMP_DIR "\stamp.py"
    RunWait("python " script,, "Hide")
    Sleep(100)
    Send("^v")
}