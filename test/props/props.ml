type attr_value = B of bool | AI of int | AF of float | AS of string

type d =
  | Null
  | S of string
  | I of int
  | F of float
  | U of string
  | N of string * (string * attr_value) list * d list
  | L of d list
  | A of d list
  | W of int * string
  | Frag of d
  | Fmt of string

let to_attr (name, v) =
  ( name,
    match v with
    | B b ->
        `Bool b
    | AI i ->
        `Int i
    | AF f ->
        `Float f
    | AS s ->
        `String s
  )

let rec to_jsx = function
  | Null ->
      JSX.null
  | S s ->
      JSX.string s
  | I i ->
      JSX.int i
  | F f ->
      JSX.float f
  | U s ->
      JSX.unsafe s
  | N (tag, attrs, children) ->
      JSX.node tag (List.map to_attr attrs) (List.map to_jsx children)
  | L l ->
      JSX.list (List.map to_jsx l)
  | A l ->
      JSX.array (Array.of_list (List.map to_jsx l))
  | W (size, s) ->
      JSX.writer size (fun b -> Buffer.add_string b s)
  | Frag d ->
      JSX.fragment ~children:(to_jsx d) ()
  | Fmt s ->
      JSX.format "%s" s

let inline_tags =
  [
    "a";
    "abbr";
    "b";
    "bdi";
    "bdo";
    "br";
    "button";
    "cite";
    "code";
    "data";
    "del";
    "dfn";
    "em";
    "embed";
    "i";
    "img";
    "input";
    "ins";
    "kbd";
    "label";
    "mark";
    "meter";
    "output";
    "progress";
    "q";
    "s";
    "samp";
    "select";
    "small";
    "span";
    "strong";
    "sub";
    "sup";
    "textarea";
    "time";
    "u";
    "var";
    "wbr";
  ]

let verbatim_tags = [ "pre"; "textarea"; "script"; "style" ]

let void_tags =
  [
    "area";
    "base";
    "br";
    "col";
    "embed";
    "hr";
    "img";
    "input";
    "link";
    "meta";
    "param";
    "source";
    "track";
    "wbr";
    "menuitem";
  ]

let ref_escape s =
  let b = Buffer.create (String.length s) in
  String.iter
    (function
      | '&' ->
          Buffer.add_string b "&amp;"
      | '<' ->
          Buffer.add_string b "&lt;"
      | '>' ->
          Buffer.add_string b "&gt;"
      | '"' ->
          Buffer.add_string b "&quot;"
      | '\'' ->
          Buffer.add_string b "&apos;"
      | c ->
          Buffer.add_char b c
      )
    s;
  Buffer.contents b

let ref_unescape s =
  let n = String.length s in
  let b = Buffer.create n in
  let entities =
    [
      ("&amp;", '&');
      ("&lt;", '<');
      ("&gt;", '>');
      ("&quot;", '"');
      ("&apos;", '\'');
    ]
  in
  let i = ref 0 in
  while !i < n do
    let hit =
      List.find_opt
        (fun (e, _) ->
          let l = String.length e in
          !i + l <= n && String.sub s !i l = e
        )
        entities
    in
    match hit with
    | Some (e, c) ->
        Buffer.add_char b c;
        i := !i + String.length e
    | None ->
        Buffer.add_char b s.[!i];
        incr i
  done;
  Buffer.contents b

let ref_valid_attribute_name name =
  name <> ""
  && not
       (String.exists
          (fun c ->
            Char.code c <= 0x20
            || Char.code c = 0x7f
            || c = '"' || c = '\'' || c = '>' || c = '/' || c = '='
          )
          name
       )

let ref_attr (name, v) =
  if not (ref_valid_attribute_name name) then
    invalid_arg ("invalid attribute name " ^ String.escaped name);
  match v with
  | B false ->
      ""
  | B true ->
      " " ^ name
  | AI i ->
      Printf.sprintf " %s=\"%d\"" name i
  | AF f ->
      Printf.sprintf " %s=\"%s\"" name (Float.to_string f)
  | AS s ->
      Printf.sprintf " %s=\"%s\"" name (ref_escape s)

