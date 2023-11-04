let hello = (~lola) => {
  <div> {React.string(lola)} </div>;
};

let react_component_with_props = <hello lola="flores" />;
