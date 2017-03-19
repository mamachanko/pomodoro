module SubscriptionsTests exposing (..)

import Subscriptions exposing (subscriptions)
import Model exposing (..)
import Time
import Test exposing (..)
import Expect


describeSubscriptions : Test
describeSubscriptions =
    describe "subscriptions"
        [ test "does nothing for an inactive session" <|
            \() ->
                subscriptions unstartedPomodoro
                    |> Expect.equal Sub.none
        , test "emits Tick every second for an active session" <|
            \() ->
                subscriptions freshPomodoro
                    |> Expect.equal (Time.every Time.second Tick)
        , test "emits Tick every second for a sessions running over" <|
            \() ->
                subscriptions (Over Pomodoro (Time.second * 45))
                    |> Expect.equal (Time.every Time.second Tick)
        ]
