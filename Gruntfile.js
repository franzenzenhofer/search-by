module.exports = function(grunt) {

  js_to_watch = ['js/src/main.js']
  css_to_watch = ['css/src/main.css']
  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    concat: {
    options: {
      separator: ';'
    },
    js: {
      src: js_to_watch,
      dest: 'js/lib/main.js'
    },
    css: {
      src: css_to_watch,
      dest: 'css/lib/main.css'
    }
  },
    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      },
      js: {
        src: 'js/src/main.js',
        dest: 'js/lib/main.min.js'
      }
    },
htmlmin: {                                     // Task
    dist: {                                      // Target
      options: {                                 // Target options
        removeComments: true,
        collapseWhitespace: true
      },
      files: {                                   // Dictionary of files
        'html/min/index.html': 'html/src/index.html'
      }
    }
  },
  mincss: {
  compress: {
    files: {
      "css/lib/main.min.css": 'css/lib/main.css'
    }
  }
},
  watch: {
    js: {
      files: js_to_watch,
      tasks: ['concat', 'uglify']
    },
    css: {
      files: css_to_watch,
      tasks: ['concat', 'mincss']
    },
    html: {
      files: 'html/src/index.html',
      tasks: ['htmlmin']
    }
  }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-htmlmin');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-mincss');

  // Default task(s).
  grunt.registerTask('default', ['concat','uglify', 'htmlmin']);

};