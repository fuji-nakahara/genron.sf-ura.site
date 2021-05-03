const glob = require("glob");
const path = require("path");
const WebpackAssetsManifest = require("webpack-assets-manifest");

const isProd = process.env.NODE_ENV === "production";

const entry = {};
glob
  .sync(path.resolve(__dirname, "app/javascript/packs/*.{js,ts,tsx}"))
  .forEach((p) => {
    entry[path.basename(p, path.extname(p))] = p;
  });

module.exports = {
  mode: isProd ? "production" : "development",
  devtool: "source-map",
  entry: entry,
  output: {
    path: path.resolve(__dirname, "public/packs"),
    publicPath:
      process.env.USE_WEBPACK_DEV_SERVER === "1"
        ? "//localhost:8081/packs/"
        : "/packs/",
    filename: isProd ? "[name]-[hash].js" : "[name].js",
  },
  resolve: {
    extensions: [".js", ".ts", ".tsx"],
  },
  optimization: {
    splitChunks: {
      chunks: "initial",
      name: "vendor",
    },
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        loader: "ts-loader",
        options: {
          transpileOnly: true,
        },
      },
    ],
  },
  devServer: {
    contentBase: path.resolve(__dirname, "public"),
    publicPath: "/packs/",
    host: "localhost",
    port: 8081,
    headers: {
      "Access-Control-Allow-Origin": "*",
    },
  },
  plugins: [
    new WebpackAssetsManifest({
      publicPath: true,
      output: "manifest.json",
      writeToDisk: true,
    }),
  ],
};
