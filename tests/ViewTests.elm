module ViewTests exposing (..)

import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, boolAttribute)
import Pomodoro exposing (..)


describeView : Test
describeView =
    describe "view"
        [ test "displays a message" <|
            \() ->
                view unstartedPomodoro
                    |> Query.fromHtml
                    |> Query.has [ text "Pomodoro" ]
        , test "displays an unstarted Pomodoro" <|
            \() ->
                view unstartedPomodoro
                    |> Query.fromHtml
                    |> Query.has [ text (formatPomodoro unstartedPomodoro) ]
        , test "displays a running Pomodoro" <|
            \() ->
                view (runningPomodoro (toTimeRemaining 18 27))
                    |> Query.fromHtml
                    |> Query.has [ text "18:27" ]
        ]
