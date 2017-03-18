module Tests exposing (..)

import Pomodoro exposing (..)
import Sound exposing (ringBell)
import Test exposing (..)
import ViewTests exposing (..)
import InitTests exposing (..)
import UpdateTests exposing (..)
import SubscriptionsTests exposing (..)
import FormattingTests exposing (..)
import Expect
import Time


all : Test
all =
    describe "Pomodoro"
        [ describeView
        , describeInit
        , describeUpdate
        , describeSubscriptions
        , describeFormatting
        ]
