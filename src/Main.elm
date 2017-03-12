module Main exposing (main)

import Pomodoro exposing (init, view, update)
import Html


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \a -> Sub.none
        }
