module Panel.View exposing (..)

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

import Panel.Model exposing (..)
import Panel.Messages exposing (..)

-- VIEW

emptyLineHelper : String -> String
emptyLineHelper l =
    case l of
        "" -> " "
        _ -> l

renderLine : String -> Html a
renderLine l =
    div [ class "line" ]
        [ span [ ] [ text (emptyLineHelper l) ]]

cursorToString : (Int, Int) -> String
cursorToString (x, y)=
    toString x ++ " | " ++ toString y

cursorTop : Int -> String
cursorTop x =
    toString (Basics.toFloat x * 16) ++ "px"

cursorLeft : Int -> String
cursorLeft y =
    toString (Basics.toFloat y * 7.8) ++ "px"


selectionBlock : (Float, String) -> (Float, String) -> Int -> Int -> Html a
selectionBlock width height left top =
    div [ class "selection"
        , style [ ("height", (toString (fst height)) ++ (snd height) )
                , ("width", (toString (fst width)) ++ (snd width) )
                , ("left", cursorLeft left )
                , ("top", cursorTop top )
                ]
        ] []

selection : Model -> List (Html a)
selection model =
    let
        top = min (fst model.cursor) (fst model.selectionStart)
        showEnd = linesCount - 1 >= 0
        topLeft =
            if not showEnd then
                min (snd model.cursor) (snd model.selectionStart)

            else if fst model.cursor < fst model.selectionStart then
                snd model.cursor

            else
                snd model.selectionStart

        bottomWidth =
            if not showEnd then
                abs ((snd model.cursor) - (snd model.selectionStart))

            else if fst model.cursor > fst model.selectionStart then
                snd model.cursor

            else
                snd model.selectionStart


        bottom = max (fst model.cursor) (fst model.selectionStart)
        linesCount = abs ((fst model.cursor) - (fst model.selectionStart))
        begin =
            if showEnd then
                [selectionBlock (100, "%") (16.0, "px") topLeft top]
            else
                [selectionBlock (Basics.toFloat bottomWidth * 7.8, "px") (16.0, "px") topLeft top]

        middle =
            if showEnd then
                [selectionBlock (100, "%") (Basics.toFloat (linesCount - 1) * 16, "px") 0 (top + 1)]
            else
                [ ]
        end =
            if showEnd then
                [selectionBlock (Basics.toFloat bottomWidth * 7.8, "px") (16.0, "px") 0 bottom]
            else
                [ ]

    in
        begin ++ middle ++ end


view : Model -> Html Msg
view model =
    pre [ id "panel", class "pan" ]
        [ div [ class "layer code-layer" ] (List.map renderLine model.lines)
        , div
              [ class "layer cursor-layer"]
              [ div
                [ class "cursor"
                , id "cursor"
                , style
                      [ ("top", cursorTop (fst model.cursor) )
                      , ("left", cursorLeft (snd model.cursor) )
                      ]
                ] []
              ]
        , div
            [ class "layer selection-layer", style [ ("visibility", if model.selection then "visible" else "hidden") ] ]
            (selection model)
        ]
