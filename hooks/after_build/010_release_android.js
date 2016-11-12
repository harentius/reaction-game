#!/usr/bin/env node

var fs = require('fs');
var path = require('path');
var execSync = require('child_process').execSync;
var rootdir = process.argv[2];
var releaseAPKFile = rootdir + '/build/sequence-master.apk';
var apk = rootdir + '/platforms/android/build/outputs/apk/android-release-unsigned.apk';

if (
    process.env.CORDOVA_PLATFORMS.toLowerCase().indexOf('android') == -1
        ||
    process.env.CORDOVA_CMDLINE.toLowerCase().indexOf('--release') == -1
) {
    return;
}

if (fs.existsSync(releaseAPKFile)) {
    fs.unlink(releaseAPKFile);
}

execSync('jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -storepass foofoo -keystore ' + rootdir + '/sequence-master-mobileapps.keystore ' + apk + ' SequenceMastermobileapps');
execSync('mkdir -p ./build');
execSync('zipalign -v 4 ' + apk + ' ' + releaseAPKFile);
