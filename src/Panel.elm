module Panel exposing (..)

--import Html.Events exposing ()
import Char exposing (..)
import Debug exposing (..)
import Html exposing (Html, div, text, span)
import Html.Attributes exposing (class)
import Keyboard
import List exposing (..)
import String exposing (..)

-- MODEL

type alias Model =
    -- split buffer into String array
    { lines: List String
    , cursor: (Int, Int)
    }

initialModel : Model
initialModel =
    { lines =
          [ "bello world"
          , "other stuff"
          ]
    , cursor = (0, 0)
    }

-- MESSAGES
type Msg
    = KeyPressedMsg Keyboard.KeyCode
    | KeyDownMsg Keyboard.KeyCode
    -- cursor change (arrows)
    -- 


-- VIEW

renderLine : String -> Html a
renderLine l =
    div [ class "line" ]
        [ span [ ] [ text l ] ]

cursorToString : (Int, Int) -> String
cursorToString (x, y)=
    toString x ++ " | " ++ toString y

view : Model -> Html Msg
view model =
    div [ class "an" ]
        [ div [] (List.map renderLine model.lines)
        , span [ class "line" ] [ text (cursorToString model.cursor)]
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

-- TODO check against line length
right : Model -> (Int, Int)
right model =
    case model.cursor of
        (x,y) ->
            case nth x model.lines of
                Nothing -> model.cursor
                Just line ->
                    if y + 1 < String.length line  then
                        (x,y + 1)
                    else
                        model.cursor


up : Model -> (Int, Int)
up model =
    case model.cursor of
        (0,_) -> model.cursor
        -- calculate y if lines if shorter than previous line
        (x,y) -> (x - 1,y)

-- TODO check against lines count
down : Model -> (Int, Int)
down model =
    case model.cursor of
        (x,y) ->
            let
                lines = List.length model.lines
            in
                if x + 1 < lines then
                    -- calculate y if lines if shorter than previous line
                    (x + 1,y)
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


