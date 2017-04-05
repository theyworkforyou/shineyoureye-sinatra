## Design Decisions

These are some of the design decisions we took when building this app:

* Since this app is an exemplar, the most important thing we keep in mind is to separate site-specific code from generic code (for example, the posts and post pages are generic, but the route to the posts page or the post page is site-specific). Anything that is site-specific is passed as an argument. That way, we keep a separation of concerns. This will also help do a cleaner extract of a generic core for future code re-use.

* We avoid having logic in the routes or in the views, the only code there should be to create objects and wire up dependencies or jump to the next route. We prefer to separate all our logic from the framework, so that the code is portable, testable and decoupled. We put all the logic in service objects instead. Example: if you find yourself formatting a string or a date in a view, that should probably go in the view's page class instead, so that you can just do `@page.text` or `@page.date` in the view and it will have the right format. See for example, [this guide for Rails](https://8thlight.com/blog/christoph-gockel/2016/10/26/getting-rails-on-track-part-2-views.html) (which is applicable here). We do this for separation of concerns as well.

* For the same reasons, the service objects are independent of Sinatra and know nothing about it, so there should be no Sinatra exceptions or anything framework-related in this code. If you took these classes out and put them into a Rails or Middleman app, for example, they should work with very small tweaks.

* Related with the previous point, and to avoid complexity, [we only pass ONE object to the views](https://robots.thoughtbot.com/sandi-metz-rules-for-developers#only-instantiate-one-object-in-the-controller). That object is usually an instance of a page. Its public methods return everything that the view needs to render.

* We have a lot of different sources of data that we use to display information on the pages, so keeping a clear separation of the classes by function (see the **Code structure** section below) is very important to keep the code manageable and prevent changes to cascade through a lot of unrelated parts of the codebase.

* We avoid coupling classes (and tests) too much, some coupling is inevitable, but we try to keep it low. Dependency injection is your friend.

* There are different opinions about this, but we avoid comments and only use them when there is a need to explain why we did something. If you add a comment because what the code is doing is obscure, that is a code smell and it is better to refactor the code and make it more readable (and hence maintainable).


## Code structure

It is unlikely that any of our Pombola-lite sites in the future will have the level of complexity of this particular site. We have a lot of different sources of data and also this is a port from an existing Pombola site, so we need to keep some things from there as well.

However the principles we used to separate the different concerns are generic and could suit simpler sites.

* We use namespacing to distinguish all the different parts of the application.

* The code is organized as follows:
  * **page classes**, which are consumed by the views
  * **service classes**, where the logic of the application lives

  The page classes often use service objects to do their job. These are passed to the page classes using dependency injection.

* Both the service classes and the page classes live under `lib`. The data (prose documents, CSV files, JSON files, etc.) lives under the root directory in their corresponding folders (`prose`, `mapit`, `morph`, etc.)

### Service classes

#### Document

These are the classes that contain the logic to parse a document. A document in this app refers to user-editable content like posts, events, info pages and summaries. These are saved as markdown documents with YAML frontmatter, which are read from the `prose` directory.

[The YAML fields in these documents](https://github.com/theyworkforyou/shineyoureye-sinatra/blob/master/lib/document/frontmatter_parser.rb) map to prose fields in [the prose configuration file](https://github.com/theyworkforyou/shineyoureye-prose/blob/gh-pages/_prose.yml). The prose fields are different for each type of document and their values are set by the user through the prose graphic interface.


#### EP and MembershipCSV

These are the classes used to parse data about politicians. The EP classes encapsulate data coming from the [EveryPolitician](http://everypolitician.org/) project. The MembershipCSV classes encapsulate data coming from a CSV file, usually one produced by a scraper running at [Morph](https://morph.io/).

We keep both separated into two different classes for the reasons stated in the previous section, but both types should keep the same API.

#### MapIt

Although we can get the areas associated with politicians from the EveryPolitician project or from the CSV files, we map those to [MapIt data](http://nigeria.mapit.mysociety.org) and use the information from MapIt instead.

Hence, in this folder we keep all the classes to parse and encapsulate the data coming from MapIt and the mappings of MapIt areas with areas obtained from elsewhere. Ideally this could be extracted into its own gem in the future after some work, but for now it lives here.

#### Collection/Finder classes and entity classes

The service classes are usually organized into collection/finder classes and entity classes.

Collection classes represent a list of entities of a certain type. These classes can be used to find a particular entity and return either a single entity or a list of entities. Their corresponding page class will use one of them.

They are used in routes that are a list of things, for example, the list of posts, the list of people or the list of areas. Examples of collection clases are `Document::Finder` (for document entities), `EP::PeopleByLegislature`/`MembershipCSV::People` (for person entities) and `Mapit::Wrapper` (for place entities).