let rec ref_render = function
  | Null ->
      ""
  | S s | Fmt s ->
      ref_escape s
  | I i ->
      string_of_int i
  | F f ->
      Float.to_string f
  | U s ->
      s
  | W (_, s) ->
      s
  | Frag d ->
      ref_render d
  | L l | A l ->
      String.concat "" (List.map ref_render l)
  | N (tag, attrs, children) ->
      let attrs = String.concat "" (List.map ref_attr attrs) in
      if List.mem tag void_tags then
        Printf.sprintf "<%s%s />" tag attrs
      else
        Printf.sprintf "%s<%s%s>%s</%s>"
          ( if tag = "html" then
              "<!DOCTYPE html>"
            else
              ""
          )
          tag attrs
          (String.concat "" (List.map ref_render children))
          tag

let rec html_count = function
  | N (tag, _, children) ->
      if List.mem tag void_tags then
        0
      else
        ( if tag = "html" then
            1
          else
            0
        )
        + List.fold_left (fun a c -> a + html_count c) 0 children
  | L l | A l ->
      List.fold_left (fun a c -> a + html_count c) 0 l
  | Frag d ->
      html_count d
  | _ ->
      0

let rec has_unsafe = function
  | U _ | W _ ->
      true
  | N (_, _, c) | L c | A c ->
      List.exists has_unsafe c
  | Frag d ->
      has_unsafe d
  | _ ->
      false

let rec to_ocaml = function
  | Null ->
      "JSX.null"
  | S s ->
      Printf.sprintf "(JSX.string %S)" s
  | Fmt s ->
      Printf.sprintf "(JSX.format \"%%s\" %S)" s
  | I i ->
      Printf.sprintf "(JSX.int (%d))" i
  | F f ->
      Printf.sprintf "(JSX.float (%h))" f
  | U s ->
      Printf.sprintf "(JSX.unsafe %S)" s
  | W (n, s) ->
      Printf.sprintf "(JSX.writer %d (fun b -> Buffer.add_string b %S))" n s
  | Frag d ->
      Printf.sprintf "(JSX.fragment ~children:%s ())" (to_ocaml d)
  | L l ->
      Printf.sprintf "(JSX.list [%s])" (String.concat "; " (List.map to_ocaml l))
  | A l ->
      Printf.sprintf "(JSX.array [|%s|])"
        (String.concat "; " (List.map to_ocaml l))
  | N (tag, attrs, children) ->
      let attr (n, v) =
        Printf.sprintf "(%S, %s)" n
          ( match v with
          | B b ->
              Printf.sprintf "`Bool %b" b
          | AI i ->
              Printf.sprintf "`Int (%d)" i
          | AF f ->
              Printf.sprintf "`Float (%h)" f
          | AS s ->
              Printf.sprintf "`String %S" s
          )
      in
      Printf.sprintf "(JSX.node %S [%s] [%s])" tag
        (String.concat "; " (List.map attr attrs))
        (String.concat "; " (List.map to_ocaml children))

let shrink_string s =
  let n = String.length s in
  if n = 0 then
    []
  else
    [
      "";
      String.sub s 0 (n / 2);
      String.sub s (n / 2) (n - (n / 2));
      String.sub s 0 (n - 1);
      String.sub s 1 (n - 1);
    ]

let rec remove_each = function
  | [] ->
      []
  | x :: xs ->
      xs :: List.map (fun r -> x :: r) (remove_each xs)

let rec shrink_each f = function
  | [] ->
      []
  | x :: xs ->
      List.map (fun x' -> x' :: xs) (f x)
      @ List.map (fun r -> x :: r) (shrink_each f xs)

let rec shrink = function
  | Null ->
      []
  | S s ->
      Null :: List.map (fun s -> S s) (shrink_string s)
  | Fmt s ->
      Null :: List.map (fun s -> Fmt s) (shrink_string s)
  | U s ->
      Null :: List.map (fun s -> U s) (shrink_string s)
  | W (n, s) ->
      Null :: List.map (fun s -> W (n, s)) (shrink_string s)
  | I _ | F _ ->
      [ Null ]
  | Frag d ->
      d :: List.map (fun d -> Frag d) (shrink d)
  | L l ->
      (Null :: l)
      @ List.map (fun l -> L l) (remove_each l)
      @ List.map (fun l -> L l) (shrink_each shrink l)
  | A l ->
      (Null :: l)
      @ List.map (fun l -> A l) (remove_each l)
      @ List.map (fun l -> A l) (shrink_each shrink l)
  | N (tag, attrs, children) ->
      (Null :: children)
      @ List.map (fun a -> N (tag, a, children)) (remove_each attrs)
      @ List.map (fun c -> N (tag, attrs, c)) (remove_each children)
      @ List.map (fun c -> N (tag, attrs, c)) (shrink_each shrink children)
      @ List.map
          (fun a -> N (tag, a, children))
          (shrink_each
             (fun (n, v) ->
               match v with
               | AS s ->
                   List.map (fun s -> (n, AS s)) (shrink_string s)
               | _ ->
                   []
             )
             attrs
          )

