# Rerouter

Rerouter is a minimal router for [ReasonReact](https://reasonml.github.io/reason-react/) projects. It uses [history](https://github.com/ReactTraining/history) under the hood to make testing simple.

## Wait, doesn't ReasonReact have a built-in router?

[Yes](https://reasonml.github.io/reason-react/docs/en/router.html)! An excellent one, in fact.

However, its strength is also its weakness. It provides very thin bindings to the browser's API for reading and updating the URL. Unfortunately, these APIs are not supported by [Jest](https://jestjs.io/) (and, by extension, [@glennsl/bs-jest](https://github.com/glennsl/bs-jest)).

This router makes use of history to enable the use of the browser history in the browser and an in-memory history for testing.

## Installation

Just install the package

```bash
yarn add @drewschrauf/rerouter
```

and add it to your `bsconfig.json`

```json
{
    "bs-dependencies": [
        "@drewschrauf/rerouter"
    ]
}
```

## Usage

Simply wrap the `<Rerouter />` component around your application and you're good to go.

```reason
/* Index.re */
ReactDOMRe.renderToElementWithId(<Rerouter> <App /> </Rerouter>)
```

Within your app you can make use of `useUrl()` and `useHistory()` to get your current location and update it respectively.

When you're writing your tests (ideally with [@glennsl/bs-jest](https://github.com/glennsl/bs-jest) and [@drewschrauf/react-testing-library](https://github.com/drewschrauf/bs-testing-library)), render your app inside a `<Rerouter />` component with a memory history instead.

```reason
/* MyTest_test.re */
test("app should render", () => {
  let history = Rerouter.History.createMemoryHistory(~initialEntries=["/"], ());
  render(<Rerouter history> <App /> </Rerouter>);
});
```

## API

The API is heavily based on [ReasonReactRouter](https://reasonml.github.io/reason-react/docs/en/router). It's worth giving their own documentation a read to see why this approach to a React router is so perfect for Reason.

### Context and Hooks

**`<Rerouter history=option(Rerouter.History.t) />`**

The history context provider. The must be wrapped around your application in order to be able to use the following hooks. If no `history` is passed, a browser history is instantiated and used.

**`useUrl(): { path: list(string), search: string, hash: string }`**

Retrieves the current URL parts. The API is identical to that provided by ReasonReactRouter.

**`useHistory(): Rerouter.History.t`**

Retrieves the history object. This is required for passing to the `push` and `replace` methods below.

### History

**`createBrowserHistory(~basename: string=?, ~forceRefresh: bool=?, ~keyLength: int=?, ()): Rerouter.History.t`**

Create a history object for use within the browser. You usually won't need to call this yourself unless you want to customise the instance. Using `<Rerouter />` without a `history` argument will instantiate one of these by default.

**`createMemoryHistory(~initialEntries: list(string)=?, ~initialIndex: int=?, ~keyLength: int=?, ()): Rerouter.History.t`**

Create a history object for use in tests. Pass this as the `history` prop of your `<Rerouter />` context provider.

**`push(history: Rerouter.History.t, url: string): unit`**

Navigate to the given URL.

**`replace(history: Rerouter.History.t, url: string): unit`**

Navigate to the given URL, replacing the current URL in the history.
