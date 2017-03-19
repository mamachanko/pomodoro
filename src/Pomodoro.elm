module Pomodoro exposing (..)

import Model exposing (init)
import Update exposing (update)
import View exposing (view)
import Subscriptions exposing (subscriptions)
import Html exposing (program)


main =
    program
        { init = ( init, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
