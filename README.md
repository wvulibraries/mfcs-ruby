# MFCS
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
Stimulus is designed to work with Turbolinks to que sites up faster and allow on the fly rendering of serverside and JavaScript related information.  It also allows parts of the site that are not changing to remain the same.  There should be some basic documentation added on how these parts will work togather in the near future.  

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

  The roots setup of the JSON file sets the spec/javascript folder to be the place that JEST searches for tests.  This helps to keep all our tests in one location.  The modules are places that modules should be loaded from.  In oursetup all of our webpack materials are in `packs`, `components`, and `controllers`.  The scripts section sets up the testing scripts for Jest to run what it needs to run.  This file may change and grow as we add and modify more peices to be tested.  Remember to update this README each time we make a mondification.

  `yarn run jest` will run the javascript tets setup in the `spec/javascript` folder.  Remember the naming conention must have `*.spec.js` or `*.test.js`.  This is based on preference, but using RSPEC for the backend testing makes me feel more comfortable with `spec` over `test`. 

  ## RSPEC
  We are using Rspec and Shoulda matchers in the backend for testing our models.  There will be a possibility of doing integration tests too, but we want to see how far our JavaScript tests will reach before adding the complexity of more tests to the suite.  

  `bundle exec rspec` will run the full test
  `bundle exec rspec {directory_path}` will run a specific subset of tests
  `bundle exec rspec {directory_path}/{test_name}` will run a single test.