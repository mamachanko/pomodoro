module Log.UpdateTests exposing (all)

import Date
import Time
import App exposing (..)
import Test exposing (..)
import Expect


all : Test
all =
    describe "Log.update"
        [ test "should record a Pomodoro" <|
            \() ->
                { init
                    | log =
                        [ { date = Date.fromTime Time.second, count = 1 } ]
                }
                    |> updateLog (RecordPomodoro <| Date.fromTime Time.second)
                    |> Expect.equal
                        ({ init
                            | log =
                                [ { date = Date.fromTime Time.second, count = 2 }
                                ]
                         }
                            ! []
                        )
        ]
