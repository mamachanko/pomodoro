module Pomodoro exposing (..)

import Date exposing (toTime)
import Html exposing (Html, div, td, text)
import Html.Events exposing (onClick)
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
    | Tick Time.Time


tick : Action
tick =
    Tick Time.second


startPomodoro =
    StartPomodoro


view : Model -> Html Action
view model =
    div [ onClick StartPomodoro ]
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
          if timeRemaining >= 0 then
            formatTimeRemaining timeRemaining
          else
            "-" ++ (formatTimeRemaining (abs timeRemaining))



formatTimeRemaining : TimeRemaining -> String
formatTimeRemaining timeRemaining =
    (formatMinutes timeRemaining) ++ ":" ++ (formatSeconds timeRemaining)


formatMinutes : TimeRemaining -> String
formatMinutes timeRemaining =
    let
        minutes =
            truncate (Time.inMinutes timeRemaining)
    in
        if minutes == 0 then
            "00"
        else if minutes < 10 then
            "0" ++ toString minutes
        else
            toString minutes


formatSeconds : TimeRemaining -> String
formatSeconds timeRemaining =
    let
        seconds =
            Time.inSeconds <|
                toFloat <|
                    (truncate timeRemaining)
                        % (truncate Time.minute)
    in
        if seconds == 0 then
            "00"
        else if seconds < 10 then
            "0" ++ toString seconds
        else
            toString seconds


init =
    ( unstartedPomodoro, Cmd.none )


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        StartPomodoro ->
            ( freshPomodoro, Cmd.none )

        Tick time ->
            case model of
                UnstartedPomodoro ->
                    ( unstartedPomodoro, Cmd.none )

                RunningPomodoro timeRemaining ->
                    ( runningPomodoro (timeRemaining - Time.second), Cmd.none )


subscriptions : Model -> Sub Action
subscriptions model =
    case model of
        UnstartedPomodoro ->
            Sub.none

        RunningPomodoro _ ->
            Time.every Time.second Tick
