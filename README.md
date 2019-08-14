[![Netlify Status](https://api.netlify.com/api/v1/badges/21cfeac6-cf5a-48d0-8605-9c2ca52fd99b/deploy-status)](https://app.netlify.com/sites/elm-pair/deploys)

# Improving on language servers

Language servers are great, but we can do so much better. A language server is a program that knows a bunch of tricks for working with a programming language. Say you want to rename a variable in a project. You click in a menu or press a hotkey to send the instruction to your editor, and then your editor can delegate the work to a language server.

Here is what make language servers great: they work with any editor, and so we don't need to write a separate plugins for Atom, VSCode, Sublime, Vim, Emacs, etc. Instead we can write a single language server, make it great, and then all editors can enjoy great editing support!

To create a language server for a programming language you implement part of its protocol. The language server protocol defines different things a programmer might want to do, like renaming a variable. Language servers don't need to implement the entire protocol because some tricks don't make sense in some languages.

## Shortcomings

As great as I think language servers are there's things about them I like less. One is that presenting all that language server functionality to a programmer requires a lot of menu space, or a lot of hotkeys. Either way the programmer will need to memorize a lot to use the language server effectively. I don't much care for this because my memory isn't great.

A bigger disappointment for me is that the language server protocol shines in supporting common programming language tricks. Things like renaming a variable, something you can in most programming languages. It's the properties that make a programming language unique I find most interesting though, but these the language server protocol is unlikely to have support for. That's a bummer. I want language tooling to shine where the language shines!

## An abstraction facing the wrong way

The language service protocol is an abstraction. Abstractions are like shady figures in alleyways trying to sell you something. This one is saying: "Psst, did you know all programming languages are the same? You just need to know that in a programming language you can rename variables, and these other things, and that's all there is to know about programming languages." We know that statement isn't true, programming languages have big differences! But there is value in pretending they are the same because it makes writing editor tooling easier.

Here's another abstraction: "Hey you, let me tell you, all editors are the same! You can open files in them and then change the contents of those files. That's it!". Another false statement because as we know editors do in fact have differences. But I'd argue those differences are smaller than the differences between programming languages, and that offers exciting possibilities!

Let's recall that language servers are about being able to write tooling for a language once, and then being able to use this tooling in all editors. It does this by abstracting programming languages. What if we'd abstract editors instead?

## Editor drivers

In this model the language server listens to the editor. It gets notified whenever a programmer does something in an editor, like saving a file. It can then choose to take action, for example by making changes to a file itself. An 'editor driver protocol' defines what events language servers can listen too and what actions they can take in response. This replaces the 'language server protocol' which we no longer need.

Let's look at what variable renaming might look like in this system. To start a rename the programmer changes any use of a variable in the program and saves. The language server receives an event with the change the programmer made. It sees the programmer renamed a variable in one place, and acts on this by performing the same rename for all the other uses of the variable.

## What did we gain?

Let's consider how this alternative take on language servers compares to the original. The first question is whether we can still write a language server once and reuse it across editors. The answer to that is yes: our language server will now need to know about specific editors, just the editor driver protocol. Our editors will need to support it, but they already need to support the language server protocol now. We're one for one.

The first language server protocol shortcoming I called out was that it required programmers to be familiar with a bunch of menus or hotkeys. The editor server protocol allows us to build nicer interactions. In the example above the user doesn't need to go through any menu or click any key to rename a variable. They kick off the change by writing code and then the language server finishes it. The programmer can discover the renaming functionality as a natural part of their work.

The second LSP shortcoming I raised was that the language server protocol does not support tricks related to the properties that make a programming language unique. The editor-driven approach doesn't have this limitation. There's no limits to the language-specific functionality it can support. For some examples of language-specific tooling functionality check out this proposal for [elm-pair], an Elm language server based on the editor driver approach!

There's downsides too. In the variable rename example there's a natural hook that triggers the language server: it's the programmer changing the name of the variable in one place. There might not be a good hook for every trick a language server might want to support. A language server that doesn't guess the programmers intent will be annoying rather than helpful. The bar for good language server design is higher when using the editor driver approach.

Another downside is that we're now abstracting editors. Whereas in the old approach we had trouble supporting language-specific features, now we have trouble supporting editor-specific features. VIM for example has editor modes. A language server protocol implementation for VIM might under circumstances change the mode the editor is in. The editor driver protocol will not know about changing modes, because most editors won't be able to support it.

## Conclusion

Language servers enable us to write programming tooling once for all editors. We can improve on the concept by abstracting editors rather than programming languages. This results in new design challenges, but when overcome allows creation of delightful tooling that is discoverable and supports each language's strengths.

[elm-pair]: https://elm-pair.jasperwoudenberg.com/
