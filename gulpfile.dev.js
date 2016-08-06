'use strict';

let gulp = require('gulp'),
    less = require('gulp-less'),
    coffee = require('gulp-coffee'),
    concat = require('gulp-concat'),
    rename = require('gulp-rename')
;

gulp.task('less', function () {
    gulp.src('./css/**/*.less')
        .pipe(less())
        .pipe(concat('style.css'))
        .pipe(gulp.dest('./public/css/'))
    ;
});

gulp.task('coffee-lib', function () {
    gulp.src(['./js/**/*.coffee', '!./js/app/web.coffee'])
        .pipe(coffee())
        .pipe(concat('lib.js'))
        .pipe(gulp.dest('./public/js/'))
    ;
});

gulp.task('coffee-app', function () {
    gulp.src('./js/app/web.coffee')
        .pipe(coffee())
        .pipe(concat('app.js'))
        .pipe(gulp.dest('./public/js/'))
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

gulp.task('template', function () {
    return gulp.src('./public/index.html.dist')
        .pipe(rename('index.html'))
        .pipe(gulp.dest('./public'))
    ;
});

gulp.task('template-spec', function () {
    return gulp.src('./public/tests.html.dist')
        .pipe(rename('tests.html'))
        .pipe(gulp.dest('./public'))
    ;
});

gulp.task('watch', function() {
    gulp.watch(['./js/**/*.coffee', './spec/**/*.coffee', './css/**/*.less'], ['default']);
});

gulp.task(
    'default',
    ['coffee-lib', 'coffee-app', 'less', 'template', 'coffee-spec-common', 'coffee-spec', 'template-spec', 'watch']
);
