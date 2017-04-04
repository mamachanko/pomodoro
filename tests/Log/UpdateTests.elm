module Log.UpdateTests exposing (all)

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
                        { initLog
                            | log = [ "worked on stuff" ]
                            , currentInput = "worked on more stuff"
                        }
                }
                    |> updateLog RecordPomodoro
                    |> Expect.equal
                        ( { init
                            | log =
                                { initLog
                                    | log = [ "worked on more stuff", "worked on stuff" ]
                                    , currentInput = ""
                                }
                          }
                        , Cmd.none
                        )
        , test "when there's text input" <|
            \() ->
                { init | log = { initLog | currentInput = "worked on " } }
                    |> updateLog (TextInput "worked on stuff")
                    |> Expect.equal
                        ( { init
                            | log =
                                { initLog
                                    | currentInput = "worked on stuff"
                                }
                          }
                        , Cmd.none
                        )
        ]
