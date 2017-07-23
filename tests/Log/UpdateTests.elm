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
                        [ { date = Date.fromTime Time.second, text = "worked on stuff", editing = False } ]

                    newLog =
                        [ { date = Date.fromTime Time.second, text = "Pomodoro", editing = False }
                        , { date = Date.fromTime Time.second, text = "worked on stuff", editing = False }
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
        , test "should start to edit a Pomodoro" <|
            \() ->
                let
                    oldLog =
                        [ { date = Date.fromTime 0, text = "worked on stuff", editing = False }
                        , { date = Date.fromTime 1, text = "worked on stuff", editing = False }
                        ]

                    newLog =
                        [ { date = Date.fromTime 0, text = "worked on stuff", editing = False }
                        , { date = Date.fromTime 1, text = "worked on stuff", editing = True }
                        ]
                in
                    { init
                        | log = oldLog
                    }
                        |> updateLog (EditingPomodoro (Date.fromTime 1) True)
                        |> Expect.equal
                            ({ init
                                | log = newLog
                             }
                                ! []
                            )
        , test "should end editing a Pomodoro" <|
            \() ->
                let
                    oldLog =
                        [ { date = Date.fromTime 0, text = "worked on stuff", editing = False }
                        , { date = Date.fromTime 1, text = "worked on stuff", editing = True }
                        ]

                    newLog =
                        [ { date = Date.fromTime 0, text = "worked on stuff", editing = False }
                        , { date = Date.fromTime 1, text = "worked on stuff", editing = False }
                        ]
                in
                    { init
                        | log = oldLog
                    }
                        |> updateLog (EditingPomodoro (Date.fromTime 1) False)
                        |> Expect.equal
                            ({ init
                                | log = newLog
                             }
                                ! []
                            )
        , test "should update a Pomodoro" <|
            \() ->
                let
                    oldLog =
                        [ { date = Date.fromTime 0, text = "worked on stuff", editing = False }
                        , { date = Date.fromTime 1, text = "worked on stuff", editing = False }
                        ]

                    newLog =
                        [ { date = Date.fromTime 0, text = "worked on stuff", editing = False }
                        , { date = Date.fromTime 1, text = "worked on other stuff", editing = False }
                        ]
                in
                    { init
                        | log = oldLog
                    }
                        |> updateLog (UpdatePomodoro (Date.fromTime 1) "worked on other stuff")
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
                        [ { date = Date.fromTime Time.second, text = "worked on stuff", editing = False } ]

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
