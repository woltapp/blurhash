const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

// Is the current build a development build
const env = process.env.NODE_ENV;

const IS_DEV = !env ? true : env;
const dirNode = 'node_modules';
const dirApp = path.join(__dirname, 'src');
const dirAssets = path.join(__dirname, 'assets');

/**
 * Webpack Configuration
 */
module.exports = {
  entry: {
    vendor: ['lodash'],
    bundle: path.join(dirApp, 'index'),
  },
  resolve: {
    modules: [dirNode, dirApp, dirAssets],
  },
  devtool: IS_DEV ? '#cheap-module-source-map' : '#source-map',
  plugins: [
    new MiniCssExtractPlugin({
      filename: '[name].[hash].css',
    }),
    new webpack.DefinePlugin({
      IS_DEV: IS_DEV,
    }),
    new webpack.HotModuleReplacementPlugin(),
    new HtmlWebpackPlugin({
      template: path.join(dirApp, 'index.ejs'),
      title: 'BlurHash',
    }),
  ],
  module: {
    rules: [
      // BABEL
      {
        test: /\.js$/,
        loader: 'babel-loader',
        exclude: /(node_modules)/,
        options: {
          compact: true,
        },
      },

      // CSS / SASS
      {
        test: /\.scss/,
        use: [
          IS_DEV && MiniCssExtractPlugin.loader,
          {
            loader: 'css-loader',
            options: {
              sourceMap: IS_DEV,
            },
          },
          {
            loader: 'sass-loader',
            options: {
              sourceMap: IS_DEV,
              includePaths: [dirAssets],
            },
          },
        ],
      },
      // IMAGES
      {
        test: /\.(jpe?g|png|gif|svg)$/,
        loader: 'file-loader',
        options: {
          name: '[path][name].[ext]',
        },
      },

      // FONTS
      {
        test: /\.(eot|otf|woff2?|ttf)[\?]?.*$/, // eslint-disable-line
        use: 'file-loader?name=fonts/[name].[ext]',
      },
    ],
  },
  devServer: {
    host: '0.0.0.0',
    historyApiFallback: true,
    hot: true,
  },
};
