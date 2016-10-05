module Panel.Update exposing (..)

import String exposing (..)
import List exposing (..)
import Keyboard
import Char exposing (..)

import Panel.Model exposing (..)
import Panel.Messages exposing (..)

-- UPDATE

keyToString : Keyboard.KeyCode -> String
keyToString keyCode =
    fromChar ( fromCode keyCode )


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
        -- modifiers ctrl/shift
        KeyDownMsg 17 ->
            ( { model | ctrl = True }, Cmd.none)

        KeyUpMsg 17 ->
            ( { model | ctrl = False }, Cmd.none)

        KeyDownMsg 16 ->
            ( { model | shift = True }, Cmd.none)

        KeyUpMsg 16 ->
            ( { model | shift = False }, Cmd.none)

        -- backspace
        KeyDownMsg 8 ->
            case model.lines of
                [] ->
                    ( model, Cmd.none )
                lines ->
                    let
                        x = fst model.cursor
                        y = snd model.cursor
                        middle =
                            case nth x model.lines of
                                Nothing -> ""
                                Just a -> deleteCharFromString a y

                        front =
                            let
                                f = List.take x model.lines
                                last =
                                    case head (getLast f) of
                                        Nothing -> []
                                        Just a -> [(a ++ middle)]
                            in
                                case model.cursor of
                                    (0,0) -> f ++ [middle]
                                    (x,0) -> (removeLast f) ++ last
                                    _ -> f ++ [middle]

                        back = List.drop (x + 1) model.lines
                        lines = front ++ back
                        cursor =
                            case model.cursor of
                                (0, 0) -> model.cursor
                                (x,0) ->
                                    case nth (x - 1) front of
                                        Nothing -> model.cursor
                                        Just a ->
                                            let
                                                y = (String.length a) - (String.length middle)
                                            in
                                                (x - 1, y)
                                _ -> left model
                    in
                        ( { model |
                                lines = lines,
                                cursor = cursor
                          }
                        , Cmd.none
                        )

        -- handle other keys like arrows/tab
        KeyDownMsg keyCode ->
            case  keyCode of
                -- tab
                9 ->
                    let
                        y =
                            case model.tab of
                                Hard -> 1
                                Soft a ->
                                    case model.shift of
                                        False -> snd model.cursor + a
                                        True ->
                                            if snd model.cursor - a <= 0 then
                                                0
                                            else
                                                snd model.cursor - a
                        string =
                            case model.tab of
                                Hard -> "\t"
                                Soft a -> String.repeat a " "
                        x = fst model.cursor
                        front = List.take x model.lines
                        back = List.drop (x + 1) model.lines
                        middle =
                            case nth x model.lines of
                                Nothing -> []
                                Just a ->
                                    case model.shift of
                                        True -> [dropTab model.tab a]
                                        False -> [string ++ a]
                        lines = front ++ middle ++ back
                    in
                        ( { model |
                                lines = lines,
                                cursor = (x, y)
                          }
                        , Cmd.none
                        )
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


        -- char insert
        KeyPressedMsg keyCode ->
            case model.ctrl of
                True ->
                    ( model , Cmd.none )
                False ->
                    let
                        string = keyToString keyCode
                        x = fst model.cursor
                        y = snd model.cursor
                        front = List.take x model.lines
                        back = List.drop (x + 1) model.lines
                        middle =
                            case nth x model.lines of
                                Nothing -> []
                                Just a ->
                                    case keyCode of
                                        13 -> String.lines (changeElement a y string)
                                        _ -> [changeElement a y string]
                        lines = front ++ middle ++ back
                    in
                        case keyCode of
                            -- is enter
                            13 ->
                                ( { model |
                                        lines = lines,
                                        cursor = (x + 1, 0)
                                  }
                                , Cmd.none
                                )
                            -- else
                            _ ->
                                ( { model |
                                        lines = lines,
                                        cursor = (x, y + 1)
                                  }
                                , Cmd.none
                                )

        _ ->
            ( model, Cmd.none )


dropTab : Tab -> String -> String
dropTab tab line =
    let
        size =
            case tab of
                Soft a -> a
                Hard -> 0
        string = String.repeat size " "
    in
        if String.left size line == string then
            String.dropLeft size line
        else
            line


deleteCharFromString : String -> Int -> String
deleteCharFromString base n =
    let
        left = String.left n base
        right = String.dropLeft n base
    in
        (String.dropRight 1 left) ++ right


changeElement : String -> Int -> String -> String
changeElement base n addition =
    let
        left = String.left n base
        right = String.dropLeft n base
    in
        left ++ addition ++ right


nth : Int -> List a -> Maybe a
nth n xs =
    if n < 0 then Nothing
    else
        case drop n xs of
            [] -> Nothing
            x::_ -> Just x


left : Model -> (Int, Int)
left model =
    case model.cursor of
        (_,0) -> model.cursor
        (x,y) -> (x,y - 1)


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


getLineLength : (Int, Int) -> Int -> List String -> Int
getLineLength (x, y) modifier lines =
    case nth (x + modifier) lines of
        Nothing -> y
        Just line ->
            let
                len = String.length line
            in
                if y < len then
                    y
                else
                    len

up : Model -> (Int, Int)
up model =
    case model.cursor of
        (0,_) -> model.cursor
        (x,y) ->
            let
                lines = List.length model.lines
                lineLength = getLineLength model.cursor (-1) model.lines
            in
                if x - 1 < lines then
                    (x - 1, lineLength)
                else
                    (x - 1,y)


down : Model -> (Int, Int)
down model =
    case model.cursor of
        (x,y) ->
            let
                lines = List.length model.lines
                lineLength = getLineLength model.cursor 1 model.lines
            in
                if x + 1 < lines then
                    (x + 1,lineLength)
                else
                    model.cursor
