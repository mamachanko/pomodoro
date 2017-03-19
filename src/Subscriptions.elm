module Subscriptions exposing (subscriptions)

import Model exposing (Model, Session(Inactive, Active, Over), Action(Tick))
import Time exposing (every, second)


subscriptions : Model.Model -> Sub Model.Action
subscriptions { currentSession } =
    case currentSession of
        Inactive _ _ ->
            Sub.none

        Active _ _ ->
            every second Tick

        Over _ _ ->
            every second Tick
