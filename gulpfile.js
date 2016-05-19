var gulp = require('gulp'),
    less = require('gulp-less'),
    coffee = require('gulp-coffee'),
    concat = require('gulp-concat'),
    watch = require('gulp-watch'),
    batch = require('gulp-batch'),
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
        .pipe(gulp.dest('./public/css/'))
    ;
});

gulp.task('coffee-lib', function () {
    gulp.src(['./js/**/*.coffee', '!./js/app.coffee'])
        .pipe(coffee())
        .pipe(concat('lib.js'))
        .pipe(gulp.dest('./public/js/'))
    ;
});

gulp.task('coffee-app', function () {
    gulp.src('./js/app.coffee')
        .pipe(coffee())
        .pipe(concat('app.js'))
        .pipe(gulp.dest('./public/js/'))
    ;
});

gulp.task('coffee-spec', function () {
    gulp.src('./spec/**/*.coffee')
        .pipe(coffee())
        .pipe(concat('spec.js'))
        .pipe(gulp.dest('./public/js/'))
    ;
});

gulp.task('watch', function() {
    watch(['./js/*.coffee'], batch(function(events, cb) {
        gulp.start('default', cb);
    }));

    watch(['./css/**/*.less'], batch(function(events, cb) {
        gulp.start('default', cb);
    }));
});

var tasks = ['coffee-lib', 'coffee-app', 'less'];

if (env === 'dev') {
    tasks.push('watch');
    tasks.push('coffee-spec');
}

gulp.task('default', tasks);
