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
        [ test "should show log entries for dates" <|
            let
                log =
                    [ { date = Date.fromTime 0, text = "worked on stuff", editing = False }
                    , { date = Date.fromTime (Time.hour * 24), text = "worked on other stuff", editing = False }
                    ]
            in
                \() ->
                    viewLog log
                        |> Query.fromHtml
                        |> Query.findAll [ class "logDate" ]
                        |> Query.count (Expect.equal 2)
        , test "should show entry for date" <|
            \() ->
                viewLog [ { date = Date.fromTime ((Time.hour * 24) * 180 + Time.hour * 2 + Time.minute * 15), text = "worked on stuff", editing = False } ]
                    |> Query.fromHtml
                    |> Query.find [ class "logDate" ]
                    |> Query.has [ text "30-06-1970" ]
        , test "should show log entries for date" <|
            \() ->
                viewLog [ { date = Date.fromTime ((Time.hour * 24) * 180 + Time.hour * 2 + Time.minute * 15), text = "worked on stuff", editing = False } ]
                    |> Query.fromHtml
                    |> Query.find [ class "logEntryDate" ]
                    |> Query.has [ text "03:15" ]
        , test "should show log entries with text" <|
            \() ->
                viewLog [ { date = Date.fromTime ((Time.hour * 24) * 180 + Time.hour * 2 + Time.minute * 15), text = "worked on stuff", editing = False } ]
                    |> Query.fromHtml
                    |> Query.find [ class "logEntryText" ]
                    |> Query.has [ text "worked on stuff" ]
        , test "should show log entries with id" <|
            \() ->
                viewLog [ { date = Date.fromTime 0, text = "worked on stuff", editing = False } ]
                    |> Query.fromHtml
                    |> Query.find [ class "logEntryText" ]
                    |> Query.has [ id ("pomodoro-" ++ (Date.fromTime 0 |> toString)) ]
        , test "should show an empty session log" <|
            \() ->
                viewLog []
                    |> Query.fromHtml
                    |> Query.findAll [ class "logEntry" ]
                    |> Query.count (Expect.equal 0)
        , test "should group log entries by date" <|
            \() ->
                let
                    logEntry =
                        { date = Date.fromTime 0, text = "worked on stuff", editing = False }

                    dayOne =
                        { logEntry | date = Date.fromTime 1 }

                    dayOne_ =
                        { logEntry | date = Date.fromTime Time.hour }

                    dayTwo =
                        { logEntry | date = Date.fromTime <| Time.hour * 25 }

                    dayTwo_ =
                        { logEntry | date = Date.fromTime <| Time.hour * 26 }

                    dayThree =
                        { logEntry | date = Date.fromTime <| Time.hour * 50 }

                    log =
                        [ dayOne, dayOne_, dayTwo, dayTwo_, dayThree ]

                    expectedGroupByDate =
                        [ ( "03-01-1970", [ dayThree ] )
                        , ( "02-01-1970", [ dayTwo_, dayTwo ] )
                        , ( "01-01-1970", [ dayOne_, dayOne ] )
                        ]
                in
                    groupByDate log
                        |> Expect.equal expectedGroupByDate
        ]
