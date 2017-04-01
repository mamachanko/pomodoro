module Timer.SubscriptionsTests exposing (all)

import Timer exposing (..)
import Time
import Keyboard
import Test exposing (..)
import Expect


all : Test
all =
    describe "Timer.subscriptions"
        [ test "should listen to keyboard presses for shortcuts" <|
            \() ->
                subscriptions init
                    |> Expect.equal (Keyboard.presses KeyboardEvent)
        , test "should listen to ticks for an active session" <|
            \() ->
                subscriptions freshPomodoro
                    |> Expect.equal
                        (Sub.batch
                            [ Time.every Time.second Tick
                            , Keyboard.presses KeyboardEvent
                            ]
                        )
        , test "should listen to ticks for an overrunning sessions" <|
            \() ->
                subscriptions (Over Pomodoro Time.second)
                    |> Expect.equal
                        (Sub.batch
                            [ Time.every Time.second Tick
                            , Keyboard.presses KeyboardEvent
                            ]
                        )
        ]
