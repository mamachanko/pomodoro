module App.Tests exposing (..)

import App exposing (..)
import Expect
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
        , describe ".initWithFlags" <|
            [ test "should initialise log" <|
                \() ->
                    let
                        initialLog =
                            initLog
                    in
                        initWithFlags [ "this", "that" ]
                            |> Expect.equal
                                ({ init
                                    | log = { initialLog | log = [ "this", "that" ] }
                                 }
                                    ! []
                                )
            ]
        , describe ".update" <|
            [ test "should update timer" <|
                \() ->
                    let
                        ( newTimer, cmds ) =
                            updateTimer StartPomodoro initTimer

                        newCmds =
                            cmds
                    in
                        update StartPomodoro init
                            |> Expect.equal
                                ( { init | timer = newTimer }, newCmds )
            , test "should update log" <|
                \() ->
                    let
                        ( newLog, cmds ) =
                            updateLog RecordPomodoro initLog

                        newCmds =
                            cmds
                    in
                        update RecordPomodoro init
                            |> Expect.equal
                                ( { init | log = newLog }, newCmds )
            , test "should update notifications" <|
                \() ->
                    let
                        ( newNotifications, cmds ) =
                            updateNotifications EnableDesktopNotifications initNotifications

                        newCmds =
                            cmds
                    in
                        update (ActionForNotifications Notifications.EnableDesktopNotifications) init
                            |> Expect.equal
                                ( { init | notifications = newNotifications }, newCmds )
            ]
        , describe ".view" <|
            [ test "should display timer" <|
                \() ->
                    view { init | timer = freshPomodoro }
                        |> Query.fromHtml
                        |> Query.find [ id "time" ]
                        |> Query.has [ text ("25:00") ]
            , test "should display log" <|
                \() ->
                    view init
                        |> Query.fromHtml
                        |> Query.findAll [ id "pomodoroLog" ]
                        |> Query.count (Expect.equal 1)
            , test "should display notifications" <|
                \() ->
                    view init
                        |> Query.fromHtml
                        |> Query.find [ tag "button", id "enableDesktopNotifications" ]
                        |> Query.has [ text "Enable desktop notifications" ]
            ]
        , describe ".subscriptions" <|
            [ test "should listen to timer related events" <|
                \() ->
                    subscriptions init
                        |> Expect.equal
                            (Sub.batch
                                [ subscriptionsTimer init.timer
                                , subscriptionsLog init.log
                                , subscriptionsNotifications init.notifications
                                ]
                            )
            ]
        ]
