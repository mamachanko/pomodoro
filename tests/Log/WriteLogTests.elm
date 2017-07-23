module Log.WriteLogTests exposing (..)

import App exposing (..)
import Date
import Expect
import Test exposing (..)


all : Test
all =
    describe "Log.writeLog"
        [ test "should write log via port" <|
            \() ->
                writeLog
                    [ { date = Date.fromTime 0, text = "text", editing = False }
                    , { date = Date.fromTime (86400 * 1000), text = "text", editing = False }
                    ]
                    |> Expect.equal
                        (Cmd.batch
                            [ updatePomodoroLogPort
                                { log =
                                    [ { date = "<Thu Jan 01 1970 01:00:00 GMT+0100 (CET)>"
                                      , text = "text"
                                      }
                                    , { date = "<Fri Jan 02 1970 01:00:00 GMT+0100 (CET)>"
                                      , text = "text"
                                      }
                                    ]
                                }
                            ]
                        )
        , test "should reset log" <|
            \() ->
                resetLog |> Expect.equal (writeLog [])
        ]
