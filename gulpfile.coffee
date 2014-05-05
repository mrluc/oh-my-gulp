gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
browserify = require 'browserify'
source     = require 'vinyl-source-stream'
livereload = require 'gulp-livereload'
compass    = require 'gulp-compass'
imagemin   = require 'gulp-imagemin'


paths =
  entry: [ './app/assets/js/app.coffee' ]
  js: [ './app/assets/js/**' ]
  scss: ['./app/assets/css/**/*.scss'],
  images: './app/assets/img/**/*'
  build: './build/'

handleErrors = (args...) ->
  #require('gulp-notify').onError( title: "Compile Error",message: "<%= error.message %>" ).apply  @, args
  console.log( args ) and emit 'end'


gulp.task 'scripts', ->
  browserify
    entries: paths.entry,
    extensions:['.coffee']
  .bundle()
    .pipe source 'bundle.js'
    .pipe gulp.dest paths.build

gulp.task 'compass', ->
	gulp.src paths.scss
		.pipe compass
			config_file: './compass.rb',
			css: "./build/css",
			sass: './app/assets/css'
		.on('error', handleErrors)
		.pipe livereload()

gulp.task 'images', ->
  gulp.src paths.images
    .pipe imagemin optimizationLevel: 5
    .pipe gulp.dest 'build/img'

gulp.task 'watch', ->
	gulp.watch paths.js, ['scripts']
	gulp.watch paths.scss, ['compass']
	gulp.watch paths.images, ['images']
	livereload()


# called when you run `gulp` from cli
gulp.task 'default', ['scripts', 'compass', 'images', 'watch']
