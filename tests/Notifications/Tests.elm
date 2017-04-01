module Notifications.Tests exposing (all)

import Notifications.ViewTests
import Notifications.UpdateTests
import Notifications.NotifyTests
import Notifications.SubscriptionsTests
import Test exposing (..)
import Expect


all =
    describe "Notifications"
        [ Notifications.ViewTests.all
        , Notifications.NotifyTests.all
        , Notifications.UpdateTests.all
        , Notifications.SubscriptionsTests.all
        ]
