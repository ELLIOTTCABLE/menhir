(* This script checks that the code back-end, the table back-end, and the
   reference interpreter appear to be working correctly. It uses the calc
   demo for this purpose. *)

type sexp =
  | A of string
  | L of sexp list

let rec print_sexp ppf = function
  | A s -> Format.pp_print_string ppf s
  | L l ->
      Format.fprintf ppf "@[<1>(%a)@]"
        (Format.pp_print_list ~pp_sep:Format.pp_print_space print_sexp) l

let print_sexp sexp =
  Format.printf "@[<v>%a@;@]" print_sexp sexp

let calc_data =
  "calc-data"

let calc_data_slash filename =
  calc_data ^ "/" ^ filename

let check mode base =
  print_sexp
    (L[A"rule";
       L[A"alias"; A"test"];
       L[A"action";
         L[A"progn";
           L[A"diff"; A(calc_data_slash (base ^ ".ref.out")); A(base ^ "." ^ mode ^ ".out")];
           L[A"diff"; A(calc_data_slash (base ^ ".ref.err")); A(base ^ "." ^ mode ^ ".err")]]]])

let process_real_test basename =
  let print_rule mode =
    print_sexp
      (L[A"rule";
         L[A"with-stdout-to"; A(basename ^ "." ^ mode ^ ".out");
           L[A"with-stderr-to"; A(basename ^ "." ^ mode ^ ".err");
             L[A"with-stdin-from"; A(calc_data_slash (basename ^ ".in"));
               L[A"run"; A("calc/" ^ mode ^ "/calc.exe")]]]]])
  in

  (* Build the parser with the code back-end and run it. *)
  print_rule "code";

  (* Build the parser with the table back-end and run it. *)
  print_rule "table";

  (* Build the parser with the table back-end (with --inspection) and run it. *)
  print_rule "inspection";

  (* Compare the results to the reference. *)
  check "code" basename;
  check "table" basename;
  check "inspection" basename

let process_ideal_test basename =
  (* Run the reference interpreter. *)
  print_sexp
    (L[A"rule";
       L[A"with-stdout-to"; A(basename ^ ".interpret.out");
         L[A"with-stderr-to"; A(basename ^ ".interpret.err");
           L[A"with-stdin-from"; A(calc_data_slash (basename ^ ".in"));
             L[A"run"; A"menhir"; A"--trace"; A"--interpret"; A"%{dep:calc/parser.mly}"]]]]]);

  (* Check the results of the reference interpreter. *)
  check "interpret" basename

type test =
  | RealTest of string
  | IdealTest of string

let process = function
  | RealTest basename ->
      process_real_test basename
  | IdealTest basename ->
      process_ideal_test basename

let classify basename =
  if Filename.check_suffix basename ".real" then
    RealTest basename
  else if Filename.check_suffix basename ".ideal" then
    IdealTest basename
  else
    failwith ("Unexpected suffix: " ^ basename)

let () =
  Sys.readdir calc_data
  |> Array.to_list
  |> List.filter (fun basename -> Filename.check_suffix basename ".in")
  |> List.map (fun basename -> Filename.chop_suffix basename ".in")
  |> List.map classify
  |> List.iter process
