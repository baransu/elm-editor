module Editor.View exposing (..)

import Html exposing (Html, div, text, span, pre)
import Html.Attributes exposing (class, style, id, tabindex)
import List exposing (..)
import Html.Keyed as Keyed
import Editor.Model exposing (..)
import Editor.Messages exposing (..)


-- VIEW


emptyLineHelper : String -> String
emptyLineHelper l =
    case l of
        "" ->
            " "

        _ ->
            l



-- CODE RENDERING


renderLine : Int -> String -> ( String, Html a )
renderLine key l =
    ( toString key
    , div
        [ class "line" ]
        [ div [ style [ ( "position", "absolute" ), ( "left", "-30px" ) ] ]
            [ div [ class "linenumber" ] [ text <| toString key ] ]
        , pre []
            [ span [] [ text (emptyLineHelper l) ] ]
        ]
    )


renderCode : Model -> Html a
renderCode model =
    Keyed.node "div"
        [ class "layer code-layer" ]
        (List.indexedMap renderLine model.lines)



-- CURSOR RENDERING


renderCursor : Model -> Html a
renderCursor model =
    div
        [ class "cursor"
        , style
            [ ( "top", cursorTop (Tuple.first model.cursor) )
            , ( "left", cursorLeft (Tuple.second model.cursor) )
            ]
        ]
        []



-- SELECTION RENDERING


selectionBlock : ( Float, String ) -> ( Float, String ) -> Int -> Int -> Html a
selectionBlock width height left top =
    div
        [ class "selection"
        , style
            [ ( "height", (toString (Tuple.first height)) ++ (Tuple.second height) )
            , ( "width", (toString (Tuple.first width)) ++ (Tuple.second width) )
            , ( "left", cursorLeft left )
            , ( "top", cursorTop top )
            ]
        ]
        []


selection : Model -> List (Html a)
selection { cursor, selectionStart } =
    let
        ( cursorX, cursorY ) =
            cursor

        ( startX, startY ) =
            selectionStart

        top =
            min cursorX startX

        showEnd =
            linesCount - 1 >= 0

        bottom =
            max cursorX startX

        linesCount =
            abs (cursorX - startX)

        ( topLeft, bottomWidth ) =
            if not showEnd then
                ( min cursorY startY, abs (cursorY - startY) )
            else if cursorX < startX then
                ( cursorY, startY )
            else
                ( startY, cursorY )

        selectionDivs =
            if showEnd then
                [ selectionBlock ( 100, "%" ) ( 16.0, "px" ) topLeft top
                , selectionBlock ( 100, "%" ) ( Basics.toFloat (linesCount - 1) * 16, "px" ) 0 (top + 1)
                , selectionBlock ( Basics.toFloat bottomWidth * 7.8, "px" ) ( 16.0, "px" ) 0 bottom
                ]
            else
                [ selectionBlock ( Basics.toFloat bottomWidth * 7.8, "px" ) ( 16.0, "px" ) topLeft top
                ]
    in
        selectionDivs


renderSelection : Model -> Html a
renderSelection model =
    div
        [ class "layer selection-layer"
        , style
            [ ( "visibility"
              , if model.selection then
                    "visible"
                else
                    "hidden"
              )
            ]
        ]
        (selection model)



-- helper debuging function


cursorToString : ( Int, Int ) -> String
cursorToString ( x, y ) =
    toString x ++ " | " ++ toString y


cursorTop : Int -> String
cursorTop x =
    toString (Basics.toFloat x * 16) ++ "px"


cursorLeft : Int -> String
cursorLeft y =
    toString (Basics.toFloat y * 7.8) ++ "px"



-- TODO should we move key events from window to pane because of Tab focus


codeHeight : List a -> ( String, String )
codeHeight lines =
    ( "height"
    , lines
        |> List.length
        |> (*) 16
        |> toString
        |> (\a b -> b ++ a) "px"
    )


view : Model -> Html Msg
view model =
    div [ class "pane", style [ codeHeight model.lines ] ]
        [ div [ class "sizer" ]
            [ renderCode model
            , renderCursor model
            , renderSelection model
            ]
          -- dyanimc height
        , div [ class "gutters", style [ codeHeight model.lines ] ]
            -- dynamic width
            [ div [ class "gutter", style [ ( "width", "30px" ) ] ] [] ]
        ]
