module Pomodoro exposing (..)

import Model exposing (initialModel)
import Update exposing (update)
import View exposing (view)
import Subscriptions exposing (subscriptions)
import Html exposing (program)


main =
    program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
