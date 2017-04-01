module Notifications.Tests exposing (all)

import Notifications
import Test exposing (..)
import Expect


all =
    describe "Notifications"
        [ describe "notify"
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
        ]
