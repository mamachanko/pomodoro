module SubscriptionsTests exposing (..)

import Subscriptions exposing (subscriptions)
import Model exposing (..)
import Time
import Keyboard
import Test exposing (..)
import Expect


describeSubscriptions : Test
describeSubscriptions =
    describe "subscriptions"
        [ test "does nothing for an inactive session" <|
            \() ->
                subscriptions (Model unstartedPomodoro [])
                    |> Expect.equal (Keyboard.presses KeyboardEvent)
        , test "emits Tick every second for an active session" <|
            \() ->
                subscriptions (Model freshPomodoro [])
                    |> Expect.equal
                        (Sub.batch [ Time.every Time.second Tick, Keyboard.presses KeyboardEvent ])
        , test "emits Tick every second for a sessions running over" <|
            \() ->
                subscriptions (Model (Over Pomodoro (Time.second * 45)) [])
                    |> Expect.equal
                        (Sub.batch [ Time.every Time.second Tick, Keyboard.presses KeyboardEvent ])
        ]
