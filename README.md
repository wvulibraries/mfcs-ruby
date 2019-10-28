# MFCS Stack Documentation 
MFCS is going to be a fairly complex application.  Because of this we are going to have a rather large stacks that helps to comprise MFCS.  

## Backend 
  - Rails 
  - Elasticsearch (Indexing / Search)
  - Postgres (SQL Database)
  - Redis (Potentially) for queing up Jobs

## Frontend 
  - Webpack
  - Bootstrap (+ bootstraps required dependencies)
  - Font Awesome 
  - Stimulus JS
  - Yarn Integration 

## Turbolinks 
Stimulus is designed to work with Turbolinks to que sites up faster and allow on the fly rendering of serverside and JavaScript related information.  It also allows parts of the site that are not changing to remain the same.  There should be some basic documentation added on how these parts will work togather in the near future.  

There are some packages that used to be in the main rails stuff, but is now added through yarn.  

## JavaScript Webpacks 
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