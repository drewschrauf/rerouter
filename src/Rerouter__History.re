type history;
type unlisten = unit => unit;
type location = {
  pathname: string,
  search: string,
  hash: string,
};

module BrowserHistoryOptions = {
  type t = {
    basename: option(string),
    forceRefresh: option(bool),
    keyLength: option(int),
  };
};

module MemoryHistoryOptions = {
  type t = {
    initialEntries: option(array(string)),
    initialIndex: option(int),
    keyLength: option(int),
  };
};

[@bs.module "history"]
external _createBrowserHistory: BrowserHistoryOptions.t => history =
  "createBrowserHistory";

[@bs.module "history"]
external _createMemoryHistory: MemoryHistoryOptions.t => history =
  "createMemoryHistory";

[@bs.send] external listen: (history, location => unit) => unlisten = "listen";
[@bs.get] external location: history => location = "location";
[@bs.send] external push: (history, string) => unit = "push";
[@bs.send] external replace: (history, string) => unit = "replace";

let createBrowserHistory =
    (
      ~basename: option(string)=?,
      ~forceRefresh: option(bool)=?,
      ~keyLength: option(int)=?,
      (),
    )
    : history =>
  _createBrowserHistory({basename, forceRefresh, keyLength});

let createMemoryHistory =
    (
      ~initialEntries: option(list(string))=?,
      ~initialIndex: option(int)=?,
      ~keyLength: option(int)=?,
      (),
    )
    : history =>
  _createMemoryHistory({
    initialEntries:
      switch (initialEntries) {
      | Some(entries) => Some(entries->Array.of_list)
      | None => None
      },
    initialIndex,
    keyLength,
  });
