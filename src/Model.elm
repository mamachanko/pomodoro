module Model
    exposing
        ( Model(..)
        , Action(..)
        , Session(..)
        , tick
        , unstartedPomodoro
        , activePomodoro
        , freshPomodoro
        )

import Time


type Model
    = Active Session Remainder
    | Inactive Session Remainder


type Session
    = Pomodoro


type alias Remainder =
    Float


type Action
    = StartPomodoro
    | Tick Time.Time


fullPomodoro : Remainder
fullPomodoro =
    Time.minute * 25


unstartedPomodoro =
    Inactive Pomodoro fullPomodoro


freshPomodoro : Model
freshPomodoro =
    Active Pomodoro fullPomodoro


activePomodoro : Remainder -> Model
activePomodoro remainder =
    Active Pomodoro remainder


tick : Action
tick =
    Tick Time.second


startPomodoro =
    StartPomodoro
