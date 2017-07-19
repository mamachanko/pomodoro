port module App exposing (..)

import Task
import Dict
import Time
import Date
import Date.Format
import Keyboard
import Html exposing (Html, div, footer, map, programWithFlags, h1, text, p, td, input, button, h1, h2, ul, li)
import Html.Attributes exposing (class, id, type_, value, style)
import Html.Events exposing (onClick, onInput)


init : Model
init =
    { timer = initTimer
    , log = initLog
    , notifications = initNotifications
    }


altR =
    KeyboardEvent 174


type alias Flag =
    { date : String, text : String }


type alias Flags =
    { log : List Flag }


initWithFlags : Flags -> ( Model, Cmd msg )
initWithFlags flags =
    let
        parseLog log =
            case Date.fromString log.date of
                Ok date ->
                    Just { date = date, text = log.text }

                Err error ->
                    Nothing

        loadedLog =
            List.map parseLog flags.log |> List.filterMap identity
    in
        { init | log = loadedLog } ! []


initTimer : TimerModel
initTimer =
    unstartedPomodoro


initLog : LogModel
initLog =
    []


initNotifications : NotificationsModel
initNotifications =
    None


timerDefaults =
    { pomodoro = Time.minute * 25
    , break = Time.minute * 5
    }


type alias Model =
    { timer : TimerModel
    , log : LogModel
    , notifications : NotificationsModel
    }


type TimerModel
    = Active SessionType Remainder
    | Inactive SessionType Remainder
    | Over SessionType Overflow


type SessionType
    = Pomodoro
    | Break


type alias Remainder =
    Time.Time


type alias Overflow =
    Time.Time


type alias LogModel =
    List Recorded


type alias Recorded =
    { date : Date.Date
    , text : String
    }


type NotificationsModel
    = None


type Action
    = RecordPomodoro Date.Date
    | StartPomodoro
    | StartBreak
    | Tick Time.Time
    | KeyboardEvent Keyboard.KeyCode


fullPomodoro : Remainder
fullPomodoro =
    timerDefaults.pomodoro


fullBreak : Remainder
fullBreak =
    timerDefaults.break


unstartedPomodoro : TimerModel
unstartedPomodoro =
    Inactive Pomodoro fullPomodoro


unstartedBreak : TimerModel
unstartedBreak =
    Inactive Break fullBreak


freshPomodoro : TimerModel
freshPomodoro =
    Active Pomodoro fullPomodoro


freshBreak : TimerModel
freshBreak =
    Active Break fullBreak


tick : Action
tick =
    Tick Time.second


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        RecordPomodoro date ->
            updateLog action model

        StartPomodoro ->
            updateTimer action model

        StartBreak ->
            updateTimer action model

        KeyboardEvent keycode ->
            case keycode of
                960 ->
                    updateTimer action model

                223 ->
                    updateTimer action model

                8706 ->
                    updateNotifications action model

                174 ->
                    updateLog action model

                _ ->
                    model ! []

        Tick _ ->
            updateTimer action model


updateNotifications : Action -> Model -> ( Model, Cmd Action )
updateNotifications action model =
    case action of
        KeyboardEvent keycode ->
            case keycode of
                8706 ->
                    model ! [ enableDesktopNotifications ]

                _ ->
                    model ! []

        _ ->
            model ! []


updateLog : Action -> Model -> ( Model, Cmd Action )
updateLog action model =
    let
        { timer, log, notifications } =
            model
    in
        case action of
            RecordPomodoro date ->
                let
                    recordedPomodoro =
                        Recorded date "Pomodoro"

                    newLog =
                        recordedPomodoro :: log
                in
                    { model | log = newLog } ! [ writeLog newLog ]

            KeyboardEvent 174 ->
                { model | log = [] } ! [ resetLog ]

            _ ->
                model ! []


updateTimer : Action -> Model -> ( Model, Cmd Action )
updateTimer action model =
    let
        { timer, log, notifications } =
            model
    in
        case action of
            StartPomodoro ->
                { model | timer = freshPomodoro } ! []

            StartBreak ->
                { model | timer = freshBreak } ! []

            KeyboardEvent keycode ->
                { model | timer = updateKeyboardEvent timer keycode } ! []

            Tick time ->
                let
                    ( newTimer, cmd ) =
                        updateTick timer time
                in
                    ( { model | timer = newTimer }, cmd )

            _ ->
                model ! []


updateTick : TimerModel -> Time.Time -> ( TimerModel, Cmd Action )
updateTick model time =
    case model of
        Over sessionType overflow ->
            Over sessionType (countUp overflow) ! []

        Active sessionType remainder ->
            updateActiveSession model sessionType remainder

        _ ->
            model ! []


updateActiveSession : TimerModel -> SessionType -> Remainder -> ( TimerModel, Cmd Action )
updateActiveSession model sessionType remainder =
    let
        newRemainder =
            countDown remainder
    in
        if (newRemainder == 0) then
            finishedSession model sessionType
        else
            activeSession model sessionType newRemainder


updateKeyboardEvent : TimerModel -> Keyboard.KeyCode -> TimerModel
updateKeyboardEvent model keycode =
    case keycode of
        960 ->
            freshPomodoro

        223 ->
            freshBreak

        _ ->
            model


finishedSession : TimerModel -> SessionType -> ( TimerModel, Cmd Action )
finishedSession model finishedSessionType =
    let
        cmds =
            case finishedSessionType of
                Pomodoro ->
                    Cmd.batch [ Task.perform RecordPomodoro Date.now, notify "It's break-y time." ]

                _ ->
                    notify "Ora di pomodoro."
    in
        Over finishedSessionType 0
            ! [ cmds ]


