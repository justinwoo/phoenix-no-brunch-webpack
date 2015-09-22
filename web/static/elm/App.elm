module App where

import Html exposing (..)

type alias File = String
type alias Files = List File

type alias Model = {
  files: Files
}

port newFiles : Signal Files

updateFiles : Signal (Model -> Model)
updateFiles =
  Signal.map
    (\files -> (\model -> { model | files <- files }))
    newFiles


update : (Model -> Model) -> Model -> Model
update folder model =
  folder model

fileView : File -> Html
fileView file =
  div [] [text file]

filesView : Files -> Html
filesView files =
  div [] (List.map (\n -> fileView n) files)

view : Model -> Html
view model =
  div []
    [
      h3 [] [text "Muh Filez:"],
      filesView model.files
    ]

model =
  {
    files = []
  }

main =
  Signal.map view (Signal.foldp update model updateFiles)
