module Main exposing (main)

import Html
import Pomodoro exposing (init, subscriptions, update, view)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
