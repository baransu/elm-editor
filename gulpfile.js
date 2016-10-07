const gulp = require('gulp');
const sass = require('gulp-sass');
const clean = require('gulp-clean');
const bower = require('gulp-bower');
const autoprefix = require('gulp-autoprefixer');
const gulpSequesnce = require('gulp-sequence');

const config = {
  bowerDir: './bower_components',
  dest: './build',
  sassDir: './web/sass'
};

gulp.task('sass', function() {
  return gulp.src(config.sassDir + '/*.scss')
    .pipe(sass({
      outputStyle: 'compressed',
      includePaths: [
        config.sassDir,
        config.bowerDir + '/bootstrap-sass/assets/stylesheets',
        config.bowerDir + '/font-awesome/scss',
      ]
    }).on('error', sass.logError))
    .pipe(autoprefix('last 2 version'))
    .pipe(gulp.dest(config.dest + '/css'));
});

gulp.task('js', function() {
  return gulp.src(['./web/ports.js'])
    .pipe(gulp.dest(config.dest + '/js'));
});

gulp.task('html', function() {
  return gulp.src(['./web/index.html'])
    .pipe(gulp.dest(config.dest));
});

gulp.task('icons', function() {
  return gulp.src(config.bowerDir + '/fontsawesome/fonts/**.*')
    .pipe(gulp.dest(config.dest + '/fonts'));
});

gulp.task('bower', function() {
  return bower().pipe(gulp.dest(config.bowerDir));
});

gulp.task('clean', function () {
	return gulp.src([ config.dest ], {read: false})
		.pipe(clean());
});

gulp.task('default', gulpSequesnce([
  'clean',
  'bower'
], [
  'js',
  'icons',
  'html',
  'sass'
]));
