module ViewTests exposing (..)

import Expect
import Model exposing (Model(Active, Inactive, Over), Session(Pomodoro, ShortBreak, LongBreak))
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (id, tag, text)
import Time
import View exposing (view)


anActiveSession =
    (Active Pomodoro (Time.minute * 12 + Time.second * 34))


anInactiveSession =
    (Inactive Pomodoro (Time.minute * 12 + Time.second * 34))


anOverflowingSession =
    (Over Pomodoro (Time.minute * 12 + Time.second * 34))


describeView : Test
describeView =
    describe "view"
        [ test "displays a message" <|
            \() ->
                view anActiveSession
                    |> Query.fromHtml
                    |> Query.find [ id "header" ]
                    |> Query.has [ text "Pomodoro" ]
        , describe "timer"
            [ test "displays a active session" <|
                \() ->
                    view anActiveSession
                        |> Query.fromHtml
                        |> Query.find [ id "timer" ]
                        |> Query.has [ text ("12:34") ]
            , test "displays a inactive session" <|
                \() ->
                    view anActiveSession
                        |> Query.fromHtml
                        |> Query.find [ id "timer" ]
                        |> Query.has [ text ("12:34") ]
            , test "displays an overflowing session" <|
                \() ->
                    view anOverflowingSession
                        |> Query.fromHtml
                        |> Query.find [ id "timer" ]
                        |> Query.has [ text ("-12:34") ]
            ]
        , describe "message"
            [ test "displays no message for an active session" <|
                \() ->
                    view anActiveSession
                        |> Query.fromHtml
                        |> Query.findAll [ id "message" ]
                        |> Query.count (Expect.equal 0)
            , test "displays no message for an inactive session" <|
                \() ->
                    view anActiveSession
                        |> Query.fromHtml
                        |> Query.findAll [ id "message" ]
                        |> Query.count (Expect.equal 0)
            , test "displays a message for an overflowing Pomodoro" <|
                \() ->
                    view (Over Pomodoro 123)
                        |> Query.fromHtml
                        |> Query.find [ id "message" ]
                        |> Query.has [ text "It's break-y time" ]
            , test "displays a message for an overflowing short break" <|
                \() ->
                    view (Over ShortBreak 123)
                        |> Query.fromHtml
                        |> Query.find [ id "message" ]
                        |> Query.has [ text "Ora di pomodoro!" ]
            , test "displays a message for an overflowing long break" <|
                \() ->
                    view (Over LongBreak 123)
                        |> Query.fromHtml
                        |> Query.find [ id "message" ]
                        |> Query.has [ text "Ora di pomodoro!" ]
            ]
        , describe "controls"
            [ test "displays a button to start a Pomodoro" <|
                \() ->
                    view anActiveSession
                        |> Query.fromHtml
                        |> Query.find [ tag "button", id "startPomodoro" ]
                        |> Query.has [ text "Pomodoro" ]
            , test "displays a button to start a short break" <|
                \() ->
                    view anActiveSession
                        |> Query.fromHtml
                        |> Query.find [ tag "button", id "startShortBreak" ]
                        |> Query.has [ text "Short break" ]
            , test "displays a button to start a long break" <|
                \() ->
                    view anActiveSession
                        |> Query.fromHtml
                        |> Query.find [ tag "button", id "startLongBreak" ]
                        |> Query.has [ text "Long break" ]
            ]
        ]