let pick st l = List.nth l (Random.State.int st (List.length l))

let gen_string st =
  let atoms =
    [
      "a";
      "b";
      " ";
      "\n";
      "\t";
      "<";
      ">";
      "&";
      "\"";
      "'";
      "&amp;";
      "&lt;";
      "</div>";
      "<script>";
      "\xc3\xa9";
      "\xe2\x82\xac";
      "\x00";
      "\r";
      "x y";
      "&#39;";
      "]]>";
    ]
  in
  let n = Random.State.int st 6 in
  String.concat "" (List.init n (fun _ -> pick st atoms))

let gen_tag st =
  pick st
    ([
       "div";
       "span";
       "p";
       "html";
       "body";
       "pre";
       "svg";
       "path";
       "HTML";
       "BR";
       "a";
       "ul";
       "li";
       "textarea";
       "script";
       "style";
       "b";
       "em";
       "code";
       "label";
     ]
    @ void_tags
    )

let bad_attribute_names =
  [
    "";
    " ";
    "a b";
    "a\"b";
    "a'b";
    "a>b";
    "a/b";
    "a=b";
    "a\tb";
    "a\nb";
    "a\000b";
    "a\127b";
    "x\" onload=\"y";
  ]

let gen_attr_name ~bad_names st =
  if bad_names && Random.State.int st 6 = 0 then
    pick st bad_attribute_names
  else
    pick st
      [ "id"; "class"; "disabled"; "data-x"; "aria-label"; "@click"; "x:y" ]

let gen_int st =
  match Random.State.int st 6 with
  | 0 ->
      min_int
  | 1 ->
      max_int
  | 2 ->
      0
  | 3 ->
      Random.State.int st 20 - 10
  | _ ->
      Random.State.bits st - Random.State.bits st

let gen_float st =
  match Random.State.int st 10 with
  | 0 ->
      nan
  | 1 ->
      infinity
  | 2 ->
      neg_infinity
  | 3 ->
      -0.
  | 4 ->
      0.1 +. 0.2
  | 5 ->
      Float.of_int (Random.State.int st 100)
  | 6 ->
      Random.State.float st 1e-5
  | 7 ->
      Random.State.float st 1e15
  | _ ->
      Random.State.float st 1000. -. 500.

let gen_attr ~bad_names st =
  ( gen_attr_name ~bad_names st,
    match Random.State.int st 5 with
    | 0 ->
        B (Random.State.bool st)
    | 1 ->
        AI (gen_int st)
    | 2 ->
        AF (gen_float st)
    | _ ->
        AS (gen_string st)
  )

let rec gen ~unsafe ~bad_names st depth =
  let leaf () =
    match
      Random.State.int st
        ( if unsafe then
            7
          else
            5
        )
    with
    | 0 ->
        Null
    | 1 ->
        S (gen_string st)
    | 2 ->
        I (gen_int st)
    | 3 ->
        F (gen_float st)
    | 4 ->
        Fmt (gen_string st)
    | 5 ->
        U (gen_string st)
    | _ ->
        W (Random.State.int st 40 - 5, gen_string st)
  in
  if depth = 0 then
    leaf ()
  else
    let children () =
      List.init (Random.State.int st 4) (fun _ ->
          gen ~unsafe ~bad_names st (depth - 1)
      )
    in
    match Random.State.int st 8 with
    | 0 | 1 ->
        leaf ()
    | 2 ->
        L (children ())
    | 3 ->
        A (children ())
    | 4 ->
        Frag (gen ~unsafe ~bad_names st (depth - 1))
    | _ ->
        N
          ( gen_tag st,
            List.init (Random.State.int st 3) (fun _ -> gen_attr ~bad_names st),
            children ()
          )

