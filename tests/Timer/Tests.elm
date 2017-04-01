module Timer.Tests exposing (all)

import Timer.UpdateTests
import Timer.ViewTests
import Timer.SubscriptionsTests
import Test exposing (..)


all =
    describe "Timer"
        [ Timer.UpdateTests.all
        , Timer.ViewTests.all
        , Timer.SubscriptionsTests.all
        ]
