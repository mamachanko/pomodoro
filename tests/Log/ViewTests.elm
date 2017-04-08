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
        [ test "should show log entries" <|
            let
                log =
                    [ { date = Date.fromTime 0, text = "worked on stuff" }
                    , { date = Date.fromTime (Time.hour * 24), text = "worked on other stuff" }
                    ]
            in
                \() ->
                    viewLog log
                        |> Query.fromHtml
                        |> Query.findAll [ class "pomodoroLogEntry" ]
                        |> Query.count (Expect.equal 2)
        , test "should show log entry with date" <|
            \() ->
                viewLog [ { date = Date.fromTime ((Time.hour * 24) * 180 + Time.hour * 2 + Time.minute * 15), text = "worked on stuff" } ]
                    |> Query.fromHtml
                    |> Query.find [ class "pomodoroLogEntry" ]
                    |> Query.has [ text "30-06-1970 03:15: worked on stuff" ]
        , test "should show an empty session log" <|
            \() ->
                viewLog []
                    |> Query.fromHtml
                    |> Query.findAll [ class "pomodoroLogEntry" ]
                    |> Query.count (Expect.equal 0)
        ]
