module Timer.UpdateTests exposing (all)

import App exposing (..)
import Time
import Test exposing (..)
import Expect


all : Test
all =
    describe "Timer.updateTimer"
        [ describe "Pomodoro" <|
            [ test "when it starts" <|
                \() ->
                    updateTimer StartPomodoro init
                        |> Expect.equal
                            ( { init | timer = freshPomodoro }
                            , Cmd.none
                            )
            , test "when it is counting down" <|
                \() ->
                    { init | timer = (Active Pomodoro <| Time.minute * 2 + Time.second * 24) }
                        |> updateTimer tick
                        |> Expect.equal
                            ( { init | timer = Active Pomodoro <| Time.minute * 2 + Time.second * 23 }
                            , Cmd.none
                            )
            , test "when it is up" <|
                \() ->
                    { init | timer = (Active Pomodoro <| Time.second * 1) }
                        |> updateTimer tick
                        |> Expect.equal
                            ( { init | timer = Over Pomodoro 0 }
                            , notify "It's break-y time."
                            )
            , test "when it is running over" <|
                \() ->
                    { init | timer = Over Pomodoro 0 }
                        |> updateTimer tick
                        |> Expect.equal
                            ( { init | timer = Over Pomodoro Time.second }
                            , Cmd.none
                            )
            , test "when it continues to run over" <|
                \() ->
                    { init | timer = (Over Pomodoro <| Time.second * 59) }
                        |> updateTimer tick
                        |> Expect.equal
                            ( { init | timer = Over Pomodoro Time.minute }
                            , Cmd.none
                            )
            ]
        , describe "short break" <|
            [ test "when it starts" <|
                \() ->
                    { init | timer = unstartedShortBreak }
                        |> updateTimer StartShortBreak
                        |> Expect.equal
                            ( { init | timer = freshShortBreak }
                            , Cmd.none
                            )
            , test "when it is counting down" <|
                \() ->
                    { init | timer = (Active ShortBreak <| Time.minute * 2 + Time.second * 24) }
                        |> updateTimer tick
                        |> Expect.equal
                            ( { init | timer = (Active ShortBreak <| Time.minute * 2 + Time.second * 23) }
                            , Cmd.none
                            )
            , test "when it is up" <|
                \() ->
                    { init | timer = (Active ShortBreak <| Time.second * 1) }
                        |> updateTimer tick
                        |> Expect.equal
                            ( { init | timer = Over ShortBreak 0 }
                            , notify "Ora di pomodoro."
                            )
            , test "when it is running over" <|
                \() ->
                    { init | timer = Over ShortBreak 0 }
                        |> updateTimer tick
                        |> Expect.equal
                            ( { init | timer = Over ShortBreak Time.second }
                            , Cmd.none
                            )
            , test "when it continues to run over" <|
                \() ->
                    { init | timer = (Over ShortBreak <| Time.second * 59) }
                        |> updateTimer tick
                        |> Expect.equal
                            ( { init | timer = Over ShortBreak Time.minute }
                            , Cmd.none
                            )
            ]
        , describe "long break" <|
            [ test "when it starts" <|
                \() ->
                    initTimer
                        |> updateTimer StartLongBreak
                        |> Expect.equal
                            ( freshLongBreak
                            , Cmd.none
                            )
            , test "when it is counting down" <|
                \() ->
                    (Active LongBreak <| Time.minute * 2 + Time.second * 24)
                        |> updateTimer tick
                        |> Expect.equal
                            ( Active LongBreak <| Time.minute * 2 + Time.second * 23
                            , Cmd.none
                            )
            , test "when it is up" <|
                \() ->
                    (Active LongBreak <| Time.second * 1)
                        |> updateTimer tick
                        |> Expect.equal
                            ( Over LongBreak 0
                            , notify "Ora di pomodoro."
                            )
            , test "when it is running over" <|
                \() ->
                    Over LongBreak 0
                        |> updateTimer tick
                        |> Expect.equal
                            ( Over LongBreak Time.second
                            , Cmd.none
                            )
            , test "when it continues to run over" <|
                \() ->
                    (Over LongBreak <| Time.second * 59)
                        |> updateTimer tick
                        |> Expect.equal
                            ( Over LongBreak Time.minute
                            , Cmd.none
                            )
            ]
        , describe "keyboard shortcuts" <|
            [ test "starts a Pomodoro" <|
                \() ->
                    updateTimer (KeyboardEvent 960) initTimer
                        |> Expect.equal
                            ( freshPomodoro
                            , Cmd.none
                            )
            , test "starts a short break" <|
                \() ->
                    updateTimer (KeyboardEvent 223) initTimer
                        |> Expect.equal
                            ( freshShortBreak
                            , Cmd.none
                            )
            , test "starts a long break" <|
                \() ->
                    updateTimer (KeyboardEvent 172) initTimer
                        |> Expect.equal
                            ( freshLongBreak
                            , Cmd.none
                            )
            ]
        ]
