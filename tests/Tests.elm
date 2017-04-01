module Tests exposing (..)

import ViewTests exposing (..)
import UpdateTests exposing (..)
import SubscriptionsTests exposing (..)
import FormattingTests exposing (..)
import Test exposing (..)
import Timer.Tests
import Notifications.Tests


all : Test
all =
    describe "Pomodoro"
        [ describeView
        , describeUpdate
        , describeSubscriptions
        , describeFormatting
        , Timer.Tests.all
        , Notifications.Tests.all
        ]
