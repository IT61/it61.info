// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_self
//= require bootstrap
//= require styx

//= require_tree ./lib
//= require events
//= require companies
//= require user_profiles
//= require common

window.initNamespaces = function(str) {
    var namespace, namespaceToUse, namespaces, _i, _len;
    if (!str) {
        str = 'It61';
    }
    if (str === 'It61') {
        namespaces = ['It61'];
    }
    else {
        namespaces = ('It61.' + str).split('.');
    }
    namespaceToUse = window;
    for (_i = 0, _len = namespaces.length; _i < _len; _i++) {
        namespace = namespaces[_i];
        if (!namespaceToUse[namespace]) {
            namespaceToUse[namespace] = {};
        }
        namespaceToUse = namespaceToUse[namespace];
    }
    return namespaceToUse;
};

initNamespaces();
