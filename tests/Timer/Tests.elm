module Timer.Tests exposing (all)

import Timer.ModelTest
import Test exposing (..)


all =
    describe "Timer"
        [ Timer.ModelTest.all
        ]
