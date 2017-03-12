module Pomodoro exposing (view, init, update, noAction)

import Html exposing (div, text)


type Action
    = NoAction


noAction =
    NoAction


view model =
    div [] [ text "Pomodoro" ]


init =
    ( "", Cmd.none )


update : Action -> String -> ( String, Cmd Action )
update action model =
    ( model, Cmd.none )
