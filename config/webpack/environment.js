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
// const sassLoader = { 
//   test: /\.scss$/,
//   exclude: /node_modules/,
//   use: [
//     MiniCssExtractPlugin.loader,
//     "css-loader",
//     "postcss-loader",
//     "sass-loader"
//   ]
// }

// // prepend the plugin 
// environment.loaders.prepend('sass', sassLoader );

// keep default rails stuffs. 
module.exports = environment
