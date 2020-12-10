/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.

const images = require.context('./images', true);
const imagePath = (name) => images(name, true)

// Rails Documentation says these have to be added
// ===================================================================== 
import "core-js/stable";
import "regenerator-runtime/runtime";

// TurboLinks
// ===================================================================== 
require("turbolinks").start();

// RAILS UJS 
// =====================================================================
require("@rails/ujs").start();

// scss
// ===================================================================== 
import './src/application.scss';

// Bootstrap JavaScript
// ===================================================================== 
import 'bootstrap/dist/js/bootstrap.bundle.min';

$(document).on("turbolinks:load",function(){
  $('[data-toggle="popover"]').popover();
  $('[data-toggle="tooltip"]').tooltip();
});

// Nested Forms JS
// =====================================================================

// Remove Fields from View
$(document).on('click', '.remove-fields', function(event) {
  event.preventDefault();
  $(this).prev('input[type=hidden]').val('1')
  $(this).closest('fieldset').hide()
});

// Add Fields into View 
$(document).on('click', '.add-fields', function(event) {
  event.preventDefault();
  var time = new Date().getTime();
  var regexp = new RegExp($(this).data('id'), 'g');
  $(this).before($(this).data('fields').replace(regexp, time));
});

// stimulus 
// ===================================================================== 
import "../controllers"

// WYSIWYG
// ===================================================================== 

import "trix/dist/trix.css";
import { Trix } from "trix"

// Multiselect
// ===================================================================== 
import 'select2';                       // globally assign select2 fn to $ element

$(document).on("turbolinks:before-cache", function() {
  $('.multiselect-select2').select2('destroy');
});

$(document).on('turbolinks:load', function() {
  $('.multiselect-select2').select2({theme: 'mfcs'});
});