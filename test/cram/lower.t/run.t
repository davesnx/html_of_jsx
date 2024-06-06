  $ ../ppx.sh --output re input.re
  let lower = JSX.node("div", [], []);
  let lower_empty_attr =
    JSX.node(
      "div",
      List.filter_map(
        Fun.id,
        [Some([@implicit_arity] JSX.Attribute.String("class", "": string))],
      ),
      [],
    );
  let lower_inline_styles =
    JSX.node(
      "div",
      List.filter_map(
        Fun.id,
        [
          Some(
            JSX.Attribute.Style(
              Style.make(~backgroundColor="gainsboro", ()): string,
            ),
          ),
        ],
      ),
      [],
    );
  let lower_opt_attr =
    JSX.node(
      "div",
      List.filter_map(
        Fun.id,
        [
          Stdlib.Option.map(
            v =>
              [@implicit_arity]
              JSX.Attribute.String("tabindex", string_of_int(v)),
            tabindex: option(int),
          ),
        ],
      ),
      [],
    );
  let lowerWithChildAndProps = foo =>
    JSX.node(
      "a",
      List.filter_map(
        Fun.id,
        [
          Some(
            [@implicit_arity]
            JSX.Attribute.String("href", "https://example.com": string),
          ),
          Some(
            [@implicit_arity]
            JSX.Attribute.String("tabindex", string_of_int(1: int)),
          ),
        ],
      ),
      [foo],
    );
  let lower_child_static = JSX.node("div", [], [JSX.node("span", [], [])]);
  let lower_child_ident = JSX.node("div", [], [lolaspa]);
  let lower_child_single = JSX.node("div", [], [JSX.node("div", [], [])]);
  let lower_children_multiple = (foo, bar) => lower(~children=[foo, bar], ());
  let lower_child_with_upper_as_children = JSX.node("div", [], [App.make()]);
  let lower_children_nested =
    JSX.node(
      "div",
      List.filter_map(
        Fun.id,
        [
          Some(
            [@implicit_arity]
            JSX.Attribute.String("class", "flex-container": string),
          ),
        ],
      ),
      [
        JSX.node(
          "div",
          List.filter_map(
            Fun.id,
            [
              Some(
                [@implicit_arity]
                JSX.Attribute.String("class", "sidebar": string),
              ),
            ],
          ),
          [
            JSX.node(
              "h2",
              List.filter_map(
                Fun.id,
                [
                  Some(
                    [@implicit_arity]
                    JSX.Attribute.String("class", "title": string),
                  ),
                ],
              ),
              ["jsoo-react" |> s],
            ),
            JSX.node(
              "nav",
              List.filter_map(
                Fun.id,
                [
                  Some(
                    [@implicit_arity]
                    JSX.Attribute.String("class", "menu": string),
                  ),
                ],
              ),
              [
                JSX.node(
                  "ul",
                  [],
                  [
                    examples
                    |> List.map(e =>
                         JSX.node(
                           "li",
                           [],
                           [
                             JSX.node(
                               "a",
                               List.filter_map(
                                 Fun.id,
                                 [
                                   Some(
                                     [@implicit_arity]
                                     JSX.Attribute.Event(
                                       "onclick",
                                       "console.log": string,
                                     ),
                                   ),
                                   Some(
                                     [@implicit_arity]
                                     JSX.Attribute.String(
                                       "href",
                                       e.path: string,
                                     ),
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
    JSX.node(
      "button",
      List.filter_map(
        Fun.id,
        [
          Some(
            [@implicit_arity]
            JSX.Attribute.String("class", "FancyButton": string),
          ),
        ],
      ),
      [children],
    );
  let lower_with_many_props =
    JSX.node(
      "div",
      List.filter_map(
        Fun.id,
        [
          Some(
            [@implicit_arity] JSX.Attribute.String("translate", "yes": string),
          ),
        ],
      ),
      [
        JSX.node(
          "picture",
          List.filter_map(
            Fun.id,
            [
              Some(
                [@implicit_arity]
                JSX.Attribute.String("id", "idpicture": string),
              ),
            ],
          ),
          [
            JSX.node(
              "img",
              List.filter_map(
                Fun.id,
                [
                  Some(
                    [@implicit_arity]
                    JSX.Attribute.String("id", "idimg": string),
                  ),
                  Some(
                    [@implicit_arity]
                    JSX.Attribute.String("alt", "test picture/img.png": string),
                  ),
                  Some(
                    [@implicit_arity]
                    JSX.Attribute.String("src", "picture/img.png": string),
                  ),
                ],
              ),
              [],
            ),
            JSX.node(
              "source",
              List.filter_map(
                Fun.id,
                [
                  Some(
                    [@implicit_arity]
                    JSX.Attribute.String("src", "picture/img1.webp": string),
                  ),
                  Some(
                    [@implicit_arity]
                    JSX.Attribute.String("type", "image/webp": string),
                  ),
                ],
              ),
              [],
            ),
            JSX.node(
              "source",
              List.filter_map(
                Fun.id,
                [
                  Some(
                    [@implicit_arity]
                    JSX.Attribute.String("src", "picture/img2.jpg": string),
                  ),
                  Some(
                    [@implicit_arity]
                    JSX.Attribute.String("type", "image/jpeg": string),
                  ),
                ],
              ),
              [],
            ),
          ],
        ),
      ],
    );
  let some_random_html_element =
    JSX.node(
      "text",
      List.filter_map(
        Fun.id,
        [
          Some([@implicit_arity] JSX.Attribute.String("dy", "3 4": string)),
          Some([@implicit_arity] JSX.Attribute.String("dx", "1 2": string)),
        ],
      ),
      [],
    );
