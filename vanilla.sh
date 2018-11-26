#!/usr/bin/env bash

NEW_PROJECT="$1"




mkdir "$NEW_PROJECT";cd $NEW_PROJECT

# CONFIG FILES
echo "'use strict';

root = true

[*]
charset = utf-8
end_of_line = lf
trim_trailing_whitespace = true
insert_final_newline = true
indent_style = space
indent_size = 2

[*.md]
indent_size = 4" > .editorconfig

echo "last 10 versions" > .browserslistrc

echo "module.exports = {
    plugins: [
        require('autoprefixer'),
        require('cssnano')({
            preset: 'default',
        })
    ]
}" > postcss.config.js

echo "const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
  entry: './src/js/index.js',
  output: {
    path: path.resolve(__dirname, './dist'),
    filename: 'bundle.js',
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: [{
        loader: 'babel-loader',
        options: {
          presets: [
            '@babel/preset-env'
          ]
          }
        }]
      },
      {
        test: /\.scss$/,
        exclude: /node_modules/,
        use: ['style-loader', MiniCssExtractPlugin.loader, 'css-loader', 'postcss-loader', 'sass-loader']
      },
      {
        test: /\.pug$/,
        exclude: /node_modules/,
        use: 'pug-loader'
      },
      {
        test: /\.(jpe?g|png|gif)$/,
        loader: 'url-loader',
        options: {
            limit: 10 * 1024 // doesn't inline anything over 10kb
        }
      },
      {
        test: /\.(jpg|png|gif|svg)$/,
        loader: 'image-webpack-loader',
        enforce: 'pre'
      },
      {
        test: /\.svg$/,
        loader: 'svg-url-loader',
        options: {
          limit: 10 * 1024, // doesn't inline anything over 10kb,
          noquotes: true,
        }
      }
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({
      inject: false,
      hash: false,
      template: './src/index.pug',
      filename: 'index.html',
      minify: {
        removeAttributeQuotes: true,
        collapseWhitespace: true,
        html5: true,
        removeComments: true,
        removeEmptyAttributes: true
      }
    }),
    new MiniCssExtractPlugin({
      filename: 'style.css',
    }),
  ],
}
" > webpack.config.js

echo "'use strict';

module.exports = {
    root: true,
    extends: 'airbnb-base',
    env: {
        es6: true,
        browser: true,
    },
}" > .eslintrc.js

echo "/dist" > .eslintignore

echo "# Compiled source #
###################
*.com
*.class
*.dll
*.exe
*.o
*.so

# Packages #
############
# it's better to unpack these files and commit the raw source
# git has its own built in compression methods
*.7z
*.dmg
*.gz
*.iso
*.jar
*.rar
*.tar
*.zip

# Logs and databases #
######################
*.log
*.sql
*.sqlite

# OS generated files #
######################
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
Icon?
ehthumbs.db
Thumbs.db


# Node specific #
#################
lib-cov
*.seed
*.log
*.dat
*.out
*.pid
*.gz
pids
logs
#results
npm-debug.log
node_modules/" > .gitignore

# SRC DIRECTORY

SASS_ABSTRACTS="_functions _mixins _variables"
SASS_BASE="_animations _typography _utilities"
SASS_LAYOUT="_footer _grid _header _navigation"
SASS_PAGES="_home"

mkdir src;cd src
echo 'doctype html
html(lang="en")
  head
    meta(charset="UTF-8")
    meta(name="viewport", content="width=device-width, initial-scale=1.0")
    meta(http-equiv="X-UA-Compatible", content="ie=edge")
    link(rel="stylesheet", href="style.css")
    title '$NEW_PROJECT'
  body' > index.pug

function mkdirAndTouch() {
    mkdir $1
    cd $1
    for FILE in $2;do
        touch "$FILE"."$3"
    done
    cd ..
}

mkdir js;cd js;echo 'import "../sass/main.scss";' > index.js;cd ..
mkdir sass;cd sass
echo '@import "abstracts/functions";
@import "abstracts/mixins";
@import "abstracts/variables";

@import "base/animations";
@import "base/base";
@import "base/typography";
@import "base/utilities";

@import "layout/footer";
@import "layout/grid";
@import "layout/header";
@import "layout/navigation";

@import "pages/home";' > main.scss
mkdirAndTouch abstracts "$SASS_ABSTRACTS" scss
mkdirAndTouch base "$SASS_BASE" scss
cd base; echo "*,
*::before,
*::after {
    margin: 0;
    padding: 0;
    box-sizing: inherit;
}
html {
    font-size: 62.5%;
    box-sizing: border-box;
}" > _base.scss;cd ..
mkdir components
mkdirAndTouch layout "$SASS_LAYOUT" scss
mkdirAndTouch pages "$SASS_PAGES" scss
cd ..;cd ..

# NPM STUFF
npm init -y
rm package.json
echo '{
  "name": "'$NEW_PROJECT'",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "watch": "webpack --mode development -w",
    "build": "webpack --mode production"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "@babel/cli": "latest",
    "@babel/core": "latest",
    "@babel/node": "latest",
    "@babel/preset-env": "latest",
    "autoprefixer": "latest",
    "babel-loader": "latest",
    "css-loader": "latest",
    "cssnano": "latest",
    "html-webpack-plugin": "latest",
    "mini-css-extract-plugin": "latest",
    "node-sass": "latest",
    "postcss-loader": "latest",
    "pug": "latest",
    "pug-loader": "latest",
    "sass-loader": "latest",
    "style-loader": "latest",
    "webpack": "latest",
    "webpack-cli": "latest",
    "webpack-dev-server": "latest"
  }
}' > package.json
npm install; npm update;

git init
git add .
git commit -m 'first commit'

code .