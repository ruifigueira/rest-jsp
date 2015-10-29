'use strict';

angular
  .module('loggerApp', [
    'ngResource',
    'ngRoute',
    'ui.bootstrap',
    'ngTagsInput'
  ])
  .config(function ($routeProvider) {
    $routeProvider
	  .when('/appenders', {
		templateUrl: 'views/appender-list.html',
		controller: 'AppenderListCtrl',
		controllerAs: 'controller'
	  })
      .when('/loggers', {
        templateUrl: 'views/logger-list.html',
        controller: 'LoggerListCtrl',
        controllerAs: 'controller'
      })
      .otherwise({
        redirectTo: '/loggers'
      });
  });