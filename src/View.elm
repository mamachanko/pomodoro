module View exposing (view)

import Model exposing (..)
import Format exposing (formatTime)
import Html exposing (Html, div, td, text, input, button, h1)
import Html.Attributes exposing (class, id, type_, value)
import Html.Events exposing (onClick, onInput)


view : Model -> Html Action
view model =
    div [ id "pomodoro" ]
        [ header
        , timer model
        , controls
        , sessionLog model
        , footer
        ]


header =
    h1 [ id "header" ] [ text "Pomodoro" ]


sessionLog { pastPomodoros, currentText, showPomodoroLogInput } =
    let
        elements =
            if showPomodoroLogInput then
                [ logPomodoroInput currentText
                , logPomodoroButton
                , pomodoroLog pastPomodoros
                ]
            else
                [ pomodoroLog pastPomodoros ]
    in
        div [] elements


logPomodoroInput currentText =
    input [ id "workDone", type_ "text", onInput TextInput, value currentText ] []


logPomodoroButton =
    button [ id "saveWorkDone", onClick RecordPomodoro ] [ text "Save" ]


pomodoroLog pastPomodoros =
    div
        [ id "pomodoroLog" ]
        (List.map
            (\loggedPomodoro -> div [ class "loggedPomodoro" ] [ text loggedPomodoro ])
            pastPomodoros
        )


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
