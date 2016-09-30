module Panel exposing (..)

import Char exposing (..)
import Debug exposing (..)
import Html exposing (Html, div, text, span, pre)
import Html.Attributes exposing (class, style, id)
import Html.Events exposing (on, keyCode)
import Json.Decode as Json
import Keyboard
import List exposing (..)
import String exposing (..)
import Task exposing (Task)
import Dom

-- MODEL

type alias Model =
    -- split buffer into String array
    { lines: List String
    , cursor: (Int, Int)
    }

initialModel : Model
initialModel =
    { lines =
          [ "bello world iasjdlasjdlkajdlkajsdlksj"
          , "other stuff"
          ]
    , cursor = (0, 0)
    }

-- MESSAGES
type Msg
    = KeyPressedMsg Keyboard.KeyCode
    | KeyDownMsg Keyboard.KeyCode


-- VIEW

renderLine : String -> Html a
renderLine l =
    div [ class "line" ]
        [ span [ ] [ text l ] ]

cursorToString : (Int, Int) -> String
cursorToString (x, y)=
    toString x ++ " | " ++ toString y

cursorTop : Int -> String
cursorTop x =
    toString (Basics.toFloat x * 16) ++ "px"

cursorLeft : Int -> String
cursorLeft y =
    toString (Basics.toFloat y * 7.8) ++ "px"

view : Model -> Html Msg
view model =
    pre [ class "pan" ]
        [ div [ class "layer code-layer" ] (List.map renderLine model.lines)
        , div
              [ class "layer cursor-layer"]
              [ div
                [ class "cursor"
                , style
                      [ ("top", cursorTop (fst model.cursor) )
                      , ("left", cursorLeft (snd model.cursor) )
                      ]
                ] []
              ]
        ]

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
                        ( { lines = lastLess ++ last
                          -- cursor placement correction
                          , cursor = model.cursor
                          }
                        , Cmd.none
                        )

        KeyDownMsg 13 ->
            ( { lines = model.lines ++ [""]
              -- cursor placement correction
              , cursor = model.cursor
              }
            , Cmd.none
            )

        KeyPressedMsg keyCode ->
            let
                string = keyToString keyCode
                last =
                    case head (getLast model.lines) of
                        Nothing -> ""
                        Just a -> a
                lastLess = removeLast model.lines
            in
                ( { lines = lastLess ++ [(last ++ string)]
                    -- cursor placement correction
                  , cursor = model.cursor
                  }
                , Cmd.none
                )

        KeyDownMsg keyCode ->
            case keyCode of
                -- left/right
                37 ->
                    ( { model | cursor = left model }, Cmd.none)
                39 ->
                    ( { model | cursor = right model }, Cmd.none)
                -- up/down
                38 ->
                    ( { model | cursor = up model }, Cmd.none)
                40 ->
                    ( { model | cursor = down model }, Cmd.none)
                _ ->
                    ( model, Cmd.none )


left : Model -> (Int, Int)
left model =
    case model.cursor of
        (_,0) -> model.cursor
        (x,y) -> (x,y - 1)

nth : Int -> List a -> Maybe a
nth n xs =
    if n < 0 then Nothing
    else
        case drop n xs of
            [] -> Nothing
            x::_ -> Just x

right : Model -> (Int, Int)
right model =
    case model.cursor of
        (x,y) ->
            case nth x model.lines of
                Nothing -> model.cursor
                Just line ->
                    if y < String.length line  then
                        (x,y + 1)
                    else
                        model.cursor


up : Model -> (Int, Int)
up model =
    case model.cursor of
        (0,_) -> model.cursor
        -- calculate y if lines if shorter than previous line
        (x,y) -> (x - 1,y)

down : Model -> (Int, Int)
down model =
    case model.cursor of
        (x,y) ->
            let
                lines = List.length model.lines
                lineLength =
                    case nth (x + 1) model.lines of
                        Nothing -> y
                        Just line ->
                            let
                                len = String.length line
                            in
                                if y < len then
                                    y
                                else
                                    len
            in
                if x + 1 < lines then
                    (x + 1,lineLength)
                else
                    model.cursor

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

offsetWidth : Json.Decoder Float
offsetWidth =
    Json.at ["target", "offsetWidth"] Json.float

onKey : (Float -> msg) -> Html.Attribute msg
onKey tagger =
    on "keydown" (Json.map tagger offsetWidth)

onKeyDown : (Int -> msg) -> Html.Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger Html.Events.keyCode)





