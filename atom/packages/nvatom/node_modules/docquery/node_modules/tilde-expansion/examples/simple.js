var tilde = require('../'),
    dirs = ['~root', '~/', '~fakeuser/'];

dirs.forEach(function(s) {
  tilde(s, function(expanded) {
    console.log('%s => %s', s, expanded);
  });
});
