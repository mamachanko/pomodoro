module UpdateTests exposing (..)

import Update exposing (update)
import Model exposing (..)
import Sound exposing (..)
import Time
import Test exposing (..)
import Expect


withPomodoroCounter session =
    { currentSession = session, pomodoroCount = 123 }


describeUpdate : Test
describeUpdate =
    describe "update"
        [ describe "Pomodoro" <|
            [ test "when it starts" <|
                \() ->
                    withPomodoroCounter unstartedPomodoro
                        |> update StartPomodoro
                        |> Expect.equal ( withPomodoroCounter freshPomodoro, Cmd.none )
            , test "when it is counting down" <|
                \() ->
                    withPomodoroCounter (Active Pomodoro (Time.minute * 2 + Time.second * 24))
                        |> update tick
                        |> Expect.equal ( withPomodoroCounter (Active Pomodoro (Time.minute * 2 + Time.second * 23)), Cmd.none )
            , test "when it is up" <|
                \() ->
                    { currentSession = (Active Pomodoro (Time.second * 1)), pomodoroCount = 2 }
                        |> update tick
                        |> Expect.equal
                            ( { currentSession = (Over Pomodoro 0), pomodoroCount = 3 }
                            , ringBell
                            )
            , test "when it is running over" <|
                \() ->
                    withPomodoroCounter (Over Pomodoro 0)
                        |> update tick
                        |> Expect.equal ( withPomodoroCounter (Over Pomodoro Time.second), Cmd.none )
            , test "when it continues to run over" <|
                \() ->
                    withPomodoroCounter (Over Pomodoro (Time.second * 59))
                        |> update tick
                        |> Expect.equal ( withPomodoroCounter (Over Pomodoro Time.minute), Cmd.none )
            ]
        , describe "short break" <|
            [ test "when it starts" <|
                \() ->
                    withPomodoroCounter unstartedShortBreak
                        |> update StartShortBreak
                        |> Expect.equal ( withPomodoroCounter freshShortBreak, Cmd.none )
            , test "when it is counting down" <|
                \() ->
                    withPomodoroCounter (Active ShortBreak (Time.minute * 2 + Time.second * 24))
                        |> update tick
                        |> Expect.equal ( withPomodoroCounter (Active ShortBreak (Time.minute * 2 + Time.second * 23)), Cmd.none )
            , test "when it is up" <|
                \() ->
                    withPomodoroCounter (Active ShortBreak (Time.second * 1))
                        |> update tick
                        |> Expect.equal
                            ( withPomodoroCounter (Over ShortBreak 0)
                            , ringBell
                            )
            , test "when it is running over" <|
                \() ->
                    withPomodoroCounter (Over ShortBreak 0)
                        |> update tick
                        |> Expect.equal ( withPomodoroCounter (Over ShortBreak Time.second), Cmd.none )
            , test "when it continues to run over" <|
                \() ->
                    withPomodoroCounter (Over ShortBreak (Time.second * 59))
                        |> update tick
                        |> Expect.equal ( withPomodoroCounter (Over ShortBreak Time.minute), Cmd.none )
            ]
        , describe "long break" <|
            [ test "when it starts" <|
                \() ->
                    withPomodoroCounter unstartedLongBreak
                        |> update StartLongBreak
                        |> Expect.equal ( withPomodoroCounter freshLongBreak, Cmd.none )
            , test "when it is counting down" <|
                \() ->
                    withPomodoroCounter (Active LongBreak (Time.minute * 2 + Time.second * 24))
                        |> update tick
                        |> Expect.equal ( withPomodoroCounter (Active LongBreak (Time.minute * 2 + Time.second * 23)), Cmd.none )
            , test "when it is up" <|
                \() ->
                    withPomodoroCounter (Active LongBreak (Time.second * 1))
                        |> update tick
                        |> Expect.equal
                            ( withPomodoroCounter (Over LongBreak 0)
                            , ringBell
                            )
            , test "when it is running over" <|
                \() ->
                    withPomodoroCounter (Over LongBreak 0)
                        |> update tick
                        |> Expect.equal ( withPomodoroCounter (Over LongBreak Time.second), Cmd.none )
            , test "when it continues to run over" <|
                \() ->
                    withPomodoroCounter (Over LongBreak (Time.second * 59))
                        |> update tick
                        |> Expect.equal ( withPomodoroCounter (Over LongBreak Time.minute), Cmd.none )
            ]
        ]
