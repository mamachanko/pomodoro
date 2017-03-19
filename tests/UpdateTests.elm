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
        [ describe "Pomodoro" <|
            [ test "when it starts" <|
                \() ->
                    update StartPomodoro unstartedPomodoro
                        |> Expect.equal ( freshPomodoro, Cmd.none )
            , test "when it is counting down" <|
                \() ->
                    update tick (Active Pomodoro (Time.minute * 2 + Time.second * 24))
                        |> Expect.equal ( Active Pomodoro (Time.minute * 2 + Time.second * 23), Cmd.none )
            , test "when it is up" <|
                \() ->
                    update tick (Active Pomodoro (Time.second * 1))
                        |> Expect.equal ( Over Pomodoro 0, ringBell )
            , test "when it is running over" <|
                \() ->
                    update tick (Over Pomodoro 0)
                        |> Expect.equal ( Over Pomodoro Time.second, Cmd.none )
            , test "when it continues to run over" <|
                \() ->
                    update tick (Over Pomodoro (Time.second * 59))
                        |> Expect.equal ( Over Pomodoro Time.minute, Cmd.none )
            ]
        , describe "short break" <|
            [ test "when it starts" <|
                \() ->
                    update StartShortBreak unstartedShortBreak
                        |> Expect.equal ( freshShortBreak, Cmd.none )
            , test "when it is counting down" <|
                \() ->
                    update tick (Active ShortBreak (Time.minute * 2 + Time.second * 24))
                        |> Expect.equal ( Active ShortBreak (Time.minute * 2 + Time.second * 23), Cmd.none )
            , test "when it is up" <|
                \() ->
                    update tick (Active ShortBreak Time.second)
                        |> Expect.equal ( Over ShortBreak 0, ringBell )
            , test "when it is running over" <|
                \() ->
                    update tick (Over ShortBreak 0)
                        |> Expect.equal ( Over ShortBreak Time.second, Cmd.none )
            , test "when it continues to run over" <|
                \() ->
                    update tick (Over ShortBreak (Time.second * 59))
                        |> Expect.equal ( Over ShortBreak Time.minute, Cmd.none )
            ]
        , describe "long break" <|
            [ test "when it starts" <|
                \() ->
                    update StartLongBreak unstartedLongBreak
                        |> Expect.equal ( freshLongBreak, Cmd.none )
            , test "when it is counting down" <|
                \() ->
                    update tick (Active LongBreak (Time.minute * 2 + Time.second * 24))
                        |> Expect.equal ( Active LongBreak (Time.minute * 2 + Time.second * 23), Cmd.none )
            , test "when it is up" <|
                \() ->
                    update tick (Active LongBreak (Time.second * 1))
                        |> Expect.equal ( Over LongBreak 0, ringBell )
            , test "when it is running over" <|
                \() ->
                    update tick (Over LongBreak 0)
                        |> Expect.equal ( Over LongBreak Time.second, Cmd.none )
            , test "when it continues to run over" <|
                \() ->
                    update tick (Over LongBreak (Time.second * 59))
                        |> Expect.equal ( Over LongBreak Time.minute, Cmd.none )
            ]
        ]
