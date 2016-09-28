module Main exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (..)
import Html.App
import Panel exposing (..)


-- MODEL

-- split panel into array of panels
type alias Model =
    { panelModel: Panel.Model }

init : ( Model, Cmd Msg )
init =
    ({ panelModel = Panel.initialModel
     }
    , Cmd.none
    )


-- MESSAGES

type Msg
    = PanelMsg Panel.Msg


-- VIEW

view : Model -> Html Msg
view model =
    div [ class "" ]
        [ Html.App.map PanelMsg (Panel.view model.panelModel) ]


-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PanelMsg subMsg ->
            let
                ( updatePanelModel, panelCmd ) =
                    Panel.update subMsg model.panelModel
            in
                ({ model | panelModel = updatePanelModel }
                , Cmd.map PanelMsg panelCmd
                )


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map PanelMsg ( Panel.subscriptions model.panelModel )


-- MAIN

main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
