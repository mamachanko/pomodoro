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
                        |> Expect.equal ( Model freshPomodoro nopastPomodoros, Cmd.none )
            , test "when it is counting down" <|
                \() ->
                    Model (Active Pomodoro (Time.minute * 2 + Time.second * 24)) nopastPomodoros
                        |> update tick
                        |> Expect.equal ( Model (Active Pomodoro (Time.minute * 2 + Time.second * 23)) nopastPomodoros, Cmd.none )
            , test "when it is up" <|
                \() ->
                    Model (Active Pomodoro (Time.second * 1)) nopastPomodoros
                        |> update tick
                        |> Expect.equal
                            ( Model (Over Pomodoro 0) nopastPomodoros, Notifications.notifyEndOfPomodoro )
            , test "when it is recorded" <|
                \() ->
                    Model freshPomodoro [ "worked on stuff" ]
                        |> update (RecordPomodoro "worked on more stuff")
                        |> Expect.equal
                            ( Model freshPomodoro [ "worked on more stuff", "worked on stuff" ], Cmd.none )
            , test "when it is running over" <|
                \() ->
                    Model (Over Pomodoro 0) nopastPomodoros
                        |> update tick
                        |> Expect.equal ( Model (Over Pomodoro Time.second) nopastPomodoros, Cmd.none )
            , test "when it continues to run over" <|
                \() ->
                    Model (Over Pomodoro (Time.second * 59)) nopastPomodoros
                        |> update tick
                        |> Expect.equal ( Model (Over Pomodoro Time.minute) nopastPomodoros, Cmd.none )
            ]
        , describe "short break" <|
            [ test "when it starts" <|
                \() ->
                    Model unstartedShortBreak nopastPomodoros
                        |> update StartShortBreak
                        |> Expect.equal ( Model freshShortBreak nopastPomodoros, Cmd.none )
            , test "when it is counting down" <|
                \() ->
                    Model (Active ShortBreak (Time.minute * 2 + Time.second * 24)) nopastPomodoros
                        |> update tick
                        |> Expect.equal ( Model (Active ShortBreak (Time.minute * 2 + Time.second * 23)) nopastPomodoros, Cmd.none )
            , test "when it is running over" <|
                \() ->
                    Model (Over ShortBreak 0) nopastPomodoros
                        |> update tick
                        |> Expect.equal ( Model (Over ShortBreak Time.second) nopastPomodoros, Cmd.none )
            , test "when it continues to run over" <|
                \() ->
                    Model (Over ShortBreak (Time.second * 59)) nopastPomodoros
                        |> update tick
                        |> Expect.equal ( Model (Over ShortBreak Time.minute) nopastPomodoros, Cmd.none )
            ]
        , describe "long break" <|
            [ test "when it starts" <|
                \() ->
                    Model unstartedLongBreak nopastPomodoros
                        |> update StartLongBreak
                        |> Expect.equal ( Model freshLongBreak nopastPomodoros, Cmd.none )
            , test "when it is counting down" <|
                \() ->
                    Model (Active LongBreak (Time.minute * 2 + Time.second * 24)) nopastPomodoros
                        |> update tick
                        |> Expect.equal ( Model (Active LongBreak (Time.minute * 2 + Time.second * 23)) nopastPomodoros, Cmd.none )
            , test "when it is running over" <|
                \() ->
                    Model (Over LongBreak 0) nopastPomodoros
                        |> update tick
                        |> Expect.equal ( Model (Over LongBreak Time.second) nopastPomodoros, Cmd.none )
            , test "when it continues to run over" <|
                \() ->
                    Model (Over LongBreak (Time.second * 59)) nopastPomodoros
                        |> update tick
                        |> Expect.equal ( Model (Over LongBreak Time.minute) nopastPomodoros, Cmd.none )
            ]
        , describe "desktop notifications" <|
            [ test "requests to permit desktop notifications" <|
                \() ->
                    let
                        anyModel =
                            Model (Inactive Pomodoro 123) nopastPomodoros
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
                            Model (Inactive Pomodoro 123) nopastPomodoros
                    in
                        update (KeyboardEvent 960) anyModel
                            |> Expect.equal ( Model freshPomodoro nopastPomodoros, Cmd.none )
            , test "starts a short break" <|
                \() ->
                    let
                        anyModel =
                            Model (Inactive Pomodoro 123) nopastPomodoros
                    in
                        update (KeyboardEvent 223) anyModel
                            |> Expect.equal ( Model freshShortBreak nopastPomodoros, Cmd.none )
            , test "starts a long break" <|
                \() ->
                    let
                        anyModel =
                            Model (Inactive Pomodoro 123) nopastPomodoros
                    in
                        update (KeyboardEvent 172) anyModel
                            |> Expect.equal ( Model freshLongBreak nopastPomodoros, Cmd.none )
            ]
        ]
