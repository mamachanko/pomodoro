module Timer.ViewTests exposing (..)

import Timer exposing (..)
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
                    view (Active Pomodoro <| Time.minute * 12 + Time.second * 34)
                        |> Query.fromHtml
                        |> Query.find [ id "time" ]
                        |> Query.has [ text ("12:34") ]
            , test "should display an inactive session" <|
                \() ->
                    view (Inactive Pomodoro <| Time.minute * 12 + Time.second * 34)
                        |> Query.fromHtml
                        |> Query.find [ id "time" ]
                        |> Query.has [ text ("12:34") ]
            , test "should display an overflowing session" <|
                \() ->
                    view (Over Pomodoro <| Time.minute * 12 + Time.second * 34)
                        |> Query.fromHtml
                        |> Query.find [ id "time" ]
                        |> Query.has [ text ("-12:34") ]
            ]
        , describe "controls"
            [ test "should display a button to start a Pomodoro" <|
                \() ->
                    view init
                        |> Query.fromHtml
                        |> Query.find [ tag "button", id "startPomodoro" ]
                        |> Query.has [ text "Pomodoro" ]
            , test "should display a button to start a short break" <|
                \() ->
                    view init
                        |> Query.fromHtml
                        |> Query.find [ tag "button", id "startShortBreak" ]
                        |> Query.has [ text "Short break" ]
            , test "should display a button to start a long break" <|
                \() ->
                    view init
                        |> Query.fromHtml
                        |> Query.find [ tag "button", id "startLongBreak" ]
                        |> Query.has [ text "Long break" ]
            ]
        ]
