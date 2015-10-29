'use strict';

angular.module('loggerApp')
  .controller('LoggerListCtrl', function (Logger, $modal) {
    var self = this;
    this.loggers = Logger.query();
    this.sortProperty = 'name'; 
    this.searchValue = '';
    
    this.editLogger = function(logger) {
	  var modalInstance = $modal.open({
	    templateUrl: 'views/logger-editor.html',
	    controller: 'LoggerEditorCtrl',
	    controllerAs: 'controller',
	    size: 'lg',
        resolve: {
        	logger: function () {
	        return logger;
	      }
	    }
	  });
	  modalInstance.result.then(function (logger) {
	    console.log("Logger saved:", logger);
	  });
	};
  })
  .controller('AppenderListCtrl', function (Appender) {
	var self = this;
	this.appenders = Appender.query();
	this.sortProperty = 'name'; 
	this.searchValue = '';
  })
  .controller('LoggerEditorCtrl', function (Logger, Level, Appender, $modalInstance, logger) {
    var self = this;
    this.levels = Level.query();
    this.appenders = Appender.query();
    this.loggerForm = angular.copy(logger);
    this.loggerForm.appenders = this.appenders
		.filter(function (a) { return logger.appenderNames === a.name });

    this.matchingAppenders = function (query) {
    	return self.appenders
    		.filter(function (a) { return a.name.indexOf(query) !== -1 });
    };
    
    this.save = function () {
      logger.name = self.loggerForm.name;
      logger.level = self.loggerForm.level;
      logger.appenderNames = self.loggerForm.appenders.map(function (a) { return a.name } );
      
      logger.$save();
      $modalInstance.close(logger);
    };

    this.cancel = function () {
      $modalInstance.dismiss('cancel');
    };
  });

