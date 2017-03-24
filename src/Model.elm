module Model exposing (..)

import Time
import Keyboard


initialModel : Model
initialModel =
    { currentSession = unstartedPomodoro, pastSessions = noPastSessions }


type alias Model =
    { currentSession : Session, pastSessions : List DoneSession }


type Session
    = Active SessionType Remainder
    | Inactive SessionType Remainder
    | Over SessionType Overflow


type DoneSession
    = DonePomodoro String
    | DoneShortBreak
    | DoneLongBreak


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
    | KeyboardEvent Keyboard.KeyCode
    | RecordPomodoro String


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


noPastSessions =
    []


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
