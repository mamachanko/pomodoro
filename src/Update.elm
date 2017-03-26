module Update exposing (update)

import Model exposing (..)
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

        KeyboardEvent keycode ->
            updateKeyboardEvent model keycode

        Tick time ->
            updateTick model time

        EnableDesktopNotifications ->
            ( model, Notifications.enableDesktopNotifications )

        RecordPomodoro ->
            ( { model
                | pastPomodoros = model.currentText :: model.pastPomodoros
                , currentText = ""
                , showPomodoroLogInput = False
              }
            , Cmd.none
            )

        TextInput input ->
            ( { model | currentText = input }, Cmd.none )


updateTick : Model -> Time.Time -> ( Model, Cmd action )
updateTick model time =
    case model of
        { currentSession } ->
            case currentSession of
                Over sessionType overflow ->
                    ( { model | currentSession = Over sessionType (countUp overflow) }, Cmd.none )

                Active sessionType remainder ->
                    updateActiveSession model sessionType remainder

                _ ->
                    ( model, Cmd.none )


updateActiveSession : Model -> SessionType -> Remainder -> ( Model, Cmd action )
updateActiveSession model sessionType remainder =
    let
        newRemainder =
            countDown remainder
    in
        if (newRemainder == 0) then
            finishedSession model sessionType
        else
            activeSession model sessionType newRemainder


updateKeyboardEvent model keycode =
    case keycode of
        960 ->
            ( { model | currentSession = freshPomodoro }, Cmd.none )

        223 ->
            ( { model | currentSession = freshShortBreak }, Cmd.none )

        172 ->
            ( { model | currentSession = freshLongBreak }, Cmd.none )

        _ ->
            ( model, Cmd.none )


finishedSession : Model -> SessionType -> ( Model, Cmd action )
finishedSession model finishedSessionType =
    let
        newSession =
            Over finishedSessionType 0

        newModel =
            case finishedSessionType of
                Pomodoro ->
                    { model | currentSession = newSession, showPomodoroLogInput = True }

                _ ->
                    { model | currentSession = newSession }
    in
        ( newModel, endOfSessionNotification finishedSessionType )


endOfSessionNotification sessionType =
    case sessionType of
        Pomodoro ->
            Notifications.notifyEndOfPomodoro

        _ ->
            Notifications.notifyEndOfBreak


activeSession model activeSessionType remainder =
    ( { model | currentSession = Active activeSessionType remainder }, Cmd.none )


countDown =
    (+) (Time.second * -1)


countUp =
    (+) Time.second
