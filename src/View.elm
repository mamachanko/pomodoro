module View exposing (view)

import Model exposing (..)
import Format exposing (formatTime)
import Html exposing (Html, div, td, text, audio, source, button)
import Html.Attributes exposing (id)
import Html.Events exposing (onClick)


view : Model -> Html Action
view model =
    div []
        [ text "Pomodoro"
        , div
            []
            [ div [] [ text (formatSession model) ]
            , div []
                [ button
                    [ id "startPomodoro"
                    , onClick StartPomodoro
                    ]
                    [ text "Pomodoro" ]
                ]
            , div []
                [ button
                    [ id "startShortBreak"
                    , onClick StartShortBreak
                    ]
                    [ text "Short break" ]
                ]
            , div []
                [ button
                    [ id "startLongBreak"
                    , onClick StartLongBreak
                    ]
                    [ text "Long break" ]
                ]
            ]
        ]


formatSession : Model -> String
formatSession model =
    case model of
        Active _ time ->
            formatTime time

        Inactive _ time ->
            formatTime time
