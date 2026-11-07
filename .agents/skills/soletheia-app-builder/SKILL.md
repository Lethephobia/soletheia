---
name: soletheia-app-builder
description: Design and implement the Soletheia wallet app, including Flutter module structure, typed routing, Material UI, localization, and its application-specific Rust bridge. Use for changes to this repository's app, infrastructure integration, or project-specific development skills.
---

# Soletheia App Builder

Guide development of the developer-oriented Soletheia wallet. The Dart workspace is
`apps/soletheia_wallet`; its Flutter application is `app`, with supporting packages under
`packages`. Resolve these paths relative to the repository root.

Read only the references relevant to the task. Check the current source and diff before applying
examples: paths and APIs can evolve, and existing uncommitted changes may be intentional.
These guides preserve project decisions; an explicit user-requested design change can revise them.
Do not infer authorization to implement from a request to discuss a design.

## Reading conventions

- **DO**: expected rule; departures need a concrete reason.
- **DON'T**: avoid the stated approach within its defined scope.
- **PREFER**: recommended default; alternatives may fit the context.
- **AVOID**: usually unsuitable; exceptions need a practical benefit.
- **CONSIDER**: optional guidance for the stated circumstances.

Each directive has paired **Good** and **Bad** fenced examples. DO, PREFER, and CONSIDER put
Good first; DON'T and AVOID put Bad first. Examples are focused excerpts, not complete programs.
When updating this skill, preserve the rationale while updating obsolete examples. Do not convert
a one-time cleanup, an omitted feature, or a temporary platform limitation into a permanent ban.

## Reference map

- [Structure](references/structure.md): Dart function bodies, module layout, barrels, naming, Riverpod generation, and application exception types.
- [Routing](references/routing.md): typed routes, branches, and shell ownership.
- [UI](references/ui.md): View/Layout boundaries, current official M3/Expressive guidance, components, theme, and responsiveness.
- [Localization](references/localization.md): ARB keys, translator context, reuse, and messages.
- [Rust](references/rust.md): application-specific Rust, the FFI facade, and generated integration.
- [Skill Authoring](references/skills.md): skill scope, reference organization, paired examples, and preserving design decisions during updates.

## Verification

Choose checks for the changed behavior. From `apps/soletheia_wallet/app`, use
`flutter gen-l10n` after ARB changes and `dart run build_runner build` after changes to generated
Riverpod or typed-route definitions. Run formatting, `flutter analyze`, and relevant existing tests.
For Rust changes, use the current workspace toolchain and the checks configured in the Rust workflow.
Do not hand-edit generated outputs to make checks pass or broaden a task into CI changes.
