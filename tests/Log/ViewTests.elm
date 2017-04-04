module Log.ViewTests exposing (..)

import App exposing (..)
import Test exposing (..)
import Expect
import Test.Html.Query as Query
import Test.Html.Selector exposing (id, tag, text, attribute, class)


all : Test
all =
    describe "Log.view"
        [ test "should show text input field" <|
            \() ->
                viewLog { initLog | currentInput = "this is what I worked on" }
                    |> Query.fromHtml
                    |> Query.find [ id "pomodoroLogInput", tag "input", attribute "type" "text" ]
                    |> Query.has [ attribute "value" "this is what I worked on" ]
        , test "should show a button" <|
            \() ->
                viewLog { initLog | currentInput = "this is what I worked on" }
                    |> Query.fromHtml
                    |> Query.find [ id "pomodoroLogButton", tag "button" ]
                    |> Query.has [ text "Log Pomodoro" ]
        , test "should show log" <|
            \() ->
                viewLog { initLog | log = [ "worked on this", "worked on that" ] }
                    |> Query.fromHtml
                    |> Query.findAll [ class "pomodoroLogEntry" ]
                    |> Query.count (Expect.equal 2)
        , test "should show an empty session log" <|
            \() ->
                viewLog { initLog | log = [] }
                    |> Query.fromHtml
                    |> Query.findAll [ class "pomodoroLogEntry" ]
                    |> Query.count (Expect.equal 0)
        ]
