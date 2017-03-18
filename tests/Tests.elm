module Tests exposing (..)

import ViewTests exposing (..)
import UpdateTests exposing (..)
import SubscriptionsTests exposing (..)
import FormattingTests exposing (..)
import Test exposing (..)


all : Test
all =
    describe "Pomodoro"
        [ describeView
        , describeUpdate
        , describeSubscriptions
        , describeFormatting
        ]
