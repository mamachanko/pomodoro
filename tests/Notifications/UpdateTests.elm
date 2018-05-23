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
        , test "should send a test notification" <|
            \() ->
                updateNotifications (KeyboardEvent 8224) init
                    |> Expect.equal (init ! [ notify "Testing notifications. Do you hear the bell?" ])
        ]
