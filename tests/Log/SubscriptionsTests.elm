module Log.SubscriptionsTests exposing (..)

import Log exposing (..)
import Test exposing (..)
import Expect


all : Test
all =
    describe "Log.subscriptions"
        [ test "should listen to nothing" <|
            \() ->
                subscriptions init
                    |> Expect.equal Sub.none
        ]
