# MFCS
[![CircleCI](https://circleci.com/gh/wvulibraries/mfcs-ruby.svg?style=svg)](https://circleci.com/gh/wvulibraries/mfcs-ruby)
[![Maintainability](https://api.codeclimate.com/v1/badges/fae0d299e71e41e042dd/maintainability)](https://codeclimate.com/github/wvulibraries/mfcs-ruby/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/dc9fb3109c8a8ff1301c/test_coverage)](https://codeclimate.com/github/wvulibraries/mfcs-ruby/test_coverage)


## Metadata Form Creation System 
- The current goal is to match functionality of the current MFCS system, but also to remember that this system will serve as a minor preservation system.  The full goal of this system is to get item level metadata for digital collections.  This data will then be able to be served out to OAI-PMH exports, DPLA exports, a variety of different Metadata Formats, and other needs as established by WVU Libraries.

- More Detailed Documentation to come in the form of Wiki's as the software becomes more complete.  

## Documentation Contents
- [BACKEND](#BACKEND)
- [FRONTEND](#FRONTEND)
  - [Dependencies](#dependencies)
  - [TurboLinks](#turbolinks)
  - [Webpack Gotchas](#webpacks)
  - [Stimulus](#stimulus-controllers)
- [TEST SUITE](#TESTING-SUITE)
  - [JEST (Frontend Testing)](#JEST)
  - [RSPEC (Backend Testing)](#RSPEC)

# BACKEND 
  - Rails 
  - Elasticsearch (Indexing / Search)
  - Postgres (SQL Database)
  - Redis (Potentially) for queing up Jobs

So far this is fairly straight forward as a Rails App, more to come I'm sure.

# FRONTEND

## Dependencies
  - Webpack
  - Bootstrap (+ bootstraps required dependencies)
  - Font Awesome 
  - Stimulus JS
  - Babel
  - SCSS
  - Yarn Integration 
  - Jest

## Turbolinks 
Stimulus is designed to work with Turbolinks to que sites up faster and allow on the fly rendering of serverside and JavaScript related information.  It also allows parts of the site that are not changing to remain the same.  There should be some basic documentation added on how these parts will work together in the near future.

There are some packages that used to be in the main rails stuff, but is now added through yarn.  

## Webpacks 
Any JavaScript that needs to be referenced in a webpack, must include that JS in the pack or it will not get compiled correctly by webpack.  

Ex: 
```
$(document).on("turbolinks:load",function(){
  $('[data-toggle="popover"]').popover();
  $('[data-toggle="tooltip"]').tooltip()
});
```

This can not be used in any other packs except the application pack, because each pack has to contain the code that is going to compile it.  If we wanted to use it in smaller invidual pack we would have to include all the bootstrap files into that pack as well, but this would be a duplicate effort since it is already included in the application.js pack.  There may be ways around this limitation such as exposing bootstrap or using bootstrap.js in the compilation of the files, but this is what worked for me after a few days of frustration. 

## Stimulus Controllers 

The beauty behind the stimulus controllers are how the bindings happen.  Stimulus bindings are always in place so dymaically adding HTML to the various aspects of the DOM will still allow the JavaScript to manipulate those items or attach events to those items.  Making it much easier to create dynamic javascript events.

# TESTING SUITE
MFCS is tested using two different test suites.  A test suite for the frontend work, and a test suite for the backend work.  

## RSPEC
We are using Rspec to handle the backend testing.

`RAILS_ENV=test bundle exec rspec` will run the full test
`RAILS_ENV=test bundle exec rspec {directory_path}` will run a specific subset of tests
`RAILS_ENV=test bundle exec rspec {directory_path}/{test_name}` will run a single test.

## JEST
We are using Jest to handle the frontend testing.  If you look in the `package.json` file you will notice some setup requirements. 

```json
"jest": {
    "roots": [
      "spec/javascript"
    ],
    "moduleDirectories": [
      "node_modules",
      "app/frontend/packs", 
      "app/frontend/components", 
      "app/frontend/controllers"
    ]
  }, 
  "scripts": {
    "test": "jest"
  }
  ``` 

  The roots setup of the JSON file sets the spec/javascript folder to be the place that JEST searches for tests.  This helps to keep all our tests in one location.  The modules are places that modules should be loaded from.  In our setup all of our webpack materials are in `packs`, `components`, and `controllers`.  The scripts section sets up the testing scripts for Jest to run what it needs to run.  This file may change and grow as we add and modify more peices to be tested.  Remember to update this README each time we make a mondification.

  `yarn run jest` will run the javascript tests setup in the `spec/javascript` folder.  Remember the naming conention must have `*.spec.js` or `*.test.js`.  This is based on preference, but using RSPEC for the backend testing makes me feel more comfortable with `spec` over `test`. 

  ## Importing
  Scripts have been created to help with the importing of exported data from MFCS (PHP). To run the individual imports excute the following commands.

  `bin/rails r importing/users/import_users.rb` import users
  `bin/rails r importing/forms/import_forms.rb` import forms
  `bin/rails r importing/projects/import_projects.rb` import projects
  `bin/rails r importing/watermarks/import_watermarks.rb` import watermarks
  `bin/rails r importing/objects/import_metadata_objects.rb` import metadata objects
  `bin/rails r importing/objects/import_digital_objects.rb` import digital objects

  To run all the import scrips run `sh ./import.sh`




...--
