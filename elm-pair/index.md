# Elm-pair

Elm-pair helps you write Elm code. You tell Elm-pair about the change you want
to make, and it will do the actual work. It's a bit like using an IDE, except
you don't need to learn any keyboard shortcuts.

You talk to Elm-pair by saving a file in your project. Elm-pair will notice the change you made since you last saved, and if it understands your intent will respond with a change off its own.

To explain what working with Elm-pair is like its easiest to show you some examples. In the recordings below we use the terminal editor Vim, but Elm-pair runs on any editor that supports the editor-driver protocol.

## Examples

### Changing names

Change the name of a function, let binding, type, constructor or field and save your file. Elm-pair will rename all other uses of the name across your entire project.

- rename-record-field.cast
- rename-type.cast

### Working with imports

Use a qualified name in your code and Elm-pair will automatically add an import statement if necessary.

- add import.cast

Remove the qualifier in front of a name and Elm-pair will automatically add it to the `exposing` clause of an import.

- unqualify-import.cast

Elm-pair will automatically remove unused imports.

- remove-unnecessary-imports.cast

### Adding or removing function arguments

Change a function to take another argument and Elm-pair will put placeholder values anywhere you call the function across your project.

- add-argument.cast

Remove an unused argument from a function and Elm-pair will stop passing a value for it anywhere you call the function. Should this result in other functions with an unused argument Elm-pair will remove the argument from them too, and keeping going until there's no more unused arguments left.

- remove-unused-argument.cast

### Extracting and inlining functions

Remove a let binding and Elm-pair will insert the body of the binding in all places using it.

- inline-let.cast

Move a let binding to the root of a module and Elm-pair will add extra arguments if necessary. Move a function to a let binding and Elm-pair will remove arguments. You can also move let bindings from one let statement to another and Elm-pair will update its arguments accordingly.

- extract-from-let.cast

Replace an expression in a function body with a name and Elm-pair will create a let binding with that name, with the expression as its body.

- extract-into-let.cast

### Working with types

Replace a primitive type in a type signature with a named type and Elm-pair will create a type alias with that name.

- alias-to-wrapper-type.cast

Remove the `alias` from a `type alias` and Elm-pair will turn it into a wrapper type.

- create-type-alias.cast

Add or remove fields to a record and Elm-pair will automatically update all uses of the record.

- add-record-field.cast

## Will Elm-pair break my code?

You might worry about Elm-pair breaking your code, requiring you to clean up after it. That could cost you more time than you save!

To prevent mistakes Elm-pair responds to a change you make with a change off its own if your Elm project compiles afterwards. If Elm-pair cannot make a change that will get your project to compile it will do nothing.

This makes Elm-pair the perfect companion for 'type driven development'. This style of programming is about taking small steps, ensuring your code compiles after each step. If you dislike this style of programming Elm-pair might not be the right tool for you.
