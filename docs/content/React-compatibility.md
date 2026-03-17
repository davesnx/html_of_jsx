
# React compatibility mode

The React compatibility mode eases migration from reason-react to html\_of\_jsx. It adds camelCase aliases for HTML attributes that React uses instead of the standard HTML names.


## Enable

Turn on `-react` in your ppx configuration.

```dune
(libraries html_of_jsx)
(preprocess (pps html_of_jsx.ppx -react))
```

## Aliases

The `-react` flag adds the following aliases. The standard HTML attribute names still work.

| React name | HTML output | Type |
| --- | --- | --- |
| `className` | `class` | string |
| `htmlFor` | `for` | string |
| `tabIndex` | `tabindex` | int |
| `maxLength` | `maxlength` | int |
| `readOnly` | `readonly` | bool |
| `colSpan` | `colspan` | int |
| `rowSpan` | `rowspan` | int |
| `autoComplete` | `autocomplete` | string |
| `defaultValue` | `value` | string |
| `defaultChecked` | `checked` | bool |
```reasonml
JSX.render(
  <div className="card">
    <label htmlFor="email"> {JSX.string("Email")} </label>
    <input
      id="email"
      type_="email"
      tabIndex=1
      maxLength=100
      autoComplete="email"
      readOnly=true
    />
    <table>
      <tr> <td colSpan=2> {JSX.string("Full width")} </td> </tr>
    </table>
  </div>
)
```