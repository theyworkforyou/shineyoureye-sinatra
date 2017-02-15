# Shine Your Eye (Sinatra)

This project is a proof of concept that aims to make it easy to produce
lightweight parliamentary monitoring sites. It uses EveryPolitician data,
user-editable data (through [prose.io](http://prose.io/)), and CSV data.
It doesn't use a database.

It is meant to be an exemplar. A generic core could be extracted from it,
leaving ShineYourEye specifics out, so that a parliament-monitoring site can be
implemented for other countries as well, using this approach.

## Approach

The approach of this project is similar to
[`viewer-sinatra`](https://github.com/everypolitician/viewer-sinatra):

* This is a Sinatra application that uses content produced by
[prose.io](http://prose.io/) that is saved in
[`shineyoureye-prose`](https://github.com/theyworkforyou/shineyoureye-prose).
* A script pulls this content, runs the app and scrapes it.
* Then pushes the scraped pages to the `gh-pages` branch of another repo,
[`shineyoureye-static`](https://github.com/theyworkforyou/shineyoureye-static).

Non-technical users can use [prose.io](http://prose.io/) to add content to the
prose repo. Then, whenever there is a change in that repo, the script runs,
producing an updated version of the site in the static repo.

Running a static site vs a dynamic one has several advantages. Also, we benefit
from GitHub's free hosting.


## Data sources

This project uses data from several different sources:

* Mapit, for the areas data
* Pombola, to get information from the old version of the site, like slugs for the areas and person pages
* EveryPolitician (EP), for the data about politicians
* Morph, because the information about governors is not available in EP, so we had to write a scraper

For these we need a lot of mapping CSV files which can be found in the `mapit` folder:

* A file to map federal constituency Mapit areas to their states, as Mapit is returning them with a `parent_area` of `null`. This file is needed because both the area name and the state name have to be displayed in the site
* For symmetry, there is also a file to do the same mapping to senatorial districts, although in this case Mapit returns a valid `parent_area` for those
* A file to map Mapit area ids to EP area ids, one for federal constituencies and another for senatorial districts. This is so that we can return the area of a politician as a Mapit area, and so that we can ask EP data for all the persons associated to a Mapit area.
* A file to map Mapit areas to Pombola slugs, so that we use the same urls for place pages as the Pombola version of the site
* A file to map EP persons to Pombola slugs, so that we use the same urls for person pages as the Pombola version of the site


## Development


### How to use this project

This is a Ruby project.
You will need to tell your favourite Ruby version manager to set your local Ruby
 version to the one specified in the `Gemfile` file.

For example, if you are using
[rbenv](https://cbednarski.com/articles/installing-ruby/):

1. Install the right Ruby version. That would be the version specified at the
beginning of the Gemfile. For example, if it was `ruby '2.3.1'`, you would type:
```bash
rbenv install 2.3.1
rbenv rehash
```
2. Then you would move to the root directory of this project and type:
```bash
rbenv local 2.3.1
ruby -v
```

You will also need to install the `bundler` gem, which will allow you to install
 the rest of the dependencies listed in the `Gemfile` file of this project.

```bash
gem install bundler
rbenv rehash
```


### Folder structure

* `bin `: scripts, like deploy scripts, etc.
* `lib `: the codebase
* `lib/document`: code to parse [prose.io](http://prose.io/) files (markdown
  with frontmatter)
* `lib/ep`: code to parse EveryPolitician data
* `lib/helpers`: mostly site-specific stuff
* `lib/mapit`: code to parse Mapit data
* `lib/page`: presenters to extract all logic out of the views
* `prose`: where the `shineyoureye-prose` repository will be cloned. Contains
user introduced content, like blog posts, events, etc.
* `public`: static assets
* `public/stylesheets/sass`: sass files automatically compiled into css
* `tests`: all the tests
* `views`: the erb templates to build the site


## Running the app

### Initialise the project

```bash
bundle install
```

### Prepare data for the app

```
bin/prepare-data
```

This will copy the user-editable contents of the site (the blog posts
and static pages generated using [prose.io](http://prose.io/)) into a
`prose` directory.

### Run the app

```bash
bundle exec rackup
```

And go to <http://localhost:9292/>


## Tests

(Assuming you have installed the fixtures with `bin/prepare-data`, as above.)

### Run the tests

```bash
bundle exec rake test
```

### Run one test file

```bash
bundle exec rake test TEST='path/to/test/file'
```
