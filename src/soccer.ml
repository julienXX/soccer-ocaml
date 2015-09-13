open Lwt
open Cohttp
open Cohttp_lwt_unix
open Yojson.Basic.Util
open Yojson.Safe

let extract_team_names json =
  [json]
    |> filter_member "standing"
    |> flatten
    |> filter_member "teamName"
    |> filter_string

let body =
  Client.get (Uri.of_string "http://api.football-data.org/alpha/soccerseasons/396/leagueTable") >>= fun (resp, body) ->
  body |> Cohttp_lwt_body.to_string >|= fun body ->
  body

let main () =
  let body = Lwt_main.run body in
  let json = Yojson.Basic.from_string body in
  List.iter print_endline (extract_team_names json)

let () = main ()
