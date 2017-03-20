module ViewTests exposing (..)

import Expect
import Model exposing (Model, Session(..), SessionType(..))
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (id, tag, text)
import Time
import View exposing (view)


describeView : Test
describeView =
    describe "view"
        [ test "displays a message" <|
            \() ->
                view (Model (Active Pomodoro (Time.minute * 12 + Time.second * 34)) [])
                    |> Query.fromHtml
                    |> Query.find [ id "header" ]
                    |> Query.has [ text "Pomodoro" ]
        , describe "timer"
            [ test "displays a active session" <|
                \() ->
                    view (Model (Active Pomodoro (Time.minute * 12 + Time.second * 34)) [])
                        |> Query.fromHtml
                        |> Query.find [ id "timer" ]
                        |> Query.has [ text ("12:34") ]
            , test "displays a inactive session" <|
                \() ->
                    view (Model (Inactive Pomodoro (Time.minute * 12 + Time.second * 34)) [])
                        |> Query.fromHtml
                        |> Query.find [ id "timer" ]
                        |> Query.has [ text ("12:34") ]
            , test "displays an overflowing session" <|
                \() ->
                    view (Model (Over Pomodoro (Time.minute * 12 + Time.second * 34)) [])
                        |> Query.fromHtml
                        |> Query.find [ id "timer" ]
                        |> Query.has [ text ("-12:34") ]
            ]
        , describe "pomodoro counter"
            [ test "displays the number of Pomodoros done" <|
                \() ->
                    view (Model (Over Pomodoro 0) [ Pomodoro, Pomodoro ])
                        |> Query.fromHtml
                        |> Query.find [ id "counter" ]
                        |> Query.has [ text ("2") ]
            ]
        , describe "message"
            [ test "displays no message for an active session" <|
                \() ->
                    view (Model (Active Pomodoro (Time.minute * 12 + Time.second * 34)) [])
                        |> Query.fromHtml
                        |> Query.findAll [ id "message" ]
                        |> Query.count (Expect.equal 0)
            , test "displays no message for an inactive session" <|
                \() ->
                    view (Model (Inactive Pomodoro (Time.minute * 12 + Time.second * 34)) [])
                        |> Query.fromHtml
                        |> Query.findAll [ id "message" ]
                        |> Query.count (Expect.equal 0)
            , test "displays a message for an overflowing Pomodoro" <|
                \() ->
                    view (Model (Over Pomodoro 0) [])
                        |> Query.fromHtml
                        |> Query.find [ id "message" ]
                        |> Query.has [ text "It's break-y time" ]
            , test "displays a message for an overflowing Pomodoro after four Pomodoros" <|
                \() ->
                    view (Model (Over Pomodoro 0) (List.repeat 4 Pomodoro))
                        |> Query.fromHtml
                        |> Query.find [ id "message" ]
                        |> Query.has [ text "You should take a long break" ]
            , test "displays a message for an overflowing Pomodoro after eight Pomodoros" <|
                \() ->
                    view (Model (Over Pomodoro 0) (List.repeat 8 Pomodoro))
                        |> Query.fromHtml
                        |> Query.find [ id "message" ]
                        |> Query.has [ text "You should take a long break" ]
            , test "displays a message for an overflowing short break" <|
                \() ->
                    view (Model (Over ShortBreak 0) [])
                        |> Query.fromHtml
                        |> Query.find [ id "message" ]
                        |> Query.has [ text "Ora di pomodoro!" ]
            , test "displays a message for an overflowing long break" <|
                \() ->
                    view (Model (Over LongBreak 0) [])
                        |> Query.fromHtml
                        |> Query.find [ id "message" ]
                        |> Query.has [ text "Ora di pomodoro!" ]
            ]
        , describe "controls"
            [ test "displays a button to start a Pomodoro" <|
                \() ->
                    view (Model (Over LongBreak 0) [])
                        |> Query.fromHtml
                        |> Query.find [ tag "button", id "startPomodoro" ]
                        |> Query.has [ text "Pomodoro" ]
            , test "displays a button to start a short break" <|
                \() ->
                    view (Model (Over LongBreak 0) [])
                        |> Query.fromHtml
                        |> Query.find [ tag "button", id "startShortBreak" ]
                        |> Query.has [ text "Short break" ]
            , test "displays a button to start a long break" <|
                \() ->
                    view (Model (Over LongBreak 0) [])
                        |> Query.fromHtml
                        |> Query.find [ tag "button", id "startLongBreak" ]
                        |> Query.has [ text "Long break" ]
            ]
        ]
