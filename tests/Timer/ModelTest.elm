module Timer.ModelTest exposing (all)

import Timer.Model
import Test exposing (..)
import Expect


all =
    describe "Timer.Model"
        [ test "something" <|
            \() ->
                Timer.Model.init
                    |> Expect.equal (Timer.Model.Timer 2)
        ]
