module Notifications.UpdateTests exposing (..)

import App exposing (..)
import Expect
import Test exposing (..)


all : Test
all =
    describe "Notifications.update"
        [ test "should request to enable desktop notifications" <|
            \() ->
                updateNotifications (KeyboardEvent 8706) init
                    |> Expect.equal (init ! [ enableDesktopNotifications ])
        ]
