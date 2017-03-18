module ViewTests exposing (..)

import View exposing (view)
import Model exposing (Model)
import Time
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, id)


aSession =
    (Model.Active Model.Pomodoro (Time.minute * 12 + Time.second * 34))


describeView : Test
describeView =
    describe "view"
        [ test "displays a message" <|
            \() ->
                view aSession
                    |> Query.fromHtml
                    |> Query.has [ text "Pomodoro" ]
        , test "displays a session" <|
            \() ->
                view aSession
                    |> Query.fromHtml
                    |> Query.has [ text ("12:34") ]
        , test "displays a button to start a Pomodoro" <|
            \() ->
                view aSession
                    |> Query.fromHtml
                    |> Query.find [ tag "button", id "startPomodoro" ]
                    |> Query.has [ text "Pomodoro" ]
        , test "displays a button to start a short break" <|
            \() ->
                view aSession
                    |> Query.fromHtml
                    |> Query.find [ tag "button", id "startShortBreak" ]
                    |> Query.has [ text "Short break" ]
        , test "displays a button to start a long break" <|
            \() ->
                view aSession
                    |> Query.fromHtml
                    |> Query.find [ tag "button", id "startLongBreak" ]
                    |> Query.has [ text "Long break" ]
        ]
