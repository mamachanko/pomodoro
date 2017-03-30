module View exposing (view)

import Model exposing (..)
import Format exposing (formatTime)
import Html exposing (Html, div, td, text, input, button, h1, h2, ul, li)
import Html.Attributes exposing (class, id, type_, value, style)
import Html.Events exposing (onClick, onInput)


view : Model -> Html Action
view model =
    div [ id "pomodoro" ]
        [ header
        , pomodoroTimer model
        , pomodoroLog model
        ]


header =
    h1 [ id "header" ] [ text "Pomodoro" ]


pomodoroLog { pomodoroLog, currentText, showPomodoroLogInput } =
    let
        pomodoroLogInputVisibility =
            if showPomodoroLogInput then
                "visible"
            else
                "hidden"

        pomodoroLogInputElements =
            div [ id "pomodoroLogInput", style [ ( "visibility", pomodoroLogInputVisibility ) ] ]
                [ pomodoroLogInput currentText
                , pomodoroLogButton
                ]
    in
        div [ id "pomodoroLog" ]
            [ h2 [] [ text "Pomodoro Log" ]
            , pomodoroLogInputElements
            , pomodoroLogEntries pomodoroLog
            ]


pomodoroLogInput currentText =
    input
        [ id "pomodoroLogInputText"
        , type_ "text"
        , onInput TextInput
        , value currentText
        ]
        []


pomodoroLogButton =
    button
        [ id "pomodoroLogButton"
        , onClick RecordPomodoro
        ]
        [ text "Log Pomodoro" ]


pomodoroLogEntries pomodoroLog =
    if (List.isEmpty pomodoroLog) then
        pomodoroLogNoEntries
    else
        ul [ id "pomodoroLogEntries" ]
            (List.map
                (\pomodoroLogEntry -> li [ class "pomodoroLogEntry" ] [ text pomodoroLogEntry ])
                pomodoroLog
            )


pomodoroLogNoEntries =
    div [ id "pomodoroLogEntriesEmpty" ] [ text "<no logged Pomodoros yet>" ]


pomodoroTimer { currentSession } =
    div [ id "timer" ]
        [ time currentSession
        , timerControls
        , timerShortcuts
        , notificationControls
        ]


timerShortcuts =
    div [ id "timerShortcuts" ]
        [ div [] [ text "alt+p" ]
        , div [] [ text "alt+s" ]
        , div [] [ text "alt+l" ]
        ]


time session =
    div [ id "time" ] [ text (formatSession session) ]


timerControls =
    div [ id "timerControls" ]
        [ pomodoroButton
        , shortBreakButton
        , longBreakButton
        ]


notificationControls =
    div [ id "notificationControls" ]
        [ enableDesktopNotificationsButton
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


formatSession : Session -> String
formatSession session =
    case session of
        Active _ time ->
            formatTime time

        Inactive _ time ->
            formatTime time

        Over _ time ->
            "-" ++ (formatTime time)
