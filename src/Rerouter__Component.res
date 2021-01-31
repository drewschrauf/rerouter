module History = Rerouter__History

type url = {
  path: array<string>,
  search: string,
  hash: string,
}

let context = React.createContext(None)

module Provider = {
  let make = React.Context.provider(context)
  let makeProps = (~value, ~children, ()) =>
    {
      "value": value,
      "children": children,
    }
}

let locationToUrl = (location: History.location): url => {
  {
    path: switch location.pathname {
    | ""
    | "/" => []
    | raw =>
      let raw = raw->Js.String2.sliceToEnd(~from=1)
      let lastChar = raw->Js.String2.get(raw->String.length - 1)
      let raw = switch lastChar {
      | "/" => raw->Js.String2.slice(~from=0, ~to_=-1)
      | _ => raw
      }
      raw->Js.String2.split("/")
    },
    search: location.search->Js.String2.sliceToEnd(~from=1),
    hash: location.hash->Js.String2.sliceToEnd(~from=1),
  }
}

@react.component
let make = (~history=?, ~children) => {
  let history = React.useMemo1(() =>
    switch history {
    | Some(history) => history
    | None => History.createBrowserHistory()
    }
  , [])

  let (url, setUrl) = React.useState(_ => history->History.location->locationToUrl)

  React.useEffect(() => {
    let unlisten = history->History.listen(l => setUrl(_ => l.location->locationToUrl))
    Some(unlisten)
  })

  <Provider value=Some((url, history))> children </Provider>
}

let useUrl = (): url => {
  let c = React.useContext(context)
  switch c {
  | Some((url, _)) => url
  | None => Js.Exn.raiseError("useUrl must be used inside a Rerouter context")
  }
}

let useHistory = (): History.t => {
  let c = React.useContext(context)
  switch c {
  | Some((_, history)) => history
  | None => Js.Exn.raiseError("useHistory must be used inside a Rerouter context")
  }
}
