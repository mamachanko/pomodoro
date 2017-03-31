module Timer.Tests exposing (all)

import Timer.UpdateTests
import Test exposing (..)


all =
    describe "Timer"
        [ Timer.UpdateTests.all
        ]
