module Editor.Messages exposing (..)

import Keyboard exposing (KeyCode)


-- MESSAGES


type Msg
    = KeyPressedMsg KeyCode
    | KeyDownMsg KeyCode
    | KeyUpMsg KeyCode
    | OpenFile String
