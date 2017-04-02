module Notifications.UpdateTests exposing (..)

import Notifications exposing (..)
import Expect
import Test exposing (..)


all : Test
all =
    describe "Notifications.update"
        [ test "should request to enable desktop notifications" <|
            \() ->
                update EnableDesktopNotifications init
                    |> Expect.equal (init ! [ enableDesktopNotifications ])
        ]
