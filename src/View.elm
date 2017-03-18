module View exposing (view)

import Model exposing (..)
import Format exposing (formatTime)
import Html exposing (Html, div, td, text, audio, source, button)
import Html.Events exposing (onClick)


view : Model -> Html Action
view model =
    div [ onClick StartPomodoro ]
        [ text "Pomodoro"
        , div
            []
            [ div [] [ text (formatSession model) ]
            , div [] [ button [ onClick StartPomodoro ] [ text "Pomodoro" ] ]
            ]
        ]


formatSession : Model -> String
formatSession model =
    case model of
        Active _ remainder ->
            formatTime remainder

        Inactive _ remainder ->
            formatTime remainder
