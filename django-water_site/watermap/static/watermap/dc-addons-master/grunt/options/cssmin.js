module.exports = {
    build: {
        files: [{
            expand: true,
            cwd: '<%= config.dist %>/',
            src: '**/*.css',
            dest: '<%= config.dist %>/',
            ext: '.min.css'
        }]
    }
};
