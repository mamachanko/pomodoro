port module Notifications
    exposing
        ( enableDesktopNotifications
        , notifyEndOfPomodoro
        , notifyEndOfPomodoroStreak
        , notifyEndOfShortBreak
        , notifyEndOfLongBreak
        )


enableDesktopNotifications =
    requestPermissions ""


notifyEndOfPomodoro =
    notify "It's short break-y time."


notifyEndOfPomodoroStreak =
    notify "It's a time for a long break. You have done four consecutive Pomodoros."


notifyEndOfShortBreak =
    notify "Ora di pomodoro."


notifyEndOfLongBreak =
    notifyEndOfShortBreak


notify message =
    triggerNotification message


port requestPermissions : String -> Cmd action


port triggerNotification : String -> Cmd action
