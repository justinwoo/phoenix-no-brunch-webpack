module App where

import Html exposing (..)
import Html.Events exposing (onClick, on)
import Json.Decode as Json
import String

type alias File = String
type alias Files = List File

type alias Model = {
  files: Files,
  times: Int,
  filterPhrase: Maybe String
}

-- may change in the future
type alias ViewModel = Model

type Action =
  NoOp
  | UpdateRequest

updateRequestMailbox : Signal.Mailbox Action
updateRequestMailbox = Signal.mailbox NoOp
port updateRequests : Signal String
port updateRequests =
  Signal.map (\x -> "updateRequest") updateRequestMailbox.signal

port newFiles : Signal Files

filterPhraseInputMailbox : Signal.Mailbox String
filterPhraseInputMailbox = Signal.mailbox ""

updateFiles : Signal (Model -> Model)
updateFiles =
  Signal.map
    (\files -> (\model -> { model | files <- files, times <- model.times + 1 }))
    newFiles

updateFilterPhrase : Signal (Model -> Model)
updateFilterPhrase =
  Signal.map
    (\inputValue ->
      let
        filterPhrase = if | not (String.isEmpty inputValue) -> Just inputValue
                          | otherwise -> Nothing
      in
        (\model -> { model | filterPhrase <- filterPhrase }))
    filterPhraseInputMailbox.signal

update : (Model -> Model) -> Model -> Model
update folder model =
  folder model

applyFilter : Model -> ViewModel
applyFilter model =
  case model.filterPhrase of
    Just phrase ->
      { model |
        files <-
          List.filter
            (\item -> String.contains phrase item)
            model.files }
    Nothing -> model

computeViewModel : Model -> ViewModel
computeViewModel model =
  applyFilter model

targetValueString : Json.Decoder String
targetValueString =
  Json.at ["target", "value"] Json.string

updateRequestButton : Html
updateRequestButton =
  button
    [
      onClick updateRequestMailbox.address UpdateRequest
    ]
    [text "request update"]

filterPhraseInput : Html
filterPhraseInput =
  input
    [
      on "keyup" targetValueString (\value -> Signal.message filterPhraseInputMailbox.address value)
    ]
    []

fileView : File -> Html
fileView file =
  div [] [text file]

filesView : Files -> Html
filesView files =
  div [] (List.map (\n -> fileView n) files)

view : ViewModel -> Html
view model =
  div []
    [
      h3 [] [text "Muh Filez:"],
      updateRequestButton,
      div []
        [
          text "filter",
          filterPhraseInput
        ],
      h4 [] [text ("times updated: " ++ (toString model.times))],
      filesView model.files
    ]

model =
  {
    files = [],
    times = 0,
    filterPhrase = Nothing
  }

main =
  Signal.mergeMany
    [
      updateFiles,
      updateFilterPhrase
    ]
  |> Signal.foldp update model
  |> Signal.map computeViewModel
  |> Signal.map view
