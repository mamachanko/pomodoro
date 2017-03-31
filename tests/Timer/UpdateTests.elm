module Timer.UpdateTests exposing (all)

import Timer exposing (..)
import Notifications
import Time
import Test exposing (..)
import Expect


all : Test
all =
    describe "update"
        [ describe "Pomodoro" <|
            [ test "when it starts" <|
                \() ->
                    update StartPomodoro init
                        |> Expect.equal
                            ( freshPomodoro
                            , Cmd.none
                            )
            , test "when it is counting down" <|
                \() ->
                    (Active Pomodoro <| Time.minute * 2 + Time.second * 24)
                        |> update tick
                        |> Expect.equal
                            ( Active Pomodoro <| Time.minute * 2 + Time.second * 23
                            , Cmd.none
                            )
            , test "when it is up" <|
                \() ->
                    (Active Pomodoro <| Time.second * 1)
                        |> update tick
                        |> Expect.equal
                            ( Over Pomodoro 0
                            , Notifications.notifyEndOfPomodoro
                            )
            , test "when it is running over" <|
                \() ->
                    Over Pomodoro 0
                        |> update tick
                        |> Expect.equal
                            ( Over Pomodoro Time.second
                            , Cmd.none
                            )
            , test "when it continues to run over" <|
                \() ->
                    (Over Pomodoro <| Time.second * 59)
                        |> update tick
                        |> Expect.equal
                            ( Over Pomodoro Time.minute
                            , Cmd.none
                            )
            ]
        , describe "short break" <|
            [ test "when it starts" <|
                \() ->
                    unstartedShortBreak
                        |> update StartShortBreak
                        |> Expect.equal
                            ( freshShortBreak
                            , Cmd.none
                            )
            , test "when it is counting down" <|
                \() ->
                    (Active ShortBreak <| Time.minute * 2 + Time.second * 24)
                        |> update tick
                        |> Expect.equal
                            ( Active ShortBreak <| Time.minute * 2 + Time.second * 23
                            , Cmd.none
                            )
            , test "when it is up" <|
                \() ->
                    (Active ShortBreak <| Time.second * 1)
                        |> update tick
                        |> Expect.equal
                            ( Over ShortBreak 0
                            , Notifications.notifyEndOfBreak
                            )
            , test "when it is running over" <|
                \() ->
                    Over ShortBreak 0
                        |> update tick
                        |> Expect.equal
                            ( Over ShortBreak Time.second
                            , Cmd.none
                            )
            , test "when it continues to run over" <|
                \() ->
                    (Over ShortBreak <| Time.second * 59)
                        |> update tick
                        |> Expect.equal
                            ( Over ShortBreak Time.minute
                            , Cmd.none
                            )
            ]
        , describe "long break" <|
            [ test "when it starts" <|
                \() ->
                    init
                        |> update StartLongBreak
                        |> Expect.equal
                            ( freshLongBreak
                            , Cmd.none
                            )
            , test "when it is counting down" <|
                \() ->
                    (Active LongBreak <| Time.minute * 2 + Time.second * 24)
                        |> update tick
                        |> Expect.equal
                            ( Active LongBreak <| Time.minute * 2 + Time.second * 23
                            , Cmd.none
                            )
            , test "when it is up" <|
                \() ->
                    (Active LongBreak <| Time.second * 1)
                        |> update tick
                        |> Expect.equal
                            ( Over LongBreak 0
                            , Notifications.notifyEndOfBreak
                            )
            , test "when it is running over" <|
                \() ->
                    Over LongBreak 0
                        |> update tick
                        |> Expect.equal
                            ( Over LongBreak Time.second
                            , Cmd.none
                            )
            , test "when it continues to run over" <|
                \() ->
                    (Over LongBreak <| Time.second * 59)
                        |> update tick
                        |> Expect.equal
                            ( Over LongBreak Time.minute
                            , Cmd.none
                            )
            ]
        , describe "keyboard shortcuts" <|
            [ test "starts a Pomodoro" <|
                \() ->
                    update (KeyboardEvent 960) init
                        |> Expect.equal
                            ( freshPomodoro
                            , Cmd.none
                            )
            , test "starts a short break" <|
                \() ->
                    update (KeyboardEvent 223) init
                        |> Expect.equal
                            ( freshShortBreak
                            , Cmd.none
                            )
            , test "starts a long break" <|
                \() ->
                    update (KeyboardEvent 172) init
                        |> Expect.equal
                            ( freshLongBreak
                            , Cmd.none
                            )
            ]
        ]
