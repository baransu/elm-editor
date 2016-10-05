module Panel.Subscriptions exposing (..)

import Panel.Model exposing (Model)
import Panel.Messages exposing (..)
import Keyboard

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.presses KeyPressedMsg
        , Keyboard.downs KeyDownMsg
        , Keyboard.ups KeyUpMsg
        ]
