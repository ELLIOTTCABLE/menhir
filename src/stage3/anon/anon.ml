let line_directive_re =
  Str.regexp {|^# \([0-9]+\) ".*"$|}

let process fn =
  let ic = open_in fn in
  let rec loop () =
    match input_line ic with
    | s ->
        print_endline (Str.replace_first line_directive_re {|# \1 ""|} s);
        loop ()
    | exception End_of_file ->
        ()
  in
  loop ();
  close_in ic

let () =
  Arg.parse [] process ""
