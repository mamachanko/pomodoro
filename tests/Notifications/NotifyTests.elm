module Notifications.NotifyTests exposing (..)

import App exposing (..)
import Expect
import Test exposing (..)


all : Test
all =
    describe "Notifications.notify"
        [ test "should send notification and ring bell" <|
            \() ->
                notify "hello"
                    |> Expect.equal
                        (Cmd.batch
                            [ sendNotification "hello"
                            , ringBell
                            ]
                        )
        ]
