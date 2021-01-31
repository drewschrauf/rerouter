open Jest
open Expect
open ReactHooksTestingLibrary

let history = %bs.raw(` require("history") `)
let bh = %bs.raw(` jest.spyOn(history, "createBrowserHistory") `)

beforeEach(() => {
  %bs.raw(` jest.clearAllMocks() `)->ignore
  %bs.raw(` console.error = jest.fn() `)->ignore
})

module type TestArgs = {
  let url: string
  let path: list<string>
  let search: string
  let hash: string
}
module type TestCase = {}
module Tests = (TA: TestArgs): TestCase => {
  module Context = {
    @react.component
    let make = (~children) =>
      <Rerouter history={Rerouter.History.createMemoryHistory(~initialEntries=list{TA.url}, ())}>
        children
      </Rerouter>
  }

  test(
    "when url is \"" ++
    (TA.url ++
    ("\" path should be [" ++
    ((TA.path |> List.map(i => "\"" ++ (i ++ "\"")) |> Array.of_list |> Js.Array.joinWith(", ")) ++
    "]"))),
    () => {
      let {Rerouter.path: path} =
        renderHook(() => Rerouter.useUrl(), ~wrapper=Context.make) |> current
      expect(path) |> toEqual(TA.path)
    },
  )

  test("when url is \"" ++ (TA.url ++ ("\" search should be \"" ++ (TA.search ++ "\""))), () => {
    let {Rerouter.search: search} =
      renderHook(() => Rerouter.useUrl(), ~wrapper=Context.make) |> current
    expect(search) |> toEqual(TA.search)
  })

  test("when url is \"" ++ (TA.url ++ ("\" hash should be \"" ++ (TA.hash ++ "\""))), () => {
    let {Rerouter.hash: hash} =
      renderHook(() => Rerouter.useUrl(), ~wrapper=Context.make) |> current
    expect(hash) |> toEqual(TA.hash)
  })
}

include Tests({
  let url = "/"
  let path = list{}
  let search = ""
  let hash = ""
})

include Tests({
  let url = "/hello/world"
  let path = list{"hello", "world"}
  let search = ""
  let hash = ""
})

include Tests({
  let url = "/hello/world/"
  let path = list{"hello", "world"}
  let search = ""
  let hash = ""
})

include Tests({
  let url = "/?"
  let path = list{}
  let search = ""
  let hash = ""
})

include Tests({
  let url = "/?search"
  let path = list{}
  let search = "search"
  let hash = ""
})

include Tests({
  let url = "/#"
  let path = list{}
  let search = ""
  let hash = ""
})

include Tests({
  let url = "/#hash"
  let path = list{}
  let search = ""
  let hash = "hash"
})

include Tests({
  let url = "/hello/world?search=value#hash"
  let path = list{"hello", "world"}
  let search = "search=value"
  let hash = "hash"
})

module Context = {
  @react.component
  let make = (~children) =>
    <Rerouter history={Rerouter.History.createMemoryHistory(~initialEntries=list{"/"}, ())}>
      children
    </Rerouter>
}

test("using history.push should update url", () => {
  let result = renderHook(() => {
    let path = Rerouter.useUrl()
    let history = Rerouter.useHistory()
    (path, history)
  }, ~wrapper=Context.make)

  let history = result |> current |> snd

  act(() => history->Rerouter.History.push("/hello/world"))

  let {Rerouter.path: path} = result |> current |> fst

  expect(path) |> toEqual(list{"hello", "world"})
})

test("using history.replace should update url", () => {
  let result = renderHook(() => {
    let path = Rerouter.useUrl()
    let history = Rerouter.useHistory()
    (path, history)
  }, ~wrapper=Context.make)

  let history = result |> current |> snd

  act(() => history->Rerouter.History.replace("/hello/world"))

  let {Rerouter.path: path} = result |> current |> fst

  expect(path) |> toEqual(list{"hello", "world"})
})

test("using the provider without a history should default to a browser history", () => {
  ReactTestingLibrary.render(<Rerouter> <div /> </Rerouter>)->ignore
  %bs.raw(` expect(bh).toHaveBeenCalled() `)->ignore
  pass
})

test("Using useUrl without a context should throw", () =>
  renderHook(() => Rerouter.useUrl())
  |> error
  |> Js.Exn.message
  |> expect
  |> toBe(Some("useUrl must be used inside a Rerouter context"))
)

test("Using useHistory without a context should throw", () =>
  renderHook(() => Rerouter.useHistory())
  |> error
  |> Js.Exn.message
  |> expect
  |> toBe(Some("useHistory must be used inside a Rerouter context"))
)
