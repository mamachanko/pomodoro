port module App exposing (..)

import Time
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
    let
        initialLog =
            initLog

        loadedLog =
            { initialLog | log = log }
    in
        ( { init | log = loadedLog }, Cmd.none )


initTimer : TimerModel
initTimer =
    unstartedPomodoro


initLog : LogModel
initLog =
    { log = []
    , currentInput = ""
    }


initNotifications : NotificationsModel
initNotifications =
    Nothing


timerDefaults =
    { pomodoro = Time.minute * 25
    , shortbreak = Time.minute * 5
    , longbreak = Time.minute * 15
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
    | ShortBreak
    | LongBreak


type alias Remainder =
    Time.Time


type alias Overflow =
    Time.Time


type alias LogModel =
    { log : List String
    , currentInput : String
    }


type NotificationsModel
    = Nothing


type Action
    = RecordPomodoro
    | TextInput String
    | EnableDesktopNotifications
    | StartPomodoro
    | StartShortBreak
    | StartLongBreak
    | Tick Time.Time
    | KeyboardEvent Keyboard.KeyCode


fullPomodoro : Remainder
fullPomodoro =
    timerDefaults.pomodoro


fullShortBreak : Remainder
fullShortBreak =
    timerDefaults.shortbreak


fullLongBreak : Remainder
fullLongBreak =
    timerDefaults.longbreak


unstartedPomodoro : TimerModel
unstartedPomodoro =
    Inactive Pomodoro fullPomodoro


unstartedShortBreak : TimerModel
unstartedShortBreak =
    Inactive ShortBreak fullShortBreak


unstartedLongBreak : TimerModel
unstartedLongBreak =
    Inactive LongBreak fullLongBreak


freshPomodoro : TimerModel
freshPomodoro =
    Active Pomodoro fullPomodoro


freshShortBreak : TimerModel
freshShortBreak =
    Active ShortBreak fullShortBreak


freshLongBreak : TimerModel
freshLongBreak =
    Active LongBreak fullLongBreak


tick : Action
tick =
    Tick Time.second


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        TextInput textInput ->
            updateLog action model

        RecordPomodoro ->
            updateLog action model

        EnableDesktopNotifications ->
            model ! [ enableDesktopNotifications ]

        StartPomodoro ->
            updateTimer action model

        StartShortBreak ->
            updateTimer action model

        StartLongBreak ->
            updateTimer action model

        KeyboardEvent _ ->
            updateTimer action model

        Tick _ ->
            updateTimer action model


updateNotifications : Action -> Model -> ( Model, Cmd action )
updateNotifications action model =
    case action of
        EnableDesktopNotifications ->
            model ! [ enableDesktopNotifications ]

        _ ->
            model ! []


updateLog : Action -> Model -> ( Model, Cmd action )
updateLog action model =
    let
        { timer, log, notifications } =
            model
    in
        case action of
            TextInput textInput ->
                let
                    newLog =
                        { log | currentInput = textInput }
                in
                    { model | log = newLog } ! []

            RecordPomodoro ->
                let
                    newLog =
                        { log | log = log.currentInput :: log.log, currentInput = "" }
                in
                    { model | log = newLog } ! []

            _ ->
                model ! []


updateTimer : Action -> Model -> ( Model, Cmd action )
updateTimer action model =
    let
        { timer, log, notifications } =
            model
    in
        case action of
            StartPomodoro ->
                { model | timer = freshPomodoro } ! []

            StartShortBreak ->
                { model | timer = freshShortBreak } ! []

            StartLongBreak ->
                { model | timer = freshLongBreak } ! []

            KeyboardEvent keycode ->
                { model | timer = updateKeyboardEvent timer keycode } ! []

            Tick time ->
                let
                    ( newTimer, cmd ) =
                        updateTick timer time
                in
                    { model | timer = newTimer } ! [ cmd ]

            _ ->
                model ! []


updateTick : TimerModel -> Time.Time -> ( TimerModel, Cmd action )
updateTick model time =
    case model of
        Over sessionType overflow ->
            Over sessionType (countUp overflow) ! []

        Active sessionType remainder ->
            updateActiveSession model sessionType remainder

        _ ->
            model ! []


updateActiveSession : TimerModel -> SessionType -> Remainder -> ( TimerModel, Cmd action )
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
            freshShortBreak

        172 ->
            freshLongBreak

        _ ->
            model


finishedSession : TimerModel -> SessionType -> ( TimerModel, Cmd action )
finishedSession model finishedSessionType =
    Over finishedSessionType 0 ! [ endOfSessionNotification finishedSessionType ]


endOfSessionNotification : SessionType -> Cmd action
endOfSessionNotification sessionType =
    case sessionType of
        Pomodoro ->
            notify "It's break-y time."

        _ ->
            notify "Ora di pomodoro."


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
        , div [] [ text "alt+l" ]
        ]


timer session =
    div [ id "time" ] [ text (formatTimer session) ]


timerControls =
    div [ id "timerControls" ]
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
