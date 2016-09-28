module Panel exposing (..)

import Html exposing (Html, div, text, span)
--import Html.Events exposing ()
import Html.Attributes exposing (class)
import Char exposing (..)
import String exposing (..)
import Debug exposing (..)
import Keyboard

-- MODEL

type alias Model =
    -- split buffer into String array
    { lines: List String
    }

initialModel : Model
initialModel =
    { lines =
          [ "bello world"
          , "other stuff"
          ]
    }

-- MESSAGES
-- key pressed
-- shortcuts etc
type Msg
    = KeyPressedMsg Keyboard.KeyCode
    | KeyDownMsg Keyboard.KeyCode


-- VIEW

renderLine : String -> Html a
renderLine l =
    div [ ]
        [ span [ class "line" ] [ text l ] ]

view : Model -> Html Msg
view model =
    div [ ] (List.map renderLine model.lines)

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
    case message of
        -- KeyDownMsg 8 ->
        --     --( { model | buffer = dropRight 1 model.buffer}, Cmd.none )
        -- -- ENTER (32 case)

        -- KeyPressedMsg keyCode ->
        --     let
        --         --string = log "keyCode" (toString keyCode)
        --         string = keyToString keyCode
        --     in
        --        ( { model | buffer = model.buffer ++ string }, Cmd.none )

        _ ->
            ( model, Cmd.none )


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.presses KeyPressedMsg
        , Keyboard.downs KeyDownMsg
        ]

keyToString : Keyboard.KeyCode -> String
keyToString keyCode =
    fromChar ( fromCode keyCode )


