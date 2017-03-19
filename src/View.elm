module View exposing (view)

import Model exposing (..)
import Format exposing (formatTime)
import Html exposing (Html, div, td, text, audio, source, button)
import Html.Attributes exposing (id)
import Html.Events exposing (onClick)


view : Model -> Html Action
view model =
    div []
        [ header
        , div
            []
            [ timer model
            , pomodoroButton
            , shortBreakButton
            , longBreakButton
            , message model
            ]
        ]


header =
    div [ id "header" ] [ text "Pomodoro" ]


timer model =
    div [ id "timer" ] [ text (formatSession model) ]


message model =
    case model of
        Active _ _ ->
            text ""

        Inactive _ _ ->
            text ""

        Over session _ ->
            overflowMessage session


overflowMessage session =
    case session of
        Pomodoro ->
            div [ id "message" ] [ text "It's break-y time!" ]

        _ ->
            div [ id "message" ] [ text "Ora di pomodoro!" ]


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


formatSession : Model -> String
formatSession model =
    case model of
        Active _ time ->
            formatTime time

        Inactive _ time ->
            formatTime time

        Over _ time ->
            "-" ++ (formatTime time)
