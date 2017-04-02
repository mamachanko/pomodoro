port module Notifications exposing (..)

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (id)
import Html.Events exposing (onClick)


init =
    Nothing


type Model
    = Nothing


type Action
    = EnableDesktopNotifications


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        EnableDesktopNotifications ->
            model ! [ enableDesktopNotifications ]


subscriptions : Model -> Sub action
subscriptions model =
    Sub.none


view : Model -> Html Action
view model =
    div [ id "notificationControls" ]
        [ button
            [ id "enableDesktopNotifications"
            , onClick EnableDesktopNotifications
            ]
            [ text "Enable desktop notifications"
            ]
        ]


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
