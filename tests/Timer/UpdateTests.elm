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
                        { init | timer = Over Pomodoro 0 }
                            |> Expect.equal model
              -- it should also notify and record a Pomodoro, but a Task cannot be tested
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
        , describe "break" <|
            [ test "when it starts" <|
                \() ->
                    { init | timer = unstartedBreak }
                        |> updateTimer StartBreak
                        |> Expect.equal
                            ({ init | timer = freshBreak }
                                ! []
                            )
            , test "when it is counting down" <|
                \() ->
                    { init | timer = (Active Break <| Time.minute * 2 + Time.second * 24) }
                        |> updateTimer tick
                        |> Expect.equal
                            ( { init | timer = (Active Break <| Time.minute * 2 + Time.second * 23) }
                            , Cmd.none
                            )
            , test "when it is up" <|
                \() ->
                    { init | timer = (Active Break <| Time.second * 1) }
                        |> updateTimer tick
                        |> Expect.equal
                            ({ init | timer = Over Break 0 }
                                ! [ notify "Ora di pomodoro." ]
                            )
            , test "when it is running over" <|
                \() ->
                    { init | timer = Over Break 0 }
                        |> updateTimer tick
                        |> Expect.equal
                            ( { init | timer = Over Break Time.second }
                            , Cmd.none
                            )
            , test "when it continues to run over" <|
                \() ->
                    { init | timer = (Over Break <| Time.second * 59) }
                        |> updateTimer tick
                        |> Expect.equal
                            ( { init | timer = Over Break Time.minute }
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
            , test "starts a break" <|
                \() ->
                    updateTimer (KeyboardEvent 223) init
                        |> Expect.equal
                            ( { init | timer = freshBreak }
                            , Cmd.none
                            )
            ]
        ]
