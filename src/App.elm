port module App exposing (..)

import Task
import Dict
import Time
import Date
import Date.Format
import Keyboard
import Html exposing (Html, div, map, programWithFlags, h1, text, td, input, button, h1, h2, ul, li)
import Html.Attributes exposing (class, id, type_, value, style)
import Html.Events exposing (onClick, onInput)


init : Model
init =
    { timer = initTimer
    , log = initLog
    , notifications = initNotifications
    }


initWithFlags : List String -> ( Model, Cmd msg )
initWithFlags log =
    init ! []


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
    | EnableDesktopNotifications
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

        EnableDesktopNotifications ->
            model ! [ enableDesktopNotifications ]

        StartPomodoro ->
            updateTimer action model

        StartBreak ->
            updateTimer action model

        KeyboardEvent _ ->
            updateTimer action model

        Tick _ ->
            updateTimer action model


updateNotifications : Action -> Model -> ( Model, Cmd Action )
updateNotifications action model =
    case action of
        EnableDesktopNotifications ->
            model ! [ enableDesktopNotifications ]

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
                    recorded =
                        Recorded date "Pomodoro"
                in
                    { model | log = recorded :: log } ! []

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
subscriptions model =
    Sub.batch
        [ subscriptionsTimer model.timer
        , subscriptionsLog model.log
        , subscriptionsNotifications model.notifications
        ]


subscriptionsTimer : TimerModel -> Sub Action
subscriptionsTimer model =
    let
        keyPresses =
            Keyboard.presses KeyboardEvent

        seconds =
            Time.every Time.second Tick
    in
        case model of
            Inactive _ _ ->
                keyPresses

            _ ->
                Sub.batch [ seconds, keyPresses ]


subscriptionsLog : LogModel -> Sub Action
subscriptionsLog model =
    Sub.none


subscriptionsNotifications : NotificationsModel -> Sub action
subscriptionsNotifications model =
    Sub.none


view : Model -> Html Action
view model =
    div [ id "App" ]
        [ h1 [ id "header" ] [ text "Pomodoro" ]
        , viewTimer model.timer
        , viewNotifications model.notifications
        , viewLog model.log
        ]


viewTimer : TimerModel -> Html Action
viewTimer model =
    div [ id "timer" ]
        [ timer model
        , timerControls
        , timerShortcuts
        ]


timerShortcuts =
    div [ id "timerShortcuts" ]
        [ div [] [ text "alt+p" ]
        , div [] [ text "alt+s" ]
        ]


timer session =
    div [ id "time" ] [ text (formatTimer session) ]


timerControls =
    div [ id "timerControls" ]
        [ pomodoroButton
        , breakButton
        ]


pomodoroButton =
    div []
        [ button
            [ id "startPomodoro"
            , onClick StartPomodoro
            ]
            [ text "Pomodoro" ]
        ]


breakButton =
    div []
        [ button
            [ id "startBreak"
            , onClick StartBreak
            ]
            [ text "Break" ]
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
    div [ id "pomodoroLog" ]
        [ h2 [] [ text "Pomodoro Log" ]
        , pomodoroLogEntries model
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
            ul [ id "pomodoroLogEntries" ]
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
            Dict.toList result


formatLogDate : Date.Date -> String
formatLogDate =
    Date.Format.format "%d-%m-%Y"


pushLogEntry : Recorded -> Maybe (List Recorded) -> Maybe (List Recorded)
pushLogEntry entry list =
    case list of
        Just stuff ->
            Just <| List.sortBy (\{ date } -> Date.toTime date) (entry :: stuff)

        Nothing ->
            Just [ entry ]


pomodoroLogDate : ( String, List Recorded ) -> Html Action
pomodoroLogDate ( dateString, pomodoros ) =
    let
        logEntries =
            ul [] <| List.map pomodoroLogEntry pomodoros
    in
        li
            [ class "pomodoroLogDate"
            ]
            [ text dateString
            , logEntries
            ]


pomodoroLogEntry : Recorded -> Html Action
pomodoroLogEntry logEntry =
    li
        [ class "pomodoroLogEntry"
        ]
        [ text <| (Date.Format.format "%H:%M" logEntry.date) ++ ": " ++ logEntry.text
        ]


pomodoroLogNoEntries =
    div [ id "pomodoroLogEntriesEmpty" ] [ text "<no logged Pomodoros yet>" ]


viewNotifications : NotificationsModel -> Html Action
viewNotifications model =
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


main =
    programWithFlags
        { init = initWithFlags
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
