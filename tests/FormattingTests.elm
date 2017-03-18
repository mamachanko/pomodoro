module FormattingTests exposing (..)

import Pomodoro exposing (..)
import Expect
import Test exposing (..)


describeFormatting : Test
describeFormatting =
    describe "formatting"
        [ test "formats an unstarted Pomodoro" <|
            \() ->
                formatPomodoro unstartedPomodoro
                    |> Expect.equal "--:--"
        , test "formats a fresh Pomodoro" <|
            \() ->
                formatPomodoro freshPomodoro
                    |> Expect.equal "25:00"
        , test "formats a started Pomodoro" <|
            \() ->
                formatPomodoro (runningPomodoro (toTimeRemaining 18 27))
                    |> Expect.equal "18:27"
        , test "formats another started Pomodoro" <|
            \() ->
                formatPomodoro (runningPomodoro (toTimeRemaining 8 7))
                    |> Expect.equal "08:07"
        , test "formats a finished Pomodoro" <|
            \() ->
                formatPomodoro (runningPomodoro (toTimeRemaining 0 0))
                    |> Expect.equal "00:00"
        , test "formats a finished Pomodoro beyond 00:00" <|
            \() ->
                formatPomodoro (runningPomodoro (toTimeRemaining -2 -5))
                    |> Expect.equal "-02:05"
        ]
