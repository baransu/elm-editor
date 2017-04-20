module Main exposing (..)

import Html exposing (Html, div, text)


type Msg
    = No0p


type alias Model =
    String


view : Model -> Html Msg
view model =
    div [] [ text "elm-editor example" ]


init : ( Model, Cmd Msg )
init =
    ( "", Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
