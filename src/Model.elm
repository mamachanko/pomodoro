module Model exposing (..)

import Time
import Keyboard


defaults =
    { pomodoro = Time.minute * 25
    , shortbreak = Time.minute * 5
    , longbreak = Time.minute * 15
    }


initialModel : Model
initialModel =
    { currentSession = unstartedPomodoro
    , pastPomodoros = []
    , currentText = ""
    , showPomodoroLogInput = False
    }


type alias Model =
    { currentSession : Session
    , pastPomodoros : List String
    , currentText : String
    , showPomodoroLogInput : Bool
    }


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
    | KeyboardEvent Keyboard.KeyCode
    | RecordPomodoro
    | TextInput String


fullPomodoro : Remainder
fullPomodoro =
    defaults.pomodoro


fullShortBreak : Remainder
fullShortBreak =
    defaults.shortbreak


fullLongBreak : Remainder
fullLongBreak =
    defaults.longbreak


unstartedPomodoro =
    Inactive Pomodoro fullPomodoro


unstartedShortBreak =
    Inactive ShortBreak fullShortBreak


unstartedLongBreak =
    Inactive LongBreak fullLongBreak


noPastPomodoros =
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
