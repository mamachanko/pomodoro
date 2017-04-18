module App.Tests exposing (..)

import App exposing (..)
import Expect
import Date
import Time
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (id, tag, text, attribute, class)


all : Test
all =
    describe "App"
        [ describe ".init" <|
            [ test "should initialise all models" <|
                \() ->
                    init
                        |> Expect.equal
                            { timer = initTimer
                            , log = initLog
                            , notifications = initNotifications
                            }
            ]
        , describe ".update" <|
            [ test "should update timer" <|
                \() ->
                    Expect.equal (update StartPomodoro init) (updateTimer StartPomodoro init)
            , test "should update log" <|
                \() ->
                    Expect.equal (update (RecordPomodoro (Date.fromTime Time.second)) init) (updateLog (RecordPomodoro (Date.fromTime Time.second)) init)
            ]
        , describe ".view" <|
            [ test "should display timer" <|
                \() ->
                    view { init | timer = freshPomodoro }
                        |> Query.fromHtml
                        |> Query.find [ id "timer" ]
                        |> Query.has [ text ("25:00") ]
            , test "should display log" <|
                \() ->
                    view init
                        |> Query.fromHtml
                        |> Query.findAll [ id "log" ]
                        |> Query.count (Expect.equal 1)
            , test "should display shortcuts" <|
                \() ->
                    view init
                        |> Query.fromHtml
                        |> Query.findAll [ id "shortcuts" ]
                        |> Query.count (Expect.equal 1)
            ]
        ]
