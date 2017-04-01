module Log exposing (..)

import Html exposing (Html, div, td, text, input, button, h1, h2, ul, li)
import Html.Attributes exposing (class, id, type_, value, style)
import Html.Events exposing (onClick, onInput)


init : Model
init =
    { log = []
    , currentInput = ""
    }


type alias Model =
    { log : List String
    , currentInput : String
    }


type Action
    = RecordPomodoro
    | TextInput String


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        TextInput textInput ->
            { model | currentInput = textInput } ! []

        RecordPomodoro ->
            { model | log = model.currentInput :: model.log, currentInput = "" } ! []


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none


view : Model -> Html Action
view model =
    div [ id "pomodoroLog" ]
        [ h2 [] [ text "Pomodoro Log" ]
        , pomodoroLogInputElements model
        , pomodoroLogEntries model
        ]


pomodoroLogInputElements { currentInput } =
    div [ id "pomodoroLogInput" ]
        [ pomodoroLogInput currentInput
        , pomodoroLogButton
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


pomodoroLogEntries { log } =
    if (List.isEmpty log) then
        pomodoroLogNoEntries
    else
        ul [ id "pomodoroLogEntries" ]
            (List.map
                (\pomodoroLogEntry -> li [ class "pomodoroLogEntry" ] [ text pomodoroLogEntry ])
                log
            )


pomodoroLogNoEntries =
    div [ id "pomodoroLogEntriesEmpty" ] [ text "<no logged Pomodoros yet>" ]
