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
        , test "starts a short break" <|
            \() ->
                update StartShortBreak unstartedPomodoro
                    |> Expect.equal ( freshShortBreak, Cmd.none )
        , test "starts a long break" <|
            \() ->
                update StartLongBreak unstartedPomodoro
                    |> Expect.equal ( freshLongBreak, Cmd.none )
        , describe "counts an active session down"
            [ test "when it is a fresh session" <|
                \() ->
                    update tick (Active Pomodoro (Time.minute * 18 + Time.second * 36))
                        |> Expect.equal ( (Active Pomodoro (Time.minute * 18 + Time.second * 35)), Cmd.none )
            , test "when the Pomodoro is up" <|
                \() ->
                    update tick (Active Pomodoro (Time.second * 1))
                        |> Expect.equal ( Active Pomodoro 0, ringBell )
            , test "when the short break is up" <|
                \() ->
                    update tick (Active ShortBreak (Time.second * 1))
                        |> Expect.equal ( Active ShortBreak 0, ringBell )
            , test "when the Pomodoro is up beyond a minute" <|
                \() ->
                    update tick (Active Pomodoro (Time.second * -59))
                        |> Expect.equal ( (Active Pomodoro (Time.minute * -1)), Cmd.none )
            , test "when the short break is up beyond a minute" <|
                \() ->
                    update tick (Active ShortBreak (Time.second * -59))
                        |> Expect.equal ( (Active ShortBreak (Time.minute * -1)), Cmd.none )
            ]
        ]
