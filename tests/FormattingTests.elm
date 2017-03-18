module FormattingTests exposing (..)

import Format exposing (formatTime)
import Model exposing (..)
import Time
import Expect
import Test exposing (..)


describeFormatting : Test
describeFormatting =
    describe "formatting"
        [ test "formats time" <|
            \() ->
                formatTime ((Time.minute * 18) + (Time.second * 27))
                    |> Expect.equal "18:27"
        , test "formats more time" <|
            \() ->
                formatTime ((Time.minute * 8) + (Time.second * 7))
                    |> Expect.equal "08:07"
        , test "formats zero time" <|
            \() ->
                formatTime 0
                    |> Expect.equal "00:00"
        , test "formats negative time" <|
            \() ->
                formatTime ((Time.minute * -2) + (Time.second * -5))
                    |> Expect.equal "-02:05"
        ]
