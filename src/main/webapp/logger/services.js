'use strict';

angular.module('loggerApp')
  .factory('Level', function($resource) {
	return $resource('logger.jsp?_=/levels');
  })
  .factory('Logger', function($resource) {
	return $resource('logger.jsp?_=/loggers/:name');
  })
  .factory('Appender', function($resource) {
	  return $resource('logger.jsp?_=/appenders/:name');
  });