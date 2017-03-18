module Format exposing (formatTime)

import Time


formatTime : Time.Time -> String
formatTime time =
    if time >= 0 then
        formatTime_ time
    else
        "-" ++ (formatTime_ (abs time))


formatTime_ : Time.Time -> String
formatTime_ time =
    (formatMinutes time) ++ ":" ++ (formatSeconds time)


formatMinutes : Time.Time -> String
formatMinutes time =
    let
        minutes =
            truncate (Time.inMinutes time)
    in
        if minutes == 0 then
            "00"
        else if minutes < 10 then
            "0" ++ toString minutes
        else
            toString minutes


formatSeconds : Time.Time -> String
formatSeconds time =
    let
        seconds =
            Time.inSeconds <|
                toFloat <|
                    (truncate time)
                        % (truncate Time.minute)
    in
        if seconds == 0 then
            "00"
        else if seconds < 10 then
            "0" ++ toString seconds
        else
            toString seconds