let render_streaming_chunks ~chunk_size el =
  let chunks = ref [] in
  JSX.render_streaming ~chunk_size (fun c -> chunks := c :: !chunks) el;
  List.rev !chunks

let strip_ws s =
  let b = Buffer.create (String.length s) in
  String.iter (function ' ' | '\n' -> () | c -> Buffer.add_char b c) s;
  Buffer.contents b

let count_sub s sub =
  let n = String.length s and m = String.length sub in
  let c = ref 0 in
  for i = 0 to n - m do
    if String.sub s i m = sub then incr c
  done;
  !c

let tmp_render el =
  let path = Filename.temp_file "props" ".html" in
  let oc = open_out_bin path in
  JSX.render_to_channel oc el;
  close_out oc;
  let ic = open_in_bin path in
  let s = really_input_string ic (in_channel_length ic) in
  close_in ic;
  Sys.remove path;
  s

type prop = {
  name : string;
  unsafe : bool;
  bad_names : bool;
  check : d -> string option;
}

let eq label a b =
  if a = b then
    None
  else
    Some (Printf.sprintf "%s\n  actual:   %S\n  expected: %S" label a b)

let outcome f =
  match f () with
  | s ->
      s
  | exception Invalid_argument _ ->
      "<Invalid_argument>"

let raises_invalid_argument f =
  match f () with
  | _ ->
      false
  | exception Invalid_argument _ ->
      true
  | exception _ ->
      false

let render_paths ?(chunk_size = 7) el =
  [
    ("render", fun () -> ignore (JSX.render el));
    ("write", fun () -> JSX.write (Buffer.create 16) el);
    ("render_to_channel", fun () -> ignore (tmp_render el));
    ( "render_streaming",
      fun () -> JSX.render_streaming ~chunk_size (fun _ -> ()) el
    );
    ("pp", fun () -> ignore (JSX.pp el));
  ]

let rec has_bad_attribute_name = function
  | N (tag, attrs, children) ->
      List.exists (fun (n, _) -> not (ref_valid_attribute_name n)) attrs
      || (not (List.mem tag void_tags))
         && List.exists has_bad_attribute_name children
  | L l | A l ->
      List.exists has_bad_attribute_name l
  | Frag d ->
      has_bad_attribute_name d
  | _ ->
      false

let rec leaves = function
  | (S _ | Fmt _ | I _ | F _ | U _) as leaf ->
      [ leaf ]
  | N (_, _, c) | L c | A c ->
      List.concat_map leaves c
  | Frag d ->
      leaves d
  | Null | W _ ->
      []

let rec nodes = function
  | N (tag, _, c) as n ->
      (tag, n)
      ::
      ( if List.mem tag void_tags then
          []
        else
          List.concat_map nodes c
      )
  | L c | A c ->
      List.concat_map nodes c
  | Frag d ->
      nodes d
  | _ ->
      []

let contains s sub = count_sub s sub > 0

let first_some l = List.find_map (fun f -> f ()) l

let chunk_sizes = [ 1; 2; 7; 4096 ]

