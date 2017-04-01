module Notifications.NotifyTests exposing (..)

import Expect
import Notifications exposing (..)
import Test exposing (..)


all : Test
all =
    describe "Notifications.notify"
        [ test "should send notification and ring bell" <|
            \() ->
                Notifications.notify "hello"
                    |> Expect.equal
                        (Cmd.batch
                            [ Notifications.sendNotification "hello"
                            , Notifications.ringBell
                            ]
                        )
        ]
