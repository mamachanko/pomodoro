module Tests exposing (..)

import Test exposing (..)
import Timer.Tests
import Notifications.Tests
import Log.Tests
import App.Tests


all : Test
all =
    describe "Pomodoro"
        [ App.Tests.all
        , Timer.Tests.all
        , Notifications.Tests.all
        , Log.Tests.all
        ]
