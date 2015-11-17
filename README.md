# Bug Squishing
**Some thoughts on problem decomposition and debugging.**

## Introduction
Problem decomposition and debugging are skills that every developer needs to progress from beginner to competent professional. When coupled with the ability to read and implement documentation, they form the cornerstone of skills that separate a developer from a layperson, and they are often are just an extension and refinement of what people consider to be "magical" about "people who are good with computers."

# First: Strategies for Problem Decomposition

## Make a Plan: Pseduocode and Doodling FTW

### Make a List

Let's say I want to write a program to model a library. Rather than diving in and starting to write out a class definition of a `Book`, I should step back and first make a list of all the classes I'll need to model a library. Maybe I'll need books, shelves, categories, and patrons. Starting out with an idea of where you're going sounds like a basic step, but it's easy to think the problem is "straight forward" and begin coding, only to realize you aren't sure what you need or where to go next. Make a list of all your objects and take it from there.

## Pseudocode!

Formally, pseudocode is the expression of an algorithm's logical process in plain English. However, we can adapt the idea of pseudocode to any method we are attempting to write. Pseudocode is just writing the logical instructions you want the computer to follow, but in plain English. It's a good way to step through the functionality you want your methods to produce without needing to get in the weeds with implementation details in your language of choice right off the bat. It's a *recipe* for what it will take to produce the return value you want, including the steps you think you'll need and what you'll need data-wise to achieve that.

For example, let's say I'm writing a program that analyzes people's emails in order to make decisions about their communication style. I want to count the number of words in each email as one metric that assesses them on a scale from terse to verbose based on the average over time compared with other users. A first draft of the method to do that (in pseudocode) might look something like this:

```
initialize a counter for the number of emails analyzed
initialize a counter for the total number of words
get all the user's emails, go through each one
add the word count to the total number of words
increment the number of emails counter

divide the number of words total by the number of emails counter
```

Writing it out this way produces plenty of opportunities for re-factoring. I probably just realized that I could do this more efficiently by collecting the number of emails from the array or other data structure they are stored in (using `count` or `size` or `length`, etc). Pseudocode is a good way of nailing down what you want to achieve before you begin.

Finally, doodling is your friend, too! If you are a visual person, it can be helpful to draw a picture or diagram of what you are trying to do. Whiteboarding, doodling, etc are all good ways to get some tactile engagement with your planning process, and they are more amenable to visualization and easy modification.

## A (very) Brief Interlude About Testing (just do it)

A test is another great way to nail down what you are trying to do. If you know what objects you need, you can write tests to help you decide how they should behave or what their methods should produce.

Further, why would you manually test your code again and again to see if your methods work when a test could handle this tedious process for you?! Good programmers are a little lazy, and they don't do work the computer can do for them.

Finally, tests also give you more feedback about what's wrong or let you know when you re-factored some code or added a new method and totally broke everything in the process. Oops.

# Strategies for Debugging

## "Rubber Ducky, you're the one...you make debugging lots of f"--well, less terrible

