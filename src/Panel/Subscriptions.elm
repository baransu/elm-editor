port module Panel.Subscriptions exposing (..)

import Panel.Model exposing (Model)
import Panel.Messages exposing (..)
import Keyboard


-- SUBSCRIPTIONS

port onCommand : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.presses KeyPressedMsg
        , Keyboard.downs KeyDownMsg
        , Keyboard.ups KeyUpMsg
        , onCommand OpenFile
        ]
