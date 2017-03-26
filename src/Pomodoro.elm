module Pomodoro exposing (..)

import Html exposing (program)
import Model exposing (initialModel)
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view)


main =
    program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
