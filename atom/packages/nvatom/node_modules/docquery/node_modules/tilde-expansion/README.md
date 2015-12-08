tilde-expansion
===============

Expand a ~ character to a users home directory like bash

Examples
--------

Given

``` js
var tilde = require('tilde-expansion');
```

You can do basic expansion

``` js
tilde('~root', function(s) {
  console.log(s);
});
```

yields

```
/root
```

or even simpler

``` js
tilde('~/', function(s) {
  console.log(s);
});
```

yields

```
/home/dave/
```

and get fancy with the PWD

``` js
tilde('~+', function(s) {
  console.log(s);
});
```

yields

```
/home/dave/dev
```

Notes
-----

- Any unrecognized expansions will result in the string being unchanged
- The node [etc-passwd](https://github.com/bahamas10/node-etc-passwd) module is
  used to determine the home directory of a user
- If the user is not found on the system, the expansion will remain unaltered
- The string must be unquoted for any expansion to take place (see bash(1))

Usage
-----

``` js
var tilde = require('tilde-expansion');
```

Installation
------------

    npm install tilde-expansion

Tests
-----

    npm test

License
-------

MIT License
