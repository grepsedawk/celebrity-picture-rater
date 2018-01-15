module Voting exposing (..)

import Html exposing (Html, div, p, text, button, img, node)
import Html.Attributes exposing (src, class, href, rel)
import Html.Events exposing (onClick)
import Keyboard
import Json.Decode exposing (Decoder, nullable, string, int, list)
import Json.Decode.Pipeline exposing (decode, required)
import String exposing (toLower)
import List exposing (head)
import Http


type alias Model =
    { celebrity_id : Int
    , votes : List Vote
    }


type alias Vote =
    { uuid : String
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
        ( Model celebrity_id [], getVotes celebrity_id 3 )


view : Model -> Html Message
view model =
    case head model.votes of
        Nothing ->
            div [] [ text "Loading..." ]

        Just vote ->
            div []
                [ p []
                    [ text "Left or Right? Click or use left/right arrow keys to vote!" ]
                , div
                    [ class "voting-images" ]
                    [ img [ src vote.left_picture_path, onClick (SubmitVote Left) ] []
                    , img [ src vote.right_picture_path, onClick (SubmitVote Right) ] []
                    ]
                , div [] (renderPrefetchVotes model.votes)
                ]


renderPrefetchVote : Vote -> Html Message
renderPrefetchVote vote =
    div []
        [ node "link" [ rel "prefetch", href vote.left_picture_path ] []
        , node "link" [ rel "prefetch", href vote.right_picture_path ] []
        ]


renderPrefetchVotes : List Vote -> List (Html Message)
renderPrefetchVotes votes =
    List.map renderPrefetchVote votes


type Message
    = AddVotes (Result Http.Error (List Vote))
    | SubmitVote Choice
    | FinishVote (Result Http.Error Choice)
    | KeyMsg Keyboard.KeyCode


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        SubmitVote choice ->
            case head model.votes of
                Nothing ->
                    ( model, Cmd.none )

                Just vote ->
                    ( model, Cmd.batch [ submitVote model vote choice, getVotes model.celebrity_id 1 ] )

        FinishVote (Ok choice) ->
            ( removeLastVote model, Cmd.none )

        AddVotes (Ok newVotes) ->
            ( { model | votes = model.votes ++ newVotes }, Cmd.none )

        FinishVote (Err _) ->
            ( model, Cmd.none )

        AddVotes (Err _) ->
            ( model, Cmd.none )

        KeyMsg code ->
            case head model.votes of
                Nothing ->
                    ( model, Cmd.none )

                Just vote ->
                    if code == 37 then
                        ( model, Cmd.batch [ submitVote model vote Left, getVotes model.celebrity_id 1 ] )
                    else if code == 39 then
                        ( model, Cmd.batch [ submitVote model vote Right, getVotes model.celebrity_id 1 ] )
                    else
                        ( model, Cmd.none )


removeLastVote : Model -> Model
removeLastVote model =
    { model | votes = List.drop 1 model.votes }


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


submitVote : Model -> Vote -> Choice -> Cmd Message
submitVote model vote choice =
    let
        url =
            "/celebrities/"
                ++ toString model.celebrity_id
                ++ "/vote/"
                ++ vote.uuid
                ++ "/"
                ++ toLower (toString choice)

        request =
            Http.get url (Json.Decode.succeed choice)
    in
        Http.send FinishVote request


getVotes : Int -> Int -> Cmd Message
getVotes celebrity_id count =
    let
        url =
            "/celebrities/" ++ toString celebrity_id ++ "/vote/new?count=" ++ toString count

        request =
            Http.get url decodeVotes
    in
        Http.send AddVotes request


decodeVote : Decoder Vote
decodeVote =
    decode Vote
        |> required "uuid" (string)
        |> required "left_picture_path" (string)
        |> required "right_picture_path" (string)


decodeVotes : Decoder (List Vote)
decodeVotes =
    decode identity
        |> required "votes" (list decodeVote)
