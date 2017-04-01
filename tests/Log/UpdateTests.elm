module Log.UpdateTests exposing (all)

import Log exposing (..)
import Test exposing (..)
import Expect


all : Test
all =
    describe "Log.update"
        [ test "should record a Pomodoro" <|
            \() ->
                { init
                    | log = [ "worked on stuff" ]
                    , currentInput = "worked on more stuff"
                }
                    |> update RecordPomodoro
                    |> Expect.equal
                        ( { log = [ "worked on more stuff", "worked on stuff" ]
                          , currentInput = ""
                          }
                        , Cmd.none
                        )
        , test "when there's text input" <|
            \() ->
                { init | currentInput = "worked on " }
                    |> update (TextInput "worked on stuff")
                    |> Expect.equal
                        ( { init
                            | currentInput = "worked on stuff"
                          }
                        , Cmd.none
                        )
        ]
