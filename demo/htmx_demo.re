module Counter = {
  let make = (~count, ()) => {
    <div style="display: flex; align-items: center; gap: 12px">
      <button
        hx_post="/htmx/counter/decrement"
        hx_target="#counter"
        hx_swap=`outerHTML
        style="padding: 8px 16px; font-size: 1.2rem; cursor: pointer; border: 1px solid #555; background: #333; color: #eee; border-radius: 4px">
        "-"
      </button>
      <span
        id="counter"
        style="font-size: 1.5rem; min-width: 40px; text-align: center">
        {JSX.int(count)}
      </span>
      <button
        hx_post="/htmx/counter/increment"
        hx_target="#counter"
        hx_swap=`outerHTML
        style="padding: 8px 16px; font-size: 1.2rem; cursor: pointer; border: 1px solid #555; background: #333; color: #eee; border-radius: 4px">
        "+"
      </button>
    </div>;
  };
};

let contacts = [|
  ("Leandro", "leandro@example.com"),
  ("Alan", "alan@example.com"),
  ("David", "david@example.com"),
  ("TJ", "tj@example.com"),
  ("Antonio", "antonio@example.com"),
  ("Andrey", "andrey@example.com"),
|];

module Search_results = {
  let make = (~query, ()) => {
    let results =
      if (String.length(query) == 0) {
        Array.to_list(contacts);
      } else {
        let q = String.lowercase_ascii(query);
        Array.to_list(contacts)
        |> List.filter(((name, _email)) =>
             String.lowercase_ascii(name) |> String.starts_with(~prefix=q)
           );
      };

    <tbody id="search-results">
      {JSX.list(
         List.map(
           ((name, email)) =>
             <tr style="border-bottom: 1px solid #444">
               <td style="padding: 8px 16px"> {JSX.string(name)} </td>
               <td style="padding: 8px 16px"> {JSX.string(email)} </td>
             </tr>,
           results,
         ),
       )}
    </tbody>;
  };
};

module Todo_item = {
  let make = (~id, ~text, ()) => {
    <li
      id={Printf.sprintf("todo-%d", id)}
      style="display: flex; align-items: center; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #444">
      <span> {JSX.string(text)} </span>
      <button
        hx_delete={Printf.sprintf("/htmx/todos/%d", id)}
        hx_target={Printf.sprintf("#todo-%d", id)}
        hx_swap=`outerHTML
        hx_confirm="Are you sure?"
        style="padding: 4px 12px; cursor: pointer; border: 1px solid #833; background: #633; color: #eee; border-radius: 4px">
        "Delete"
      </button>
    </li>;
  };
};

module Section = {
  let make = (~title: string, ~children: list(JSX.element), ()) => {
    <section
      style="margin-bottom: 40px; padding: 24px; border: 1px solid #444; border-radius: 8px">
      <h2 style="margin: 0 0 16px 0; font-size: 1.3rem">
        {JSX.string(title)}
      </h2>
      {JSX.list(children)}
    </section>;
  };
};

let page = () => {
  <html lang="en" style="color-scheme: dark">
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title> "HTMX Demo - html_of_jsx" </title>
      <Htmx version="2.0.4" />
      <style type_="text/css">
        {|
        html {
          height: 100vh;
          width: 100vw;
          margin: 0;
          padding: 0;
          line-height: 1.5;
          font-family: ui-sans-serif, system-ui, sans-serif;
        }
        body {
          max-width: 720px;
          margin: 0 auto;
          padding: 40px 20px;
        }
        |}
      </style>
    </head>
    <body>
      <h1 style="margin-bottom: 8px"> "HTMX Demo" </h1>
      <p style="color: #999; margin-bottom: 32px">
        "Powered by "
        <code> "html_of_jsx" </code>
        " + "
        <code> "html_of_jsx.htmx" </code>
      </p>
      <Section title="Click to load">
        <p style="color: #aaa; margin-bottom: 12px">
          "Click the button to load content from the server."
        </p>
        <button
          hx_get="/htmx/click"
          hx_target="#click-result"
          hx_swap=`innerHTML
          style="padding: 8px 20px; cursor: pointer; border: 1px solid #555; background: #333; color: #eee; border-radius: 4px">
          "Load content"
        </button>
        <div
          id="click-result"
          style="margin-top: 12px; padding: 12px; min-height: 20px"
        />
      </Section>
      <Section title="Counter">
        <p style="color: #aaa; margin-bottom: 12px">
          "Server-side counter with htmx POST requests."
        </p>
        <Counter count=0 />
      </Section>
      <Section title="Active search">
        <p style="color: #aaa; margin-bottom: 12px">
          "Search contacts as you type (debounced 300ms)."
        </p>
        <input
          type_=`search
          name="query"
          placeholder="Search contacts..."
          hx_post="/htmx/search"
          hx_trigger="keyup changed delay:300ms, search"
          hx_target="#search-results"
          hx_swap=`outerHTML
          style="padding: 8px 12px; width: 100%; box-sizing: border-box; border: 1px solid #555; background: #222; color: #eee; border-radius: 4px; font-size: 1rem"
        />
        <table
          style="width: 100%; margin-top: 12px; border-collapse: collapse">
          <thead>
            <tr style="border-bottom: 2px solid #555">
              <th style="padding: 8px 16px; text-align: left"> "Name" </th>
              <th style="padding: 8px 16px; text-align: left"> "Email" </th>
            </tr>
          </thead>
          <Search_results query="" />
        </table>
      </Section>
      <Section title="Delete with confirmation">
        <p style="color: #aaa; margin-bottom: 12px">
          "Delete items with a confirmation dialog."
        </p>
        <ul style="list-style: none; padding: 0; margin: 0">
          <Todo_item id=1 text="Learn OCaml" />
          <Todo_item id=2 text="Build with html_of_jsx" />
          <Todo_item id=3 text="Add htmx interactions" />
        </ul>
      </Section>
    </body>
  </html>;
};

let fragment_click = () => {
  <div
    style="padding: 12px; background: #1a3a1a; border: 1px solid #2a5a2a; border-radius: 4px">
    <strong> "Loaded from the server!" </strong>
    " This content was fetched via "
    <code> "hx-get" </code>
    " and swapped in."
  </div>;
};

let fragment_counter = count => {
  <Counter count />;
};

let fragment_search = query => {
  <Search_results query />;
};
