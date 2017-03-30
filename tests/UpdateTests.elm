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
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = freshPomodoro
                              }
                            , Cmd.none
                            )
            , test "when it is counting down" <|
                \() ->
                    { initialModel | currentSession = Active Pomodoro <| Time.minute * 2 + Time.second * 24 }
                        |> update tick
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = Active Pomodoro <| Time.minute * 2 + Time.second * 23
                              }
                            , Cmd.none
                            )
            , test "when it is up" <|
                \() ->
                    { initialModel | currentSession = Active Pomodoro <| Time.second * 1 }
                        |> update tick
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = (Over Pomodoro 0)
                                , showPomodoroLogInput = True
                              }
                            , Notifications.notifyEndOfPomodoro
                            )
            , test "when it is running over" <|
                \() ->
                    { initialModel | currentSession = Over Pomodoro 0 }
                        |> update tick
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = Over Pomodoro Time.second
                              }
                            , Cmd.none
                            )
            , test "when it continues to run over" <|
                \() ->
                    { initialModel | currentSession = Over Pomodoro <| Time.second * 59 }
                        |> update tick
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = Over Pomodoro Time.minute
                              }
                            , Cmd.none
                            )
            ]
        , describe "short break" <|
            [ test "when it starts" <|
                \() ->
                    { initialModel | currentSession = unstartedShortBreak }
                        |> update StartShortBreak
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = freshShortBreak
                              }
                            , Cmd.none
                            )
            , test "when it is counting down" <|
                \() ->
                    { initialModel | currentSession = Active ShortBreak <| Time.minute * 2 + Time.second * 24 }
                        |> update tick
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = Active ShortBreak <| Time.minute * 2 + Time.second * 23
                              }
                            , Cmd.none
                            )
            , test "when it is up" <|
                \() ->
                    { initialModel | currentSession = Active ShortBreak <| Time.second * 1 }
                        |> update tick
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = (Over ShortBreak 0)
                              }
                            , Notifications.notifyEndOfBreak
                            )
            , test "when it is running over" <|
                \() ->
                    { initialModel | currentSession = Over ShortBreak 0 }
                        |> update tick
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = Over ShortBreak Time.second
                              }
                            , Cmd.none
                            )
            , test "when it continues to run over" <|
                \() ->
                    { initialModel | currentSession = Over ShortBreak <| Time.second * 59 }
                        |> update tick
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = Over ShortBreak Time.minute
                              }
                            , Cmd.none
                            )
            ]
        , describe "long break" <|
            [ test "when it starts" <|
                \() ->
                    { initialModel | currentSession = unstartedLongBreak }
                        |> update StartLongBreak
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = freshLongBreak
                              }
                            , Cmd.none
                            )
            , test "when it is counting down" <|
                \() ->
                    { initialModel | currentSession = Active LongBreak <| Time.minute * 2 + Time.second * 24 }
                        |> update tick
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = Active LongBreak <| Time.minute * 2 + Time.second * 23
                              }
                            , Cmd.none
                            )
            , test "when it is up" <|
                \() ->
                    { initialModel | currentSession = Active LongBreak <| Time.second * 1 }
                        |> update tick
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = (Over LongBreak 0)
                              }
                            , Notifications.notifyEndOfBreak
                            )
            , test "when it is running over" <|
                \() ->
                    { initialModel | currentSession = Over LongBreak 0 }
                        |> update tick
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = Over LongBreak Time.second
                              }
                            , Cmd.none
                            )
            , test "when it continues to run over" <|
                \() ->
                    { initialModel | currentSession = Over LongBreak <| Time.second * 59 }
                        |> update tick
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = Over LongBreak Time.minute
                              }
                            , Cmd.none
                            )
            ]
        , describe "desktop notifications" <|
            [ test "requests to permit desktop notifications" <|
                \() ->
                    initialModel
                        |> update EnableDesktopNotifications
                        |> Expect.equal
                            ( initialModel, Notifications.enableDesktopNotifications )
            ]
        , describe "keyboard shortcuts" <|
            [ test "starts a Pomodoro" <|
                \() ->
                    update (KeyboardEvent 960) initialModel
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = freshPomodoro
                              }
                            , Cmd.none
                            )
            , test "starts a short break" <|
                \() ->
                    update (KeyboardEvent 223) initialModel
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = freshShortBreak
                              }
                            , Cmd.none
                            )
            , test "starts a long break" <|
                \() ->
                    update (KeyboardEvent 172) initialModel
                        |> Expect.equal
                            ( { initialModel
                                | currentSession = freshLongBreak
                              }
                            , Cmd.none
                            )
            ]
        , describe "recording Pomodoros"
            [ test "when it is recorded" <|
                \() ->
                    { initialModel
                        | pomodoroLog = [ "worked on stuff" ]
                        , currentText = "worked on more stuff"
                        , showPomodoroLogInput = True
                    }
                        |> update RecordPomodoro
                        |> Expect.equal
                            ( { initialModel
                                | pomodoroLog = [ "worked on more stuff", "worked on stuff" ]
                                , currentText = ""
                                , showPomodoroLogInput = False
                              }
                            , Cmd.none
                            )
            , test "when there's text input" <|
                \() ->
                    { initialModel | currentText = "worked on " }
                        |> update (TextInput "worked on stuff")
                        |> Expect.equal
                            ( { initialModel
                                | currentText = "worked on stuff"
                              }
                            , Cmd.none
                            )
            ]
        ]
