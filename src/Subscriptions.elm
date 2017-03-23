module Subscriptions exposing (subscriptions)

import Model exposing (Model, Session(Inactive, Active, Over), Action(Tick, KeyboardEvent))
import Time exposing (every, second)
import Keyboard


subscriptions : Model.Model -> Sub Model.Action
subscriptions { currentSession } =
    let
        keyPresses =
            Keyboard.presses KeyboardEvent

        seconds =
            every second Tick
    in
        case currentSession of
            Inactive _ _ ->
                keyPresses

            _ ->
                Sub.batch [ seconds, keyPresses ]