let props =
  [
    {
      name = "render agrees with reference renderer";
      unsafe = true;
      bad_names = true;
      check =
        (fun d ->
          eq "render"
            (outcome (fun () -> JSX.render (to_jsx d)))
            (outcome (fun () -> ref_render d))
        );
    };
    {
      name = "render_streaming chunks concatenate to render";
      unsafe = true;
      bad_names = false;
      check =
        (fun d ->
          let el = to_jsx d in
          let expected = JSX.render el in
          first_some
            (List.map
               (fun chunk_size () ->
                 eq
                   (Printf.sprintf "streaming chunk_size=%d" chunk_size)
                   (String.concat "" (render_streaming_chunks ~chunk_size el))
                   expected
               )
               chunk_sizes
            )
        );
    };
    {
      name = "render_streaming chunks are non-empty and at least chunk_size";
      unsafe = true;
      bad_names = false;
      check =
        (fun d ->
          let el = to_jsx d in
          first_some
            (List.map
               (fun chunk_size () ->
                 let chunks = render_streaming_chunks ~chunk_size el in
                 let rec bad = function
                   | [] ->
                       None
                   | [ last ] ->
                       if last = "" then
                         Some "empty last chunk"
                       else
                         None
                   | c :: rest ->
                       if String.length c < chunk_size || c = "" then
                         Some (Printf.sprintf "short chunk %S" c)
                       else
                         bad rest
                 in
                 Option.map
                   (fun m -> Printf.sprintf "chunk_size=%d: %s" chunk_size m)
                   (bad chunks)
               )
               [ 1; 2; 7; 4096 ]
            )
        );
    };
    {
      name = "rendering twice gives the same result";
      unsafe = true;
      bad_names = false;
      check =
        (fun d ->
          let el = to_jsx d in
          let a = JSX.render el in
          first_some
            [
              (fun () -> eq "render again" (JSX.render el) a);
              (fun () ->
                eq "streaming again"
                  (String.concat "" (render_streaming_chunks ~chunk_size:3 el))
                  a
              );
              (fun () -> eq "pp again" (JSX.pp el) (JSX.pp el));
            ]
        );
    };
    {
      name = "write appends to a non-empty buffer; render_to_channel agrees";
      unsafe = true;
      bad_names = false;
      check =
        (fun d ->
          let el = to_jsx d in
          let b = Buffer.create 4 in
          Buffer.add_string b "PRE";
          JSX.write b el;
          first_some
            [
              (fun () -> eq "write" (Buffer.contents b) ("PRE" ^ JSX.render el));
              (fun () -> eq "channel" (tmp_render el) (JSX.render el));
            ]
        );
    };
    {
      name = "escaped output has no raw special characters";
      unsafe = false;
      bad_names = false;
      check =
        (fun d ->
          let rec texts = function
            | S s | Fmt s ->
                [ s ]
            | N (_, attrs, c) ->
                List.filter_map (function _, AS s -> Some s | _ -> None) attrs
                @ List.concat_map texts c
            | L c | A c ->
                List.concat_map texts c
            | Frag d ->
                texts d
            | _ ->
                []
          in
          first_some
            (List.map
               (fun s () ->
                 let b = Buffer.create 16 in
                 JSX.escape b s;
                 let out = Buffer.contents b in
                 first_some
                   [
                     (fun () -> eq "escape" out (ref_escape s));
                     (fun () ->
                       eq "unescape (escape s)" (ref_unescape out) s
                       |> Option.map (fun m -> m)
                     );
                     (fun () ->
                       if
                         String.exists
                           (function
                             | '<' | '>' | '"' | '\'' -> true | _ -> false
                             )
                           out
                       then
                         Some ("raw special in " ^ out)
                       else
                         None
                     );
                   ]
               )
               (texts d)
            )
        );
    };
    {
      name = "unsafe passes through unchanged";
      unsafe = true;
      bad_names = false;
      check =
        (fun d ->
          match d with
          | U s ->
              first_some
                [
                  (fun () -> eq "bare" (JSX.render (JSX.unsafe s)) s);
                  (fun () ->
                    eq "in div"
                      (JSX.render (JSX.node "div" [] [ JSX.unsafe s ]))
                      ("<div>" ^ s ^ "</div>")
                  );
                ]
          | _ ->
              None
        );
    };
    {
      name = "int and float leaves render like the stdlib";
      unsafe = true;
      bad_names = false;
      check =
        (fun d ->
          match d with
          | I i ->
              eq "int" (JSX.render (JSX.int i)) (string_of_int i)
          | F f ->
              eq "float" (JSX.render (JSX.float f)) (Float.to_string f)
          | _ ->
              None
        );
    };
    {
      name = "doctype once per html, void tags unclosed, tags balance";
      unsafe = false;
      bad_names = false;
      check =
        (fun d ->
          let out = JSX.render (to_jsx d) in
          let doctype = count_sub out "<!DOCTYPE html>" in
          let doctype_html = count_sub out "<!DOCTYPE html><html" in
          let html_opens = count_sub out "<html" in
          let expected = html_count d in
          if doctype <> expected then
            Some
              (Printf.sprintf "doctype count %d, expected %d in %S" doctype
                 expected out
              )
          else if doctype_html <> doctype then
            Some (Printf.sprintf "doctype not before html in %S" out)
          else if html_opens <> expected then
            Some (Printf.sprintf "html open count %d in %S" html_opens out)
          else
            let stack = ref [] in
            let n = String.length out in
            let i = ref 0 in
            let err = ref None in
            while !err = None && !i < n do
              if out.[!i] = '<' then (
                let j = String.index_from out !i '>' in
                let inner = String.sub out (!i + 1) (j - !i - 1) in
                ( if inner = "!DOCTYPE html" then
                    ()
                  else if inner.[0] = '/' then
                    let tag = String.sub inner 1 (String.length inner - 1) in
                    match !stack with
                    | t :: rest when t = tag ->
                        stack := rest
                    | _ ->
                        err := Some ("unbalanced close " ^ tag)
                  else
                    let tag =
                      match String.index_opt inner ' ' with
                      | Some k ->
                          String.sub inner 0 k
                      | None ->
                          inner
                    in
                    if inner.[String.length inner - 1] = '/' then (
                      if not (List.mem tag void_tags) then
                        err := Some ("self-closing non-void " ^ tag)
                    ) else if List.mem tag void_tags then
                      err := Some ("void with close form " ^ tag)
                    else
                      stack := tag :: !stack
                );
                i := j + 1
              ) else
                incr i
            done;
            match !err with
            | Some e ->
                Some (e ^ " in " ^ out)
            | None ->
                if !stack <> [] then
                  Some ("unclosed tags in " ^ out)
                else
                  None
        );
    };
    {
      name = "pp equals render modulo space and newline";
      unsafe = true;
      bad_names = false;
      check =
        (fun d ->
          let el = to_jsx d in
          let expected = strip_ws (JSX.render el) in
          first_some
            (List.map
               (fun width () ->
                 match JSX.pp ~width el with
                 | out ->
                     eq
                       (Printf.sprintf "pp width=%d" width)
                       (strip_ws out) expected
                 | exception e ->
                     Some
                       (Printf.sprintf "pp width=%d raised %s" width
                          (Printexc.to_string e)
                       )
               )
               [ 0; 1; 10; 80; 1000 ]
            )
        );
    };
    {
      name = "invalid attribute names raise in every render path";
      unsafe = true;
      bad_names = true;
      check =
        (fun d ->
          let el = to_jsx d in
          let expect_raise = has_bad_attribute_name d in
          first_some
            (List.map
               (fun (path, run) () ->
                 match (expect_raise, raises_invalid_argument run) with
                 | true, true | false, _ ->
                     None
                 | true, false ->
                     Some (path ^ " did not raise Invalid_argument")
               )
               (render_paths el)
            )
        );
    };
    {
      name = "valid attribute names never raise";
      unsafe = true;
      bad_names = true;
      check =
        (fun d ->
          if has_bad_attribute_name d then
            None
          else
            let el = to_jsx d in
            first_some
              (List.map
                 (fun (path, run) () ->
                   match run () with
                   | () ->
                       None
                   | exception e ->
                       Some (path ^ " raised " ^ Printexc.to_string e)
                 )
                 (render_paths el)
              )
        );
    };
    {
      name = "render_streaming rejects chunk_size <= 0 before writing";
      unsafe = true;
      bad_names = false;
      check =
        (fun d ->
          let el = to_jsx d in
          first_some
            (List.map
               (fun chunk_size () ->
                 let calls = ref 0 in
                 let raised =
                   raises_invalid_argument (fun () ->
                       JSX.render_streaming ~chunk_size (fun _ -> incr calls) el
                   )
                 in
                 if not raised then
                   Some (Printf.sprintf "chunk_size=%d did not raise" chunk_size)
                 else if !calls > 0 then
                   Some
                     (Printf.sprintf "chunk_size=%d wrote %d chunks" chunk_size
                        !calls
                     )
                 else
                   None
               )
               [ 0; -1; min_int ]
            )
        );
    };
    {
      name = "render_streaming chunks stay bounded for int and float leaves";
      unsafe = true;
      bad_names = false;
      check =
        (fun d ->
          let numbers =
            List.filter (function I _ | F _ -> true | _ -> false) (leaves d)
          in
          if numbers = [] then
            None
          else
            let el = to_jsx (L numbers) in
            first_some
              (List.map
                 (fun chunk_size () ->
                   let chunks = render_streaming_chunks ~chunk_size el in
                   let rec bad = function
                     | [] | [ _ ] ->
                         None
                     | c :: rest ->
                         let n = String.length c in
                         if n < chunk_size || n >= chunk_size + 32 then
                           Some (Printf.sprintf "chunk of %d bytes" n)
                         else
                           bad rest
                   in
                   let total = String.length (JSX.render el) in
                   let at_least = total / (chunk_size + 31) in
                   if List.length chunks < at_least then
                     Some
                       (Printf.sprintf "chunk_size=%d: %d chunks for %d bytes"
                          chunk_size (List.length chunks) total
                       )
                   else
                     Option.map
                       (fun m -> Printf.sprintf "chunk_size=%d: %s" chunk_size m)
                       (bad chunks)
                 )
                 [ 1; 4; 7 ]
              )
        );
    };
    {
      name = "pp prints verbatim and inline elements exactly as render";
      unsafe = true;
      bad_names = false;
      check =
        (fun d ->
          let el = to_jsx d in
          let exact =
            List.filter
              (fun (tag, _) ->
                List.mem tag verbatim_tags || List.mem tag inline_tags
              )
              (nodes d)
          in
          first_some
            (List.map
               (fun width () ->
                 let out = JSX.pp ~width el in
                 first_some
                   (List.map
                      (fun (tag, n) () ->
                        let expected = ref_render n in
                        if contains out expected then
                          None
                        else
                          Some
                            (Printf.sprintf "pp width=%d lost %s: %S not in %S"
                               width tag expected out
                            )
                      )
                      exact
                   )
               )
               [ 0; 1; 10; 80 ]
            )
        );
    };
    {
      name = "pp keeps inline text unchanged at any width";
      unsafe = true;
      bad_names = false;
      check =
        (fun d ->
          match leaves d with
          | [] ->
              None
          | ls ->
              let inline = [| "b"; "em"; "span"; "a"; "code"; "img"; "br" |] in
              let children =
                List.mapi
                  (fun i leaf ->
                    if i mod 2 = 1 then
                      N (inline.(i mod Array.length inline), [], [ leaf ])
                    else
                      leaf
                  )
                  ls
              in
              let d = N ("p", [], children) in
              let el = to_jsx d in
              let expected = ref_render d in
              first_some
                (List.map
                   (fun width () ->
                     eq
                       (Printf.sprintf "pp width=%d" width)
                       (JSX.pp ~width el) expected
                   )
                   [ 0; 1; 10; 80 ]
                )
        );
    };
  ]

