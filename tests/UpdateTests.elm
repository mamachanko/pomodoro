module UpdateTests exposing (..)

import Pomodoro exposing (..)
import Sound exposing (..)
import Test exposing (..)
import Expect


describeUpdate : Test
describeUpdate =
    describe "update"
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
                        |> Expect.equal ( (runningPomodoro (toTimeRemaining 0 0)), ringBell )
            , test "when the Pomodoro is up beyond a minute" <|
                \() ->
                    update tick (runningPomodoro (toTimeRemaining 0 -59))
                        |> Expect.equal ( (runningPomodoro (toTimeRemaining -1 0)), Cmd.none )
            ]
        ]
