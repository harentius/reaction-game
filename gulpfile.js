var gulp = require('gulp'),
    less = require('gulp-less'),
    coffee = require('gulp-coffee'),
    concat = require('gulp-concat'),
    watch = require('gulp-watch'),
    batch = require('gulp-batch'),
    rev = require('gulp-rev'),
    revReplace = require('gulp-rev-replace'),
    fs = require('fs'),
    argv = require('yargs').argv
;

// Environment detecting
var env = argv.env || 'prod',
    envFile = '.env'
;

if (!argv.env && fs.existsSync(envFile)) {
    env = fs.readFileSync(envFile, 'utf8');
}

gulp.task('less', function () {
    gulp.src('./css/**/*.less')
        .pipe(less())
        .pipe(concat('style.css'))
        .pipe(rev())
        .pipe(gulp.dest('./public/css/'))
        .pipe(rev.manifest('rev-manifest-css.json'))
        .pipe(gulp.dest('./build'))
    ;
});

gulp.task('coffee-lib', function () {
    gulp.src(['./js/**/*.coffee', '!./js/app/web.coffee'])
        .pipe(coffee())
        .pipe(concat('lib.js'))
        .pipe(rev())
        .pipe(gulp.dest('./public/js/'))
        .pipe(rev.manifest('rev-manifest-lib.json'))
        .pipe(gulp.dest('./build'))
    ;
});

gulp.task('coffee-app', function () {
    gulp.src('./js/app/web.coffee')
        .pipe(coffee())
        .pipe(concat('app.js'))
        .pipe(rev())
        .pipe(gulp.dest('./public/js/'))
        .pipe(rev.manifest('rev-manifest-app.json'))
        .pipe(gulp.dest('./build'))
    ;
});

gulp.task('coffee-spec-common', function () {
    gulp.src('./spec/common.coffee')
        .pipe(coffee())
        .pipe(concat('spec-common.js'))
        .pipe(gulp.dest('./public/js/'))
    ;
});

gulp.task('coffee-spec', function () {
    gulp.src(['./spec/**/*.coffee', '!./spec/common.coffee'])
        .pipe(coffee())
        .pipe(concat('spec.js'))
        .pipe(gulp.dest('./public/js/'))
    ;
});

gulp.task('watch', function() {
    watch(['./js/**/*.coffee'], batch(function (events, cb) {
        gulp.start('default', cb);
    }));

    watch(['./spec/**/*.coffee'], batch(function (events, cb) {
        gulp.start('default', cb);
    }));

    watch(['./css/**/*.less'], batch(function (events, cb) {
        gulp.start('default', cb);
    }));
});

gulp.task('template', ['coffee-lib', 'coffee-app', 'less'], function () {
    var manifest = gulp.src([
        './build/rev-manifest-app.json',
        './build/rev-manifest-lib.json',
        './build/rev-manifest-css.json'
    ]);

    return gulp.src('./public/index.html')
        .pipe(revReplace({manifest: manifest}))
        .pipe(gulp.dest('./public'))
    ;
});

gulp.task('clean-assets', function () {
    gulp.src(['./public/css', './public/js'])
        .pipe(clean())
    ;
});

var tasks = ['coffee-lib', 'coffee-app', 'less', 'template'];

if (env === 'dev') {
    tasks.push('watch');
    tasks.push('coffee-spec-common');
    tasks.push('coffee-spec');
}

gulp.task('default', tasks);
