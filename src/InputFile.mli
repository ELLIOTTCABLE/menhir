(* This module keeps track of which input file is currently being read. It
   defines a type [input_file] of input files, which is used to record the
   origin of certain elements (productions, declarations, etc.). *)

(* ---------------------------------------------------------------------------- *)

(* The identity of the current input file. *)

type input_file

(* [new_input_file filename] must be called when a new input file is about
   to be read. *)

val new_input_file: string -> unit

(* [get_input_file()] indicates which input file is currently being read.
   [get_input_file_name()] is the name of this file. *)

val get_input_file: unit -> input_file
val get_input_file_name: unit -> string

(* This fictitious "built-in" input file is used as the origin of the start
   productions. This technical detail is probably irrelevant entirely. *)

val builtin_input_file: input_file

(* This equality test for input files is used (for instance) when determining
   which of two productions has greater priority. *)

val same_input_file: input_file -> input_file -> bool

(* This ordering between input files reflects their ordering on the command
   line. Ideally, it should NOT be used. *)

val compare_input_files: input_file -> input_file -> int

(* ---------------------------------------------------------------------------- *)

(* The contents of the current input file. *)

(* [with_file_contents contents f] records that the contents of the current
   input file is [contents] while the action [f] runs. The function [f] can
   then call [get_file_contents()] to retrieve [contents]. *)

val with_file_contents: string -> (unit -> 'a) -> 'a
val get_file_contents: unit -> string