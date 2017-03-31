module Timer.Model exposing (init, Model(Timer))


init : Model
init =
    Timer 2


type Model
    = Timer Int
