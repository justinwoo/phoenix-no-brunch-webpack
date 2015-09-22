var webpack = require('webpack');

module.exports = {
  entry: './web/static/js/app.js',
  output: {
    path: './priv/static/js',
    filename: 'app.js'
  },
  module: {
    loaders: [
      {
        loader: 'babel-loader',
        test: /\.js$/,
        exclude: /node_modules/
      },
      {
        loader: 'elm-simple-loader',
        test: /\.elm$/,
        exclude: /node_modules/
      }
    ]
  }
};
