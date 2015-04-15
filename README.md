# What is this project?
This project is for creating node-webkit app.

# Installation step

## 1. Clone this repository
git clone `git@github.com:katsew/nw-scaffold.git`

## 2. Goto source directory
`cd [project-root]/source`

## 3. Initialize on the source directory
1. `npm init`
2. `git init`

## 4. Start creating your app!

### resources in source

`views/` is for Jade and compiled html will be output into `release/src/`.  
create `package.json` on this directory for your app.  
(cf. Installation step 3)

### resources in source/assets

`coffee/` is for CoffeeScript and its file will browserify and be output into `release/src/js/`.
`coffee/modules/` is for CoffeeScript modules. It expect to be required by `coffee/main.coffee` then browserified.
`stylus/` is for Stylus and compiled css will be output into `release/src/css/`.

### tasks

`gulp watch` will watch all resources (except image) and compile to `release/src`.
`gulp release` will create node-webkit app for your project, then output into `release/bin`.


