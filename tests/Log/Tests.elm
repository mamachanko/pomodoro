module Log.Tests exposing (all)

import Log.UpdateTests
import Log.ViewTests
import Log.FlagsTests
import Test exposing (..)


all =
    describe "Log"
        [ Log.UpdateTests.all
        , Log.ViewTests.all
        , Log.FlagsTests.all
        ]
