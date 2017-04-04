module Notifications.SubscriptionsTests exposing (..)

import App exposing (..)
import Test exposing (..)
import Expect


all : Test
all =
    describe "Notifications.subscriptions"
        [ test "should listen to nothing" <|
            \() ->
                subscriptionsNotifications initNotifications
                    |> Expect.equal Sub.none
        ]
