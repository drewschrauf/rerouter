let make:
  {
    .
    "history": option(History.history),
    "children": React.element,
  } =>
  React.element;
let makeProps:
  (
    ~history: History.history=?,
    ~children: React.element,
    ~key: string=?,
    unit
  ) =>
  {
    .
    "history": option(History.history),
    "children": React.element,
  };

type url = {
  path: list(string),
  search: string,
  hash: string,
};
let useUrl: unit => url;
let useHistory: unit => History.history;
