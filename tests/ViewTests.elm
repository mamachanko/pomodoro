module ViewTests exposing (..)

import View exposing (view)
import Model exposing (Model)
import Time
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, id)


anActiveSession =
    (Model.Active Model.Pomodoro (Time.minute * 12 + Time.second * 34))


anOverflowingSession =
    (Model.Over Model.Pomodoro (Time.minute * 12 + Time.second * 34))


describeView : Test
describeView =
    describe "view"
        [ test "displays a message" <|
            \() ->
                view anActiveSession
                    |> Query.fromHtml
                    |> Query.has [ text "Pomodoro" ]
        , test "displays a active session" <|
            \() ->
                view anActiveSession
                    |> Query.fromHtml
                    |> Query.has [ text ("12:34") ]
        , test "displays an overflowing session" <|
            \() ->
                view anOverflowingSession
                    |> Query.fromHtml
                    |> Query.has [ text ("-12:34") ]
        , test "displays a button to start a Pomodoro" <|
            \() ->
                view anActiveSession
                    |> Query.fromHtml
                    |> Query.find [ tag "button", id "startPomodoro" ]
                    |> Query.has [ text "Pomodoro" ]
        , test "displays a button to start a short break" <|
            \() ->
                view anActiveSession
                    |> Query.fromHtml
                    |> Query.find [ tag "button", id "startShortBreak" ]
                    |> Query.has [ text "Short break" ]
        , test "displays a button to start a long break" <|
            \() ->
                view anActiveSession
                    |> Query.fromHtml
                    |> Query.find [ tag "button", id "startLongBreak" ]
                    |> Query.has [ text "Long break" ]
        ]
