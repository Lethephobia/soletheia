# Routing

### DO let the parent define each typed route's path and navigator

Keep route declarations grouped by their owning navigator. Use relative route data for destinations
shared by multiple parents. Place a destination on the root navigator when it should cover the
shell. Register the generated `$appRoutes` once and regenerate bindings after declaration changes.

**Good**

```text
Both parent annotations reference the same typed relative child declaration.
```

**Bad**

```text
A shared destination hard-codes a URL that assumes one particular parent.
```

### DO choose the initial location from resolved application state

When startup navigation depends on persisted data, await the initial read before choosing the
location. For a flow that writes data, navigate on successful completion.

**Good**

```text
Read persisted state -> choose initial typed destination.
```

**Bad**

```text
Treat loading as empty and briefly show the wrong flow.
```

### DO keep router mechanics in the shell and presentation in the layout

Use `goBranch` for stateful branches. Preserve their navigation stacks when switching branches
or resizing. Let the shell supply branch actions and the layout choose their placement.

**Good**

```text
The shell passes the current branch and its action to the responsive layout.
```

**Bad**

```text
The layout inspects the child widget's runtime type to decide where to navigate.
```
