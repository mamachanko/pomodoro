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
                    view unstartedPomodoro
                        |> Query.fromHtml
                        |> Query.has [ text "Pomodoro" ]
            , test "displays an unstarted timer" <|
                \() ->
                    view unstartedPomodoro
                        |> Query.fromHtml
                        |> Query.has [ text "--:--" ]
            , test "displays an started timer" <|
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
                        update Tick (freshPomodoro)
                            |> Expect.equal ( (runningPomodoro (toTimeRemaining 24 59)), Cmd.none )
                , test "when it is a running Pomodoro" <|
                    \() ->
                        update Tick (runningPomodoro (toTimeRemaining 18 27))
                            |> Expect.equal ( (runningPomodoro (toTimeRemaining 18 26)), Cmd.none )
                ]
            ]
        ]
