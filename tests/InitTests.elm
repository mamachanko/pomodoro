module InitTests exposing (..)

import Pomodoro exposing (..)
import Test exposing (..)
import Expect


describeInit : Test
describeInit =
    describe "init"
        [ test "initialises as unstarted Pomodoro" <|
            \() ->
                init |> Expect.equal ( unstartedPomodoro, Cmd.none )
        ]
