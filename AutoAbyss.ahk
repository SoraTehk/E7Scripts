#Requires AutoHotkey v2.0

CoordMode("Mouse", "Screen")

windowTitle    := "Epic Seven"
loopIntervalMs := 36000  ; Pause between end of one cycle and start of next

; [relX, relY, delayMs]
clicks := [
    [0.04,  0.95,   1000], ; Clear completed UI
    [0.04,  0.95,   2000], ; Back to Abyss
    [0.74,  0.25,   100], ; 18
    [0.74,  0.25,   100], ; 16
    [0.74,  0.25,   100], ; 14
    [0.74,  0.25,   100], ; 12
    [0.74,  0.25,   100], ; 10
    [0.74,  0.25,   100], ; 8
    [0.74,  0.25,   100], ; 6
    [0.74,  0.25,   100], ; 4
    [0.74,  0.25,   100], ; 2
    
    ;[0.74,  0.43,   100], ; 3
    ;[0.74,  0.43,   100], ; 2
    
    [0.74,  0.43,   100], ; 1
    [0.878, 0.94,  2000], ; Replay
    [0.878, 0.94,  300], ; Start
    [0.55,  0.7,   300], ; Replay confirm
    [0.55,  0.7,   300], ; Replay confirm (extra)
]

running := false

F3::ToggleLoop()
F9::ExitApp()

; --- OSD (click-through, non-blocking) ---
osd := Gui("-Caption +ToolWindow +AlwaysOnTop")
osd.BackColor := "202020"
osd.SetFont("s10 Bold", "Segoe UI")
osdLabel := osd.AddText("w130 Center", "")
osd.Show("NoActivate x10 y10 w130 h28")
WinSetTransparent(210, osd)
WinSetExStyle("+0x20", osd)  ; WS_EX_TRANSPARENT — passes all clicks through

ToggleLoop() {
    global running, osdLabel
    running := !running

    if running {
        DoClicks()
        osdLabel.SetFont("cLime")
        osdLabel.Value := "● Abyss: Running"
    }
    else {
        SetTimer(DoClicks, 0)  ; Cancel any pending next cycle
        osdLabel.SetFont("c707070")
        osdLabel.Value := "● Abyss: Stopped"
    }
}

DoClicks() {
    global windowTitle, clicks, running, loopIntervalMs

    win := WinExist(windowTitle)
    if win {
        WinGetClientPos(&winX, &winY, &winW, &winH, win)

        for pos in clicks {
            if !running
                return
            clickX := winX + (pos[1] * winW)
            clickY := winY + (pos[2] * winH)
            Click(clickX, clickY)
            Sleep(pos[3])
        }
    }

    if running
        SetTimer(DoClicks, -loopIntervalMs)  ; Negative = fire once after delay
}
