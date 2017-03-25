module ViewTests exposing (..)

import Expect
import Model exposing (Model, Session(..), SessionType(..), initialModel)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (id, tag, text, attribute, class)
import Time
import View exposing (view)


describeView : Test
describeView =
    describe "view"
        [ test "displays a message" <|
            \() ->
                view initialModel
                    |> Query.fromHtml
                    |> Query.find [ id "header" ]
                    |> Query.has [ text "Pomodoro" ]
        , describe "timer"
            [ test "displays a active session" <|
                \() ->
                    view { initialModel | currentSession = Active Pomodoro <| Time.minute * 12 + Time.second * 34 }
                        |> Query.fromHtml
                        |> Query.find [ id "timer" ]
                        |> Query.has [ text ("12:34") ]
            , test "displays a inactive session" <|
                \() ->
                    view { initialModel | currentSession = Inactive Pomodoro <| Time.minute * 12 + Time.second * 34 }
                        |> Query.fromHtml
                        |> Query.find [ id "timer" ]
                        |> Query.has [ text ("12:34") ]
            , test "displays an overflowing session" <|
                \() ->
                    view { initialModel | currentSession = Over Pomodoro <| Time.minute * 12 + Time.second * 34 }
                        |> Query.fromHtml
                        |> Query.find [ id "timer" ]
                        |> Query.has [ text ("-12:34") ]
            ]
        , describe "controls"
            [ test "displays a button to start a Pomodoro" <|
                \() ->
                    view initialModel
                        |> Query.fromHtml
                        |> Query.find [ tag "button", id "startPomodoro" ]
                        |> Query.has [ text "Pomodoro" ]
            , test "displays a button to start a short break" <|
                \() ->
                    view initialModel
                        |> Query.fromHtml
                        |> Query.find [ tag "button", id "startShortBreak" ]
                        |> Query.has [ text "Short break" ]
            , test "displays a button to start a long break" <|
                \() ->
                    view initialModel
                        |> Query.fromHtml
                        |> Query.find [ tag "button", id "startLongBreak" ]
                        |> Query.has [ text "Long break" ]
            , test "displays a button to enable desktop notifications" <|
                \() ->
                    view initialModel
                        |> Query.fromHtml
                        |> Query.find [ tag "button", id "enableDesktopNotifications" ]
                        |> Query.has [ text "Enable desktop notifications" ]
            ]
        , describe "session log"
            [ test "shows text input" <|
                \() ->
                    view
                        { initialModel
                            | currentText = "this is what I worked on"
                            , showPomodoroLogInput = True
                        }
                        |> Query.fromHtml
                        |> Query.find [ id "pomodoroLogInput", tag "input", attribute "type" "text" ]
                        |> Query.has [ attribute "value" "this is what I worked on" ]
            , test "shows a button" <|
                \() ->
                    view
                        { initialModel
                            | currentText = "this is what I worked on"
                            , showPomodoroLogInput = True
                        }
                        |> Query.fromHtml
                        |> Query.find [ id "pomodoroLogButton", tag "button" ]
                        |> Query.has [ text "Log Pomodoro" ]
            , test "does not show text input" <|
                \() ->
                    view { initialModel | showPomodoroLogInput = False }
                        |> Query.fromHtml
                        |> Query.findAll [ id "pomodoroLogButton", tag "input", attribute "type" "text" ]
                        |> Query.count (Expect.equal 0)
            , test "shows session log" <|
                \() ->
                    view { initialModel | pastPomodoros = [ "worked on this", "worked on that" ] }
                        |> Query.fromHtml
                        |> Query.findAll [ class "pomodoroLogEntry" ]
                        |> Query.count (Expect.equal 2)
            , test "shows empty session log" <|
                \() ->
                    view { initialModel | pastPomodoros = [] }
                        |> Query.fromHtml
                        |> Query.findAll [ class "pomodoroLogEntry" ]
                        |> Query.count (Expect.equal 0)
            ]
        ]
