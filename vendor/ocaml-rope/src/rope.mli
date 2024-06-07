(* File: rope.mli

   Copyright (C) 2007

     Christophe Troestler
     email: Christophe.Troestler@umh.ac.be
     WWW: http://math.umh.ac.be/an/software/

   This library is free software; you can redistribute it and/or modify
   it under the terms of the GNU Lesser General Public License version 2.1 or
   later as published by the Free Software Foundation, with the special
   exception on linking described in the file LICENSE.

   This library is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
   LICENSE for more details. *)


(** Ropes ("heavyweight strings") are a scalable string implementation.

    Ropes are designed for efficient operation that
    involve the string as a whole.  Operations such as concatenation,
    and substring take time that is nearly independent of the length
    of the string.  Unlike strings, ropes are a reasonable
    representation for very long strings such as edit buffers or mail
    messages.

    Features:
    - No length limitation (contrarily to strings);
    - Immutability (use {!Rope.Buffer} to incrementally build ropes);
    - Efficient concatenation ({!Rope.concat2}) and splice
      ({!Rope.sub});
    - Share memory whenever possible.

    Disadvantages:
    - [get] is not O(1) — but it is amortized O(1) if you use an
    iterator (see the {!Rope.Iterator} module).  {!Rope.get} is 2 to 3 times
    slower than for a string so it should not be your main operation.
    However, as soon as in addition you have a few concatenations
    (especially with sharing) or splice operations, ropes will usually
    outperform strings.

    You can say [module String = Rope] to use ropes instead of strings
    and, in particular, so that [r.[i]] gets the [i]th char of the
    rope [r].  This module has all non-deprecated operations of [String].
    It additionally features {!Rope.Buffer} and {!Rope.Iterator} modules.

    To use this library in the toploop (REPL), issue
    [#require "rope.top";;].

    @version %%VERSION%%
    @author Christophe Troestler
*)


type t (** Immutable rope. *)

type rope = t (** Alias for type {!Rope.t} *)

exception Out_of_bounds of string
  (** Raised by various functions to indicate out-of-bounds access.
      The string argument is the name of the function that raised it. *)

(** {2 Basics (creation, access,...)} *)

val empty : t
  (** The empty rope. *)

val of_string : string -> t
  (** [of_string s] creates a rope from the string [s].  *)

val of_substring : string -> int -> int -> t
  (** [of_substring s start len] create a rope from the substring
      [s.[start .. start+len-1]].
      @raise Invalid_argument if [start] and [len] do not designate a valid
      sbstring of [s]. *)

val of_char : char -> t
  (** [of_char c] returns a rope consisting of the unique character
      [c].  It may be useful to append a char to a given rope. *)

val make : int -> char -> t
(** [make len c] returns a rope of length [len] filled with [c]. *)

val init : int -> (int -> char) -> t
(** [init len f] returns a rope of length [len] with entry of index
   [i] filled with [f i]. *)

val to_string : t -> string
  (** [to_string r] return a string with the same content as the rope.
      @raise Failure if the rope is too long to fit into a string. *)

val is_empty : t -> bool
  (** [is_empty r] tells whether the rope [r] is empty. *)

val length : t -> int
  (** [length r] returns the length of the rope.  O(1) time. *)

val get : t -> int -> char
  (** [get r i] returns the [i]th char of the rope.
      Takes O(log(length r)). *)

val sub : t -> int -> int -> t
  (** [sub r i start len] returns the sub-rope consisting of
      characters from position [start] to [start+len-1] (included) of
      the rope [r].  O(log(length r)) time.

      @raise Invalid_argument if [i < 0], [len < 0] or [i + len >
      Rope.length r]. *)

val blit : t -> int -> Bytes.t -> int -> int -> unit
(** [blit src srcoff dst dstoff len] copies [len] bytes from the rope
   [src] starting at index [srcoff], to sequence [dst], starting at
   index [dstoff]. *)

val concat2 : t -> t -> t
  (** [concat2 r1 r2] concatenates the ropes [r1] and [r2].  *)

val concat : t -> t list -> t
  (** [concat sep rl] concatenates the list of ropes [rl], inserting
      the separator string [sep] between each. *)

val iter : (char -> unit) -> t -> unit
  (** [iter f r] execute [f c] for [c] going through every character
      of rope [r] from left to right. *)

val iteri : (int -> char -> unit) -> t -> unit
  (** [iter f r] execute [f i c] for [c] going through every
      character of rope [r] from left to right and [i] the index of
      [c]. *)

val map : f:(char -> char) -> t -> t
(** [map f r] applies function [f] in turn to all the characters of
   [r] (in increasing index order) and stores the results in a new
   string that is returned. *)

val mapi : f:(int -> char -> char) -> t -> t
(** Same as [map] but the function [f] is passed the index [i] of the
   char. *)

val trim : t -> t
(** Return a copy of the argument, without leading and trailing
   whitespace.  The characters regarded as whitespace are: [' '],
   ['\012'], ['\n'], ['\r'], and ['\t']. *)

val escaped : t -> t
  (** Return a copy of the argument, with special characters
      represented by escape sequences, following the lexical
      conventions of Objective Caml. *)

(** {2 Search char} *)

val index : t -> char -> int
  (** [index r c] returns the position of the leftmost occurrence of
      character [c] in rope [r].
      @raise Not_found if [c] does not occur in [r]. *)

val index_opt : t -> char -> int option
(** [index r c] returns [Some i] where [i] is the position of the
   leftmost occurrence of character [c] in rope [r] and [None] if [c]
   does not occur in [r]. *)

val rindex : t -> char -> int
  (** [rindex r c] returns the position of the rightmost occurrence
      of character [c] in rope [r].
      @raise Not_found if [c] does not occur in [r]. *)

val rindex_opt : t -> char -> int option
(** [rindex_opt r c] returns [Some i] where [i] is the position of the
   rightmost occurrence of character [c] in rope [r] or [None] if [c]
   does not occur in [r]. *)

val index_from : t -> int -> char -> int
  (** Same as {!Rope.index}, but start searching at the character
      position given as second argument.  [Rope.index r c] is
      equivalent to [Rope.index_from r 0 c]. *)

val index_from_opt : t -> int -> char -> int option
(** Same as {!Rope.index_opt}, but start searching at the character
   position given as second argument.  [Rope.index_opt r c] is
   equivalent to [Rope.index_from_opt r 0 c]. *)


val rindex_from : t -> int -> char -> int
  (** Same as {!Rope.rindex}, but start searching at the character
      position given as second argument.  [Rope.rindex r c] is
      equivalent to [Rope.rindex_from s (Rope.length r - 1) c]. *)

val rindex_from_opt : t -> int -> char -> int option
(** Same as {!Rope.rindex_opt}, but start searching at the character
   position given as second argument.  [Rope.rindex_opt r c] is
   equivalent to [Rope.rindex_from_opt s (Rope.length r - 1) c]. *)

val contains : t -> char -> bool
  (** [contains r c] tests if character [c] appears in the rope [r]. *)

val contains_from : t -> int -> char -> bool
  (** [contains_from r start c] tests if character [c] appears in
      the subrope of [r] starting from [start] to the end of [s].
      @raise Invalid_argument if [start] is not a valid index of [r]. *)

val rcontains_from : t -> int -> char -> bool
  (** [rcontains_from r stop c] tests if character [c] appears in
      the subrope of [r] starting from the beginning of [r] to index
      [stop].
      @raise Invalid_argument if [stop] is not a valid index of [r]. *)


(** {2 Search substring} *)

val search_forward_string : string -> t -> int -> int
  (** [search_forward_string p] is a search function that, given a
      rope [r] and a start index [i0], will return the position of
      [p] in [r] or raise [Not_found] if no occurrence of [p] in [r]
      exists.  [let search = search_forward_string p] takes
      O(length p) and [search r i0] takes O(length r - i0). *)


(** {2 ASCII letter case} *)

val uppercase_ascii : t -> t
(** Return the argument with all lowercase letters translated to
   uppercase, including accented letters of the ISO Latin-1 (8859-1)
   character set. *)

val lowercase_ascii : t -> t
(** Return the argument with all uppercase letters translated to
   lowercase, including accented letters of the ISO Latin-1 (8859-1)
   character set. *)

val capitalize_ascii : t -> t
(** Return the argument, with the first character set to uppercase. *)

val uncapitalize_ascii : t -> t
(** Return the argument with the first character set to lowercase. *)

val uppercase : t -> t    [@@ocaml.deprecated "Use Rope.uppercase_ascii"]
(** @deprecated Use {!Rope.uppercase_ascii}. *)

val lowercase : t -> t    [@@ocaml.deprecated "Use Rope.lowercase_ascii"]
(** @deprecated Use {!Rope.lowercase_ascii}. *)

val capitalize : t -> t   [@@ocaml.deprecated "Use Rope.capitalize_ascii"]
(** @deprecated Use {!Rope.capitalize_ascii}. *)

val uncapitalize : t -> t [@@ocaml.deprecated "Use Rope.uncapitalize_ascii"]
(** @deprecated Use {!Rope.uncapitalize_ascii}. *)


(** {2 Ordering} *)

val compare: t -> t -> int
  (** The comparison function for ropes, with the same specification
      as [Pervasives.compare].  Along with the type [t], this function
      [compare] allows the module {!Rope} to be passed as argument to
      the functors [Set.Make] and [Map.Make]. *)

val equal : t -> t -> bool
  (** [equal r1 r2] tells whether the two ropes [r1] and [r2] are
      equal.  (It is equivalent to [compare r1 r2 = 0], just slightly
      faster.) *)


(** {2 Input/output}

    Input and output functions for ropes modelled on the standard
    library [Pervasives]. *)

val input_line : ?leaf_length:int -> in_channel -> t
  (** Read characters from the given input channel, until a newline
      character is encountered.  Return the rope of all characters read,
      without the newline character at the end.
      @raise End_of_file if the end of the file is reached at the
      beginning of line. *)

val read_line : unit -> t
  (** Flush standard output, then read characters from standard input
      until a newline character is encountered.  Return the rope of
      all characters read, without the newline character at the end. *)

val print_string : t -> unit
  (** Print a rope on standard output. *)

val print_endline : t -> unit
  (** Print a rope, followed by a newline character, on standard
      output and flush standard output. *)

val prerr_string : t -> unit
  (** Print a rope on standard error. *)

val prerr_endline : t -> unit
  (** Print a rope, followed by a newline character on standard error
      and flush standard error. *)

val output_rope : out_channel -> t -> unit
(** [output_rope oc r] outputs the rope [r] to the output channel [oc].
    May also be used with a [%a] directive of printf. *)

val output_string : out_channel -> t -> unit
(** Alias for {!Rope.output_rope} to be a drop in replacement for strings. *)



(** {2 Balancing} *)

val balance : t -> t
  (** [balance r] return a balanced copy of the rope [r].  Implicit
      rebalancing is done by some of the above functions to avoid
      gross inefficiencies but you may want to call this function
      explicitely to try to improve your running times.  *)

val height : t -> int
  (** [depth r] returns the depth of the rope [r].  This information
      may be useful to decide whether you want to re-balance. *)

val rebalancing_height : int
  (** The rope will be rebalanced by some functions it its height is
      greater or equal to [rebalancing_height]. *)


(** {2 Iterator} *)

(** Iterators for ropes.  It is more efficient to use an iterator to
    perform small steps and get the characters than to use {!Rope.get}
    repeatedly. *)
module Iterator : sig

  type t
    (** Mutable iterator on a rope.  Iterators are less efficient than
        {!Rope.get} on small ropes (of length [<= 1024] chars). *)

  val make : rope -> int -> t
    (** [make r i0] returns a new iterator for the rope [r].  It is
        initially at position [i0]. *)

  val get : t -> char
    (** [get itr] returns the character of the rope at the current
        position.  O(1) time.  This does not change the current position.
        @raise Out_of_bounds if the position is outside the rope. *)

  val peek : t -> int -> char
    (** [peek itr i] returns the character [i] of the rope.  If [i] is
        close to the current position of the iterator, this will in
        general be more efficient than [get rope i].  *)

  val pos : t -> int
    (** [pos itr] returns the current position.  It may not be a valid
        position of the rope.  O(1) time. *)

  val incr : t -> unit
    (** [incr itr] moves to the next character.  O(1) time. *)

  val decr : t -> unit
    (** [decr itr] moves to the previous character.  O(1) time.  *)

  val goto : t -> int -> unit
    (** [goto itr i] move to position [i].  O(1) time but the next
        call to [get] may be slower. *)

  val move : t -> int -> unit
    (** [mode itr i] move the current position by [i] chars ([i] may
        be negative or null).  O(1) time but the next call to [get]
        may be slower. *)

  val rope : t -> rope
    (** [rope itr] returns the rope from which the iterator was
        constructed. *)
end


(** {2 Buffer} *)

(** This is similar to the [Buffer] module in the standard library
    except that it constructs ropes.  It is recommended to use this
    module instead of repeatedly concatenating chars. *)
module Buffer : sig

  type t
    (** Mutable buffer to construct ropes. *)

  val create : int -> t
    (** [create n] returns a fresh buffer, initially empty.  The [n]
        parameter is the initial size of the internal rope that holds
        the buffer contents.  The buffer will grow dynamically to
        accomodate new inputs. *)

  val clear : t -> unit
    (** Empty the buffer. *)

  val reset : t -> unit
    (** Empty the buffer. *)

  val length : t -> int
    (** Return the number of characters currently contained in the buffer. *)

  val add_char : t -> char -> unit
    (** [add_char b c] appends the character [c] at the end of the
        buffer [b].
        @raise Failure if the length if the buffer exceeds [max_int]. *)

  val add_string : t -> string -> unit
    (** [add_string b s] appends the string [s] at the end of the
        buffer [b].
        @raise Failure if the length if the buffer exceeds [max_int]. *)

  val add_substring : t -> string -> int -> int -> unit
    (** [add_substring b s ofs len] takes [len] characters from offset
        [ofs] in string [s] and appends them at the end of the buffer
        [b].
        @raise Invalid_argument if [ofs] and [len] do not designate a
        valid substring of [s].
        @raise Failure if the length if the buffer exceeds [max_int]. *)

  val add_rope : t -> rope -> unit
    (** [add_rope b r] add the rope [r] to the buffer [b]. *)

  val add_channel : t -> in_channel -> int -> unit
    (** [add_channel b ic n] reads exactly [n] characters from the input
        channel [ic] and stores them at the end of buffer [b].
        @raise End_of_file if the channel contains fewer than [n]
        characters. *)

  val add_buffer : t -> t -> unit
    (** [add_buffer b1 b2] appends the current contents of buffer [b2]
        at the end of buffer [b1].  [b2] is not modified. *)

  val contents : t -> rope
    (** Return a copy of the current contents of the buffer.
        The buffer itself is unchanged. *)

  val sub : t -> int -> int -> rope
    (** [sub b off len] returns a rope of the current contents of the
        buffer [b] starting at offset [off] of length [len] bytes.
        The buffer itself is unaffected.
        @raise Invalid_argument if out of bounds request.  *)

  val nth : t -> int -> char
    (** [nth b i] returns the [i]th character if the buffer.
        @raise Out_of_bounds if [i < 0] or [i >= length b].
        Time: O(log(length b)). *)
end

(* TBD: Regular expressions for ropes. *)
(* module Regexp : sig *)


(* end *)


(** {2 REPL} *)

(** Toploop printer and its configuration. *)
module Rope_toploop : sig

  val printer : Format.formatter -> rope -> unit
    (** Toploop printer for rope values.  The value will be printed
        alike a standard string except that one will display at most
        [!max_display_length] characters from the rope in order to
        allow convenient interactive manipulations of long ropes.  In
        case the rope display is truncated, [!ellipsis] is appended
        after the closing quote. *)

  val max_display_length : int ref
    (** Maximum number of characters displayed. Default: [400]. *)

  val ellipsis : string ref
    (** String used a ellipsis for truncated ropes.  Default: ["..."]. *)
end


(**/**)

(** {2 For system use} *)

val number_leaves : t -> int
val number_concat : t -> int
val print : t -> unit
val length_leaves : t -> int * int

module IMap : Map.S with type key = int
val distrib_leaves : t -> int ref IMap.t
(**/**)
