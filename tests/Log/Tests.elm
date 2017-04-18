module Log.Tests exposing (all)

import Log.UpdateTests
import Log.ViewTests
import Test exposing (..)


all =
    describe "Log"
        [ Log.UpdateTests.all
        , Log.ViewTests.all
        ]
