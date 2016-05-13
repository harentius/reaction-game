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

gulp.task('coffee', function () {
    gulp.src('./js/**/*.coffee')
        .pipe(coffee())
        .pipe(concat('client.js'))
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

var tasks = ['coffee', 'less'];

if (env === 'dev') {
    tasks.push('watch');
}

gulp.task('default', tasks);
