module Notifications.SubscriptionsTests exposing (..)

import Notifications exposing (..)
import Test exposing (..)
import Expect


all : Test
all =
    describe "Notifications.subscriptions"
        [ test "should listen to nothing" <|
            \() ->
                subscriptions init
                    |> Expect.equal Sub.none
        ]
