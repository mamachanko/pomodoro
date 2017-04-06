module Timer.UpdateTests exposing (all)

import App exposing (..)
import Time
import Date
import Task
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
                let
                    ( model, cmd ) =
                        updateTimer tick { init | timer = (Active Pomodoro <| Time.second * 1) }
                in
                    \() ->
                        Expect.equal { init | timer = Over Pomodoro 0 } model
              -- it should also notify and record a Pomodoro, but Task cannot be tested
            , test "when it is running over" <|
                \() ->
                    { init | timer = Over Pomodoro 0 }
                        |> updateTimer tick
                        |> Expect.equal
                            ({ init | timer = Over Pomodoro Time.second }
                                ! []
                            )
            , test "when it continues to run over" <|
                \() ->
                    { init | timer = (Over Pomodoro <| Time.second * 59) }
                        |> updateTimer tick
                        |> Expect.equal
                            ({ init | timer = Over Pomodoro Time.minute }
                                ! []
                            )
            ]
        , describe "short break" <|
            [ test "when it starts" <|
                \() ->
                    { init | timer = unstartedShortBreak }
                        |> updateTimer StartShortBreak
                        |> Expect.equal
                            ({ init | timer = freshShortBreak }
                                ! []
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
                            ({ init | timer = Over ShortBreak 0 }
                                ! [ notify "Ora di pomodoro." ]
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
                    init
                        |> updateTimer StartLongBreak
                        |> Expect.equal
                            ( { init | timer = freshLongBreak }
                            , Cmd.none
                            )
            , test "when it is counting down" <|
                \() ->
                    { init | timer = (Active LongBreak <| Time.minute * 2 + Time.second * 24) }
                        |> updateTimer tick
                        |> Expect.equal
                            ( { init | timer = (Active LongBreak <| Time.minute * 2 + Time.second * 23) }
                            , Cmd.none
                            )
            , test "when it is up" <|
                \() ->
                    { init | timer = (Active LongBreak <| Time.second * 1) }
                        |> updateTimer tick
                        |> Expect.equal
                            ({ init | timer = Over LongBreak 0 }
                                ! [ notify "Ora di pomodoro." ]
                            )
            , test "when it is running over" <|
                \() ->
                    { init | timer = Over LongBreak 0 }
                        |> updateTimer tick
                        |> Expect.equal
                            ( { init | timer = Over LongBreak Time.second }
                            , Cmd.none
                            )
            , test "when it continues to run over" <|
                \() ->
                    { init | timer = (Over LongBreak <| Time.second * 59) }
                        |> updateTimer tick
                        |> Expect.equal
                            ( { init | timer = Over LongBreak Time.minute }
                            , Cmd.none
                            )
            ]
        , describe "keyboard shortcuts" <|
            [ test "starts a Pomodoro" <|
                \() ->
                    updateTimer (KeyboardEvent 960) init
                        |> Expect.equal
                            ( { init | timer = freshPomodoro }
                            , Cmd.none
                            )
            , test "starts a short break" <|
                \() ->
                    updateTimer (KeyboardEvent 223) init
                        |> Expect.equal
                            ( { init | timer = freshShortBreak }
                            , Cmd.none
                            )
            , test "starts a long break" <|
                \() ->
                    updateTimer (KeyboardEvent 172) init
                        |> Expect.equal
                            ( { init | timer = freshLongBreak }
                            , Cmd.none
                            )
            ]
        ]
