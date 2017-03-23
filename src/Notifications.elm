port module Notifications
    exposing
        ( enableDesktopNotifications
        , notifyEndOfPomodoro
        , notifyEndOfBreak
        )


bell =
    "beep.mp3"


enableDesktopNotifications =
    requestPermissions ""


notifyEndOfPomodoro =
    Cmd.batch
        [ notify "It's break-y time."
        , ringBell
        ]


notifyEndOfBreak =
    Cmd.batch
        [ notify "Ora di pomodoro."
        , ringBell
        ]


notify message =
    triggerNotification message


ringBell : Cmd msg
ringBell =
    playSound bell


port requestPermissions : String -> Cmd action


port triggerNotification : String -> Cmd action


port playSound : String -> Cmd action
