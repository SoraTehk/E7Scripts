#Requires AutoHotkey v2.0

CoordMode("Mouse", "Screen")

windowTitle    := "Epic Seven"
loopIntervalMs := 50000  ; Pause between end of one cycle and start of next

; [relX, relY, delayMs]
clicks := [
    [0.04,  0.95,   1000], ; Clear completed UI
    [0.04,  0.95,   3000], ; Back to Abyss
    [0.74,  0.25,   200], ; 18
    [0.74,  0.25,   200], ; 16
    [0.74,  0.25,   200], ; 14
    [0.74,  0.25,   200], ; 12
    [0.74,  0.25,   200], ; 10
    [0.74,  0.25,   200], ; 8
    [0.74,  0.25,   200], ; 6
    [0.74,  0.25,   200], ; 4
    [0.74,  0.43,   200], ; 3
    ;[0.74,  0.43,   200], ; 2
    ;[0.74,  0.43,   200], ; 1
    [0.878, 0.94,  3000], ; Replay
    [0.878, 0.94,  1000], ; Start
    [0.55,  0.7,   1000], ; Replay confirm
    [0.55,  0.7,   1000], ; Replay confirm (extra)
]

running := false

F3::ToggleLoop()
F9::ExitApp()

ToggleLoop() {
    global running
    running := !running
    if running
        DoClicks()
    else
        SetTimer(DoClicks, 0)  ; Cancel any pending next cycle
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