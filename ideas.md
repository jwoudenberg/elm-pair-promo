# Editor driver

Core idea: instead of a 'language server' called by an editor, we'd prefer an 'editor driver' called by a 'language daemon'.
This solves the same idea that a language server does: Writing language tools once for all editors.
It has these benefits over the language server approach:

- Respond reactively to changes to files (file watching), instead of waiting for the user to initiate something by pressing a hotkey or selection a menu option.
- Languages can define any 'operation' that make sense for that language, and don't need to limit themselves to operations defined in some 'language server API'.
- Support for polyglot projects. Multiple language daemons or build daemons or build systems can steer the editor. Not possible in a language server, which will not be able to understand how changes in one file fill affect files written in other languages.

## Editor driver commands

- Move cursor
- Change file (maybe do this directly?)
- Anotate code
- Set list of errors (each error has code location)

## Examples in Elm

The following 'refactors' should happen automatically when the code compiles before and after the automatic change.
Motivation:

- We only run automatic refactors when the code compiles before a change, to not bother the user if they're in the middle of a manual refactor.
- We only apply a refactor if the code compiles after the change, as a sanity check that we understood the user correctly.

### Renames

Renaming a top level function, record field, type name, or constructor name in a project that compiles will automatically rename every use of that name in all other code.

### Extracting into let binding

Replacing an expression with a name will extract that expression into a let binding with that name.

```elm
-- Take this:
percent part whole = 100 * part / whole

-- Change it to this:
percent part whole = 100 * fraction

-- Will be turned into this:
percent part whole =
  let
    fraction = part / whole
  in
  100 * fraction
```

### Moving from a let binding to a higher scope (other let binding or top level)

Moving a let binding to a higher scope will add additional arguments for values not in scope at that higher level.

```elm
-- Take this:
percent part whole =
  let
    fraction = part / whole
  in
  100 * fraction

-- Change it to this:
percent part whole =
  let
  in
  100 * fraction

fraction = part / whole

-- Will be turned into this:
percent part whole =
  100 * (fraction part whole)

fraction part whole =
  part / whole
```

### Change argument order

Moving the arguments of a function around (either types or arguments themselves), applies the argument reorder change everywhere else.

### Inlining

Removing a definition (top level or let binding) inlines it in every location it is used.

### Adding import

Using a qualified function from a module not yet imported will add that module to the list of imports.
Example: use `List.Extra.flibble` somewhere, and `import List.Extra` will be added to the imports if it hasn't already.

### Exposing a value from an import

Removeing the qualifier from an import will cause the definition to be exposed directly.

```elm
-- Take this:
import List.Extra
foo = List.Extra.flibble

-- Change it to this:
import List.Extra
foo = flibble

-- Will be turned into this:
import List.Extra exposing (flibble)
foo = flibble
```

### Removing an import

Imports will be removed automatically when they are no longer used.

### Adding an argument

All the places calling the function that has the additional argument pass a `Debug.todo "new argument"` in its position.

### Removing an argument

All places calling the function stop passing the argument

### Making a record out of a tuple

All places using the tuple are modified to accept a record instead.

This is a good example of an operation that is language specific!

### Removing a type alias

The places using the alias use the unaliased type instead

### Adding a type alias

Places already importing the module that defines the alias will start using it wherever the unaliased type shows up in functions.

### Adding a field to a record

Places that constructor the record add the field with a placeholder value of `Debug.todo "new field"`

### Make up helper

When writing a piece of code with a made up helper function, that helper function gets created on the top level, with a function signatures, and an implementation mocked out using `Debug.todo "new helper"`