let streaming_leaf_chunks_case () =
  let count = 100_000 in
  let el = JSX.list (List.init count JSX.int) in
  let chunks = render_streaming_chunks ~chunk_size:4 el in
  let rec bad = function
    | [] | [ _ ] ->
        None
    | c :: rest ->
        let n = String.length c in
        if n < 4 || n >= 4 + 20 then
          Some (Printf.sprintf "chunk of %d bytes" n)
        else
          bad rest
  in
  match bad chunks with
  | Some _ as e ->
      e
  | None ->
      if List.length chunks <= 1000 then
        Some (Printf.sprintf "only %d chunks" (List.length chunks))
      else
        eq "concat" (String.concat "" chunks) (JSX.render el)

let streaming_float_chunks_case () =
  let el = JSX.list (List.init 1000 (fun i -> JSX.float (float_of_int i))) in
  let chunks = render_streaming_chunks ~chunk_size:4 el in
  if List.length chunks > 100 then
    None
  else
    Some (Printf.sprintf "only %d chunks" (List.length chunks))

let chunk_size_case () =
  let el = JSX.node "div" [] [ JSX.string "x" ] in
  let calls = ref 0 in
  if
    raises_invalid_argument (fun () ->
        JSX.render_streaming ~chunk_size:0 (fun _ -> incr calls) el
    )
    && !calls = 0
  then
    None
  else
    Some "chunk_size:0 did not raise without writing"

