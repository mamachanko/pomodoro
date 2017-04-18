module Notifications.Tests exposing (all)

import Notifications.UpdateTests
import Notifications.NotifyTests
import Test exposing (..)
import Expect


all =
    describe "Notifications"
        [ Notifications.NotifyTests.all
        , Notifications.UpdateTests.all
        ]
