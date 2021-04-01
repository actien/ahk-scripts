#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Hotkey Reference
; ----------------
; # = Windows
; ! = Alt
; ^ = Ctrl
; + = Shift

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Return Active Window's Monitor Areas
getCurrentMonitorAreas(ByRef areaLeft, ByRef areaRight, ByRef areaTop, ByRef areaBottom) {
    SysGet, monitors, MonitorCount
    Loop, %monitors% {
        WinGetPos, x, y, w, h, A
        SysGet, m, Monitor, %A_Index%
        if (mLeft <= (x + (w/3)) && (x + (w/3)) < mRight) {
            SysGet, workArea, MonitorWorkArea, %A_Index%
            areaLeft := workAreaLeft
            areaRight := workAreaRight
            areaTop := workAreaTop
            areaBottom := workAreaBottom
        }
    }
}

;; Return Active Window's Next Monitor Areas
getNextMonitorAreas(ByRef areaLeft, ByRef areaRight, ByRef areaTop, ByRef areaBottom) {
    SysGet, monitors, MonitorCount
    Loop, %monitors% {
        WinGetPos, x, y, w, h, A
        SysGet, m, Monitor, %A_Index%
        if (mLeft <= (x + (w/3)) && (x + (w/3)) < mRight) {
            nextMonitor := Mod(A_Index+1, monitors)
            SysGet, workArea, MonitorWorkArea, %nextMonitor%
            areaLeft := workAreaLeft
            areaRight := workAreaRight
            areaTop := workAreaTop
            areaBottom := workAreaBottom
        }
    }
}

;; Maximize the Active Window
^!+Up::
    WinMaximize, A
return

;; Fill Top Half
^!Up::
    WinRestore, A
    getCurrentMonitorAreas(areaLeft, areaRight, areaTop, areaBottom)
    WinMove, A,, areaLeft,areaTop,areaRight-areaLeft,areaBottom/2
return

;; Fill Bottom Half
^!Down::
    WinRestore, A
    getCurrentMonitorAreas(areaLeft, areaRight, areaTop, areaBottom)
    WinMove, A,, areaLeft,areaBottom/2,areaRight-areaLeft,areaBottom/2
return

;; Fill Left Half
^!Left::
    WinRestore, A
    getCurrentMonitorAreas(areaLeft, areaRight, areaTop, areaBottom)
    WinMove, A,, areaLeft,areaTop,(areaRight-areaLeft)/2,areaBottom
return

;; Fill Right Half
^!Right::
    WinRestore, A
    getCurrentMonitorAreas(areaLeft, areaRight, areaTop, areaBottom)
    if (areaLeft < 0) {
        WinMove, A,, areaLeft/2,areaTop,(areaRight-areaLeft)/2,areaBottom
    } else {
        WinMove, A,, areaRight/2,areaTop,(areaRight-areaLeft)/2,areaBottom
    }
    
return

;; Move to next monitor
^!Space::
    WinRestore, A
    getNextMonitorAreas(areaLeft, areaRight, areaTop, areaBottom)
    WinMove, A,, areaLeft, areaTop
return
