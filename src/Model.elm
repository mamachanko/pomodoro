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
    { currentSession = unstartedPomodoro, pastSessions = [] }


type alias Model =
    { currentSession : Session, pastSessions : List SessionType }


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
    | EnableDesktopNotifications


fullPomodoro : Remainder
fullPomodoro =
    Time.second * 2


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
