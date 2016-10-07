port module Main exposing (..)

import Html exposing (Html, div, text)
import Html.App
import Html.Attributes exposing (..)
import Panel.Model exposing (..)
import Panel.Messages exposing (..)
import Panel.Subscriptions exposing (..)
import Panel.Update exposing (..)
import Panel.View exposing (..)


-- MODEL

type alias Model =
    { panelModel: Panel.Model.Model }

init : ( Model, Cmd Msg )
init =
    ({ panelModel = Panel.Model.initialModel
     }
    , Cmd.none
    )


-- MESSAGES

type Msg
    = PanelMsg Panel.Messages.Msg


-- VIEW

view : Model -> Html Msg
view model =
    div [ class "application" ]
        [ Html.App.map PanelMsg (Panel.View.view model.panelModel) ]


-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PanelMsg subMsg ->
            let
                ( updatePanelModel, panelCmd ) =
                    Panel.Update.update subMsg model.panelModel
            in
                ({ model | panelModel = updatePanelModel }
                , Cmd.map PanelMsg panelCmd
                )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map PanelMsg ( Panel.Subscriptions.subscriptions model.panelModel )
        ]

-- MAIN

main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

