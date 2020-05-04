type history;
type unlisten = unit => unit;
type location = {
  pathname: string,
  search: string,
  hash: string,
};

let createBrowserHistory:
  (~basename: string=?, ~forceRefresh: bool=?, ~keyLength: int=?, unit) =>
  history;

let createMemoryHistory:
  (
    ~initialEntries: list(string)=?,
    ~initialIndex: int=?,
    ~keyLength: int=?,
    unit
  ) =>
  history;

let listen: (history, location => unit) => unlisten;
let location: history => location;
let push: (history, string) => unit;
let replace: (history, string) => unit;
