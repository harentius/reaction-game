'use strict';

let gulp = require('gulp'),
    hub = require('gulp-hub'),
    fs = require('fs'),
    argv = require('yargs').argv,
    less = require('gulp-less'),
    coffee = require('gulp-coffee'),
    concat = require('gulp-concat'),
    rename = require('gulp-rename'),
    nunjucks = require('gulp-nunjucks'),
    minify = require('gulp-minify'),
    cleanCSS = require('gulp-clean-css')
;

// Environment detecting
let env = argv.env || 'prod',
    confFile = 'build-config.json'
;

if (!fs.existsSync(confFile)) {
    throw `Config file ${confFile} not found`;
}

let config = JSON.parse(fs.readFileSync(confFile, 'utf8'));
let target = config.target;

if (!argv.env) {
    env = config.env;
}

gulp.task('less', function () {
    let resource = gulp.src('./css/**/*.less')
        .pipe(less())
        .pipe(concat('style.css'))
    ;

    if (env === 'prod') {
        resource = resource.pipe(cleanCSS())
    }

    resource.pipe(gulp.dest('./www/css/'))
});

gulp.task('coffee-lib', function () {
    let resource = gulp.src(['./js/common/**/*.coffee', '!./js/app/web.coffee'])
        .pipe(coffee())
        .pipe(concat('lib.js'))
    ;

    if (env === 'prod') {
        resource = resource.pipe(minify({
            noSource: true,
            ext: {
                min: '.js'
            }
        }))
    }

    resource.pipe(gulp.dest('./www/js/'));
});

gulp.task('coffee-app', function () {
    let resource = gulp.src('./js/app/web.coffee')
            .pipe(coffee())
            .pipe(concat('app.js'))
        ;

    if (env === 'prod') {
        resource = resource.pipe(minify({
            noSource: true,
            ext: {
                min: '.js'
            }
        }))
    }

    resource.pipe(gulp.dest('./www/js/'));
});

gulp.task('template', function () {
    return gulp.src(`./templates/index_${target}.html.nunj`)
        .pipe(nunjucks.compile({
            assetVersion: Math.random().toString(36).substr(2, 15),
            env: env,
        }))
        .pipe(rename('index.html'))
        .pipe(gulp.dest('./www'))
    ;
});

let tasks = ['coffee-lib', 'coffee-app', 'less', 'template'];

if (env === 'dev') {
    gulp.task('coffee-spec-common', function () {
        gulp.src('./spec/common.coffee')
            .pipe(coffee())
            .pipe(concat('spec-common.js'))
            .pipe(gulp.dest('./www/js/'))
        ;
    });

    gulp.task('coffee-spec', function () {
        gulp.src(['./spec/**/*.coffee', '!./spec/common.coffee'])
            .pipe(coffee())
            .pipe(concat('spec.js'))
            .pipe(gulp.dest('./www/js/'))
        ;
    });

    gulp.task('template-spec', function () {
        return gulp.src('./templates/tests.html.nunj')
            .pipe(nunjucks.compile({}))
            .pipe(rename('tests.html'))
            .pipe(gulp.dest('./www'))
        ;
    });

    gulp.task('watch', function() {
        gulp.watch(['./js/**/*.coffee', './spec/**/*.coffee', './css/**/*.less'], ['default']);
    });

    tasks.push('coffee-spec-common');
    tasks.push('coffee-spec');
    tasks.push('template-spec');
    tasks.push('watch');
}

gulp.task('default', tasks);
