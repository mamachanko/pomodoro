port module Notifications
    exposing
        ( enableDesktopNotifications
        , notify
        , sendNotification
        , ringBell
        )


enableDesktopNotifications =
    requestPermissionsPort ""


notify message =
    Cmd.batch
        [ sendNotification message
        , ringBell
        ]


sendNotification message =
    sendNotificationPort message


ringBell =
    ringBellPort ""


port requestPermissionsPort : String -> Cmd action


port sendNotificationPort : String -> Cmd action


port ringBellPort : String -> Cmd action


port updatePomodoroLogPort : String -> Cmd action
