port module Notifications exposing (enableDesktopNotifications, triggerNotification)


enableDesktopNotifications =
    requestPermissions ""

notify message =
    triggerNotification message

port requestPermissions : String -> Cmd action

port triggerNotification : String -> Cmd action