port module Notifications
    exposing
        ( enableDesktopNotifications
        , notifyEndOfPomodoro
        , notifyEndOfBreak
        )


enableDesktopNotifications =
    requestPermissions ""


notifyEndOfPomodoro =
    notify "It's break-y time."


notifyEndOfBreak =
    notify "Ora di pomodoro."


notify message =
    triggerNotification message


port requestPermissions : String -> Cmd action


port triggerNotification : String -> Cmd action
