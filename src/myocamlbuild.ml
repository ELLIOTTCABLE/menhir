open Ocamlbuild_plugin
open Command

(* ---------------------------------------------------------------------------- *)

(* Compilation flags. *)

let flags () =
  (* -inline 1000 *)
  flag ["ocaml"; "compile"; "native"] (S [A "-inline"; A "1000"]);
  (* -noassert *)
  flag ["ocaml"; "compile"; "noassert"] (S [A "-noassert"]);
  (* nazi warnings *)
  flag ["ocaml"; "compile"; "my_warnings"] (S[A "-w"; A "@1..49-4-9-41-44"])

(* ---------------------------------------------------------------------------- *)

(* A command for copying a file. *)

let copy_file_from_tag src dst env build =
  Cmd (S [A "cp"; T (tags_of_pathname src); P dst])

(* ---------------------------------------------------------------------------- *)

(* Dealing with the two parsers. *)

(* Just for fun, Menhir comes with two parsers for its own input files. One is
   called [yacc-parser.mly] and is built using [ocamlyacc]. The other is called
   [fancy-parser.mly] and is built using Menhir. It depends on [standard.mly].
   The choice between the two parsers is determined by the presence of the tag
   [yacc_parser] or [fancy_parser]. *)

let parser_rule () =
  (* The three dependencies. *)  
  flag_and_dep ["origin_parser"; "yacc_parser"]  (P "yacc-parser.mly");
  flag_and_dep ["origin_parser"; "fancy_parser"] (P "fancy-parser.mly");
  dep ["origin_parser"; "fancy_parser"] ["standard.mly"];
  (* The two rules. *)
  rule  "yacc-parser -> parser" ~prod:"parser.mly" (copy_file_from_tag  "yacc-parser.mly" "parser.mly");
  rule "fancy-parser -> parser" ~prod:"parser.mly" (copy_file_from_tag "fancy-parser.mly" "parser.mly")

let driver_rule () =
  (* The source file is either [yaccDriver.ml] or [fancyDriver.ml], depending
     on which tag is (globally) present: [yacc_parser] or [fancy_parser]. *)
  let source =
    if Tags.mem "yacc_parser" (tags_of_pathname "")
    then "yaccDriver.ml"
    else "fancyDriver.ml"
  in
  (* The target file is [Driver.ml]. *)
  let target =
    "Driver.ml"
  in
  (* A copy rule. *)
  copy_rule "create Driver.ml" source target

(* ---------------------------------------------------------------------------- *)

(* The file [FancyParserMessages.ml] is generated by Menhir based on
   [fancy-parser.messages], which is maintained by hand. Of course,
   this is possible only in stage 2 of the bootstrap process, since
   Menhir is required. *)

let messages_rule () =
  if Tags.mem "fancy_parser" (tags_of_pathname "") then
    (* The target. *)
    let prod = "FancyParserMessages.ml" in
    (* The two source files. *)
    let messages = "fancy-parser.messages"
    and grammar = "parser.mly" in
    (* The production rule. *)
    rule
      "fancy parser messages"
      ~prod:prod
      ~deps:[ messages; grammar ]
      (fun env _ ->
        Cmd(S[
          !Options.ocamlyacc; (* menhir *)
          P (env grammar);
          A "--compile-errors"; P (env messages);
          Sh ">"; Px (env prod);
        ]))

(* ---------------------------------------------------------------------------- *)

(* Define custom compilation rules. *)

let () =
  dispatch (function After_rules ->
    (* Add our rules after the standard ones. *)
    parser_rule();
    driver_rule();
    messages_rule();
    flags();
  | _ -> ()
  )
