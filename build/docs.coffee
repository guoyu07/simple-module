gulp = require 'gulp'
gutil = require 'gulp-util'
jade = require 'gulp-jade'
through = require 'through2'
path = require 'path'
fs = require 'fs'
coffee = require 'gulp-coffee'
sass = require 'gulp-sass'
pkg = require '../package.json'
navItems = require '../docs/data/nav.json'
helper = require './helper.coffee'

gulp.task 'docs.clean', ->
  helper.removeDir '_docs'

gulp.task 'docs.jade', ->
  compileJade()


gulp.task 'docs.coffee', ->
  compileCoffee()

gulp.task 'docs.sass', ->
  compileSass()

gulp.task 'docs', ['docs.clean'], ->
  compileJade()
  compileCoffee()
  compileSass()


compileJade = ->
  gulp.src(['docs/**/*.jade', '!docs/layouts/**/*.jade'])
    .pipe through.obj (file, encoding, done) ->
      file.data =
        pkg: pkg
        navItems: navItems
        filename: path.basename(file.path, '.jade')
      @push file
      done()
    .pipe jade()
    .pipe through.obj (file, encoding, done) ->
      file.path = path.join file.base, "#{file.data.filename}.html"
      @push file
      done()
    .pipe gulp.dest '_docs'

compileCoffee = ->
  gulp.src 'docs/**/*.coffee'
    .pipe coffee().on('error', gutil.log)
    .pipe gulp.dest('_docs/')

compileSass = ->
  gulp.src 'docs/**/*.scss'
    .pipe sass().on('error', sass.logError)
    .pipe gulp.dest('_docs/')
