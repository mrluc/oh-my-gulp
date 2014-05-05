gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
browserify = require 'browserify'
source     = require 'vinyl-source-stream'
livereload = require 'gulp-livereload'
compass    = require 'gulp-compass'
imagemin   = require 'gulp-imagemin'


paths =
  js_entry: [ './app/assets/js/app.coffee' ]
  js: [ './app/assets/js/**' ]
  css: ['./app/assets/css/**/*.scss'],
  images: './app/assets/img/**/*'

handleErrors = (args...) ->
  notify = require "gulp-notify"
  notify.onError(
    title: "Compile Error",
    message: "<%= error.message %>"
  ).apply( @, args )

  @emit( 'end' ) #Keep gulp from hanging on this task


# ### TASKS
#
gulp.task 'scripts', ->
  browserify( entries: paths.js_entry, extensions: ['.coffee'] )
    .bundle()
      .pipe source 'bundle.js'   # text stream -> 'fake' file
      .pipe gulp.dest './build/'

gulp.task 'compass', ->
	gulp.src paths.css
		.pipe compass(
			config_file: 'compass.rb',
			css: 'build',
			sass: 'src/sass'
		)
		.on('error', handleErrors)
		.pipe livereload()

gulp.task 'images', ->
 gulp.src paths.images
    .pipe imagemin optimizationLevel: 5
    .pipe gulp.dest 'build/img'

gulp.task 'watch', ->
	gulp.watch paths.js, ['scripts']
	gulp.watch paths.css, ['compass']
	gulp.watch paths.images, ['images']
	livereload()


# called when you run `gulp` from cli
gulp.task 'default', ['scripts', 'images', 'watch']
