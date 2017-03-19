module Model
    exposing
        ( Model(..)
        , Action(..)
        , Session(..)
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


type Model
    = Active Session Remainder
    | Inactive Session Remainder
    | Over Session Overflow


type Session
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


freshPomodoro : Model
freshPomodoro =
    Active Pomodoro fullPomodoro


freshShortBreak : Model
freshShortBreak =
    Active ShortBreak fullShortBreak


freshLongBreak : Model
freshLongBreak =
    Active LongBreak fullLongBreak


activePomodoro : Remainder -> Model
activePomodoro remainder =
    Active Pomodoro remainder


tick : Action
tick =
    Tick Time.second


startPomodoro =
    StartPomodoro
