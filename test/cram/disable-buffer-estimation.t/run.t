Test with -disable-buffer-estimation flag: buffer should use fixed size (1024) instead of estimated size
  $ ../ppx.sh --output re --flags="-disable-buffer-estimation" input.re
  let dynamic_string = name => {
    let __html_buf = Buffer.create(1024);
    {
      Buffer.add_string(__html_buf, "<div>");
      JSX.escape(__html_buf, name);
      Buffer.add_string(__html_buf, "</div>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let dynamic_int = count => {
    let __html_buf = Buffer.create(1024);
    {
      Buffer.add_string(__html_buf, "<div>");
      Buffer.add_string(__html_buf, Int.to_string(count));
      Buffer.add_string(__html_buf, "</div>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let dynamic_element = child => {
    let __html_buf = Buffer.create(1024);
    {
      Buffer.add_string(__html_buf, "<div>");
      JSX.write(__html_buf, child);
      Buffer.add_string(__html_buf, "</div>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
  let mixed = (name, child) => {
    let __html_buf = Buffer.create(1024);
    {
      Buffer.add_string(__html_buf, "<div>");
      JSX.escape(__html_buf, name);
      JSX.write(__html_buf, child);
      Buffer.add_string(__html_buf, "</div>");
      ();
    };
    JSX.unsafe(Buffer.contents(__html_buf));
  };
