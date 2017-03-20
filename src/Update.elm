module Update exposing (update)

import Model exposing (..)
import Sound exposing (ringBell)
import Time


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        StartPomodoro ->
            ( { model | currentSession = freshPomodoro }, Cmd.none )

        StartShortBreak ->
            ( { model | currentSession = freshShortBreak }, Cmd.none )

        StartLongBreak ->
            ( { model | currentSession = freshLongBreak }, Cmd.none )

        Tick time ->
            case model of
                { currentSession } ->
                    case currentSession of
                        Over sessionType overflow ->
                            ( { model | currentSession = Over sessionType (countUp overflow) }, Cmd.none )

                        Active sessionType remainder ->
                            updateActiveSession model sessionType remainder

                        _ ->
                            ( model, Cmd.none )


updateActiveSession model sessionType remainder =
    let
        newRemainder =
            countDown remainder
    in
        if (newRemainder == 0) then
            finishedSession model sessionType
        else
            activeSession model sessionType newRemainder


finishedSession model finishedSessionType =
    ( { model
        | currentSession = Over finishedSessionType 0
        , pastSessions = finishedSessionType :: model.pastSessions
      }
    , ringBell
    )


activeSession model activeSessionType remainder =
    ( { model
        | currentSession = Active activeSessionType remainder
      }
    , Cmd.none
    )


countDown =
    (+) (Time.second * -1)


countUp =
    (+) Time.second
