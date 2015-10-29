'use strict';

module.exports = function(grunt) {

    grunt.initConfig({

        rsync: {
            options: {
                args: ['-avz'],
                exclude: ['.git*', 'cache', 'log'],
                recursive: true
            },
            development: {
                options: {
                    src: 'src/main/webapp/*',
                    dest: '/opt/tomcat/webapps/sites/restjsp/',
                    host: 'root@lw94',
                    port: 22
                }
            }
        },

        watch: {
            development: {
                files: [
                'src/main/webapp/**/*'
                ],
                tasks: ['rsync:development']
            }
        }

    });

    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-rsync');

    grunt.registerTask('default', ['watch:development']);
};
