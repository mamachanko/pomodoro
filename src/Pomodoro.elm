module Pomodoro exposing (..)

import Html exposing (programWithFlags)
import Model exposing (initialModel, Model, Action)
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view)


init : List String -> ( Model, Cmd Action )
init pomodoroLog =
    ( { initialModel | pastPomodoros = pomodoroLog }, Cmd.none )


main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
