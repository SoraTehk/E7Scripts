#Requires AutoHotkey v2.0

CoordMode("Mouse", "Screen")

windowTitle    := "Epic Seven"
loopIntervalMs := 36000  ; Pause between end of one cycle and start of next

; [relX, relY, delayMs]
clicks := [
    [0.02,  0.95,   1000], ; Clear completed UI
    [0.02,  0.95,   2000], ; Back to Abyss

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

; --- OSD (click-through, non-blocking) ---
osd := Gui("-Caption +ToolWindow +AlwaysOnTop")
osd.BackColor := "202020"
osd.SetFont("s10 Bold", "Segoe UI")
osdLabel := osd.AddText("w130 Center", "")
osd.Show("NoActivate w144 h32")
WinSetTransparent(210, osd)
WinSetExStyle("+0x20", osd)  ; WS_EX_TRANSPARENT — passes all clicks through
UpdateOSD()
AnchorOSD()
SetTimer(AnchorOSD, 500)

F3::ToggleLoop()
F9::ExitApp()

ToggleLoop() {
    global running
    running := !running
    UpdateOSD()
    if running
        DoClicks()
    else
        SetTimer(DoClicks, 0)  ; Cancel any pending next cycle
}

; Sleep in small chunks so toggling off takes effect within ~50ms
InterruptibleSleep(ms) {
    global running
    loop Max(1, ms // 50) {
        if !running
            return
        Sleep(Min(50, ms))
        ms -= 50
    }
}

UpdateOSD() {
    global running, osdLabel
    if running {
        osdLabel.SetFont("cLime")
        osdLabel.Value := "● Abyss: Running"
    } else {
        osdLabel.SetFont("c707070")
        osdLabel.Value := "● Abyss: Stopped"
    }
}

AnchorOSD() {
    global windowTitle, osd
    if WinExist(windowTitle) {
        WinGetClientPos(&wx, &wy)  ; uses last found window
        osd.Move(wx + 10, wy + 10)
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
            InterruptibleSleep(pos[3])
        }
    }

    if running
        SetTimer(DoClicks, -loopIntervalMs)  ; Negative = fire once after delay
}
