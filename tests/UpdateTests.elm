module UpdateTests exposing (..)

import Update exposing (update)
import Model exposing (..)
import Sound exposing (..)
import Time
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
                        |> Expect.equal ( (activePomodoro (Time.minute * 24 + Time.second * 59)), Cmd.none )
            , test "when it is a running Pomodoro" <|
                \() ->
                    update tick (activePomodoro (Time.minute * 18 + Time.second * 27))
                        |> Expect.equal ( (activePomodoro (Time.minute * 18 + Time.second * 26)), Cmd.none )
            , test "when the Pomodoro is up" <|
                \() ->
                    update tick (activePomodoro (Time.second * 1))
                        |> Expect.equal ( activePomodoro 0, ringBell )
            , test "when the Pomodoro is up beyond a minute" <|
                \() ->
                    update tick (activePomodoro (Time.second * -59))
                        |> Expect.equal ( (activePomodoro (Time.minute * -1)), Cmd.none )
            ]
        ]
