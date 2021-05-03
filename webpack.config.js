const glob = require('glob');
const path = require('path');
const TsconfigPathsPlugin = require('tsconfig-paths-webpack-plugin');
const WebpackAssetsManifest = require('webpack-assets-manifest');

const entry = {};
for (const p of glob.sync(path.resolve(__dirname, 'app/javascript/packs/*'))) {
  entry[path.basename(p, path.extname(p))] = p;
}

const isProd = process.env.NODE_ENV === 'production';

module.exports = {
  entry: entry,
  mode: isProd ? 'production' : 'development',
  output: {
    path: path.resolve(__dirname, 'public/packs'),
    publicPath: process.env.USE_WEBPACK_DEV_SERVER === '1' ? '//localhost:8081/packs/' : '/packs/',
    filename: isProd ? '[name]-[hash].js' : '[name].js',
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        loader: 'ts-loader',
        options: {
          transpileOnly: true,
        },
      },
    ],
  },
  resolve: {
    extensions: ['.js', '.ts', '.jsx', '.tsx'],
    plugins: [new TsconfigPathsPlugin()],
  },
  optimization: {
    splitChunks: {
      chunks: 'initial',
      name: 'vendor',
    },
  },
  plugins: [
    new WebpackAssetsManifest({
      publicPath: true,
      output: 'manifest.json',
      writeToDisk: true,
    }),
  ],
  devServer: {
    contentBase: path.resolve(__dirname, 'public'),
    publicPath: '/packs/',
    host: 'localhost',
    port: 8081,
    headers: {
      'Access-Control-Allow-Origin': '*',
    },
  },
  devtool: 'source-map',
};
