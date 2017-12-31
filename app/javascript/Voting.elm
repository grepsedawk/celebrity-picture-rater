module Main exposing (..)

import Html exposing (Html, div, p, text, button, img)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Keyboard
import Json.Decode exposing (Decoder, nullable, string, int)
import Json.Decode.Pipeline exposing (decode, required)
import String exposing (toLower)
import Http


type alias Model =
    { celebrity_id : Int
    , uuid : String
    , left_picture_path : String
    , right_picture_path : String
    }


type alias Flags =
    { celebrity_id : Int }


type Choice
    = Left
    | Right


init : Flags -> ( Model, Cmd Message )
init flags =
    let
        { celebrity_id } =
            flags
    in
        ( Model celebrity_id "" "" "", getVote celebrity_id )


view : Model -> Html Message
view model =
    div []
        [ div [] [ p [] [ text "Left or Right? Click or use left/right arrow keys to vote!" ] ]
        , div
            []
            [ img [ src model.left_picture_path, onClick VoteLeft ] []
            , img [ src model.right_picture_path, onClick VoteRight ] []
            ]
        ]


type Message
    = NewVote (Result Http.Error Model)
    | VoteLeft
    | VoteRight
    | KeyMsg Keyboard.KeyCode


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        VoteLeft ->
            ( model, submitVote model Left )

        VoteRight ->
            ( model, submitVote model Right )

        NewVote (Ok newModel) ->
            ( newModel, Cmd.none )

        NewVote (Err _) ->
            ( model, Cmd.none )

        KeyMsg code ->
            if code == 37 then
                ( model, submitVote model Left )
            else if code == 39 then
                ( model, submitVote model Right )
            else
                ( model, Cmd.none )


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.batch [ Keyboard.downs KeyMsg ]


main : Program Flags Model Message
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


submitVote : Model -> Choice -> Cmd Message
submitVote model choice =
    let
        url =
            "/celebrities/"
                ++ toString model.celebrity_id
                ++ "/vote/"
                ++ model.uuid
                ++ "/"
                ++ toLower (toString choice)

        request =
            Http.get url decodeVote
    in
        Http.send NewVote request


getVote : Int -> Cmd Message
getVote celebrity_id =
    let
        url =
            "/celebrities/" ++ toString celebrity_id ++ "/vote/new"

        request =
            Http.get url decodeVote
    in
        Http.send NewVote request


decodeVote : Decoder Model
decodeVote =
    decode Model
        |> required "celebrity_id" (int)
        |> required "uuid" (string)
        |> required "left_picture_path" (string)
        |> required "right_picture_path" (string)
