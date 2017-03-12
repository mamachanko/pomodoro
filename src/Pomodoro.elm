module Pomodoro exposing (..)

import Date exposing (toTime)
import Html exposing (Html, div, text)
import Time


type alias TimeRemaining =
    Float


toTimeRemaining : Float -> Float -> TimeRemaining
toTimeRemaining minutes seconds =
    (Time.minute * minutes) + (Time.second * seconds)


fullPomodoro : TimeRemaining
fullPomodoro =
    toTimeRemaining 25 0


type Model
    = UnstartedPomodoro
    | RunningPomodoro TimeRemaining


unstartedPomodoro =
    UnstartedPomodoro


freshPomodoro : Model
freshPomodoro =
    RunningPomodoro fullPomodoro


runningPomodoro : TimeRemaining -> Model
runningPomodoro timeRemaining =
    RunningPomodoro timeRemaining


type Action
    = StartPomodoro
    | Tick


startPomodoro =
    StartPomodoro


view : Model -> Html Action
view model =
    div []
        [ text "Pomodoro"
        , div
            []
            [ text (formatPomodoro model) ]
        ]


formatPomodoro : Model -> String
formatPomodoro model =
    case model of
        UnstartedPomodoro ->
            "--:--"

        RunningPomodoro timeRemaining ->
            formatTimeRemaining timeRemaining


formatTimeRemaining : TimeRemaining -> String
formatTimeRemaining timeRemaining =
    (formatMinutes timeRemaining) ++ ":" ++ (formatSeconds timeRemaining)


formatMinutes : TimeRemaining -> String
formatMinutes timeRemaining =
    toString <|
        truncate <|
            Time.inMinutes timeRemaining


formatSeconds : TimeRemaining -> String
formatSeconds timeRemaining =
    toString <|
        (truncate timeRemaining)
            % (truncate (Time.second * 60))


init =
    ( unstartedPomodoro, Cmd.none )


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        StartPomodoro ->
            ( freshPomodoro, Cmd.none )

        Tick ->
            case model of
                UnstartedPomodoro ->
                    ( unstartedPomodoro, Cmd.none )

                RunningPomodoro timeRemaining ->
                    ( runningPomodoro (timeRemaining - Time.second), Cmd.none )
