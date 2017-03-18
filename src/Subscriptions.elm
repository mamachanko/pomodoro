module Subscriptions exposing (subscriptions)

import Model
import Time


subscriptions : Model.Model -> Sub Model.Action
subscriptions model =
    case model of
        Model.Inactive _ _ ->
            Sub.none

        Model.Active _ _ ->
            Time.every Time.second Model.Tick
