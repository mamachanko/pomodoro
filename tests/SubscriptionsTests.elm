module SubscriptionsTests exposing (..)

import Subscriptions exposing (subscriptions)
import Model exposing (..)
import Time
import Test exposing (..)
import Expect


withPomodoroCounter session =
    { currentSession = session, pomodoroCount = 123 }


describeSubscriptions : Test
describeSubscriptions =
    describe "subscriptions"
        [ test "does nothing for an inactive session" <|
            \() ->
                subscriptions (withPomodoroCounter unstartedPomodoro)
                    |> Expect.equal Sub.none
        , test "emits Tick every second for an active session" <|
            \() ->
                subscriptions (withPomodoroCounter freshPomodoro)
                    |> Expect.equal (Time.every Time.second Tick)
        , test "emits Tick every second for a sessions running over" <|
            \() ->
                subscriptions (withPomodoroCounter (Over Pomodoro (Time.second * 45)))
                    |> Expect.equal (Time.every Time.second Tick)
        ]
