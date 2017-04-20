module Panel.Model exposing (..)

-- MODEL


type Tab
    = Soft Int
    | Hard


type alias Model =
    { lines : List String
    , cursor : ( Int, Int )
    , ctrl : Bool
    , shift : Bool
    , tab : Tab
    , selection : Bool
    , selectionStart : ( Int, Int )
    }


initialModel : Model
initialModel =
    { lines = []
    , cursor = ( 0, 0 )
    , ctrl = False
    , shift = False
    , tab = Soft 2
    , selection = False
    , selectionStart = ( 0, 0 )
    }