let attribute_name_case () =
  let bad =
    List.concat_map
      (fun name ->
        List.map
          (fun v -> JSX.node "div" [ (name, v) ] [])
          [ `Bool true; `Bool false; `Int 1; `Float 1.; `String "x" ]
      )
      bad_attribute_names
  in
  first_some
    (List.concat_map
       (fun el ->
         List.map
           (fun (path, run) () ->
             if raises_invalid_argument run then
               None
             else
               Some (path ^ " accepted an invalid attribute name")
           )
           (render_paths el)
       )
       bad
    )

let attribute_name_message_case () =
  match JSX.render (JSX.node "div" [ ("a\"b", `String "x") ] []) with
  | _ ->
      Some "no exception"
  | exception Invalid_argument m ->
      if contains m "a\\\"b" then
        None
      else
        Some ("message does not name the attribute: " ^ m)

let valid_attribute_name_case () =
  eq "render"
    (JSX.render
       (JSX.node "div"
          [
            ("@click", `String "x");
            (":class", `String "y");
            ("hx-on::after-request", `String "z");
            ("x.y", `Bool true);
          ]
          []
       )
    )
    {|<div @click="x" :class="y" hx-on::after-request="z" x.y></div>|}

let pp_inline_case () =
  let el =
    JSX.node "p" []
      [
        JSX.string "Hello ";
        JSX.node "b" [] [ JSX.string "world" ];
        JSX.string "!";
      ]
  in
  first_some
    (List.map
       (fun width () ->
         eq
           (Printf.sprintf "width=%d" width)
           (JSX.pp ~width el) "<p>Hello <b>world</b>!</p>"
       )
       [ 0; 1; 5; 80 ]
    )

