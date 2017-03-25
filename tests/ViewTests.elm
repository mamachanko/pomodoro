module ViewTests exposing (..)

import Expect
import Model exposing (Model, Session(..), SessionType(..), initialModel)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (id, tag, text)
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
        ]
