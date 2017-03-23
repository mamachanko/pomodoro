module Update exposing (update)

import Model exposing (..)
import Sound
import Notifications
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

        EnableDesktopNotifications ->
            ( model, Notifications.enableDesktopNotifications )

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
    let
        newPastSessions =
            finishedSessionType :: model.pastSessions
    in
        ( { model
            | currentSession = Over finishedSessionType 0
            , pastSessions = newPastSessions
          }
        , endOfSessionNotification finishedSessionType
        )


endOfSessionNotification sessionType =
    case sessionType of
        Pomodoro ->
            Notifications.notifyEndOfPomodoro

        _ ->
            Notifications.notifyEndOfBreak


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
