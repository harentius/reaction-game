'use strict';

let gulp = require('gulp'),
    less = require('gulp-less'),
    coffee = require('gulp-coffee'),
    concat = require('gulp-concat'),
    rev = require('gulp-rev'),
    rename = require('gulp-rename'),
    revReplace = require('gulp-rev-replace')
;

gulp.task('less', function () {
    gulp.src('./css/**/*.less')
        .pipe(less())
        .pipe(concat('style.css'))
        .pipe(rev())
        .pipe(gulp.dest('./www/css/'))
        .pipe(rev.manifest('rev-manifest-css.json'))
        .pipe(gulp.dest('./build'))
    ;
});

gulp.task('coffee-lib', function () {
    gulp.src(['./js/**/*.coffee', '!./js/app/web.coffee'])
        .pipe(coffee())
        .pipe(concat('lib.js'))
        .pipe(rev())
        .pipe(gulp.dest('./www/js/'))
        .pipe(rev.manifest('rev-manifest-lib.json'))
        .pipe(gulp.dest('./build'))
    ;
});

gulp.task('coffee-app', function () {
    gulp.src('./js/app/web.coffee')
        .pipe(coffee())
        .pipe(concat('app.js'))
        .pipe(rev())
        .pipe(gulp.dest('./www/js/'))
        .pipe(rev.manifest('rev-manifest-app.json'))
        .pipe(gulp.dest('./build'))
    ;
});

gulp.task('template', ['coffee-lib', 'coffee-app', 'less'], function () {
    let manifest = gulp.src([
        './build/rev-manifest-app.json',
        './build/rev-manifest-lib.json',
        './build/rev-manifest-css.json'
    ]);

    return gulp.src('./index.html.dist')
        .pipe(revReplace({
            manifest: manifest,
            replaceInExtensions: ['.dist']
        }))
        .pipe(rename('index.html'))
        .pipe(gulp.dest('./www'))
    ;
});

gulp.task('default', ['coffee-lib', 'coffee-app', 'less', 'template']);
