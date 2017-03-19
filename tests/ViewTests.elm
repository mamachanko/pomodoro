module ViewTests exposing (..)

import Expect
import Model exposing (Model, Session(..), SessionType(..))
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (id, tag, text)
import Time
import View exposing (view)


anActiveSession =
    { currentSession = (Active Pomodoro (Time.minute * 12 + Time.second * 34))
    , pomodoroCount = 12
    }


anInactiveSession =
    { currentSession = (Inactive Pomodoro (Time.minute * 12 + Time.second * 34))
    , pomodoroCount = 12
    }


anOverflowingPomodoro =
    { currentSession = (Over Pomodoro (Time.minute * 12 + Time.second * 34))
    , pomodoroCount = 12
    }


anOverflowingShortBreak =
    { currentSession = (Over ShortBreak (Time.minute * 12 + Time.second * 34))
    , pomodoroCount = 12
    }


anOverflowingLongBreak =
    { currentSession = (Over LongBreak (Time.minute * 12 + Time.second * 34))
    , pomodoroCount = 12
    }


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
                    view anOverflowingPomodoro
                        |> Query.fromHtml
                        |> Query.find [ id "timer" ]
                        |> Query.has [ text ("-12:34") ]
            ]
        , describe "pomodoro counter"
            [ test "displays the number of Pomodoros done" <|
                \() ->
                    view anActiveSession
                        |> Query.fromHtml
                        |> Query.find [ id "counter" ]
                        |> Query.has [ text ("12") ]
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
                    view anOverflowingPomodoro
                        |> Query.fromHtml
                        |> Query.find [ id "message" ]
                        |> Query.has [ text "It's break-y time" ]
            , test "displays a message for an overflowing short break" <|
                \() ->
                    view anOverflowingShortBreak
                        |> Query.fromHtml
                        |> Query.find [ id "message" ]
                        |> Query.has [ text "Ora di pomodoro!" ]
            , test "displays a message for an overflowing long break" <|
                \() ->
                    view anOverflowingLongBreak
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
