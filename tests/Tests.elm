module Tests exposing (..)

import Pomodoro exposing (..)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text)
import Expect


all : Test
all =
    describe "Pomodoro"
        [ describe "view"
            [ test "displays a message" <|
                \() ->
                    view Nothing
                        |> Query.fromHtml
                        |> Query.has [ text "Pomodoro" ]
            ]
        , describe "model"
            [ test "initialises as empty String with no Cmd" <|
                \() ->
                    init |> Expect.equal ( "", Cmd.none )
            ]
        , describe "update"
            [ test "does nothing to the model" <|
                \() ->
                    update noAction ""
                        |> Expect.equal ( "", Cmd.none )
            ]
        ]
