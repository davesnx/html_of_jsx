  $ ../ppx.sh --output re input.re
  let lower = Jsx.node("div", [], []);
  let lower_empty_attr =
    Jsx.node(
      "div",
      List.filter_map(
        Fun.id,
        [Some([@implicit_arity] Attribute.String("class", "": string))],
      ),
      [],
    );
  let lower_inline_styles =
    Jsx.node(
      "div",
      List.filter_map(
        Fun.id,
        [
          Some(
            Attribute.Style(
              Style.make(~backgroundColor="gainsboro", ()): string,
            ),
          ),
        ],
      ),
      [],
    );
  let lower_opt_attr =
    Jsx.node(
      "div",
      List.filter_map(
        Fun.id,
        [
          Option.map(
            v =>
              [@implicit_arity] Attribute.String("tabIndex", string_of_int(v)),
            tabIndex: option(int),
          ),
        ],
      ),
      [],
    );
  let lowerWithChildAndProps = foo =>
    Jsx.node(
      "a",
      List.filter_map(
        Fun.id,
        [
          Some(
            [@implicit_arity]
            Attribute.String("href", "https://example.com": string),
          ),
          Some(
            [@implicit_arity]
            Attribute.String("tabIndex", string_of_int(1: int)),
          ),
        ],
      ),
      [foo],
    );
  let lower_child_static = Jsx.node("div", [], [Jsx.node("span", [], [])]);
  let lower_child_ident = Jsx.node("div", [], [lolaspa]);
  let lower_child_single = Jsx.node("div", [], [Jsx.node("div", [], [])]);
  let lower_children_multiple = (foo, bar) => lower(~children=[foo, bar], ());
  let lower_child_with_upper_as_children =
    Jsx.node("div", [], [App.createElement()]);
  let lower_children_nested =
    Jsx.node(
      "div",
      List.filter_map(
        Fun.id,
        [
          Some(
            [@implicit_arity]
            Attribute.String("class", "flex-container": string),
          ),
        ],
      ),
      [
        Jsx.node(
          "div",
          List.filter_map(
            Fun.id,
            [
              Some(
                [@implicit_arity] Attribute.String("class", "sidebar": string),
              ),
            ],
          ),
          [
            Jsx.node(
              "h2",
              List.filter_map(
                Fun.id,
                [
                  Some(
                    [@implicit_arity]
                    Attribute.String("class", "title": string),
                  ),
                ],
              ),
              ["jsoo-react" |> s],
            ),
            Jsx.node(
              "nav",
              List.filter_map(
                Fun.id,
                [
                  Some(
                    [@implicit_arity] Attribute.String("class", "menu": string),
                  ),
                ],
              ),
              [
                Jsx.node(
                  "ul",
                  [],
                  [
                    examples
                    |> List.map(e =>
                         Jsx.node(
                           "li",
                           [],
                           [
                             Jsx.node(
                               "a",
                               List.filter_map(
                                 Fun.id,
                                 [
                                   Some(
                                     [@implicit_arity]
                                     Attribute.Event(
                                       "onclick",
                                       "console.log": string,
                                     ),
                                   ),
                                   Some(
                                     [@implicit_arity]
                                     Attribute.String("href", e.path: string),
                                   ),
                                 ],
                               ),
                               [e.title |> s],
                             ),
                           ],
                         )
                       )
                    |> React.list,
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  let lower_ref_with_children =
    Jsx.node(
      "button",
      List.filter_map(
        Fun.id,
        [
          Some(
            [@implicit_arity] Attribute.String("class", "FancyButton": string),
          ),
        ],
      ),
      [children],
    );
  let lower_with_many_props =
    Jsx.node(
      "div",
      List.filter_map(
        Fun.id,
        [
          Some([@implicit_arity] Attribute.String("translate", "yes": string)),
        ],
      ),
      [
        Jsx.node(
          "picture",
          List.filter_map(
            Fun.id,
            [
              Some(
                [@implicit_arity] Attribute.String("id", "idpicture": string),
              ),
            ],
          ),
          [
            Jsx.node(
              "img",
              List.filter_map(
                Fun.id,
                [
                  Some(
                    [@implicit_arity] Attribute.String("id", "idimg": string),
                  ),
                  Some(
                    [@implicit_arity]
                    Attribute.String("alt", "test picture/img.png": string),
                  ),
                  Some(
                    [@implicit_arity]
                    Attribute.String("src", "picture/img.png": string),
                  ),
                ],
              ),
              [],
            ),
            Jsx.node(
              "source",
              List.filter_map(
                Fun.id,
                [
                  Some(
                    [@implicit_arity]
                    Attribute.String("src", "picture/img1.webp": string),
                  ),
                  Some(
                    [@implicit_arity]
                    Attribute.String("type", "image/webp": string),
                  ),
                ],
              ),
              [],
            ),
            Jsx.node(
              "source",
              List.filter_map(
                Fun.id,
                [
                  Some(
                    [@implicit_arity]
                    Attribute.String("src", "picture/img2.jpg": string),
                  ),
                  Some(
                    [@implicit_arity]
                    Attribute.String("type", "image/jpeg": string),
                  ),
                ],
              ),
              [],
            ),
          ],
        ),
      ],
    );
  let some_random_html_element = text(~dx="1 2", ~dy="3 4", ());
