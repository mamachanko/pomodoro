module Log.SubscriptionsTests exposing (..)

import Test exposing (..)
import Expect


all : Test
all =
    describe "Log.subscriptions"
        [ test "should listen to nothing" <|
            \() ->
                subscriptionsLog initLog
                    |> Expect.equal Sub.none
        ]
