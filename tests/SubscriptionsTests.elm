module SubscriptionsTests exposing (..)

import Test exposing (..)
import Pomodoro exposing (..)
import Time
import Expect


describeSubscriptions : Test
describeSubscriptions =
    describe "subscriptions"
        [ test "does nothing for an unstarted Pomodoro" <|
            \() ->
                subscriptions unstartedPomodoro
                    |> Expect.equal Sub.none
        , test "emits Tick every second for a running Pomodoro" <|
            \() ->
                subscriptions freshPomodoro
                    |> Expect.equal (Time.every Time.second Tick)
        ]
