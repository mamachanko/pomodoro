module App exposing (init, initWithFlags, update, subscriptions, view, Action(..))

import Log
import Notifications
import Timer
import Html exposing (Html, div, map, programWithFlags, h1, text)
import Html.Attributes exposing (id)


init : Model
init =
    { timer = Timer.init
    , log = Log.init
    , notifications = Notifications.init
    }


initWithFlags : List String -> ( Model, Cmd msg )
initWithFlags log =
    let
        initialLog =
            Log.init

        loadedLog =
            { initialLog | log = log }
    in
        ( { init | log = loadedLog }, Cmd.none )


type alias Model =
    { timer : Timer.Model
    , log : Log.Model
    , notifications : Notifications.Model
    }


type Action
    = ActionForTimer Timer.Action
    | ActionForLog Log.Action
    | ActionForNotifications Notifications.Action


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        ActionForTimer timerAction ->
            let
                ( timer_, cmds ) =
                    Timer.update timerAction model.timer

                cmds_ =
                    Cmd.map ActionForTimer cmds
            in
                ( { model | timer = timer_ }, cmds_ )

        ActionForLog logAction ->
            let
                ( log_, cmds ) =
                    Log.update logAction model.log

                cmds_ =
                    Cmd.map ActionForLog cmds
            in
                ( { model | log = log_ }, cmds_ )

        ActionForNotifications notificationsAction ->
            let
                ( notifications_, cmds ) =
                    Notifications.update notificationsAction model.notifications

                cmds_ =
                    Cmd.map ActionForNotifications cmds
            in
                ( { model | notifications = notifications_ }, cmds_ )


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.batch
        [ Sub.map ActionForTimer <| Timer.subscriptions model.timer
        , Sub.map ActionForLog <| Log.subscriptions model.log
        , Sub.map ActionForNotifications <| Notifications.subscriptions model.notifications
        ]


view : Model -> Html Action
view model =
    div [ id "App" ]
        [ h1 [ id "header" ] [ text "Pomodoro" ]
        , map (\timerAction -> ActionForTimer timerAction) (Timer.view model.timer)
        , map (\notificationsAction -> ActionForNotifications notificationsAction) (Notifications.view model.notifications)
        , map (\logAction -> ActionForLog logAction) (Log.view model.log)
        ]


main =
    programWithFlags
        { init = initWithFlags
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
