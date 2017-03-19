module View exposing (view)

import Model exposing (..)
import Format exposing (formatTime)
import Html exposing (Html, div, td, text, audio, source, button, h1)
import Html.Attributes exposing (id)
import Html.Events exposing (onClick)
import FontAwesome
import Color


view : Model -> Html Action
view model =
    div [ id "pomodoro" ]
        [ header
        , timer model
        , counter model
        , controls
        , message model
        ]


header =
    h1 [ id "header" ] [ FontAwesome.clock_o Color.black 50 ]


timer model =
    div [ id "timer" ] [ text (formatSession model) ]


controls =
    div [ id "controls" ]
        [ pomodoroButton
        , shortBreakButton
        , longBreakButton
        ]


counter model =
    div [ id "counter" ]
        [ FontAwesome.dot_circle_o Color.black 20
        , FontAwesome.times Color.black 20
        , text (toString model.pomodoroCount)
        ]


message { currentSession } =
    case currentSession of
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
formatSession { currentSession } =
    case currentSession of
        Active _ time ->
            formatTime time

        Inactive _ time ->
            formatTime time

        Over _ time ->
            "-" ++ (formatTime time)
