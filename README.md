# Rerouter

Rerouter is a minimal router for reason-react projects. It uses history under the hood to make testing simple.

## Wait, doesn't reason-react have a built-in router?

[Yes](https://reasonml.github.io/reason-react/docs/en/router.html)! An excellent one, in fact.

However, its strength is also its weakness. It provides very thin bindings to the browser's history API for reading and updating the URL. Unfortunately, these APIs are not supported by jest (and, by extension, bs-jest).

This router makes use of history to enable the use of the browser history in the browser and an in-memory history for testing.

## Example

Simply wrap the `<Rerouter />` component around your application and you're good to go.

```reason
/* Index.re */
ReactDOMRe.renderToElementWithId(<Rerouter> <App /> </Rerouter>)
```

Within your app you can make use of `useUrl()` and `useHistory()` to get your current location and update it respectively.

When you're writing your tests (ideally with bs-jest and @drewschrauf/react-testing-library), render your app inside a `<Rerouter />` component with a memory history instead.

```reason
/* MyTest_test.re */
test("app should render", () => {
	let history = Rerouter.History.createMemoryHistory(~initialEntries=["/"], ());
	render(<Rerouter history> <App /> </Rerouter>);
})
```



## API

### Context and Hooks

**`<Rerouter history=option(Rerouter.History.t) />`**

**`useUrl(): { path: list(string), search: string, hash: string }`**

**`useHistory(): Rerouter.History.t`**

### History

**`createBrowserHistory(~basename: string=?, ~forceRefresh: bool=?, ~keyLength: int=?, ()): Rerouter.History.t`**

**`createMemoryHistory(~initialEntries: list(string)=?, ~initialIndex: int=?, ~keyLength: int=?, ()): Rerouter.History.t`**

**`listen(history: Rerouter.History.t, onChange: Rerouter.History.location => unit): () => unit`**

**`location(history: Rerouter.History.t): Rerouter.History.location`**

**`push(history: Rerouter.History.t, path: string): unit`**

**`replace(history: Rerouter.History.t, path: string): unit`**