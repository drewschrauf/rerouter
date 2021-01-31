type t
type unlisten = unit => unit
type location = {
  pathname: string,
  search: string,
  hash: string,
}

let createBrowserHistory: (~basename: string=?, ~forceRefresh: bool=?, ~keyLength: int=?, unit) => t

let createMemoryHistory: (
  ~initialEntries: list<string>=?,
  ~initialIndex: int=?,
  ~keyLength: int=?,
  unit,
) => t

let listen: (t, location => unit) => unlisten
let location: t => location
let push: (t, string) => unit
let replace: (t, string) => unit
