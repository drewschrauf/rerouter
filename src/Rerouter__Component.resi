let make: {"history": option<Rerouter__History.t>, "children": React.element} => React.element
let makeProps: (
  ~history: Rerouter__History.t=?,
  ~children: React.element,
  ~key: string=?,
  unit,
) => {"history": option<Rerouter__History.t>, "children": React.element}

type url = {
  path: list<string>,
  search: string,
  hash: string,
}
let useUrl: unit => url
let useHistory: unit => Rerouter__History.t
