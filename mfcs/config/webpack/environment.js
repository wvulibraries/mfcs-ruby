// rails webpack environment
const { environment } = require('@rails/webpacker');
const webpack = require("webpack")
// Bootstrap JS
environment.plugins.append("Provide", new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default'],
  Rails: ['@rails/ujs']
}))

// // sass loader module should load sass and then send it to the postcss loader
module.exports = environment