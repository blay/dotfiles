var tilde = require('../'),
    dirs = ['~-', '~+', '~root/some/other/dir', '~/.ssh', '~~'];

dirs.forEach(function(s) {
  tilde(s, function(expanded) {
    console.log('%s => %s', s, expanded);
  });
});
