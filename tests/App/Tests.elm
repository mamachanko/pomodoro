module App.Tests exposing (..)

import App exposing (init, update, subscriptions, view, Action(ActionForNotifications, ActionForTimer, ActionForLog))
import Expect
import Log
import Notifications
import Test exposing (..)
import Timer
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
                            { timer = Timer.init
                            , log = Log.init
                            , notifications = Notifications.init
                            }
            ]
        , describe ".update" <|
            [ test "should update timer" <|
                \() ->
                    let
                        ( newTimer, cmds ) =
                            Timer.update Timer.StartPomodoro Timer.init

                        newCmds =
                            Cmd.map ActionForTimer cmds
                    in
                        update (ActionForTimer Timer.StartPomodoro) init
                            |> Expect.equal
                                ( { init | timer = newTimer }, newCmds )
            , test "should update log" <|
                \() ->
                    let
                        ( newLog, cmds ) =
                            Log.update Log.RecordPomodoro Log.init

                        newCmds =
                            Cmd.map ActionForLog cmds
                    in
                        update (ActionForLog Log.RecordPomodoro) init
                            |> Expect.equal
                                ( { init | log = newLog }, newCmds )
            , test "should update notifications" <|
                \() ->
                    let
                        ( newNotifications, cmds ) =
                            Notifications.update Notifications.EnableDesktopNotifications Notifications.init

                        newCmds =
                            Cmd.map ActionForNotifications cmds
                    in
                        update (ActionForNotifications Notifications.EnableDesktopNotifications) init
                            |> Expect.equal
                                ( { init | notifications = newNotifications }, newCmds )
            ]
        , describe ".view" <|
            [ test "should display timer" <|
                \() ->
                    view { init | timer = Timer.freshPomodoro }
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
                                [ Sub.map ActionForTimer (Timer.subscriptions init.timer)
                                , Sub.map ActionForLog (Log.subscriptions init.log)
                                , Sub.map ActionForNotifications (Notifications.subscriptions init.notifications)
                                ]
                            )
            ]
        ]
