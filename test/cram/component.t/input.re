let hello = (~lola) => {
  <div> {React.string(lola)} </div>;
};

let react_component_with_props = <hello lola="flores" />;

let cositas = (~lola=?) => {
  switch (lola) {
  | Some(lola) => <div> {React.string(lola)} </div>
  | None => <div> {React.string("no lola")} </div>
  };
};

let react_component_with_optional_prop = <hello lola=?"flores" />;

let div = <> <div class_="md:w-1/3" /> <div class_="md:w-2/3" /> </>;

let component = <Container> <span /> </Container>;
