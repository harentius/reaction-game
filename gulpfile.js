'use strict';

let gulp = require('gulp'),
    hub = require('gulp-hub'),
    fs = require('fs'),
    argv = require('yargs').argv
;

// Environment detecting
let env = argv.env || 'prod',
    envFile = '.env'
;

if (!argv.env && fs.existsSync(envFile)) {
    env = fs.readFileSync(envFile, 'utf8');
}

hub([`./gulpfile.${env}.js`]);
