module Notifications.ViewTests exposing (..)

import App exposing (..)
import Test exposing (..)
import Expect
import Test.Html.Query as Query
import Test.Html.Selector exposing (id, tag, text, attribute, class)


all : Test
all =
    describe "Notifications.view"
        [ test "should display a button to enable desktop notifications" <|
            \() ->
                viewNotifications initNotifications
                    |> Query.fromHtml
                    |> Query.find [ tag "button", id "enableDesktopNotifications" ]
                    |> Query.has [ text "Enable desktop notifications" ]
        ]
