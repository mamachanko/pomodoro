module Log.FlagsTests exposing (..)

import App exposing (..)
import Test exposing (..)
import Expect
import Date
import Json.Decode


all : Test
all =
    describe "Log.flags"
        [ test "should parse no flags into an empty log" <|
            let
                flags =
                    { log = [] }
            in
                \() -> initWithFlags flags |> Expect.equal (init ! [])
        , test "should parse flags into a log" <|
            let
                flags =
                    { log =
                        [ { date = "<Thu Jan 01 1970 01:00:00 GMT+0100 (CET)>"
                          , text = "text"
                          }
                        ]
                    }
            in
                \() ->
                    initWithFlags flags
                        |> Expect.equal
                            ({ init
                                | log =
                                    [ { date = Date.fromTime 0
                                      , text = "text"
                                      }
                                    ]
                             }
                                ! []
                            )
        , test "should parse bad flags into an empty log" <|
            let
                flags =
                    { log =
                        [ { date = "i am not a date"
                          , text = "text"
                          }
                        ]
                    }
            in
                \() ->
                    initWithFlags flags |> Expect.equal (init ! [])
        ]
