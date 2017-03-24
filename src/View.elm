module View exposing (view)

import Model exposing (..)
import Format exposing (formatTime)
import Html exposing (Html, div, td, text, audio, source, button, h1)
import Html.Attributes exposing (id)
import Html.Events exposing (onClick)


view : Model -> Html Action
view model =
    div [ id "pomodoro" ]
        [ header
        , timer model
        , controls
        , footer
        ]


header =
    h1 [ id "header" ] [ text "Pomodoro" ]


footer =
    div [ id "footer" ]
        [ enableDesktopNotificationsButton
        , shortcuts
        ]


shortcuts =
    div [ id "shortcuts" ]
        [ div [] [ text "alt+p: Pomodoro" ]
        , div [] [ text "alt+s: short break" ]
        , div [] [ text "alt+l: long break" ]
        ]


timer model =
    div [ id "timer" ] [ text (formatSession model) ]


controls =
    div [ id "controls" ]
        [ pomodoroButton
        , shortBreakButton
        , longBreakButton
        ]


pomodoroButton =
    div []
        [ button
            [ id "startPomodoro"
            , onClick StartPomodoro
            ]
            [ text "Pomodoro" ]
        ]


shortBreakButton =
    div []
        [ button
            [ id "startShortBreak"
            , onClick StartShortBreak
            ]
            [ text "Short break" ]
        ]


longBreakButton =
    div []
        [ button
            [ id "startLongBreak"
            , onClick StartLongBreak
            ]
            [ text "Long break" ]
        ]


enableDesktopNotificationsButton =
    button
        [ id "enableDesktopNotifications"
        , onClick EnableDesktopNotifications
        ]
        [ text "Enable desktop notifications"
        ]


formatSession : Model -> String
formatSession { currentSession } =
    case currentSession of
        Active _ time ->
            formatTime time

        Inactive _ time ->
            formatTime time

        Over _ time ->
            "-" ++ (formatTime time)
