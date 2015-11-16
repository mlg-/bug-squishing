# Bug Squishing
**Some thoughts on problem decomposition and debugging.**


## Introduction
Problem decomposition and debugging in Ruby are made more straightforward thanks to the very beautiful and developer-friendly syntax of the language, coupled with nice tools for inspecting issues during code execution [like Pry](http://pryrepl.org/). You may also find extensions to Pry like [Pry Nav](https://github.com/nixme/pry-nav) or [Pry Byebug](https://github.com/deivid-rodriguez/pry-byebug) useful for particularly thorny issues.

# Strategies for Problem Decomposition

## Make a Plan: Pseduo code and doodling FTW

### Make a list

Let's say I want to write a program to model a library. Rather than diving in and starting to write out a class definition of a `Book`, I should step back and first make a list of all the classes I'll need to model a library. Maybe I'll need books, shelves, categories, and patrons. Starting out with an idea of where you're going sounds like a basic step, but it's easy to think the problem is "straight forward" and begin coding, only to realize you aren't sure what you need or where to go next. Make a list of all your objects and take it from there.

## Pseudo code!

Formally, pseudo code is the expression of an algorithm's logical process in plain English. However, we can adapt the idea of pseudo-code to any method we are attempting to write. Pseudo code is just writing the logical instructions you want the computer to follow, but in plain English. It's a good way to step through the functionality you want your methods to produce without needing to get in the weeds with implementation details in your language of choice right off the bat. It's a *recipe* for what it will take to produce the return value you want, including the steps you think you'll need and what you'll need data-wise to achieve that.

For example, let's say I'm writing a program that analyzes people's emails in order to make decisions about their communication style. I want to count the number of words in each email as one metric that assesses them on a scale from terse to verbose based on the average over time compared with other users. A first draft of the method to do that (in pseudo code) might look something like this:

```
initialize a counter for the number of emails analyzed
initialize a counter for the total number of words
get all the user's emails, go through each one
add the word count to the total number of words
increment the number of emails counter

divide the number of words total by the number of emails counter
```

Writing it out this way produces plenty of opportunities for re-factoring. I probably just realized that I could do this more efficiently by collecting the number of emails from the array or other data structure they are stored in (using `count` or `size` or `length`, etc). Pseudo code is a good way of nailing down what you want to achieve before you begin.

Finally, doodling is your friend, too! If you are a visual person, it can be helpful to draw a picture or diagram of what you are trying to do. Whiteboarding, doodling, etc are all good ways to get some tactile engagement with your planning process, and they are more amenable to visualization and easy modification.

## A (very) brief interlude about testing (just do it)

A test is another great way to nail down what you are trying to do. If you know what objects you need, you can write tests to help you decide how they should behave or what their methods should produce.

Further, why would you manually test your code again and again to see if your methods work when a test could handle this tedious process for you?! Good programmers are a little lazy, and they don't do work the computer can do for them.

Finally, tests also give you more feedback about what's wrong or let you know when you re-factored some code or added a new method and totally broke everything in the process. Oops.

# Strategies for Debugging

## Rubber Ducky, you're the one...you make debugging lots of f--well, less terrible

[Rubber Duck debugging](https://en.wikipedia.org/wiki/Rubber_duck_debugging) is a programming concept that presumes you do not actually need help from another human a lot of the time to debug your code. You just need someone to talk to (aww, don't we all.) The process goes something like this:

1. Procure inanimate object
2. Tell it about your code (and your feelings too, if necessary)
3. Become great

## The stack trace does not lie

!["Read the stack trace, Luke."](/images/luke.png)
!["A sad tip"](/images/sadtip.png)
!["Not being a baddy"](/images/baddy.png)
!["trololol"](/images/trololol.png)

Okay, you get the picture. You have to read the damn [stack trace](https://en.wikipedia.org/wiki/Stack_trace). But how, you ask?!

Here's an example:

```
/Users/mlg/cf/bug-squishing/hello-world/lib/greeting.rb:12:in `say_greeting': undefined local variable or method `hello_word' for main:Object (NameError)
  from /Users/mlg/cf/bug-squishing/hello-world/spec/hello_world_spec.rb:1:in `require_relative'
  from /Users/mlg/cf/bug-squishing/hello-world/spec/hello_world_spec.rb:1:in `<top (required)>'
  from /Users/mlg/.gem/ruby/2.0.0/gems/rspec-core-3.3.2/lib/rspec/core/configuration.rb:1327:in `load'
  from /Users/mlg/.gem/ruby/2.0.0/gems/rspec-core-3.3.2/lib/rspec/core/configuration.rb:1327:in `block in load_spec_files'
  from /Users/mlg/.gem/ruby/2.0.0/gems/rspec-core-3.3.2/lib/rspec/core/configuration.rb:1325:in `each'
  from /Users/mlg/.gem/ruby/2.0.0/gems/rspec-core-3.3.2/lib/rspec/core/configuration.rb:1325:in `load_spec_files'
  from /Users/mlg/.gem/ruby/2.0.0/gems/rspec-core-3.3.2/lib/rspec/core/runner.rb:102:in `setup'
  from /Users/mlg/.gem/ruby/2.0.0/gems/rspec-core-3.3.2/lib/rspec/core/runner.rb:88:in `run'
  from /Users/mlg/.gem/ruby/2.0.0/gems/rspec-core-3.3.2/lib/rspec/core/runner.rb:73:in `run'
  from /Users/mlg/.gem/ruby/2.0.0/gems/rspec-core-3.3.2/lib/rspec/core/runner.rb:41:in `invoke'
  from /Users/mlg/.gem/ruby/2.0.0/gems/rspec-core-3.3.2/exe/rspec:4:in `<top (required)>'
  from /Users/mlg/.gem/ruby/2.0.0/bin/rspec:23:in `load'
  from /Users/mlg/.gem/ruby/2.0.0/bin/rspec:23:in `<main>'
  from /Users/mlg/.gem/ruby/2.0.0/bin/ruby_executable_hooks:15:in `eval'
  from /Users/mlg/.gem/ruby/2.0.0/bin/ruby_executable_hooks:15:in `<main>'
```

!["Stack trace diagram"](/images/stacktracebigthree.png)

Let's break down how to read this, top to bottom:

1. `/Users/mlg/cf/bug-squishing/hello-world/lib/greeting.rb:12` : this part says, hey, the error in your file is occurring on line 12 of a file called `greeting.rb`, and here is the full path to that file.

2. `:in say_greeting` : this is the specific method where everything is blowing up.

3. `undefined local variable or method `hello_word'` : this is *actual error message* that specifically says what the Ruby interpreter is all worked up about. We'll talk about some common errors in a minute.

4. `main:Object` : this is the class name that's involved.

5. `(NameError)` : this is the name of the exception.

6. Every line thereafter is where your error originated from, all the way down into the guts of the Ruby Standard Library.

The first thing you should do is read that first line carefully, and then follow it back to the line and method that it indicates are problematic. Take a moment to assess the code there and use the specific error message to give you a suggestion about what's going on.

For example...

`NoMethod`: You're trying to call a method that doesn't exist, that you've misspelled, *or* you're trying to call a method on `nil` (which, technically, is a method that doesn't exist since `nil` has no methods, but that's neither here nor there).


## Beast-mode uses of Pry

Pry is your friend. The best piece of advice regarding use `pry` that I have is this: Throw a `binding.pry` on the line before things blow up. That line can be before the `expect` statement in the test, it can be on the line before you get an error in your ruby file, whatever, but put it in there.



## Google Fu

## Just write the damn code (Red, Green, Refactor)

## Asking for help online

##


