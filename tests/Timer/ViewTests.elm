module Timer.ViewTests exposing (..)

import Html
import App exposing (..)
import Time
import Test exposing (..)
import Expect
import Test.Html.Query as Query
import Test.Html.Selector exposing (id, tag, text, attribute, class)


all : Test
all =
    describe "Timer.view"
        [ describe "timer"
            [ test "should display an active session" <|
                \() ->
                    viewTimer (Active Pomodoro <| Time.minute * 12 + Time.second * 34)
                        |> List.singleton
                        |> Html.div []
                        |> Query.fromHtml
                        |> Query.find [ id "timer" ]
                        |> Query.has [ text ("12:34") ]
            , test "should display an inactive session" <|
                \() ->
                    viewTimer (Inactive Pomodoro <| Time.minute * 12 + Time.second * 34)
                        |> List.singleton
                        |> Html.div []
                        |> Query.fromHtml
                        |> Query.find [ id "timer" ]
                        |> Query.has [ text ("12:34") ]
            , test "should display an overflowing session" <|
                \() ->
                    viewTimer (Over Pomodoro <| Time.minute * 12 + Time.second * 34)
                        |> List.singleton
                        |> Html.div []
                        |> Query.fromHtml
                        |> Query.find [ id "timer" ]
                        |> Query.has [ text ("-12:34") ]
            ]
        ]
