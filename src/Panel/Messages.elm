module Panel.Messages exposing (..)

import Keyboard

-- MESSAGES
type Msg
    = KeyPressedMsg Keyboard.KeyCode
    | KeyDownMsg Keyboard.KeyCode
    | KeyUpMsg Keyboard.KeyCode

