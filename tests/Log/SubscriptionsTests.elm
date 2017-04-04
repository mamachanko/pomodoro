module Log.SubscriptionsTests exposing (..)

import App exposing (..)
import Test exposing (..)
import Expect


all : Test
all =
    describe "Log.subscriptions"
        [ test "should listen to nothing" <|
            \() ->
                subscriptionsLog init.log
                    |> Expect.equal Sub.none
        ]
