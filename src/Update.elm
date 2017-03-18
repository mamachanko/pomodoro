module Update exposing (update)

import Model exposing (..)
import Sound exposing (ringBell)
import Time


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        StartPomodoro ->
            ( freshPomodoro, Cmd.none )

        StartShortBreak ->
            ( freshShortBreak, Cmd.none )

        Tick time ->
            case model of
                Inactive _ _ ->
                    ( model, Cmd.none )

                Active session remainder ->
                    updateActiveSession session remainder


updateActiveSession session timeRemaining =
    let
        newRemainder =
            countDown timeRemaining

        cmd =
            if newRemainder == 0 then
                ringBell
            else
                Cmd.none

        newActiveSession =
            Active session newRemainder
    in
        ( newActiveSession, cmd )


countDown =
    (+) (Time.second * -1)
