let decimal_attr = <div tabindex=99999999999999999999 />;
let hex_attr = <div tabindex=0xFFFFFFFFFFFFFFFF />;
let int_child = <p> {JSX.int(99999999999999999999)} </p>;
let format_arg = <p> {JSX.format("%d", 99999999999999999999)} </p>;
