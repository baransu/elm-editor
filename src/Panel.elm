module Panel exposing (..)

import Html exposing (Html, div, text, span)
--import Html.Events exposing ()
import Html.Attributes exposing (class)
import Char exposing (..)
import String exposing (..)
import Debug exposing (..)
import Keyboard
import List exposing (..)

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

getLast : List a -> List a
getLast list =
    case list of
        [] -> []
        l ->
            case head (List.reverse l) of
                Nothing -> []
                Just a -> [a]

removeLast : List a -> List a
removeLast list =
    case list of
        [] -> []
        l ->
            List.reverse (drop 1 (List.reverse l))

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
    case message of
        KeyDownMsg 8 ->
            case model.lines of
                [] ->
                    ( model, Cmd.none )
                lines ->
                    let
                        last =
                            case head (getLast lines) of
                                Nothing -> []
                                Just a ->
                                    case log "last" dropRight 1 a of
                                        "" -> []
                                        a -> [a]

                        lastLess = removeLast lines
                    in
                        ( { model | lines = lastLess ++ last }, Cmd.none )

        KeyDownMsg 13 ->
            ( { model | lines = model.lines ++ [""] }, Cmd.none )
        KeyPressedMsg keyCode ->
            let
                string = keyToString keyCode
                last =
                    case head (getLast model.lines) of
                        Nothing -> ""
                        Just a -> a
                lastLess = removeLast model.lines
            in
                ( { model | lines = lastLess ++ [(last ++ string)] }, Cmd.none )

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


