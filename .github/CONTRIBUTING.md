# How to contribute

We have been making efforts to keep the code readable so that if
you want to contribute, just by reading the code everything
should make sense to you immediately.

However, we thought it would probably be helpful to write down
some of the project's tribal knowledge (every project has some)
as well as some other things that will increase the chance that
your pull request is accepted.

## Code of conduct

This is a Ruby project, so we embrace the Ruby mantra "*Matz is
nice and so we are nice*". Help us keep this project open and
inclusive. Please read and follow our
[Code of Conduct](https://github.com/theyworkforyou/shineyoureye-sinatra/blob/master/.github/code-of-conduct.md).



## Contributing guidelines

The easiest way to get it right is to read the code that already
exists and do things as you see they are done. Basically keep
the code clean, readable, maintainable and easy to change in the
future. Follow good practices, SOLID principles and design
patterns.

Reading through the
[document explaining our design decisions](https://github.com/theyworkforyou/shineyoureye-sinatra/blob/master/.github/PULL_REQUEST_TEMPLATE.md)
for this project should also be helpful.


### Coding standards

This is a mySociety project, so in general it follows our
[coding standards](https://mysociety.github.io/coding-standards.html). The
guide starts with "*Readability is more important than
cleverness.*". Readability and maintainability are very
important!

This is also a Ruby project so we use Rubocop to automate syntax
checks, following
[the official Ruby style guide](https://github.com/bbatsov/ruby-style-guide). Rubocop
runs always after the tests, so it will catch anything you
forgot.

### Tests

Make sure the code you submit with your PR is covered by tests,
and that all the tests pass. We have Travis in place so we won't
merge a PR until Travis is green. We also use Coveralls to make
sure we have a healthy test coverage.

Tests not only help make sure that new changes don't break the
existing code. More importantly; they help you have a well
designed and structured codebase.

### Git etiquette

Mostly described in our coding standards, we would like to call
attention to some points:

* We have a
  [PR template](https://github.com/theyworkforyou/shineyoureye-sinatra/blob/master/.github/PULL_REQUEST_TEMPLATE.md)!
  :smiley:

* Small PRs are easier to review, and are more likely to be
  merged fast. Sometimes we do "cleaning" PRs before the real
  PR, to fix the code first for the change we want to
  do. "[*Make the change easy, then make the easy change*](https://twitter.com/kentbeck/status/250733358307500032?lang=en)".

* [Commits should have a single responsibility. The description should use verbs in imperative tense and explain the "why"](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).

* When you finish your PR, remember to check if the README needs
  updating after your change.

* Finally, be sure that every single commit passes the tests in
  isolation (an example of when this could be useful is if you
  need to do `git bisect` at some point). You can check that
  every commit passes the tests using:

```
git rebase -i --exec 'bundle exec rake' master
```

The rebase will stop if tests fail.

## Project's insider knowledge

This section is about the gotchas of the project, state that we
as contributors to the project hold in our heads, but is not
necessarily obvious to external contributors. This is a
compilation of helpful background that you should know. Please
keep adding things here, for the newcomers.

* This app is never served dynamically. We scrape it and serve
  it as a static site from the `gh-pages` branch of a GitHub
  repository (see README). Because of that, **some things are
  done differently from other Sinatra applications, in
  particular the error handling and redirecting to another
  page**. We also have a route whose only purpose is to be used
  in the scraping.

* The `prose` contents are cloned into a folder right under the
  root directory of the app using the `bin/prepare-data` script
  (see README). All the other data we use is under the root
  directory as well (`mapit` for Mapit json files, `morph` for
  CSV files, etc.)

* For the moment, and until we are asked to implement a
  different behavior, **we use the same classes for both posts
  and events**.

* All content pages from prose are published, but not all are
  linked. This is a small nuance from the way we build the site.
  Events and posts can be published or unpublished, and their
  markdown files in prose have a `published` field in the
  frontmatter. They are linked automatically if they have a
  `published: true`. Summaries and info pages are always
  published, so their markdown files in prose don't have a
  `published` field in the frontmatter. They have to be linked
  manually, for example, in the main menu. All content is
  published because we add the unpublished posts/events and
  unlinked info pages to the page used for scraping.

* Summaries are a particular case of
  `DocumentWithFrontmatter`. For example, they are always
  published so
  [their frontmatter has no `published` field](https://github.com/theyworkforyou/shineyoureye-prose/blob/2ce655b2adf3881c27055b4d54e5f155e155ce61/_prose.yml#L61-L66). Also,
  the `find_or_empty` method in the finder is for finding
  summaries. This is because we need to pass a valid duck type
  to the person page. If the person does not have a summary, a
  null object is sent instead.

* **Every page must have a title**. For this we have a dedicated
  page: if you are not doing anything fancy, you can use an
  instance of a
  [Basic Page](https://github.com/theyworkforyou/shineyoureye-sinatra/pull/137). If
  you need more functionality, create your own page. If the page
  you created is doing too much, extract the extra functionality
  into service objects and use dependency injection. Page
  classes should just give the views what they need to
  render. See the
  [document explaining our design decisions](https://github.com/theyworkforyou/shineyoureye-sinatra/blob/master/.github/design-decisions.md)

* As the README indicates, we use `bin/prepare-data COMMIT_SHA`
  to download the user-entered data from prose, which is not
  only used for the tests but is also part of the content
  displayed by the app. If you need to make a change in the
  prose files that the tests need, **you need to update the
  commit sha in the `.travis.yml` file, but ALSO in the prose
  `.travis.yml` file**, because we use that file in prose to
  deploy the site, and it runs the tests before deploying.

* When there is some error handling to do, we prefer to
  **extract a separate method for that task**. See for example
  the
  [document finder](https://github.com/theyworkforyou/shineyoureye-sinatra/blob/master/lib/document/finder.rb)
  which uses two of those.

* Since we have two classes to handle the two different types of
  people we can have, **remember to add tests to their shared
  examples first so that both keep the same API** (the other
  option was to add an abstract parent class and use
  inheritance, but inheritance introduces unneeded coupling and
  we would still have to remember to add the methods to the
  parent first).

* The integration tests are in `tests/web`. They start
  requesting a route and assert that the right thing is rendered
  in the views. The integration tests that cover the
  user-editable content use the `prose` contents at a certain
  part of the commit history as explained in the README.

* There are some fakes for tests in `tests/test_doubles`. Before
  adding a new fake is worth checking that it doesn't exist
  there :smiley:

* Persons should always have a slug. If they don't, or if the
  slug is not unique, that should be fixed upstream. The code
  will throw an error.


## Questions

Please write to us at
[parliaments@mysociety.org](mailto:parliaments@mysociety.org).
