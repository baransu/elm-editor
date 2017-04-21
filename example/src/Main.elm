module Main exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Editor.Model exposing (..)
import Editor.Messages exposing (..)
import Editor.Subscriptions exposing (..)
import Editor.Update exposing (..)
import Editor.View exposing (..)


-- MODEL


type alias Model =
    { panelModel : Editor.Model.Model }


init : ( Model, Cmd Msg )
init =
    ( { panelModel = Editor.Model.initialModel
      }
    , Cmd.none
    )



-- MESSAGES


type Msg
    = EditorMsg Editor.Messages.Msg



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ Html.map EditorMsg (Editor.View.view model.panelModel)
        ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EditorMsg subMsg ->
            let
                ( updateEditorModel, panelCmd ) =
                    Editor.Update.update subMsg model.panelModel
            in
                ( { model | panelModel = updateEditorModel }
                , Cmd.map EditorMsg panelCmd
                )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map EditorMsg (Editor.Subscriptions.subscriptions model.panelModel)
        ]



-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
