module Model
    exposing
        ( init
        , Model
        , Action(..)
        , Session(..)
        , SessionType(..)
        , tick
        , unstartedPomodoro
        , unstartedShortBreak
        , unstartedLongBreak
        , activePomodoro
        , freshPomodoro
        , freshShortBreak
        , freshLongBreak
        )

import Time


init : Model
init =
    { currentSession = unstartedPomodoro, pomodoroCount = 0 }


type alias Model =
    { currentSession : Session, pomodoroCount : Int }


type Session
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


fullPomodoro : Remainder
fullPomodoro =
    Time.minute * 25


fullShortBreak : Remainder
fullShortBreak =
    Time.minute * 5


fullLongBreak : Remainder
fullLongBreak =
    Time.minute * 20


unstartedPomodoro =
    Inactive Pomodoro fullPomodoro


unstartedShortBreak =
    Inactive ShortBreak fullShortBreak


unstartedLongBreak =
    Inactive LongBreak fullLongBreak


freshPomodoro =
    Active Pomodoro fullPomodoro


freshShortBreak =
    Active ShortBreak fullShortBreak


freshLongBreak =
    Active LongBreak fullLongBreak


activePomodoro remainder =
    Active Pomodoro remainder


tick =
    Tick Time.second


startPomodoro =
    StartPomodoro
