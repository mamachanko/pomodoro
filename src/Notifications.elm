port module Notifications
    exposing
        ( enableDesktopNotifications
        , notifyEndOfPomodoro
        , notifyEndOfBreak
        )


enableDesktopNotifications =
    requestPermissions ""


notifyEndOfPomodoro =
    Cmd.batch
        [ notify "It's break-y time."
        , ringBell ""
        ]


notifyEndOfBreak =
    Cmd.batch
        [ notify "Ora di pomodoro."
        , ringBell ""
        ]


notify message =
    triggerNotification message


port requestPermissions : String -> Cmd action


port triggerNotification : String -> Cmd action


port ringBell : String -> Cmd action
