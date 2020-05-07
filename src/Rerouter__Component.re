module History = Rerouter__History;

type url = {
  path: list(string),
  search: string,
  hash: string,
};

let context = React.createContext(None);

module Provider = {
  let make = React.Context.provider(context);
  let makeProps = (~value, ~children, ()) => {
    "value": value,
    "children": children,
  };
};

let locationToUrl = (location: History.location): url => {
  path:
    switch (location.pathname) {
    | ""
    | "/" => []
    | raw =>
      let raw = raw |> Js.String.sliceToEnd(~from=1);
      let lastChar = raw.[raw->String.length - 1];
      let raw =
        switch (lastChar) {
        | '/' => raw |> Js.String.slice(~from=0, ~to_=-1)
        | _ => raw
        };
      raw->String.split_on_char('/', _);
    },
  search: location.search->Js.String.sliceToEnd(~from=1),
  hash: location.hash->Js.String.sliceToEnd(~from=1),
};

[@react.component]
let make = (~history=?, ~children) => {
  let history =
    React.useMemo1(
      () =>
        switch (history) {
        | Some(history) => history
        | None => History.createBrowserHistory()
        },
      [||],
    );

  let (url, setUrl) =
    React.useState(_ => history->History.location->locationToUrl);

  React.useEffect(() => {
    let unlisten = history->History.listen(l => setUrl(_ => l->locationToUrl));
    Some(unlisten);
  });

  <Provider value={Some((url, history))}> children </Provider>;
};

let useUrl = (): url => {
  let c = React.useContext(context);
  switch (c) {
  | Some((url, _)) => url
  | None => Js.Exn.raiseError("useUrl must be used inside a Rerouter context")
  };
};

let useHistory = (): History.history => {
  let c = React.useContext(context);
  switch (c) {
  | Some((_, history)) => history
  | None =>
    Js.Exn.raiseError("useHistory must be used inside a Rerouter context")
  };
};
