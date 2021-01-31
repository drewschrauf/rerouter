type t
type unlisten = unit => unit
type location = {
  pathname: string,
  search: string,
  hash: string,
}
type listenEvent = {location: location}

let createBrowserHistory: (~basename: string=?, ~forceRefresh: bool=?, ~keyLength: int=?, unit) => t

let createMemoryHistory: (
  ~initialEntries: array<string>=?,
  ~initialIndex: int=?,
  ~keyLength: int=?,
  unit,
) => t

let listen: (t, listenEvent => unit) => unlisten
let location: t => location
let push: (t, string) => unit
let replace: (t, string) => unit
