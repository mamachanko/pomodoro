module Timer.FormattingTests exposing (..)

import App exposing (..)
import Time
import Expect
import Test exposing (..)


all : Test
all =
    describe "Timer.formatTime"
        [ test "should format time" <|
            \() ->
                formatTime ((Time.minute * 18) + (Time.second * 27))
                    |> Expect.equal "18:27"
        , test "should format more time" <|
            \() ->
                formatTime ((Time.minute * 8) + (Time.second * 7))
                    |> Expect.equal "08:07"
        , test "should format zero time" <|
            \() ->
                formatTime 0
                    |> Expect.equal "00:00"
        ]
