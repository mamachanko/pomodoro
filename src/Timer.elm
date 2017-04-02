module Timer exposing (..)

import Notifications
import Time
import Keyboard
import Html exposing (Html, div, td, text, input, button, h1, h2, ul, li)
import Html.Attributes exposing (class, id, type_, value, style)
import Html.Events exposing (onClick, onInput)


defaults =
    { pomodoro = Time.minute * 25
    , shortbreak = Time.minute * 5
    , longbreak = Time.minute * 15
    }


init : Model
init =
    unstartedPomodoro


type Model
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


type Action
    = StartPomodoro
    | StartShortBreak
    | StartLongBreak
    | Tick Time.Time
    | KeyboardEvent Keyboard.KeyCode


fullPomodoro : Remainder
fullPomodoro =
    defaults.pomodoro


fullShortBreak : Remainder
fullShortBreak =
    defaults.shortbreak


fullLongBreak : Remainder
fullLongBreak =
    defaults.longbreak


unstartedPomodoro : Model
unstartedPomodoro =
    Inactive Pomodoro fullPomodoro


unstartedShortBreak : Model
unstartedShortBreak =
    Inactive ShortBreak fullShortBreak


unstartedLongBreak : Model
unstartedLongBreak =
    Inactive LongBreak fullLongBreak


freshPomodoro : Model
freshPomodoro =
    Active Pomodoro fullPomodoro


freshShortBreak : Model
freshShortBreak =
    Active ShortBreak fullShortBreak


freshLongBreak : Model
freshLongBreak =
    Active LongBreak fullLongBreak


tick : Action
tick =
    Tick Time.second


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        StartPomodoro ->
            ( freshPomodoro, Cmd.none )

        StartShortBreak ->
            ( freshShortBreak, Cmd.none )

        StartLongBreak ->
            ( freshLongBreak, Cmd.none )

        KeyboardEvent keycode ->
            updateKeyboardEvent model keycode

        Tick time ->
            updateTick model time


updateTick : Model -> Time.Time -> ( Model, Cmd action )
updateTick model time =
    case model of
        Over sessionType overflow ->
            ( Over sessionType (countUp overflow), Cmd.none )

        Active sessionType remainder ->
            updateActiveSession model sessionType remainder

        _ ->
            ( model, Cmd.none )


updateActiveSession : Model -> SessionType -> Remainder -> ( Model, Cmd action )
updateActiveSession model sessionType remainder =
    let
        newRemainder =
            countDown remainder
    in
        if (newRemainder == 0) then
            finishedSession model sessionType
        else
            activeSession model sessionType newRemainder


updateKeyboardEvent : Model -> Keyboard.KeyCode -> ( Model, Cmd action )
updateKeyboardEvent model keycode =
    case keycode of
        960 ->
            ( freshPomodoro, Cmd.none )

        223 ->
            ( freshShortBreak, Cmd.none )

        172 ->
            ( freshLongBreak, Cmd.none )

        _ ->
            ( model, Cmd.none )


finishedSession : Model -> SessionType -> ( Model, Cmd action )
finishedSession model finishedSessionType =
    ( Over finishedSessionType 0, endOfSessionNotification finishedSessionType )


endOfSessionNotification : SessionType -> Cmd action
endOfSessionNotification sessionType =
    case sessionType of
        Pomodoro ->
            Notifications.notify "It's break-y time."

        _ ->
            Notifications.notify "Ora di pomodoro."


activeSession : Model -> SessionType -> Remainder -> ( Model, Cmd action )
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


view : Model -> Html Action
view model =
    div [ id "timer" ]
        [ time model
        , timerControls
        , timerShortcuts
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
