const glob = require('glob');
const path = require('path');
const TsconfigPathsPlugin = require('tsconfig-paths-webpack-plugin');
const WebpackAssetsManifest = require('webpack-assets-manifest');

const isProd = process.env.NODE_ENV === 'production';
const devServerPort = process.env.PORT || 3035;

const entry = {};
for (const p of glob.sync(path.resolve(__dirname, 'app/javascript/packs/*'))) {
  entry[path.basename(p, path.extname(p))] = p;
}

module.exports = {
  entry: entry,
  mode: isProd ? 'production' : 'development',
  output: {
    path: path.resolve(__dirname, 'public/packs'),
    publicPath: process.env.USE_WEBPACK_DEV_SERVER === '1' ? `//localhost:${devServerPort}/packs/` : '/packs/',
    filename: isProd ? '[name]-[hash].js' : '[name].js',
  },
  module: {
    rules: [
      {
        test: /\.(js|ts)x?$/,
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
    port: devServerPort,
  },
  devtool: 'source-map',
};
