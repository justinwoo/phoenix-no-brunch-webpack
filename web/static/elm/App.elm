module App where

import Html exposing (..)
import Html.Events exposing (onClick)

type alias File = String
type alias Files = List File

type alias Model = {
  files: Files,
  times: Int
}

type Action =
  NoOp
  | UpdateRequest

updateRequestMailbox : Signal.Mailbox Action
updateRequestMailbox = Signal.mailbox NoOp
port updateRequests : Signal String
port updateRequests =
  Signal.map (\x -> "updateRequest") updateRequestMailbox.signal

port newFiles : Signal Files

updateFiles : Signal (Model -> Model)
updateFiles =
  Signal.map
    (\files -> (\model -> { model | files <- files, times <- model.times + 1 }))
    newFiles

update : (Model -> Model) -> Model -> Model
update folder model =
  folder model

updateRequestButton : Html
updateRequestButton =
  button
    [
      onClick updateRequestMailbox.address UpdateRequest
    ]
    [text "request update"]

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
      updateRequestButton,
      h4 [] [text ("times updated: " ++ (toString model.times))],
      filesView model.files
    ]

model =
  {
    files = [],
    times = 0
  }

main =
  Signal.mergeMany
    [
      updateFiles
    ]
  |> Signal.foldp update model
  |> Signal.map view
