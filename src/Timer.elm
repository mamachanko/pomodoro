module Timer exposing (..)

import Notifications
import Time
import Keyboard


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
            Notifications.notifyEndOfPomodoro

        _ ->
            Notifications.notifyEndOfBreak


activeSession : Model -> SessionType -> Remainder -> ( Model, Cmd action )
activeSession model activeSessionType remainder =
    ( Active activeSessionType remainder, Cmd.none )


countDown : Float -> Float
countDown =
    (+) (Time.second * -1)


countUp : Float -> Float
countUp =
    (+) Time.second
