# Improving language servers

Language servers are great, but we can do better. A language server is a program that knows a bunch of tricks for working with a programming language. Say you want to rename a variable in a project. You click in a menu or press a hotkey to send the instruction to your editor, and then your editor can delegate the work to a language server.

The great thing about language servers is that they offer an alternative to writing separate language plugins for Atom, VSCode, Sublime, Vim, Emacs, and every other editor out there. Instead we can have a single language server for a programming language, make it great, and have support for that language in all editors!

To create a language server for a programming language you implement part of the 'language server protocol'. This protocol defines different tricks a programmer might perform like renaming a variable. Language servers don't need to implement the entire protocol because not all tricks make sense in all languages.

## Shortcomings

As great think language servers are there are things about them I like less. One is that presenting all that language server functionality to a programmer requires a lot of menu space, or a lot of hotkeys. Either way the programmer will need a good memory to remember how to trigger each trick available, and my memory isn't great.

A bigger disappointment for me is that the language server protocol shines in supporting common programming language tricks. Renaming a variable is an example of such a common trick, because we perform it in almost any programming language. A language's unique features are unlikely to have language server protocol support, which I think is a shame. I want my language tooling to shine where the language itself shines!

## An abstraction facing the wrong way

The language service protocol is an abstraction. Abstractions are like shady figures in alleyways trying to sell you something. This one is saying: "Psst, did you know all programming languages are the same? There's these same few tricks they support." We know that statement isn't true, programming languages have big differences! Language servers are a good example of how the abstraction, despite being a lie, can still be useful.

Here's another abstraction: "Hey you, get this, all editors are the same! You can open files in them and then change the contents of those files. That's it!". Another false statement as indicated by sometimes heated exchanges over which editor is the best. Still, I'd argue differences between editors are smaller than the differences between programming languages. Let's put that thought to work.

Recall that language servers are about being able to write tooling for a language once, and then being able to use this tooling in all editors. It does this by abstracting programming languages. What if we'd abstract editors instead?

## Editor drivers

To create a protocol that abstracts editors rather than programming languages, the editor and language server need to talk a different language, one that doesn't use programming language terms. First the editor should send the language server a notification when the user does something interesting, like saving a file or hovering over a particular row and column. The language server can then choose to respond by sending the editor an instruction, like changing a file or moving the cursor.

We'll call the notifications and requests editors support the 'editor driver protocol', because they enable an external program to drive the editor. The external program doesn't need to know which editor precisely it's driving, that's our editor abstraction at work. This 'editor driver protocol' could replace the 'language server protocol' we use today.

Let's look at what variable renaming might look like in this system. To start a rename the programmer changes any use of a variable in the program and saves. The language server receives a notification with the change the programmer made. It sees the programmer renamed a variable in one place, and acts on this by performing the same rename for all the other uses of the variable.

## Improvement or not?

Let's consider how this alternative take on language servers compares to the original. The first question is whether we can still write a language server once and reuse it across editors. The answer to that is yes: our language server will communicate with any editor using a standardized protocol, just like it does now.

The first language server protocol shortcoming I called out was that it required programmers to be familiar with a bunch of menus or hotkeys. The editor driver protocol addresses this and allows us to build nicer interactions. In the example we saw the user could perform a rename without clicking 'rename' in any menu or needing to use a hotkey. They just started making a change and then the language server finished it. The programmer could have discover the renaming functionality as a natural part of their work.

The second language server protocol shortcoming I raised was that the language server protocol does not support tricks related to the properties that make a programming language unique. The editor driver approach doesn't have this limitation. It can answer language-specific queries and perform language-specific refactors. For some examples of language-specific tooling functionality check out the proposal for [elm-pair], an Elm language server based on the editor driver approach.

There's downsides too. In the variable rename example there's a natural hook that triggers the language server: it's the programmer changing the name of the variable in one place. There might not be a good hook for every trick a language server might want to support. A language server that misinterprets the programmers intent will be annoying rather than helpful. The bar for good language server design is higher when using the editor driver approach.

Another downside is that we're now abstracting editors. Whereas in the old approach we had trouble supporting language-specific features, now we have trouble supporting editor-specific features. The editor VIM for example supports different modes. A language server protocol implementation for VIM might under circumstances change the mode the editor is in, but an editor driver protocol implementation will not support functionality so specific to one editor.

## Conclusion

Language servers enable us to write programming tooling once for all editors. We can improve on the concept by abstracting editors rather than programming languages. This results in new design challenges, but when overcome allows creation of delightful tooling that is discoverable and plays to each language's strengths.

[elm-pair]: https://elm-pair.jasperwoudenberg.com/