[Rubber Duck debugging](https://en.wikipedia.org/wiki/Rubber_duck_debugging) is a programming concept that presumes you do not actually need help from another human a lot of the time to debug your code. You just need someone to talk to (aww, don't we all.) The process goes something like this:

1. Procure inanimate object
2. Tell it about your code (and your feelings too, if necessary)
3. Become great

## The Stack Trace Does Not Lie

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

**Note**: When running `rake`, you may need to scan down a line or two to get the relevant error. Here's an example where running `rake` is showing you all the directories where your `Rakefile` is trying to find `_spec` files, and *then* the error is shown:

```
Users/sean/.rubies/ruby-2.0.0-p576/bin/ruby -I/Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/lib:/Users/sean/.gem/ruby/2.0.0/gems/rspec-support-3.2.1/lib /Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/exe/rspec --pattern spec/\*\*\{,/\*/\*\*\}/\*_spec.rb
/Users/sean/.gem/ruby/2.0.0/gems/activesupport-4.0.4/lib/active_support/dependencies.rb:229:in `require': cannot load such file -- view details for a TV show with missing information (LoadError)
  from /Users/sean/.gem/ruby/2.0.0/gems/activesupport-4.0.4/lib/active_support/dependencies.rb:229:in `block in require'
  from /Users/sean/.gem/ruby/2.0.0/gems/activesupport-4.0.4/lib/active_support/dependencies.rb:214:in `load_dependency'
  from /Users/sean/.gem/ruby/2.0.0/gems/activesupport-4.0.4/lib/active_support/dependencies.rb:229:in `require'
  from /Users/sean/challenges/tv-shows-sinatra/spec/features/view_tv_shows_spec.rb:54:in `block in <top (required)>'
  from /Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/lib/rspec/core/example_group.rb:363:in `module_exec'
  from /Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/lib/rspec/core/example_group.rb:363:in `subclass'
  from /Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/lib/rspec/core/example_group.rb:253:in `block in define_example_group_method'
  from /Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/lib/rspec/core/dsl.rb:43:in `block in expose_example_group_alias'
  from /Users/sean/.gem/ruby/2.0.0/gems/capybara-2.3.0/lib/capybara/rspec/features.rb:25:in `feature'
  from /Users/sean/challenges/tv-shows-sinatra/spec/features/view_tv_shows_spec.rb:2:in `<top (required)>'
  from /Users/sean/.gem/ruby/2.0.0/gems/activesupport-4.0.4/lib/active_support/dependencies.rb:223:in `load'
  from /Users/sean/.gem/ruby/2.0.0/gems/activesupport-4.0.4/lib/active_support/dependencies.rb:223:in `block in load'
  from /Users/sean/.gem/ruby/2.0.0/gems/activesupport-4.0.4/lib/active_support/dependencies.rb:214:in `load_dependency'
  from /Users/sean/.gem/ruby/2.0.0/gems/activesupport-4.0.4/lib/active_support/dependencies.rb:223:in `load'
  from /Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/lib/rspec/core/configuration.rb:1226:in `block in load_spec_files'
  from /Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/lib/rspec/core/configuration.rb:1224:in `each'
  from /Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/lib/rspec/core/configuration.rb:1224:in `load_spec_files'
  from /Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/lib/rspec/core/runner.rb:97:in `setup'
  from /Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/lib/rspec/core/runner.rb:85:in `run'
  from /Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/lib/rspec/core/runner.rb:70:in `run'
  from /Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/lib/rspec/core/runner.rb:38:in `invoke'
  from /Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/exe/rspec:4:in `<main>'
/Users/sean/.rubies/ruby-2.0.0-p576/bin/ruby -I/Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/lib:/Users/sean/.gem/ruby/2.0.0/gems/rspec-support-3.2.1/lib /Users/sean/.gem/ruby/2.0.0/gems/rspec-core-3.2.0/exe/rspec --pattern spec/\*\*\{,/\*/\*\*\}/\*_spec.rb failed

```

Now back to your regularly scheduled programming!

## If I have to read the stack trace, how do I understand the errors listed?

Some common Ruby errors:

`NameError`: You're trying to call something that is spelled wrong or plain old doesn't exist. Did you forget to capitalize your class name? Did you misspell the name of the method you actually want?

`NoMethod`: You're trying to call a method that isn't available or doesn't exist for the given variable. Usually this is because you think your variable is a string or an integer or an array...but it's actually `nil`. Nil has very few methods available to it, compared to most other ruby data types.

`LoadError`: You're trying to call a file from the wrong place. Or it doesn't exist yet. Or it's in a different folder than you think it is. Or you misspelled its name.

`ArgumentError`: You're trying to give a method too many arguments...or too few. Check out the numbers to help clear things up: `(0 for 1)` means one argument is required and you aren't passing it. `(2 for 1)` means you're passing two and it only takes one!

'TypeError': You're trying to do something with an integer that you can only do with a string. Or any other data type mismatch. i.e.: `[1, 2, 3].first("two")`.


## Sanity check *everything*

Checking your assumptions is ground zero for problems that seem weird, magical, and/or completely nonsensical. Did you save the same file in multiple places in your text editor? Are you running two tabs in your terminal, or another window altogether that is conflicting with the code you're trying to run now? Did you save the changes to the file you are working on?

## Beast-mode uses of Pry

!["Pry logo"](/images/pry.png)

Debugging in Ruby is made more straightforward thanks to the very beautiful and developer-friendly syntax of the language, coupled with nice tools for inspecting issues during code execution [like Pry](http://pryrepl.org/).

Pry is your friend. The best piece of advice regarding use `pry` that I have is this: Throw a `binding.pry` on the line *before* things blow up. That line can be before the `expect` statement in the test, it can be on the line before you get an error in your `.rb` file, whatever, but put it in there. Then re-run your code. Now go to your terminal and poke around! What the *actual* values of your variables?

*Side Note* : It's really important to understand the Pry is not "training wheels." Professionals use debugging tools like this every day, many times a day, and they validate their assumptions about what is actually occurring at the time their code is run. You should not resist it because you think you *should know* what's happening! You don't, and we don't either, and that's why we both need it.

You can also learn how to take Pry a step further into power user territory with extensions like [Pry Nav](https://github.com/nixme/pry-nav) or [Pry Byebug](https://github.com/deivid-rodriguez/pry-byebug). The extensions above will allow you `step` through your code, including the parts where it interacts with the Ruby core library. When you stop execution, simply use `step` at the pry prompt to step through to wherever your method was called from. `Step` can optionally accept an integer as an argument, which will step you multiple times.

Pry itself also has a ton of power-user functionality right out of the box. For example, want to know what all the available variables and classes are within your current scope? Call `ls` when paused in `pry`. Just like `ls` lists the files and folders in your current directory in the Terminal, it will tell you the same about your variables.

Like so:

```
pry(#<Greeting>)> ls
Greeting#methods: hello_world
instance variables: @user
locals: _  __  _dir_  _ex_  _file_  _in_  _out_  _pry_
```

If you've moved past a method that is available in your scope, you can view it by using the `show-method` keyword:

```
pry(#<Greeting>)> show-method hello_world

From: /Users/mlg/cf/bug-squishing/hello-world/lib/greeting.rb @ line 10:
Owner: Greeting
Visibility: public
Number of lines: 4

def hello_world
  binding.pry
  "Hello World"
end
```

All of this stuff is great, but `binding.pry` is a workhorse that will not let you down and is dead-simple to start leveraging (get! it!). Use it early and often!

Other things to try in Pry (that aren't necessarily *because of* Pry) are calling `.class` and `.methods` on your variables to make sure you understand what you are working with.

Pry has many more features than make sense to discuss here, and I highly recommend [perusing the docs](https://github.com/pry/pry). Who knows, maybe even many months down the road you'll be ready to [contribute](https://github.com/pry/pry/issues) to Pry! ;)

## Isolate variables and move slowly

If you've checked all your assumptions and performed multiple sanity checks and even used Pry to no avail, you should start removing code. Slowly! The worst thing you could do is to delete 25 lines and then have things start working again. Which line was actually the problem in that scenario?! Isolate variables and only change ONE thing at a time when trying to figure out where the problem is. If you comment out code, the same logic applies.

Another way to achieve the same result is to comment out a lot of code until things start to work, and then slowly add things back in until you discover what caused the issue in the first place. In any event, you should be able to point to a line that is problematic, and you can *only* do this by approaching the issue in a scientific manner that isolates potential troublemakers.

## Google Fu

### What to paste into Google, and some basic search operators

When pasting an error into Google, avoid pasting too much text. Pick part of the file path where an error is occurring that will be common to search results of the problem on another user's machine where the error is occurring. Avoid timestamps, your user name on your computer, and other information that's irrelevant and could skew the results in a nonsensical direction. For example, when debugging this error in the Terminal:

```
ruby server.rb
/Users/Michelle/.gem/ruby/2.0.0/gems/puma-2.13.4/lib/puma/puma_http11.bundle: [BUG] Segmentation fault
ruby 2.0.0p598 (2014-11-13) [x86_64-darwin14.1.0]
```

I pasted this into Google:

```
[BUG] Segmentation fault ruby 2.0.0p598 (2014-11-13) puma
```

This turned up some results that suggested Puma might have been installed incorrectly or corrupted along the way. So the solution wound up being to run a more recent version of Ruby, re-install the Puma gem, and move forward.

Taking Google to the next step involves using some of its [search operators](https://support.google.com/websearch/answer/2466433?hl=en) to get exactly what you want. A couple ideas:

- Putting words in quotes means that only their exact matches will turn up. Great for searches with generic terms that aren't relevant unless in a particular order, i.e. `"xcrun: error: invalid active developer path"`
- Getting irrelevant results? Filter them out with the `-` minus sign. You can use this for keywords or whole sites: `An error occurred while installing nokogiri (1.6.2.1) -site:wikipedia -saw`.
- Want *just* StackOverflow and Github results? You can do that: `Error installing pry-debugger site:stackoverflow.com, site:github.com`


### Evaluating your results

So, let's say you've Googled your issue. There's a zillion results, and the first four are from a blog, StackOverflow, a github thread, and another StackOverflow result. Here are some things to consider:

- StackOverflow is a good resource, but be sure to evaluate the results carefully. Note the date that a given page was published in the Google search results (you can even sort them so that you only see results from the past year), and bias towards more recent questions.
- A Github thread may have information about the bug you're encountering when it was emergent. Use `Command + F` to find the relevant portion of the page and skim through the chatter. How did others resolve this issue? Was there a newer version of a tool released that would resolve it?
- When looking at blogs, you will start to see some familiar suspects come up again and again, and you'll know you have good information there. I am personally fond of from [Thoughtbot](https://robots.thoughtbot.com/) or [Engine Yard](https://blog.engineyard.com/). I know the information in both of those is from smart, professional developers who care about Ruby for a living.

Always bias towards newer search results, and prefer advice provided by a source you know to be credible. For example, there are some sites that can be okay as a quick-and-dirty resource for HTML/JS/CSS, but for a deeper dive and discussion, bias to checking out the [Mozilla Developer Network docs](https://developer.mozilla.org/en-US/). Sites with dated UIs or tons of ads usually get a pass from me as well, since the traffic driven there may be in the service of advertisements or simply because the information is ancient and has been indexed and clicked on since the Dawn of the Internet.

## A Parting Word: READ THE DOCS!

Finally, *read* the documentation! Are you trying to use a new tool, gem, or library? Check out its documentation or Github README. Use `Command + F` to find passages relevant to the method or function you are trying to use. If all else fails, search Github for the gem to see how others are using it.