let pp_verbatim_case () =
  first_some
    (List.map
       (fun tag () ->
         let content = "a\n    b  <c>\n\n  d" in
         let child =
           match tag with
           | "script" | "style" ->
               JSX.unsafe content
           | _ ->
               JSX.string content
         in
         let inner = JSX.node tag [ ("id", `String "x") ] [ child ] in
         let el = JSX.node "div" [] [ JSX.node "div" [] [ inner ] ] in
         let expected = JSX.render inner in
         let out = JSX.pp ~width:10 el in
         if contains out expected then
           None
         else
           Some (Printf.sprintf "%s: %S not in %S" tag expected out)
       )
       verbatim_tags
    )

let cases =
  [
    ("streaming flushes after int leaves", streaming_leaf_chunks_case);
    ("streaming flushes after float leaves", streaming_float_chunks_case);
    ("streaming chunk_size 0 raises", chunk_size_case);
    ("invalid attribute names raise in every path", attribute_name_case);
    ("invalid attribute name message", attribute_name_message_case);
    ("unusual valid attribute names render", valid_attribute_name_case);
    ("pp keeps <p>Hello <b>world</b>!</p>", pp_inline_case);
    ("pp keeps pre, textarea, script, style content", pp_verbatim_case);
  ]

let run_prop ~seed ~count p =
  let st = Random.State.make [| seed; Hashtbl.hash p.name |] in
  let failure = ref None in
  let i = ref 0 in
  while !failure = None && !i < count do
    let d =
      gen ~unsafe:p.unsafe ~bad_names:p.bad_names st (1 + Random.State.int st 4)
    in
    ( match p.check d with
    | None ->
        ()
    | Some msg ->
        failure := Some (d, msg)
    | exception e ->
        failure := Some (d, "raised " ^ Printexc.to_string e)
    );
    incr i
  done;
  match !failure with
  | None ->
      true
  | Some (d, msg) ->
      let rec minimize d msg =
        let candidates = shrink d in
        match
          List.find_map
            (fun c ->
              match p.check c with
              | Some m ->
                  Some (c, m)
              | None ->
                  None
              | exception e ->
                  Some (c, "raised " ^ Printexc.to_string e)
            )
            candidates
        with
        | Some (c, m) ->
            minimize c m
        | None ->
            (d, msg)
      in
      let d, msg = minimize d msg in
      Printf.printf "FAIL: %s (after %d cases)\n  %s\n  case: %s\n" p.name !i
        msg (to_ocaml d);
      false

let () =
  let seed = ref 42 in
  let count = ref 5000 in
  Arg.parse
    [
      ("--seed", Arg.Set_int seed, "seed");
      ("--count", Arg.Set_int count, "cases per property");
    ]
    ignore "props";
  let results =
    List.map
      (fun p ->
        let ok = run_prop ~seed:!seed ~count:!count p in
        if ok then Printf.printf "ok: %s\n" p.name;
        ok
      )
      props
  in
  let case_results =
    List.map
      (fun (name, check) ->
        match check () with
        | None ->
            Printf.printf "ok: %s\n" name;
            true
        | Some msg ->
            Printf.printf "FAIL: %s\n  %s\n" name msg;
            false
        | exception e ->
            Printf.printf "FAIL: %s\n  raised %s\n" name (Printexc.to_string e);
            false
      )
      cases
  in
  if List.exists not (results @ case_results) then exit 1
