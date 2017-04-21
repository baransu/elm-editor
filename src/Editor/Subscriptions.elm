port module Editor.Subscriptions exposing (..)

import Editor.Model exposing (Model)
import Editor.Messages exposing (..)
import Keyboard exposing (ups, downs, presses)


-- SUBSCRIPTIONS


port onCommand : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ presses KeyPressedMsg
        , downs KeyDownMsg
        , ups KeyUpMsg
        , onCommand OpenFile
        ]
