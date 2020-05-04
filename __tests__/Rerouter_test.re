open Jest;
open Expect;
open ReactTestingLibrary;
open JestDom;

let history = [%bs.raw {| require("history") |}];
let bh = [%bs.raw {| jest.spyOn(history, "createBrowserHistory")|}];

let renderWithRouter = (~path="/", comp) => {
  render(
    <Rerouter
      history={History.createMemoryHistory(~initialEntries=[path], ())}>
      comp
    </Rerouter>,
  );
};

module WithTestId = {
  [@react.component]
  let make = (~testid, ~children) =>
    ReasonReact.cloneElement(children, ~props={"data-testid": testid}, [||]);
};

module Harness = {
  [@react.component]
  let make = (~navOnClick="/") => {
    let url = Rerouter.useUrl();
    let history = Rerouter.useHistory();

    <>
      <WithTestId testid="path">
        <span>
          {url.path->Array.of_list->Js.Array.toString->React.string}
        </span>
      </WithTestId>
      <WithTestId testid="search">
        <span> url.search->React.string </span>
      </WithTestId>
      <WithTestId testid="hash">
        <span> url.hash->React.string </span>
      </WithTestId>
      <button onClick={_ => history->History.push(navOnClick)}>
        "Navigate"->React.string
      </button>
    </>;
  };
};

beforeEach(() => {
  %bs.raw
  {| jest.clearAllMocks() |}
});

test("path should be empty when just /", () => {
  renderWithRouter(<Harness />, ~path="/")
  |> getByTestId("path")
  |> expect
  |> toHaveTextContent("")
});

test("path should be list", () => {
  renderWithRouter(<Harness />, ~path="/hello/world")
  |> getByTestId("path")
  |> expect
  |> toHaveTextContent("hello,world")
});

test("path should trim trailing slash", () => {
  renderWithRouter(<Harness />, ~path="/hello/world/")
  |> getByTestId("path")
  |> expect
  |> toHaveTextContent("hello,world")
});

test("search should be empty when no search present", () => {
  renderWithRouter(<Harness />, ~path="/")
  |> getByTestId("search")
  |> expect
  |> toHaveTextContent("")
});

test("search should be empty when just ?", () => {
  renderWithRouter(<Harness />, ~path="/?")
  |> getByTestId("search")
  |> expect
  |> toHaveTextContent("")
});

test("search should be search without ?", () => {
  renderWithRouter(<Harness />, ~path="/?search")
  |> getByTestId("search")
  |> expect
  |> toHaveTextContent("search")
});

test("hash should be empty when no hash present", () => {
  renderWithRouter(<Harness />, ~path="/")
  |> getByTestId("hash")
  |> expect
  |> toHaveTextContent("")
});

test("hash should be empty when just #", () => {
  renderWithRouter(<Harness />, ~path="/#")
  |> getByTestId("hash")
  |> expect
  |> toHaveTextContent("")
});

test("hash should be hash without #", () => {
  renderWithRouter(<Harness />, ~path="/#hash")
  |> getByTestId("hash")
  |> expect
  |> toHaveTextContent("hash")
});

test("using history.push should update url", () => {
  let root =
    renderWithRouter(<Harness navOnClick="/hello/world" />, ~path="/");
  root |> getByText("Navigate") |> FireEvent.click;
  root |> getByTestId("path") |> expect |> toHaveTextContent("hello,world");
});

test(
  "using the provider without a history should default to a browser history",
  () => {
  render(<Rerouter> <Harness /> </Rerouter>)->ignore;
  [%bs.raw {| expect(bh).toHaveBeenCalled() |}]->ignore;
  pass;
});
