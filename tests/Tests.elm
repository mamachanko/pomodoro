module Tests exposing (..)

import ViewTests exposing (..)
import UpdateTests exposing (..)
import SubscriptionsTests exposing (..)
import Test exposing (..)
import Timer.Tests
import Notifications.Tests
import Log.Tests


all : Test
all =
    describe "Pomodoro"
        [ describeView
        , describeUpdate
        , describeSubscriptions
        , Timer.Tests.all
        , Notifications.Tests.all
        , Log.Tests.all
        ]
