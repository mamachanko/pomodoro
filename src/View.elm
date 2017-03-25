module View exposing (view)

import Model exposing (..)
import Format exposing (formatTime)
import Html exposing (Html, div, td, text, input, button, h1, h2)
import Html.Attributes exposing (class, id, type_, value)
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


pomodoroLog { pastPomodoros, currentText, showPomodoroLogInput } =
    let
        pomodoroLogInputElements =
            if showPomodoroLogInput then
                div [ id "pomodoroLogInput" ]
                    [ pomodoroLogInput currentText
                    , pomodoroLogButton
                    ]
            else
                text ""
    in
        div [ id "pomodoroLog" ]
            [ h2 [] [ text "Pomodoro Log" ]
            , pomodoroLogInputElements
            , pomodoroLogEntries pastPomodoros
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


pomodoroLogEntries pastPomodoros =
    let
        entries =
            if (List.isEmpty pastPomodoros) then
                [ text "<no logged Pomodoros yet>" ]
            else
                (List.map
                    (\pomodoroLogEntry -> div [ class "pomodoroLogEntry" ] [ text pomodoroLogEntry ])
                    pastPomodoros
                )
    in
        div
            [ id "pomodoroLogEntries" ]
            entries


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
