module Model
    exposing
        ( Model(..)
        , Action(..)
        , Session(..)
        , tick
        , unstartedPomodoro
        , activePomodoro
        , freshPomodoro
        , freshShortBreak
        )

import Time


type Model
    = Active Session Remainder
    | Inactive Session Remainder


type Session
    = Pomodoro
    | ShortBreak


type alias Remainder =
    Float


type Action
    = StartPomodoro
    | StartShortBreak
    | Tick Time.Time


fullPomodoro : Remainder
fullPomodoro =
    Time.minute * 25


fullShortBreak : Remainder
fullShortBreak =
    Time.minute * 5


unstartedPomodoro =
    Inactive Pomodoro fullPomodoro


freshPomodoro : Model
freshPomodoro =
    Active Pomodoro fullPomodoro


freshShortBreak : Model
freshShortBreak =
    Active ShortBreak fullShortBreak


activePomodoro : Remainder -> Model
activePomodoro remainder =
    Active Pomodoro remainder


tick : Action
tick =
    Tick Time.second


startPomodoro =
    StartPomodoro
