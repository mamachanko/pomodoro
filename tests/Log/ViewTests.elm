module Log.ViewTests exposing (..)

import App exposing (..)
import Test exposing (..)
import Expect
import Date
import Time
import Test.Html.Query as Query
import Test.Html.Selector exposing (id, tag, text, attribute, class)


all : Test
all =
    describe "Log.view"
        [ test "should show log" <|
            \() ->
                viewLog [ { date = Date.fromTime Time.second, text = "worked on this" }, { date = Date.fromTime Time.second, text = "worked on that" } ]
                    |> Query.fromHtml
                    |> Query.findAll [ class "pomodoroLogEntry" ]
                    |> Query.count (Expect.equal 2)
        , test "should show an empty session log" <|
            \() ->
                viewLog []
                    |> Query.fromHtml
                    |> Query.findAll [ class "pomodoroLogEntry" ]
                    |> Query.count (Expect.equal 0)
        ]
