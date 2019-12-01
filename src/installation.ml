(******************************************************************************)
(*                                                                            *)
(*                                   Menhir                                   *)
(*                                                                            *)
(*                       François Pottier, Inria Paris                        *)
(*              Yann Régis-Gianas, PPS, Université Paris Diderot              *)
(*                                                                            *)
(*  Copyright Inria. All rights reserved. This file is distributed under the  *)
(*  terms of the GNU General Public License version 2, as described in the    *)
(*  file LICENSE.                                                             *)
(*                                                                            *)
(******************************************************************************)


let rec normalize fn =
  let dir = Filename.dirname fn in
  let base = Filename.basename fn in
  if dir = fn then dir
  else if base = Filename.current_dir_name then
    normalize dir
  else if base = Filename.parent_dir_name then
    Filename.dirname (normalize dir)
  else
    Filename.concat (normalize dir) base

let libdir =
  Filename.concat
    (Filename.dirname (Filename.dirname (normalize Sys.executable_name)))
    (Filename.concat "lib" (Filename.concat "menhir" "lib"))
