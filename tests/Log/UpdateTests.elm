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
                let
                    oldLog =
                        [ { date = Date.fromTime Time.second, text = "worked on stuff" } ]

                    newLog =
                        [ { date = Date.fromTime Time.second, text = "Pomodoro" }
                        , { date = Date.fromTime Time.second, text = "worked on stuff" }
                        ]
                in
                    { init
                        | log = oldLog
                    }
                        |> updateLog (RecordPomodoro <| Date.fromTime Time.second)
                        |> Expect.equal
                            ({ init
                                | log = newLog
                             }
                                ! [ writeLog newLog ]
                            )
        , test "should reset the log on alt+r" <|
            \() ->
                let
                    oldLog =
                        [ { date = Date.fromTime Time.second, text = "worked on stuff" } ]

                    emptyLog =
                        []
                in
                    { init
                        | log = oldLog
                    }
                        |> updateLog altR
                        |> Expect.equal
                            ({ init
                                | log = emptyLog
                             }
                                ! [ resetLog ]
                            )
        ]
