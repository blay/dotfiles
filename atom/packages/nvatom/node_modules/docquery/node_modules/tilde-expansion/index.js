var passwd = require('etc-passwd'),
    sep = require('path').sep;

module.exports = expand;

function expand(s, cb) {
  // Only expand under certain cases, see bash(1)
  if (!s) return cb(s);
  if (s.indexOf('~') !== 0
   || s.indexOf('"') !== -1
   || s.indexOf("'") !== -1
   || s.indexOf('\\') !== -1) return cb(s);

  var parts = s.split(sep),
      prefix = parts[0];

  // Check the prefix
  switch (prefix) {
    case '~':
      if (process.env.HOME === undefined) {
        passwd.getUser({'uid': process.getuid()}, function(err, user) {
          if (err) return cb(s);
          parts[0] = user.home;
          cb(parts.join(sep));
        });
      } else {
        parts[0] = process.env.HOME;
        cb(parts.join(sep));
      }
      break;
    case '~+':
      parts[0] = (process.env.PWD !== undefined) ? process.env.PWD : parts[0];
      cb(parts.join(sep));
      break;
    case '~-':
      parts[0] = (process.env.OLDPWD !== undefined) ? process.env.OLDPWD : parts[0];
      cb(parts.join(sep));
      break;
    default:
      var username = parts[0].substr(1);
      passwd.getUser({'username': username}, function(err, user) {
        if (err) return cb(s);
        parts[0] = user.home;
        cb(parts.join(sep));
      });
      break;
  }
}
