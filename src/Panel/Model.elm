module Panel.Model exposing (..)

-- MODEL
type Tab = Soft Int | Hard

type alias Model =
    { lines: List String
    , cursor: (Int, Int)
    , ctrl: Bool
    , shift: Bool
    , tab : Tab
    }


initialModel : Model
initialModel =
    { lines =
          [ "bello world iasjdlasjdlkajdlkajsdlksj"
          , "other stuff"
          ]
    , cursor = (0, 0)
    , ctrl = False
    , shift = False
    , tab = Soft 2
    }
