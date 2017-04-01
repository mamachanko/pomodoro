module Log.Tests exposing (all)

import Log.UpdateTests
import Log.ViewTests
import Log.SubscriptionsTests
import Test exposing (..)


all =
    describe "Log"
        [ Log.UpdateTests.all
        , Log.ViewTests.all
        , Log.SubscriptionsTests.all
        ]
