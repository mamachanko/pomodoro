module Notifications.UpdateTests exposing (..)

import Notifications exposing (..)
import Test exposing (..)
import Expect


all : Test
all =
    describe "Notifications.update"
        [ test "should do nothing" <|
            \() ->
                update noAction init
                    |> Expect.equal (init ! [])
        ]