activeSession : TimerModel -> SessionType -> Remainder -> ( TimerModel, Cmd action )
activeSession model activeSessionType remainder =
    ( Active activeSessionType remainder, Cmd.none )


countDown : Float -> Float
countDown =
    (+) (Time.second * -1)


countUp : Float -> Float
countUp =
    (+) Time.second


subscriptions : Model -> Sub Action
subscriptions { timer } =
    let
        keyPresses =
            Keyboard.presses KeyboardEvent

        seconds =
            Time.every Time.second Tick
    in
        case timer of
            Inactive _ _ ->
                keyPresses

            _ ->
                Sub.batch [ seconds, keyPresses ]


view : Model -> Html Action
view model =
    div [ id "App" ]
        [ viewTimer model.timer
        , viewLog model.log
        , viewShortcuts
        ]


viewTimer : TimerModel -> Html Action
viewTimer model =
    div [ id "timer" ]
        [ text (formatTimer model)
        ]


viewShortcuts =
    footer [ id "shortcuts" ]
        [ p [] [ text "Hit alt+p for a Pomodoro. Hit alt+s for a break." ]
        , p [] [ text "Hit alt+r to reset your log. Hit alt+d to enable desktop notifications." ]
        ]


formatTimer : TimerModel -> String
formatTimer model =
    case model of
        Active _ time ->
            formatTime time

        Inactive _ time ->
            formatTime time

        Over _ time ->
            "-" ++ (formatTime time)


formatTime : Time.Time -> String
formatTime time =
    if time >= 0 then
        formatTime_ time
    else
        "-" ++ (formatTime_ (abs time))


formatTime_ : Time.Time -> String
formatTime_ time =
    (formatMinutes time) ++ ":" ++ (formatSeconds time)


formatMinutes : Time.Time -> String
formatMinutes time =
    let
        minutes =
            truncate (Time.inMinutes time)
    in
        if minutes == 0 then
            "00"
        else if minutes < 10 then
            "0" ++ toString minutes
        else
            toString minutes


formatSeconds : Time.Time -> String
formatSeconds time =
    let
        seconds =
            Time.inSeconds <|
                toFloat <|
                    (truncate time)
                        % (truncate Time.minute)
    in
        if seconds == 0 then
            "00"
        else if seconds < 10 then
            "0" ++ toString seconds
        else
            toString seconds


viewLog : LogModel -> Html Action
viewLog model =
    div [ id "log" ]
        [ pomodoroLogEntries model
        ]


pomodoroLogEntries log =
    if (List.isEmpty log) then
        pomodoroLogNoEntries
    else
        let
            logDates =
                groupByDate log
                    |> List.map pomodoroLogDate
        in
            ul [ id "logEntries" ]
                logDates


groupByDate : LogModel -> List ( String, List Recorded )
groupByDate log =
    groupByDate_ log Dict.empty


groupByDate_ : LogModel -> Dict.Dict String (List Recorded) -> List ( String, List Recorded )
groupByDate_ log result =
    case log of
        entry :: remainder ->
            groupByDate_ remainder <|
                Dict.update (formatLogDate entry.date) (pushLogEntry entry) result

        [] ->
            Dict.toList result |> List.reverse


formatLogDate : Date.Date -> String
formatLogDate =
    Date.Format.format "%d-%m-%Y"


pushLogEntry : Recorded -> Maybe (List Recorded) -> Maybe (List Recorded)
pushLogEntry entry list =
    case list of
        Just stuff ->
            Just <| List.sortBy (\{ date } -> (Date.toTime date) * -1) (entry :: stuff)

        Nothing ->
            Just [ entry ]


pomodoroLogDate : ( String, List Recorded ) -> Html Action
pomodoroLogDate ( dateString, pomodoros ) =
    let
        logEntries =
            ul [] <| List.map pomodoroLogEntry pomodoros
    in
        li
            [ class "logDate"
            ]
            [ text dateString
            , logEntries
            ]


pomodoroLogEntry : Recorded -> Html Action
pomodoroLogEntry logEntry =
    li
        [ class "logEntry"
        ]
        [ text <| (Date.Format.format "%H:%M" logEntry.date) ++ ": " ++ logEntry.text
        ]


pomodoroLogNoEntries =
    div [ id "emptyLog" ]
        [ p [] [ text "This is where you're logged Pomodoros will appear." ]
        , p [] [ text "Your log is kept on this device and survives reloads." ]
        ]


writeLog : LogModel -> Cmd msg
writeLog log =
    let
        serializeLog log =
            { date = toString log.date, text = log.text }
    in
        Cmd.batch
            [ updatePomodoroLogPort
                { log =
                    List.map serializeLog log
                }
            ]


resetLog : Cmd msg
resetLog =
    writeLog []


enableDesktopNotifications : Cmd msg
enableDesktopNotifications =
    requestPermissionsPort ""


notify : String -> Cmd msg
notify message =
    Cmd.batch
        [ sendNotification message
        , ringBell
        ]


sendNotification : String -> Cmd msg
sendNotification message =
    sendNotificationPort message


ringBell : Cmd msg
ringBell =
    ringBellPort ""


port requestPermissionsPort : String -> Cmd action


port sendNotificationPort : String -> Cmd action


port ringBellPort : String -> Cmd action


port updatePomodoroLogPort : Flags -> Cmd action


main =
    programWithFlags
        { init = initWithFlags
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
