module Tests exposing (..)

import Pomodoro exposing (..)
import Sound exposing (playSound)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, boolAttribute)
import Expect
import Time


all : Test
all =
    describe "Pomodoro"
        [ describe "view"
            [ test "displays a message" <|
                \() ->
                    view unstartedPomodoro
                        |> Query.fromHtml
                        |> Query.has [ text "Pomodoro" ]
            , test "displays an unstarted Pomodoro" <|
                \() ->
                    view unstartedPomodoro
                        |> Query.fromHtml
                        |> Query.has [ text "--:--" ]
            , test "displays a running Pomodoro" <|
                \() ->
                    view (runningPomodoro (toTimeRemaining 18 27))
                        |> Query.fromHtml
                        |> Query.has [ text "18:27" ]
            ]
        , describe "init"
            [ test "initialises as unstarted Pomodoro" <|
                \() ->
                    init |> Expect.equal ( unstartedPomodoro, Cmd.none )
            ]
        , describe "update"
            [ test "starts a Pomodoro" <|
                \() ->
                    update StartPomodoro unstartedPomodoro
                        |> Expect.equal ( freshPomodoro, Cmd.none )
            , describe "counts a Pomodoro down"
                [ test "when it is a fresh Pomodoro" <|
                    \() ->
                        update tick (freshPomodoro)
                            |> Expect.equal ( (runningPomodoro (toTimeRemaining 24 59)), Cmd.none )
                , test "when it is a running Pomodoro" <|
                    \() ->
                        update tick (runningPomodoro (toTimeRemaining 18 27))
                            |> Expect.equal ( (runningPomodoro (toTimeRemaining 18 26)), Cmd.none )
                , test "when the Pomodoro is up" <|
                    \() ->
                        update tick (runningPomodoro (toTimeRemaining 0 1))
                            |> Expect.equal ( (runningPomodoro (toTimeRemaining 0 0)), playSound "" )
                , test "when the Pomodoro is up beyond a minute" <|
                    \() ->
                        update tick (runningPomodoro (toTimeRemaining 0 -59))
                            |> Expect.equal ( (runningPomodoro (toTimeRemaining -1 0)), Cmd.none )
                ]
            ]
        , describe "subscriptions"
            [ test "does nothing for an unstarted Pomodoro" <|
                \() ->
                    subscriptions unstartedPomodoro
                        |> Expect.equal Sub.none
            , test "emits Tick every second for a running Pomodoro" <|
                \() ->
                    subscriptions freshPomodoro
                        |> Expect.equal (Time.every Time.second Tick)
            ]
        , describe "formatting"
            [ test "formats an unstarted Pomodoro" <|
                \() ->
                    formatPomodoro unstartedPomodoro
                        |> Expect.equal "--:--"
            , test "formats a fresh Pomodoro" <|
                \() ->
                    formatPomodoro freshPomodoro
                        |> Expect.equal "25:00"
            , test "formats a started Pomodoro" <|
                \() ->
                    formatPomodoro (runningPomodoro (toTimeRemaining 18 27))
                        |> Expect.equal "18:27"
            , test "formats another started Pomodoro" <|
                \() ->
                    formatPomodoro (runningPomodoro (toTimeRemaining 8 7))
                        |> Expect.equal "08:07"
            , test "formats a finished Pomodoro" <|
                \() ->
                    formatPomodoro (runningPomodoro (toTimeRemaining 0 0))
                        |> Expect.equal "00:00"
            , test "formats a finished Pomodoro beyond 00:00" <|
                \() ->
                    formatPomodoro (runningPomodoro (toTimeRemaining -2 -5))
                        |> Expect.equal "-02:05"
            ]
        ]
