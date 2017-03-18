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
        , test "emits Tick every second for a running Pomodoro" <|
            \() ->
                subscriptions (freshPomodoro)
                    |> Expect.equal (Time.every Time.second Tick)
        ]
