gulp = require 'gulp'
watch = require 'gulp-watch'
plumber = require 'gulp-plumber'
gshell = require 'gulp-shell'

runSequence = require 'run-sequence'
del = require 'del'

# Watch changing files
gulp.task 'watch', () ->
  watch ["source/assets/coffee/**/*.coffee"], () ->
    gulp.start ['coffee', 'test:app']

  watch ["source/views/**/!(_)*.jade"], () ->
    gulp.start ['jade', 'test:app']

  watch ["source/assets/stylus/**/!(_)*.styl"], () ->
    gulp.start ['stylus', 'test:app']

# Test
gulp.task 'test:app', () ->
  gulp.src './'
    .pipe(gshell '/Applications/node-webkit.app/Contents/MacOS/node-webkit ./release/src')

# Clean Resources
gulp.task 'clean:js', (cb) ->
  del("release/src/js/*.js*", null, cb)

gulp.task 'clean:css', (cb) ->
  del("release/src/css/*.css*", null, cb)

gulp.task 'clean:html', (cb) ->
  del("release/src/*.html", null, cb)


# Compile Stylus
gulp.task 'stylus', ['clean:css'], () ->

  stylus = require 'gulp-stylus'

  gulp.src ["source/assets/stylus/**/*.styl"]
    .pipe(plumber())
    .pipe stylus
      compress: true
    .pipe(gulp.dest("release/src/css"))


# Compile CoffeeScript
gulp.task 'coffee', ['clean:js'], () ->
  browserify = require 'browserify'
  source = require 'vinyl-source-stream'
  buffer = require 'vinyl-buffer'

  browserify(
    entries: ['./source/assets/coffee/main.coffee']
    debug: true,
    extensions: ['.coffee'],
    transform: ['coffeeify'],
    detectGlobals: false,
    builtins: []
  )
  .bundle()
  .pipe(plumber())
  .pipe(source('main.js'))
  .pipe(buffer())
  .pipe(gulp.dest('release/src/js'))

# Compile Jade
gulp.task 'jade', ['clean:html'], () ->
  jade = require 'jade'
  gjade = require 'gulp-jade'

  gulp.src ["source/views/!(_)*.jade"]
    .pipe(plumber())
    .pipe gjade
      jade: jade
      pretty: true
    .pipe(gulp.dest("release/src"))

# Copy Resources
gulp.task 'copy:meta', () ->
  gulp.src ['source/package.json']
    .pipe(gulp.dest('release/src'))

# Release Task
gulp.task 'release', ['copy:meta'], () ->

  builder = require 'node-webkit-builder'
  gutil = require 'gulp-util'

  options =
    version: 'latest'
    files: ['release/src/**']
    buildDir: 'release/bin'
    cacheDir: 'release/nw'
    platform: ['osx', 'win']
    buildType: 'versioned'

  nw = new builder(options)

  nw.on 'log', (message) ->
    gutil.log('node-webkit-builder', message)

  nw.build().catch (error)->
    gutil.log('node-webkit-builder', error)


# Default Task
gulp.task 'default', () ->
  console.log('Error! No Task Defined!')