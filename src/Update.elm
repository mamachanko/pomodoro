module Update exposing (update)

import Model exposing (..)
import Sound exposing (ringBell)
import Time


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        StartPomodoro ->
            ( freshPomodoro, Cmd.none )

        Tick time ->
            case model of
                Inactive _ _ ->
                    ( unstartedPomodoro, Cmd.none )

                Active _ remainder ->
                    updateActiveSession model remainder


updateActiveSession model timeRemaining =
    let
        newRemainder =
            (timeRemaining - Time.second)

        newActiveSession =
            activePomodoro newRemainder
    in
        if newRemainder == 0 then
            ( newActiveSession, ringBell )
        else
            ( newActiveSession, Cmd.none )
