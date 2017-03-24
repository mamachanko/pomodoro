module UpdateTests exposing (..)

import Update exposing (update)
import Model exposing (..)
import Notifications
import Time
import Test exposing (..)
import Expect


describeUpdate : Test
describeUpdate =
    describe "update"
        [ describe "Pomodoro" <|
            [ test "when it starts" <|
                \() ->
                    update StartPomodoro initialModel
                        |> Expect.equal ( Model freshPomodoro noPastSessions, Cmd.none )
            , test "when it is counting down" <|
                \() ->
                    Model (Active Pomodoro (Time.minute * 2 + Time.second * 24)) noPastSessions
                        |> update tick
                        |> Expect.equal ( Model (Active Pomodoro (Time.minute * 2 + Time.second * 23)) noPastSessions, Cmd.none )
            , test "when it is up" <|
                \() ->
                    Model (Active Pomodoro (Time.second * 1)) noPastSessions
                        |> update tick
                        |> Expect.equal
                            ( Model (Over Pomodoro 0) noPastSessions, Notifications.notifyEndOfPomodoro )
            , test "when it is recorded" <|
                \() ->
                    Model (Over Pomodoro (Time.second * 50)) []
                        |> update (RecordPomodoro "worked on stuff")
                        |> Expect.equal
                            ( Model (Over Pomodoro 0) [ DonePomodoro "worked on stuff" ], Notifications.notifyEndOfPomodoro )
            , test "when it is running over" <|
                \() ->
                    Model (Over Pomodoro 0) noPastSessions
                        |> update tick
                        |> Expect.equal ( Model (Over Pomodoro Time.second) noPastSessions, Cmd.none )
            , test "when it continues to run over" <|
                \() ->
                    Model (Over Pomodoro (Time.second * 59)) noPastSessions
                        |> update tick
                        |> Expect.equal ( Model (Over Pomodoro Time.minute) noPastSessions, Cmd.none )
            ]
        , describe "short break" <|
            [ test "when it starts" <|
                \() ->
                    Model unstartedShortBreak noPastSessions
                        |> update StartShortBreak
                        |> Expect.equal ( Model freshShortBreak noPastSessions, Cmd.none )
            , test "when it is counting down" <|
                \() ->
                    Model (Active ShortBreak (Time.minute * 2 + Time.second * 24)) noPastSessions
                        |> update tick
                        |> Expect.equal ( Model (Active ShortBreak (Time.minute * 2 + Time.second * 23)) noPastSessions, Cmd.none )
            , test "when it is up" <|
                \() ->
                    Model (Active ShortBreak (Time.second * 1)) noPastSessions
                        |> update tick
                        |> Expect.equal
                            ( Model (Over ShortBreak 0) [ DoneShortBreak ]
                            , Notifications.notifyEndOfBreak
                            )
            , test "when it is running over" <|
                \() ->
                    Model (Over ShortBreak 0) noPastSessions
                        |> update tick
                        |> Expect.equal ( Model (Over ShortBreak Time.second) noPastSessions, Cmd.none )
            , test "when it continues to run over" <|
                \() ->
                    Model (Over ShortBreak (Time.second * 59)) noPastSessions
                        |> update tick
                        |> Expect.equal ( Model (Over ShortBreak Time.minute) noPastSessions, Cmd.none )
            ]
        , describe "long break" <|
            [ test "when it starts" <|
                \() ->
                    Model unstartedLongBreak noPastSessions
                        |> update StartLongBreak
                        |> Expect.equal ( Model freshLongBreak noPastSessions, Cmd.none )
            , test "when it is counting down" <|
                \() ->
                    Model (Active LongBreak (Time.minute * 2 + Time.second * 24)) noPastSessions
                        |> update tick
                        |> Expect.equal ( Model (Active LongBreak (Time.minute * 2 + Time.second * 23)) noPastSessions, Cmd.none )
            , test "when it is up" <|
                \() ->
                    Model (Active LongBreak (Time.second * 1)) noPastSessions
                        |> update tick
                        |> Expect.equal
                            ( Model (Over LongBreak 0) [ DoneLongBreak ]
                            , Notifications.notifyEndOfBreak
                            )
            , test "when it is running over" <|
                \() ->
                    Model (Over LongBreak 0) noPastSessions
                        |> update tick
                        |> Expect.equal ( Model (Over LongBreak Time.second) noPastSessions, Cmd.none )
            , test "when it continues to run over" <|
                \() ->
                    Model (Over LongBreak (Time.second * 59)) noPastSessions
                        |> update tick
                        |> Expect.equal ( Model (Over LongBreak Time.minute) noPastSessions, Cmd.none )
            ]
        , describe "desktop notifications" <|
            [ test "requests to permit desktop notifications" <|
                \() ->
                    let
                        anyModel =
                            Model (Inactive Pomodoro 123) noPastSessions
                    in
                        anyModel
                            |> update EnableDesktopNotifications
                            |> Expect.equal ( anyModel, Notifications.enableDesktopNotifications )
            ]
        , describe "keyboard shortcuts" <|
            [ test "starts a Pomodoro" <|
                \() ->
                    let
                        anyModel =
                            Model (Inactive Pomodoro 123) noPastSessions
                    in
                        update (KeyboardEvent 960) anyModel
                            |> Expect.equal ( Model freshPomodoro noPastSessions, Cmd.none )
            , test "starts a short break" <|
                \() ->
                    let
                        anyModel =
                            Model (Inactive Pomodoro 123) noPastSessions
                    in
                        update (KeyboardEvent 223) anyModel
                            |> Expect.equal ( Model freshShortBreak noPastSessions, Cmd.none )
            , test "starts a long break" <|
                \() ->
                    let
                        anyModel =
                            Model (Inactive Pomodoro 123) noPastSessions
                    in
                        update (KeyboardEvent 172) anyModel
                            |> Expect.equal ( Model freshLongBreak noPastSessions, Cmd.none )
            ]
        ]
