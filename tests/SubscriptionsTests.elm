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
                subscriptions initialModel
                    |> Expect.equal (Keyboard.presses KeyboardEvent)
        , test "emits Tick every second for an active session" <|
            \() ->
                subscriptions { initialModel | currentSession = freshPomodoro }
                    |> Expect.equal
                        (Sub.batch [ Time.every Time.second Tick, Keyboard.presses KeyboardEvent ])
        , test "emits Tick every second for a sessions running over" <|
            \() ->
                subscriptions { initialModel | currentSession = Over Pomodoro Time.second }
                    |> Expect.equal
                        (Sub.batch [ Time.every Time.second Tick, Keyboard.presses KeyboardEvent ])
        ]
