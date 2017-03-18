port module Sound exposing (ringBell)


bell =
    "beep.mp3"


ringBell : Cmd msg
ringBell =
    playSound bell


port playSound : String -> Cmd msg
