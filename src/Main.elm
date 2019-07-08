module Main exposing (Book)

import Dict exposing (Dict)


type alias Book =
    { title : String
    , authorName : String
    }


show : Book -> String
show { title, authorName } =
    title ++ ", by " ++ authorName
