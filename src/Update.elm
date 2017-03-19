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

        StartLongBreak ->
            ( freshLongBreak, Cmd.none )

        Tick time ->
            case model of
                Inactive _ _ ->
                    ( model, Cmd.none )

                Active session remainder ->
                    updateActiveSession session remainder

                Over session overflow ->
                    ( Over session (countUp overflow), Cmd.none )


updateActiveSession session remainder =
    let
        newRemainder =
            countDown remainder
    in
        if (newRemainder == 0) then
            ( Over session 0, ringBell )
        else
            ( Active session newRemainder, Cmd.none )


countDown =
    (+) (Time.second * -1)


countUp =
    (+) Time.second
