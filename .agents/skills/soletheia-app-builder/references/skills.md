# Skill Authoring

Use this reference when creating or updating Soletheia skills and their references. Preserve the
user's design decisions while keeping instructions focused on choices that need project context.

## Entry Point

### DO make SKILL.md explain scope and how to read references

Keep YAML `name` and `description` accurate so the skill can be selected for the right tasks. In the
body, describe its purpose, explain the directive keywords, and tell readers to select relevant
references from the index rather than loading every guide. Keep detailed rules in those references.

Use the Effective Dart-style keywords consistently:

| Keyword | Meaning | Example order |
| --- | --- | --- |
| DO | Expected rule; departures need a concrete reason | Good, then Bad |
| DON'T | Prohibited approach within the stated scope | Bad, then Good |
| PREFER | Recommended default, with reasonable alternatives | Good, then Bad |
| AVOID | Usually unsuitable, but justified exceptions exist | Bad, then Good |
| CONSIDER | Conditional option; explain when it helps | Good, then Bad |

**Good**

```text
SKILL.md
  Frontmatter: name and task-specific description
  Purpose and scope
  Reading guide: keyword meanings and relevant-reference selection
  Reference index: paths and when to read each one
references/
  Topic-specific guidance and examples
```

**Bad**

```text
SKILL.md
  Vague scope: "Use for all development"
  All detailed guidance copied from every reference
  Instruction to read every file for every task
```

### DO give each reference a discoverable index entry

Link every reference from `SKILL.md` with a relative path and a short explanation of when it applies.
Use descriptive labels. A reference may link to another relevant reference instead of duplicating its
rules. Update callers when renaming or deleting a reference and verify the links still resolve.

**Good**

```markdown
- [Localization](references/localization.md)

  Use for ARB naming, translator context, and message reuse.
```

**Bad**

```text
Add references/localization.md but provide no index entry or explanation of when to read it.
```

## Reference Content

### DO organize references around concrete decisions

Start with a title and one sentence defining the reference's scope. Group related rules under
section headings when useful. Each rule uses a `###` heading beginning with DO, DON'T, PREFER, AVOID,
or CONSIDER, followed by its rationale, scope, and paired examples.

Explain what changes the implementation decision. Do not inflate the guide with generic advice or
split one distinction across several repetitive rules. Choose the keyword's strength deliberately;
a context-dependent preference is not a universal prohibition.

**Good**

```text
### DO let each View own its AppBar
Explain how page-specific titles and actions stay with the screen.
Good: View owns AppBar; layout owns navigation
Bad: layout switches page-specific actions by selected index
```

**Bad**

```text
### DO write good code
Explain that code should be good.
Good: good implementation
Bad: bad implementation
```

### DO order contrasting examples according to the directive

Every rule includes both **Good** and **Bad**, each followed by a fenced example. For DO, PREFER, and
CONSIDER, show Good first. For DON'T and AVOID, show Bad first. Put the explanation before the examples
so changing example order does not separate a caveat from the behavior it qualifies.

Examples should differ on the rule being taught, not on unrelated details. Prefer actual Dart, Rust, or ARB
excerpts; use shell, configuration, Markdown, or text flows where they communicate the distinction
better. Label schematic or partial examples. A Bad example for a conditional rule must show the
condition that makes it unsuitable, not condemn every alternative.

**Good**

```text
DO describe each template ARB message
  Good: message plus contextual description
  Bad: ambiguous message key without metadata

DON'T hand-edit generated bridge bindings
  Bad: patch generated output to hide an API mismatch
  Good: update the source API and regenerate bindings
```

**Bad**

```text
DON'T hand-edit generated bridge bindings
  Good: shown first despite the negative directive
  Bad: omitted because the prohibition "seems obvious"
```

### DON'T turn a past cleanup into a permanent ban

A removed helper, DTO, or wrapper may have been unnecessary in that implementation without being an
invalid design in general. State the reusable decision and its conditions instead. Distinguish
current examples from proposed designs; do not present an unimplemented API as existing behavior.

**Bad**

```text
A divider was removed from the main layout.
Therefore: never use dividers anywhere in the app.
```

**Good**

```text
Choose visual separation based on the surrounding content.
The current main layout uses spacing; other screens may benefit from a divider.
```

## Maintenance

### DO preserve design decisions when updating examples

Compare the existing rule, its Git history, and the current implementation before removing it.
Separate deliberate design changes from obsolete API spelling or examples. Update stale examples
while retaining still-valid intent, and consolidate duplicates without dropping their exceptions or
rationale. Previously agreed removals should not reappear just because an older version contained them.

Verify scope, directive strength, example order, API accuracy, code fences, and reference links.
Use the skill validator when available; format validation does not establish that the guidance is
correct. Summarize substantive removals and changes so they can be reviewed.

**Good**

```text
Old example uses accountsTitle for navigation and the page title.
Check current ARB -> use navigationAccountLabel and accountListTitle.
Preserve the decision to separate messages with distinct purposes.
```

**Bad**

```text
Old example uses accountsTitle.
Rewrite the guide -> merge navigation and page-title messages because their English text matches.
```
